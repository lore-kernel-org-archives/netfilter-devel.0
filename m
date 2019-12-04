Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74781C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 00:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3505620675
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 00:54:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="ml1B/w8H";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="N2Fbefa8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfLDAyM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 19:54:12 -0500
Received: from alln-iport-2.cisco.com ([173.37.142.89]:57053 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfLDAyM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 19:54:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1290; q=dns/txt; s=iport;
  t=1575420850; x=1576630450;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=QFYDSpJrmTZmW72uDYfgiAg2B5KgUpHly0YdkAX7Eu0=;
  b=ml1B/w8HkZh1C5DUu5/0zj5uvEf/yEz+G97FsPMVKN2bVjWI+72CjUUu
   nVk92wYa4/OpleHW9ZBlKvjkL1IPdYHwWxllH6Fk3fJBLCzEOzXeYLMB/
   fGrHKLOcBPfe3cAvVjrb5oH6sIA7Qi5err9IO13dwx2mRqsb9NTG934sR
   o=;
IronPort-PHdr: =?us-ascii?q?9a23=3A84U+EBGu26yo3LFRyvqMZ51GYnJ96bzpIg4Y7I?=
 =?us-ascii?q?YmgLtSc6Oluo7vJ1Hb+e4z1Q3SRYuO7fVChqKWqK3mVWEaqbe5+HEZON0pNV?=
 =?us-ascii?q?cejNkO2QkpAcqLE0r+eeXgYj4kEd5BfFRk5Hq8d0NSHZW2ag=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BvAADDAudd/5NdJa1lHQEBAQkBEQU?=
 =?us-ascii?q?FAYFqCAELAYFKUAWBRCAECyoKhCGDRgOEWoYemmOBLoEkA1QJAQEBDAEBLQI?=
 =?us-ascii?q?BAYRAGYF2JDQJDgIDDQEBBAEBAQIBBQRthTcBC4VVFhERDAEBNwERASICJgI?=
 =?us-ascii?q?EMBUSBA4ngwCCRwMuAaZaAoE4iGB1gTKCfgEBBYJKgjsYghcJgQ4oAYUahns?=
 =?us-ascii?q?agUE/gTgggh8BiEOCXo07gmOeKQqCLgOGN48fFAeCQYduj3WOSoFDmFoCBAI?=
 =?us-ascii?q?EBQIOAQEFgVI5gVhwFWUBgkFQERSMZoNzilN0gSiPRwGBDwEB?=
X-IronPort-AV: E=Sophos;i="5.69,275,1571702400"; 
   d="scan'208";a="386516806"
Received: from rcdn-core-11.cisco.com ([173.37.93.147])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 04 Dec 2019 00:54:10 +0000
Received: from XCH-ALN-014.cisco.com (xch-aln-014.cisco.com [173.36.7.24])
        by rcdn-core-11.cisco.com (8.15.2/8.15.2) with ESMTPS id xB40sAuh024283
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 4 Dec 2019 00:54:10 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-ALN-014.cisco.com
 (173.36.7.24) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Dec
 2019 18:54:09 -0600
Received: from xhs-aln-002.cisco.com (173.37.135.119) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Dec
 2019 19:54:08 -0500
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-002.cisco.com (173.37.135.119) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 3 Dec 2019 18:54:08 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XK2Qx7rHi4Ps7p0rWgRJHwOaZOnJmoUydSwFCuLt/hLbskBmG/Uexcm/2Thbm6TtciC63NJ+5cyewDc3atwBWH+CuChdBv34ZMNIYkevDtAKQPheLZtZaL33xmCvzMoFOOWBgZMvq/UXW3bcDYiyWb051NabEJJ75z5sLLfMcU0LaTFI2SOZE29UhSg3we5W6BIfizIsAZPe4g/bhD799j1HIKXRnxb8Wr6x65Bcrp2rl+eHoE1K0ijJb4ZhNJY4rY8SIa9sMH75VKkw02ClAKpZaI8BuRVdyu4250GbJ5EFAqnjq92f1RgIXIFZpcaGzjMl9jINR7ITBhZAXjGdSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFYDSpJrmTZmW72uDYfgiAg2B5KgUpHly0YdkAX7Eu0=;
 b=nnXSJTGFQpDFhnLjdA+Q3P6qo3I+vzGXzr/D7EG2OHYLjmqcCHrnH6ukmmCZd7+5JKM3zt5iAyTZEUBqStYeGnGRsClQWA0gWGeZ0fF4kYN+PJMzWdg6f1cYt9t/p+p8dw/mx0tbEFjrQZOo6pi5AxxIxQI6oT6zBF9OyHtpdxw3HXkqvFZLMehOaQQIlUjgnW/4ZnMKAnIK61SVtTgM7T46uBebs+dceFLXhztEzXGHPyjwFgt93nUwxScaJa17hH/b610quyk9sziYN9EpiSkmFgXbx/j1to5tjy3PPql2IzZdxA8+c5htC57UHNuRN3o0K7eq5yVwD+Rlwr0p3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFYDSpJrmTZmW72uDYfgiAg2B5KgUpHly0YdkAX7Eu0=;
 b=N2Fbefa819gQaYAIvhXCK+Xww+G70hrnfhRn7JADOiOA7H1+QCwMe1i/nraG2UOLZntX9+cH1eO0y9J8nCXdyXXhf7oGb8+LVUd3/whkUHqYkEde9XZTyDLoAkRsPavwwe4bPtA+m62Vt9LmeDZXSuGd204zFrRwYMWMHVh72Kg=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB2044.namprd11.prod.outlook.com (10.168.106.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Wed, 4 Dec 2019 00:54:06 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a%10]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 00:54:05 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC:     Phil Sutter <phil@nwl.cc>
Subject: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezg==
Date:   Wed, 4 Dec 2019 00:54:05 +0000
Message-ID: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1727967-c12e-469d-0106-08d77854769a
x-ms-traffictypediagnostic: DM5PR11MB2044:
x-microsoft-antispam-prvs: <DM5PR11MB20449948100DA4847F64A10DC45D0@DM5PR11MB2044.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(189003)(199004)(36756003)(71200400001)(316002)(71190400001)(99286004)(14454004)(64756008)(58126008)(4744005)(478600001)(33656002)(66556008)(86362001)(4326008)(66446008)(14444005)(256004)(8936002)(66476007)(2616005)(6512007)(6436002)(5640700003)(6486002)(5660300002)(305945005)(2501003)(26005)(2351001)(6116002)(7736002)(76116006)(81166006)(25786009)(3846002)(91956017)(8676002)(186003)(6506007)(102836004)(6916009)(2906002)(66946007)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB2044;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tMvYw4dARltTYpCwimuZDanicASvw6zPBbYiN5y897OuBxNSw5gbCNQkCPcu+04NXAuuySaqVY9+try0bzEkPWz+C35b7iDt/0HYR4kk+OKx+MOfLRYAybnjCgOQaNeUpndb6af65Y6N+AYNv0QnlB1MVVXTBeOf3u3Yg3Byf2NaLFIoYIUef/kIT9DqpqXoZ4CFmtoe74zwWbtgR8cW+7OUoMpJAlZPyVpidnkh/5tg7B3vKSctqNmjIQ1m9Y45IlRghx3QokgkL6fX4ZIqsGCG2hU8Y5ZlLPnWl6VkpzMMkrEaKZybFKIn5qFbuFE/kpfleo4oVOLC20eLQxO6W8sgsLFZJFceikG6lZCbJPdQYmwDNoGOovUsBOgmm+JY5JFe9/sU9KjDl7LFj2d7CmMSKw4xjZEg7SE+XAvGjk2z4JySEqcRXaHiwQK/RgmY
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA802E8A2E24C8459C9DDAF3360401A7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d1727967-c12e-469d-0106-08d77854769a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 00:54:05.7575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hod/9maxMr05l6yxo31Sk1GgHUE/N07+dpXj99IuebRcprXSZ6TYMX4JlJVZ/vBnOqA1oKieg6f4RG9+XdZ14A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2044
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.24, xch-aln-014.cisco.com
X-Outbound-Node: rcdn-core-11.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8sDQoNCk5mdGFibGVzIHdpa2kgZ2l2ZXMgdGhpcyBleGFtcGxlIGZvciBudW1nZW46DQoN
Cm5mdCBhZGQgcnVsZSBuYXQgcHJlcm91dGluZyBudW1nZW4gcmFuZG9tIG1vZCAyIHZtYXAgeyAw
IDoganVtcCBteWNoYWluMSwgMSA6IGp1bXAgbXljaGFpbjIgfQ0KDQpJIHdvdWxkIGxpa2UgdG8g
dXNlIGl0IGJ1dCB3aXRoIG1hcCByZWZlcmVuY2UsIGxpa2UgdGhpczoNCg0KbmZ0IGFkZCBydWxl
IG5hdCBwcmVyb3V0aW5nIG51bWdlbiByYW5kb20gbW9kIDIgdm1hcCBAc2VydmljZTEtZW5kcG9p
bnRzDQoNCkNvdWxkIHlvdSBwbGVhc2UgY29uZmlybSBpZiBpdCBpcyBzdXBwb3J0ZWQ/IElmIGl0
IGlzIHdoYXQgd291bGQgYmUgdGhlIHR5cGUgb2YgdGhlIGtleSBpbiBzdWNoIG1hcD8gSSB0aG91
Z2h0IGl0IHdvdWxkIGJlIGludGVnZXIsIGJ1dCBjb21tYW5kIGZhaWxzLg0KDQpzdWRvIG5mdCAt
LWRlYnVnIGFsbCBhZGQgbWFwIGlwdjR0YWJsZSBrOHMtNTdYVk9DRk5UTFRSM1EyNy1lbmRwb2lu
dHMgICB7IHR5cGUgIGludGVnZXIgOiB2ZXJkaWN0IFw7IH0NCkVycm9yOiB1bnF1YWxpZmllZCBr
ZXkgdHlwZSBpbnRlZ2VyIHNwZWNpZmllZCBpbiBtYXAgZGVmaW5pdGlvbg0KYWRkIG1hcCBpcHY0
dGFibGUgazhzLTU3WFZPQ0ZOVExUUjNRMjctZW5kcG9pbnRzIHsgdHlwZSBpbnRlZ2VyIDogdmVy
ZGljdCA7IH0NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBeXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXg0KDQpUaGUgdWx0aW1hdGUgIGdvYWwgaXMgdG8g
dXBkYXRlIGR5bmFtaWNhbGx5IGp1c3QgdGhlICBtYXAgIHdpdGggYXZhaWxhYmxlIGVuZHBvaW50
cyBhbmQgbG9hZGJhbGFuY2UgYmV0d2VlbiB0aGVtIHdpdGhvdXQgIHRvdWNoaW5nIHRoZSBydWxl
Lg0KDQpUaGFuayB5b3UNClNlcmd1ZWkgDQoNCg==
