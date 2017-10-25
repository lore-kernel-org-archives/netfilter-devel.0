From: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Subject: nftables rules not matching after upgrading from 0.7 to 0.8
Date: Wed, 25 Oct 2017 16:31:55 +0000
Message-ID: <1508949114.1154.14.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bender.cohaesio.com ([212.97.128.130]:50913 "EHLO
        mail.cohaesio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751702AbdJYQb6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2017 12:31:58 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.cohaesio.com (Postfix) with ESMTP id 7C3E37804C5E
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2017 18:31:56 +0200 (CEST)
Received: from mail.cohaesio.com ([127.0.0.1])
        by localhost (bender.cohaesio.com [127.0.0.1]) (amavisd-new, port 10028)
        with LMTP id pgU1aMdym7rV for <netfilter-devel@vger.kernel.org>;
        Wed, 25 Oct 2017 18:31:56 +0200 (CEST)
Received: from cohexch02.cohaesio.com (cohexch02.cohaesio.com [212.97.128.232])
        by mail.cohaesio.com (Postfix) with ESMTP id 5F8D47800D28
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2017 18:31:56 +0200 (CEST)
Content-Language: en-US
Content-ID: <C3D90F385AD05B4E977257AEEDE2AE8A@surftown.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SGVsbG8sDQoNCkFmdGVyIHVwZ3JhZGluZyB0byBuZnRhYmxlcyAwLjggKGZyb20gMC43KSBvbiBv
bmUgb2YgbXkgc3lzdGVtcywgSSd2ZQ0KZXhwZXJpZW5jZXMgc2V2ZXJhbCBjYXNlcyB3aGVyZSBy
dWxlcyB0aGF0IHVzZWQgdG8gd29yayBmaW5lIHdpdGggMC43DQpzb21ldGltZXMgZG9lc24ndCBt
YXRjaCBhbnltb3JlIHdpdGggMC44IChpdCdzIG5vdCBjb25zaXN0ZW50IC0NCnNvbWV0aW1lcyB0
aGUgcnVsZXMgZG8gbWF0Y2ggd2l0aCAwLjgpLg0KDQpUaGUgcnVsZSBjaGFpbnMgZW5kIHdpdGgg
YSBsb2cgc3RhdGVtZW50IGJlZm9yZSByZWplY3Rpbmcgb3IgZHJvcHBpbmcNCnRoZSBwYWNrZXRz
LCBhbmQgSSBjYW4gc2VlIGluIHRoZSBsb2cgdGhhdCBldmVyeXRoaW5nIGlzIGFzIGV4cGVjdGVk
DQphbmQgdGhlIHJ1bGVzIHNob3VsZCBtYXRjaC4gQWZ0ZXIgZG93bmdyYWRpbmcgdG8gbmZ0YWJs
ZXMgMC43DQpldmVyeXRoaW5nIHdvcmtzIGFnYWluLg0KDQpJIHRyaWVkIGxvYWRpbmcgbXkgcnVs
ZSBzZXQgd2l0aCAiLS1kZWJ1Zz1uZXRsaW5rIiBhbmQgZGlmZiB0aGUgb3V0cHV0DQpmcm9tIDAu
NyB2cy4gMC44LiBBcGFydCBmcm9tIHN5bnRheCBkaWZmZXJlbmNlcyB0aGUgb25seSB0aGluZyB0
aGF0DQpjaGFuZ2VkIGlzDQoNCiBpcCBmaWx0ZXIgaW5wdXQgDQotICBbIHBheWxvYWQgbG9hZCAx
YiBAIG5ldHdvcmsgaGVhZGVyICsgOSA9PiByZWcgMSBdDQorICBbIG1ldGEgbG9hZCBsNHByb3Rv
ID0+IHJlZyAxIF0NCg0KYW5kDQoNCiBpcDYgZmlsdGVyIGlucHV0IA0KLSAgWyBwYXlsb2FkIGxv
YWQgMWIgQCBuZXR3b3JrIGhlYWRlciArIDYgPT4gcmVnIDEgXQ0KKyAgWyBtZXRhIGxvYWQgbDRw
cm90byA9PiByZWcgMSBdDQoNCmZvciBtYW55IG9mIHRoZSBydWxlcy4gSSBiZWxpZXZlIHRoaXMg
aXMgaW50ZW50aW9uYWwgYW5kIGNvcnJlY3QgYnkNCml0c2VsZiwgc28gSSBndWVzcyB0aGUgcHJv
YmxlbSBpcyBpbiB0aGUga2VybmVsICh0aGUgc3lzdGVtIGlzDQpjdXJyZW50bHkgcnVubmluZyA0
LjEzLjgpLCB3aGVyZSAibWV0YSBsNHByb3RvIiBzb21ldGltZXMgaXNuJ3Qgd2hhdCBpdA0Kc2hv
dWxkIGJlLg0KDQpEb2VzIHRoaXMgc291bmQgcmlnaHQgYW5kIGRvZXMgaXQgcmluZyBhbnkgYmVs
bHM/DQoNClJlZ2FyZHMsDQpBbmRlcnMgSy4gUGVkZXJzZW4=
