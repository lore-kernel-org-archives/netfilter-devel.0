Return-Path: <SRS0=orVX=WS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C871C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 13:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C74B22CE3
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 13:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="f2U2bFvz";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="WF7cFZyZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731916AbfHVN5a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:57:30 -0400
Received: from rcdn-iport-1.cisco.com ([173.37.86.72]:52701 "EHLO
        rcdn-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730333AbfHVN5a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 09:57:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=634; q=dns/txt; s=iport;
  t=1566482248; x=1567691848;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=AiDg1T/upMDLGmRb5HlCpSwMzt62RDE3TbJ7bxXASLU=;
  b=f2U2bFvz5Nn5f3V2bG2Ys7MTCwRJJAgz49F2Crm3IneASI3B3X2odOHv
   LvpDAXw5s+b9qzzphFd1Evx2TcmaCjVrL1CVdluwV4Q5BWKeOL3mXfqBT
   Y0iRzAb22/EKNv9Keih1zFSQaSsp6fdRXlUzeVsN/Ifj3NtpDYhmEZqwW
   M=;
IronPort-PHdr: =?us-ascii?q?9a23=3Aeyr0HR9uWX6hgv9uRHGN82YQeigqvan1NQcJ65?=
 =?us-ascii?q?0hzqhDabmn44+8ZR7E/fs4iljPUM2b8P9Ch+fM+4HYEW0bqdfk0jgZdYBUER?=
 =?us-ascii?q?oMiMEYhQslVdWPBF/lIeTpRyc7B89FElRi+iLzPA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BzCgAsnl5d/4QNJK1kHQEBBQEHBQG?=
 =?us-ascii?q?BZ4FFUAOBQiAECyoKhBaDRwOKak2Bao9yiBmCUgNUCQEBAQwBAS0CAQGEWIJ?=
 =?us-ascii?q?IIzgTAgkBAQQBAQMBBgRthS0BC4VjEREMAQE4EQEiAiYCBDAVCggENYMAgWs?=
 =?us-ascii?q?DHQGfMAKBOIhhc4EygnsBAQWCR4JXGIIWCYEMKIR6hnUYgUA/gREnDBOKWTK?=
 =?us-ascii?q?CJoxKgk6cSAkCgh2GCI41G4IhAZYojV+YEwIEAgQFAg4BAQWBZyGBWHAVZQG?=
 =?us-ascii?q?CQYJCg3KKU3KBKYo+AYEgAQE?=
X-IronPort-AV: E=Sophos;i="5.64,416,1559520000"; 
   d="scan'208";a="617190973"
Received: from alln-core-10.cisco.com ([173.36.13.132])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 22 Aug 2019 13:57:27 +0000
Received: from XCH-ALN-019.cisco.com (xch-aln-019.cisco.com [173.36.7.29])
        by alln-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id x7MDvRq7007866
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL)
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2019 13:57:27 GMT
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by XCH-ALN-019.cisco.com
 (173.36.7.29) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 22 Aug
 2019 08:57:27 -0500
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-rtp-001.cisco.com
 (64.101.210.228) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 22 Aug
 2019 09:57:25 -0400
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 22 Aug 2019 08:57:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dv+qPYqWVAvVgTVvcSChxvoW1BTERtwqnG+RA7Angn8Kvyg++RpRdQX5ypIBXyI7PGixBkgNnRZA0c3TFN/6mL6qB8VTJDi+z2r04JfAK9neNC2hMSTz7u4MXerqLxZL61qKN844IZ7pGpKM9ahXp+2KplSkThb9Bfmd3UGh3qt9kB6/61ST6eVN7FpnsUpewRR9y9hZF4iWo8lIsdGB1nu+3sPBUPVuGYa9Msjc5qO2r9GseN8viMsNQuq9eXy0va2fxC8dTIQk4cJCokFW7g8jbTk7zGT/xFyz9e69ViaGCLcfA9G04czU/bDzhG3CLMsyAAlfNZGRMwzqu4QtTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AiDg1T/upMDLGmRb5HlCpSwMzt62RDE3TbJ7bxXASLU=;
 b=Wwv+pxkDhqnaMmgevu6/+NFntv7DbIF63bMEYz44HxDfez0vUUrhXqhdA+FcK4YbnWTebNx+92AgEr9Dr6E0x9T+mqY6C+UDWau+Y2t4bPfxTb0JcxJ84J1gf5XEKQGQJM9KWmlrzANfoTN/a2UOSGc1alyVkViPLbv13vLZGI+9EV1S0Gpozm5sLv1XBY7cfKelguQou/Vvjj6s2nYNrJLFqKQv+ul12PCmb34okspXR0j59qmEU8lILifiq5wjIkmnN6XJ9pzp6w/E5eN/wmXd7E/GdGxkVpzOk32N5oZSduO8jM1t0fpCrC4GZ5jO8AC3fQHeQXrLWHLfgh3wUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AiDg1T/upMDLGmRb5HlCpSwMzt62RDE3TbJ7bxXASLU=;
 b=WF7cFZyZH+GtK/IfFd/6svaFwYdisx11amsGoCY22cwzuiKW6eSYIgsy/MGeQrPqdA5kgDnfT0DJIZwpmH7LpEQi6HqQn2pZ/wUkpNtjX6QmkMnQtsMje9s9GtWbMn72QwBs25j1+UZOkbmXDEQqt/ki1HcITbo+Afz6sIjjcJE=
Received: from BN6PR11MB1460.namprd11.prod.outlook.com (10.172.21.136) by
 BN6PR11MB1971.namprd11.prod.outlook.com (10.175.97.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 13:57:24 +0000
Received: from BN6PR11MB1460.namprd11.prod.outlook.com
 ([fe80::531:1342:6daf:28d5]) by BN6PR11MB1460.namprd11.prod.outlook.com
 ([fe80::531:1342:6daf:28d5%11]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 13:57:24 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: nft equivalent of iptables command
Thread-Topic: nft equivalent of iptables command
Thread-Index: AQHVWPGGzbiV3UpkmEmnxgajwrqrkQ==
Date:   Thu, 22 Aug 2019 13:57:24 +0000
Message-ID: <69AAC254-AF78-4918-82B5-14B3EDB10EDB@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 256883d0-9a11-4e89-3807-08d72708a90e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN6PR11MB1971;
x-ms-traffictypediagnostic: BN6PR11MB1971:
x-microsoft-antispam-prvs: <BN6PR11MB1971E048422042F23BBAA546C4A50@BN6PR11MB1971.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(199004)(189003)(8676002)(66946007)(64756008)(81156014)(4744005)(14454004)(5660300002)(66476007)(66556008)(8936002)(3846002)(305945005)(186003)(256004)(6116002)(6512007)(66446008)(81166006)(53936002)(91956017)(2501003)(76116006)(2906002)(99286004)(7736002)(6506007)(36756003)(2351001)(33656002)(71190400001)(71200400001)(486006)(6916009)(25786009)(66066001)(102836004)(476003)(86362001)(6486002)(6436002)(2616005)(58126008)(5640700003)(26005)(316002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1971;H:BN6PR11MB1460.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nfigw9uKpYfyiw1QTG/FSvMpBqnM28aV0kG5+UfJyUXVN52b5Tj2LKXngsWLPHlDgmIy6BbazAqIKC3rFWExzosPkRzb/GRcdaYtw904cPgTZsXv417UW5i4RBt/9nRjqigKkvuzVeWR5U/MXrvCaW0e90Gi4V4DJXB2tukyKMrIW7Js9AthflTz9o8NBL+d7PtMvnIWA79XRu8QVV3LLCIy2qB9O/0R5mrXmVSNMgQ70F50rCfgjpUPdzUbuIAPLQFPQPt7awVaLCNZxqywjEqh+SHgJOjf0GaIYjCTCunTulRCAFCat0xaA/TRvhlBBp2Vg6fv4d3inqhH64dzap/Xn1QO2fmEVKK+c7HfqTljVoqdTKaz9AIjkpNC4LrZpuDSxoQ89adpq8AB9K5psjC7pznyg1c8I1wvv5rDCuI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DCC5576A1337A4CA8688044D0675F82@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 256883d0-9a11-4e89-3807-08d72708a90e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 13:57:24.4687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BSUtTokXRYSVChKlsX1WVMOumwfnWObmU+7vfb/iCmH40eoQl+RzaFTQN2t6tFFlTyIp/tTzRsJgt88IKGRSfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1971
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.29, xch-aln-019.cisco.com
X-Outbound-Node: alln-core-10.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8sDQoNCkkgYW0gdHJ5aW5nIHRvIGZpbmQgYW4gZXF1aXZhbGVudCBuZnQgY29tbWFuZCBm
b3IgdGhlIGZvbGxvd2luZyBpcHRhYmxlcyBjb21tYW5kLiAgU3BlY2lmaWNhbGx5ICJwaHlzZGV2
IiBhbmQgImFkZHJ0eXBlIiwgSSBjb3VsZCBub3QgZmluZCBzbyBmYXIsIHNvbWUgaGVscCB3b3Vs
ZCBiZSB2ZXJ5IGFwcHJlY2lhdGVkLg0KDQotQSBLVUJFLVNFUlZJQ0VTIA0KLW0gY29tbWVudCAt
LWNvbW1lbnQgImRlZmF1bHQvcG9ydGFsOnBvcnRhbCBleHRlcm5hbCBJUCIgDQotbSB0Y3AgDQot
cCB0Y3AgDQotZCAxOTIuMTY4LjgwLjEwNC8zMiANCi0tZHBvcnQgODk4OSANCi1tIHBoeXNkZXYg
ISAtLXBoeXNkZXYtaXMtaW4gICAgICAgICAgICAgDQotbSBhZGRydHlwZSAhIC0tc3JjLXR5cGUg
TE9DQUwgDQotaiBLVUJFLVNWQy1NVVBYUFZLNFhBWkhTV0FSDQoNClRoYW5rIHlvdQ0KU2VyZ3Vl
aQ0KDQo=
