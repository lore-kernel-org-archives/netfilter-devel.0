Received: from outbound.baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB17364E82;
	Fri, 30 Jan 2026 11:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769772286; cv=none; b=F/nqSy+Ayt0vV2jUt2SC1oVSThKEJp0WEEmA989g2ueslRn4ChSfZpSqh+lUerTCydJ5kYtkjj5yC1ELOW/KeqKbugi6hDCSWsAibnNIrjsTRsW0Gtgat8f4fXNs0ujFa61qbU9e1SkYg2JQaSDvW5J7IVrEig1Nmf+LBpuknUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769772286; c=relaxed/simple;
	bh=gY3XoYkjeVfsuCDxSemHm6hTSqPiFrY4EP7XNKMz+pk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EyxNYyuV1oDFYEcu36rgWNfGSYIp6x8XmqtGmRTJatAgQQC0nQwYi3q2FPcivujqKVGx0Kh8INyqi0Xd1aphJV7H1u1kmQBGVCluG93wL+mwo2xH+GLZVWMnYf2ckgFXYo4+DJ0DbgDcuCvjsxldyZEKC4DPCyZPZRbLo15qIyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Eric Dumazet <edumazet@google.com>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter
	<phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, "coreteam@netfilter.org"
	<coreteam@netfilter.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBb5aSW6YOo6YKu5Lu2XSBSZTogW1BBVENIXSBuZXRmaWx0ZXI6?=
 =?utf-8?B?IGNvbm50cmFjazogcmVtb3ZlIF9fcmVhZF9tb3N0bHkgZnJvbSBuZl9jb25u?=
 =?utf-8?Q?track=5Fgeneration?=
Thread-Topic: =?utf-8?B?W+WklumDqOmCruS7tl0gUmU6IFtQQVRDSF0gbmV0ZmlsdGVyOiBjb25udHJh?=
 =?utf-8?B?Y2s6IHJlbW92ZSBfX3JlYWRfbW9zdGx5IGZyb20gbmZfY29ubnRyYWNrX2dl?=
 =?utf-8?Q?neration?=
Thread-Index: AQHckaMKaFyWuz7BF0WyyylXiDKXFLVp/hqAgACTs4A=
Date: Fri, 30 Jan 2026 11:23:36 +0000
Message-ID: <7e1f38c0f792440da38ba0fa96ce932b@baidu.com>
References: <20260130044348.3095-1-lirongqing@baidu.com>
 <CANn89iLetxqpxpSBpQztPcg=av38nGNr2VpOo7HARrbqubREyg@mail.gmail.com>
In-Reply-To: <CANn89iLetxqpxpSBpQztPcg=av38nGNr2VpOo7HARrbqubREyg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.3.12
X-FE-Policy-ID: 52:10:53:SYSTEM

PiBXaGF0IGFib3V0IG5mX2Nvbm50cmFja19oYXNoX3JuZCA/DQo+IA0KPiBJIF90aGlua18gdGhp
cyBuZWVkcyB0byBiZSBfX3JlYWRfbW9zdGx5LCByZWdhcmRsZXNzIG9mIGl0cyBjdXJyZW50IGxv
Y2F0aW9uIChpdA0KPiBtaWdodCBieSBhY2NpZGVudCBzaGFyZSBhIG1vc3RseSByZWFkIGNhY2hl
IGxpbmUpLCBlc3BlY2lhbGx5IGlmIHlvdXIgcGF0Y2ggcHV0cw0KPiBuZl9jb25udHJhY2tfZ2Vu
ZXJhdGlvbiBpbiB0aGUgc2FtZSBjYWNoZSBsaW5lIHRoYW4gbmZfY29ubnRyYWNrX2hhc2hfcm5k
Lg0KPiANCj4gU2FtZSByZW1hcmsgZm9yIG5mX2N0X2V4cGVjdF9oYXNocm5kDQo+IA0KDQpZb3Ug
YXJlIHJpZ2h0LCBuZl9jb25udHJhY2tfaGFzaF9ybmQgYW5kIG5mX2N0X2V4cGVjdF9oYXNocm5k
IHNob3VsZCBiZSBtYXJrZWQgYXMgX19yZWFkX21vc3RseQ0KDQpUaGFua3MNCg0KLUxpDQoNCj4g
ZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUuYw0KPiBiL25ldC9u
ZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUuYw0KPiBpbmRleA0KPiBkMWY4ZWI3MjVkNDIyM2Uw
NDJiMDJhYjg2YmE4OWI5YjdjYWY3NWY1Li4wYTcwNWZhYjJiYjczZjc1OTA2NDdmZjA2ZA0KPiA3
MDY2Mzk1ZTZlZWE2Ng0KPiAxMDA2NDQNCj4gLS0tIGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJh
Y2tfY29yZS5jDQo+ICsrKyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUuYw0KPiBA
QCAtMjA0LDggKzIwNCw4IEBAIEVYUE9SVF9TWU1CT0xfR1BMKG5mX2Nvbm50cmFja19odGFibGVf
c2l6ZSk7DQo+IA0KPiAgdW5zaWduZWQgaW50IG5mX2Nvbm50cmFja19tYXggX19yZWFkX21vc3Rs
eTsNCj4gRVhQT1JUX1NZTUJPTF9HUEwobmZfY29ubnRyYWNrX21heCk7DQo+IC1zZXFjb3VudF9z
cGlubG9ja190IG5mX2Nvbm50cmFja19nZW5lcmF0aW9uIF9fcmVhZF9tb3N0bHk7IC1zdGF0aWMN
Cj4gc2lwaGFzaF9hbGlnbmVkX2tleV90IG5mX2Nvbm50cmFja19oYXNoX3JuZDsNCj4gK3NlcWNv
dW50X3NwaW5sb2NrX3QgbmZfY29ubnRyYWNrX2dlbmVyYXRpb247IHN0YXRpYw0KPiArc2lwaGFz
aF9hbGlnbmVkX2tleV90IG5mX2Nvbm50cmFja19oYXNoX3JuZCBfX3JlYWRfbW9zdGx5Ow0KPiAN
Cj4gIHN0YXRpYyB1MzIgaGFzaF9jb25udHJhY2tfcmF3KGNvbnN0IHN0cnVjdCBuZl9jb25udHJh
Y2tfdHVwbGUgKnR1cGxlLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25l
ZCBpbnQgem9uZWlkLCBkaWZmIC0tZ2l0DQo+IGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tf
ZXhwZWN0LmMNCj4gYi9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19leHBlY3QuYw0KPiBpbmRl
eA0KPiBjZmMyZGFhM2ZjN2YzNDA5Mzc4OThiNGJlZjA3NjlmZDMxZjgwMWI1Li40ZGFlNDA1NTI3
ZmViZjkxM2FmNDNjNDlkZGINCj4gMjk2MWE4ZjA1ZTBlNA0KPiAxMDA2NDQNCj4gLS0tIGEvbmV0
L25ldGZpbHRlci9uZl9jb25udHJhY2tfZXhwZWN0LmMNCj4gKysrIGIvbmV0L25ldGZpbHRlci9u
Zl9jb25udHJhY2tfZXhwZWN0LmMNCj4gQEAgLTQxLDcgKzQxLDcgQEAgRVhQT1JUX1NZTUJPTF9H
UEwobmZfY3RfZXhwZWN0X2hhc2gpOw0KPiAgdW5zaWduZWQgaW50IG5mX2N0X2V4cGVjdF9tYXgg
X19yZWFkX21vc3RseTsNCj4gDQo+ICBzdGF0aWMgc3RydWN0IGttZW1fY2FjaGUgKm5mX2N0X2V4
cGVjdF9jYWNoZXAgX19yZWFkX21vc3RseTsgLXN0YXRpYw0KPiBzaXBoYXNoX2FsaWduZWRfa2V5
X3QgbmZfY3RfZXhwZWN0X2hhc2hybmQ7DQo+ICtzdGF0aWMgc2lwaGFzaF9hbGlnbmVkX2tleV90
IG5mX2N0X2V4cGVjdF9oYXNocm5kIF9fcmVhZF9tb3N0bHk7DQo+IA0KPiAgLyogbmZfY29ubnRy
YWNrX2V4cGVjdCBoZWxwZXIgZnVuY3Rpb25zICovICB2b2lkDQo+IG5mX2N0X3VubGlua19leHBl
Y3RfcmVwb3J0KHN0cnVjdCBuZl9jb25udHJhY2tfZXhwZWN0ICpleHAsDQo+IA0KPiBUaGFua3Mu
DQoNCg==
