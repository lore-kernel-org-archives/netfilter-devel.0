Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72035C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 18:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3286D20748
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 18:55:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="hFXgGA34";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="wBMG+BaU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfKYSzp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 13:55:45 -0500
Received: from alln-iport-3.cisco.com ([173.37.142.90]:5151 "EHLO
        alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbfKYSzp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 13:55:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1474; q=dns/txt; s=iport;
  t=1574708144; x=1575917744;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=za9nADArU8Lf0kaOG4yfJZxOKrPfKNWzAncNM1t/bAE=;
  b=hFXgGA34qXAT2TejP3VM5r+lu2lhb5aPIDEKceGbrXweNGY1cEPImvxY
   /V1X173H+GWdgonywYYeK1OUoCwd8yynKtcroF13VTiQBD8vreLQiiFij
   m+9f4lTO4dbjT8kPMkZuYAntrG6V/fJF4/2xajt7O21xTmqoOxpynJ8dL
   E=;
X-IPAS-Result: =?us-ascii?q?A0ArAQBqItxd/5NdJa1lHAEBAQEBBwEBEQEEBAEBgWwFA?=
 =?us-ascii?q?QELAYFKKScFgUQgBAsqCoQhg0YDinBOmhWBLhSBEANUCQEBAQwBAS0CAQGEW?=
 =?us-ascii?q?YIXJDYHDgIDAQEBAwIDAgEBBAEBAQIBBQRthTcMhWsREQwBATgRASICJgIEM?=
 =?us-ascii?q?BUSBAE0gwCCRwMuAQKmeAKBOIhgdYEygn4BAQWFFhiCFwmBDigBhRqGexqBQ?=
 =?us-ascii?q?D+BOCCCHgEBhRyDJzKCLJAXnh8KgisDlVEbgj+Haos1hD6OSJoQAgQCBAUCD?=
 =?us-ascii?q?gEBBYFZATGBWHAVZQGCQVARFIZIgScBB4JEilN0gSiMFAGBDgEB?=
IronPort-PHdr: =?us-ascii?q?9a23=3ALWiHNhVoGXU0F8/fQ0WqVOJft/fV8LGuZFwc94?=
 =?us-ascii?q?YnhrRSc6+q45XlOgnF6O5wiEPSA9yJ8OpK3uzRta2oGXcN55qMqjgjSNRNTF?=
 =?us-ascii?q?dE7KdehAk8GIiAAEz/IuTtankhFslQSlJ//FmwMFNeH4D1YFiB6nA=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.69,128,1571702400"; 
   d="scan'208";a="388432339"
Received: from rcdn-core-11.cisco.com ([173.37.93.147])
  by alln-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 25 Nov 2019 18:55:43 +0000
Received: from XCH-RCD-008.cisco.com (xch-rcd-008.cisco.com [173.37.102.18])
        by rcdn-core-11.cisco.com (8.15.2/8.15.2) with ESMTPS id xAPIthRR013053
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 25 Nov 2019 18:55:43 GMT
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by XCH-RCD-008.cisco.com
 (173.37.102.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Nov
 2019 12:55:42 -0600
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-rcd-003.cisco.com
 (173.37.227.248) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Nov
 2019 12:55:41 -0600
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Nov 2019 12:55:41 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaEeERo0NXq27zaRUqYwfOat8G925L0DSegNlYqeN2boYcs4Hz6n25RcSu5vy0GPD551C8MnsgwPbWS7t7sWxYM9l5rguiOLsS4SU0j4a6cN0YwOqXbeV4NVUX9tfIeMHDsJEDR6YWdlT/v0ripd+e+wy2FXrZvhFyJ3F2XAOq+kmOB1k1+8n9z7g7QK7/PBCkfkibQ+wLMrb0U2qpspeJ6oVmNVdn3zNyA5MReY1rqjIBK/owhaT+LSuojTIVaBWvbzO1FRMgeHDWhA8Xojm0XZk3jmAWDFfHUyh0u0RlTozQnlri7NDDBdSjFBWknlL8sEFCjetL2qjXmZFoY0DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=za9nADArU8Lf0kaOG4yfJZxOKrPfKNWzAncNM1t/bAE=;
 b=kYZjo7m4RUizu54lXXr1VeSXL3QNcF5RuhgKt1YdLH4Y3989HTKoH3/2Q0bz5uuJgZYyroxzMR5sQAT1aodg/GjdQ//0svskYUGo7FAysFhT/bfgcfL5DgC9PFLP4JKmaqIltvczh/ti2HhypihzOqU+lXbJTFIyiq/UzVsCJY0PgEa2euImeRdpCh8EC64nLGpWY7dgg2h7U0QfGTUMP/Ui3TzFVuCb2K1sURAP6qx88XVL6+JsIrbaZT2PJod796F0ju4/1oNCyQMYJaxB/ncZ9ZbbhqUu8cN4tsoCSyKRC/Qguw7O5hGLnuJcVLKSR1VZsYx9dLSlvfk3ZDtZYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=za9nADArU8Lf0kaOG4yfJZxOKrPfKNWzAncNM1t/bAE=;
 b=wBMG+BaUIRCQaC8NCx7qNabCRqz1GsSvNjVuBAYLvEagjur0/T8rLZQuLCjfbSSqieV2A1Ze60v6nBTHI0P+DjaZrUFJistWNAIZbP9aWMOr7P+LKcbYiXj2kLnZFAee2yQp3WncrmbC+/epkOMCnnfBcIQ/NC0V3Ooh+L4Ok6M=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB3245.namprd11.prod.outlook.com (52.135.111.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Mon, 25 Nov 2019 18:55:41 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d%7]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 18:55:41 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLtsw==
Date:   Mon, 25 Nov 2019 18:55:41 +0000
Message-ID: <5248B312-60A9-48A7-B4CF-E00D1BDF1CD2@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.79]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0657c06a-67bb-4112-410f-08d771d9119d
x-ms-traffictypediagnostic: SN6PR11MB3245:
x-microsoft-antispam-prvs: <SN6PR11MB32450C356DA2E83A549BCC4AC44A0@SN6PR11MB3245.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(189003)(199004)(6486002)(6436002)(66066001)(102836004)(3846002)(6116002)(478600001)(305945005)(6506007)(316002)(7736002)(2616005)(14454004)(71200400001)(71190400001)(91956017)(26005)(76116006)(66476007)(186003)(66946007)(110136005)(33656002)(8936002)(2501003)(256004)(86362001)(5660300002)(58126008)(81166006)(25786009)(99286004)(81156014)(8676002)(4744005)(2906002)(36756003)(6512007)(64756008)(66556008)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3245;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SQ3OxFfGjLRJChra4kzn+44QRPgs9vNeyzzlo4pDxHQuhJF6KNnLa402iL19T7dZgdFkIhfpQfjb32jRlDLgFCTO6WICoxNr3CaQSWnZSCgMnp7uGMrUSQ2UykuvpiVnkBtB8I3f61ZmOeNcTnv48b7ZLLKpDXbvEW/bOLPJWLZ2wpWstsMumqpBReLL/Z1I+OqE0ebgI0jFO1S+BmkS8IIpvpHhHDl8VQfPk5B9aykJiZ24JcaFFRr8AhQh306rvrJnmtQvody9kTlLLb9BBSVxqvqiwd2YQJw0HVy0E3Kn9vk5FV5Pzn4FpxFN/SheOThI/WB2+C6RIsR9nKWgLzHyprJDV0Ph1pvUHIMeNkzEapws2URI8rfJNsUScymLoMMNGY8p+vbaCfFrkwSBZ5kX9ebACQUmILrPQB2VmDSER5Rs9k+6+heuhgIfkyOY
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <01F77B1B6DC062498ADF34AA717CF7EE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0657c06a-67bb-4112-410f-08d771d9119d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 18:55:41.2335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ykCqXhD8sI5McaPdugSWMTQqBpYDB9a00QvCE7Vk2OzlZ8q+3Y3t5aIGaKl7h2fC8wqoFboRc3gkLi0cuyKI/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3245
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.18, xch-rcd-008.cisco.com
X-Outbound-Node: rcdn-core-11.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8gUGFibG8sDQoNClBsZWFzZSBzZWUgYmVsb3cgIHRhYmxlL2NoYWluL3J1bGVzL3NldHMg
SSBwcm9ncmFtLCAgd2hlbiBJIHRyeSB0byBhZGQganVtcCBmcm9tIGlucHV0LW5ldCwgaW5wdXQt
bG9jYWwgdG8gc2VydmljZXMgIGl0IGZhaWxzIHdpdGggIiBPcGVyYXRpb24gbm90IHN1cHBvcnRl
ZCIgLCBJIHdvdWxkIGFwcHJlY2lhdGUgaWYgc29tZWJvZHkgY291bGQgaGVscCB0byB1bmRlcnN0
YW5kIHdoeToNCg0Kc3VkbyBuZnQgYWRkIHJ1bGUgaXB2NHRhYmxlIGlucHV0LW5ldCBqdW1wIHNl
cnZpY2VzDQpFcnJvcjogQ291bGQgbm90IHByb2Nlc3MgcnVsZTogT3BlcmF0aW9uIG5vdCBzdXBw
b3J0ZWQNCmFkZCBydWxlIGlwdjR0YWJsZSBpbnB1dC1uZXQganVtcCBzZXJ2aWNlcw0KXl5eXl5e
Xl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXg0KDQoNCnRhYmxlIGlwIGlwdjR0
YWJsZSB7DQoJc2V0IG5vLWVuZHBvaW50LXN2Yy1wb3J0cyB7DQoJCXR5cGUgaW5ldF9zZXJ2aWNl
DQoJCWVsZW1lbnRzID0geyA4MDgwLCA4OTg5IH0NCgl9DQoNCglzZXQgbm8tZW5kcG9pbnQtc3Zj
LWFkZHJzIHsNCgkJdHlwZSBpcHY0X2FkZHINCgkJZmxhZ3MgaW50ZXJ2YWwNCgkJZWxlbWVudHMg
PSB7IDEwLjEuMS4xLCAxMC4xLjEuMiB9DQoJfQ0KDQoJY2hhaW4gaW5wdXQtbmV0IHsNCgkJdHlw
ZSBuYXQgaG9vayBwcmVyb3V0aW5nIHByaW9yaXR5IGZpbHRlcjsgcG9saWN5IGFjY2VwdDsNCgl9
DQoNCgljaGFpbiBpbnB1dC1sb2NhbCB7DQoJCXR5cGUgbmF0IGhvb2sgb3V0cHV0IHByaW9yaXR5
IGZpbHRlcjsgcG9saWN5IGFjY2VwdDsNCgl9DQoNCgljaGFpbiBzZXJ2aWNlcyB7DQoJCWlwIGRh
ZGRyIEBuby1lbmRwb2ludC1zdmMtYWRkcnMgdGNwIGRwb3J0IEBuby1lbmRwb2ludC1zdmMtcG9y
dHMgcmVqZWN0IHdpdGggdGNwIHJlc2V0DQoJCWlwIGRhZGRyIEBuby1lbmRwb2ludC1zdmMtYWRk
cnMgdWRwIGRwb3J0IEBuby1lbmRwb2ludC1zdmMtcG9ydHMgcmVqZWN0IHdpdGggaWNtcCB0eXBl
IG5ldC11bnJlYWNoYWJsZQ0KCX0NCn0NCg0KVGhhbmsgeW91DQpTZXJndWVpDQoNCg==
