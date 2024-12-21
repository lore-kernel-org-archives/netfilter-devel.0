Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E207FBA2
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Dec 2024 15:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734795305; cv=none; b=C/ab7e79+3zwdzR4vqBiYcBkibf0mTOJE3X0rw88MqjMrTZHqFRjxp623cViZVtKKWK2tkj124cpJRv637drWqnSGFf+NWiIiDtlmB7aaLflh1V/vFD6m2eurL/hO/pq3tQEdRsEKb3NQNMoWfKbLzPCwJmUor8rqUEVpY+idfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734795305; c=relaxed/simple;
	bh=jLdUS6RvxJzhvJoAjL8UxR0YTGMv9mdzNgs88g6yhN0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=G9RmRE7Zu8adT11DEze/vwxnxfSeTBhf/7/ZCH/+NIJyeL+Dmfi7Aezs+z/jRCrZ8NgFa/H+xY3qLAdFCE1RRjasgXIMGjxHFwaT1x2flVyJW1+icD8zZ6PdaEspyzbLDWSXr1tOI8TfAMkYQ6kJTJZ+Xac/DvCfG7D/2q5Y6rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=kmEhKOP8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=g/mhrgcr; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="kmEhKOP8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="g/mhrgcr"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 3E9E41380206;
	Sat, 21 Dec 2024 10:35:00 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sat, 21 Dec 2024 10:35:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1734795300; x=1734881700; bh=Ir6+udzEyh
	JHy87Q7ZPwtuQUFaU1d2r5VjSg7QMLKzA=; b=kmEhKOP8MCHj+ZSFJKFHS6mxTx
	RcyBlELmPx+fTvOXp3amht5fHYhDxhtQ29IiPO5w278fwqUs1jwGW92QzlLJvMu5
	/JVD4qr48GDaSJYdmMytJg2rl7BwNhnv0WAbVYPflST0hSVvDpQhwV8YGJYzIzUU
	c0OPocWyZcn7pB1W7GCeEkrChmauoRp60P3IruYi7k7zmKj8jINO1gB9jdKnZvKg
	nx4UF/Jv7ZzNfOhep7PdIIOVjFOrVKvDVdZhu6jAi3KBv5JSKEhMY3P9hrc5T4Ol
	YVHrnpGEQNSFx6oGpatx1R4QFR1EIxjoieCFhKC9A5t/I9XtSiK1chtpv75Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1734795300; x=1734881700; bh=Ir6+udzEyhJHy87Q7ZPwtuQUFaU1d2r5VjS
	g7QMLKzA=; b=g/mhrgcrOzRRu6JIK6fCp2i+8yQYYGQVX9sN1W8WQaxcAzgyN90
	7A2ZGaaA9QZWtoFOkdpxVCGHsl5p6ZkBBhAGCbPwB4tHrxMs6QGjBKGlTYFQMsR0
	0/pPoxxpDp1wU3xXtMlAQkgzacf3Tos2y+cNgizc0Lkwzo2SYCVuNyN67BbU9h0v
	KQ9aIEfjeYaggR0eSs6KoFlOIEPOy2QXZg4m7reDiELXvQaxGYGiODkn7UBM9k4R
	pH2tHdb1VCtmxaL2hGavlBOcPkkO+XZxF7d3/KeM+X/tZ8b48JXpLJFpvt9TMOsX
	mnchsyL/7DfiEDf2B36IqKtK2ew2MsF8CWA==
X-ME-Sender: <xms:I-BmZ7_OphOwB4HrxllkuQ1X9IyXiwbsm388m3zg9dcmHErxB20ZJg>
    <xme:I-BmZ3u9z70AQpb-qYTZQ1czJmr6WNXXILyoA4PjiczZy-4tUI3deX6k8NyjqOix5
    ZteRTQORI5_pmwyxQ>
X-ME-Received: <xmr:I-BmZ5CHdMTTzEFB1q3ehnCzbCJfZvXuLCai0kK8qrNiS8pKJtTPVtxgppPC4uLKoQMrxbpvjdkdIy9U7AvjYA2oHYvK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddruddthedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhephffvvefujghffffkgggtsehgtderredttdejnecu
    hfhrohhmpeetlhihshhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenucggtf
    frrghtthgvrhhnpeetheevudfgjefghefhieejudelkeeljeegvdekueeuhffhgedvveef
    teevgeetieenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehhihesrghlhihsshgrrdhishdpnhgspghrtghpthhtohepgedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtohepjhhoshhhuhgrlhgrnhhtsehgohhoghhlvghmrghilhdrtg
    homhdprhgtphhtthhopehprggslhhosehnvghtfhhilhhtvghrrdhorhhgpdhrtghpthht
    ohepphhhihhlsehnfihlrdgttgdprhgtphhtthhopehnvghtfhhilhhtvghrqdguvghvvg
    hlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:I-BmZ3eEDHU-9BX1i_0jGlvFnCd2s76IH1YTJ-ii7Fl6zqlXnpoytA>
    <xmx:I-BmZwMVT6EQCXjR5xbh-2GIrfS6dOxcix_KmVketV5qHYe1oKS7wg>
    <xmx:I-BmZ5lANzXH6OlxMlNqXaPmxdP1fiKBvo3S2qTkEyIpMCO45qadIA>
    <xmx:I-BmZ6uIOfpFfWX9HhA_lj-r3Zwdv4n--lfXufYzb_l6OB6a0zAoxw>
    <xmx:JOBmZ9ph9UeWkhLXRcQwqrQ-5yiBg6Xyggu70SIoErmDHku6DucGG8tr>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 21 Dec 2024 10:34:59 -0500 (EST)
Received: by mbp.qyliss.net (Postfix, from userid 1000)
	id 19AB1CC45; Sat, 21 Dec 2024 16:34:57 +0100 (CET)
From: Alyssa Ross <hi@alyssa.is>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Joshua Lant <joshualant@googlemail.com>
Subject: Re: [PATCH nftables] include: fix for musl with iptables v1.8.11
In-Reply-To: <Z2VkJrkSLRmY9lAE@orbyte.nwl.cc>
References: <20241219231001.1166085-2-hi@alyssa.is>
 <Z2VaEv0u3ZPcWqye@orbyte.nwl.cc>
 <v654rm6mbtymzhavlbg2fu7irth4mkz4motq7vb7rzjql5ccqa@u7xv7uvdfvsl>
 <Z2VkJrkSLRmY9lAE@orbyte.nwl.cc>
Date: Sat, 21 Dec 2024 16:34:55 +0100
Message-ID: <87v7vd59sw.fsf@alyssa.is>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Phil Sutter <phil@nwl.cc> writes:

> On Fri, Dec 20, 2024 at 01:07:56PM +0100, Alyssa Ross wrote:
>> On Fri, Dec 20, 2024 at 12:50:42PM +0100, Phil Sutter wrote:
>> > Hi Alyssa,
>> >
>> > On Fri, Dec 20, 2024 at 12:10:02AM +0100, Alyssa Ross wrote:
>> > > Since iptables commit 810f8568 (libxtables: xtoptions: Implement
>> > > XTTYPE_ETHERMACMASK), nftables failed to build for musl libc:
>> > >
>> > > 	In file included from /nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-m=
usl-1.2.5-dev/include/netinet/et=E2=80=A6
>> > > 	                 from /nix/store/kz6fymqpgbrj6330s6wv4idcf9pwsqs4-i=
ptables-1.8.10-de=E2=80=A6
>> > > 	                 from src/xt.c:30:
>> > > 	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/=
netinet/if_ether.h:115:8: error: redefinition of 'struct ethhdr'
>> > > 	  115 | struct ethhdr {
>> > > 	      |        ^~~~~~
>> > > 	In file included from ./include/linux/netfilter_bridge.h:8,
>> > > 	                 from ./include/linux/netfilter_bridge/ebtables.h:1,
>> > > 	                 from src/xt.c:27:
>> > > 	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/=
linux/if_ether.h:173:8: note: originally defined here
>> > > 	  173 | struct ethhdr {
>> > > 	      |        ^~~~~~
>> > >
>> > > The fix is to use libc's version of if_ether.h before any kernel
>> > > headers, which takes care of conflicts with the kernel's struct ethh=
dr
>> > > definition by defining __UAPI_DEF_ETHHDR, which will tell the kernel=
's
>> > > header not to define its own version.
>> >
>> > What I don't like about this is how musl tries to force projects to not
>> > include linux/if_ether.h directly. From the project's view, this is a
>> > workaround not a fix.
>>=20
>> My understanding is that it's a general principle of using any libc on
>> Linux that if there's both a libc and kernel header for the same thing,
>> the libc header should be used.  libc headers will of course include
>> other libc headers in preference to kernel headers, so if you also
>> include the kernel headers you're likely to end up with conflicts.
>> Whether conflicts occur in any particular case depends on how a
>> particular libc chooses to expose a particular kernel API.  I could be
>> misremembering, but I believe the same thing can happen with Glibc =E2=
=80=94
>> some headers under sys/ cause conflicts with their corresponding kernel
>> headers if both are included.  While this case is musl specific, I
>> think the principle applies to all libcs.
>
> While this may be true for the vast majority of user space programs,
> netfilter tools and libraries are a bit special in how close they
> interface with the kernel. Not all netfilter-related kernel API is
> exposed by glibc, for instance. Including (some) kernel headers is
> therefore unavoidable, and (as your patch shows) order of inclusion
> becomes subtly relevant in ways which won't show when compile-testing
> against glibc only.

Yeah =E2=80=94 really it needs to be ensured in review that libc headers are
included before kernel headers, and libc headers are preferred over
kernel headers where both are available.  It's not too much to keep in
mind, but it does need to be taught/learned because the issues it causes
won't always be caught during testing in any particular environment.
The same holds for lots of things in C, though.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQRV/neXydHjZma5XLJbRZGEIw/wogUCZ2bgHwAKCRBbRZGEIw/w
oqIpAP9dy83DYDj542QyTh8W60CK9aM+8xUqd1Ybtg+xuRZvxAD+KZTMa11I8DoM
UG5Thhc6bE446VIPdXlyVZdkpYEVFAo=
=VOvI
-----END PGP SIGNATURE-----
--=-=-=--
