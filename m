Return-Path: <SRS0=BYf1=4P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37239C11D3D
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Feb 2020 16:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D09A024697
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Feb 2020 16:21:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="GV/myvps";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="YVbpxGpV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbgB0QVp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 11:21:45 -0500
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:64819 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729968AbgB0QVp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 11:21:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=896; q=dns/txt; s=iport;
  t=1582820503; x=1584030103;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=kHS4SPa04qyQQpnbsyTCoz7D+YX+CU8CFqgTRghJPMo=;
  b=GV/myvpsNpD9+3Pr5gadRuQNDkCyVr3jFFVdy2QZSMevZu1s4ov92CJK
   Kd69fFy0wXotXbhsXDh/eiUtOTZxKzQ1PP49tkI6qAUdTVLiW9HM7cxaE
   jJUAHwlt6w+QVwzEG8fHdCAGgdwY6/scSA4xuKlWnoOy995FgVxo0H7tB
   A=;
IronPort-PHdr: =?us-ascii?q?9a23=3AJggkIBQ0CtJvowfGIdQKmGoPINpsv++ubAcI9p?=
 =?us-ascii?q?oqja5Pea2//pPkeVbS/uhpkESXBNfA8/wRje3QvuigQmEG7Zub+FE6OJ1XH1?=
 =?us-ascii?q?5g640NmhA4RsuMCEn1NvnvOjcwEdZcWUVm13q6KkNSXs35Yg6arw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0ADCAAN7Fde/4sNJK1mHgELHIFwC4F?=
 =?us-ascii?q?UUAWBRCAECyoKhAqDRgOKZ5pzgS6BJANUCQEBAQwBAS0CBAEBhEAZgXEkNgc?=
 =?us-ascii?q?OAgMNAQEFAQEBAgEFBG2FNwyFZhYREQwBATcBEQEiAiYCBDAVEgQBDSeDBIJ?=
 =?us-ascii?q?LAy4BpG4CgTmIYnWBMoJ/AQEFgkSCSBiCDAmBDiqFIAyGeRqBQT+BOCCKZjK?=
 =?us-ascii?q?CLI15gmyfNQqCPIZnj34cgjmYdY5wm0cCBAIEBQIOAQEFgVkKKIFYcBVlAYJ?=
 =?us-ascii?q?BUBgNjh2Dc4pVdIEpjHoBgQ8BAQ?=
X-IronPort-AV: E=Sophos;i="5.70,492,1574121600"; 
   d="scan'208";a="732153909"
Received: from alln-core-6.cisco.com ([173.36.13.139])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 27 Feb 2020 16:21:42 +0000
Received: from XCH-RCD-003.cisco.com (xch-rcd-003.cisco.com [173.37.102.13])
        by alln-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id 01RGLgAo004118
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 27 Feb 2020 16:21:42 GMT
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by XCH-RCD-003.cisco.com
 (173.37.102.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Feb
 2020 10:21:41 -0600
Received: from xhs-aln-002.cisco.com (173.37.135.119) by xhs-rcd-001.cisco.com
 (173.37.227.246) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Feb
 2020 10:21:41 -0600
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-002.cisco.com (173.37.135.119) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 27 Feb 2020 10:21:41 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Izif1Z6j3m7PJ0IEJLBhoWfJkprXi3oMIhx8HUY8QUXeKgq0Il69ZL7nK/JLWrb1I27KnSMu/tbE1aBDR3FdIGdCpKcA+Je6lQ+Tqs6QM+xmHP/SmkF+mNnQa3kJK8q1UP9OeTrIhY5iaCnbtMXyHL14Uyjb+MZktC7VXlWsWmTQ1PAmf7sJFh2AYFV8uUIRzJKvdCqkjdXHXo5Gw9XMRJjeOusbuCEg01e5liPtH4ty9Sey7Cjett9b5nnYpxqAkF2HHi1kYNUt+arRutLgJOLlmbd/CH1eTCcUvAiOXwgF396o/ru+DXNVNvck9fyXlR3lZLIh1tTVbbSKDvQhIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHS4SPa04qyQQpnbsyTCoz7D+YX+CU8CFqgTRghJPMo=;
 b=T+2vVheQKmQ6SIB3mrmg8KauTTlEpFpbJMFbmGrzBYw8hKtlOfbFhWb22jd34MwdlairZ+sDlbmbXQzV0LsD9XEGf1F7ecUSIs3neeJzLUgTPeH+qperbsxldWo5CjkFEUOW7O4331z+c6hLnJ7QMSWp0Jjxbt3esSQNNUyovwgQLSu+c8mDQdVMVW/nzb7QhYkKD1zMhg7jYG8K0yQiaC8RHQmswxMHs2ZJxYGDONwssr07JD8VszqDs9NCpLQ2gwUNLPhUrd188AULnkajn4/ef30Q8hhT86TMLnZGie1IWdgoiX7UF+EmhYpkNH3Uxhfso7RdgQgnZRpHZ75eVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHS4SPa04qyQQpnbsyTCoz7D+YX+CU8CFqgTRghJPMo=;
 b=YVbpxGpVJ0L9CXk2x8rWDyF8Ss+/Rqm372NL+jGur6KJllzifm4hUUPOYkMF60cdguYO95CRrJIyrv6GsmKO48dqJ06UmFVLTtw3ymhiQcwVizRtfBpU4NfuE6KL6lbGajJhxXsu6Z1Qvf7Xx6vTdoD67vOXA+6X8Dbi347lf/8=
Received: from MN2PR11MB3598.namprd11.prod.outlook.com (2603:10b6:208:f0::28)
 by MN2PR11MB4320.namprd11.prod.outlook.com (2603:10b6:208:195::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Thu, 27 Feb
 2020 16:21:40 +0000
Received: from MN2PR11MB3598.namprd11.prod.outlook.com
 ([fe80::ccd9:1946:3cb2:d495]) by MN2PR11MB3598.namprd11.prod.outlook.com
 ([fe80::ccd9:1946:3cb2:d495%2]) with mapi id 15.20.2750.021; Thu, 27 Feb 2020
 16:21:40 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Ipv6 address in concatenation 
Thread-Topic: Ipv6 address in concatenation 
Thread-Index: AQHV7Yn9ikf1UKam/UKNuCgsdX0Y1Q==
Date:   Thu, 27 Feb 2020 16:21:40 +0000
Message-ID: <54A7EDF2-F83D-44D7-994C-2C8E35E586AD@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.22.0.200209
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca2f89fe-0b64-4164-5d5c-08d7bba12090
x-ms-traffictypediagnostic: MN2PR11MB4320:
x-microsoft-antispam-prvs: <MN2PR11MB4320FBCA4FA9CF7AE5275F6BC4EB0@MN2PR11MB4320.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03264AEA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(189003)(199004)(76116006)(86362001)(36756003)(4744005)(186003)(66476007)(8936002)(6512007)(110136005)(66946007)(5660300002)(26005)(81166006)(81156014)(8676002)(6486002)(71200400001)(478600001)(316002)(2616005)(2906002)(4743002)(33656002)(64756008)(66446008)(6506007)(66556008)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4320;H:MN2PR11MB3598.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KCmS8uGEw1EuAGkUV1vi8AIKunlp0Pvmydp3AvpaY6AMeGokniHFmGMe2NajfR4jd1BmhJh/efc3+rQ0t8RG3Stupdz2zn3AjJdljPrz3v8tEh4TDssg/fYkgSC5NnYJe0iiKaFJpvEOs+KuuI1C5izhZF2UHLGvgM/HBagUp/byriCPJm2LuIpatDPysCTR6walNj3au4f91HUiUmuVmH9u9bKJHyH+E0OnCYo+Dk1pNPQOgn8zcjSletLRQIDief/OMdTZaxMN0vX2UNivasIuJZdueRfL8BH4HW2NBKLFnJP+oIZ9z3gV2OJEQXDqpIyWWdjDW0DRPAqp7jF8jXh2RWT8/D/ADZHS9jl6b3l+5YTLi7Jb1WzTI8/nHOqGCHc+4ghAXbeMW7mOe2IUSNd85MuVcaCAPuBb3JUlXIUxAkWNwFQedJCtRnB+ooaZ
x-ms-exchange-antispam-messagedata: H9IPewkBj+4dz+bhGv5W0CgNhQ7EyasCWbOPsYp/SJ6yhKVKuvFT8OabDGwlROeL5JurridRYuu2vtnJh3XyoglDjvDaTbm7uYVbqFqwznx4Gw0+xv5Hly70vijsZ2URdvz5FiaG2abPB34TOXHeGw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C416324ADAC02745877846F71C119490@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ca2f89fe-0b64-4164-5d5c-08d7bba12090
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2020 16:21:40.5146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z2m73f/+X7ZjeAXRDCUpPVr31+d/qq1MmRIFuiYI1epwZNNxkNy7GBDTGtFMgAd1VNqmfH53N2t06cMHVBZUSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4320
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.13, xch-rcd-003.cisco.com
X-Outbound-Node: alln-core-6.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8sDQoNCkkgc3RhcnRlZCB0ZXN0aW5nICBuZnByb3h5IGluIGlwdjYgZW5hYmxlZCBrdWJl
cm5ldGVzIGNsdXN0ZXIgYW5kIGl0IHNlZW1zIGlwdjYgYWRkcmVzcyBjYW5ub3QgYmUgYSBwYXJ0
IG9mIGNvbmNhdGVuYXRpb24gZXhwcmVzc2lvbi4gSXMgdGhlcmUgYSBrbm93biBpc3N1ZSBvciBp
dCBpcyBtZSBkb2luZyBzb21ldGhpbmcgaW5jb3JyZWN0Pw0KRnJvbSBteSBzaWRlIHRoZSBjb2Rl
IGlzIHRoZSBzYW1lLCBJIGp1c3QgY2hhbmdlIGlwNF9hZGRyIHRvIGlwNl9hZGRyIHdoZW4gSSBi
dWlsZCBzZXRzLg0KDQogICAgICAgIG1hcCBuby1lbmRwb2ludHMgew0KICAgICAgICAgICAgICAg
IHR5cGUgaW5ldF9wcm90byAuIGlwdjZfYWRkciAuIGluZXRfc2VydmljZSA6IHZlcmRpY3QNCiAg
ICAgICAgfQ0KDQogICAgICAgIG1hcCBkby1tYXJrLW1hc3Egew0KICAgICAgICAgICAgICAgIHR5
cGUgaW5ldF9wcm90byAuIGlwdjZfYWRkciAuIGluZXRfc2VydmljZSA6IHZlcmRpY3QNCiAgICAg
ICAgfQ0KDQogICAgICAgIG1hcCBjbHVzdGVyLWlwIHsNCiAgICAgICAgICAgICAgICB0eXBlIGlu
ZXRfcHJvdG8gLiBpcHY2X2FkZHIgLiBpbmV0X3NlcnZpY2UgOiB2ZXJkaWN0DQogICAgICAgIH0N
Cg0KVGhhbmsgeW91DQpTZXJndWVpDQoNCg==
