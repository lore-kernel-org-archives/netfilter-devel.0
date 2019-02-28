Return-Path: <SRS0=zt5D=RD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=3.0 tests=CHARSET_FARAWAY_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5C0C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 01:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36A012186A
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 01:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbfB1BaV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 20:30:21 -0500
Received: from mx22.baidu.com ([220.181.50.185]:57606 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730234AbfB1BaV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 20:30:21 -0500
Received: from M1-MAIL-EX15.internal.baidu.com (unknown [10.44.89.55])
        by Forcepoint Email with ESMTPS id DC8BEF5A36893;
        Thu, 28 Feb 2019 09:29:42 +0800 (CST)
Received: from BC-Mail-Ex13.internal.baidu.com (172.31.40.49) by
 M1-MAIL-EX15.internal.baidu.com (10.44.89.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Thu, 28 Feb 2019 09:29:43 +0800
Received: from BC-Mail-Ex13.internal.baidu.com ([172.31.40.49]) by
 Bc-Mail-Ex13.internal.baidu.com ([172.31.40.49]) with mapi id 15.01.1531.010;
 Thu, 28 Feb 2019 09:29:43 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSB0aW1lOiBJbnRyb2R1Y2UgamlmZmllczY0X3RvX21z?=
 =?gb2312?Q?ecs()?=
Thread-Topic: [PATCH] time: Introduce jiffies64_to_msecs()
Thread-Index: AQHUzo4ecMmHTWKYM0yt/4PZZN+rLKX0bPEw
Date:   Thu, 28 Feb 2019 01:29:43 +0000
Message-ID: <11fc9ad74dbe48dbb0df93e12a1dde4b@baidu.com>
References: <1551260313-2926-1-git-send-email-lirongqing@baidu.com>
 <alpine.DEB.2.21.1902271217110.1857@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1902271217110.1857@nanos.tec.linutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.150.40]
x-baidu-bdmsfe-datecheck: 1_M1-MAIL-EX15_2019-02-28 09:29:44:039
x-baidu-bdmsfe-viruscheck: M1-MAIL-EX15_GRAY_Inside_WithoutAtta_2019-02-28
 09:29:44:023
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogVGhvbWFzIEdsZWl4bmVyIFttYWls
dG86dGdseEBsaW51dHJvbml4LmRlXQ0KPiC3osvNyrG85DogMjAxOcTqMtTCMjfI1SAxOToxOA0K
PiDK1bz+yMs6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gs63LzTogbmV0
ZmlsdGVyLWRldmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
ZzsNCj4gc2JveWRAa2VybmVsLm9yZzsgam9obi5zdHVsdHpAbGluYXJvLm9yZw0KPiDW98ziOiBS
ZTogW1BBVENIXSB0aW1lOiBJbnRyb2R1Y2UgamlmZmllczY0X3RvX21zZWNzKCkNCj4gDQo+IE9u
IFdlZCwgMjcgRmViIDIwMTksIExpIFJvbmdRaW5nIHdyb3RlOg0KPiANCj4gPiB0aGVyZSBpcyBh
IHNpbWlsYXIgaGVscGVyIGluIG5ldC9uZXRmaWx0ZXIvbmZfdGFibGVzX2FwaS5jLCB0aGlzIG1h
eWJlDQo+ID4gYmVjb21lIGEgY29tbW9uIHJlcXVlc3Qgc29tZWRheS4NCj4gDQo+IE1heWJlIGlz
IG5vdCBhIHJlYWxseSBnb29kIGp1c3RpZmljYXRpb24gZm9yIGFkZGluZyB0aGF0LiBBdCBsZWFz
dCB5b3Ugc2hvdWxkDQo+IHByb3ZpZGUgYSBwYXRjaCB3aGljaCByZXBsYWNlcyB0aGUgaW5zdGFu
Y2UgaW4gdGhlIG5ldGZpbHRlciBjb2RlLg0KPiANCj4gVGhhbmtzLA0KPiANCg0KDQpPSywgSSB3
aWxsIHNlbmQgVjINCg0KVGhhbmtzDQotcm9uZ3FpbmcNCg0K
