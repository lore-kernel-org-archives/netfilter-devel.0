Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398ADC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 02:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08FC22087C
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 02:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfBZCx5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 21:53:57 -0500
Received: from mx20.baidu.com ([111.202.115.85]:52981 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725954AbfBZCx5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 21:53:57 -0500
Received: from M1-MAIL-EX05.internal.baidu.com (unknown [10.44.83.53])
        by Forcepoint Email with ESMTPS id 884C7A58278CA;
        Tue, 26 Feb 2019 10:53:50 +0800 (CST)
Received: from BC-Mail-Ex16.internal.baidu.com (172.31.40.52) by
 M1-MAIL-EX05.internal.baidu.com (10.44.83.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Tue, 26 Feb 2019 10:53:51 +0800
Received: from BC-Mail-Ex13.internal.baidu.com (172.31.40.49) by
 BC-Mail-Ex16.internal.baidu.com (172.31.40.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Tue, 26 Feb 2019 10:53:51 +0800
Received: from BC-Mail-Ex13.internal.baidu.com ([172.31.40.49]) by
 Bc-Mail-Ex13.internal.baidu.com ([172.31.40.49]) with mapi id 15.01.1531.010;
 Tue, 26 Feb 2019 10:53:51 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogW1BBVENIXSBuZXRmaWx0ZXI6IGZv?=
 =?utf-8?B?cmNlIGFjY2VzcyBvZiBSQ1UgcHJvdGVjdGVkIGRhdGEgaW4gbmZ0X3VwZGF0?=
 =?utf-8?B?ZV9jaGFpbl9zdGF0cw==?=
Thread-Topic: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF0gbmV0ZmlsdGVyOiBmb3JjZSBhY2Nl?=
 =?utf-8?B?c3Mgb2YgUkNVIHByb3RlY3RlZCBkYXRhIGluIG5mdF91cGRhdGVfY2hhaW5f?=
 =?utf-8?Q?stats?=
Thread-Index: AQHUzL036rQ47IvhCkSSk0/1m/0UX6Xv4vGQ//99pACAAKLMQIAAIjaAgAE7vzA=
Date:   Tue, 26 Feb 2019 02:53:51 +0000
Message-ID: <b2dc0099c04949e2b07eabe2ce084b8d@baidu.com>
References: <1551059920-14120-1-git-send-email-lirongqing@baidu.com>
 <4818220f-1c66-df00-e397-4efbeba82665@gmail.com>
 <b8ca2a794fdf4406a52ee4ecb78ef54b@baidu.com>
 <cc982bdc-3639-490d-36a7-df32316313e2@gmail.com>
 <3614110dd296453db887938bb07f3aa6@baidu.com>
 <071a3554-442b-59cd-74ff-7bbc21c7a9e1@gmail.com>
In-Reply-To: <071a3554-442b-59cd-74ff-7bbc21c7a9e1@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.150.27]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex16_2019-02-26 10:53:51:793
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex16_GRAY_Inside_WithoutAtta_2019-02-26
 10:53:51:778
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Baidu-BdMsfe-DateCheck: 1_M1-MAIL-EX05_2019-02-26 10:53:51:995
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IEVyaWMgRHVtYXpldCBb
bWFpbHRvOmVyaWMuZHVtYXpldEBnbWFpbC5jb21dDQo+IOWPkemAgeaXtumXtDogMjAxOeW5tDLm
nIgyNeaXpSAyMzo1Ng0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1
LmNvbT47IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcNCj4g5Li76aKYOiBSZTog562U
5aSNOiDnrZTlpI06IFtQQVRDSF0gbmV0ZmlsdGVyOiBmb3JjZSBhY2Nlc3Mgb2YgUkNVIHByb3Rl
Y3RlZCBkYXRhIGluDQo+IG5mdF91cGRhdGVfY2hhaW5fc3RhdHMNCj4gDQo+IA0KPiANCj4gT24g
MDIvMjQvMjAxOSAxMDowMCBQTSwgTGksUm9uZ3Fpbmcgd3JvdGU6DQo+ID4NCj4gPg0KPiA+PiAt
LS0tLemCruS7tuWOn+S7ti0tLS0tDQo+ID4+IOWPkeS7tuS6ujogRXJpYyBEdW1hemV0IFttYWls
dG86ZXJpYy5kdW1hemV0QGdtYWlsLmNvbV0NCj4gPj4g5Y+R6YCB5pe26Ze0OiAyMDE55bm0Muac
iDI15pelIDEyOjExDQo+ID4+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFp
ZHUuY29tPjsNCj4gPj4gbmV0ZmlsdGVyLWRldmVsQHZnZXIua2VybmVsLm9yZw0KPiA+PiDkuLvp
opg6IFJlOiDnrZTlpI06IFtQQVRDSF0gbmV0ZmlsdGVyOiBmb3JjZSBhY2Nlc3Mgb2YgUkNVIHBy
b3RlY3RlZCBkYXRhIGluDQo+ID4+IG5mdF91cGRhdGVfY2hhaW5fc3RhdHMNCj4gPj4NCj4gPj4N
Cj4gPj4NCj4gPj4gT24gMDIvMjQvMjAxOSAwODowMyBQTSwgTGksUm9uZ3Fpbmcgd3JvdGU6DQo+
ID4+Pg0KPiA+Pj4NCj4gPj4+PiAtLS0tLemCruS7tuWOn+S7ti0tLS0tDQo+ID4+Pj4g5Y+R5Lu2
5Lq6OiBFcmljIER1bWF6ZXQgW21haWx0bzplcmljLmR1bWF6ZXRAZ21haWwuY29tXQ0KPiA+Pj4+
IOWPkemAgeaXtumXtDogMjAxOeW5tDLmnIgyNeaXpSAxMTo1MA0KPiA+Pj4+IOaUtuS7tuS6ujog
TGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPjsNCj4gPj4+PiBuZXRmaWx0ZXItZGV2
ZWxAdmdlci5rZXJuZWwub3JnDQo+ID4+Pj4g5Li76aKYOiBSZTogW1BBVENIXSBuZXRmaWx0ZXI6
IGZvcmNlIGFjY2VzcyBvZiBSQ1UgcHJvdGVjdGVkIGRhdGEgaW4NCj4gPj4+PiBuZnRfdXBkYXRl
X2NoYWluX3N0YXRzDQo+ID4+Pj4NCj4gPj4+Pg0KPiA+Pj4+DQo+ID4NCj4gPg0KPiA+ICAgICBb
UkZDXSBuZXRmaWx0ZXI6IGNoZWNrIHRoZSByZXN1bHQgb2YgZGVyZWZlcmVuY2luZw0KPiA+IGJh
c2VfY2hhaW4tPnN0YXRzDQo+ID4NCj4gPiAgICAgY2hlY2sgdGhlIHJlc3VsdCBvZiBkZXJlZmVy
ZW5jaW5nIGJhc2VfY2hhaW4tPnN0YXRzLCBpbnN0ZWFkIG9mDQo+ID4gICAgIHJlc3VsdCBvZiB0
aGlzX2NwdV9wdHINCj4gPg0KPiA+ICAgICBiYXNlX2NoYWluLT5zdGF0cyBtYXliZSBjaGFuZ2Ug
dG8gTlVMTCB3aGVuIGEgY2hhaW4gaXMgdXBkYXRlZCwNCj4gPiAgICAgYSBOVUxMIGNvdW50ZXIg
Y2FuIGJlIGF0dGFjaGVkDQo+ID4NCj4gPiAgICAgYW5kIHdlIGRvIG5vdCBuZWVkIHRvIGNoZWNr
IHJldHVybmluZyBvZiB0aGlzX2NwdV9wdHIgc2luY2UNCj4gPiAgICAgYmFzZV9jaGFpbi0+c3Rh
dHMgaXMgYWxsb2NhdGVkIGJ5IHBlcmNwdSBhbGxvY2F0b3IgaWYgaXQgaXMNCj4gPiAgICAgbm9u
LU5VTEwsIHRoaXNfY3B1X3B0ciByZXR1cm5zIGEgdmFsaWQgdmFsdWUNCj4gPg0KPiA+IGRpZmYg
LS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mX3RhYmxlc19jb3JlLmMNCj4gPiBiL25ldC9uZXRmaWx0
ZXIvbmZfdGFibGVzX2NvcmUuYyBpbmRleCAyYTAwYWVmN2I2ZDQuLmVkOGEzODJkMTAxMg0KPiA+
IDEwMDY0NA0KPiA+IC0tLSBhL25ldC9uZXRmaWx0ZXIvbmZfdGFibGVzX2NvcmUuYw0KPiA+ICsr
KyBiL25ldC9uZXRmaWx0ZXIvbmZfdGFibGVzX2NvcmUuYw0KPiA+IEBAIC05OCwxNSArOTgsMTYg
QEAgc3RhdGljIG5vaW5saW5lIHZvaWQgbmZ0X3VwZGF0ZV9jaGFpbl9zdGF0cyhjb25zdA0KPiBz
dHJ1Y3QgbmZ0X2NoYWluICpjaGFpbiwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdA0KPiBuZnRfcGt0aW5mbw0KPiA+ICpwa3QpICB7
DQo+ID4gICAgICAgICBzdHJ1Y3QgbmZ0X2Jhc2VfY2hhaW4gKmJhc2VfY2hhaW47DQo+ID4gLSAg
ICAgICBzdHJ1Y3QgbmZ0X3N0YXRzICpzdGF0czsNCj4gPiArICAgICAgIHN0cnVjdCBuZnRfc3Rh
dHMgKnN0YXRzLCAqcHN0YXRzOw0KPiANCj4gT0sgYnV0IHRoZW4gbWFrZSBzdXJlIHRvIGFkZCBw
cm9wZXIgc3BhcnNlIGFubm90YXRpb25zICAoIGFrYSBfX3BlcmNwdSApDQo+IA0KDQpJIHRlc3Qg
dGhpcyBhbmQgZm91bmQgLCB0aGVyZSBpcyBhbHdheXMgc3BhcnNlIGVycm9yIHdoZXRoZXIgYWRk
IF9fcGVyY3B1IG9yIG5vdA0KDQpMaWtlOiANCnN0cnVjdCBuZnRfc3RhdHMgX19wZXJjcHUgKnBz
dGF0czsNCg0KcHN0YXRzID0gcmN1X2RlcmVmZXJlbmNlKGJhc2VfY2hhaW4tPnN0YXRzKTsNCg0K
ZXJyb3I6IGluY29tcGF0aWJsZSB0eXBlcyBpbiBjb21wYXJpc29uIGV4cHJlc3Npb24gKGRpZmZl
cmVudCBhZGRyZXNzIHNwYWNlcykNCg0KLVJvbmdRaW5nIA0K
