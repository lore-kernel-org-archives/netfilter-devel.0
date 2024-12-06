Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E84F144D0A
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2024 02:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733451594; cv=none; b=c3Jc/OKSXayTdyhMxliGz71S2gjFLvfovLfESlOK7dgKyYUqxNFa/hIQQJmbalKKEMvNN9ZPXjjHJgdygz60WFRi4XcIX66HSFR7zE9RdiT0qBldN9RPvy1m1bqaI8CEfN9jtyl/atwVQFgV7GBxE+uKyZMHfv5iS3dtvJ8G1ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733451594; c=relaxed/simple;
	bh=LnI0Na3/B3DR4dG1oO0Wy0h54NsiJph8a4Tm/NLGsLI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=qpb+6fGAqtrOSrzRZvv67JZSbsCfx2cACU3EuUpaQyaqwEgwhCK/osldMJLJjBtQ7h2xvoSr5PE9mCV1yHjM2ilocC+mYS2rJ3x5OKKYRtC8d0PClIJwQzgJg3Lz0LlRqT2RpTxqrCO4jU1oJEj5bjTo1xE3Atr2qLqxQrfRsyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-38-yTzVEjDMP82plyYRPmALzQ-1; Fri, 06 Dec 2024 02:19:43 +0000
X-MC-Unique: yTzVEjDMP82plyYRPmALzQ-1
X-Mimecast-MFC-AGG-ID: yTzVEjDMP82plyYRPmALzQ
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 6 Dec
 2024 02:18:59 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Fri, 6 Dec 2024 02:18:59 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Naresh Kamboju' <naresh.kamboju@linaro.org>, Dan Carpenter
	<dan.carpenter@linaro.org>
CC: open list <linux-kernel@vger.kernel.org>, "lkft-triage@lists.linaro.org"
	<lkft-triage@lists.linaro.org>, Linux Regressions
	<regressions@lists.linux.dev>, Linux ARM
	<linux-arm-kernel@lists.infradead.org>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Anders
 Roxell" <anders.roxell@linaro.org>, Johannes Berg <johannes.berg@intel.com>,
	"toke@kernel.org" <toke@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	"kernel@jfarr.cc" <kernel@jfarr.cc>, "kees@kernel.org" <kees@kernel.org>
Subject: RE: arm64: include/linux/compiler_types.h:542:38: error: call to
 '__compiletime_assert_1050' declared with attribute error: clamp() low limit
 min greater than high limit max_avail
Thread-Topic: arm64: include/linux/compiler_types.h:542:38: error: call to
 '__compiletime_assert_1050' declared with attribute error: clamp() low limit
 min greater than high limit max_avail
Thread-Index: AQHbR0VgROIHG94lCEKLQVwMYBVLZbLYdnCQ
Date: Fri, 6 Dec 2024 02:18:59 +0000
Message-ID: <bd95d7249ff94e31beb11b3f71a64e87@AcuMS.aculab.com>
References: <CA+G9fYsT34UkGFKxus63H6UVpYi5GRZkezT9MRLfAbM3f6ke0g@mail.gmail.com>
 <8dde5a62-4ce6-4954-86c9-54d961aed6df@stanley.mountain>
 <CA+G9fYv5gW1gByakU1yyQ__BoAKWkCcg=vGGyNep7+5p9_2uJA@mail.gmail.com>
In-Reply-To: <CA+G9fYv5gW1gByakU1yyQ__BoAKWkCcg=vGGyNep7+5p9_2uJA@mail.gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 10eFHTUXB8fToTjzsnA56jmVOP8H1L63tFtpHPKkzHA_1733451582
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

RnJvbTogTmFyZXNoIEthbWJvanUNCj4gU2VudDogMDUgRGVjZW1iZXIgMjAyNCAxODo0Mg0KPiAN
Cj4gT24gVGh1LCA1IERlYyAyMDI0IGF0IDIwOjQ2LCBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVu
dGVyQGxpbmFyby5vcmc+IHdyb3RlOg0KPiA+DQo+ID4gQWRkIERhdmlkIHRvIHRoZSBDQyBsaXN0
Lg0KPiANCj4gQW5kZXJzIGJpc2VjdGVkIHRoaXMgcmVwb3J0ZWQgaXNzdWUgYW5kIGZvdW5kIHRo
ZSBmaXJzdCBiYWQgY29tbWl0IGFzLA0KPiANCj4gIyBmaXJzdCBiYWQgY29tbWl0Og0KPiAgIFtl
ZjMyYjkyYWM2MDViYTFiNzY5MjgyNzMzMGI5YzYwMjU5ZjBhZjQ5XQ0KPiAgIG1pbm1heC5oOiB1
c2UgQlVJTERfQlVHX09OX01TRygpIGZvciB0aGUgbG8gPCBoaSB0ZXN0IGluIGNsYW1wKCkNCg0K
VGhhdCAnanVzdCcgY2hhbmdlZCB0aGUgdGVzdCB0byB1c2UgX19idWlsdGluX2NvbnN0YW50X3Ao
KSBhbmQNCnRodXMgZ2V0cyBjaGVja2VkIGFmdGVyIHRoZSBvcHRpbWlzZXIgaGFzIHJ1bi4NCg0K
SSBjYW4gcGFyYXBocmFzZSB0aGUgY29kZSBhczoNCnVuc2lnbmVkIGludCBmbih1bnNpZ25lZCBp
bnQgeCkNCnsNCglyZXR1cm4gY2xhbXAoMTAsIDUsIHggPT0gMCA/IDAgOiB4IC0gMSk7DQp9DQp3
aGljaCBpcyBuZXZlciBhY3R1YWxseSBjYWxsZWQgd2l0aCB4IDw9IDUuDQpUaGUgY29tcGlsZXIg
Y29udmVydHMgaXQgdG86DQoJcmV0dXJuIHggPCAwID8gY2xhbXAoMTAsIDUsIDApIDogY2xhbXAo
MTAsIDUsIHgpOw0KKFByb2JhYmx5IGJlY2F1c2UgaXQgY2FuIHNlZSB0aGF0IGNsYW1wKDEwLCA1
LCAwKSBpcyBjb25zdGFudC4pDQpBbmQgdGhlbiB0aGUgY29tcGlsZS10aW1lIHNhbml0eSBjaGVj
ayBpbiBjbGFtcCgpIGZpcmVzLg0KDQpUaGUgb3JkZXIgb2YgdGhlIGFyZ3VtZW50cyB0byBjbGFt
cCBpcyBqdXN0IHdyb25nIQ0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVL
DQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

