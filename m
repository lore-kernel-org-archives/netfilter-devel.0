Return-Path: <SRS0=SAea=2Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC7FC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jan 2020 12:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C79A215A4
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jan 2020 12:30:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="OzPWzyrT";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="PmtD3YFR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgADMaZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Jan 2020 07:30:25 -0500
Received: from rcdn-iport-6.cisco.com ([173.37.86.77]:35786 "EHLO
        rcdn-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgADMaY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Jan 2020 07:30:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4706; q=dns/txt; s=iport;
  t=1578141023; x=1579350623;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XbdWMNs/NFLIQSybfpsXhf/ROrKByFl/kg6lTjE5iMI=;
  b=OzPWzyrTDQSRF9VQdkujzB90V+HTjEbVdMpj9AYlWiotxifGG2NSOqwF
   uwgdnE0jFmTtMwpUVjieHPN3DeMLVOdj+iEDD2tTBqWQVEFG8vZE9Ze53
   xbP7jF2kleJJ7MblwB4m7ZJnQeOX9WPaN25IPVggpxsGEi1SweygrfjNd
   A=;
IronPort-PHdr: =?us-ascii?q?9a23=3A+jMC6R8CeYAGV/9uRHGN82YQeigqvan1NQcJ65?=
 =?us-ascii?q?0hzqhDabmn44+8ZR7E/fs4iljPUM2b8P9Ch+fM+4HYEW0bqdfk0jgZdYBUER?=
 =?us-ascii?q?oMiMEYhQslVdWPBF/lIeTpRyc7B89FElRi+iLzPA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BwAABxhBBe/5xdJa1mGwEBAQEBAQE?=
 =?us-ascii?q?FAQEBEQEBAwMBAQGBawMBAQELAYFTUAWBRCAECyoKg3+DRgOLAYJfmA2CUgN?=
 =?us-ascii?q?UCQEBAQwBAS0CAQGEQAIXgVIkNwYOAgMNAQEEAQEBAgEFBG2FNwyFXwEBAQM?=
 =?us-ascii?q?SEREMAQE3AQ8CAQgYAgImAgICMBUQAgQBDQUigwCCRwMuAQKhFQKBOIhhdYE?=
 =?us-ascii?q?ygn4BAQWFDBiCDAmBDigBhRyGfBqBQT+BOCCCTD6EYIJ5MoIsjU0JgmiPOo8?=
 =?us-ascii?q?lCoI2hk6PTBuWGYRCjlOaWQIEAgQFAg4BAQWBaCOBWHAVOyoBgkFQGA2NEgw?=
 =?us-ascii?q?Xg1CKU3SBKIxiAYEPAQE?=
X-IronPort-AV: E=Sophos;i="5.69,394,1571702400"; 
   d="scan'208";a="696911040"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 04 Jan 2020 12:30:23 +0000
Received: from XCH-ALN-010.cisco.com (xch-aln-010.cisco.com [173.36.7.20])
        by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPS id 004CUMBU029481
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Sat, 4 Jan 2020 12:30:22 GMT
Received: from xhs-aln-002.cisco.com (173.37.135.119) by XCH-ALN-010.cisco.com
 (173.36.7.20) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 4 Jan
 2020 06:30:22 -0600
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by xhs-aln-002.cisco.com
 (173.37.135.119) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 4 Jan
 2020 06:30:21 -0600
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-001.cisco.com (173.37.227.246) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 4 Jan 2020 06:30:21 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1n832zqCAggmYlWCe42bknMz8C+2teKQrPFPiuGk1X2eG0gTgdU8UreKo1SKShayB0muBfzpt+4LNhcvTaJSRrF+g4X3h/Ci+qu9t6czoq1KvUJYe4SbrX0xj6jkz3bxOcYCaiULzN7heZV7ThbbfkkGzGk667G3oU4sIGud25A5yPOMjk0UITdP3xyIpmtfrP6RojUkjqTreU/F86v2zj4ghTVCTEG8mpY7sfnW01nkQgQYPjNtggMgJw+Z8dl5bfuIjd5w5sZScr421/5DBCTf8OwDz10bK2spdmSP2dqcd87SjtYWr6IzvmZH4U3oA+V+h/3Bn32E3Boi9Osvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbdWMNs/NFLIQSybfpsXhf/ROrKByFl/kg6lTjE5iMI=;
 b=cz1q3FjR+tZ+SqmPv1Q5slkL73P98WOgLbdeFstCCHnI/zTHia4pWIf/LZIXkS4arD9T1ZtK46fje5mP8KmkMSx5TEph98SeLVZ+lvnT1UxvlOpVpIpvG9ftiVbvLvSrbif0kMG2QUAnzNXe15JGWcwQHQEDKeZKwn/Myzi3AUls4zhlOVI3VgEmWRiMLPWxhhWiC6aJxnxG1n5UmHd6FgDEFjeyh3+Mpb2/80H2RcOefTQeYiNgihCzxnMMgOVd1LOYs0o89q2TLSOHaw+7ITJWL5GNy0h+uHxtXWeqbZH+Op6wRmZcxRaOeZ0ZsuvmqAxRovEZGGWgbVsa/nNWUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XbdWMNs/NFLIQSybfpsXhf/ROrKByFl/kg6lTjE5iMI=;
 b=PmtD3YFRGsueEiybh9501VrL87LPtjBN+G1sfj15nntBUVqyQGzeO52DTHVDCeicusQfkih68ypG4LZMF4ZBQShOEUrMXbH2kfaBbtP/WqxFObGocfLb8hzBSaGUEqkVW2h3QGzDSE7qmapLToMlNRPIDf69sfqN6YpEGExP4EA=
Received: from MN2PR11MB3598.namprd11.prod.outlook.com (20.178.252.28) by
 MN2PR11MB3600.namprd11.prod.outlook.com (20.178.254.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Sat, 4 Jan 2020 12:30:21 +0000
Received: from MN2PR11MB3598.namprd11.prod.outlook.com
 ([fe80::e526:356d:d654:f135]) by MN2PR11MB3598.namprd11.prod.outlook.com
 ([fe80::e526:356d:d654:f135%7]) with mapi id 15.20.2602.012; Sat, 4 Jan 2020
 12:30:20 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
CC:     Laura Garcia <nevola@gmail.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyAgABX04CAABp3AIAAVCiAgBKu9ACAARbtgP//xyeAAA/qeAAAKIIrgAALSEoA///THgCAAFfMAIAA+MQA///yJwCAAGDPAP//sEKAgAAm64CAGMPHAA==
Date:   Sat, 4 Jan 2020 12:30:20 +0000
Message-ID: <956496D2-40AA-41B2-876B-342AA9B1F851@cisco.com>
References: <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
 <20191217122925.GD8553@orbyte.nwl.cc>
 <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
 <20191217164140.GE8553@orbyte.nwl.cc>
 <6F72FC38-4238-4CCC-BAEB-A7F4B07817D7@cisco.com>
 <20191218172436.GA24932@orbyte.nwl.cc>
 <36EA0652-C146-4ED4-A004-2D729AB69BA7@cisco.com>
 <CAF90-Whnsiw=kEGyYroERYwo+_E2vWEv_3RtT89oSbp-9xoc1A@mail.gmail.com>
 <20191219104834.GD24932@orbyte.nwl.cc>
 <F1A3EFFB-7C17-4AC1-B543-C4789F2418A9@cisco.com>
 <20191219154530.GB30413@orbyte.nwl.cc>
 <F56E73D4-3A7E-4CCE-AEA4-C867CC11A08B@cisco.com>
 <6E35A7A0-481D-40B6-A504-04EF0A2DEDA2@cisco.com>
In-Reply-To: <6E35A7A0-481D-40B6-A504-04EF0A2DEDA2@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.20.0.191208
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.79]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7a5647b-62ed-4bc1-090a-08d79111dd51
x-ms-traffictypediagnostic: MN2PR11MB3600:
x-microsoft-antispam-prvs: <MN2PR11MB36000007936EDB5C972EB92EC4220@MN2PR11MB3600.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02723F29C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(39860400002)(396003)(136003)(189003)(199004)(4001150100001)(316002)(54906003)(71200400001)(478600001)(4326008)(81156014)(8676002)(81166006)(8936002)(5660300002)(6512007)(6486002)(110136005)(36756003)(33656002)(26005)(186003)(2616005)(86362001)(6506007)(66556008)(66946007)(76116006)(66446008)(2906002)(66476007)(64756008)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3600;H:MN2PR11MB3598.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cxcB2AjdEBa6ZhLkZ62nZvioM/hWEu2D+bLGM2DvDNUhAZqLSM6Z+oLGkYOmd5yqw08QWzNqokrbVYUuOUHgxX4WuAdQ/8KLyx+7bd5UlCOE1Zs12i/LI3awdEO97nSERJ/dErYcEzEUZTdmVx1FMyuDcvepcJtlJenPLVaTl3qAmIzBzs/u6yhqqNJ5k3rL6Z/QiQnAch/NR+kd6762Y5Mbh5OLjhG9tkuGzgszpaVZH5il2dJcDpumu4CWTRliW4CHhGicpi61Dn5ykH5PfJAZgst4ktj0q2SNMVkRtm4E+9BxCm1qUpaLBIBTJw4MUxDgEPTO464UlystLn9ZowDdgpBHdX5sTkP/w1xdQLuRSmmC6fWJkesLMsa9FXArfn92V/DlJThHRAtMSIa1QYfFj1BzRH53tYsp2+Vb92kJyp3dJfuji+0YHUoqPN/6
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C79E62DF20A144194B00A99B54240E1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a5647b-62ed-4bc1-090a-08d79111dd51
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2020 12:30:20.7302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n/9U6/Aj+dYjGb6US4O4TVh107oJUlzrDZo/P/XA2jX/u62wmtJ1VkaPDQrL9yclSfM4frrWMTiy86y7QXrhJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3600
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.20, xch-aln-010.cisco.com
X-Outbound-Node: rcdn-core-5.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8sDQoNCkhhcHB5IE5ldyBZZWFyIQ0KDQpJIHdhcyB3b25kZXJpbmcgaWYgdGhlcmUgaXMg
YSBjaGFuY2UgdG8gZml4IHRoZSBpc3N1ZSByZXBvcnRlZCBiZWxvdy4gV2l0aCB0aGlzIHR5cGUg
b2Ygdm1hcCwga3ViZS1wcm94eSdzIHJ1bGVzIGNvdWxkIGJlIGdyb3VwZWQgdG9nZXRoZXIgdG8g
bWFrZSB0aGVtICBtb3JlIGVmZmljaWVudC4NCg0KVGhhbmsgeW91DQpTZXJndWVpDQoNCu+7v09u
IDIwMTktMTItMTksIDE6MTkgUE0sICJTZXJndWVpIEJlenZlcmtoaSAoc2JlenZlcmspIiA8c2Jl
enZlcmtAY2lzY28uY29tPiB3cm90ZToNCg0KICAgIFdoaWxlIHRyeWluZyB0byBhZGQgYW4gZWxl
bWVudCB0byB0aGUgc2V0LCBJIGFtIGdldHRpbmcgZXJyb3I6DQogICAgDQogICAgc3VkbyBuZnQg
LS1kZWJ1ZyBhbGwgYWRkIGVsZW1lbnQgaXB2NHRhYmxlIG5vLWVuZHBvaW50cy1zZXJ2aWNlcyAg
eyB0Y3AgLiAxOTIuMTY4LjgwLjEwNCAuIDg5ODkgOiBnb3RvIGRvX3JlamVjdCB9DQogICAgDQog
ICAgRXJyb3I6IENvdWxkIG5vdCBwcm9jZXNzIHJ1bGU6IEludmFsaWQgYXJndW1lbnQNCiAgICBh
ZGQgZWxlbWVudCBpcHY0dGFibGUgbm8tZW5kcG9pbnRzLXNlcnZpY2VzIHsgdGNwIC4gMTkyLjE2
OC44MC4xMDQgLiA4OTg5IDogZ290byBkb19yZWplY3QgfQ0KICAgIF5eXl5eXl5eXl5eXl5eXl5e
Xl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5e
Xl5eXl5eXl5eXl5eXl5eXl5eXg0KICAgIEFueXRoaW5nIGFtIEkgZG9pbmcgd3Jvbmc/DQogICAg
VGhhbmsgeW91DQogICAgU2VyZ3VlaQ0KICAgIA0KICAgIE9uIDIwMTktMTItMTksIDExOjAwIEFN
LCAiU2VyZ3VlaSBCZXp2ZXJraGkgKHNiZXp2ZXJrKSIgPHNiZXp2ZXJrQGNpc2NvLmNvbT4gd3Jv
dGU6DQogICAgDQogICAgICAgIEhJIFBoaWwsDQogICAgICAgIA0KICAgICAgICBJIGJ1aWx0IDAu
OS4zIGFuZCBub3cgaXQgcmVjb2duaXplcyAidGgiLCBidXQgdGhlcmUgaXMgSSBzdXNwZWN0IGEg
Y29zbWV0aWMgaXNzdWUgaW4gdGhlIG91dHB1dCBpbiBuZnQgY2xpLiBTZWUgYmVsb3cgdGhlIGNv
bW1hbmQgSSB1c2VkOg0KICAgICAgICBzdWRvIG5mdCAtLWRlYnVnIGFsbCBhZGQgcnVsZSBpcHY0
dGFibGUgazhzLWZpbHRlci1zZXJ2aWNlcyBpcCBwcm90b2NvbCAuIGlwIGRhZGRyIC4gdGggZHBv
cnQgdm1hcCBAbm8tZW5kcG9pbnRzLXNlcnZpY2VzDQogICAgICAgIA0KICAgICAgICBJdCBsb29r
cyBsaWtlIGNvcnJlY3RseSBnZW5lcmF0aW5nIGV4cHJlc3Npb25zOg0KICAgICAgICANCiAgICAg
ICAgaXAgaXB2NHRhYmxlIGs4cy1maWx0ZXItc2VydmljZXMgDQogICAgICAgICAgWyBwYXlsb2Fk
IGxvYWQgMWIgQCBuZXR3b3JrIGhlYWRlciArIDkgPT4gcmVnIDEgXQ0KICAgICAgICAgIFsgcGF5
bG9hZCBsb2FkIDRiIEAgbmV0d29yayBoZWFkZXIgKyAxNiA9PiByZWcgOSBdDQogICAgICAgICAg
WyBwYXlsb2FkIGxvYWQgMmIgQCB0cmFuc3BvcnQgaGVhZGVyICsgMiA9PiByZWcgMTAgXQ0KICAg
ICAgICAgIFsgbG9va3VwIHJlZyAxIHNldCBuby1lbmRwb2ludHMtc2VydmljZXMgZHJlZyAwIF0N
CiAgICAgICAgDQogICAgICAgIEJ1dCB3aGVuIEkgcnVuICJzdWRvIG5mdCBsaXN0IHRhYmxlcyBp
cHY0dGFibGUiIHRoZSBydWxlIGlzIG1pc3NpbmcgdGhpcmQgcGFyYW1ldGVyLg0KICAgICAgICAN
CiAgICAgICAgdGFibGUgaXAgaXB2NHRhYmxlIHsNCiAgICAgICAgCW1hcCBuby1lbmRwb2ludHMt
c2VydmljZXMgew0KICAgICAgICAJCXR5cGUgaW5ldF9wcm90byAuIGlwdjRfYWRkciAuIGluZXRf
c2VydmljZSA6IHZlcmRpY3QNCiAgICAgICAgCX0NCiAgICAgICAgDQogICAgICAgIAljaGFpbiBr
OHMtZmlsdGVyLXNlcnZpY2VzIHsNCiAgICAgICAgCQlpcCBwcm90b2NvbCAuIGlwIGRhZGRyIHZt
YXAgQG5vLWVuZHBvaW50cy1zZXJ2aWNlcyAgICAgICAgICAgIDwgLS0tLS0tLS0tLS0tLS0tLS0t
LSBNaXNzaW5nICIgdGggZHBvcnQiDQogICAgICAgIAl9DQogICAgICAgIH0NCiAgICAgICAgDQog
ICAgICAgIEl0IHNlZW1zIGp1c3QgYSBjb3NtZXRpYyB0aGluZywgYnV0IGV2ZW50dWFsbHkgd291
bGQgYmUgbmljZSB0byBoYXZlIGl0IGZpeGVkLCBpZiBpdCBoYXMgbm90IGJlZW4gYWxyZWFkeSBp
biB0aGUgbWFzdGVyIGJyYW5jaC4gSSBhbSB1c2luZyB2MC45LjMgYnJhbmNoLg0KICAgICAgICAN
CiAgICAgICAgVGhhbmsgeW91DQogICAgICAgIFNlcmd1ZWkNCiAgICAgICAgT24gMjAxOS0xMi0x
OSwgMTA6NDYgQU0sICJuMC0xQG9yYnl0ZS5ud2wuY2Mgb24gYmVoYWxmIG9mIFBoaWwgU3V0dGVy
IiA8bjAtMUBvcmJ5dGUubndsLmNjIG9uIGJlaGFsZiBvZiBwaGlsQG53bC5jYz4gd3JvdGU6DQog
ICAgICAgIA0KICAgICAgICAgICAgSGksDQogICAgICAgICAgICANCiAgICAgICAgICAgIE9uIFRo
dSwgRGVjIDE5LCAyMDE5IGF0IDAyOjU5OjAxUE0gKzAwMDAsIFNlcmd1ZWkgQmV6dmVya2hpIChz
YmV6dmVyaykgd3JvdGU6DQogICAgICAgICAgICA+IE5vdCBzdXJlIHdoeSwgYnV0IGV2ZW4gd2l0
aCAwLjkuMiAidGgiIGV4cHJlc3Npb24gaXMgbm90IHJlY29nbml6ZWQuDQogICAgICAgICAgICA+
IA0KICAgICAgICAgICAgPiBlcnJvcjogc3ludGF4IGVycm9yLCB1bmV4cGVjdGVkIHRoDQogICAg
ICAgICAgICA+IGFkZCBydWxlIGlwdjR0YWJsZSBrOHMtZmlsdGVyLXNlcnZpY2VzIGlwIHByb3Rv
Y29sIC4gaXAgZGFkZHIgLiB0aCBkcG9ydCB2bWFwIEBuby1lbmRwb2ludHMtc2VydmljZXMNCiAg
ICAgICAgICAgID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIF5eDQogICAgICAgICAgICA+IHNiZXp2ZXJrQGRldi11YnVudHUtMTptaW1pYy1maWx0ZXIk
IHN1ZG8gbmZ0IC12ZXJzaW9uDQogICAgICAgICAgICA+IG5mdGFibGVzIHYwLjkuMiAoU2NyYW0p
DQogICAgICAgICAgICA+IHNiZXp2ZXJrQGRldi11YnVudHUtMTptaW1pYy1maWx0ZXIkDQogICAg
ICAgICAgICA+IA0KICAgICAgICAgICAgPiBJdCBzZWVtcyAwLjkuMyBpcyBvdXQgYnV0IHN0aWxs
IG5vIERlYmlhbiBwYWNrYWdlLiBJcyBpdCBwb3NzaWJsZSBpdCBkaWQgbm90IG1ha2UgaXQgaW50
byAwLjkuMj8NCiAgICAgICAgICAgIA0KICAgICAgICAgICAgTm90IHN1cmUgd2hhdCdzIG1pc3Np
bmcgb24geW91ciBlbmQuIEkgY2hlY2tlZCAwLjkuMiB0YXJiYWxsLCBhdCBsZWFzdA0KICAgICAg
ICAgICAgcGFyc2VyIHNob3VsZCB1bmRlcnN0YW5kIHRoZSBzeW50YXguDQogICAgICAgICAgICAN
CiAgICAgICAgICAgIENoZWVycywgUGhpbA0KICAgICAgICAgICAgDQogICAgICAgIA0KICAgICAg
ICANCiAgICANCiAgICANCg0K
