package com.example.restreminder;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private static final String CHANNEL_ID = "rest_reminder_channel";
    private static final String PREFS_NAME = "RestReminderPrefs";
    private static final String KEY_ENABLED = "reminder_enabled";
    private static final String KEY_INTERVAL = "reminder_interval";
    private static final String KEY_IS_PAUSED = "is_paused";
    private static final String KEY_START_TIME = "start_time";

    private Switch switchReminder;
    private EditText editTextInterval;
    private Button buttonSave;
    private Button buttonPause;
    private Button buttonResume;
    private TextView textViewStatus;
    private TextView textViewNextReminder;

    private SharedPreferences prefs;
    private ReminderScheduler scheduler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        scheduler = new ReminderScheduler(this);

        initializeViews();
        createNotificationChannel();
        loadSettings();
        setupListeners();

        if (prefs.getBoolean(KEY_ENABLED, false) && !prefs.getBoolean(KEY_IS_PAUSED, false)) {
            scheduler.scheduleReminder(getIntervalMinutes());
            updateStatus(true);
        } else if (prefs.getBoolean(KEY_ENABLED, false) && prefs.getBoolean(KEY_IS_PAUSED, false)) {
            updateStatus(false, true);
        } else {
            updateStatus(false);
        }
    }

    private void initializeViews() {
        switchReminder = findViewById(R.id.switchReminder);
        editTextInterval = findViewById(R.id.editTextInterval);
        buttonSave = findViewById(R.id.buttonSave);
        buttonPause = findViewById(R.id.buttonPause);
        buttonResume = findViewById(R.id.buttonResume);
        textViewStatus = findViewById(R.id.textViewStatus);
        textViewNextReminder = findViewById(R.id.textViewNextReminder);
    }

    private void createNotificationChannel() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            CharSequence name = "休息提醒";
            String description = "定时提醒用户休息";
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription(description);

            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    private void loadSettings() {
        boolean enabled = prefs.getBoolean(KEY_ENABLED, false);
        int interval = prefs.getInt(KEY_INTERVAL, 30);
        boolean isPaused = prefs.getBoolean(KEY_IS_PAUSED, false);

        switchReminder.setChecked(enabled);
        editTextInterval.setText(String.valueOf(interval));

        buttonPause.setEnabled(enabled && !isPaused);
        buttonResume.setEnabled(enabled && isPaused);
    }

    private void setupListeners() {
        buttonSave.setOnClickListener(v -> saveSettings());
        buttonPause.setOnClickListener(v -> pauseReminder());
        buttonResume.setOnClickListener(v -> resumeReminder());
    }

    private void saveSettings() {
        String intervalStr = editTextInterval.getText().toString();
        if (intervalStr.isEmpty()) {
            Toast.makeText(this, "请输入有效的时间间隔", Toast.LENGTH_SHORT).show();
            return;
        }

        try {
            int interval = Integer.parseInt(intervalStr);
            if (interval < 1 || interval > 1440) {
                Toast.makeText(this, "时间间隔必须在1-1440分钟之间", Toast.LENGTH_SHORT).show();
                return;
            }

            boolean enabled = switchReminder.isChecked();
            prefs.edit()
                    .putBoolean(KEY_ENABLED, enabled)
                    .putInt(KEY_INTERVAL, interval)
                    .putBoolean(KEY_IS_PAUSED, false)
                    .apply();

            if (enabled) {
                scheduler.scheduleReminder(interval);
                Toast.makeText(this, "提醒已开启，间隔" + interval + "分钟", Toast.LENGTH_SHORT).show();
                updateStatus(true);
            } else {
                scheduler.cancelReminder();
                Toast.makeText(this, "提醒已关闭", Toast.LENGTH_SHORT).show();
                updateStatus(false);
            }

            buttonPause.setEnabled(enabled);
            buttonResume.setEnabled(false);

        } catch (NumberFormatException e) {
            Toast.makeText(this, "请输入有效的数字", Toast.LENGTH_SHORT).show();
        }
    }

    private void pauseReminder() {
        scheduler.cancelReminder();
        prefs.edit().putBoolean(KEY_IS_PAUSED, true).apply();
        updateStatus(false, true);

        buttonPause.setEnabled(false);
        buttonResume.setEnabled(true);

        Toast.makeText(this, "提醒已暂停", Toast.LENGTH_SHORT).show();
    }

    private void resumeReminder() {
        int interval = getIntervalMinutes();
        scheduler.scheduleReminder(interval);
        prefs.edit().putBoolean(KEY_IS_PAUSED, false).apply();
        updateStatus(true);

        buttonPause.setEnabled(true);
        buttonResume.setEnabled(false);

        Toast.makeText(this, "提醒已恢复", Toast.LENGTH_SHORT).show();
    }

    private int getIntervalMinutes() {
        return prefs.getInt(KEY_INTERVAL, 30);
    }

    private void updateStatus(boolean isRunning) {
        updateStatus(isRunning, false);
    }

    private void updateStatus(boolean isRunning, boolean isPaused) {
        if (isRunning) {
            int interval = getIntervalMinutes();
            textViewStatus.setText("状态: 运行中");
            textViewStatus.setTextColor(getResources().getColor(android.R.color.holo_green_dark));
            textViewNextReminder.setText("下次提醒: " + interval + " 分钟后");
        } else if (isPaused) {
            textViewStatus.setText("状态: 已暂停");
            textViewStatus.setTextColor(getResources().getColor(android.R.color.holo_orange_dark));
            textViewNextReminder.setText("下次提醒: 已暂停");
        } else {
            textViewStatus.setText("状态: 已关闭");
            textViewStatus.setTextColor(getResources().getColor(android.R.color.holo_red_dark));
            textViewNextReminder.setText("下次提醒: 未设置");
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
}
