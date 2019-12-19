Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B1CC43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 14:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 144D320684
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 14:59:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="mPS9dPy+";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="0aqZRTfk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfLSO7G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 09:59:06 -0500
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:61550 "EHLO
        rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfLSO7G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 09:59:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2308; q=dns/txt; s=iport;
  t=1576767545; x=1577977145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SmoHvWdoYEDcuyb6R5g0a+UehmXeLqHM+XrhT4EfdqY=;
  b=mPS9dPy+g4PGz6vMqv7O61Znrmf35ExES6oXotyxELq7QscsRe+0xe94
   J2RiMl5q2VMnI/BoSfzCmsMp3+fBOR2WyMPk74OhTGppRA5wfolgzDY4X
   WP2FykKGtjfAeHyhgIX4PuuHgAIQjHfKodIi/PMN04YbTVVdPauJ4+ovW
   w=;
IronPort-PHdr: =?us-ascii?q?9a23=3AkuTP5xSi260zTBnOuexUt+6Zg9psv++ubAcI9p?=
 =?us-ascii?q?oqja5Pea2//pPkeVbS/uhpkESXBNfA8/wRje3QvuigQmEG7Zub+FE6OJ1XH1?=
 =?us-ascii?q?5g640NmhA4RsuMCEn1NvnvOjcwEdZcWUVm13q6KkNSXs35Yg6arw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AUAABMj/td/4MNJK1lGgEBAQEBAQE?=
 =?us-ascii?q?BAQMBAQEBEQEBAQICAQEBAYFqAwEBAQELAYFMUAWBRCAECyoKg3yDRgOKdIJ?=
 =?us-ascii?q?fmAiBLoEkA1QJAQEBDAEBLQIBAYRAAheCBSQ2Bw4CAw0BAQQBAQECAQUEbYU?=
 =?us-ascii?q?3DIVeAQEBAQIBEhERDAEBNwEPAgEIGAICJgICAjAVEAIEAQ0FIoMAgkcDDiA?=
 =?us-ascii?q?BoWcCgTiIYXWBMoJ+AQEFhR0YggwJgQ4oAYwYGoFBP4E4IIJMPoRJF4J5MoI?=
 =?us-ascii?q?sjTSDA484jyAKgjSWGBuCQ5gOjlFfZ5kLAgQCBAUCDgEBBYFZBiyBWHAVZQG?=
 =?us-ascii?q?CQVAYDY0SDBeDUIpTdIEojl4BgQ8BAQ?=
X-IronPort-AV: E=Sophos;i="5.69,332,1571702400"; 
   d="scan'208";a="673700428"
Received: from alln-core-1.cisco.com ([173.36.13.131])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 19 Dec 2019 14:59:04 +0000
Received: from XCH-RCD-006.cisco.com (xch-rcd-006.cisco.com [173.37.102.16])
        by alln-core-1.cisco.com (8.15.2/8.15.2) with ESMTPS id xBJEx2qU006280
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 19 Dec 2019 14:59:03 GMT
Received: from xhs-aln-003.cisco.com (173.37.135.120) by XCH-RCD-006.cisco.com
 (173.37.102.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Dec
 2019 08:59:02 -0600
Received: from xhs-aln-002.cisco.com (173.37.135.119) by xhs-aln-003.cisco.com
 (173.37.135.120) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Dec
 2019 08:59:02 -0600
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-002.cisco.com (173.37.135.119) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 19 Dec 2019 08:59:02 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oo9uLMl62pEj2XdY3cOVn6u1jX0pPOvBW/FsWTz1YN2TwbO3G40NLny0qM1MibBJB9Bbt7IY/C5jH09VDeqnAT+KmIsslW+WoD3d+iI2eWgcVRUiNymYs3ttNfDS89D6MvoVlotMyEHKDrjadWPg3bFIrfM2eFhBfleQ8OMw1/sXIv4NHVndMouGngI5f/ssMrlwsxAFQcTn5uT8TvR0kVFR6ZLoHYk/DAaWuCsMZgrqjSWJuqpbyQOFjnMoSzPWNXKDaTMeIr5+ownF8sgHuazrHF5JpgS9Sbdl8VQrLBFCkNPtKsNgAqpLlzoif/mLdUuMds+USd77c9BXCZZaZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmoHvWdoYEDcuyb6R5g0a+UehmXeLqHM+XrhT4EfdqY=;
 b=Yi9a4ZMW4ZjjKMfALGfUD+2OoU4vqp80O6u06Zs1oGLAiuE7Qn+exPxbyPGBCS9A53SpFgisi1DI291/1plnYGDtixOsJaBccjhUqoVYgDNXakNFMILqg3/UUvDS4ZyfYXnJ1vjmg6Pv49xwzyYcKq6Bj9zdG/JJbrrs19wAp1ZX3/rryeDscYjk+Knes8kiFOqgw6KVwmwqquBlLvF+eNv3LJ1MuD2MH40UFWqYpTM5GNRGi1cT+GEnceQ+FhuudiBPKUj62/mQvLvCcjws+L7jgI9K4Le0U4f6mssVJYZKeXu0v44S3XZh00g8dY7YtKGJqkXtVH8D8Ku19fvORg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmoHvWdoYEDcuyb6R5g0a+UehmXeLqHM+XrhT4EfdqY=;
 b=0aqZRTfkQxbjkLvbmXAZxof9SFkIG5Uh/TqjsgDSB50Tv4l36fH0Pj7Hho4kPEVsLiEo+oybPACFdgiOIgxtZIX7Td0CNI0II2yP9UoSEMZKq6NpYeNBCyxgS+9zmwpqG+2GwlLyskWHzVuCwzJD+/ZVtw44AunDkVzYst9wST4=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB1369.namprd11.prod.outlook.com (10.168.104.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Thu, 19 Dec 2019 14:59:01 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::e1fe:e33a:f856:7c26%10]) with mapi id 15.20.2538.022; Thu, 19 Dec
 2019 14:59:01 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Phil Sutter <phil@nwl.cc>, Laura Garcia <nevola@gmail.com>
CC:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyAgABX04CAABp3AIAAVCiAgBKu9ACAARbtgP//xyeAAA/qeAAAKIIrgAALSEoA///THgCAAFfMAIAA+MQA///yJwA=
Date:   Thu, 19 Dec 2019 14:59:01 +0000
Message-ID: <F1A3EFFB-7C17-4AC1-B543-C4789F2418A9@cisco.com>
References: <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
 <20191204223215.GX14469@orbyte.nwl.cc>
 <98A8233C-1A83-44A1-A122-6F80212D618F@cisco.com>
 <20191217122925.GD8553@orbyte.nwl.cc>
 <C5103001-881F-46A8-8738-EC8F8117FAE6@cisco.com>
 <20191217164140.GE8553@orbyte.nwl.cc>
 <6F72FC38-4238-4CCC-BAEB-A7F4B07817D7@cisco.com>
 <20191218172436.GA24932@orbyte.nwl.cc>
 <36EA0652-C146-4ED4-A004-2D729AB69BA7@cisco.com>
 <CAF90-Whnsiw=kEGyYroERYwo+_E2vWEv_3RtT89oSbp-9xoc1A@mail.gmail.com>
 <20191219104834.GD24932@orbyte.nwl.cc>
In-Reply-To: <20191219104834.GD24932@orbyte.nwl.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.20.0.191208
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c57d9a82-1276-41cb-e520-08d78493fbbb
x-ms-traffictypediagnostic: DM5PR11MB1369:
x-microsoft-antispam-prvs: <DM5PR11MB13695797999A837A45B5F7FCC4520@DM5PR11MB1369.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(136003)(346002)(39860400002)(199004)(189003)(478600001)(316002)(26005)(6512007)(110136005)(54906003)(2616005)(8676002)(81156014)(8936002)(33656002)(81166006)(66946007)(4326008)(5660300002)(64756008)(66446008)(2906002)(6486002)(53546011)(91956017)(6506007)(71200400001)(36756003)(66476007)(186003)(4001150100001)(76116006)(86362001)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1369;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iHe/lfKnf8V4lJfmiv6BpdBNEokdCHr3bbslTBubLGxub4YnvsP8Y7uecq4lW61aGYo87/rB0+eX5PrsOciKE4/p6mlJDGRogV8Id/3o+3LObsxxnOBkCIamX2862YfIZXrwWDYsIcs4K2kYu6/xPgRpjgfaOWYEwts7Ak/KIrvgv6q0fUw4sTdf11c6XkZ1pPcWl1fDEgNmsnT3ng3ujBVNX9y/0yLsiJviXwYjNtkWnh18baw/IF3HVvPTUmuJowCRIhAEF/2XZAuneQKZa0hE8ivZkftsiVqztkVEUKrieH0F97qu3qpcIDNeIcof1FwEA46/Zq4ITcot3/bnfgjVulE+jz/bnGFCQMDeNmxXJjBhAZeQXT1/oDITAIGdjVQ11hK5Oq5215ltYwynYKFFaoNg2MOOucz3/BG0lAevX07wl99UmFCdFbvAGAiH
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BB31F548445F74180F2C448BCC3B33C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c57d9a82-1276-41cb-e520-08d78493fbbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 14:59:01.2639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QDqw6vrAQKLfNzClt2x24pxWc1BCmqO1FzK+wXZx5/kp6CdgxSEWBox44yMwBmluSFtcjPcN0qXT3kD7QGHU2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1369
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.16, xch-rcd-006.cisco.com
X-Outbound-Node: alln-core-1.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGkgUGhpbCwNCg0KTm90IHN1cmUgd2h5LCBidXQgZXZlbiB3aXRoIDAuOS4yICJ0aCIgZXhwcmVz
c2lvbiBpcyBub3QgcmVjb2duaXplZC4NCg0KZXJyb3I6IHN5bnRheCBlcnJvciwgdW5leHBlY3Rl
ZCB0aA0KYWRkIHJ1bGUgaXB2NHRhYmxlIGs4cy1maWx0ZXItc2VydmljZXMgaXAgcHJvdG9jb2wg
LiBpcCBkYWRkciAuIHRoIGRwb3J0IHZtYXAgQG5vLWVuZHBvaW50cy1zZXJ2aWNlcw0KICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5eDQpzYmV6dmVya0Bk
ZXYtdWJ1bnR1LTE6bWltaWMtZmlsdGVyJCBzdWRvIG5mdCAtdmVyc2lvbg0KbmZ0YWJsZXMgdjAu
OS4yIChTY3JhbSkNCnNiZXp2ZXJrQGRldi11YnVudHUtMTptaW1pYy1maWx0ZXIkDQoNCkl0IHNl
ZW1zIDAuOS4zIGlzIG91dCBidXQgc3RpbGwgbm8gRGViaWFuIHBhY2thZ2UuIElzIGl0IHBvc3Np
YmxlIGl0IGRpZCBub3QgbWFrZSBpdCBpbnRvIDAuOS4yPw0KDQpUaGFuayB5b3UNClNlcmd1ZWkN
Cg0K77u/T24gMjAxOS0xMi0xOSwgNTo0OCBBTSwgIm4wLTFAb3JieXRlLm53bC5jYyBvbiBiZWhh
bGYgb2YgUGhpbCBTdXR0ZXIiIDxuMC0xQG9yYnl0ZS5ud2wuY2Mgb24gYmVoYWxmIG9mIHBoaWxA
bndsLmNjPiB3cm90ZToNCg0KICAgIEhpLA0KICAgIA0KICAgIE9uIFdlZCwgRGVjIDE4LCAyMDE5
IGF0IDA4OjU4OjEyUE0gKzAxMDAsIExhdXJhIEdhcmNpYSB3cm90ZToNCiAgICA+IE9uIFdlZCwg
RGVjIDE4LCAyMDE5IGF0IDg6NDQgUE0gU2VyZ3VlaSBCZXp2ZXJraGkgKHNiZXp2ZXJrKQ0KICAg
ID4gPHNiZXp2ZXJrQGNpc2NvLmNvbT4gd3JvdGU6DQogICAgPiA+DQogICAgPiA+IEVycm9yOiBz
eW50YXggZXJyb3IsIHVuZXhwZWN0ZWQgdGgNCiAgICA+ID4NCiAgICA+ID4gYWRkIHJ1bGUgaXB2
NHRhYmxlIGs4cy1maWx0ZXItc2VydmljZXMgaXAgcHJvdG9jb2wgLiBpcCBkYWRkciAuIHRoIGRw
b3J0IHZtYXAgQG5vLWVuZHBvaW50cy1zZXJ2aWNlcw0KICAgID4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXl4NCiAgICA+IA0KICAgIA0KICAgIFRo
ZSB0aCBoZWFkZXIgZXhwcmVzc2lvbiBpcyBhdmFpbGFibGUgc2luY2UgdjAuOS4yLCB5b3UnbGwg
aGF2ZSB0bw0KICAgIHVwZGF0ZSBuZnRhYmxlcyB0byB1c2UgaXQuDQogICAgDQogICAgPiBUcnkg
dGhpczoNCiAgICA+IA0KICAgID4gLi4uIEB0aCBkcG9ydCB2bWFwIC4uLg0KICAgIA0KICAgIFdy
b25nIHN5bnRheC4NCiAgICANCiAgICA+IG9yDQogICAgPiANCiAgICA+IC4uLiBAdGgsMTYsMTYg
dm1hcCAuLi4NCiAgICANCiAgICBUaGlzIG5vdCB3b3JraW5nIGluIGNvbmNhdGVuYXRpb25zIHdh
cyBvbmUgb2YgRmxvcmlhbidzIG1vdGl2YXRpb25zIHRvDQogICAgaW1wbGVtZW50IHRoIGV4cHJl
c3Npb24sIHNlZSBhNDNhNjk2NDQzYTE1ICgicHJvdG86IGFkZCBwc2V1ZG8gdGgNCiAgICBwcm90
b2NvbCB0byBtYXRjaCBkL3Nwb3J0IGluIGdlbmVyaWMgd2F5IikgZm9yIGRldGFpbHMuIDopDQog
ICAgDQogICAgQ2hlZXJzLCBQaGlsDQogICAgDQoNCg==
