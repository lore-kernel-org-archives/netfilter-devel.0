Received: from ksmg4.croc.ru (ksmg4.croc.ru [195.38.23.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E711C33D51F
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 13:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.38.23.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765891024; cv=none; b=W10vkXj/8GoZiuQGbgfyLnp2eWh6KTdBAiV3LwUQbH3uHIpvug5h+zGX/iReaLrizbtO1GJaVoKB9QCZVyq8VPzhCdbf3UbsplFoL9SP7WzpeKJV1z9Xm5puZnhynuP22ixCdENSPeUgzBvaDqDsHVj4P8EF/b+T/j56t6RjsVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765891024; c=relaxed/simple;
	bh=MwHTODEizw50sWcFd1adJqYKaGrKWzKzf5C0L6+2iso=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pwCGYu5v/o7id8zOkzAVNeqyxEAJ3lTRRwOq2bTbpTmnaGm1xrWQ0YtRtsUZDihG2P8RwpfEx8iuZJBSTHvn+ejwbhjztxnp4Zgc9BSIeGsSCr+m7EwM9bX3gnYWfqsShdFtQAWUWzGyeXkXNSsdiNDpXxqa0rqjatLRyJZnqBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=k2.cloud; spf=pass smtp.mailfrom=k2.cloud; dkim=pass (2048-bit key) header.d=k2.cloud header.i=@k2.cloud header.b=Mmhy7QCK; arc=none smtp.client-ip=195.38.23.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=k2.cloud
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=k2.cloud
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=k2.cloud header.i=@k2.cloud header.b="Mmhy7QCK"
Received: from ksmg4.croc.ru (localhost [127.0.0.1])
	by ksmg4.croc.ru (Postfix) with ESMTP id 3C97E2000E;
	Tue, 16 Dec 2025 16:16:53 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 ksmg4.croc.ru 3C97E2000E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=k2.cloud; s=mail;
	t=1765891013; bh=MwHTODEizw50sWcFd1adJqYKaGrKWzKzf5C0L6+2iso=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:From;
	b=Mmhy7QCK4B7j9vMg3aKRZtPk0CbrSP1CO2YZcjzHCmwtOYgzvPBDNyj9486Fv1RRy
	 x/V+J4+qnvaJqvd/4e/xakniFF69mYWOvKXp919yz62UyJ6H+c4P54V3JbeqUjRg61
	 S3aYhiXsm/ZGA8RjBYxeOtHyIX8/rm2wRRVK/62uBXuah5OqVFjVfGTvF+vtaacOLT
	 AsloUYnZzPuLPyNiKfYWfn1dn7CVbkTJz9mAgvrNauHJpPEFvB/Brkr2Jcfve5tYAj
	 HXeltmexsW9P1Kvi+nQnYfxCvtVWupAl3pabMpRDdazmPCXi+N68OBf+J4AFYDgAm3
	 gNjS68qIQt6ug==
Received: from MXONE (unknown [195.38.23.35])
	by ksmg4.croc.ru (Postfix) with ESMTP;
	Tue, 16 Dec 2025 16:16:53 +0300 (MSK)
From: Rukomoinikova Aleksandra <ARukomoinikova@k2.cloud>
To: Fernando Fernandez Mancera <fmancera@suse.de>, Rukomoinikova Aleksandra
	<ARukomoinikova@k2.cloud>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>
CC: "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_conncount: increase connection clean up
 limit to 64
Thread-Topic: [PATCH nf] netfilter: nf_conncount: increase connection clean up
 limit to 64
Thread-Index: AQHcbocNh3y3qLAjZk2dMZY8VreCsbUkPMm5///QWgA=
Date: Tue, 16 Dec 2025 13:16:52 +0000
Message-ID: <05ed8c2c-aa0c-462f-a76d-f731a55aadb1@k2.cloud>
References: <20251216122449.30116-1-fmancera@suse.de>
 <5b08a4a6-4428-4f7b-a448-7cd529801f91@k2.cloud>
 <4683e951-bfff-4351-aad0-57f46fb23b14@suse.de>
In-Reply-To: <4683e951-bfff-4351-aad0-57f46fb23b14@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-except: 1
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEBB2500CDE4934E89AA70D82D88255C@croc.ru>
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

WWVzLCBzdXJlLCBpIHdpbGwgdGVzdCBpdCB0b2RheS4NCg0KT24gMTYuMTIuMjAyNSAxNjowNywg
RmVybmFuZG8gRmVybmFuZGV6IE1hbmNlcmEgd3JvdGU6DQo+DQo+DQo+IE9uIDEyLzE2LzI1IDE6
NDQgUE0sIFJ1a29tb2luaWtvdmEgQWxla3NhbmRyYSB3cm90ZToNCj4+IEhpLCB0aGFua3Mgc28g
bXVjaCBmb3IgZml4KQ0KPj4NCj4NCj4gQWxla3NhbmRyYSwgaWYgeW91IGNvdWxkIHRlc3QgaXQg
YW5kIHByb3ZpZGUgeW91ciBUZXN0ZWQtYnk6IHRhZyBpdCANCj4gd291bGQgYmUgcXVpdGUgaGVs
cGZ1bC4gSSB0ZXN0ZWQgdGhpcyBmaXggd2l0aCANCj4gbmZ0X2Nvbm5saW1pdC94dF9jb25ubGlt
aXQgYW5kIGFsc28gd2l0aCBPVlMgem9uZS1saW1pdCBmZWF0dXJlLg0KPg0KPj4gT24gMTYuMTIu
MjAyNSAxNToyNCwgRmVybmFuZG8gRmVybmFuZGV6IE1hbmNlcmEgd3JvdGU6DQo+Pj4gQWZ0ZXIg
dGhlIG9wdGltaXphdGlvbiB0byBvbmx5IHBlcmZvcm0gb25lIEdDIHBlciBqaWZmeSwgYSBuZXcg
cHJvYmxlbQ0KPj4+IHdhcyBpbnRyb2R1Y2VkLiBJZiBtb3JlIHRoYW4gOCBuZXcgY29ubmVjdGlv
bnMgYXJlIHRyYWNrZWQgcGVyIGppZmZ5IA0KPj4+IHRoZQ0KPj4+IGxpc3Qgd29uJ3QgYmUgY2xl
YW5lZCB1cCBmYXN0IGVub3VnaCBwb3NzaWJseSByZWFjaGluZyB0aGUgbGltaXQNCj4+PiB3cm9u
Z2x5Lg0KPj4+DQo+Pj4gSW4gb3JkZXIgdG8gcHJldmVudCB0aGlzIGlzc3VlLCBpbmNyZWFzZSB0
aGUgY2xlYW4gdXAgbGltaXQgdG8gNjQNCj4+PiBjb25uZWN0aW9ucyBzbyBpdCBpcyBlYXNpZXIg
Zm9yIGNvbm5jb3VudCB0byBrZWVwIHVwIHdpdGggdGhlIG5ldw0KPj4+IGNvbm5lY3Rpb25zIHRy
YWNrZWQgcGVyIGppZmZ5IHJhdGUuDQo+Pj4NCj4+PiBGaXhlczogZDI2NTkyOTkzMGUyICgibmV0
ZmlsdGVyOiBuZl9jb25uY291bnQ6IHJlZHVjZSB1bm5lY2Vzc2FyeSBHQyIpDQo+Pj4gUmVwb3J0
ZWQtYnk6IEFsZWtzYW5kcmEgUnVrb21vaW5pa292YSA8QVJ1a29tb2luaWtvdmFAazIuY2xvdWQ+
DQo+Pj4gQ2xvc2VzOiANCj4+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRmaWx0ZXIvYjIw
NjRlN2ItMDc3Ni00ZTE0LWFkYjYtYzY4MDgwOTg3NDcxQGsyLmNsb3VkLw0KPj4+IFNpZ25lZC1v
ZmYtYnk6IEZlcm5hbmRvIEZlcm5hbmRleiBNYW5jZXJhIDxmbWFuY2VyYUBzdXNlLmRlPg0KPj4+
IC0tLQ0KPj4+IMKgwqAgbmV0L25ldGZpbHRlci9uZl9jb25uY291bnQuYyB8IDkgKysrKystLS0t
DQo+Pj4gwqDCoCAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygt
KQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubmNvdW50LmMgDQo+
Pj4gYi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm5jb3VudC5jDQo+Pj4gaW5kZXggMzY1NGYxZTg5NzZj
Li5lYzEzNDcyOTg1NmYgMTAwNjQ0DQo+Pj4gLS0tIGEvbmV0L25ldGZpbHRlci9uZl9jb25uY291
bnQuYw0KPj4+ICsrKyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubmNvdW50LmMNCj4+PiBAQCAtMzQs
OCArMzQsOSBAQA0KPj4+IMKgwqAgwqDCoCAjZGVmaW5lIENPTk5DT1VOVF9TTE9UU8KgwqDCoMKg
wqDCoMKgIDI1NlUNCj4+PiDCoMKgIC0jZGVmaW5lIENPTk5DT1VOVF9HQ19NQVhfTk9ERVPCoMKg
wqAgOA0KPj4+IC0jZGVmaW5lIE1BWF9LRVlMRU7CoMKgwqDCoMKgwqDCoCA1DQo+Pj4gKyNkZWZp
bmUgQ09OTkNPVU5UX0dDX01BWF9OT0RFU8KgwqDCoMKgwqDCoMKgIDgNCj4+PiArI2RlZmluZSBD
T05OQ09VTlRfR0NfTUFYX0NPTExFQ1TCoMKgwqAgNjQNCj4+PiArI2RlZmluZSBNQVhfS0VZTEVO
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA1DQo+Pj4gwqDCoCDCoMKgIC8qIHdlIHdpbGwgc2F2ZSB0
aGUgdHVwbGVzIG9mIGFsbCBjb25uZWN0aW9ucyB3ZSBjYXJlIGFib3V0ICovDQo+Pj4gwqDCoCBz
dHJ1Y3QgbmZfY29ubmNvdW50X3R1cGxlIHsNCj4+PiBAQCAtMTg3LDcgKzE4OCw3IEBAIHN0YXRp
YyBpbnQgX19uZl9jb25uY291bnRfYWRkKHN0cnVjdCBuZXQgKm5ldCwNCj4+PiDCoMKgIMKgwqDC
oMKgwqDCoCAvKiBjaGVjayB0aGUgc2F2ZWQgY29ubmVjdGlvbnMgKi8NCj4+PiDCoMKgwqDCoMKg
wqAgbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKGNvbm4sIGNvbm5fbiwgJmxpc3QtPmhlYWQsIG5v
ZGUpIHsNCj4+PiAtwqDCoMKgwqDCoMKgwqAgaWYgKGNvbGxlY3QgPiBDT05OQ09VTlRfR0NfTUFY
X05PREVTKQ0KPj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAoY29sbGVjdCA+IENPTk5DT1VOVF9HQ19N
QVhfQ09MTEVDVCkNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOw0KPj4+
IMKgwqAgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZm91bmQgPSBmaW5kX29yX2V2aWN0KG5ldCwgbGlz
dCwgY29ubik7DQo+Pj4gQEAgLTMxNiw3ICszMTcsNyBAQCBzdGF0aWMgYm9vbCBfX25mX2Nvbm5j
b3VudF9nY19saXN0KHN0cnVjdCBuZXQgKm5ldCwNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9
DQo+Pj4gwqDCoCDCoMKgwqDCoMKgwqDCoMKgwqDCoCBuZl9jdF9wdXQoZm91bmRfY3QpOw0KPj4+
IC3CoMKgwqDCoMKgwqDCoCBpZiAoY29sbGVjdGVkID4gQ09OTkNPVU5UX0dDX01BWF9OT0RFUykN
Cj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGNvbGxlY3RlZCA+IENPTk5DT1VOVF9HQ19NQVhfQ09M
TEVDVCkNCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOw0KPj4+IMKgwqDC
oMKgwqDCoCB9DQo+Pg0KPj4NCj4NCg0KLS0gDQpyZWdhcmRzLA0KQWxleGFuZHJhLg0KDQo=
