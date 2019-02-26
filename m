Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FB4C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 09:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1EEF2173C
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 09:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfBZJUv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:20:51 -0500
Received: from mx20.baidu.com ([111.202.115.85]:38717 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbfBZJUv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 04:20:51 -0500
Received: from M1-MAIL-EX03.internal.baidu.com (unknown [10.44.83.52])
        by Forcepoint Email with ESMTPS id 1E8B6183A50E1;
        Tue, 26 Feb 2019 17:20:43 +0800 (CST)
Received: from BC-Mail-Ex13.internal.baidu.com (172.31.40.49) by
 M1-MAIL-EX03.internal.baidu.com (10.44.83.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Tue, 26 Feb 2019 17:20:44 +0800
Received: from BC-Mail-Ex13.internal.baidu.com (172.31.40.49) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.40.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Tue, 26 Feb 2019 17:20:44 +0800
Received: from BC-Mail-Ex13.internal.baidu.com ([172.31.40.49]) by
 Bc-Mail-Ex13.internal.baidu.com ([172.31.40.49]) with mapi id 15.01.1531.010;
 Tue, 26 Feb 2019 17:20:44 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogtPC4tDogtPC4tDogW1BBVENIXVtuZi1uZXh0XSBuZXRmaWx0ZXI6?=
 =?gb2312?Q?_replace_modulo_operation_with_bitwise_AND?=
Thread-Topic: =?gb2312?B?tPC4tDogtPC4tDogW1BBVENIXVtuZi1uZXh0XSBuZXRmaWx0ZXI6IHJlcGxh?=
 =?gb2312?Q?ce_modulo_operation_with_bitwise_AND?=
Thread-Index: AQHUzP0C+daqTE6OsEGa7BAHFYpRr6XwYOjg//+AnQCAAWQhIP//1CaAgAC1HkA=
Date:   Tue, 26 Feb 2019 09:20:43 +0000
Message-ID: <c665c8af350047278fed60301ab85948@baidu.com>
References: <1551093361-2150-1-git-send-email-lirongqing@baidu.com>
 <20190225112648.bgpnpu3no34wyx26@breakpoint.cc>
 <9d0a1d65189d4118a2dd6087b817d42e@baidu.com>
 <20190225115404.lul4qhfailu5u4yx@breakpoint.cc>
 <9563bbe86d9d4c719cfedafc8ded7ff8@baidu.com>
 <20190226063145.i4ctlywl47lfj5d5@breakpoint.cc>
In-Reply-To: <20190226063145.i4ctlywl47lfj5d5@breakpoint.cc>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.150.27]
x-baidu-bdmsfe-datecheck: 1_Bc-Mail-Ex13_2019-02-26 17:20:44:326
x-baidu-bdmsfe-viruscheck: Bc-Mail-Ex13_GRAY_Inside_WithoutAtta_2019-02-26
 17:20:44:311
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Baidu-BdMsfe-DateCheck: 1_M1-MAIL-EX03_2019-02-26 17:20:44:483
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogRmxvcmlhbiBXZXN0cGhhbCBbbWFp
bHRvOmZ3QHN0cmxlbi5kZV0NCj4gt6LLzcqxvOQ6IDIwMTnE6jLUwjI2yNUgMTQ6MzINCj4gytW8
/sjLOiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+ILOty806IEZsb3JpYW4g
V2VzdHBoYWwgPGZ3QHN0cmxlbi5kZT47IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcN
Cj4g1vfM4jogUmU6ILTwuLQ6ILTwuLQ6IFtQQVRDSF1bbmYtbmV4dF0gbmV0ZmlsdGVyOiByZXBs
YWNlIG1vZHVsbyBvcGVyYXRpb24NCj4gd2l0aCBiaXR3aXNlIEFORA0KPiANCj4gTGksUm9uZ3Fp
bmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPiB3cm90ZToNCj4gPiBJIHRoaW5rIHRoaXMgcGF0Y2hl
cyBtYXliZSBkb2luZyB0d28gdGhpbmc6DQo+ID4NCj4gPiAxLiBtYWtlIGNvZGVzIG5vdCBkZXBl
bmQgb24gY29tcGlsZXIgb3B0aW1pemF0aW9uIDIuIHJlbWluZCB0byBub3QNCj4gPiBjaGFuZ2Ug
Q09OTlRSQUNLX0xPQ0tTIHRvIGEgdmFsdWUgd2hpY2ggaXMgbm90IHBvd2VyIG9mIDINCj4gDQo+
IFlvdSBjb3VsZCBhZGQgYSBCVUlMRF9CVUdfT05fTk9UX1BPV0VSX09GXzIoKSBjaGVjayBmb3Ig
dGhhdC4NCg0KDQpPSywgcGxlYXNlIGRyb3AgdGhpcyBwYXRjaCwgSSB3aWxsIHNlbmQgYSBuZXcg
b25lIGJhc2VkIG9uIHlvdXIgYWR2aWNlDQoNCi1Sb25nUWluZw0K
