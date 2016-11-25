From: "Liping Zhang" <zlpnobody@163.com>
Subject: Re: [PATCH nf-next] netfilter: nft_fib: store loopback interface to
 dreg when rt is local
Date: Fri, 25 Nov 2016 21:47:34 +0800 (CST)
Message-ID: <5f68cd99.12bc5.1589bbdc376.Coremail.zlpnobody@163.com>
References: <1479994128-16654-1-git-send-email-zlpnobody@163.com>
 <20161124135014.GD24598@breakpoint.cc>
 <50e29b0e.fa76.15896bf2fb2.Coremail.zlpnobody@163.com>
 <20161124144859.GE24598@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: "Florian Westphal" <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m13-148.163.com ([220.181.13.148]:25607 "EHLO m13-148.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754708AbcKYODT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Nov 2016 09:03:19 -0500
In-Reply-To: <20161124144859.GE24598@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

CkF0IDIwMTYtMTEtMjQgMjI6NDg6NTksICJGbG9yaWFuIFdlc3RwaGFsIiA8ZndAc3RybGVuLmRl
PiB3cm90ZToKPkxpcGluZyBaaGFuZyA8emxwbm9ib2R5QDE2My5jb20+IHdyb3RlOgpbLi4uXQo+
IjEiIHNob3VsZCBvbmx5IGFwcGVhciBpZiBsb29rdXAtdXAgYWRkcmVzcyBpcyBjb25maWd1cmVk
IG9uIHRoaXMgbWFjaGluZS4KPkZvciBzYWRkciwgSSBkb24ndCB0aGluayBpdHMgZ29vZCBpZGVh
LCBiZWNhdXNlIGl0IHdpbGwgcGFzcwo+Cj5vaWYgbmUgMCBhY2NlcHQKClllcywgbXkgcGF0Y2gg
d2lsbCBicmVhayB0aGlzLiAKCj4KPkZvciBBQ0NFUFRfTE9DQUwgaSB0aGluayBpdHMgZWFzaWVy
IHRvIGNvbWJpbmUgdGhpcyB3aXRoIHRoZSBhZGRydHlwZQo+Y2hlY2sgb2YganVzdCBhZGQgZXhw
bGljaXQgYWNjZXB0IHJ1bGVzIHRoYXQgbWFrZSBpdCBieXBhc3MgbmZ0X2ZpYgo+cnVsZS4KClll
cywgY29tYmluZSB0aGlzIHdpdGggYWRkcnR5cGUgd2lsbCBiZSBlYXNpZXIuIE15IGZpcnN0IHRo
b3VnaHQgd2FzIHRoYXQKd2UgY2FuIGFsc28gdXNlICJmaWIgc2FkZHIgb2lmIGVxIDEiIHRvIHNp
bXVsYXRlIHRoZSBBQ0NFQ1BUX0xPQ0FMLCBidXQKSSdtIHdyb25nLCBpdCB3aWxsIGJlY29tZSBt
b3JlIGNvbXBsaWNhdGVkLgoKPgo+V2hhdCBkbyB5b3UgdGhpbms/Cj4KPkkgYWdyZWUgdGhhdCBm
b3IgeW91ciBwcmVyb3V0aW5nIGRhZGRyIGV4YW1wbGUgMCBtYWtlcyBubyBzZW5zZSBhbmQgMQo+
d291bGQgaW5kZWVkIGJlIGEgYmV0dGVyIG9wdGlvbi4KPgo=
