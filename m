From: "Liping Zhang" <zlpwmdx@163.com>
Subject: Re:Re: [PATCH] netfilter: ipv4: fix NULL dereference
Date: Fri, 25 Mar 2016 14:38:15 +0800 (CST)
Message-ID: <21bea8ab.6e3f.153ac7eaa52.Coremail.zlpwmdx@163.com>
References: <1458743250-4003-1-git-send-email-zlpwmdx@163.com>
 <20160324202205.GA2167@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: base64
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	davem@davemloft.net, kernel@kyup.com,
	"Liping Zhang" <liping.zhang@spreadtrum.com>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m13-128.163.com ([220.181.13.128]:39152 "EHLO m13-128.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbcCYGyC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Mar 2016 02:54:02 -0400
In-Reply-To: <20160324202205.GA2167@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

QXQgMjAxNi0wMy0yNSAwNDoyMjowNSwgIlBhYmxvIE5laXJhIEF5dXNvIiA8cGFibG9AbmV0Zmls
dGVyLm9yZz4gd3JvdGU6Cj4KPkNvdWxkIHlvdSBhbHNvIHBhc3MgbmV0IGFzIHBhcmFtZXRlciB0
byBzeW5wcm94eV9zZW5kX3NlcnZlcl9zeW4oKSA/Cj4KPnBhci0+bmV0IHByb3ZpZGVzIHRoaXMg
ZnJvbSBzeW5wcm94eV90ZzQoKS4KCk5vdCBwYXNzIHRoZSBuZXQgYnV0IHJlcGxhY2UgdGhlIGZp
cnN0IHBhcmFtZXRlciAnc25ldCcgd2l0aCAnbmV0JyBzZWVtcyBiZXR0ZXI/CnNuZXQgaXMgb25s
eSB1c2VkIGluIHN5bnByb3h5X3JlY3ZfY2xpZW50X2Fjay0+c3lucHJveHlfc2VuZF9zZXJ2ZXJf
c3luIGNhbGwgcGF0aCwKYW5kIGluIG90aGVyIGNhbGwgcGF0aCwgYWN0dWFsbHkgd2Ugb25seSBu
ZWVkIG5ldCwgIGFuZCB3ZSBjYW4gY2FsbCBzeW5wcm94eV9wZXJuZXQobmV0KQp0byBnZXQgdGhl
IHNuZXQuCgpsaWtlIGZvbGxvd3M6Ci1zeW5wcm94eV9zZW5kX3NlcnZlcl9zeW4oY29uc3Qgc3Ry
dWN0IHN5bnByb3h5X25ldCAqc25ldCwKK3N5bnByb3h5X3NlbmRfc2VydmVyX3N5bihzdHJ1Y3Qg
bmV0ICpuZXQsCgotc3lucHJveHlfcmVjdl9jbGllbnRfYWNrKGNvbnN0IHN0cnVjdCBzeW5wcm94
eV9uZXQgKnNuZXQsCitzeW5wcm94eV9yZWN2X2NsaWVudF9hY2soc3RydWN0IG5ldCAqbmV0LAog
ICAgICAgICAgICAgICAgICAgICAgICAgY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwgY29uc3Qg
c3RydWN0IHRjcGhkciAqdGgsCiAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3Qgc3lucHJv
eHlfb3B0aW9ucyAqb3B0cywgdTMyIHJlY3Zfc2VxKQogeworICAgICAgIHN0cnVjdCBzeW5wcm94
eV9uZXQgKnNuZXQgPSBzeW5wcm94eV9wZXJuZXQobmV0KTsKCj4KPlRoYW5rcy4K
