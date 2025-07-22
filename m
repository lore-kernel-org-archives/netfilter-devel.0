Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAA8288C97
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 08:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753171662; cv=none; b=ZZ5GSz+C3OgcAnZjEfwHjwVznkoS1z9HEUDC3pCqVXplP9Z8ePEwFMPCzPOtt0IZKtgjkBhs8y+bAc3XzCZUvVd0O/rO2b0i+vjG/n4sGlG8qjqmiarmXK6IdGFcRBD2jmNqheDT2C+lwytWpm90/G5aTAOGd5aXbowLzxDU9RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753171662; c=relaxed/simple;
	bh=Jk2XBgvKJ+egnwck4cqJCxB9P39vR2BJ63hOYEVBH0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CgKoSxAKPRI97LBCtHyrw7W6Cf7yBBqRoHuEhsuedKYGQJO+DMFF7YGx7odQHHkOe4yRx20t1LVwsf7eigRdMsTi0Bmcg6Vbb/7/UYF8TqVM000Zk3e3oJfFIV3qJyIk/3kJQ0UpBUarz5tO+85HqkUflIIqeB1qXNBv9nZ7tSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=d20CqU+z; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="d20CqU+z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1753171578;
	bh=Jk2XBgvKJ+egnwck4cqJCxB9P39vR2BJ63hOYEVBH0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=d20CqU+zS0Ht8XgV9Ed0eQrWqypqz5WpapQPJA7zWjbSZNHnuyzQhpgXbWZmmHdwR
	 W1FZ442JQG+UMCdmTCCbzOaY6N6eV2IAnPcN40WNrNchOCKMFdhEX76bMvGE2jsqsv
	 hsVtnv5TECZ2lu+bLEw6oH1+DOXRIMbKSH+qgnIU=
X-QQ-mid: zesmtpip3t1753171528t3ec7333b
X-QQ-Originating-IP: /pRypQO32Iz44++x6tk4NLGOP28Tf/v1ADE1NLN9Nek=
Received: from [IPV6:240e:668:120a::212:232] ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 22 Jul 2025 16:05:26 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4268784135301633643
EX-QQ-RecipientCnt: 17
Message-ID: <4DFD87AA0CE5EA72+aebc5df6-9174-4ecf-9dc9-3abb312defc1@uniontech.com>
Date: Tue, 22 Jul 2025 16:05:26 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] ipvs: ip_vs_conn_expire_now: Rename del_timer in
 comment
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: horms@verge.net.au, ja@ssi.bg, kadlec@netfilter.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, zhanjun@uniontech.com,
 niecheng1@uniontech.com, guanwentao@uniontech.com, wangyuli@deepin.org
References: <E5403EE80920424D+20250704083553.313144-1-wangyuli@uniontech.com>
 <aH8Ek6XA_EFr_XWh@calendula>
Content-Language: en-US
From: WangYuli <wangyuli@uniontech.com>
Autocrypt: addr=wangyuli@uniontech.com; keydata=
 xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSKP+nX39DN
 IVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAxFiEEa1GMzYeuKPkg
 qDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMBAAAKCRDF2h8wRvQL7g0UAQCH
 3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfPbwD/SrncJwwPAL4GiLPEC4XssV6FPUAY
 0rA68eNNI9cJLArOOARmgSyJEgorBgEEAZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7
 VTL0dvPDofBTjFYDAQgHwngEGBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIb
 DAAKCRDF2h8wRvQL7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkU
 o9ERi7qS/hbUdUgtitI89efbY0TVetgDsyeQiwU=
In-Reply-To: <aH8Ek6XA_EFr_XWh@calendula>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------miZQFZGDnPdt0uLvzGTFutMR"
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: MZqX2UPTdakpWbM9IW6/4bWYlv+pFvN5LZk9xpcdGo8NI19DP8bo2rQH
	xNQ03qE0iRwsA5YbRFteWVW6/JmnZcKUyWn6q0nZzKmA51aCvA+u2zl6pR83lPFNpRpQCZu
	ohU6kp0D/NwXgbj4sYdudPWaizdIHS3h5XCGIX68pVSmoKYC/C6U0ghwIH4mIwaQyVRHl65
	sEDVtQ7UCIq91oR4hY6QCtmMKlqeFHXapoMQUVf00yrxQJSzXGkEMQf17LDF44X/CBAYrVu
	32ngkJXyl+T41qM9B6zY/7j573Y+p+2JE0/p2uAqFvQA44U4X8tdjueyC2Msf6X/J255qde
	lFAm9/GeI/ajhEPYlDb6cR+ehcuXLK75Ys8KSAGnyOLRZaxIcquXzSEgDUPcr5Lwa8B2HrX
	PfDnp/lD8xqjTKlBK4HeT6WilDbJLkXio8mpsGspWYVKstDt+oVdkb31KHRhAXvSuxL/d0e
	gH61etqrev49k3Bw51cetyj34h/9hPEjO+Ti0zadUaHkCy7aBWuaMe92ZN7ZAyv50qwnrLL
	lYazeyYhbI4NMdIb2oK6eofjTTTvuTGQV1dVPaOVe5JHccHn4oE75K2JEXwpFzHizEoUloX
	UHosq3HNkyKotT6Jx4pzA86Sk1CyJQQ6dGO5IGH4ZWC9LzQXpeSZwjtz+AklCeX7q88KB0A
	FED41Xa0GhPXh4uaRYl4HaNsm/pfxyETmTNjwu/pcB5K818ehYrM/w1Qrp0+ieaSwNBcu3D
	HnEXWI/3xWFgr9y4AlQXEZv3djDB4tICPWeGEXioRKeUzVnTUnVpVmRAkFgoy7YDrVpqZIP
	KN/g7qbUaED2bYEAwQW7W+Kb6B1Q4dsLLB23FnA6PNjGHo8+/ax93LPfS9achjMx+ucOy44
	Wk4puqF1Zl4i/BBUGN/anMxaP4pvQo5/mVZZD7eKfjXpjP6s594cFp73ZykhBl/lWNviwP+
	BxbyUa66ozfyldKNYCeaNeATbuC0+MWtBAoyV1h4dHZB5WMgnCU0cHoi7EmeHmlTiw9sCYw
	sJKZ+AISEn2pLlr57DW8i7RQmhFpECg4AdEDo6KOpocN9QrvUJWKFwUxU8WDxNedTdwdjQf
	LZR4Ge2jnbMGrsIWKOUl3m056M9dBWPuVVGoyHEVRps/iuTQwCd9ajpx0qeIIB/Bw==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------miZQFZGDnPdt0uLvzGTFutMR
Content-Type: multipart/mixed; boundary="------------wln8Z5WJ90acIPVp5CBvJ1Z0";
 protected-headers="v1"
From: WangYuli <wangyuli@uniontech.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: horms@verge.net.au, ja@ssi.bg, kadlec@netfilter.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, zhanjun@uniontech.com,
 niecheng1@uniontech.com, guanwentao@uniontech.com, wangyuli@deepin.org
Message-ID: <aebc5df6-9174-4ecf-9dc9-3abb312defc1@uniontech.com>
Subject: Re: [PATCH RESEND] ipvs: ip_vs_conn_expire_now: Rename del_timer in
 comment
References: <E5403EE80920424D+20250704083553.313144-1-wangyuli@uniontech.com>
 <aH8Ek6XA_EFr_XWh@calendula>
In-Reply-To: <aH8Ek6XA_EFr_XWh@calendula>

--------------wln8Z5WJ90acIPVp5CBvJ1Z0
Content-Type: multipart/mixed; boundary="------------07PXpVmU8b1YT04K6viN7jix"

--------------07PXpVmU8b1YT04K6viN7jix
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgUGFibG8gTmVpcmEgQXl1c28sDQoNCk9uIDIwMjUvNy8yMiAxMToyNSwgUGFibG8gTmVp
cmEgQXl1c28gd3JvdGU6DQo+IE9uIEZyaSwgSnVsIDA0LCAyMDI1IGF0IDA0OjM1OjUzUE0g
KzA4MDAsIFdhbmdZdWxpIHdyb3RlOg0KPj4gQ29tbWl0IDhmYTcyOTJmZWU1YyAoInRyZWV3
aWRlOiBTd2l0Y2gvcmVuYW1lIHRvIHRpbWVyX2RlbGV0ZVtfc3luY10oKSIpDQo+PiBzd2l0
Y2hlZCBkZWxfdGltZXIgdG8gdGltZXJfZGVsZXRlLCBidXQgZGlkIG5vdCBtb2RpZnkgdGhl
IGNvbW1lbnQgZm9yDQo+PiBpcF92c19jb25uX2V4cGlyZV9ub3coKS4gTm93IGZpeCBpdC4N
Cj4gJCBnaXQgZ3JlcCBkZWxfdGltZXIgbmV0L25ldGZpbHRlci8NCj4gbmV0L25ldGZpbHRl
ci9pcHZzL2lwX3ZzX2xibGMuYzogKiAgICAgSnVsaWFuIEFuYXN0YXNvdiAgICAgICAgOiAg
ICByZXBsYWNlZCBkZWxfdGltZXIgY2FsbCB3aXRoIGRlbF90aW1lcl9zeW5jDQo+IG5ldC9u
ZXRmaWx0ZXIvaXB2cy9pcF92c19sYmxjLmM6ICogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGhhbmRsZXIgYW5kIGRlbF90aW1lciB0aHJlYWQgaW4gU01QDQo+DQo+IFdp
ZGVyIHNlYXJjaCwgaW4gdGhlIG5ldCB0cmVlOg0KPg0KPiBuZXQvaXB2NC9pZ21wLmM6ICog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHdoaWNoIGNhdXNlZCBhICJk
ZWxfdGltZXIoKSBjYWxsZWQNCj4gbmV0L2lwdjQvaWdtcC5jOiAqICAgICAgICAgICAgICBD
aHJpc3RpYW4gRGF1ZHQgOiAgICAgICByZW1vdmVkIGRlbF90aW1lciBmcm9tDQo+DQo+IE1h
eWJlIHRoZXNlIGFyZSBvbmx5IGZvciBoaXN0b3JpY2FsIHB1cnBvc2UsIHNvIGxlYXZpbmcg
dGhlbSB1bnRvdWNoZWQNCj4gaXMgZmluZS4NCj4NCkkgaW50ZW50aW9uYWxseSBtb2RpZmll
ZCBvbmx5IHRoaXMgcGFydCwgbGVhdmluZyB0aGUgb3RoZXIgcGxhY2VzIHlvdSANCmZvdW5k
IHVudG91Y2hlZC4NCg0KTXkgZ29hbCB3YXMgdG8gdXBkYXRlIG9ubHkgdGhlIGNvbW1lbnQg
Zm9yIHRoaXMgY29kZSBibG9jaywgbm90IHRoZSANCmZpbGUncyBjaGFuZ2Vsb2cuDQoNCg0K
VGhhbmtzLA0KDQotLSANCldhbmdZdWxpDQo=
--------------07PXpVmU8b1YT04K6viN7jix
Content-Type: application/pgp-keys; name="OpenPGP_0xC5DA1F3046F40BEE.asc"
Content-Disposition: attachment; filename="OpenPGP_0xC5DA1F3046F40BEE.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSK
P+nX39DNIVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAx
FiEEa1GMzYeuKPkgqDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMB
AAAKCRDF2h8wRvQL7g0UAQCH3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfP
bwD/SrncJwwPAL4GiLPEC4XssV6FPUAY0rA68eNNI9cJLArOOARmgSyJEgorBgEE
AZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7VTL0dvPDofBTjFYDAQgHwngE
GBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIbDAAKCRDF2h8wRvQL
7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkUo9ERi7qS
/hbUdUgtitI89efbY0TVetgDsyeQiwU=3D
=3DBlkq
-----END PGP PUBLIC KEY BLOCK-----

--------------07PXpVmU8b1YT04K6viN7jix--

--------------wln8Z5WJ90acIPVp5CBvJ1Z0--

--------------miZQFZGDnPdt0uLvzGTFutMR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCaH9GRgUDAAAAAAAKCRDF2h8wRvQL7gwh
AQD+b6zSXab3OX8ehDxFFWIDaNEuEcWNgwe8KckxeUJLCwEA/a+pT5OaBoXOrDvuUSxrem7LXlM6
dIjddT3Qgh/H1gg=
=xVG0
-----END PGP SIGNATURE-----

--------------miZQFZGDnPdt0uLvzGTFutMR--
