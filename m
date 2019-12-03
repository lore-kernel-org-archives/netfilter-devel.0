Return-Path: <SRS0=edwS=ZZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35894C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 18:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D47B72073B
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 18:43:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="hhfrD6Et";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="Xk7abHsI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfLCSnY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 13:43:24 -0500
Received: from alln-iport-6.cisco.com ([173.37.142.93]:44697 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfLCSnY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 13:43:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1392; q=dns/txt; s=iport;
  t=1575398603; x=1576608203;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fWH+0JQJwF2TL/FMt+HOJ0QgrUeJ1Tsx+VErmQb1OyU=;
  b=hhfrD6EtXi0ayNtpjT8nsE89EA7QfRBtguLHr4psGaaOoWCn+BGHK3gt
   /8mxGhyioiTw5AfI9maR79RwPNIEIZLC33e3lNYRkQGcO8xhAOUxjOYuB
   Vk+AwOpJ9bOoEWmsaLm8ONBQiN6QiBsR6qt6tUfwS1zcH0zOEhHv0B0LF
   E=;
IronPort-PHdr: =?us-ascii?q?9a23=3ANsDRlhC16+6/Iqc5gNNYUyQJPHJ1sqjoPgMT9p?=
 =?us-ascii?q?ssgq5PdaLm5Zn5IUjD/qs03kTRU9Dd7PRJw6rNvqbsVHZIwK7JsWtKMfkuHw?=
 =?us-ascii?q?QAld1QmgUhBMCfDkiuN/TnfTI3BsdqX15+9Hb9Ok9QS47z?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AGAAA4rOZd/40NJK1lGQEBAQEBAQE?=
 =?us-ascii?q?BAQEBAQEBAQEBEQEBAQEBAQEBAQEBgWoEAQEBAQELAYFKUAWBRCAECyoKhCG?=
 =?us-ascii?q?DRgOEWoYegl+YBIEugSQDVAkBAQEMAQEtAgEBhEACF4F2JDQJDgIDDQEBBAE?=
 =?us-ascii?q?BAQIBBQRthTcMhVMBAQEDEhERDAEBNwEPAgEIGAICJgICAjAVEAIEDgUigwC?=
 =?us-ascii?q?CRwMuAaZfAoE4iGB1gTKCfgEBBYUJGIIXCYEOKAGFGoZ7GoFBP4ERJyCCHi4?=
 =?us-ascii?q?+hEkXgnkygiyPZTmeKQqCLpVZG5okqGcCBAIEBQIOAQEFgVI5gVhwFWUBgkF?=
 =?us-ascii?q?QERSMZoNzilN0gSiOGCuBBAGBDwEB?=
X-IronPort-AV: E=Sophos;i="5.69,274,1571702400"; 
   d="scan'208";a="394251307"
Received: from alln-core-8.cisco.com ([173.36.13.141])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 03 Dec 2019 18:43:21 +0000
Received: from XCH-RCD-004.cisco.com (xch-rcd-004.cisco.com [173.37.102.14])
        by alln-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id xB3IhLtA020935
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 3 Dec 2019 18:43:21 GMT
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by XCH-RCD-004.cisco.com
 (173.37.102.14) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Dec
 2019 12:43:21 -0600
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-rcd-001.cisco.com
 (173.37.227.246) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Dec
 2019 12:43:20 -0600
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 3 Dec 2019 12:43:20 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9TxVwBajOE9f2zVA1AFQQ2USMJz/hp4CDbDTOVCcy8ASk+d/gB8U9C+nlwpAV/bNZpfB+haSE1bwOu4WQUDKcAS56MQmdLGoJ0Zr2VBoRhUc5zO+8Yi4yXQuwZ79ZDSSPbtlAcIki1+A7nX7AyILBoHCPxEY1XeiW8iMyLxgA0Ej2xsttEE9rdmKubTaoRGu2RTAHp8NPMgL2OSPpLas9DVcmMNtliIWIUT2KBmGf8h2CSHsgGVDIVPfTt3A+o7ASsuTEjMjWCnyAu9xGwVYs4gQLlDVAc6mGgiOGSiRcWmQxFNRScHAGHMAsF7G5fCw73eNDUR2jnjUt4c4g0ybQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWH+0JQJwF2TL/FMt+HOJ0QgrUeJ1Tsx+VErmQb1OyU=;
 b=eCRc+/A1u4Z5eEhEUhS29tB88SZ30QoKwcbgLps4vNJHU2q6Ft5CXau0QSJmTTFwdzGqKIIr0E87/KtR/ScwAlU//bSjAWsA+0FReV1fmrJds6o9WMoZzc0onAljXfzRS/4p5K8/Rg1UHIYuu/TLHp42fnhksPBLBMP9K10vQWsxK1IfX8hXNhPZmL0PkPNM3k9teMoy1byxAHBVDN3uxG8Qzn699uidIuPCfTN2Yu1QlwwKXO6a00ZF7VeBNd0zPmmwiO+OpREvfSqk9isxXjzh3Ry1n5qN3SyzV5iUYaWCVYMWwEqW6gDQb60vSTp/S6d0vRjToG3ddR/DuUyOJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWH+0JQJwF2TL/FMt+HOJ0QgrUeJ1Tsx+VErmQb1OyU=;
 b=Xk7abHsIlUYU44C/QJXniz1dQPKVa/UKbvBcCBbiENgcxdIh2xlhC9cIGdBE4/R0wnhYgMkNWjcP7RIvSBG98dDhLLJ2TXwxcPKeH3CIIDvxcD+WrsrLhLKdzx3tdsgzk3/6EIr50jR9Gl/0tA4mLb5j84GqQYpgztprBXF7Gws=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB2025.namprd11.prod.outlook.com (10.168.102.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.17; Tue, 3 Dec 2019 18:43:20 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a%10]) with mapi id 15.20.2516.003; Tue, 3 Dec 2019
 18:43:19 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "Laura Garcia" <nevola@gmail.com>
Subject: Re: Operation not supported when adding jump command
Thread-Topic: Operation not supported when adding jump command
Thread-Index: AQHVo8HvElEENwloc0uP91utUJLts6edYHQA///QMACAAGcLAP//rq8AgABU1YD//91EAAAL5rgA///LmgCAAStKAP//9huAgABc5QD//7OUAIAAXK0A//+4hIAAC5GiAAAGSjgAACMiCwAABt4vgAACbymAAC1bvgAAEorqAACzerCA
Date:   Tue, 3 Dec 2019 18:43:19 +0000
Message-ID: <9E56E734-8E3C-4BB5-AD31-1A8A703CEBCE@cisco.com>
References: <20191127150836.GJ8016@orbyte.nwl.cc>
 <3AE9B74A-37FB-4CDA-86FB-143F506D6C77@cisco.com>
 <20191127160646.GK8016@orbyte.nwl.cc>
 <7C2EF59A-57A3-4E55-92EB-7D64BC0A8417@cisco.com>
 <20191127172210.GM8016@orbyte.nwl.cc>
 <739A821F-2645-41B2-AADA-AA6C34A17335@cisco.com>
 <20191128130814.GQ8016@orbyte.nwl.cc>
 <00B4F260-EA79-4EC1-B7B4-8A9C9D2C96DE@cisco.com>
 <20191128151511.GU8016@orbyte.nwl.cc>
 <97A2D022-C314-4DC4-813D-C319AE9A8DB3@cisco.com>
 <20191130000416.GX8016@orbyte.nwl.cc>
In-Reply-To: <20191130000416.GX8016@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37ed7c5a-e439-4316-dfb6-08d77820aafa
x-ms-traffictypediagnostic: DM5PR11MB2025:
x-microsoft-antispam-prvs: <DM5PR11MB2025EF03FA95880F916F0A97C4420@DM5PR11MB2025.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02408926C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(199004)(189003)(71200400001)(86362001)(6116002)(71190400001)(5660300002)(26005)(3846002)(186003)(305945005)(6916009)(4744005)(6486002)(6512007)(36756003)(2906002)(25786009)(4001150100001)(6436002)(6506007)(33656002)(76176011)(7736002)(81166006)(6246003)(81156014)(14444005)(8676002)(478600001)(102836004)(66946007)(14454004)(229853002)(91956017)(4326008)(64756008)(76116006)(66556008)(8936002)(316002)(256004)(2616005)(11346002)(66476007)(58126008)(99286004)(66446008)(54906003)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB2025;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +OZU9FoR4exe/c7ngpFwNfVxNS1JRWtb9qEvxVuJ0SZT32PV0M9B9Q4LwStEBEgESNS1UmX7n71HPHVQrivYkLe/QpZvP1rh+rUP7zH3p5jH2mjTKHVQqqZoBVpGHap7PiqZKNyUwEuX6OR856FlIXUH+Kuvp3mhN1HyXAbAHGkBkINzlThDpt7Z4OfysjfPgZdTQdspsgsDq0xBeHBxib4Qmo8QhGgf7hY3ws7vkxHfczNsAxvLHHz9NE3YvC5l8oHaSTXc5WMKznDcNVZuoiuL1nxXirHtxQZSMPCiIAXJLDOtrWODot7PokylhXqTJTEE8A0VyHOnOtksUHvec3tNuNKnrB73isBN0wyW8TTHQa9HGBCMWOxIGHrn6aeW7LA//0kaRu6dia/DlmQcgkLwsqqrsVej4JfSuFq1jxa9pzbEJHPWjxKAsZfzx7aP
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5267543D0C84414397C53D2CB54326C0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 37ed7c5a-e439-4316-dfb6-08d77820aafa
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2019 18:43:19.7809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q3WcEkyiXPcokA8ag8JmFlQvIHAD+d5XTZlwMTmjTWkChC4i9i88QAjoaXcEavMATg0qsKJCdLcaeALxDT9mOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2025
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.14, xch-rcd-004.cisco.com
X-Outbound-Node: alln-core-8.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8gUGhpbCwNCg0KU3RhcnRlZCB3b3JraW5nIG9uIG5hdCBwb3J0aW9uIGFuZCBoZXJlIGlz
IGlwdGFibGVzIHJ1bGUgd2hpY2ggaXMgYSBiaXQgY29uY2VybmluZy4NCg0KLUEgS1VCRS1TRVJW
SUNFUyAtZCAxOTIuMTY4LjgwLjEwNC8zMiAtcCB0Y3AgLW0gY29tbWVudCAtLWNvbW1lbnQgImRl
ZmF1bHQvcG9ydGFsOnBvcnRhbCBleHRlcm5hbCBJUCIgLW0gdGNwIC0tZHBvcnQgODk4OSAtbSBw
aHlzZGV2ICEgLS1waHlzZGV2LWlzLWluIC1tIGFkZHJ0eXBlICEgLS1zcmMtdHlwZSBMT0NBTCAt
aiBLVUJFLVNWQy1NVVBYUFZLNFhBWkhTV0FSDQoNCkkgY2FuIGFkZHJlc3MgIiBhZGRydHlwZSIg
d2l0aCBuZnRhYmxlcyAiZmliIiBhbmQgIiBpaWYgdHlwZSBsb2NhbCIgYnV0IEkgYW0gbm90IHN1
cmUgYWJvdXQgInBoeXNkZXYiLCBhcHByZWNpYXRlIGFueSBzdWdnZXN0aW9ucy4NCg0KVGhhbmsg
eW91DQpTZXJndWVpDQoNCu+7v09uIDIwMTktMTEtMjksIDc6MDQgUE0sICJuMC0xQG9yYnl0ZS5u
d2wuY2Mgb24gYmVoYWxmIG9mIFBoaWwgU3V0dGVyIiA8bjAtMUBvcmJ5dGUubndsLmNjIG9uIGJl
aGFsZiBvZiBwaGlsQG53bC5jYz4gd3JvdGU6DQoNCiAgICBIaSBTZXJndWVpLA0KICAgIA0KICAg
IE9uIEZyaSwgTm92IDI5LCAyMDE5IGF0IDA4OjEzOjIxUE0gKzAwMDAsIFNlcmd1ZWkgQmV6dmVy
a2hpIChzYmV6dmVyaykgd3JvdGU6DQogICAgPiBAUGhpbCwgdGhhbmtzIHNvIG11Y2ggZm9yIENv
bmNhdCBzdWdnZXN0aW9uLiBBbnkgbW9yZSBwb2ludHMgZm9yIG9wdGltaXphdGlvbj8gSWYgbm8s
IHRoZW4gSSB3aWxsIG1vdmUgdG8gbmF0IHBvcnRpb24gb2YgazhzIGlwdGFibGVzLg0KICAgIA0K
ICAgIExvb2tzIGZpbmUgdG8gbWUuIEkgZG9uJ3QgbGlrZSB0aGUgbWFyay1iYXNlZCB2ZXJkaWN0
cywgYnV0IHRvIHZhbGlkYXRlDQogICAgdGhvc2Ugd2UgbmVlZCB0byBzZWUgd2hlcmUgdGhlIG1h
cmtzIGFyZSBzZXQuDQogICAgDQogICAgQ2hlZXJzLCBQaGlsDQogICAgDQoNCg==
