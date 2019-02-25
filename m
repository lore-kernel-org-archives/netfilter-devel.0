Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE97C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 04:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03C0920989
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 04:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfBYEUf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Feb 2019 23:20:35 -0500
Received: from mx23.baidu.com ([61.135.165.120]:40118 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728473AbfBYEUf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Feb 2019 23:20:35 -0500
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2019 23:20:33 EST
Received: from USDC-Mail-CAS03.internal.baidu.com (unknown [172.19.44.141])
        by Forcepoint Email with ESMTPS id CF39446813D6B;
        Mon, 25 Feb 2019 12:05:14 +0800 (CST)
Received: from BC-Mail-Ex14.internal.baidu.com (172.31.40.50) by
 USDC-Mail-CAS03.internal.baidu.com (172.19.44.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Sun, 24 Feb 2019 20:05:11 -0800
Received: from BC-Mail-Ex13.internal.baidu.com (172.31.40.49) by
 BC-Mail-Ex14.internal.baidu.com (172.31.40.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Mon, 25 Feb 2019 12:05:09 +0800
Received: from BC-Mail-Ex13.internal.baidu.com ([172.31.40.49]) by
 Bc-Mail-Ex13.internal.baidu.com ([172.31.40.49]) with mapi id 15.01.1531.010;
 Mon, 25 Feb 2019 12:05:09 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW25mLW5leHRdIG5ldGZpbHRlcjogVXNlIFJDVSBw?=
 =?utf-8?Q?rimitives_under_RCU_protected_data?=
Thread-Topic: [PATCH][nf-next] netfilter: Use RCU primitives under RCU
 protected data
Thread-Index: AQHUzL2Ti9jl5srMdEaf3oC7Bye7b6Xv5NGQ
Date:   Mon, 25 Feb 2019 04:05:09 +0000
Message-ID: <06d08b4aff314d1481b75707bd9d4a03@baidu.com>
References: <1551065562-26220-1-git-send-email-lirongqing@baidu.com>
 <2963a108-e8ae-e8d6-8e5a-d4605c432e72@gmail.com>
In-Reply-To: <2963a108-e8ae-e8d6-8e5a-d4605c432e72@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.150.12]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex14_2019-02-25 12:05:09:755
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex14_GRAY_Inside_WithoutAtta_2019-02-25
 12:05:09:740
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Baidu-BdMsfe-DateCheck: 1_USDC-Mail-CAS03_2019-02-24 20:05:14:180
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IEVyaWMgRHVtYXpldCBb
bWFpbHRvOmVyaWMuZHVtYXpldEBnbWFpbC5jb21dDQo+IOWPkemAgeaXtumXtDogMjAxOeW5tDLm
nIgyNeaXpSAxMTo1Mw0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1
LmNvbT47IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcNCj4g5Li76aKYOiBSZTogW1BB
VENIXVtuZi1uZXh0XSBuZXRmaWx0ZXI6IFVzZSBSQ1UgcHJpbWl0aXZlcyB1bmRlciBSQ1UgcHJv
dGVjdGVkDQo+IGRhdGENCj4gDQo+IA0KPiANCj4gT24gMDIvMjQvMjAxOSAwNzozMiBQTSwgTGkg
Um9uZ1Fpbmcgd3JvdGU6DQo+ID4gVGhpcyBwb2ludGVyIGlzIFJDVSBwcm90ZWN0ZWQsIHNvIHBy
b3BlciBwcmltaXRpdmVzIHNob3VsZCBiZSB1c2VkLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTog
WmhhbmcgWXUgPHpoYW5neXUzMUBiYWlkdS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9u
Z1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiA+IC0tLQ0KPiA+ICBuZXQvbmV0ZmlsdGVy
L3h0X0NULmMgfCA2ICsrKy0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
LCAzIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIveHRf
Q1QuYyBiL25ldC9uZXRmaWx0ZXIveHRfQ1QuYyBpbmRleA0KPiA+IDBmYTg2M2Y1NzU3NS4uMjZk
ZWU4YmJhMzI2IDEwMDY0NA0KPiA+IC0tLSBhL25ldC9uZXRmaWx0ZXIveHRfQ1QuYw0KPiA+ICsr
KyBiL25ldC9uZXRmaWx0ZXIveHRfQ1QuYw0KPiA+IEBAIC05OSw3ICs5OSw3IEBAIHh0X2N0X3Nl
dF9oZWxwZXIoc3RydWN0IG5mX2Nvbm4gKmN0LCBjb25zdCBjaGFyDQo+ICpoZWxwZXJfbmFtZSwN
Cj4gPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gPiAgCX0NCj4gPg0KPiA+IC0JaGVscC0+aGVscGVy
ID0gaGVscGVyOw0KPiA+ICsJUkNVX0lOSVRfUE9JTlRFUihoZWxwLT5oZWxwZXIsIGhlbHBlcik7
DQo+ID4gIAlyZXR1cm4gMDsNCj4gPiAgfQ0KPiA+DQo+ID4gQEAgLTI3NCw3ICsyNzQsNyBAQCBz
dGF0aWMgaW50IHh0X2N0X3RnX2NoZWNrKGNvbnN0IHN0cnVjdA0KPiA+IHh0X3RnY2hrX3BhcmFt
ICpwYXIsDQo+ID4gIGVycjQ6DQo+ID4gIAloZWxwID0gbmZjdF9oZWxwKGN0KTsNCj4gPiAgCWlm
IChoZWxwKQ0KPiA+IC0JCW5mX2Nvbm50cmFja19oZWxwZXJfcHV0KGhlbHAtPmhlbHBlcik7DQo+
ID4gKwkJbmZfY29ubnRyYWNrX2hlbHBlcl9wdXQocmN1X2RlcmVmZXJlbmNlKGhlbHAtPmhlbHBl
cikpOw0KPiANCj4gQXJlIHlvdSBzdXJlIGl0IGlzIG9rLCBoYXZlIHlvdSB0ZXN0ZWQgeW91ciBw
YXRjaCA/DQo+IA0KPiBXaGVyZSBpcyB0aGUgcmN1X3JlYWRfbG9jaygpID8NCj4gDQo+IENPTkZJ
R19QUk9WRV9SQ1U9eSAgd2lsbCBsaWtlbHkgZ2l2ZSBhIHNwbGF0IGhlcmUuDQo+IA0KDQpUaGFu
a3MsICBJIHdpbGwgdGVzdCBpdCBhcyB5b3VyIHN1Z2dlc3Rpb24NCg0KLVJvbmdRaW5nDQoNCg0K
