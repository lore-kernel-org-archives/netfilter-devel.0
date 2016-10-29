From: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Subject: [PATCH nftables] Allow concatenation of rt nexthop etc.
Date: Sat, 29 Oct 2016 09:49:09 +0000
Message-ID: <1477734549.1059.65.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bender.cohaesio.com ([212.97.128.130]:58908 "EHLO
        mail.cohaesio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932597AbcJ2JtN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2016 05:49:13 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.cohaesio.com (Postfix) with ESMTP id 670C0780261F
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2016 11:49:10 +0200 (CEST)
Received: from mail.cohaesio.com ([127.0.0.1])
        by localhost (bender.cohaesio.com [127.0.0.1]) (amavisd-new, port 10028)
        with LMTP id a+mXUesHb64h for <netfilter-devel@vger.kernel.org>;
        Sat, 29 Oct 2016 11:49:10 +0200 (CEST)
Received: from cohexch02.cohaesio.com (cohexch02.cohaesio.com [212.97.128.232])
        by mail.cohaesio.com (Postfix) with ESMTP id 49A0C780162D
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2016 11:49:10 +0200 (CEST)
Content-Language: en-US
Content-ID: <97871BD2F0B03140B3C3AEF5A6A84217@surftown.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

RnJvbTogQW5kZXJzIEsuIFBlZGVyc2VuIDxha3BAY29oYWVzaW8uY29tPg0KDQpDb25jYXRlbmF0
aW9ucyBvZiBydCBuZXh0aG9wIG9yIGN0IHtvcmlnbmFsIHwgcmVwbHl9IHtzYWRkciB8IGRhZGRy
fSBmYWlsDQpkdWUgdG8NCg0KICMgbmZ0IGFkZCBydWxlIGlwIGZpbHRlciBwb3N0cm91dGluZyBm
bG93IHRhYmxlIGFjY3QgXHsgaXAgc2FkZHIgLiBydCBuZXh0aG9wIGNvdW50ZXIgXH0NCiA8Y21k
bGluZT46MTo2MS03MDogRXJyb3I6IGNhbiBub3QgdXNlIHZhcmlhYmxlIHNpemVkIGRhdGEgdHlw
ZXMgKGludmFsaWQpIGluIGNvbmNhdCBleHByZXNzaW9ucw0KIGFkZCBydWxlIGlwIGZpbHRlciBw
b3N0cm91dGluZyBmbG93IHRhYmxlIGFjY3QgeyBpcCBzYWRkciAuIHJ0IG5leHRob3AgY291bnRl
ciB9DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH5+
fn5+fn5+fn5+Xl5eXl5eXl5eXg0KDQpGaXggdGhpcyBieSByZW9yZGVyaW5nIHRoZSBjaGVjayBm
b3IgdmFyaWFibGUgc2l6ZSBkYXRhIHR5cGVzIGluDQpleHByX2V2YWx1YXRlX2NvbmNhdCgpIHRv
IGhhcHBlbiBhZnRlciBleHByX2V2YWx1YXRlKCkgaGFzIGJlZW4gY2FsbGVkICh2aWENCmxpc3Rf
bWVtYmVyX2V2YWx1YXRlKCkpIGZvciB0aGUgc3ViIGV4cHJlc3Npb24uIFRoaXMgYWxsb3dzDQpl
eHByX2V2YWx1YXRlX1tjcl10KCkgdG8gY2FsbCBbY3JddF9leHByX3VwZGF0ZV90eXBlKCkgYW5k
IHNldCB0aGUgZGF0YSB0eXBlDQpiZWZvcmUgdGhlIGNoZWNrLg0KDQpTaWduZWQtb2ZmLWJ5OiBB
bmRlcnMgSy4gUGVkZXJzZW4gPGFrcEBjb2hhZXNpby5jb20+DQotLS0NCiBzcmMvZXZhbHVhdGUu
YyB8IDE0ICsrKysrKystLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwg
NyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL3NyYy9ldmFsdWF0ZS5jIGIvc3JjL2V2YWx1
YXRlLmMNCmluZGV4IDc5YWRkNWUuLjg3OGVmYWMgMTAwNjQ0DQotLS0gYS9zcmMvZXZhbHVhdGUu
Yw0KKysrIGIvc3JjL2V2YWx1YXRlLmMNCkBAIC05ODcsMTMgKzk4Nyw2IEBAIHN0YXRpYyBpbnQg
ZXhwcl9ldmFsdWF0ZV9jb25jYXQoc3RydWN0IGV2YWxfY3R4ICpjdHgsIHN0cnVjdCBleHByICoq
ZXhwcikNCiAJCQkJCQkgImV4cGVjdGluZyAlcyIsDQogCQkJCQkJIGR0eXBlLT5kZXNjKTsNCiAN
Ci0JCWlmIChkdHlwZSA9PSBOVUxMICYmIGktPmR0eXBlLT5zaXplID09IDApDQotCQkJcmV0dXJu
IGV4cHJfYmluYXJ5X2Vycm9yKGN0eC0+bXNncywgaSwgKmV4cHIsDQotCQkJCQkJICJjYW4gbm90
IHVzZSB2YXJpYWJsZSBzaXplZCAiDQotCQkJCQkJICJkYXRhIHR5cGVzICglcykgaW4gY29uY2F0
ICINCi0JCQkJCQkgImV4cHJlc3Npb25zIiwNCi0JCQkJCQkgaS0+ZHR5cGUtPm5hbWUpOw0KLQ0K
IAkJaWYgKGR0eXBlID09IE5VTEwpDQogCQkJdG1wID0gZGF0YXR5cGVfbG9va3VwKFRZUEVfSU5W
QUxJRCk7DQogCQllbHNlDQpAQCAtMTAwNCw2ICs5OTcsMTMgQEAgc3RhdGljIGludCBleHByX2V2
YWx1YXRlX2NvbmNhdChzdHJ1Y3QgZXZhbF9jdHggKmN0eCwgc3RydWN0IGV4cHIgKipleHByKQ0K
IAkJCXJldHVybiAtMTsNCiAJCWZsYWdzICY9IGktPmZsYWdzOw0KIA0KKwkJaWYgKGR0eXBlID09
IE5VTEwgJiYgaS0+ZHR5cGUtPnNpemUgPT0gMCkNCisJCQlyZXR1cm4gZXhwcl9iaW5hcnlfZXJy
b3IoY3R4LT5tc2dzLCBpLCAqZXhwciwNCisJCQkJCQkgImNhbiBub3QgdXNlIHZhcmlhYmxlIHNp
emVkICINCisJCQkJCQkgImRhdGEgdHlwZXMgKCVzKSBpbiBjb25jYXQgIg0KKwkJCQkJCSAiZXhw
cmVzc2lvbnMiLA0KKwkJCQkJCSBpLT5kdHlwZS0+bmFtZSk7DQorDQogCQludHlwZSA9IGNvbmNh
dF9zdWJ0eXBlX2FkZChudHlwZSwgaS0+ZHR5cGUtPnR5cGUpOw0KIAl9DQogDQo=
