/*! Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: MIT-0

  Welcome Workshopper!
  This is the application configuration file.

  This is the ONLY file you need to modify in the front-end application.
  Each section is separated by MODULE # for you to modify.
*/

export const appConfig = {
  initStateAPI: 'https://glkvjnngck.execute-api.us-east-2.amazonaws.com/Prod/InitState/', // e.g. https://12abcdef89.execute-api.us-west-2.amazonaws.com/Prod/InitState/
  iot: {
    poolId: 'us-east-2:adebd190-8590-47e7-9c0b-15ff289e50d6', // e.g. 'us-west-2:1abcdef-1234-abcd-1234-abcde123456'
    host: 'a1c4z5dui0bt0v-ats.iot.us-east-2.amazonaws.com', // e.g. 'ab12ab12abcde.iot.us-east-1.amazonaws.com'
    region: 'us-east-2' // e.g. 'us-west-1'
  },
  photoUploadURL: 'https://glkvjnngck.execute-api.us-east-2.amazonaws.com/Prod/Upload', // e.g. https://12abcdfg89.execute-api.us-west-2.amazonaws.com/Prod/Upload
  //
  // Don't modify anything below this comment!
  //
  images: {
    parkMapURL: 'https://d15l97sovqpx31.cloudfront.net/images/theme-park-map-large.jpg',
    logoURL: 'https://d15l97sovqpx31.cloudfront.net/images/theme-park-logo-150.png'
  },
  icons: {
    restroom: 'https://d15l97sovqpx31.cloudfront.net/icons/icon-restroom.png',
    dining: 'https://d15l97sovqpx31.cloudfront.net/icons/icon-dining.png',
    atm: 'https://d15l97sovqpx31.cloudfront.net/icons/icon-atm.png'
  }
}
