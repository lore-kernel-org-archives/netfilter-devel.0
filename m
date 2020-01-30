Return-Path: <SRS0=SOhW=3T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB980C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 17:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96AC4206F0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 17:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="FJVVXjol";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="retiedi9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbgA3RTS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jan 2020 12:19:18 -0500
Received: from alln-iport-6.cisco.com ([173.37.142.93]:49676 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727338AbgA3RTS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jan 2020 12:19:18 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jan 2020 12:19:16 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4690; q=dns/txt; s=iport;
  t=1580404756; x=1581614356;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=6nWP9RKWXp5Uf1a2o2/sCIEjhsPlZp18X+qlOQoHzAg=;
  b=FJVVXjolfCeXRu60cHiRLN185yYJV9x05UhT2/jNNKzHBxHn66C0Njzx
   b5rbO5ZOG0GJMAE2WgmtQlJOhM+P8gh8k+RETuctWzYR2xvrtjT7bXlre
   L3Rul0UvuGSKPfhBoB4LkqijNcr13mbRy09SkbmyAXsPHJ418kLKHJAh2
   E=;
IronPort-PHdr: =?us-ascii?q?9a23=3Azm37hBNcRqvczoy/aOEl6mtXPHoupqn0MwgJ65?=
 =?us-ascii?q?Eul7NJdOG58o//OFDEu6w/l0fHCIPc7f8My/HbtaztQyQh2d6AqzhDFf4ETB?=
 =?us-ascii?q?oZkYMTlg0kDtSCDBjgJvP4cSEgH+xJVURu+DewNk0GUMs=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DyAQCuDTNe/49dJa1lHQEBAQkBEQU?=
 =?us-ascii?q?FAYFqBQELAYFTUAWBRCAECyoKhAqDRgOKcppuglIDVAkBAQEMAQEtAgEBhEA?=
 =?us-ascii?q?ZghckNwYOAgMNAQEEAQEBAgEFBG2FNwyFYRYREQwBASMUAREBIgImAgQwFRI?=
 =?us-ascii?q?EAQ0ngwSCSwMuAQKiKwKBOYhidYEygn8BAQWCRIJAGIIMCYEOKgGFHQyGdhq?=
 =?us-ascii?q?BQT+BEAEnIIIfAYhDMoIsjWqCbIYEmQcKgjkEhlaPYBubAo5gmC2CZwIEAgQ?=
 =?us-ascii?q?FAg4BAQWBaCOBWHAVZQGCQVAYDY4dg3OKU3SBKYwZAYEPAQE?=
X-IronPort-AV: E=Sophos;i="5.70,382,1574121600"; 
   d="scan'208";a="440031804"
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 30 Jan 2020 17:12:10 +0000
Received: from XCH-ALN-008.cisco.com (xch-aln-008.cisco.com [173.36.7.18])
        by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id 00UHCAhO009352
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 30 Jan 2020 17:12:10 GMT
Received: from xhs-aln-002.cisco.com (173.37.135.119) by XCH-ALN-008.cisco.com
 (173.36.7.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 30 Jan
 2020 11:12:09 -0600
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by xhs-aln-002.cisco.com
 (173.37.135.119) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 30 Jan
 2020 11:12:09 -0600
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-003.cisco.com (64.101.210.230) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 30 Jan 2020 12:12:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErOaM2JfNUONxDXkXTK/48ZEN/ntosK0Z77B81YNA+XCKkqSboY9E007K6E942Ygx9XcBAQoLCkXY2xgS+laShjwCJgm1ldtpH6zn8bHaDG49CleL1KKHNHQTkJGgX8e8/kQig58b3cKesQ7yqQY/2RpDsUm7qjgqUT32GC1QgF9RgIKrWDxbcD+XA8BFgwNMVHkLVcl0445nHmOI7+95S1FO8caoRwVCu9BNp+dztxWPJE94/IE352eLq5FWDU6zTwb+vBQ6hSOsxKx00CeR1bapo7aO6x2KqMm+SHDimYvuEoBPK9uzBCx5vOBv07GDcc3HkGd9NzKYiXtYYWtMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nWP9RKWXp5Uf1a2o2/sCIEjhsPlZp18X+qlOQoHzAg=;
 b=T5dYX9c4/G/7Yf10fMf7KclfMXqBTYiVXAML5IIp+m15UKJIGwCydENNab7LETyn/mjn2auDCm/cPmJ4EHfmO46X/RAaGQSF32ieQ7LXEI0D20k7X+HmcHUhVRgjdQ6Mk3kXVo4X8EFJXjXVcazUUmUYH1wTH9qUvOu+Kb7DfMNnQXmUQjVtnK+UMXyk0546qTCZdOsWjH1hs7ptkwIdf+M3WO9n1RKf+4Pn/UuRRnJe/GrrVItmbwFgnNbno+Oys2vLZtVlh6cidkXACBK1bisu6tBzS9k47Otu+fwaNAcj2myjkaPwyJhTnINJoS3u2AjgjulpvTHQFA936XjSOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nWP9RKWXp5Uf1a2o2/sCIEjhsPlZp18X+qlOQoHzAg=;
 b=retiedi9x5zWdxXfUZXPUP+NV1WhFNCdUy/W8+25I5e+QE1zbyZHWtrLzc+VbHHImc+4qMtKjy+wyLw5wrjqL4LvvwF+ZosJxcPLY/yPM6G9typXFqCwRbp0W1bitXNk1dJ0Zc5288MXxCYUCyCQbcXeJ0Bi247oPPA/G7eilYc=
Received: from MN2PR11MB3598.namprd11.prod.outlook.com (20.178.252.28) by
 MN2PR11MB4142.namprd11.prod.outlook.com (20.179.149.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Thu, 30 Jan 2020 17:12:07 +0000
Received: from MN2PR11MB3598.namprd11.prod.outlook.com
 ([fe80::e526:356d:d654:f135]) by MN2PR11MB3598.namprd11.prod.outlook.com
 ([fe80::e526:356d:d654:f135%7]) with mapi id 15.20.2665.027; Thu, 30 Jan 2020
 17:12:07 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Proxy load balancer rules
Thread-Topic: Proxy load balancer rules
Thread-Index: AQHV15BmhBdMf3sJiEm/5Fz1ZNsLfw==
Date:   Thu, 30 Jan 2020 17:12:07 +0000
Message-ID: <DEB99F9B-0D1A-40DD-97C8-3FB0C4E24CD6@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.21.0.200113
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [24.200.205.158]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 953249c0-58e8-48ce-b703-08d7a5a7894a
x-ms-traffictypediagnostic: MN2PR11MB4142:
x-microsoft-antispam-prvs: <MN2PR11MB41428133A2C03082BC54B520C4040@MN2PR11MB4142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 02981BE340
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(478600001)(3480700007)(110136005)(33656002)(36756003)(2906002)(316002)(4326008)(6512007)(6506007)(2616005)(81156014)(86362001)(26005)(6486002)(186003)(76116006)(91956017)(8936002)(8676002)(81166006)(71200400001)(66446008)(66946007)(66556008)(5660300002)(64756008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4142;H:MN2PR11MB3598.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aYhMZvKDeF+NXdx2ORgFuNgewEeHN+LLmXZux2XmqJWQDS8qJ0zAIwjDe5Hv9My3TPaKjEfzIkvl5al/zIT7xRgNGbzGEvFEN5PtPkwSrNUiSQiBNags+sPaoLjNURsvWyrO/4YHsw5dk1uZLQ5+it9Td/cdVYKftMyjKUxdKpIZ4WR9XOsjcwCuvXFyxSpO2COupw3UJNM5dB0R84GkWicHjrBB9zdNuHnvuYfrBRhCt5djAyloO5NPm9/Yj8lrTS3obgUO7pqx2hMWLk0CRYVCQeET7FGZNVKHjBLHCATlJW+YRxpbNiW69An6FK7dkwMqq8mITTvQ/N3zsmwjgpkkmh3Y736ZR74Vk5+Yt5s2ofKCeoFM4bBztLU6VZYOjTx2K30Mhyt1xPlhia4qIUAvOIbccLmUs4kutawicXu1JXQR0F0Cy/dfV+xxde2U
x-ms-exchange-antispam-messagedata: FTssyYs/Dchqu9VenB5pyq+2cc7ClvMQ8U5KPZDaoM/TJeiNDZGUQGtqYgAEIMJwuTYyGqJDM6Rk2YzRTYbc3biv0C9668LtaNp+cdB421rgxa+q+20y0yjhFYnPcGiokP1BVE6Cw8DInW65DDQ7aw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <878E2EDCAFD981449F55BA5DA0BE4DA1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 953249c0-58e8-48ce-b703-08d7a5a7894a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2020 17:12:07.3953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wo+oSi/KBeSF3rMfKbO+z2toJ6H6xzDdUOgnQefqBmv3folnHIECgg2XNz8FaCDfXDSH0GrAGmPCEPeu0Kgl6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4142
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.18, xch-aln-008.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8sDQoNCldoaWxlIHJ1bm5pbmcga3ViZXJuZXRlcyBlMmUgY29uZm9ybWFuY2UgdGVzdHMg
YWdhaW5zdCBuZnByb3h5LCBJIGZvdW5kIG91dCB0aGF0IGN1cnJlbnQga3ViZS1wcm94eSBidWls
ZHMga2luZCBvZiBjb21wbGljYXRlZCBzZXQgb2YgcnVsZXMsIEkgd2FzIHdvbmRlcmluZyBpZiB5
b3UgY291bGQgY2hlY2sgdG8gc2VlIGlmIHRoZXJlIGlzIGVxdWl2YWxlbnRzIGZvciBrZXl3b3Jk
cyB1c2VkIGluIG5mdGFibGVzOg0KDQpJZiBwYWNrZXQgaGl0cyB0aGlzIGxvYWRiYWxhbmNlciBp
cCwgdGhlIHByb2Nlc3Npbmcgc3RhcnRzOg0KDQotQSBLVUJFLVNFUlZJQ0VTIC1kIDE5Mi4xNjgu
ODAuMjUwLzMyIC1wIHRjcCAtbSBjb21tZW50IC0tY29tbWVudCAic2VydmljZXMtOTgzNy9hZmZp
bml0eS1sYi1lc2lwcC10cmFuc2l0aW9uOiBsb2FkYmFsYW5jZXIgSVAiIC1tIHRjcCAtLWRwb3J0
IDgwIC1qIEtVQkUtRlctQkFKNDJPNldNU1NCN1lHQQ0KDQotQSBLVUJFLUZXLUJBSjQyTzZXTVNT
QjdZR0EgLW0gY29tbWVudCAtLWNvbW1lbnQgInNlcnZpY2VzLTk4MzcvYWZmaW5pdHktbGItZXNp
cHAtdHJhbnNpdGlvbjogbG9hZGJhbGFuY2VyIElQIiAtaiBLVUJFLVhMQi1CQUo0Mk82V01TU0I3
WUdBDQotQSBLVUJFLUZXLUJBSjQyTzZXTVNTQjdZR0EgLW0gY29tbWVudCAtLWNvbW1lbnQgInNl
cnZpY2VzLTk4MzcvYWZmaW5pdHktbGItZXNpcHAtdHJhbnNpdGlvbjogbG9hZGJhbGFuY2VyIElQ
IiAtaiBLVUJFLU1BUkstRFJPUA0KDQotQSBLVUJFLVhMQi1CQUo0Mk82V01TU0I3WUdBIC1zIDU3
LjExMi4wLjAvMTIgLW0gY29tbWVudCAtLWNvbW1lbnQgIlJlZGlyZWN0IHBvZHMgdHJ5aW5nIHRv
IHJlYWNoIGV4dGVybmFsIGxvYWRiYWxhbmNlciBWSVAgdG8gY2x1c3RlcklQIiAtaiBLVUJFLVNW
Qy1CQUo0Mk82V01TU0I3WUdBDQotQSBLVUJFLVhMQi1CQUo0Mk82V01TU0I3WUdBIC1tIGNvbW1l
bnQgLS1jb21tZW50ICJtYXNxdWVyYWRlIExPQ0FMIHRyYWZmaWMgZm9yIHNlcnZpY2VzLTk4Mzcv
YWZmaW5pdHktbGItZXNpcHAtdHJhbnNpdGlvbjogTEIgSVAiIC1tIGFkZHJ0eXBlIC0tc3JjLXR5
cGUgTE9DQUwgLWogS1VCRS1NQVJLLU1BU1ENCi1BIEtVQkUtWExCLUJBSjQyTzZXTVNTQjdZR0Eg
LW0gY29tbWVudCAtLWNvbW1lbnQgInJvdXRlIExPQ0FMIHRyYWZmaWMgZm9yIHNlcnZpY2VzLTk4
MzcvYWZmaW5pdHktbGItZXNpcHAtdHJhbnNpdGlvbjogTEIgSVAgdG8gc2VydmljZSBjaGFpbiIg
LW0gYWRkcnR5cGUgLS1zcmMtdHlwZSBMT0NBTCAtaiBLVUJFLVNWQy1CQUo0Mk82V01TU0I3WUdB
DQoNCiENCiEgICAtbSByZWNlbnQgLS1yY2hlY2sgLS1zZWNvbmRzIDEwODAwIC0tcmVhcCAgLS1y
c291cmNlIC0ga2V5d29yZHMgSSBhbSBsb29raW5nIGZvciBlcXVpdmFsZW50IGluICBuZnRhYmxl
cyAgDQohDQoNCi1BIEtVQkUtWExCLUJBSjQyTzZXTVNTQjdZR0EgLW0gY29tbWVudCAtLWNvbW1l
bnQgInNlcnZpY2VzLTk4MzcvYWZmaW5pdHktbGItZXNpcHAtdHJhbnNpdGlvbjoiIC1tIHJlY2Vu
dCAtLXJjaGVjayAtLXNlY29uZHMgMTA4MDAgLS1yZWFwIC0tbmFtZSBLVUJFLVNFUC1KQU9RNFpC
TkZHWjM0QVo0IC0tbWFzayAyNTUuMjU1LjI1NS4yNTUgLS1yc291cmNlIC1qIEtVQkUtU0VQLUpB
T1E0WkJORkdaMzRBWjQNCi1BIEtVQkUtWExCLUJBSjQyTzZXTVNTQjdZR0EgLW0gY29tbWVudCAt
LWNvbW1lbnQgInNlcnZpY2VzLTk4MzcvYWZmaW5pdHktbGItZXNpcHAtdHJhbnNpdGlvbjoiIC1t
IHJlY2VudCAtLXJjaGVjayAtLXNlY29uZHMgMTA4MDAgLS1yZWFwIC0tbmFtZSBLVUJFLVNFUC1X
TEhEVlFUTDU3VkJQVVJFIC0tbWFzayAyNTUuMjU1LjI1NS4yNTUgLS1yc291cmNlIC1qIEtVQkUt
U0VQLVdMSERWUVRMNTdWQlBVUkUNCi1BIEtVQkUtWExCLUJBSjQyTzZXTVNTQjdZR0EgLW0gY29t
bWVudCAtLWNvbW1lbnQgInNlcnZpY2VzLTk4MzcvYWZmaW5pdHktbGItZXNpcHAtdHJhbnNpdGlv
bjoiIC1tIHJlY2VudCAtLXJjaGVjayAtLXNlY29uZHMgMTA4MDAgLS1yZWFwIC0tbmFtZSBLVUJF
LVNFUC01WFdDSUtOSTNNNE1XQU1VIC0tbWFzayAyNTUuMjU1LjI1NS4yNTUgLS1yc291cmNlIC1q
IEtVQkUtU0VQLTVYV0NJS05JM000TVdBTVUNCiENCi1BIEtVQkUtWExCLUJBSjQyTzZXTVNTQjdZ
R0EgLW0gY29tbWVudCAtLWNvbW1lbnQgIkJhbGFuY2luZyBydWxlIDAgZm9yIHNlcnZpY2VzLTk4
MzcvYWZmaW5pdHktbGItZXNpcHAtdHJhbnNpdGlvbjoiIC1tIHN0YXRpc3RpYyAtLW1vZGUgcmFu
ZG9tIC0tcHJvYmFiaWxpdHkgMC4zMzMzMzMzMzM0OSAtaiBLVUJFLVNFUC1KQU9RNFpCTkZHWjM0
QVo0DQotQSBLVUJFLVhMQi1CQUo0Mk82V01TU0I3WUdBIC1tIGNvbW1lbnQgLS1jb21tZW50ICJC
YWxhbmNpbmcgcnVsZSAxIGZvciBzZXJ2aWNlcy05ODM3L2FmZmluaXR5LWxiLWVzaXBwLXRyYW5z
aXRpb246IiAtbSBzdGF0aXN0aWMgLS1tb2RlIHJhbmRvbSAtLXByb2JhYmlsaXR5IDAuNTAwMDAw
MDAwMDAgLWogS1VCRS1TRVAtV0xIRFZRVEw1N1ZCUFVSRQ0KLUEgS1VCRS1YTEItQkFKNDJPNldN
U1NCN1lHQSAtbSBjb21tZW50IC0tY29tbWVudCAiQmFsYW5jaW5nIHJ1bGUgMiBmb3Igc2Vydmlj
ZXMtOTgzNy9hZmZpbml0eS1sYi1lc2lwcC10cmFuc2l0aW9uOiIgLWogS1VCRS1TRVAtNVhXQ0lL
TkkzTTRNV0FNVQ0KDQoNCi1BIEtVQkUtU0VQLTVYV0NJS05JM000TVdBTVUgLXMgNTcuMTEyLjAu
MjA4LzMyIC1qIEtVQkUtTUFSSy1NQVNRDQotQSBLVUJFLVNFUC01WFdDSUtOSTNNNE1XQU1VIC1w
IHRjcCAtbSByZWNlbnQgLS1zZXQgLS1uYW1lIEtVQkUtU0VQLTVYV0NJS05JM000TVdBTVUgLS1t
YXNrIDI1NS4yNTUuMjU1LjI1NSAtLXJzb3VyY2UgLW0gdGNwIC1qIEROQVQgW3Vuc3VwcG9ydGVk
IHJldmlzaW9uXQ0KDQotQSBLVUJFLVNFUC1KQU9RNFpCTkZHWjM0QVo0IC1zIDU3LjExMi4wLjIw
Ni8zMiAtaiBLVUJFLU1BUkstTUFTUQ0KLUEgS1VCRS1TRVAtSkFPUTRaQk5GR1ozNEFaNCAtcCB0
Y3AgLW0gcmVjZW50IC0tc2V0IC0tbmFtZSBLVUJFLVNFUC1KQU9RNFpCTkZHWjM0QVo0IC0tbWFz
ayAyNTUuMjU1LjI1NS4yNTUgLS1yc291cmNlIC1tIHRjcCAtaiBETkFUIFt1bnN1cHBvcnRlZCBy
ZXZpc2lvbl0NCg0KLUEgS1VCRS1TRVAtV0xIRFZRVEw1N1ZCUFVSRSAtcyA1Ny4xMTIuMC4yMDcv
MzIgLWogS1VCRS1NQVJLLU1BU1ENCi1BIEtVQkUtU0VQLVdMSERWUVRMNTdWQlBVUkUgLXAgdGNw
IC1tIHJlY2VudCAtLXNldCAtLW5hbWUgS1VCRS1TRVAtV0xIRFZRVEw1N1ZCUFVSRSAtLW1hc2sg
MjU1LjI1NS4yNTUuMjU1IC0tcnNvdXJjZSAtbSB0Y3AgLWogRE5BVCBbdW5zdXBwb3J0ZWQgcmV2
aXNpb25dDQoNCkFwcHJlY2lhdGUgYSBsb3QgeW91ciBoZWxwIA0KVGhhbmsgeW91DQpTZXJndWVp
DQoNCg==
