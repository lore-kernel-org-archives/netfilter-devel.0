Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A3FC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 01:15:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F13721841
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 01:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfBZBPS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 20:15:18 -0500
Received: from mx20.baidu.com ([111.202.115.85]:58472 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725877AbfBZBPS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 20:15:18 -0500
Received: from M1-MAIL-EX12.internal.baidu.com (unknown [10.44.89.52])
        by Forcepoint Email with ESMTPS id 7E5424D65B24B;
        Tue, 26 Feb 2019 09:15:13 +0800 (CST)
Received: from BC-Mail-Ex13.internal.baidu.com (172.31.40.49) by
 M1-MAIL-EX12.internal.baidu.com (10.44.89.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Tue, 26 Feb 2019 09:15:14 +0800
Received: from BC-Mail-Ex13.internal.baidu.com (172.31.40.49) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.40.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Tue, 26 Feb 2019 09:15:14 +0800
Received: from BC-Mail-Ex13.internal.baidu.com ([172.31.40.49]) by
 Bc-Mail-Ex13.internal.baidu.com ([172.31.40.49]) with mapi id 15.01.1531.010;
 Tue, 26 Feb 2019 09:15:14 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF1bbmYtbmV4dF0gbmV0ZmlsdGVyOiBy?=
 =?utf-8?Q?eplace_modulo_operation_with_bitwise_AND?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW25mLW5leHRdIG5ldGZpbHRlcjogcmVwbGFjZSBt?=
 =?utf-8?Q?odulo_operation_with_bitwise_AND?=
Thread-Index: AQHUzP0C+daqTE6OsEGa7BAHFYpRr6XwYOjg//+AnQCAAWQhIA==
Date:   Tue, 26 Feb 2019 01:15:14 +0000
Message-ID: <9563bbe86d9d4c719cfedafc8ded7ff8@baidu.com>
References: <1551093361-2150-1-git-send-email-lirongqing@baidu.com>
 <20190225112648.bgpnpu3no34wyx26@breakpoint.cc>
 <9d0a1d65189d4118a2dd6087b817d42e@baidu.com>
 <20190225115404.lul4qhfailu5u4yx@breakpoint.cc>
In-Reply-To: <20190225115404.lul4qhfailu5u4yx@breakpoint.cc>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.150.27]
x-baidu-bdmsfe-datecheck: 1_Bc-Mail-Ex13_2019-02-26 09:15:14:836
x-baidu-bdmsfe-viruscheck: Bc-Mail-Ex13_GRAY_Inside_WithoutAtta_2019-02-26
 09:15:14:821
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Baidu-BdMsfe-DateCheck: 1_M1-MAIL-EX12_2019-02-26 09:15:15:009
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IEZsb3JpYW4gV2VzdHBo
YWwgW21haWx0bzpmd0BzdHJsZW4uZGVdDQo+IOWPkemAgeaXtumXtDogMjAxOeW5tDLmnIgyNeaX
pSAxOTo1NA0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4N
Cj4g5oqE6YCBOiBGbG9yaWFuIFdlc3RwaGFsIDxmd0BzdHJsZW4uZGU+OyBuZXRmaWx0ZXItZGV2
ZWxAdmdlci5rZXJuZWwub3JnDQo+IOS4u+mimDogUmU6IOetlOWkjTogW1BBVENIXVtuZi1uZXh0
XSBuZXRmaWx0ZXI6IHJlcGxhY2UgbW9kdWxvIG9wZXJhdGlvbiB3aXRoDQo+IGJpdHdpc2UgQU5E
DQo+IA0KPiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+IHdyb3RlOg0KPiA+DQo+
ID4NCj4gPiA+IC0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCj4gPiA+IOWPkeS7tuS6ujogRmxvcmlh
biBXZXN0cGhhbCBbbWFpbHRvOmZ3QHN0cmxlbi5kZV0NCj4gPiA+IOWPkemAgeaXtumXtDogMjAx
OeW5tDLmnIgyNeaXpSAxOToyNw0KPiA+ID4g5pS25Lu25Lq6OiBMaSxSb25ncWluZyA8bGlyb25n
cWluZ0BiYWlkdS5jb20+DQo+ID4gPiDmioTpgIE6IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5l
bC5vcmcNCj4gPiA+IOS4u+mimDogUmU6IFtQQVRDSF1bbmYtbmV4dF0gbmV0ZmlsdGVyOiByZXBs
YWNlIG1vZHVsbyBvcGVyYXRpb24gd2l0aA0KPiA+ID4gYml0d2lzZSBBTkQNCj4gPiA+DQo+ID4g
PiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+IHdyb3RlOg0KPiA+ID4gPiBDT05O
VFJBQ0tfTE9DS1MgaXMgMTAyNCBhbmQgcG93ZXIgb2YgMiwgc28gbW9kdWxvIG9wZXJhdGlvbnMg
Y2FuDQo+ID4gPiA+IGJlIHJlcGxhY2VkIHdpdGggQU5EIChDT05OVFJBQ0tfTE9DS1MgLSAxKQ0K
PiA+ID4gPg0KPiA+ID4gPiBhbmQgYml0d2lzZSBBTkQgb3BlcmF0aW9uIGlzIHF1aWNrZXIgdGhh
biBtb2R1bGUgb3BlcmF0aW9uDQo+ID4gPg0KPiA+ID4gVWguICBXaGF0IGtpbmQgb2YgY29tcGls
ZXIgZG9lc24ndCBmaWd1cmUgdGhhdCBvdXQ/IQ0KPiA+ID4NCj4gPiA+IEkgd291bGQgcHJlZmVy
IHRvIGtlZXAgaXQgYXMtaXMgYW5kIGxldCBjb21waWxlciBkbyB0aGUgb3B0aW1pemF0aW9uLg0K
PiA+DQo+ID4NCj4gPiBnY2MgdmVyc2lvbiA3LjMuMCAoR0NDKQ0KPiA+DQo+ID4NCj4gPiBtYWlu
KCkNCj4gPiB7DQo+ID4gICAgIGludCBpPTEwMDAwMDAwMDA7DQo+ID4NCj4gPiAgICAgICAgICBp
PSBpICUgMTAyNDsNCj4gPg0KPiA+ICAgICAgICAgcmV0dXJuIGk7DQo+ID4gfQ0KPiA+DQo+ID4g
MDAwMDAwMDAwMDQwMDRhNyA8bWFpbj46DQo+ID4gICA0MDA0YTc6ICAgICAgIDU1ICAgICAgICAg
ICAgICAgICAgICAgIHB1c2ggICAlcmJwDQo+ID4gICA0MDA0YTg6ICAgICAgIDQ4IDg5IGU1ICAg
ICAgICAgICAgICAgIG1vdiAgICAlcnNwLCVyYnANCj4gPiAgIDQwMDRhYjogICAgICAgYzcgNDUg
ZmMgMDAgY2EgOWEgM2IgICAgbW92bCAgICQweDNiOWFjYTAwLC0weDQoJXJicCkNCj4gPiAgIDQw
MDRiMjogICAgICAgOGIgNDUgZmMgICAgICAgICAgICAgICAgbW92ICAgIC0weDQoJXJicCksJWVh
eA0KPiA+ICAgNDAwNGI1OiAgICAgICA5OSAgICAgICAgICAgICAgICAgICAgICBjbHRkDQo+ID4g
ICA0MDA0YjY6ICAgICAgIGMxIGVhIDE2ICAgICAgICAgICAgICAgIHNociAgICAkMHgxNiwlZWR4
DQo+ID4gICA0MDA0Yjk6ICAgICAgIDAxIGQwICAgICAgICAgICAgICAgICAgIGFkZCAgICAlZWR4
LCVlYXgNCj4gPiAgIDQwMDRiYjogICAgICAgMjUgZmYgMDMgMDAgMDAgICAgICAgICAgYW5kICAg
ICQweDNmZiwlZWF4DQo+IA0KPiAmIDEwMjMuDQo+IA0KPiBXaXRoIC1PMiBnY2MgZW1pdHMgc2Ft
ZSBjb2RlIHJlZ2FyZGxlc3Mgb2YgJSAxMDI0IG9yICYgMTAyMy4NCj4gDQo+ID4gU2ltaWxhciBw
YXRjaDoNCj4gPg0KPiA+IGNvbW1pdCAxYTFkNzRkMzc4YjEzYWQzZjkzZTg5NzVhMGFkZTA5ODBh
NDlkMjhiDQo+ID4gQXV0aG9yOiBKYWt1YiBLaWNpbnNraSA8amFrdWIua2ljaW5za2lAbmV0cm9u
b21lLmNvbT4NCj4gPiBEYXRlOiAgIE1vbiBPY3QgMzEgMjA6NDM6MTcgMjAxNiArMDAwMA0KPiA+
DQo+ID4gICAgIG5mcDogdXNlIEFORCBpbnN0ZWFkIG9mIG1vZHVsbyB0byBnZXQgcmluZyBpbmRl
eGVzDQo+IA0KPiBCdXQgaW4gdGhhdCBjYXNlIHRoZSB2YWx1ZSBpc24ndCBrbm93biBhdCBjb21w
aWxlIHRpbWUuDQo+IA0KPiBnY2MgY2FuJ3Qga25vdyB0aGF0ICc9IHJlZzEgJSByZWcyJyBjYW4g
YmUgcmV3cml0dGVuIGFzICdyZWcxICYgKHJlZzIgLSAxKScNCj4gDQo+IEJ1dCBpdCBjYW4gZG8g
aXQgaWYgcmVnMiBpcyBhIGtub3duIGNvbnN0YW50IChhbmQgYSBwb3dlciBvZiAyKS4NCg0KDQpU
aGFua3MsIFlvdSBhcmUgcmlnaHQNCg0KSSB0aGluayB0aGlzIHBhdGNoZXMgbWF5YmUgZG9pbmcg
dHdvIHRoaW5nOg0KDQoxLiBtYWtlIGNvZGVzIG5vdCBkZXBlbmQgb24gY29tcGlsZXIgb3B0aW1p
emF0aW9uDQoyLiByZW1pbmQgdG8gbm90IGNoYW5nZSBDT05OVFJBQ0tfTE9DS1MgdG8gYSB2YWx1
ZSB3aGljaCBpcyBub3QgcG93ZXIgb2YgMg0KDQotUm9uZ1FpbmcNCg==
