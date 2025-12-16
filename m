Received: from ksmg4.croc.ru (ksmg4.croc.ru [195.38.23.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E4D390DC4
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 12:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.38.23.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765889096; cv=none; b=smBDYEQ9+9R432yCYrwj+ysQgP2/b/yWherurZZ8xkf+86UZe36ybFSgr3TySamFeLNigav4IlArYjfdF9VTDg1s0YPg0/KCytUAKmrmWTUluWiYBf4rrGBAJA18VYXFICK+gu3vEmIajE9LwlfgkDa2uH5l7hDPib9fEbyjRfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765889096; c=relaxed/simple;
	bh=BvDSK+ZHDmVKvRiPJnl0EpswHm3ut0fCDXJjfz4Q3Hc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fm/pi4KJkg2V7ZJD4JEhP0Or+/HMHL1AS5LxfpVrXVoSU6RgBOfuUrHgYjMEcvFdhDX2AHXrEXDLugirvjOBMOVtuhBkihya/9jJIRzvWqoUEFDEChw05Qi6HvS/Q63VnhB6WTHANimZUCSaDuwMTHY5ROIF/tBrl1K3R/5Fyxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=k2.cloud; spf=pass smtp.mailfrom=k2.cloud; dkim=pass (2048-bit key) header.d=k2.cloud header.i=@k2.cloud header.b=PC/FMx9T; arc=none smtp.client-ip=195.38.23.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=k2.cloud
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=k2.cloud
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=k2.cloud header.i=@k2.cloud header.b="PC/FMx9T"
Received: from ksmg4.croc.ru (localhost [127.0.0.1])
	by ksmg4.croc.ru (Postfix) with ESMTP id 3E77920025;
	Tue, 16 Dec 2025 15:44:40 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg4.croc.ru 3E77920025
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=k2.cloud; s=mail;
	t=1765889080; bh=BvDSK+ZHDmVKvRiPJnl0EpswHm3ut0fCDXJjfz4Q3Hc=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:From;
	b=PC/FMx9TfVRdzovQCp7Yv+2/KppSoabtZUD9FigvF28PUnQkJe58X5ypFSC/k0cvE
	 TWQsFGrPVdM/U9Slg0/PizgnGr+0IEAwCOaPUY4s7v/dT3mf75hjzzdCEuCBt7j8CH
	 MFwPmQlC4ACoPmNpFIugbKOaoykXGDpsjKM30Y9q9R/EpGBjWLiY/o7EvsusrVw7jB
	 8oh66AUCbFZne/g3asXxpKV95SIEoCKX8nDBrfX3BZRuurzX4g3BsjNhVo6juuSqQs
	 mCwmMkR2Lb3/n35TZG3ae5pH9ca7NGSPZawJZ2sEES1OzwEXSLyYvx2DjErf5944B9
	 Q3xkvcj/k2CaQ==
Received: from MXONE (unknown [195.38.23.35])
	by ksmg4.croc.ru (Postfix) with ESMTP;
	Tue, 16 Dec 2025 15:44:40 +0300 (MSK)
From: Rukomoinikova Aleksandra <ARukomoinikova@k2.cloud>
To: Fernando Fernandez Mancera <fmancera@suse.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC: "coreteam@netfilter.org" <coreteam@netfilter.org>, "Rukomoinikova
 Aleksandra" <ARukomoinikova@k2.cloud>
Subject: Re: [PATCH nf] netfilter: nf_conncount: increase connection clean up
 limit to 64
Thread-Topic: [PATCH nf] netfilter: nf_conncount: increase connection clean up
 limit to 64
Thread-Index: AQHcbocNh3y3qLAjZk2dMZY8VreCsbUkBCOA
Date: Tue, 16 Dec 2025 12:44:39 +0000
Message-ID: <5b08a4a6-4428-4f7b-a448-7cd529801f91@k2.cloud>
References: <20251216122449.30116-1-fmancera@suse.de>
In-Reply-To: <20251216122449.30116-1-fmancera@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-except: 1
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C64E47329DEE4498FC3E4663232F395@croc.ru>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: skipped
X-KSMG-AntiSpam-Status: not scanned, allowlist
X-KSMG-AntiPhishing: not scanned, allowlist
X-KSMG-LinksScanning: not scanned, allowlist
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, not scanned, allowlist

SGksIHRoYW5rcyBzbyBtdWNoIGZvciBmaXgpDQoNCk9uIDE2LjEyLjIwMjUgMTU6MjQsIEZlcm5h
bmRvIEZlcm5hbmRleiBNYW5jZXJhIHdyb3RlOg0KPiBBZnRlciB0aGUgb3B0aW1pemF0aW9uIHRv
IG9ubHkgcGVyZm9ybSBvbmUgR0MgcGVyIGppZmZ5LCBhIG5ldyBwcm9ibGVtDQo+IHdhcyBpbnRy
b2R1Y2VkLiBJZiBtb3JlIHRoYW4gOCBuZXcgY29ubmVjdGlvbnMgYXJlIHRyYWNrZWQgcGVyIGpp
ZmZ5IHRoZQ0KPiBsaXN0IHdvbid0IGJlIGNsZWFuZWQgdXAgZmFzdCBlbm91Z2ggcG9zc2libHkg
cmVhY2hpbmcgdGhlIGxpbWl0DQo+IHdyb25nbHkuDQo+DQo+IEluIG9yZGVyIHRvIHByZXZlbnQg
dGhpcyBpc3N1ZSwgaW5jcmVhc2UgdGhlIGNsZWFuIHVwIGxpbWl0IHRvIDY0DQo+IGNvbm5lY3Rp
b25zIHNvIGl0IGlzIGVhc2llciBmb3IgY29ubmNvdW50IHRvIGtlZXAgdXAgd2l0aCB0aGUgbmV3
DQo+IGNvbm5lY3Rpb25zIHRyYWNrZWQgcGVyIGppZmZ5IHJhdGUuDQo+DQo+IEZpeGVzOiBkMjY1
OTI5OTMwZTIgKCJuZXRmaWx0ZXI6IG5mX2Nvbm5jb3VudDogcmVkdWNlIHVubmVjZXNzYXJ5IEdD
IikNCj4gUmVwb3J0ZWQtYnk6IEFsZWtzYW5kcmEgUnVrb21vaW5pa292YSA8QVJ1a29tb2luaWtv
dmFAazIuY2xvdWQ+DQo+IENsb3NlczogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZmlsdGVy
L2IyMDY0ZTdiLTA3NzYtNGUxNC1hZGI2LWM2ODA4MDk4NzQ3MUBrMi5jbG91ZC8NCj4gU2lnbmVk
LW9mZi1ieTogRmVybmFuZG8gRmVybmFuZGV6IE1hbmNlcmEgPGZtYW5jZXJhQHN1c2UuZGU+DQo+
IC0tLQ0KPiAgIG5ldC9uZXRmaWx0ZXIvbmZfY29ubmNvdW50LmMgfCA5ICsrKysrLS0tLQ0KPiAg
IDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+DQo+IGRp
ZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm5jb3VudC5jIGIvbmV0L25ldGZpbHRlci9u
Zl9jb25uY291bnQuYw0KPiBpbmRleCAzNjU0ZjFlODk3NmMuLmVjMTM0NzI5ODU2ZiAxMDA2NDQN
Cj4gLS0tIGEvbmV0L25ldGZpbHRlci9uZl9jb25uY291bnQuYw0KPiArKysgYi9uZXQvbmV0Zmls
dGVyL25mX2Nvbm5jb3VudC5jDQo+IEBAIC0zNCw4ICszNCw5IEBADQo+ICAgDQo+ICAgI2RlZmlu
ZSBDT05OQ09VTlRfU0xPVFMJCTI1NlUNCj4gICANCj4gLSNkZWZpbmUgQ09OTkNPVU5UX0dDX01B
WF9OT0RFUwk4DQo+IC0jZGVmaW5lIE1BWF9LRVlMRU4JCTUNCj4gKyNkZWZpbmUgQ09OTkNPVU5U
X0dDX01BWF9OT0RFUwkJOA0KPiArI2RlZmluZSBDT05OQ09VTlRfR0NfTUFYX0NPTExFQ1QJNjQN
Cj4gKyNkZWZpbmUgTUFYX0tFWUxFTgkJCTUNCj4gICANCj4gICAvKiB3ZSB3aWxsIHNhdmUgdGhl
IHR1cGxlcyBvZiBhbGwgY29ubmVjdGlvbnMgd2UgY2FyZSBhYm91dCAqLw0KPiAgIHN0cnVjdCBu
Zl9jb25uY291bnRfdHVwbGUgew0KPiBAQCAtMTg3LDcgKzE4OCw3IEBAIHN0YXRpYyBpbnQgX19u
Zl9jb25uY291bnRfYWRkKHN0cnVjdCBuZXQgKm5ldCwNCj4gICANCj4gICAJLyogY2hlY2sgdGhl
IHNhdmVkIGNvbm5lY3Rpb25zICovDQo+ICAgCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShjb25u
LCBjb25uX24sICZsaXN0LT5oZWFkLCBub2RlKSB7DQo+IC0JCWlmIChjb2xsZWN0ID4gQ09OTkNP
VU5UX0dDX01BWF9OT0RFUykNCj4gKwkJaWYgKGNvbGxlY3QgPiBDT05OQ09VTlRfR0NfTUFYX0NP
TExFQ1QpDQo+ICAgCQkJYnJlYWs7DQo+ICAgDQo+ICAgCQlmb3VuZCA9IGZpbmRfb3JfZXZpY3Qo
bmV0LCBsaXN0LCBjb25uKTsNCj4gQEAgLTMxNiw3ICszMTcsNyBAQCBzdGF0aWMgYm9vbCBfX25m
X2Nvbm5jb3VudF9nY19saXN0KHN0cnVjdCBuZXQgKm5ldCwNCj4gICAJCX0NCj4gICANCj4gICAJ
CW5mX2N0X3B1dChmb3VuZF9jdCk7DQo+IC0JCWlmIChjb2xsZWN0ZWQgPiBDT05OQ09VTlRfR0Nf
TUFYX05PREVTKQ0KPiArCQlpZiAoY29sbGVjdGVkID4gQ09OTkNPVU5UX0dDX01BWF9DT0xMRUNU
KQ0KPiAgIAkJCWJyZWFrOw0KPiAgIAl9DQo+ICAgDQoNCg0KLS0gDQpyZWdhcmRzLA0KQWxleGFu
ZHJhLg0KDQo=
