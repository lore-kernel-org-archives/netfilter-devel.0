From: "Liping Zhang" <zlpnobody@163.com>
Subject: Re: [PATCH nf 1/3] netfilter: conntrack: fix race between
 nf_conntrack proc read and hash resize
Date: Sun, 3 Jul 2016 10:22:10 +0800 (CST)
Message-ID: <3d7eb75e.22de.155ae9025a4.Coremail.zlpnobody@163.com>
References: <1467457167-5363-1-git-send-email-zlpnobody@163.com>
 <1467457167-5363-2-git-send-email-zlpnobody@163.com>
 <20160702174612.GD24701@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	"Liping Zhang" <liping.zhang@spreadtrum.com>
To: "Florian Westphal" <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m13-148.163.com ([220.181.13.148]:59513 "EHLO m13-148.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbcGCChq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Jul 2016 22:37:46 -0400
In-Reply-To: <20160702174612.GD24701@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pkdvb2QgY2F0Y2gsIGJ1dCAuLi4KPgo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvbmV0Zmls
dGVyL25mX2Nvbm50cmFja19jb3JlLmggYi9pbmNsdWRlL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRy
YWNrX2NvcmUuaAo+PiBpbmRleCAzZTJmMzMyLi40ZjY0NTNhIDEwMDY0NAo+PiAtLS0gYS9pbmNs
dWRlL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUuaAo+PiArKysgYi9pbmNsdWRlL25l
dC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUuaAo+PiBAQCAtODIsNiArODIsNyBAQCBwcmlu
dF90dXBsZShzdHJ1Y3Qgc2VxX2ZpbGUgKnMsIGNvbnN0IHN0cnVjdCBuZl9jb25udHJhY2tfdHVw
bGUgKnR1cGxlLAo+PiAgI2RlZmluZSBDT05OVFJBQ0tfTE9DS1MgMTAyNAo+PiAgCj4+ICBleHRl
cm4gc3RydWN0IGhsaXN0X251bGxzX2hlYWQgKm5mX2Nvbm50cmFja19oYXNoOwo+PiArZXh0ZXJu
IHNlcWNvdW50X3QgbmZfY29ubnRyYWNrX2dlbmVyYXRpb247Cj4KPmluc3RlYWQgb2YgdGhpcyBh
bmQgdGhlIHByb2xpZmVyYXRpb24gb2YgdGhpczoKPgo+PiArCWRvIHsKPj4gKwkJc2VxdWVuY2Ug
PSByZWFkX3NlcWNvdW50X2JlZ2luKCZuZl9jb25udHJhY2tfZ2VuZXJhdGlvbik7Cj4+ICsJCXN0
LT5odGFibGVfc2l6ZSA9IG5mX2Nvbm50cmFja19odGFibGVfc2l6ZTsKPj4gKwkJc3QtPmhhc2gg
PSBuZl9jb25udHJhY2tfaGFzaDsKPj4gKwl9IHdoaWxlIChyZWFkX3NlcWNvdW50X3JldHJ5KCZu
Zl9jb25udHJhY2tfZ2VuZXJhdGlvbiwgc2VxdWVuY2UpKTsKPj4gKwo+PiAgCXJldHVybiBjdF9n
ZXRfaWR4KHNlcSwgKnBvcyk7Cj4+ICB9Cj4KPkkgdGhpbmsgaXQgbWlnaHQgYmUgYmV0dGVyIHRv
IGRvIHNvbWV0aGluZyBsaWtlCj4KPi8qIG11c3QgYmUgY2FsbGVkIHdpdGggcmN1IHJlYWQgbG9j
ayBoZWxkICovCj51bnNpZ25lZCBpbnQgbmZfY29ubnRyYWNrX2dldF9odChzdHJ1Y3QgaGxpc3Rf
bnVsbHNfaGVhZCAqaCwKPgkJCSAgICAgICAgIHVuc2lnbmVkIGludCAqYnVja2V0cykKPnsKPglk
byB7Cj4JCXMgPSByZWFkX3NlcSAuLi4KPgkJc2l6ZSA9IG5mX2Nvbm50cmFja19odGFibGVfc2l6
ZTsKPgkJcHRyID0gbmZfY29ubnRyYWNrX2hhc2g7Cj4JfSB3aGlsZSAuLi4KPgo+CSpoID0gcHRy
Owo+CSpidWNrZXRzID0gc2l6ZTsKPgo+CXJldHVybiBzOwoKQWdyZWUuCgpBbmQgSSBhbHNvIGZp
bmQgdGhlcmUncyBubyBuZWVkIHRvIHVzZSBuZl9jb25udHJhY2tfZ2VuZXJhdGlvbiBpbiBteSBw
YXRjaCAjMiBhbmQgIzMuCldpbGwgc2VuZCBWMiBsYXRlci4KClRoYW5rcw==
