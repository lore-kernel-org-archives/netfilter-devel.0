Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F81BC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 04:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFCE92084D
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 04:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfBYEtl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Feb 2019 23:49:41 -0500
Received: from mx21.baidu.com ([220.181.3.85]:54977 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726399AbfBYEtl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Feb 2019 23:49:41 -0500
X-Greylist: delayed 1858 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2019 23:49:39 EST
Received: from M1-MAIL-EX16.internal.baidu.com (unknown [10.44.89.56])
        by Forcepoint Email with ESMTPS id 3CD05DEF9BE09;
        Mon, 25 Feb 2019 12:03:31 +0800 (CST)
Received: from BC-Mail-Ex13.internal.baidu.com (172.31.40.49) by
 M1-MAIL-EX16.internal.baidu.com (10.44.89.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Mon, 25 Feb 2019 12:03:32 +0800
Received: from BC-Mail-Ex13.internal.baidu.com ([172.31.40.49]) by
 Bc-Mail-Ex13.internal.baidu.com ([172.31.40.49]) with mapi id 15.01.1531.010;
 Mon, 25 Feb 2019 12:03:32 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIG5ldGZpbHRlcjogZm9yY2UgYWNjZXNzIG9mIFJD?=
 =?utf-8?B?VSBwcm90ZWN0ZWQgZGF0YSBpbiBuZnRfdXBkYXRlX2NoYWluX3N0YXRz?=
Thread-Topic: [PATCH] netfilter: force access of RCU protected data in
 nft_update_chain_stats
Thread-Index: AQHUzL036rQ47IvhCkSSk0/1m/0UX6Xv4vGQ
Date:   Mon, 25 Feb 2019 04:03:32 +0000
Message-ID: <b8ca2a794fdf4406a52ee4ecb78ef54b@baidu.com>
References: <1551059920-14120-1-git-send-email-lirongqing@baidu.com>
 <4818220f-1c66-df00-e397-4efbeba82665@gmail.com>
In-Reply-To: <4818220f-1c66-df00-e397-4efbeba82665@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.150.12]
x-baidu-bdmsfe-datecheck: 1_M1-MAIL-EX16_2019-02-25 12:03:32:527
x-baidu-bdmsfe-viruscheck: M1-MAIL-EX16_GRAY_Inside_WithoutAtta_2019-02-25
 12:03:32:511
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IEVyaWMgRHVtYXpldCBb
bWFpbHRvOmVyaWMuZHVtYXpldEBnbWFpbC5jb21dDQo+IOWPkemAgeaXtumXtDogMjAxOeW5tDLm
nIgyNeaXpSAxMTo1MA0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1
LmNvbT47IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcNCj4g5Li76aKYOiBSZTogW1BB
VENIXSBuZXRmaWx0ZXI6IGZvcmNlIGFjY2VzcyBvZiBSQ1UgcHJvdGVjdGVkIGRhdGEgaW4NCj4g
bmZ0X3VwZGF0ZV9jaGFpbl9zdGF0cw0KPiANCj4gDQo+IA0KPiBPbiAwMi8yNC8yMDE5IDA1OjU4
IFBNLCBMaSBSb25nUWluZyB3cm90ZToNCj4gPiBiYXNlY2hhaW4tPnN0YXRzIGlzIHJjdSBwcm90
ZWN0ZWQgZGF0YSwgY2Fubm90IGFzc3VyZSB0aGF0DQo+ID4gdHdpY2UgYWNjZXNzZXMgaGF2ZSB0
aGUgc2FtZSByZXN1bHQsIHNvIGRlcmVmZXJlbmNlIGl0IG9uY2UuDQo+ID4NCj4gPiBiYXNlY2hh
aW4tPnN0YXRzIGlzIGFsbG9jYXRlZCBieSBwZXJjcHUgYWxsb2NhdGVyLCBpZiBpdCBpcyBub3Qg
TlVMTCwNCj4gPiBpdHMgcGVyY3B1IHZhcmlhYmxlIGRvZXMgbm90IG5lZWQgdG8gYmUgY2hlY2tl
ZCB3aXRoIE5VTEwNCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFpoYW5nIFl1IDx6aGFuZ3l1MzFA
YmFpZHUuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJh
aWR1LmNvbT4NCj4gPiAtLS0NCj4gPiAgbmV0L25ldGZpbHRlci9uZl90YWJsZXNfY29yZS5jIHwg
MTggKysrKysrKysrLS0tLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMo
KyksIDkgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9u
Zl90YWJsZXNfY29yZS5jDQo+ID4gYi9uZXQvbmV0ZmlsdGVyL25mX3RhYmxlc19jb3JlLmMgaW5k
ZXggMmEwMGFlZjdiNmQ0Li45YmU2MjJjNzZhNjINCj4gPiAxMDA2NDQNCj4gPiAtLS0gYS9uZXQv
bmV0ZmlsdGVyL25mX3RhYmxlc19jb3JlLmMNCj4gPiArKysgYi9uZXQvbmV0ZmlsdGVyL25mX3Rh
Ymxlc19jb3JlLmMNCj4gPiBAQCAtOTgsMjAgKzk4LDIwIEBAIHN0YXRpYyBub2lubGluZSB2b2lk
IG5mdF91cGRhdGVfY2hhaW5fc3RhdHMoY29uc3QNCj4gc3RydWN0IG5mdF9jaGFpbiAqY2hhaW4s
DQo+ID4gIAkJCQkJICAgIGNvbnN0IHN0cnVjdCBuZnRfcGt0aW5mbyAqcGt0KSAgew0KPiA+ICAJ
c3RydWN0IG5mdF9iYXNlX2NoYWluICpiYXNlX2NoYWluOw0KPiA+IC0Jc3RydWN0IG5mdF9zdGF0
cyAqc3RhdHM7DQo+ID4gKwlzdHJ1Y3QgbmZ0X3N0YXRzICpzdGF0cywgKnBzdGF0Ow0KPiA+DQo+
ID4gIAliYXNlX2NoYWluID0gbmZ0X2Jhc2VfY2hhaW4oY2hhaW4pOw0KPiA+IC0JaWYgKCFyY3Vf
YWNjZXNzX3BvaW50ZXIoYmFzZV9jaGFpbi0+c3RhdHMpKQ0KPiA+ICsNCj4gPiArCXN0YXRzID0g
cmN1X2RlcmVmZXJlbmNlKGJhc2VfY2hhaW4tPnN0YXRzKTsNCj4gDQo+IFRoaXMgbG9va3MgYm9n
dXMgdG8gbWUuDQo+IA0KPiBXaGVyZSBpcyB0aGUgbmVlZGVkIHJjdV9yZWFkX2xvY2soKSBiZWZv
cmUgcmN1X2RlcmVmZXJlbmNlKCkgPw0KPiANCg0KT2ssIEkgd2lsbCBjaGVjayBpdCBjYXJlZnVs
bHkuDQoNCj4gVGhpcyByY3VfYWNjZXNzX3BvaW50ZXIoKSB0ZXN0IGlzIGZpbmUsIGFuZCBhdm9p
ZHMgYQ0KPiBsb2NhbF9iaF9kaXNhYmxlKCkvbG9jYWxfYmhfZW5hYmxlKCkNCj4gaWYgdGhleSBh
cmUgbm90IG5lZWRlZC4NCg0KDQoNCkJ1dCBpdCBjYW4gbm90IGFzc3VyZSB0aGF0IHJjdV9kZXJl
ZmVyZW5jZShiYXNlX2NoYWluLT5zdGF0cykgcmV0dXJucyBOVUxMIHNpbmNlIG5mdF9jaGFpbl9z
dGF0c19yZXBsYWNlLCBzaG91bGQgd2UgY2hlY2sgaXQgYWdhaW4sIG90aGVyIHRoYW4gY2hlY2sg
dGhlIHJldHVybmluZyBvZiB0aGlzX2NwdV9wdHI/DQoNCg0KdGhhbmtzDQoNCi1Sb25nUWluZw0K
DQo=
