import { NativeModules, NativeEventEmitter } from 'react-native';

const RNEventEmitter = new NativeEventEmitter(NativeModules.RNLocalNotifications);

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
  getEventEmitter: function() {
    return RNEventEmitter;
  }
};

export default RNLocalNotifications;
