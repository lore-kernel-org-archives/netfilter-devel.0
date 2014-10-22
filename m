From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH] netfilter: xt_hashlimit: Enhance the xt_hashlimit to
 avoid duplicated codes
Date: Wed, 22 Oct 2014 10:17:29 +0800
Message-ID: <CA+6hz4oNpn0OfuJNiwG_wLBGOZddgEdvvJPPnEot7sRqDV6EnA@mail.gmail.com>
References: <CA+6hz4o-2vSEzH+hjYAUfWRVqHQ3QfcCr8q11eoRpCTq2uTYtg@mail.gmail.com>
	<20141021153128.GA3657@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=bcaec517c9d8b4af940505f98cd3
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33624 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaJVCRa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 22:17:30 -0400
Received: by mail-ig0-f169.google.com with SMTP id uq10so120351igb.2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2014 19:17:29 -0700 (PDT)
In-Reply-To: <20141021153128.GA3657@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--bcaec517c9d8b4af940505f98cd3
Content-Type: text/plain; charset=UTF-8

Firstly, I am sorry about many cc lists, and they are gotten by the
script "scripts/get_maintainer.pl"

Now I send the patch as attachment, is it OK?

On Tue, Oct 21, 2014 at 11:31 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Oct 21, 2014 at 11:23:16PM +0800, Feng Gao wrote:
>> Hi all,
>>
>> Enhance the functions "dsthash_alloc_init" and "hashlimit_mt" in file
>> "xt_hashlimit.c" to avoid two duplicated codes following:
>>
>> -           dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
>> -           rateinfo_recalc(dh, now, hinfo->cfg.mode);
>>
>>
>> The whole patch is following
>
> The patch seems mangled by your MUA.
>
> BTW, you can just Cc netfilter patches to
> netfilter-devel@vger.kernel.org. No need to Cc that many people.
>

--bcaec517c9d8b4af940505f98cd3
Content-Type: application/octet-stream;
	name="0001-netfilter-Enhance-the-xt_hashlimit-to-avoid-duplicat.patch"
Content-Disposition: attachment;
	filename="0001-netfilter-Enhance-the-xt_hashlimit-to-avoid-duplicat.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1k1vbkr0

RnJvbSAxZjA4ZmFjOTBlMTkxZjZiYjhiYTIzNmQ0OGRlZWJlM2FjYWQ1MWI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBmZ2FvIDxnZnJlZS53aW5kQGdtYWlsLmNvbT4KRGF0ZTogVHVl
LCAyMSBPY3QgMjAxNCAwODoxMjowMCAtMDcwMApTdWJqZWN0OiBbUEFUQ0ggMS8xXSBuZXRmaWx0
ZXI6IEVuaGFuY2UgdGhlIHh0X2hhc2hsaW1pdCB0byBhdm9pZCBkdXBsaWNhdGVkCiBjb2RlcwoK
U2lnbmVkLW9mZi1ieTogZmdhbyA8Z2ZyZWUud2luZEBnbWFpbC5jb20+Ci0tLQogbmV0L25ldGZp
bHRlci94dF9oYXNobGltaXQuYyB8IDIxICsrKysrKysrKystLS0tLS0tLS0tLQogMSBmaWxlIGNo
YW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQogbW9kZSBjaGFuZ2UgMTAw
NjQ0ID0+IDEwMDc1NSBuZXQvbmV0ZmlsdGVyL3h0X2hhc2hsaW1pdC5jCgpkaWZmIC0tZ2l0IGEv
bmV0L25ldGZpbHRlci94dF9oYXNobGltaXQuYyBiL25ldC9uZXRmaWx0ZXIveHRfaGFzaGxpbWl0
LmMKb2xkIG1vZGUgMTAwNjQ0Cm5ldyBtb2RlIDEwMDc1NQppbmRleCAwNWZiYzJhLi4wNmRlZDE1
Ci0tLSBhL25ldC9uZXRmaWx0ZXIveHRfaGFzaGxpbWl0LmMKKysrIGIvbmV0L25ldGZpbHRlci94
dF9oYXNobGltaXQuYwpAQCAtMTU4LDcgKzE1OCw3IEBAIGRzdGhhc2hfZmluZChjb25zdCBzdHJ1
Y3QgeHRfaGFzaGxpbWl0X2h0YWJsZSAqaHQsCiAvKiBhbGxvY2F0ZSBkc3RoYXNoX2VudCwgaW5p
dGlhbGl6ZSBkc3QsIHB1dCBpbiBodGFibGUgYW5kIGxvY2sgaXQgKi8KIHN0YXRpYyBzdHJ1Y3Qg
ZHN0aGFzaF9lbnQgKgogZHN0aGFzaF9hbGxvY19pbml0KHN0cnVjdCB4dF9oYXNobGltaXRfaHRh
YmxlICpodCwKLQkJICAgY29uc3Qgc3RydWN0IGRzdGhhc2hfZHN0ICpkc3QsIGJvb2wgKnJhY2Up
CisJCSAgIGNvbnN0IHN0cnVjdCBkc3RoYXNoX2RzdCAqZHN0LCBib29sICpuZXdfb25lKQogewog
CXN0cnVjdCBkc3RoYXNoX2VudCAqZW50OwogCkBAIC0xNzAsNyArMTcwLDYgQEAgZHN0aGFzaF9h
bGxvY19pbml0KHN0cnVjdCB4dF9oYXNobGltaXRfaHRhYmxlICpodCwKIAllbnQgPSBkc3RoYXNo
X2ZpbmQoaHQsIGRzdCk7CiAJaWYgKGVudCAhPSBOVUxMKSB7CiAJCXNwaW5fdW5sb2NrKCZodC0+
bG9jayk7Ci0JCSpyYWNlID0gdHJ1ZTsKIAkJcmV0dXJuIGVudDsKIAl9CiAKQEAgLTE5Niw2ICsx
OTUsOCBAQCBkc3RoYXNoX2FsbG9jX2luaXQoc3RydWN0IHh0X2hhc2hsaW1pdF9odGFibGUgKmh0
LAogCQlodC0+Y291bnQrKzsKIAl9CiAJc3Bpbl91bmxvY2soJmh0LT5sb2NrKTsKKwkqbmV3X29u
ZSA9IHRydWU7CisJCiAJcmV0dXJuIGVudDsKIH0KIApAQCAtNjEwLDcgKzYxMSw3IEBAIGhhc2hs
aW1pdF9tdChjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgeHRfYWN0aW9uX3BhcmFt
ICpwYXIpCiAJdW5zaWduZWQgbG9uZyBub3cgPSBqaWZmaWVzOwogCXN0cnVjdCBkc3RoYXNoX2Vu
dCAqZGg7CiAJc3RydWN0IGRzdGhhc2hfZHN0IGRzdDsKLQlib29sIHJhY2UgPSBmYWxzZTsKKwli
b29sIG5ld19vbmUgPSBmYWxzZTsKIAl1MzIgY29zdDsKIAogCWlmIChoYXNobGltaXRfaW5pdF9k
c3QoaGluZm8sICZkc3QsIHNrYiwgcGFyLT50aG9mZikgPCAwKQpAQCAtNjE5LDE4ICs2MjAsMTYg
QEAgaGFzaGxpbWl0X210KGNvbnN0IHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCB4dF9hY3Rp
b25fcGFyYW0gKnBhcikKIAlyY3VfcmVhZF9sb2NrX2JoKCk7CiAJZGggPSBkc3RoYXNoX2ZpbmQo
aGluZm8sICZkc3QpOwogCWlmIChkaCA9PSBOVUxMKSB7Ci0JCWRoID0gZHN0aGFzaF9hbGxvY19p
bml0KGhpbmZvLCAmZHN0LCAmcmFjZSk7CisJCWRoID0gZHN0aGFzaF9hbGxvY19pbml0KGhpbmZv
LCAmZHN0LCAmbmV3X29uZSk7CiAJCWlmIChkaCA9PSBOVUxMKSB7CiAJCQlyY3VfcmVhZF91bmxv
Y2tfYmgoKTsKIAkJCWdvdG8gaG90ZHJvcDsKLQkJfSBlbHNlIGlmIChyYWNlKSB7Ci0JCQkvKiBB
bHJlYWR5IGdvdCBhbiBlbnRyeSwgdXBkYXRlIGV4cGlyYXRpb24gdGltZW91dCAqLwotCQkJZGgt
PmV4cGlyZXMgPSBub3cgKyBtc2Vjc190b19qaWZmaWVzKGhpbmZvLT5jZmcuZXhwaXJlKTsKLQkJ
CXJhdGVpbmZvX3JlY2FsYyhkaCwgbm93LCBoaW5mby0+Y2ZnLm1vZGUpOwotCQl9IGVsc2Ugewot
CQkJZGgtPmV4cGlyZXMgPSBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyhoaW5mby0+Y2ZnLmV4
cGlyZSk7Ci0JCQlyYXRlaW5mb19pbml0KGRoLCBoaW5mbyk7CiAJCX0KKwl9CisKKwlpZiAobmV3
X29uZSkgeworCQlkaC0+ZXhwaXJlcyA9IGppZmZpZXMgKyBtc2Vjc190b19qaWZmaWVzKGhpbmZv
LT5jZmcuZXhwaXJlKTsKKwkJcmF0ZWluZm9faW5pdChkaCwgaGluZm8pOwogCX0gZWxzZSB7CiAJ
CS8qIHVwZGF0ZSBleHBpcmF0aW9uIHRpbWVvdXQgKi8KIAkJZGgtPmV4cGlyZXMgPSBub3cgKyBt
c2Vjc190b19qaWZmaWVzKGhpbmZvLT5jZmcuZXhwaXJlKTsKLS0gCjEuOS4xCgo=
--bcaec517c9d8b4af940505f98cd3--
