From: "Gao Feng" <gfree.wind@vip.163.com>
Subject: Re:Re: [PATCH nf v6 3/3] netfilter: nat_helper: Remove the
 expectations when its module is unloaded
Date: Fri, 5 May 2017 10:16:02 +0800 (CST)
Message-ID: <8ccdcf7.2344.15bd66481be.Coremail.gfree.wind@vip.163.com>
References: <1493945713-67263-1-git-send-email-gfree.wind@vip.163.com>
 <1493945713-67263-3-git-send-email-gfree.wind@vip.163.com>
 <CAML_gOfbrRG8LDD11PzpMmGqnq0-JpXKGk4Z=OJH3gEDnzCCxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64
Cc: "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>,
        "Florian Westphal" <fw@strlen.de>,
        "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Liping Zhang" <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from proxy90-7.mail.163.com ([43.230.90.7]:34266 "EHLO
        proxy90-7.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbdEECRA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 22:17:00 -0400
In-Reply-To: <CAML_gOfbrRG8LDD11PzpMmGqnq0-JpXKGk4Z=OJH3gEDnzCCxg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SGkgTGlwaW5nLAoKQXQgMjAxNy0wNS0wNSAwOTo1OTowNiwgIkxpcGluZyBaaGFuZyIgPHpscG5v
Ym9keUBnbWFpbC5jb20+IHdyb3RlOgo+SGkgRmVuZywKPgo+MjAxNy0wNS0wNSA4OjU1IEdNVCsw
ODowMCAgPGdmcmVlLndpbmRAdmlwLjE2My5jb20+Ogo+Wy4uLl0KPj4gK3N0YXRpYyB2b2lkCj4+
ICtuZl9jdF9mbHVzaF9leHBlY3QoY29uc3Qgc3RydWN0IG1vZHVsZSAqbWUpCj4+ICt7Cj4+ICsg
ICAgICAgc3RydWN0IG5mX2Nvbm50cmFja19leHBlY3QgKmV4cDsKPj4gKyAgICAgICBjb25zdCBz
dHJ1Y3QgaGxpc3Rfbm9kZSAqbmV4dDsKPj4gKyAgICAgICB1MzIgaTsKPj4gKwo+PiArICAgICAg
IGlmICghbWUpCj4+ICsgICAgICAgICAgICAgICByZXR1cm47Cj4+ICsKPj4gKyAgICAgICAvKiBH
ZXQgcmlkIG9mIGV4cGVjdGF0aW9ucyAqLwo+PiArICAgICAgIHNwaW5fbG9ja19iaCgmbmZfY29u
bnRyYWNrX2V4cGVjdF9sb2NrKTsKPj4gKyAgICAgICBmb3IgKGkgPSAwOyBpIDwgbmZfY3RfZXhw
ZWN0X2hzaXplOyBpKyspIHsKPj4gKyAgICAgICAgICAgICAgIGhsaXN0X2Zvcl9lYWNoX2VudHJ5
X3NhZmUoZXhwLCBuZXh0LAo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAmbmZfY3RfZXhwZWN0X2hhc2hbaV0sIGhub2RlKSB7Cj4+ICsgICAgICAgICAgICAgICAg
ICAgICAgIHN0cnVjdCBuZl9jb25uX2hlbHAgKm1hc3Rlcl9oZWxwID0gbmZjdF9oZWxwKGV4cC0+
bWFzdGVyKTsKPj4gKwo+PiArICAgICAgICAgICAgICAgICAgICAgICBpZiAoKG1hc3Rlcl9oZWxw
LT5oZWxwZXIgJiYgbWFzdGVyX2hlbHAtPmhlbHBlci0+bWUgPT0gbWUpIHx8Cj4+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAoZXhwLT5oZWxwZXIgJiYgZXhwLT5oZWxwZXItPm1lID09IG1l
KSB8fAo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgKGV4cC0+bmF0X2hlbHBlciAmJiBl
eHAtPm5hdF9oZWxwZXItPm1lID09IG1lKSkgewo+PiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIC8qIFRoaXMgZXhwZWN0IGJlbG9uZ3MgdG8gdGhlIGR5aW5nIG1vZHVsZSAqLwo+PiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChkZWxfdGltZXIoJmV4cC0+dGltZW91
dCkpIHsKPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG5mX2N0X3Vu
bGlua19leHBlY3QoZXhwKTsKPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIG5mX2N0X2V4cGVjdF9wdXQoZXhwKTsKPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB9Cj4KPklzIHRoaXMgc2hvdWxkIGJlIHJlcGxhY2VkIHdpdGggeW91ciBoZWxwZXIgZnVu
Y3Rpb24gbmZfY3RfcmVtb3ZlX2V4cGVjdCgpPwoKVGhhbmtzLiBCZWNhdXNlIHRoaXMgaGVscGVy
IHdhcyBhcHBsaWVkIGluIG5mLW5leHQuZ2l0IGJlZm9yZSwgbm90IG5mLmdpdC4KU28gSSBkaWRu
J3QgdXNlIHRoZSBoZWxwZXIgZnVuY3Rpb24uIEkganVzdCBjaGVja2VkIHNvbWUgZGF5cyBhZ28u
CgpJIHB1bGwgdGhlIG5mLmdpdCBjb2RlcyBqdXN0IG5vdywgdGhlIGhlbHBlciBpcyBhbHJlYWR5
IHN5bmNocm9uaXplZCBhdCBNYXkgMXN0LiAgCkJ1dCBJIGRvbid0IHB1bGwgdGhlIGNvZGVzIHJl
Y2VudGx5LCBzbyBJIGRpZG4ndCBmaW5kIGl0IGJlZm9yZS4KCkkgd291bGQgbGlrZSB0byB1cGRh
dGUgaXQsIGJ1dCBuZWVkIHRvIHdhaXQgZm9yIGEgd2hpbGUgdG8gY29sbGVjdCBtb3JlIGNvbW1l
bnRzLgpUaGFua3MgYWdhaW4uCgpCZXN0IFJlZ2FyZHMKRmVuZwo+Cj4+ICsgICAgICAgICAgICAg
ICAgICAgICAgIH0KPj4gKyAgICAgICAgICAgICAgIH0KPj4gKyAgICAgICB9Cj4+ICsgICAgICAg
c3Bpbl91bmxvY2tfYmgoJm5mX2Nvbm50cmFja19leHBlY3RfbG9jayk7Cgo=
