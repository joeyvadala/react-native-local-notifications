import {NativeModules} from 'react-native';

var RNLocalNotifications = {
  createNotification: function(id, text, datetime, sound, repeatType) {
        NativeModules.RNLocalNotifications.createNotification(id, text, datetime, sound, repeatType);
  },
  deleteNotification: function(id) {
        NativeModules.RNLocalNotifications.deleteNotification(id);
  },
  updateNotification: function(id, text, datetime, sound, repeatType) {
        NativeModules.RNLocalNotifications.updateNotification(id, text, datetime, sound, repeatType);
  },
};

export default RNLocalNotifications;
