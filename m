From: "Liping Zhang" <zlpnobody@163.com>
Subject: Re:Re: [PATCH nf-next 2/3] netfilter: nf_tables: fix a endless jump
 loop when use vmap
Date: Tue, 14 Jun 2016 20:07:41 +0800 (CST)
Message-ID: <6baeab0c.14c4e.1554ecf5f06.Coremail.zlpnobody@163.com>
References: <1465618828-22162-1-git-send-email-zlpnobody@163.com>
 <1465618828-22162-3-git-send-email-zlpnobody@163.com>
 <20160613181902.GA2699@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64
Cc: netfilter-devel@vger.kernel.org,
	"Liping Zhang" <liping.zhang@spreadtrum.com>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m13-44.163.com ([220.181.13.44]:51086 "EHLO m13-44.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbcFNMXS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 08:23:18 -0400
In-Reply-To: <20160613181902.GA2699@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SGkgcGFibG8sCgpBdCAyMDE2LTA2LTE0IDAyOjE5OjAyLCAiUGFibG8gTmVpcmEgQXl1c28iIDxw
YWJsb0BuZXRmaWx0ZXIub3JnPiB3cm90ZToKPk9uIFNhdCwgSnVuIDExLCAyMDE2IGF0IDEyOjIw
OjI3UE0gKzA4MDAsIExpcGluZyBaaGFuZyB3cm90ZToKPgo+VGhhbmtzIGZvciB0cmFja2luZyBk
b3duIGFuZCBmaXhpbmcgdGhpcyBvbmUuCj4KPkkndmUgbWFkZSBhIG5ldyB2ZXJzaW9uIGJhc2Vk
IG9uIHlvdXIgb3JpZ2luYWwgcGF0Y2gsIGZpbmQgaXQKPmF0dGFjaGVkLgo+Cj5CYXNpY2FsbHks
IHRoZSBpZGVhIGlzIHRvIHBhc3MgdGhlIGdlbm1hc2sgdGhyb3VnaCBpdGVyLCBzbyB3ZSBjYW4K
PnBlcmZvcm0gdGhlIGNvbmRpdGlvbmFsIGNoZWNrIGJhc2VkIG9uIHdoZXRoZXIgMSkgd2UncmUg
ZHVtcGluZyBvcgo+MikgY2hlY2tpbmcgZm9yIGxvb3BzIChpZS4gaW4gdGhlIG1pZGRsZSBvZiBh
IHRyYW5zYWN0aW9uKS4KPgo+TGV0IG1lIGtub3cgaWYgeW91IHNlZSBhbnkgcHJvYmxlbSB3aXRo
IHRoaXMgZGlmZmVyZW50IGFwcHJvYWNoLAo+dGhhbmtzLgoKSSB0aGluayB5b3VyIHBhdGNoIGlz
IGJldHRlciB0aGFuIG1pbmUuIEkgYWxzbyB0ZXN0IGl0LCBpdCB3b3JrcyB3ZWxsLgoKVGVzdGVk
LWJ5OiBMaXBpbmcgWmhhbmcgPGxpcGluZy56aGFuZ0BzcHJlYWR0cnVtLmNvbT4KClRoYW5rcw==

