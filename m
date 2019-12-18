Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDB9C43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 20:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9197921582
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 20:54:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Lx6O0fCB";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="T7rkQoVf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfLRUyI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 15:54:08 -0500
Received: from alln-iport-4.cisco.com ([173.37.142.91]:47451 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLRUyI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 15:54:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1886; q=dns/txt; s=iport;
  t=1576702447; x=1577912047;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PNu8AWBQQXTBHydxIRasnwRyMT4YynDh8D6dN0nUIk0=;
  b=Lx6O0fCBpGmYAmIQeEnXrAVDomiJ4rihJhHUZKOUGvWYh6mudTl+BeRn
   wrgBLMCLz6NWHqLCf1L/WXsD+ySDjx8ZKjgpacENiSShec8fz4hjUbYfg
   cT+dSXC0v4hMLDeTZB5p+te5tknuTCFOnlfPMrBq2cLUX77UjozG1AoCj
   I=;
IronPort-PHdr: =?us-ascii?q?9a23=3AuVeQUxNExYmkvJ2ylQgl6mtXPHoupqn0MwgJ65?=
 =?us-ascii?q?Eul7NJdOG58o//OFDEu6w/l0fHCIPc7f8My/HbtaztQyQh2d6AqzhDFf4ETB?=
 =?us-ascii?q?oZkYMTlg0kDtSCDBjgJvP4cSEgH+xJVURu+DewNk0GUMs=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0A3AABRkfpd/4QNJK1lGwEBAQEBAQE?=
 =?us-ascii?q?FAQEBEQEBAwMBAQGBagQBAQELAYFMUAWBRCAECyoKg3qDRgOKcYJfiVyOKoE?=
 =?us-ascii?q?ugSQDVAkBAQEMAQEtAgEBhEACF4ICJDYHDgIDDQEBBAEBAQIBBQRthTcMhV8?=
 =?us-ascii?q?BAQEDEhEEDQwBATcBDwIBCA4KAgImAgICHxEVEAIEDgUigwCCRwMuAaMiAoE?=
 =?us-ascii?q?4iGF1fzOCfgEBBYUTDQuCEAmBDigBjBcagUE/gTgggkw+ghuCLheCeTKCLJA?=
 =?us-ascii?q?3nhNDCoI1kW2EJhuaTo8tigyPYwIEAgQFAg4BAQWBWQIwgVhwFWUBgkFQGA2?=
 =?us-ascii?q?NEoNzilN0gSiMdQGBDwEB?=
X-IronPort-AV: E=Sophos;i="5.69,330,1571702400"; 
   d="scan'208";a="385385293"
Received: from alln-core-10.cisco.com ([173.36.13.132])
  by alln-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 18 Dec 2019 20:54:06 +0000
Received: from XCH-RCD-003.cisco.com (xch-rcd-003.cisco.com [173.37.102.13])
        by alln-core-10.cisco.com (8.15.2/8.15.2) with ESMTPS id xBIKs6HW023313
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 18 Dec 2019 20:54:06 GMT
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by XCH-RCD-003.cisco.com
 (173.37.102.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Dec
 2019 14:54:06 -0600
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by xhs-rcd-001.cisco.com
 (173.37.227.246) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Dec
 2019 14:54:05 -0600
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-001.cisco.com (173.37.227.246) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 18 Dec 2019 14:54:05 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chpsXPW+p73/7VLlWzWiwXMYb8K5RdEfrEEfNmyJhkrMhTLx3ppXPVTFZzDGohXdOScysVXGVR7pCAmoQtvnCW11T4xYeuw5K5AV0AeKlFJ3s4fbuMvTe1hpH/7EKhp4Z2q2r9c0sC44vuleB6qcqrG7perq5oPz8CvGUGnN24nNd33+Z1+IkD2N0lX9+/dxFIbd55I2fRIC31Yf7+UGLehUII5zXqYdwRG6BqvIdLae4t9Y2c3KUYtdyxGuqV7Z7LUnFPjtgQOn+AlcEPXoWM2thIQUHpYKTgjQyoV2iNmF9CMMSiLhdBPd7aBc20Dp8FwwOYOYEYtG660Xa2YhwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNu8AWBQQXTBHydxIRasnwRyMT4YynDh8D6dN0nUIk0=;
 b=a8KkDwdLB92PY+H6rJZ6YiEZwFzzkFoEBkCDTZI2VIAxK3KqIwhChGUcZQpZNUk+X/XtegtLOoMr2OckFKw0I6nWhagVW0c9x/GjzqUWJPLxIBdyuz6X0Bta4ybGm48f/mQQMfTTr8BU5fzMvlHTk9idC90K7/k1RYUKEFD2fnimpbclB77rCNN3PfcgLl2T072djDAyzD5Vw7vsJnu/0nb5va5ICkqs15q9o3AyPIVlZ6l4LkR2+yuspEo/0/BTIIOt9wYsqdc9J9k//rtFPnhr9b1lFzLiCirawgxwPNLbDRkQEa2nbVmSdxTJivwTDAxykJHdRK6KYz6BTyIbaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNu8AWBQQXTBHydxIRasnwRyMT4YynDh8D6dN0nUIk0=;
 b=T7rkQoVfUv6DzMXTHDHG/8973teImy4scj36Cy9rDkyYZeUj8Cj30MU2QVTxo8pyoIa4AYaFWHxmW6M47PaZfSiB3sWwQ+x7GAoWf7VHIuBTGBgl8UcKE1qRcp3o+GK7QFt8YG1cPbA1NmuBmY0tWfKwghEwHA9OHwzgwkTsEe8=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB1242.namprd11.prod.outlook.com (10.168.108.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 20:54:03 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26%10]) with mapi id 15.20.2538.019; Wed, 18 Dec
 2019 20:54:03 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Laura Garcia <nevola@gmail.com>
CC:     Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyAgABX04CAABp3AIAAVCiAgBKu9ACAARbtgP//xyeAAA/qeAAAKIIrgAALSEoA///THgCAAFfMAP//u8gA
Date:   Wed, 18 Dec 2019 20:54:03 +0000
Message-ID: <18A3F2E5-643A-4E58-94A3-76CC374F6C89@cisco.com>
References: <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
 <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
 <20191204223215.GX14469@orbyte.nwl.cc>
 <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
 <20191217122925.GD8553@orbyte.nwl.cc>
 <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
 <20191217164140.GE8553@orbyte.nwl.cc>
 <6F72FC38-4238-4CCC-BAEB-A7F4B07817D7@cisco.com>
 <20191218172436.GA24932@orbyte.nwl.cc>
 <36EA0652-C146-4ED4-A004-2D729AB69BA7@cisco.com>
 <CAF90-Whnsiw=kEGyYroERYwo+_E2vWEv_3RtT89oSbp-9xoc1A@mail.gmail.com>
In-Reply-To: <CAF90-Whnsiw=kEGyYroERYwo+_E2vWEv_3RtT89oSbp-9xoc1A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.20.0.191208
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b98a5ea-1f3e-45cd-bf85-08d783fc6a61
x-ms-traffictypediagnostic: DM5PR11MB1242:
x-microsoft-antispam-prvs: <DM5PR11MB124261C313725F285C43B02DC4530@DM5PR11MB1242.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(199004)(189003)(4001150100001)(186003)(76116006)(4744005)(33656002)(66946007)(26005)(8676002)(8936002)(66556008)(64756008)(66446008)(81156014)(81166006)(2616005)(4326008)(66476007)(91956017)(6486002)(54906003)(36756003)(86362001)(71200400001)(6512007)(5660300002)(2906002)(53546011)(498600001)(6506007)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1242;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XcshsbxsdyiZJuYYoG5A/rOoOSambdJzqC0i/j2gCITJxe5sn/hBeFSqVGQxr7uZ82iEedfRgWKXUPdDfZmxg2b71FMSEhZhxKDZywwUU5YrecZFlBhRMXLHPhL74qyt0Dfh57eq3hZqaUdO3XQuxj1SBVFRvpCbj0Ux9b7X5MSCRhBvoPWRzrH5nOlZM49hdunX0cazAy34ag2eXXNWOCcaIlSeuigoiJ4lK6uAO92G5p/U45zCvTmUNT3XfRcRz93AlP82W7+6jJ7fFv5UDGLp9BCLuDJ/TFWiaj77JdQQil89hST+FT7elbKRjo648U/6bbqiWmVqAGqNqbk2aeVT9/4H6PhMW+APeG9KZxtfVsSv7wgPX1SB0w98IAQmUlm1zvkI2jCf7NrGKWp1LYRYc46sZXNESSrhNgZpo/sv6JIOPUzbA1Y/iLNFs1u9
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAC94C7D6257624C921FF396FCC36DBF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b98a5ea-1f3e-45cd-bf85-08d783fc6a61
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 20:54:03.4413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LMVsoh2hXqPM+YB0bnQDNbtqNtG/hudpK2Gi+zSSjwb1ls2y+BiJM608ArIxMLsRNdLASCpeP+YxFZ7LuZXvcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1242
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.13, xch-rcd-003.cisco.com
X-Outbound-Node: alln-core-10.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

U3RpbGwgbm8gbHVjayAoDQoNCkB0aCwxNiwxNg0KDQpFcnJvcjogY2FuIG5vdCB1c2UgdmFyaWFi
bGUgc2l6ZWQgZGF0YSB0eXBlcyAoaW50ZWdlcikgaW4gY29uY2F0IGV4cHJlc3Npb25zDQphZGQg
cnVsZSBpcHY0dGFibGUgazhzLWZpbHRlci1zZXJ2aWNlcyBpcCBwcm90b2NvbCAuIGlwIGRhZGRy
IC4gQHRoLDE2LDE2IHZtYXAgQG5vLWVuZHBvaW50cy1zZXJ2aWNlcw0KICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fl5eXl5eXl5eXl5eDQoNCkVycm9yOiBzeW50YXggZXJyb3IsIHVuZXhwZWN0ZWQgZHBv
cnQsIGV4cGVjdGluZyBjb21tYQ0KYWRkIHJ1bGUgaXB2NHRhYmxlIGs4cy1maWx0ZXItc2Vydmlj
ZXMgaXAgcHJvdG9jb2wgLiBpcCBkYWRkciAuIEB0aCBkcG9ydCB2bWFwIEBuby1lbmRwb2ludHMt
c2VydmljZXMNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIF5eXl5eDQoNCkluIGZpcnN0IGNhc2UgdGhlIHN5bnRheCBsb29rcyBvaywgIGJ1dCBJIGFt
IG5vdCBzdXJlIGlmIHZsYW0gdHlwZSBuZWVkcyB0byBiZSBjaGFuZ2VkIA0KDQp0eXBlIGluZXRf
cHJvdG8gLiBpcHY2X2FkZHIgLiBpbmV0X3NlcnZpY2UgOiB2ZXJkaWN0ICAgLS0+IHR5cGUgaW5l
dF9wcm90byAuIGlwdjZfYWRkciAuIGludGVnZXI6IHZlcmRpY3QuICAgID8/Pw0KDQpUaGFuayB5
b3UNClNlcmd1ZWkNCg0KDQrvu79PbiAyMDE5LTEyLTE4LCAyOjU4IFBNLCAiTGF1cmEgR2FyY2lh
IiA8bmV2b2xhQGdtYWlsLmNvbT4gd3JvdGU6DQoNCiAgICBPbiBXZWQsIERlYyAxOCwgMjAxOSBh
dCA4OjQ0IFBNIFNlcmd1ZWkgQmV6dmVya2hpIChzYmV6dmVyaykNCiAgICA8c2JlenZlcmtAY2lz
Y28uY29tPiB3cm90ZToNCiAgICA+DQogICAgPiBFcnJvcjogc3ludGF4IGVycm9yLCB1bmV4cGVj
dGVkIHRoDQogICAgPg0KICAgID4gYWRkIHJ1bGUgaXB2NHRhYmxlIGs4cy1maWx0ZXItc2Vydmlj
ZXMgaXAgcHJvdG9jb2wgLiBpcCBkYWRkciAuIHRoIGRwb3J0IHZtYXAgQG5vLWVuZHBvaW50cy1z
ZXJ2aWNlcw0KICAgID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIF5eDQogICAgDQogICAgVHJ5IHRoaXM6DQogICAgDQogICAgLi4uIEB0aCBkcG9ydCB2
bWFwIC4uLg0KICAgIA0KICAgIG9yDQogICAgDQogICAgLi4uIEB0aCwxNiwxNiB2bWFwIC4uLg0K
ICAgIA0KDQo=
