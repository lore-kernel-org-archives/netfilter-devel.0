Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305EF33EA;
	Wed,  9 Apr 2025 10:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744194564; cv=none; b=hnxahiq+tn9OycKLcSx0rM1zwfDvYRQZzRaNxvfbAfxBR84S/cnuORvge7MH7umwLduyLokWM+1JveXTP1KK+2YGmIDqQp4I+GQkq9xwEKZS2hht+Vv0ONGSg4IisnSgwvEKh8TySEXO0Vf/Snu6kxO6CppqZ9l3bEIvbujs6J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744194564; c=relaxed/simple;
	bh=g4SlQ6n+eMwncq5ruathbT0E6VfUOiwr1w8ccuRNyRA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m+5W8wL1cMUzLuObd0T5I+tFLyHuXJDHaMX6NLCV5TFjdBoqnU8H1MLPz6vNsLOplxxA+uPU6H9myqfJYs2b2h4gbO3csEfgILzKXkRnb0w/SJ8TuwQyaQEzQ9dJ2xUWCAmypK2DKd+F45LMKYDHK3/luH4rmbN40aExWtjzx9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from mail2012.asrmicro.com (mail2012.asrmicro.com [10.1.24.123])
	by spam.asrmicro.com with ESMTPS id 539AS1Io064182
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Wed, 9 Apr 2025 18:28:01 +0800 (GMT-8)
	(envelope-from huajianyang@asrmicro.com)
Received: from exch03.asrmicro.com (10.1.24.118) by mail2012.asrmicro.com
 (10.1.24.123) with Microsoft SMTP Server (TLS) id 15.0.847.32; Wed, 9 Apr
 2025 18:28:05 +0800
Received: from exch03.asrmicro.com ([::1]) by exch03.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Wed, 9 Apr 2025 18:27:53 +0800
From: =?gb2312?B?WWFuZyBIdWFqaWFuo6jR7ruqvaGjqQ==?= <huajianyang@asrmicro.com>
To: Florian Westphal <fw@strlen.de>
CC: "pablo@netfilter.org" <pablo@netfilter.org>,
        "kadlec@netfilter.org"
	<kadlec@netfilter.org>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "davem@davemloft.net"
	<davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org"
	<kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org"
	<coreteam@netfilter.org>,
        "bridge@lists.linux.dev" <bridge@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBuZXQ6IEV4cGFuZCBoZWFkcm9vbSB0byBzZW5kIGZy?=
 =?gb2312?Q?agmented_packets_in_bridge_fragment_forward?=
Thread-Topic: [PATCH] net: Expand headroom to send fragmented packets in
 bridge fragment forward
Thread-Index: AQHbqSG8SdklQ9d4OUaoNRR/FIduA7OaiEyAgACMyqA=
Date: Wed, 9 Apr 2025 10:27:52 +0000
Message-ID: <0a711412f54c4dc6a7d58f4fa391dc0f@exch03.asrmicro.com>
References: <20250409073336.31996-1-huajianyang@asrmicro.com>
 <20250409091821.GA17911@breakpoint.cc>
In-Reply-To: <20250409091821.GA17911@breakpoint.cc>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 539AS1Io064182

VGhhbmsgeW91IGZvciB5b3VyIHJlcGx5IQ0KDQo+IFNvbWUgbmV0d29yayBkZXZpY2VzIHRoYXQg
d291bGQgbm90IGFibGUgdG8gcGluZyBsYXJnZSBwYWNrZXQgdW5kZXIgDQo+IGJyaWRnZSwgYnV0
IGxhcmdlIHBhY2tldCBwaW5nIGlzIHN1Y2Nlc3NmdWwgaWYgbm90IGVuYWJsZSBORl9DT05OVFJB
Q0tfQlJJREdFLg0KDQo+IENhbiB5b3UgYWRkIGEgbmV3IHRlc3QgdG8gdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvbmV0L25ldGZpbHRlci8gdGhhdCBkZW1vbnN0cmF0ZXMgdGhpcyBwcm9ibGVtPw0K
DQpNYXliZSBJIGNhbid0IGRlbW9uc3RyYXRlIHRoaXMgcHJvYmxlbSB3aXRoIGEgc2hlbGwgc2Ny
aXB0LA0KSSBhY3R1YWxseSBkaXNjb3ZlcmVkIHRoaXMgcHJvYmxlbSB3aGlsZSBkZWJ1Z2dpbmcg
YSB3aWZpIG5ldHdvcmsgZGV2aWNlLg0KVGhpcyBuZXRkZXZpY2UgaXMgc2V0IGEgbGFyZ2UgbmVl
ZGVkX2hlYWRyb29tKDgwKSwgc28gbGxfcnMgaXMgb3ZlcnNpemUgYW5kIGdvdG8gYmxhY2tob2xl
Lg0KDQpXZSBjYW4gZWFzaWx5IHRvIHJlcHJvZHVjZSBpdCBieSBjb25maWdpbmcgbmVlZGVkX2hl
YWRyb29tIGluIGEgbmV0ZGV2aWNlLA0KdGhlbiBhZGQgdGhpcyBuZXRkZXZpY2UgdG8gYSBicmlk
Z2UsIGFuZCB0ZXN0IGJyaWRnZSBmb3J3YXJkaW5nLg0KDQpwaW5nIGxhcmdlIHBhY2tldCBjb3Vs
ZCByZXByb2R1Y2UgdGhpcyBhcHBlYXJhbmNlLihzdWNjZXNzZnVsIGlmIG5vdCBlbmFibGUgTkZf
Q09OTlRSQUNLX0JSSURHRSkNCg0KPiBJIGd1ZXNzIHRoaXMgc2hvdWxkIGJlDQo+IA0KPiBpZiAo
Zmlyc3RfbGVuIC0gaGxlbiA+IG10dSkNCj4JZ290byBibGFja2hvbGU7DQo+IGlmIChza2JfaGVh
ZHJvb20oc2tiKSA8IGxsX3JzKQ0KPglnb3RvIGV4cGFuZF9oZWFkcm9vbTsNCg0KPiAuLi4gYnV0
IEknbSBub3Qgc3VyZSB3aGF0IHRoZSBhY3R1YWwgcHJvYmxlbSBpcy4NCg0KWWVzLCB5b3VyIGd1
ZXNzIGlzIGNvcnJlY3QhDQoNCkFjdHVhbCBwcm9ibGVtOiBJIHRoaW5rIGl0IGlzIHVucmVhc29u
YWJsZSB0byBkaXJlY3RseSBkcm9wIHNrYiB3aXRoIGluc3VmZmljaWVudCBoZWFkcm9vbS4NCg0K
PiBXaHkgZG9lcyB0aGlzIG5lZWQgdG8gbWFrZSBhIGZ1bGwgc2tiIGNvcHk/DQo+IFNob3VsZCB0
aGF0IGJlIHVzaW5nIHNrYl9leHBhbmRfaGVhZCgpPw0KDQpVc2luZyBza2JfZXhwYW5kX2hlYWQg
aGFzIHRoZSBzYW1lIGVmZmVjdC4NCg0KPiBBY3R1YWxseSwgY2FuJ3QgeW91IGp1c3QgKHJlKXVz
ZSB0aGUgc2xvd3BhdGggZm9yIHRoZSBza2JfaGVhZHJvb20gPCBsbF9ycyBjYXNlIGluc3RlYWQg
b2YgYWRkaW5nIGhlYWRyb29tIGV4cGFuc2lvbj8NCg0KSSB0ZXN0ZWQgaXQganVzdCBub3csIHJl
dXNlIHRoZSBzbG93cGF0aCB3aWxsIHN1Y2Nlc3NlZC4NCkJ1dCBtYXliZSB0aGlzIGNoYW5nZSBj
YW5ub3QgcmVzb2x2ZSBhbGwgY2FzZXMgaWYgdGhlIG5ldGRldmljZSByZWFsbHkgbmVlZHMgdGhp
cyBoZWFkcm9vbS4NCg0KQmVzdCBSZWdhcmRzLA0KSHVhamlhbg0KDQotLS0tLdPKvP7Urbz+LS0t
LS0NCreivP7IyzogRmxvcmlhbiBXZXN0cGhhbCBbbWFpbHRvOmZ3QHN0cmxlbi5kZV0gDQq3osvN
yrG85DogMjAyNcTqNNTCOcjVIDE3OjE4DQrK1bz+yMs6IFlhbmcgSHVhamlhbqOo0e67qr2ho6kg
PGh1YWppYW55YW5nQGFzcm1pY3JvLmNvbT4NCrOty806IHBhYmxvQG5ldGZpbHRlci5vcmc7IGth
ZGxlY0BuZXRmaWx0ZXIub3JnOyByYXpvckBibGFja3dhbGwub3JnOyBpZG9zY2hAbnZpZGlhLmNv
bTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZHNhaGVybkBrZXJuZWwub3JnOyBlZHVtYXpldEBnb29n
bGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOyBob3Jtc0BrZXJuZWwu
b3JnOyBuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnOyBjb3JldGVhbUBuZXRmaWx0ZXIu
b3JnOyBicmlkZ2VAbGlzdHMubGludXguZGV2OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQrW98ziOiBSZTogW1BBVENIXSBuZXQ6IEV4cGFuZCBo
ZWFkcm9vbSB0byBzZW5kIGZyYWdtZW50ZWQgcGFja2V0cyBpbiBicmlkZ2UgZnJhZ21lbnQgZm9y
d2FyZA0KDQpIdWFqaWFuIFlhbmcgPGh1YWppYW55YW5nQGFzcm1pY3JvLmNvbT4gd3JvdGU6DQo+
IFRoZSBjb25maWcgTkZfQ09OTlRSQUNLX0JSSURHRSB3aWxsIGNoYW5nZSB0aGUgd2F5IGZyYWdt
ZW50cyBhcmUgcHJvY2Vzc2VkLg0KPiBCcmlkZ2UgZG9lcyBub3Qga25vdyB0aGF0IGl0IGlzIGEg
ZnJhZ21lbnRlZCBwYWNrZXQgYW5kIGZvcndhcmRzIGl0IA0KPiBkaXJlY3RseSwgYWZ0ZXIgTkZf
Q09OTlRSQUNLX0JSSURHRSBpcyBlbmFibGVkLCBmdW5jdGlvbiANCj4gbmZfYnJfaXBfZnJhZ21l
bnQgd2lsbCBjaGVjayBhbmQgZnJhZ2xpc3QgdGhpcyBwYWNrZXQuDQo+IA0KPiBTb21lIG5ldHdv
cmsgZGV2aWNlcyB0aGF0IHdvdWxkIG5vdCBhYmxlIHRvIHBpbmcgbGFyZ2UgcGFja2V0IHVuZGVy
IA0KPiBicmlkZ2UsIGJ1dCBsYXJnZSBwYWNrZXQgcGluZyBpcyBzdWNjZXNzZnVsIGlmIG5vdCBl
bmFibGUgTkZfQ09OTlRSQUNLX0JSSURHRS4NCg0KQ2FuIHlvdSBhZGQgYSBuZXcgdGVzdCB0byB0
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9uZXQvbmV0ZmlsdGVyLyB0aGF0IGRlbW9uc3RyYXRlcyB0
aGlzIHByb2JsZW0/DQoNCj4gSW4gZnVuY3Rpb24gbmZfYnJfaXBfZnJhZ21lbnQsIGNoZWNraW5n
IHRoZSBoZWFkcm9vbSBiZWZvcmUgc2VuZGluZyBpcyANCj4gdW5kb3VidGVkLCBidXQgaXQgaXMg
dW5yZWFzb25hYmxlIHRvIGRpcmVjdGx5IGRyb3Agc2tiIHdpdGggDQo+IGluc3VmZmljaWVudCBo
ZWFkcm9vbS4NCg0KQXJlIHdlIHRhbGtpbmcgYWJvdXQNCmlmIChmaXJzdF9sZW4gLSBobGVuID4g
bXR1DQogIG9yDQpza2JfaGVhZHJvb20oc2tiKSA8IGxsX3JzKQ0KDQo/DQoNCj4gIA0KPiAgCQlp
ZiAoZmlyc3RfbGVuIC0gaGxlbiA+IG10dSB8fA0KPiAgCQkgICAgc2tiX2hlYWRyb29tKHNrYikg
PCBsbF9ycykNCj4gLQkJCWdvdG8gYmxhY2tob2xlOw0KPiArCQkJZ290byBleHBhbmRfaGVhZHJv
b207DQoNCkkgZ3Vlc3MgdGhpcyBzaG91bGQgYmUNCg0KaWYgKGZpcnN0X2xlbiAtIGhsZW4gPiBt
dHUpDQoJZ290byBibGFja2hvbGU7DQppZiAoc2tiX2hlYWRyb29tKHNrYikgPCBsbF9ycykNCgln
b3RvIGV4cGFuZF9oZWFkcm9vbTsNCg0KLi4uIGJ1dCBJJ20gbm90IHN1cmUgd2hhdCB0aGUgYWN0
dWFsIHByb2JsZW0gaXMuDQoNCj4gK2V4cGFuZF9oZWFkcm9vbToNCj4gKwlzdHJ1Y3Qgc2tfYnVm
ZiAqZXhwYW5kX3NrYjsNCj4gKw0KPiArCWV4cGFuZF9za2IgPSBza2JfY29weV9leHBhbmQoc2ti
LCBsbF9ycywgc2tiX3RhaWxyb29tKHNrYiksIEdGUF9BVE9NSUMpOw0KPiArCWlmICh1bmxpa2Vs
eSghZXhwYW5kX3NrYikpDQo+ICsJCWdvdG8gYmxhY2tob2xlOw0KDQpXaHkgZG9lcyB0aGlzIG5l
ZWQgdG8gbWFrZSBhIGZ1bGwgc2tiIGNvcHk/DQpTaG91bGQgdGhhdCBiZSB1c2luZyBza2JfZXhw
YW5kX2hlYWQoKT8NCg0KPiAgc2xvd19wYXRoOg0KDQpBY3R1YWxseSwgY2FuJ3QgeW91IGp1c3Qg
KHJlKXVzZSB0aGUgc2xvd3BhdGggZm9yIHRoZSBza2JfaGVhZHJvb20gPCBsbF9ycyBjYXNlIGlu
c3RlYWQgb2YgYWRkaW5nIGhlYWRyb29tIGV4cGFuc2lvbj8NCg==
