Return-Path: <SRS0=M/8g=ZS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC39FC432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 15:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AC552071E
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 15:47:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="jCRTzBfm";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="YEdu+j+1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbfKZPrz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Nov 2019 10:47:55 -0500
Received: from alln-iport-5.cisco.com ([173.37.142.92]:12966 "EHLO
        alln-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728558AbfKZPry (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 10:47:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2066; q=dns/txt; s=iport;
  t=1574783273; x=1575992873;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FxfWoxGY84oRV2D9gDaSXhpwuCZWvS5RQY7CYRQgLl4=;
  b=jCRTzBfm4peuf9sR0Can1lywYVpQP3BDKaH7cyEqAElyteJZPn+qnyo4
   PcQGtxsXGr50wWLfk+gaDV3dA5FhOFdQsBu61n9MpY1qu+M3JCTu0TKR9
   52qkJ1VpQZLCKOM23R76sgjOBj4m5oweY4NRq2XEqI+fuDT50ZiHgE8Cg
   k=;
IronPort-PHdr: =?us-ascii?q?9a23=3AayuK2Rex4R8Xe28YQlBzT6LAlGMj4e+mNxMJ6p?=
 =?us-ascii?q?chl7NFe7ii+JKnJkHE+PFxlwGQD57D5adCjOzb++D7VGoM7IzJkUhKcYcEFn?=
 =?us-ascii?q?pnwd4TgxRmBceEDUPhK/u/dCY3DtpPTlxN9HCgOk8TE8H7NBXf?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AUAAD9R91d/49dJa1kGgEBAQEBAQE?=
 =?us-ascii?q?BAQMBAQEBEQEBAQICAQEBAYFsAwEBAQELAYFKUAWBRCAECyoKhCGDRgOKcIJ?=
 =?us-ascii?q?fgQGXA4EugSQDVAkBAQEMAQEtAgEBhEACF4FfJDYHDgIDDQEBBAEBAQIBBQR?=
 =?us-ascii?q?thTcMhVMBAQEDEhERDAEBNwEPAgEIGAICJgICAjAVEAIEDgUigwCCRwMuAQK?=
 =?us-ascii?q?oFgKBOIhgdYEygn4BAQWFHhiCFwmBDigBhRqGexqBQD+BEScgghcHLj6ESRe?=
 =?us-ascii?q?CeTKCLI01gmKFbpgzCoIshjmPHRuCP4dqizaEPqR5g2ECBAIEBQIOAQEFgVk?=
 =?us-ascii?q?GLIFYcBVlAYJBUBEUhkgMF4NQilN0gSiNOAGBDgEB?=
X-IronPort-AV: E=Sophos;i="5.69,246,1571702400"; 
   d="scan'208";a="378658767"
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by alln-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 26 Nov 2019 15:47:52 +0000
Received: from XCH-RCD-004.cisco.com (xch-rcd-004.cisco.com [173.37.102.14])
        by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id xAQFlqZI031178
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 26 Nov 2019 15:47:52 GMT
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by XCH-RCD-004.cisco.com
 (173.37.102.14) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Nov
 2019 09:47:51 -0600
Received: from xhs-aln-002.cisco.com (173.37.135.119) by xhs-rcd-002.cisco.com
 (173.37.227.247) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Nov
 2019 09:47:50 -0600
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-002.cisco.com (173.37.135.119) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Nov 2019 09:47:50 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCxUZqlav57jN76On+22zgiIQGIpvH8BStcVtWqlIItjbx3124DjUbrwzp7RECzzb8+XQYn/Yz/TcuESMVWLh7ZWtwaeWnEbdTMH8B3nuuXtgliBz2bKq0K4GCexQjjhxpk3kowb8vcNzAU/6LYNcs+cS0aK9gU7kjoOdyLXCjGb94h7iNzGmYsDSqeAQp2VH4Z+5pcx9b+v1V+nelrXLMFhUqpiJVArPZiBUt9B7IYrtYkn4jL0IDBe70aF9DXl3/TWN7A+biL0nX8p/A1+uG7Sy1sP1TYhK16wFmy6bNdvZNtH3EA3/KWM5o/F5IaHmhL3JrPeuCFfghgi2o41vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxfWoxGY84oRV2D9gDaSXhpwuCZWvS5RQY7CYRQgLl4=;
 b=N8aKSmw8gXYbvsbMcPilW88Bx8xQUv+Bac49KdK/XPR/ZG3CgW7eaTPHHKJJTd2TQ4hp/fIo1AtP1gVgX2kGcJSaz8C5YC2ef9tzHe/Wm5nMm4xPDcEe2U9KCy+/0nssz/6jMfEOMjUE6k8Kr0/FCh+/fXefhLwW/ObPExt4FilTqEWe6r4XoJ0Nj0LZhRzH3DRPDqTI9E2uyeTNrK1hojBA65MsfjBf6nxjyrzLf2xUwF6BBGKHpY2cmZGn3VScWXBDwnltcnvMJ5E7pWU7XbUl/domX8Nh3Il4cIvrapJa18ZPp+EXqY5MAY7uyPoRnOw8kmw/JfA/pPD7JYZLfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxfWoxGY84oRV2D9gDaSXhpwuCZWvS5RQY7CYRQgLl4=;
 b=YEdu+j+1RGoX1LkzzmV4YXBXB6EZfFREz5CH2rPD4MPK4I/lxIQas4HnOHsATuqfdf+b6efjT2GoQdLKtGIYDFOx2LjUedDDehGrF+H5VAoa9IuMi0yzMTHE7Hh14Ldk0qCMBy5Qn7CB2sb65m3cp4/kcvDGbBpkqHbpL1CUDpg=
Received: from SN6PR11MB3358.namprd11.prod.outlook.com (52.135.110.149) by
 SN6PR11MB2848.namprd11.prod.outlook.com (52.135.94.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.17; Tue, 26 Nov 2019 15:47:49 +0000
Received: from SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d]) by SN6PR11MB3358.namprd11.prod.outlook.com
 ([fe80::280e:21c6:3ef8:1a6d%7]) with mapi id 15.20.2474.023; Tue, 26 Nov 2019
 15:47:49 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLts6edYHQA///QMACAAGcLAP//rq8A
Date:   Tue, 26 Nov 2019 15:47:49 +0000
Message-ID: <427E92A6-2FFA-47CF-BF3B-C08961C978C9@cisco.com>
References: <5248B312-60A9-48A7-B4CF-E00D1BDF1CD2@cisco.com>
 <20191126122110.GD795@breakpoint.cc>
 <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
 <20191126153850.pblaoj4xklfz5jgv@salvia>
In-Reply-To: <20191126153850.pblaoj4xklfz5jgv@salvia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 841b3f90-ee22-45c4-e777-08d77287fd76
x-ms-traffictypediagnostic: SN6PR11MB2848:
x-microsoft-antispam-prvs: <SN6PR11MB2848971FF874FE3DE456156CC4450@SN6PR11MB2848.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0233768B38
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(199004)(189003)(446003)(11346002)(36756003)(2616005)(5660300002)(8676002)(6916009)(76116006)(91956017)(66476007)(66556008)(64756008)(66946007)(6246003)(66446008)(66066001)(6436002)(71190400001)(6486002)(71200400001)(256004)(478600001)(25786009)(8936002)(229853002)(4326008)(2906002)(33656002)(99286004)(316002)(81166006)(58126008)(54906003)(81156014)(86362001)(14454004)(305945005)(7736002)(6116002)(3846002)(76176011)(4001150100001)(186003)(102836004)(6506007)(26005)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2848;H:SN6PR11MB3358.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hPTFSW4ClRmLxjI3LmgZBdAggrKa27jmMHBFiq7Q6kua3SV0tG/bm1bhzm2n9dQv6Q5GTmZM+atiavu1NTnpoAlSnYk3K32XgNIrbW9xBwwOd6keWBM9G55lNYTR3YISnHTWFMFwuiE1rUB3v/DNByx5ORT1uwZDL6qIBNqC50c4yfrGQqX5gWnGsIjN9oubPhFmQ6tytHp84Cf+rpVYHN7cxHyqOX33S+eEpiWRQCEGFlMCwnHQ0gPhmc5/LfkWC5WDkif9pccNNjudK1afQ/cBAFO5JrfKoszNCe/LmIBf46pcLXu5hev4CW3mQuRkNK9SJbbYDwKWAoYHyy+/poV2klYcLay7pw4CgaLHScLUu4OD9XUlzsUyRyJagk56RZCcfn7aKad+gt2ogkT9XKPrJ7ljWzJEnXtyXK3jdhfKrLfX66hG1jUYUBQqaf0q
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B356EAEAF67F042B5A48A2C70688034@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 841b3f90-ee22-45c4-e777-08d77287fd76
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2019 15:47:49.3934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O447eQHvLjBnF1h5bhRVCIJcAXvbVhhisaOPOgicR5oJ8bOXbvW4OPLA1T4J57e2LKuzqvZzks+hOqsQjKNyUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2848
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.14, xch-rcd-004.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8sDQoNCkkgdG90YWxseSBnZXQgaXQgdGhhdCBpdCBpcyBub3QgcG9zc2libGUgaW4gdGhl
b3J5LCBidXQgdGhlIG1hdHRlciBvZiBmYWN0IGlzIGluIGt1YmVybmV0ZXMgc29tZWhvdyBpdCB3
b3JrcywgbWF5YmUgaW4gc29tZSBjYXNlcyB0aGlzIGNoZWNrIGlzIG5vdCBlbmZvcmNlZCwgSSBk
byBub3Qga25vdy4gSWYgeW91IGFyZSBpbnRlcmVzdGVkIHRvIGludmVzdGlnYXRlIGl0IGZ1cnRo
ZXIsIHBsZWFzZSBsZXQgbWUga25vdyBhcyBJIHNhaWQgSSBoYXZlIGEgY2x1c3RlciB3aXRoIHRo
ZXNlIDIgcnVsZXMgY29uZmlndXJlZC4NCg0KVGhhbmsgeW91DQpTZXJndWVpDQoNCu+7v09uIDIw
MTktMTEtMjYsIDEwOjQwIEFNLCAiUGFibG8gTmVpcmEgQXl1c28iIDxwYWJsb0BuZXRmaWx0ZXIu
b3JnPiB3cm90ZToNCg0KICAgIE9uIFR1ZSwgTm92IDI2LCAyMDE5IGF0IDAyOjMwOjAyUE0gKzAw
MDAsIFNlcmd1ZWkgQmV6dmVya2hpIChzYmV6dmVyaykgd3JvdGU6DQogICAgPiBIZWxsbyBGbG9y
aWFuLA0KICAgID4NCiAgICA+IFRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgcmVwbHkuIE9u
Y2UgSSBjaGFuZ2VkIHRvIElucHV0IGNoYWluIHR5cGUsIHRoZSBydWxlIHdvcmtlZC4gSXQgc2Vl
bXMgaXB0YWJsZXMgRE8gYWxsb3cgdGhlIHNhbWUgcnVsZSBjb25maWd1cmF0aW9uIHNlZSBiZWxv
dzoNCiAgICA+DQogICAgPiAtQSBQUkVST1VUSU5HIC1tIGNvbW1lbnQgLS1jb21tZW50ICJrdWJl
cm5ldGVzIHNlcnZpY2UgcG9ydGFscyIgLWogS1VCRS1TRVJWSUNFUw0KICAgID4gLUEgS1VCRS1T
RVJWSUNFUyAtZCA1Ny4xMzEuMTUxLjE5LzMyIC1wIHRjcCAtbSBjb21tZW50IC0tY29tbWVudCAi
ZGVmYXVsdC9wb3J0YWw6cG9ydGFsIGhhcyBubyBlbmRwb2ludHMiIC1tIHRjcCAtLWRwb3J0IDg5
ODkgLWogUkVKRUNUIC0tcmVqZWN0LXdpdGggaWNtcC1wb3J0LXVucmVhY2hhYmxlDQogICAgDQog
ICAgc3RhdGljIHN0cnVjdCB4dF90YXJnZXQgcmVqZWN0X3RnX3JlZyBfX3JlYWRfbW9zdGx5ID0g
ew0KICAgICAgICAgICAgLm5hbWUgICAgICAgICAgID0gIlJFSkVDVCIsDQogICAgICAgICAgICAu
ZmFtaWx5ICAgICAgICAgPSBORlBST1RPX0lQVjQsDQogICAgICAgICAgICAudGFyZ2V0ICAgICAg
ICAgPSByZWplY3RfdGcsDQogICAgICAgICAgICAudGFyZ2V0c2l6ZSAgICAgPSBzaXplb2Yoc3Ry
dWN0IGlwdF9yZWplY3RfaW5mbyksDQogICAgICAgICAgICAudGFibGUgICAgICAgICAgPSAiZmls
dGVyIiwNCiAgICAgICAgICAgIC5ob29rcyAgICAgICAgICA9ICgxIDw8IE5GX0lORVRfTE9DQUxf
SU4pIHwgKDEgPDwgTkZfSU5FVF9GT1JXQVJEKSB8DQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAoMSA8PCBORl9JTkVUX0xPQ0FMX09VVCksDQogICAgICAgICAgICAuY2hlY2tlbnRyeSAg
ICAgPSByZWplY3RfdGdfY2hlY2ssDQogICAgICAgICAgICAubWUgICAgICAgICAgICAgPSBUSElT
X01PRFVMRSwNCiAgICB9Ow0KICAgIA0KDQo=
