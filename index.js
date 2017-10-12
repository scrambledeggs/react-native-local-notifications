import {NativeModules} from 'react-native';

var RNLocalNotifications = {
  createNotification: function(id, text, datetime, sound, data) {
        NativeModules.RNLocalNotifications.createNotification(id, text, datetime, sound, data);
  },
  deleteNotification: function(id) {
        NativeModules.RNLocalNotifications.deleteNotification(id);
  },
  updateNotification: function(id, text, datetime, sound, data) {
        NativeModules.RNLocalNotifications.updateNotification(id, text, datetime, sound, data);
  },
};

export default RNLocalNotifications;
