Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2302D2701BA;
	Thu, 24 Apr 2025 02:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745460827; cv=none; b=CU47oAdqtAl4kAM0bSbFsNAmXDTeTKtVk7LrGV3SL/okKYvnF9iBM/Evgky27+XjjA9+r/hbXGoDMN2gtYD7liG819t5chMaraFVm4WSZdaAo5KRGEtWvj7QIo0WvRSPQVUlNxPPoDht2II1opdXIDnrbtiUrfIxkJb2twYWHJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745460827; c=relaxed/simple;
	bh=ngAvRTONXmOFNq0kaBBb2o8T/nNOkmpZwfprdyr1saE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OLKfldq7ESU7j+W8npMoevsvEjSpUrpWtateg+qa+PPaNP7xwdl9zSbWjaEcPoZ3t2pkkpkJJLT8B4AomDTrtW3+uoT1ezrbAKmgZs2M/y+GdL0CONiJTTQzndrPL8YLct3pEyIIgKjW2MPc7XgmWSItNXJgFuaEyj1awosLZaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch01.asrmicro.com (exch01.asrmicro.com [10.1.24.121])
	by spam.asrmicro.com with ESMTPS id 53O2C1WR086872
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Thu, 24 Apr 2025 10:12:01 +0800 (GMT-8)
	(envelope-from huajianyang@asrmicro.com)
Received: from exch03.asrmicro.com (10.1.24.118) by exch01.asrmicro.com
 (10.1.24.121) with Microsoft SMTP Server (TLS) id 15.0.847.32; Thu, 24 Apr
 2025 10:12:02 +0800
Received: from exch03.asrmicro.com ([::1]) by exch03.asrmicro.com ([::1]) with
 mapi id 15.00.0847.030; Thu, 24 Apr 2025 10:12:02 +0800
From: =?gb2312?B?WWFuZyBIdWFqaWFuo6jR7ruqvaGjqQ==?= <huajianyang@asrmicro.com>
To: "pablo@netfilter.org" <pablo@netfilter.org>
CC: Florian Westphal <fw@strlen.de>,
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
Thread-Index: AQHbr3tKZ+wvjkSVukOYgchKk3XfyLOnYFuAgAq8iFA=
Date: Thu, 24 Apr 2025 02:12:02 +0000
Message-ID: <313bbfd54e6540e58e60dfcd9f0e8b2e@exch03.asrmicro.com>
References: <20250417092953.8275-1-huajianyang@asrmicro.com>
 <aAEMPbbOGZDRygwr@strlen.de>
In-Reply-To: <aAEMPbbOGZDRygwr@strlen.de>
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
X-MAIL:spam.asrmicro.com 53O2C1WR086872

SGkgUGFibG8sDQoNCkNhbiB5b3UgZ2l2ZSBzb21lIGFkdmljZT8NCg0KVGhhbmtzLg0KDQpCZXN0
IFJlZ2FyZHMsDQpIdWFqaWFuDQoNCi0tLS0t08q8/tStvP4tLS0tLQ0Kt6K8/sjLOiBGbG9yaWFu
IFdlc3RwaGFsIFttYWlsdG86ZndAc3RybGVuLmRlXSANCreiy83KsbzkOiAyMDI1xOo01MIxN8jV
IDIyOjEyDQrK1bz+yMs6IFlhbmcgSHVhamlhbqOo0e67qr2ho6kgPGh1YWppYW55YW5nQGFzcm1p
Y3JvLmNvbT4NCrOty806IHBhYmxvQG5ldGZpbHRlci5vcmc7IGthZGxlY0BuZXRmaWx0ZXIub3Jn
OyByYXpvckBibGFja3dhbGwub3JnOyBpZG9zY2hAbnZpZGlhLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldDsgZHNhaGVybkBrZXJuZWwub3JnOyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5l
bC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOyBob3Jtc0BrZXJuZWwub3JnOyBuZXRmaWx0ZXItZGV2
ZWxAdmdlci5rZXJuZWwub3JnOyBjb3JldGVhbUBuZXRmaWx0ZXIub3JnOyBicmlkZ2VAbGlzdHMu
bGludXguZGV2OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnDQrW98ziOiBSZTogW1BBVENIXSBuZXQ6IE1vdmUgc3BlY2lmaWMgZnJhZ21lbnRlZCBw
YWNrZXQgdG8gc2xvd19wYXRoIGluc3RlYWQgb2YgZHJvcHBpbmcgaXQNCg0KSHVhamlhbiBZYW5n
IDxodWFqaWFueWFuZ0Bhc3JtaWNyby5jb20+IHdyb3RlOg0KPiBUaGUgY29uZmlnIE5GX0NPTk5U
UkFDS19CUklER0Ugd2lsbCBjaGFuZ2UgdGhlIGJyaWRnZSBmb3J3YXJkaW5nIGZvciANCj4gZnJh
Z21lbnRlZCBwYWNrZXRzLg0KPiANCj4gVGhlIG9yaWdpbmFsIGJyaWRnZSBkb2VzIG5vdCBrbm93
IHRoYXQgaXQgaXMgYSBmcmFnbWVudGVkIHBhY2tldCBhbmQgDQo+IGZvcndhcmRzIGl0IGRpcmVj
dGx5LCBhZnRlciBORl9DT05OVFJBQ0tfQlJJREdFIGlzIGVuYWJsZWQsIGZ1bmN0aW9uIA0KPiBu
Zl9icl9pcF9mcmFnbWVudCBhbmQgYnJfaXA2X2ZyYWdtZW50IHdpbGwgY2hlY2sgdGhlIGhlYWRy
b29tLg0KPiANCj4gSW4gb3JpZ2luYWwgYnJfZm9yd2FyZCwgaW5zdWZmaWNpZW50IGhlYWRyb29t
IG9mIHNrYiBtYXkgaW5kZWVkIGV4aXN0LCANCj4gYnV0IHRoZXJlJ3Mgc3RpbGwgYSB3YXkgdG8g
c2F2ZSB0aGUgc2tiIGluIHRoZSBkZXZpY2UgZHJpdmVyIGFmdGVyIA0KPiBkZXZfcXVldWVfeG1p
dC5TbyBkcm9waW5nIHRoZSBza2Igd2lsbCBjaGFuZ2UgdGhlIG9yaWdpbmFsIGJyaWRnZSANCj4g
Zm9yd2FyZGluZyBpbiBzb21lIGNhc2VzLg0KDQpGaXhlczogM2MxNzFmNDk2ZWY1ICgibmV0Zmls
dGVyOiBicmlkZ2U6IGFkZCBjb25uZWN0aW9uIHRyYWNraW5nIHN5c3RlbSIpDQpSZXZpZXdlZC1i
eTogRmxvcmlhbiBXZXN0cGhhbCA8ZndAc3RybGVuLmRlPg0KDQpUaGlzIHNob3VsZCBwcm9iYWJs
eSBiZSByb3V0ZWQgdmlhIFBhYmxvLg0KDQpQYWJsbywgZmVlbCBmcmVlIHRvIHJvdXRlIHRoaXMg
dmlhIG5mLW5leHQgaWYgeW91IHRoaW5rIGl0cyBub3QgYW4gdXJnZW50IGZpeCwgaXRzIGJlZW4g
bGlrZSB0aGlzIHNpbmNlIGJyaWRnZSBjb25udHJhY2sgd2FzIGFkZGVkLg0K
