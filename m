Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E35AC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 06:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1EFD20842
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 06:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfBYGAX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 01:00:23 -0500
Received: from mx21.baidu.com ([220.181.3.85]:43913 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725912AbfBYGAX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 01:00:23 -0500
Received: from M1-MAIL-EX16.internal.baidu.com (unknown [10.44.89.56])
        by Forcepoint Email with ESMTPS id 39B456CBBF63C;
        Mon, 25 Feb 2019 14:00:18 +0800 (CST)
Received: from BC-Mail-Ex13.internal.baidu.com (172.31.40.49) by
 M1-MAIL-EX16.internal.baidu.com (10.44.89.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Mon, 25 Feb 2019 14:00:18 +0800
Received: from BC-Mail-Ex13.internal.baidu.com ([172.31.40.49]) by
 Bc-Mail-Ex13.internal.baidu.com ([172.31.40.49]) with mapi id 15.01.1531.010;
 Mon, 25 Feb 2019 14:00:18 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF0gbmV0ZmlsdGVyOiBmb3JjZSBhY2Nl?=
 =?utf-8?B?c3Mgb2YgUkNVIHByb3RlY3RlZCBkYXRhIGluIG5mdF91cGRhdGVfY2hhaW5f?=
 =?utf-8?Q?stats?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIG5ldGZpbHRlcjogZm9yY2UgYWNjZXNzIG9mIFJD?=
 =?utf-8?B?VSBwcm90ZWN0ZWQgZGF0YSBpbiBuZnRfdXBkYXRlX2NoYWluX3N0YXRz?=
Thread-Index: AQHUzL036rQ47IvhCkSSk0/1m/0UX6Xv4vGQ//99pACAAKLMQA==
Date:   Mon, 25 Feb 2019 06:00:18 +0000
Message-ID: <3614110dd296453db887938bb07f3aa6@baidu.com>
References: <1551059920-14120-1-git-send-email-lirongqing@baidu.com>
 <4818220f-1c66-df00-e397-4efbeba82665@gmail.com>
 <b8ca2a794fdf4406a52ee4ecb78ef54b@baidu.com>
 <cc982bdc-3639-490d-36a7-df32316313e2@gmail.com>
In-Reply-To: <cc982bdc-3639-490d-36a7-df32316313e2@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.150.12]
x-baidu-bdmsfe-datecheck: 1_M1-MAIL-EX16_2019-02-25 14:00:18:933
x-baidu-bdmsfe-viruscheck: M1-MAIL-EX16_GRAY_Inside_WithoutAtta_2019-02-25
 14:00:18:917
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IEVyaWMgRHVtYXpldCBb
bWFpbHRvOmVyaWMuZHVtYXpldEBnbWFpbC5jb21dDQo+IOWPkemAgeaXtumXtDogMjAxOeW5tDLm
nIgyNeaXpSAxMjoxMQ0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1
LmNvbT47IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcNCj4g5Li76aKYOiBSZTog562U
5aSNOiBbUEFUQ0hdIG5ldGZpbHRlcjogZm9yY2UgYWNjZXNzIG9mIFJDVSBwcm90ZWN0ZWQgZGF0
YSBpbg0KPiBuZnRfdXBkYXRlX2NoYWluX3N0YXRzDQo+IA0KPiANCj4gDQo+IE9uIDAyLzI0LzIw
MTkgMDg6MDMgUE0sIExpLFJvbmdxaW5nIHdyb3RlOg0KPiA+DQo+ID4NCj4gPj4gLS0tLS3pgq7k
u7bljp/ku7YtLS0tLQ0KPiA+PiDlj5Hku7bkuro6IEVyaWMgRHVtYXpldCBbbWFpbHRvOmVyaWMu
ZHVtYXpldEBnbWFpbC5jb21dDQo+ID4+IOWPkemAgeaXtumXtDogMjAxOeW5tDLmnIgyNeaXpSAx
MTo1MA0KPiA+PiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT47
DQo+ID4+IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4g5Li76aKYOiBSZTog
W1BBVENIXSBuZXRmaWx0ZXI6IGZvcmNlIGFjY2VzcyBvZiBSQ1UgcHJvdGVjdGVkIGRhdGEgaW4N
Cj4gPj4gbmZ0X3VwZGF0ZV9jaGFpbl9zdGF0cw0KPiA+Pg0KPiA+Pg0KPiA+Pg0KPiA+PiBPbiAw
Mi8yNC8yMDE5IDA1OjU4IFBNLCBMaSBSb25nUWluZyB3cm90ZToNCj4gPj4+IGJhc2VjaGFpbi0+
c3RhdHMgaXMgcmN1IHByb3RlY3RlZCBkYXRhLCBjYW5ub3QgYXNzdXJlIHRoYXQNCj4gPj4+IHR3
aWNlIGFjY2Vzc2VzIGhhdmUgdGhlIHNhbWUgcmVzdWx0LCBzbyBkZXJlZmVyZW5jZSBpdCBvbmNl
Lg0KPiA+Pj4NCj4gPj4+IGJhc2VjaGFpbi0+c3RhdHMgaXMgYWxsb2NhdGVkIGJ5IHBlcmNwdSBh
bGxvY2F0ZXIsIGlmIGl0IGlzIG5vdA0KPiA+Pj4gYmFzZWNoYWluLT5OVUxMLA0KPiA+Pj4gaXRz
IHBlcmNwdSB2YXJpYWJsZSBkb2VzIG5vdCBuZWVkIHRvIGJlIGNoZWNrZWQgd2l0aCBOVUxMDQo+
ID4+Pg0KPiA+Pj4gU2lnbmVkLW9mZi1ieTogWmhhbmcgWXUgPHpoYW5neXUzMUBiYWlkdS5jb20+
DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+
DQo+ID4+PiAtLS0NCj4gPj4+ICBuZXQvbmV0ZmlsdGVyL25mX3RhYmxlc19jb3JlLmMgfCAxOCAr
KysrKysrKystLS0tLS0tLS0NCj4gPj4+ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCsp
LCA5IGRlbGV0aW9ucygtKQ0KPiA+Pj4NCj4gPj4+IGRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVy
L25mX3RhYmxlc19jb3JlLmMNCj4gPj4+IGIvbmV0L25ldGZpbHRlci9uZl90YWJsZXNfY29yZS5j
IGluZGV4IDJhMDBhZWY3YjZkNC4uOWJlNjIyYzc2YTYyDQo+ID4+PiAxMDA2NDQNCj4gPj4+IC0t
LSBhL25ldC9uZXRmaWx0ZXIvbmZfdGFibGVzX2NvcmUuYw0KPiA+Pj4gKysrIGIvbmV0L25ldGZp
bHRlci9uZl90YWJsZXNfY29yZS5jDQo+ID4+PiBAQCAtOTgsMjAgKzk4LDIwIEBAIHN0YXRpYyBu
b2lubGluZSB2b2lkDQo+ID4+PiBuZnRfdXBkYXRlX2NoYWluX3N0YXRzKGNvbnN0DQo+ID4+IHN0
cnVjdCBuZnRfY2hhaW4gKmNoYWluLA0KPiA+Pj4gIAkJCQkJICAgIGNvbnN0IHN0cnVjdCBuZnRf
cGt0aW5mbyAqcGt0KSAgew0KPiA+Pj4gIAlzdHJ1Y3QgbmZ0X2Jhc2VfY2hhaW4gKmJhc2VfY2hh
aW47DQo+ID4+PiAtCXN0cnVjdCBuZnRfc3RhdHMgKnN0YXRzOw0KPiA+Pj4gKwlzdHJ1Y3QgbmZ0
X3N0YXRzICpzdGF0cywgKnBzdGF0Ow0KPiA+Pj4NCj4gPj4+ICAJYmFzZV9jaGFpbiA9IG5mdF9i
YXNlX2NoYWluKGNoYWluKTsNCj4gPj4+IC0JaWYgKCFyY3VfYWNjZXNzX3BvaW50ZXIoYmFzZV9j
aGFpbi0+c3RhdHMpKQ0KPiA+Pj4gKw0KPiA+Pj4gKwlzdGF0cyA9IHJjdV9kZXJlZmVyZW5jZShi
YXNlX2NoYWluLT5zdGF0cyk7DQo+ID4+DQo+ID4+IFRoaXMgbG9va3MgYm9ndXMgdG8gbWUuDQo+
ID4+DQo+ID4+IFdoZXJlIGlzIHRoZSBuZWVkZWQgcmN1X3JlYWRfbG9jaygpIGJlZm9yZSByY3Vf
ZGVyZWZlcmVuY2UoKSA/DQo+ID4+DQo+ID4NCj4gPiBPaywgSSB3aWxsIGNoZWNrIGl0IGNhcmVm
dWxseS4NCj4gPg0KPiA+PiBUaGlzIHJjdV9hY2Nlc3NfcG9pbnRlcigpIHRlc3QgaXMgZmluZSwg
YW5kIGF2b2lkcyBhDQo+ID4+IGxvY2FsX2JoX2Rpc2FibGUoKS9sb2NhbF9iaF9lbmFibGUoKQ0K
PiA+PiBpZiB0aGV5IGFyZSBub3QgbmVlZGVkLg0KPiA+DQo+ID4NCj4gPg0KPiA+IEJ1dCBpdCBj
YW4gbm90IGFzc3VyZSB0aGF0IHJjdV9kZXJlZmVyZW5jZShiYXNlX2NoYWluLT5zdGF0cykgcmV0
dXJucyBOVUxMDQo+IHNpbmNlIG5mdF9jaGFpbl9zdGF0c19yZXBsYWNlLCBzaG91bGQgd2UgY2hl
Y2sgaXQgYWdhaW4sIG90aGVyIHRoYW4gY2hlY2sgdGhlDQo+IHJldHVybmluZyBvZiB0aGlzX2Nw
dV9wdHI/DQo+ID4NCj4gDQo+IFNvcnJ5IEkgZG8gbm90IHVuZGVyc3RhbmQgeW91ciBjb25jZXJu
Lg0KDQoNCiAgICBbUkZDXSBuZXRmaWx0ZXI6IGNoZWNrIHRoZSByZXN1bHQgb2YgZGVyZWZlcmVu
Y2luZyBiYXNlX2NoYWluLT5zdGF0cw0KICAgIA0KICAgIGNoZWNrIHRoZSByZXN1bHQgb2YgZGVy
ZWZlcmVuY2luZyBiYXNlX2NoYWluLT5zdGF0cywgaW5zdGVhZCBvZg0KICAgIHJlc3VsdCBvZiB0
aGlzX2NwdV9wdHINCiAgICANCiAgICBiYXNlX2NoYWluLT5zdGF0cyBtYXliZSBjaGFuZ2UgdG8g
TlVMTCB3aGVuIGEgY2hhaW4gaXMgdXBkYXRlZCwNCiAgICBhIE5VTEwgY291bnRlciBjYW4gYmUg
YXR0YWNoZWQNCiAgICANCiAgICBhbmQgd2UgZG8gbm90IG5lZWQgdG8gY2hlY2sgcmV0dXJuaW5n
IG9mIHRoaXNfY3B1X3B0ciBzaW5jZQ0KICAgIGJhc2VfY2hhaW4tPnN0YXRzIGlzIGFsbG9jYXRl
ZCBieSBwZXJjcHUgYWxsb2NhdG9yIGlmIGl0IGlzDQogICAgbm9uLU5VTEwsIHRoaXNfY3B1X3B0
ciByZXR1cm5zIGEgdmFsaWQgdmFsdWUNCg0KZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvbmZf
dGFibGVzX2NvcmUuYyBiL25ldC9uZXRmaWx0ZXIvbmZfdGFibGVzX2NvcmUuYw0KaW5kZXggMmEw
MGFlZjdiNmQ0Li5lZDhhMzgyZDEwMTIgMTAwNjQ0DQotLS0gYS9uZXQvbmV0ZmlsdGVyL25mX3Rh
Ymxlc19jb3JlLmMNCisrKyBiL25ldC9uZXRmaWx0ZXIvbmZfdGFibGVzX2NvcmUuYw0KQEAgLTk4
LDE1ICs5OCwxNiBAQCBzdGF0aWMgbm9pbmxpbmUgdm9pZCBuZnRfdXBkYXRlX2NoYWluX3N0YXRz
KGNvbnN0IHN0cnVjdCBuZnRfY2hhaW4gKmNoYWluLA0KICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3QgbmZ0X3BrdGluZm8gKnBrdCkNCiB7DQog
ICAgICAgIHN0cnVjdCBuZnRfYmFzZV9jaGFpbiAqYmFzZV9jaGFpbjsNCi0gICAgICAgc3RydWN0
IG5mdF9zdGF0cyAqc3RhdHM7DQorICAgICAgIHN0cnVjdCBuZnRfc3RhdHMgKnN0YXRzLCAqcHN0
YXRzOw0KIA0KICAgICAgICBiYXNlX2NoYWluID0gbmZ0X2Jhc2VfY2hhaW4oY2hhaW4pOw0KICAg
ICAgICBpZiAoIXJjdV9hY2Nlc3NfcG9pbnRlcihiYXNlX2NoYWluLT5zdGF0cykpDQogICAgICAg
ICAgICAgICAgcmV0dXJuOw0KIA0KICAgICAgICBsb2NhbF9iaF9kaXNhYmxlKCk7DQotICAgICAg
IHN0YXRzID0gdGhpc19jcHVfcHRyKHJjdV9kZXJlZmVyZW5jZShiYXNlX2NoYWluLT5zdGF0cykp
Ow0KLSAgICAgICBpZiAoc3RhdHMpIHsNCisgICAgICAgcHN0YXRzID0gcmN1X2RlcmVmZXJlbmNl
KGJhc2VfY2hhaW4tPnN0YXRzKTsNCisgICAgICAgaWYgKHBzdGF0cykgew0KKyAgICAgICAgICAg
ICAgIHN0YXRzID0gdGhpc19jcHVfcHRyKHBzdGF0cyk7DQogICAgICAgICAgICAgICAgdTY0X3N0
YXRzX3VwZGF0ZV9iZWdpbigmc3RhdHMtPnN5bmNwKTsNCiAgICAgICAgICAgICAgICBzdGF0cy0+
cGt0cysrOw0KICAgICAgICAgICAgICAgIHN0YXRzLT5ieXRlcyArPSBwa3QtPnNrYi0+bGVuOw0K
DQo=
