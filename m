Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C51A4C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 11:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E38C20842
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 11:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfBYLfa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 06:35:30 -0500
Received: from mx20.baidu.com ([111.202.115.85]:48799 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726701AbfBYLfa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 06:35:30 -0500
X-Greylist: delayed 27110 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2019 06:35:27 EST
Received: from M1-MAIL-EX04.internal.baidu.com (unknown [10.44.83.49])
        by Forcepoint Email with ESMTPS id 3DF67F171CDF;
        Mon, 25 Feb 2019 19:35:21 +0800 (CST)
Received: from BC-Mail-Ex13.internal.baidu.com (172.31.40.49) by
 M1-MAIL-EX04.internal.baidu.com (10.44.83.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Mon, 25 Feb 2019 19:35:22 +0800
Received: from BC-Mail-Ex13.internal.baidu.com (172.31.40.49) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.40.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Mon, 25 Feb 2019 19:35:22 +0800
Received: from BC-Mail-Ex13.internal.baidu.com ([172.31.40.49]) by
 Bc-Mail-Ex13.internal.baidu.com ([172.31.40.49]) with mapi id 15.01.1531.010;
 Mon, 25 Feb 2019 19:35:22 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXVtuZi1uZXh0XSBuZXRmaWx0ZXI6IHJlcGxhY2UgbW9k?=
 =?gb2312?Q?ulo_operation_with_bitwise_AND?=
Thread-Topic: [PATCH][nf-next] netfilter: replace modulo operation with
 bitwise AND
Thread-Index: AQHUzP0C+daqTE6OsEGa7BAHFYpRr6XwYOjg
Date:   Mon, 25 Feb 2019 11:35:21 +0000
Message-ID: <9d0a1d65189d4118a2dd6087b817d42e@baidu.com>
References: <1551093361-2150-1-git-send-email-lirongqing@baidu.com>
 <20190225112648.bgpnpu3no34wyx26@breakpoint.cc>
In-Reply-To: <20190225112648.bgpnpu3no34wyx26@breakpoint.cc>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.150.12]
x-baidu-bdmsfe-datecheck: 1_Bc-Mail-Ex13_2019-02-25 19:35:22:266
x-baidu-bdmsfe-viruscheck: Bc-Mail-Ex13_GRAY_Inside_WithoutAtta_2019-02-25
 19:35:22:251
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Baidu-BdMsfe-DateCheck: 1_M1-MAIL-EX04_2019-02-25 19:35:22:435
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogRmxvcmlhbiBXZXN0cGhhbCBbbWFp
bHRvOmZ3QHN0cmxlbi5kZV0NCj4gt6LLzcqxvOQ6IDIwMTnE6jLUwjI1yNUgMTk6MjcNCj4gytW8
/sjLOiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+ILOty806IG5ldGZpbHRl
ci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcNCj4g1vfM4jogUmU6IFtQQVRDSF1bbmYtbmV4dF0gbmV0
ZmlsdGVyOiByZXBsYWNlIG1vZHVsbyBvcGVyYXRpb24gd2l0aCBiaXR3aXNlDQo+IEFORA0KPiAN
Cj4gTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPiB3cm90ZToNCj4gPiBDT05OVFJB
Q0tfTE9DS1MgaXMgMTAyNCBhbmQgcG93ZXIgb2YgMiwgc28gbW9kdWxvIG9wZXJhdGlvbnMgY2Fu
IGJlDQo+ID4gcmVwbGFjZWQgd2l0aCBBTkQgKENPTk5UUkFDS19MT0NLUyAtIDEpDQo+ID4NCj4g
PiBhbmQgYml0d2lzZSBBTkQgb3BlcmF0aW9uIGlzIHF1aWNrZXIgdGhhbiBtb2R1bGUgb3BlcmF0
aW9uDQo+IA0KPiBVaC4gIFdoYXQga2luZCBvZiBjb21waWxlciBkb2Vzbid0IGZpZ3VyZSB0aGF0
IG91dD8hDQo+IA0KPiBJIHdvdWxkIHByZWZlciB0byBrZWVwIGl0IGFzLWlzIGFuZCBsZXQgY29t
cGlsZXIgZG8gdGhlIG9wdGltaXphdGlvbi4NCg0KDQpnY2MgdmVyc2lvbiA3LjMuMCAoR0NDKQ0K
DQoNCm1haW4oKQ0Kew0KICAgIGludCBpPTEwMDAwMDAwMDA7DQoNCiAgICAgICAgIGk9IGkgJSAx
MDI0Ow0KDQogICAgICAgIHJldHVybiBpOw0KfQ0KDQowMDAwMDAwMDAwNDAwNGE3IDxtYWluPjoN
CiAgNDAwNGE3OiAgICAgICA1NSAgICAgICAgICAgICAgICAgICAgICBwdXNoICAgJXJicA0KICA0
MDA0YTg6ICAgICAgIDQ4IDg5IGU1ICAgICAgICAgICAgICAgIG1vdiAgICAlcnNwLCVyYnANCiAg
NDAwNGFiOiAgICAgICBjNyA0NSBmYyAwMCBjYSA5YSAzYiAgICBtb3ZsICAgJDB4M2I5YWNhMDAs
LTB4NCglcmJwKQ0KICA0MDA0YjI6ICAgICAgIDhiIDQ1IGZjICAgICAgICAgICAgICAgIG1vdiAg
ICAtMHg0KCVyYnApLCVlYXgNCiAgNDAwNGI1OiAgICAgICA5OSAgICAgICAgICAgICAgICAgICAg
ICBjbHRkDQogIDQwMDRiNjogICAgICAgYzEgZWEgMTYgICAgICAgICAgICAgICAgc2hyICAgICQw
eDE2LCVlZHgNCiAgNDAwNGI5OiAgICAgICAwMSBkMCAgICAgICAgICAgICAgICAgICBhZGQgICAg
JWVkeCwlZWF4DQogIDQwMDRiYjogICAgICAgMjUgZmYgMDMgMDAgMDAgICAgICAgICAgYW5kICAg
ICQweDNmZiwlZWF4DQogIDQwMDRjMDogICAgICAgMjkgZDAgICAgICAgICAgICAgICAgICAgc3Vi
ICAgICVlZHgsJWVheA0KICA0MDA0YzI6ICAgICAgIDg5IDQ1IGZjICAgICAgICAgICAgICAgIG1v
diAgICAlZWF4LC0weDQoJXJicCkNCiAgNDAwNGM1OiAgICAgICA4YiA0NSBmYyAgICAgICAgICAg
ICAgICBtb3YgICAgLTB4NCglcmJwKSwlZWF4DQogIDQwMDRjODogICAgICAgNWQgICAgICAgICAg
ICAgICAgICAgICAgcG9wICAgICVyYnANCiAgNDAwNGM5OiAgICAgICBjMyAgICAgICAgICAgICAg
ICAgICAgICByZXRxDQogIDQwMDRjYTogICAgICAgNjYgMGYgMWYgNDQgMDAgMDAgICAgICAgbm9w
dyAgIDB4MCglcmF4LCVyYXgsMSkNCg0KPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
DQptYWluKCkNCnsNCiAgICBpbnQgaT0xMDAwMDAwMDAwOw0KDQogICAgICAgICBpPSBpICYgKDEw
MjQtMSk7DQoNCiAgICAgICAgcmV0dXJuIGk7DQp9DQoNCjAwMDAwMDAwMDA0MDA0YTcgPG1haW4+
Og0KICA0MDA0YTc6ICAgICAgIDU1ICAgICAgICAgICAgICAgICAgICAgIHB1c2ggICAlcmJwDQog
IDQwMDRhODogICAgICAgNDggODkgZTUgICAgICAgICAgICAgICAgbW92ICAgICVyc3AsJXJicA0K
ICA0MDA0YWI6ICAgICAgIGM3IDQ1IGZjIDAwIGNhIDlhIDNiICAgIG1vdmwgICAkMHgzYjlhY2Ew
MCwtMHg0KCVyYnApDQogIDQwMDRiMjogICAgICAgODEgNjUgZmMgZmYgMDMgMDAgMDAgICAgYW5k
bCAgICQweDNmZiwtMHg0KCVyYnApDQogIDQwMDRiOTogICAgICAgOGIgNDUgZmMgICAgICAgICAg
ICAgICAgbW92ICAgIC0weDQoJXJicCksJWVheA0KICA0MDA0YmM6ICAgICAgIDVkICAgICAgICAg
ICAgICAgICAgICAgIHBvcCAgICAlcmJwDQogIDQwMDRiZDogICAgICAgYzMgICAgICAgICAgICAg
ICAgICAgICAgcmV0cQ0KICA0MDA0YmU6ICAgICAgIDY2IDkwICAgICAgICAgICAgICAgICAgIHhj
aGcgICAlYXgsJWF4DQoNCg0KU2ltaWxhciBwYXRjaDoNCg0KY29tbWl0IDFhMWQ3NGQzNzhiMTNh
ZDNmOTNlODk3NWEwYWRlMDk4MGE0OWQyOGINCkF1dGhvcjogSmFrdWIgS2ljaW5za2kgPGpha3Vi
LmtpY2luc2tpQG5ldHJvbm9tZS5jb20+DQpEYXRlOiAgIE1vbiBPY3QgMzEgMjA6NDM6MTcgMjAx
NiArMDAwMA0KDQogICAgbmZwOiB1c2UgQU5EIGluc3RlYWQgb2YgbW9kdWxvIHRvIGdldCByaW5n
IGluZGV4ZXMNCg0KDQp0aGFua3MNCg0KLVJvbmdRaW5nDQo=
