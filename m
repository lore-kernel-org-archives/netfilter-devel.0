Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F6BC3F68F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 17:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5126320661
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 17:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="HPoWADDG";
	dkim=pass (1024-bit key) header.d=cisco.onmicrosoft.com header.i=@cisco.onmicrosoft.com header.b="zm69U7EV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfLDRte (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:49:34 -0500
Received: from alln-iport-8.cisco.com ([173.37.142.95]:54745 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfLDRtd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 12:49:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4052; q=dns/txt; s=iport;
  t=1575481772; x=1576691372;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v+5e0Vo3JfSl4rmSJ67X4NTSDyLOy+Mm5u6x1xUq3mQ=;
  b=HPoWADDG3kkaAFE4ImmxhI5+RzYBn6CgvO9mlcHpbIb6tlMGtwYXN/G8
   +njP+DJUoVmxVdW2k+WQ3rVUifqAaskmt/QHCT/gTOWXxlRZfUkdQnkA/
   YfJlnqKWwHU2HR3AKWfbECcEM3OvFgc8whAuDV2z94YFhjzVRzlfRrHyT
   s=;
IronPort-PHdr: =?us-ascii?q?9a23=3AQ+LkdBSFc64cwif//zmQ47XWE9psv++ubAcI9p?=
 =?us-ascii?q?oqja5Pea2//pPkeVbS/uhpkESXBNfA8/wRje3QvuigQmEG7Zub+FE6OJ1XH1?=
 =?us-ascii?q?5g640NmhA4RsuMCEn1NvnvOjcwEdZcWUVm13q6KkNSXs35Yg6arw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0ASBwB78Odd/4cNJK1lHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgX6BS1AFgUQgBAsqCoQhg0YDinmCOiWYBIJSA1QJAQEBDAEBLQI?=
 =?us-ascii?q?BAYRAAheBeSQ4EwIDDQEBBAEBAQIBBQRthTcMhVMBAQEDEhERDAEBNwEPAgE?=
 =?us-ascii?q?IGAICJgICAjAVEAIEAQ0FIoMAgkcDLgGmDwKBOIhgdYEygn4BAQWCSoJAGII?=
 =?us-ascii?q?XCYEOKIUcgwiDcxqBQT+BOAwUghc1PoRJF4J5MoIskCGeLQqCLpVaG5omjkq?=
 =?us-ascii?q?aIwIEAgQFAg4BAQWBaSKBWHAVZQGCQVARFIxmg3OKU3SBKI8wAYEPAQE?=
X-IronPort-AV: E=Sophos;i="5.69,278,1571702400"; 
   d="scan'208";a="387017174"
Received: from alln-core-2.cisco.com ([173.36.13.135])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 04 Dec 2019 17:49:31 +0000
Received: from XCH-RCD-012.cisco.com (xch-rcd-012.cisco.com [173.37.102.22])
        by alln-core-2.cisco.com (8.15.2/8.15.2) with ESMTPS id xB4HnVI9017601
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 4 Dec 2019 17:49:31 GMT
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by XCH-RCD-012.cisco.com
 (173.37.102.22) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Dec
 2019 11:49:30 -0600
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-rtp-003.cisco.com
 (64.101.210.230) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Dec
 2019 12:49:29 -0500
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 4 Dec 2019 11:49:29 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2XsntG+3PVJOfczFO858miI4GKxa32nIjQXvBxbRzUtJ3o/Lo5NTw0/HA2kpn/DfrU9Qsq+Ce0r+2wky9iQzIO4Tl77tk3Or3nV48EocCBTfsXWyClL69rmj/L6KCkCCTt1P0Wnz2vcnIs46HiVbrFuME5FDAg1nEoxCqbsHmZzR2N3gayWR7acnOqgxO+Lfw4WHV0L2XnSoMzdnlOU1llSMzEahZtTVhNoeTylyjmgdSCQ3jsDhAAkE2p/4RSkCa9hGjjulBu7dUp+5GTn31yJ3iNzFrgospH1lr0s87CqOffUCq7Vq+kmuZZijJ1te1AVryUFQTVXUjJwPPZJ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+5e0Vo3JfSl4rmSJ67X4NTSDyLOy+Mm5u6x1xUq3mQ=;
 b=oFvriEiAVKLf1NT/S/htRzR+lfDJgIOXhpb6MHC+Ipx3nBT25IbeE3igggmm/WNgWSP8Q+EvAVFnMO+JCMBKTMU+khUfwRnDJKVVNDJXdvwCfDFBYofH4XUpntxXIPiCy0pWLmLzeTyfWzfi8/Y/9EagDo6UaPzqUJ022XLkWuPz5maqYMnPunqISWi0t8rKlCqb2pCvclbwNHgUlco+IvUELVp0PUodhQOETStyrlkmfrRwIhgBfJD+AbaU8PAhWStcdXXNBMkgGGg82J+fVpjI92m6xTWsA6iW8NMAsT8nx5Mber9umjr0HRpu6gt0MIVlzY5nTybxd6B38F5zag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v+5e0Vo3JfSl4rmSJ67X4NTSDyLOy+Mm5u6x1xUq3mQ=;
 b=zm69U7EVqOL6/Vwixua829cGyjMM458PVZwauJagSOncyLTpS9ugz2ueuRHAwIlp71JKfdpHwNSjwjw5dRHwte6hnBhwQ8GKeG/ERv4sxXaWs3ye34CdjifgGqTE3VSjyzbxplsragYZ67sn3qZkYStQHXT6qJo7F7ssOgTDG4w=
Received: from DM5PR11MB1484.namprd11.prod.outlook.com (10.172.36.14) by
 DM5PR11MB1913.namprd11.prod.outlook.com (10.175.87.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 4 Dec 2019 17:49:28 +0000
Received: from DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a]) by DM5PR11MB1484.namprd11.prod.outlook.com
 ([fe80::b8d0:b659:6b84:fa7a%10]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 17:49:28 +0000
From:   "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Phil Sutter <phil@nwl.cc>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Numen with reference to vmap
Thread-Topic: Numen with reference to vmap
Thread-Index: AQHVqj1Ubs5ZA1L3AEmU3M7cfc9ezqepw9GA///mtACAAGztAP//svyAgABX04CAABp3AP//sVOA
Date:   Wed, 4 Dec 2019 17:49:27 +0000
Message-ID: <92609998-F3BF-42A5-AF95-A75AAE941C27@cisco.com>
References: <EC8889A1-27E2-4DC9-B752-514689982085@cisco.com>
 <20191204101819.GN8016@orbyte.nwl.cc>
 <AFC93A41-C4DD-4336-9A62-6B9C6817D198@cisco.com>
 <20191204151738.GR14469@orbyte.nwl.cc>
 <5337E60B-E81D-46ED-912F-196E23C76701@cisco.com>
 <20191204155619.GU14469@orbyte.nwl.cc>
 <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
In-Reply-To: <624cc1ac-126e-8ad3-3faa-f7869f7d2d5b@netfilter.org>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: arturo@netfilter.org
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sbezverk@cisco.com; 
x-originating-ip: [173.38.117.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1aa38d5c-7e4b-4bd7-c71e-08d778e24f1c
x-ms-traffictypediagnostic: DM5PR11MB1913:
x-microsoft-antispam-prvs: <DM5PR11MB1913F943CB9DC0723AC9965BC45D0@DM5PR11MB1913.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(199004)(189003)(66946007)(76116006)(66476007)(11346002)(14444005)(229853002)(86362001)(99286004)(7736002)(478600001)(64756008)(66446008)(66556008)(186003)(316002)(110136005)(2616005)(91956017)(76176011)(58126008)(6436002)(6486002)(25786009)(81166006)(26005)(6246003)(8676002)(81156014)(2906002)(6116002)(102836004)(305945005)(8936002)(3846002)(6512007)(36756003)(53546011)(14454004)(5660300002)(6506007)(71190400001)(33656002)(71200400001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1913;H:DM5PR11MB1484.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8AyxI0SRwZHS8nFZdoCz/rXDhsfxVHf5So62vbL+pcx+E9HpEd8h2wUSAt8jXFdCLky2MMKxHI3QJOhPa84f7kJKW5KeI/wPL8HiKdFDmi4xMIAtg59dB+tOy2GyD2Gf0HecSmZiTgq3dlzPAUR9QW6vu338EOibG5wTWVTgn+6oEI1U/EpGGPZbw/vp7s1U3CvCACqdbeqckVutU9RdzpS+NCRnl3NezYmzTpRvVRMReRn6Mg7y3/O1q08CyNhcz+FwYsBKTwfy0yjsxXidoTNXidlfn9rn6MRp1Vk0td17xZjhHO1W5kr9YCeyAsFC02dXf/kzqL0Rs+IGFH+8MUUk2qY8M9Ko7Zx1r7pYPytOH+W7WInR6s1ogGBxXIA1vszqyKsAZvcBvuqc6ywcmiIq4cdpHrBFeaQXHvgpm8hADbJaeIvcD92HFGJ1KLgF
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B56B21D120BE54480B0334052DC2EA7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa38d5c-7e4b-4bd7-c71e-08d778e24f1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 17:49:27.9963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Tx+Q7pm44ehyHfgAahxUTbX2K0dzyYkgORDGnnc5FVfrM49xmmmw1qW+tE2rklMPN3wgSHyoQ6DLdrlP+bVYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1913
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.22, xch-rcd-012.cisco.com
X-Outbound-Node: alln-core-2.cisco.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8gQFBoaWwsDQoNCkp1c3QgdG8gY29uZmlybSwNCg0KSWYgSSBkbywNCg0KTnVtZ2VuIHJh
bmRvbSBtb2QgMyB2bWFwIHsgMCAgOiAganVtcCBlbmRwb2ludDEsIDEgIDogIGp1bXAgZW5kcG9p
bnQyLCAgMiAgOiAganVtcCBlbmRwb2ludDMgfQ0KDQpUaGVuIGlmIDR0aCBlbmRwb2ludCBhcHBl
YXJzIEkgcmVwbGFjZSB0aGUgcHJldmlvdXMgcnVsZSB3aXRoOg0KDQpOdW1nZW4gcmFuZG9tIG1v
ZCA0IHZtYXAgeyAwICA6ICBqdW1wIGVuZHBvaW50MSwgMSAgOiAganVtcCBlbmRwb2ludDIsIDIg
IDogIGp1bXAgZW5kcG9pbnQzLCAgMyAgOiAganVtcCBlbmRwb2ludDQgfQ0KDQpJdCBzaG91bGQg
ZG8gdGhlIHRyaWNrIG9mIGxvYWRiYWxhbmNpbmcsIHJpZ2h0Pw0KDQpAQXJ0dXJvDQoNCkkgYW0g
bm8gcGxhbm5pbmcgdG8gdXNlICAiIGRuYXQgbnVtZ2VuIHJhbmRtbyB7IDAtNDkgOiA8aXA+Ojxw
b3J0PiB9LiINCg0KRWFjaCBlbmQgcG9pbnQgd2lsbCBoYXZlIGl0IGlzIG93biBjaGFpbiBhbmQg
aXQgd2lsbCB0byBkbmF0IHRvIGlwIGFuZCBzcGVjaWZpYyB0byBlbmRwb2ludCB0YXJnZXQgcG9y
dC4gVGhlIGxvYWQgYmFsYW5jaW5nIHdpbGwgYmUgZG9uZSBpbiBzZXJ2aWNlIGNoYWluIGJldHdl
ZW4gbXVsdGlwbGUgZW5kcG9pbnQgY2hhaW5zLg0KU2VlIGV4YW1wbGUgYWJvdmUuIERvZXMgaXQg
bWFrZSBzZW5zZT8NCg0KVGhhbmsgeW91DQpTZXJndWVpDQoNCu+7v09uIDIwMTktMTItMDQsIDEy
OjMxIFBNLCAiQXJ0dXJvIEJvcnJlcm8gR29uemFsZXoiIDxhcnR1cm9AbmV0ZmlsdGVyLm9yZz4g
d3JvdGU6DQoNCiAgICBPbiAxMi80LzE5IDQ6NTYgUE0sIFBoaWwgU3V0dGVyIHdyb3RlOg0KICAg
ID4gT0ssIHN0YXRpYyBsb2FkLWJhbGFuY2luZyBiZXR3ZWVuIHR3byBzZXJ2aWNlcyAtIG5vIGJp
ZyBkZWFsLiA6KQ0KICAgID4gDQogICAgPiBXaGF0IGhhcHBlbnMgaWYgY29uZmlnIGNoYW5nZXM/
IEkuZS4sIGlmIG9uZSBvZiB0aGUgZW5kcG9pbnRzIGdvZXMgZG93bg0KICAgID4gb3IgYSB0aGly
ZCBvbmUgaXMgYWRkZWQ/IChUaGF0J3MgdGhlIHRoaW5nIHdlJ3JlIGRpc2N1c3NpbmcgcmlnaHQg
bm93LA0KICAgID4gYXJlbid0IHdlPykNCiAgICANCiAgICBpZiB0aGUgbm9uLWFub24gbWFwIGZv
ciByYW5kb20gbnVtZ2VuIHdhcyBhbGxvd2VkLCB0aGVuIG9ubHkgZWxlbWVudHMgd291bGQgbmVl
ZA0KICAgIHRvIGJlIGFkanVzdGVkOg0KICAgIA0KICAgIGRuYXQgbnVtZ2VuIHJhbmRvbSBtb2Qg
MTAwIG1hcCB7IDAtNDkgOiAxLjEuMS4xLCA1MC05OSA6IDIuMi4yLjIgfQ0KICAgIA0KICAgIFlv
dSBjb3VsZCBhbHdheXMgdXNlIG1vZCAxMDAgKG9yIDEwMDAwIGlmIHlvdSB3YW50KSBhbmQganVz
dCBwbGF5IHdpdGggdGhlIG1hcA0KICAgIHByb2JhYmlsaXRpZXMgYnkgdXBkYXRpbmcgbWFwIGVs
ZW1lbnRzLiBUaGlzIGlzIGEgdmFsaWQgdXNlIGNhc2UgSSB0aGluay4NCiAgICBUaGUgbW9kIG51
bWJlciBjYW4ganVzdCBiZSB0aGUgbWF4IG51bWJlciBvZiBhbGxvd2VkIGVuZHBvaW50cyBwZXIg
c2VydmljZSBpbg0KICAgIGt1YmVybmV0ZXMuDQogICAgDQogICAgQFBoaWwsDQogICAgDQogICAg
SSdtIG5vdCBzdXJlIGlmIHRoZSB0eXBlb2YoKSB0aGluZ3kgd2lsbCB3b3JrIGluIHRoaXMgY2Fz
ZSwgc2luY2UgdGhlIGludGVnZXINCiAgICBsZW5ndGggd291bGQgZGVwZW5kIG9uIHRoZSBtb2Qg
dmFsdWUgdXNlZC4NCiAgICBXaGF0IGFib3V0IGludHJvZHVjaW5nIHNvbWV0aGluZyBsaWtlIGFu
IGV4cGxpY2l0IHUxMjggaW50ZWdlciBkYXRhdHlwZS4gUGVyaGFwcw0KICAgIGl0J3MgdXNlZnVs
IGZvciBvdGhlciB1c2UgY2FzZXMgdG9vLi4uDQogICAgDQogICAgQFNlcmd1ZWksDQogICAgDQog
ICAga3ViZXJuZXRlcyBpbXBsZW1lbnRzIGEgY29tcGxleCBjaGFpbiBvZiBtZWNoYW5pc21zIHRv
IGRlYWwgd2l0aCB0cmFmZmljLiBXaGF0DQogICAgaGFwcGVucyBpZiBlbmRwb2ludHMgZm9yIGEg
Z2l2ZW4gc3ZjIGhhdmUgZGlmZmVyZW50IHBvcnRzPyBJIGRvbid0IGtub3cgaWYNCiAgICB0aGF0
J3Mgc3VwcG9ydGVkIG9yIG5vdCwgYnV0IHRoZW4gdGhpcyBhcHByb2FjaCB3b3VsZG4ndCB3b3Jr
IGVpdGhlcjogeW91IGNhbid0DQogICAgdXNlIGRuYXQgbnVtZ2VuIHJhbmRtbyB7IDAtNDkgOiA8
aXA+Ojxwb3J0PiB9Lg0KICAgIA0KICAgIEFsc28sIHdlIGhhdmUgdGhlIG1hc3F1ZXJhZGUvZHJv
cCB0aGluZyBnb2luZyBvbiB0b28sIHdoaWNoIG5lZWRzIHRvIGJlIGRlYWwNCiAgICB3aXRoIGFu
ZCB0aGF0IGN1cnJlbnRseSBpcyBkb25lIGJ5IHlldCBhbm90aGVyIGNoYWluIGp1bXAgKyBwYWNr
ZXQgbWFyay4NCiAgICANCiAgICBJJ20gbm90IHN1cmUgaW4gd2hpY2ggc3RhdGUgb2YgdGhlIGRl
dmVsb3BtZW50IHlvdSBhcmUsIGJ1dCB0aGlzIGlzIG15DQogICAgc3VnZ2VzdGlvbjogVHJ5IHRv
IGRvbid0IG92ZXItb3B0aW1pemUgaW4gdGhlIGZpcnN0IGl0ZXJhdGlvbi4gSnVzdCBnZXQgYQ0K
ICAgIHdvcmtpbmcgbmZ0IHJ1bGVzZXQgd2l0aCB0aGUgZmV3IG9wdGltaXphdGlvbiB0aGF0IG1h
a2Ugc2Vuc2UgYW5kIGFyZSBlYXN5IHRvDQogICAgdXNlIChhbmQgdW5kZXJzdGFuZCkuIEZvciBp
dGVyYXRpb24gIzIgd2UgY2FuIGRvIGJldHRlciBvcHRpbWl6YXRpb25zLCBpbmNsdWRpbmcNCiAg
ICBwYXRjaGluZyBtaXNzaW5nIGZlYXR1cmVzIHdlIG1heSBoYXZlIGluIG5mdGFibGVzLg0KICAg
IEkgcmVhbGx5IHdhbnQgYSBydWxlc2V0IHdpdGggdmVyeSBsaXR0bGUgcnVsZXMsIGJ1dCB3ZSBh
cmUgc3RpbGwgY29tcGFyaW5nIHdpdGgNCiAgICB0aGUgaXB0YWJsZXMgcnVsZXNldC4gSSBzdWdn
ZXN0IHdlIGxlYXZlIHRoZSBoYXJkIG9wdGltaXphdGlvbiBmb3IgYSBsYXRlciBwb2ludA0KICAg
IHdoZW4gd2UgYXJlIGNvbXBhcmluZyBuZnQgdnMgbmZ0IHJ1bGVzZXRzLg0KICAgIA0KDQo=
