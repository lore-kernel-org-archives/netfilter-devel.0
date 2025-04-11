Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B9B1DE2A8;
	Fri, 11 Apr 2025 02:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744339510; cv=none; b=cb5DYmdhtz1m8lAr+ee+rhAvQcBKFftHosT/LODbjygRKWVePcx4MEmpAIWs+DPnruMRX109J2HtLEP1pjQ1bBzbReICvFhmyddrLx74vEbrUbELaJw5ND+89lTqIDPzQc0O4zf4WCso7KHqsuPOBNzYqfOzSmCmA3SILOskwlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744339510; c=relaxed/simple;
	bh=UCa/jybotYpcnxVFXxMFtM0241fEygkIsjF25VUQSpo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KXLseFfWkEWu1vG8YwyQuTE/lfehy7lTwpiQOzXKKGttyEy7TdUZny0PJEDL8B/+i3u2SB1S2SXm9nxL6E76znm/LQrSNqbP3D5kfwwC5eRaBD+MjQ8x8l/gdAyWpVKLH8vp3IhPh/EnJk4uI3E4LmY7L4gf839HoeOf/RmMZ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 53B2hkuN041767
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Fri, 11 Apr 2025 10:43:46 +0800 (GMT-8)
	(envelope-from huajianyang@asrmicro.com)
Received: from exch03.asrmicro.com (10.1.24.118) by exch02.asrmicro.com
 (10.1.24.122) with Microsoft SMTP Server (TLS) id 15.0.847.32; Fri, 11 Apr
 2025 10:43:47 +0800
Received: from exch03.asrmicro.com ([::1]) by exch03.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Fri, 11 Apr 2025 10:43:36 +0800
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
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBuZXQ6IE1vdmUgc3BlY2lmaWMgZnJhZ21lbnRlZCBw?=
 =?gb2312?Q?acket_to_slow=5Fpath_instead_of_dropping_it?=
Thread-Topic: [PATCH] net: Move specific fragmented packet to slow_path
 instead of dropping it
Thread-Index: AQHbqe43btIvaVaBvESzU8w5bMigsLOcKc8AgAGQvBA=
Date: Fri, 11 Apr 2025 02:43:35 +0000
Message-ID: <717907fcffc7406191a71297fc07f6b3@exch03.asrmicro.com>
References: <20250410075726.8599-1-huajianyang@asrmicro.com>
 <20250410101824.GA6272@breakpoint.cc>
In-Reply-To: <20250410101824.GA6272@breakpoint.cc>
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
X-MAIL:spam.asrmicro.com 53B2hkuN041767

VGhhbmsgeW91IGZvciB5b3VyIHJlcGx5IQ0KDQpJbiBhbiBlYXJsaWVyIGVtYWlsIEkgd3JvdGU6
DQoNCj4gU29tZSBuZXR3b3JrIGRldmljZXMgdGhhdCB3b3VsZCBub3QgYWJsZSB0byBwaW5nIGxh
cmdlIHBhY2tldCB1bmRlciANCj4gYnJpZGdlLCBidXQgbGFyZ2UgcGFja2V0IHBpbmcgaXMgc3Vj
Y2Vzc2Z1bCBpZiBub3QgZW5hYmxlIE5GX0NPTk5UUkFDS19CUklER0UuDQoNCklmIHRoZSBwaW5n
IHRlc3Qgc3VjY2Vzc2VkIHdpdGhvdXQgTkZfQ09OTlRSQUNLX0JSSURHRSwgaXQgaXMgYmVjYXVz
ZSB0aGUgbmV0ZGV2IGRvZXNuJ3QgbmVlZCBzdWNoIGEgbGFyZ2UgaGVhZHJvb20gaW4gYWN0dWFs
IG5ldHdvcmsgZm9yd2FyZGluZy4NCg0KSWYgdGhlIG5ldGRldiByZWFseSBuZWVkIGl0LCB0aGUg
b3JpZ2luYWwgYnJpZGdlIGZvcndhcmRpbmcgd2lsbCBmYWlsIHRvby4NCg0KTWF5YmUgd2UgbmVl
ZCByZWNvbmZpZyBvdXIgd2lmaSBuZXRkZXYgb3Igc29tZXRoaW5nIGVsc2UuDQoNClNvIGlzIHRo
ZSBuZl9icl9pcF9mcmFnbWVudCBkb25lIHRvIGJlIGNvbnNpc3RlbnQgd2l0aCB0aGUgb3JpZ2lu
YWwgYnJpZGdlIGZvcndhcmRpbmc/DQoNClRoZXJlIGFyZSB0d28gdmVyeSBkaWZmZXJlbnQgaWRl
YXMgaGVyZToNCg0KT25lIGlzIHRvIHRyeSB0byBtYWludGFpbiB0aGUgc2FtZSB0cmVhdG1lbnQg
YXMgdGhlIG9yaWdpbmFsIGJyaWRnZSwgYXMgaXQgaXMgY3VycmVudGx5Lg0KDQpUaGUgb3RoZXIg
aXMgdG8gdHJ5IHRvIGVuc3VyZSB0aGF0IHRoZSBwYWNrZXQgaXMgZm9yd2FyZGVkLg0KDQo+IEkg
d291bGQgcHJlZmVyIHRvIGtlZXAgYmxhY2tob2xlIGxvZ2ljIGZvciB0aGUgbXR1IHRlc3RzLCBp
LmUuDQo+ICBpZiAoZmlyc3RfbGVuIC0gaGxlbiA+IG10dSkNCj4gICAgICBnb3RvIGJsYWNraG9s
ZTsNCg0KQW55d2F5LCB0aGlzIG1vZGlmaWNhdGlvbiBpcyBtb3JlIGFwcHJvcHJpYXRlLg0KDQpC
ZWNhdXNlIEkgaGF2ZSB0ZXN0ZWQgYnkgY2hhbmdlIG10dSBqdXN0IG5vdywgZ290byBzbG93cGF0
aCBjYW5ub3QgZm9yd2FyZCBpdCBlaXRoZXIuDQoNCg0KQmVzdCBSZWdhcmRzLA0KSHVhamlhbg0K
DQotLS0tLdPKvP7Urbz+LS0tLS0NCreivP7IyzogRmxvcmlhbiBXZXN0cGhhbCBbbWFpbHRvOmZ3
QHN0cmxlbi5kZV0gDQq3osvNyrG85DogMjAyNcTqNNTCMTDI1SAxODoxOA0KytW8/sjLOiBZYW5n
IEh1YWppYW6jqNHuu6q9oaOpIDxodWFqaWFueWFuZ0Bhc3JtaWNyby5jb20+DQqzrcvNOiBwYWJs
b0BuZXRmaWx0ZXIub3JnOyBmd0BzdHJsZW4uZGU7IGthZGxlY0BuZXRmaWx0ZXIub3JnOyByYXpv
ckBibGFja3dhbGwub3JnOyBpZG9zY2hAbnZpZGlhLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsg
ZHNhaGVybkBrZXJuZWwub3JnOyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7
IHBhYmVuaUByZWRoYXQuY29tOyBob3Jtc0BrZXJuZWwub3JnOyBuZXRmaWx0ZXItZGV2ZWxAdmdl
ci5rZXJuZWwub3JnOyBjb3JldGVhbUBuZXRmaWx0ZXIub3JnOyBicmlkZ2VAbGlzdHMubGludXgu
ZGV2OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
DQrW98ziOiBSZTogW1BBVENIXSBuZXQ6IE1vdmUgc3BlY2lmaWMgZnJhZ21lbnRlZCBwYWNrZXQg
dG8gc2xvd19wYXRoIGluc3RlYWQgb2YgZHJvcHBpbmcgaXQNCg0KSHVhamlhbiBZYW5nIDxodWFq
aWFueWFuZ0Bhc3JtaWNyby5jb20+IHdyb3RlOg0KPiAtLS0gYS9uZXQvYnJpZGdlL25ldGZpbHRl
ci9uZl9jb25udHJhY2tfYnJpZGdlLmMNCj4gKysrIGIvbmV0L2JyaWRnZS9uZXRmaWx0ZXIvbmZf
Y29ubnRyYWNrX2JyaWRnZS5jDQo+IEBAIC02MSwxOCArNjEsMTQgQEAgc3RhdGljIGludCBuZl9i
cl9pcF9mcmFnbWVudChzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCBzb2NrICpzaywNCj4gIAkJc3Ry
dWN0IHNrX2J1ZmYgKmZyYWc7DQo+ICANCj4gIAkJaWYgKGZpcnN0X2xlbiAtIGhsZW4gPiBtdHUg
fHwNCj4gLQkJICAgIHNrYl9oZWFkcm9vbShza2IpIDwgbGxfcnMpDQo+IC0JCQlnb3RvIGJsYWNr
aG9sZTsNCg0KSSB3b3VsZCBwcmVmZXIgdG8ga2VlcCBibGFja2hvbGUgbG9naWMgZm9yIHRoZSBt
dHUgdGVzdHMsIGkuZS4NCiAgaWYgKGZpcnN0X2xlbiAtIGhsZW4gPiBtdHUpDQogICAgICBnb3Rv
IGJsYWNraG9sZTsNCg0Kc2FtZSBmb3IgdGhlIGZyYWctPmxlbiB0ZXN0IGluIHRoZSBza2Jfd2Fs
a19mcmFncyBsb29wLg0KRnJvbSB3aGF0IEkgdW5kZXJzdG9vZCB0aGUgcHJvYmxlbSBpcyBvbmx5
IGJlY2F1c2Ugb2YgdGhlIGxvd2VyIGRldmljZXMnIGhlYWRyb29tIHJlcXVpcmVtZW50Lg0K
