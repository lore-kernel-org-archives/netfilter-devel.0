From: "Liping Zhang" <zlpnobody@163.com>
Subject: Re: [PATCH nf-next 3/3] netfilter: nft_log: fix snaplen does not
 truncate packets
Date: Wed, 20 Jul 2016 07:00:13 +0800 (CST)
Message-ID: <60a932e7.d60.15605635cca.Coremail.zlpnobody@163.com>
References: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
 <1468845857-30291-4-git-send-email-zlpnobody@163.com>
 <20160719181600.GD6116@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64
Cc: netfilter-devel@vger.kernel.org,
	"Liping Zhang" <liping.zhang@spreadtrum.com>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m13-148.163.com ([220.181.13.148]:18352 "EHLO m13-148.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbcGSXAZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jul 2016 19:00:25 -0400
In-Reply-To: <20160719181600.GD6116@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

QXQgMjAxNi0wNy0yMCAwMjoxNjowMCwgIlBhYmxvIE5laXJhIEF5dXNvIiA8cGFibG9AbmV0Zmls
dGVyLm9yZz4gd3JvdGU6Cj5PbiBNb24sIEp1bCAxOCwgMjAxNiBhdCAwODo0NDoxN1BNICswODAw
LCBMaXBpbmcgWmhhbmcgd3JvdGU6Cj4+IEZyb206IExpcGluZyBaaGFuZyA8bGlwaW5nLnpoYW5n
QHNwcmVhZHRydW0uY29tPgo+PiAKPj4gVGhlcmUncyBhIHNpbWlsYXIgcHJvYmxlbSBpbiB4dF9O
RkxPRywgYW5kIHdhcyBmaXhlZCBieSBjb21taXQgNzY0MzUwN2ZlOGI1Cj4+ICgibmV0ZmlsdGVy
OiB4dF9ORkxPRzogbmZsb2ctcmFuZ2UgZG9lcyBub3QgdHJ1bmNhdGUgcGFja2V0cyIpLiBPbmx5
IHNldAo+PiBjb3B5X2xlbiBoZXJlIGRvZXMgbm90IHdvcmssIHNvIHdlIHNob3VsZCBlbmFibGUg
TkZfTE9HX0ZfQ09QWV9MRU4gYWxzby4KPgo+QXBwbGllZCwgdGhhbmtzLgo+Cj5XaWxsIHlvdSBz
ZW5kIG1lIGEgcGF0Y2ggZm9yIG5mdGFibGVzIHVzZXJzcGFjZSB0byBlbmFibGUgdGhpcyBmbGFn
Pwo+Cj5JdCB3b3VsZCBiZSBnb29kIHRvIHVwZGF0ZSB0aGUgdHJhbnNsYXRpb24gdG8gbWFrZSBz
dXJlIC0tbmZsb2ctc2l6ZQo+bWFwIHRvIHNuYXBsZW4gYW5kIGlnbm9yZSAtLW5mbG9nLXJhbmdl
LgoKSSBmaW5kIHRoYXQgbmZ0YWJsZXMgYWxyZWFkeSBzdXBwb3J0IHRoaXMgZmVhdHVyZSwgdGhl
IGZvbGxvd2luZyBjb21tYW5kIG1lYW4gdG8gdHJ1bmNhdGUgcGFja2V0cwp0byAxMDAgYnl0ZXMg
YmVmb3JlIGxvZ2dpbmcgdG8gdGhlIHVzZXJzcGFjZToKICAjbmZ0IGFkZCBydWxlIGZpbHRlciBp
bnB1dCBsb2cgZ3JvdXAgMCBzbmFwbGVuIDEwMAoKQmVmb3JlIG15IHBhdGNoLCBpdCBkb2VzIG5v
dCB3b3JrLgpBbmQgYWZ0ZXIgYXBwbHkgbXkgcGF0Y2gsIGl0IHdvcmtzIGFzIGV4cGVjdGVkLgo=

