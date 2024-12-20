Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076F51BCA19
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2024 12:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734696485; cv=none; b=QeFrLrC3XZD4DoPzgh+TUPugN40LxA6smvASxGNTZMmXfo2TXaJiDkFwOLgSOPAXuWxteE98YuvyTOkxoXUlb5baM6jKXxyqbLo9k59xuxxkhHekddU3tOOyHPNf8mlo/2kAAioikSSFdKkGqM+wmm4UVY855vngdDmQSF1XsFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734696485; c=relaxed/simple;
	bh=Ia5oSfmSnRCzke89PMy7Sdtyh5BEHlV9gpnhnnV/sLo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rq2QSouwaspIr+JYkGv+3R8aJRmYUjD3U1bIqG+EIg5GNgEOXSdq/MmCup0kw63ULhU2JpR7J55FIRDV1TnRXY32y8RAfNgTDmzY6vOUZhjMVO+QZFsdiojyEfiDFbcvG5pDwZPe8u/MbwyhZFjyVO1x4uD+/DW/BjXIHssbr+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=Jfv29PoT; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=yB3pOPvD; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="Jfv29PoT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="yB3pOPvD"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id F26CE25401DE;
	Fri, 20 Dec 2024 07:08:00 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 20 Dec 2024 07:08:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1734696480; x=1734782880; bh=wWEfKU4USS
	K6vC9twiVxYAEGhMTfdZ898WLIKyTVPY4=; b=Jfv29PoTJzPgzo9pUVGIsgXM54
	741dlUg9dbkDlrZV4OwO0BRE62rTowuLjhmL1Xj2xVeJGBIy6w4Ee6DPcv9WIRWH
	IW0r9YSTcG32kHWhy1L4OKmVzWiV+h2ul7xirt0qBkU9+fJaADRzw8NEjN04mNUC
	YlGAOnvBqVZCwiMFd+UREi2AZ8xjFLlvtUi1dQ+nQAhNLqVSQ9WIcKcW900YR3lo
	/XIlJjJ6JYyqelfAwVAn1+E7J3a+xFobiuzal9QgNQ1ZDIJrgil7CRaVOddT32lg
	hftSBIQQ9FLIRIxUt462XTqPExGkjcYqGo5fdrQKppOzT7ZkRf7kKTRdWHqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1734696480; x=1734782880; bh=wWEfKU4USSK6vC9twiVxYAEGhMTfdZ898WL
	IKyTVPY4=; b=yB3pOPvDwAzrFe20jbWTWnwjBdHOP1CzuSqW5B+0c0xzKgN0FuH
	ep4uSPa33Ow7pO/sVsWPtUj6N784vZ4WLFU1DqBzK1lKLu/M0PtAWDdlw4Lns2aH
	UoMf7T0k0xd67iDYHmB9zSFPd9Cwqw6mn+iVKEO0Rzd7RVcG7R9VyRPDyKwMx43G
	uRs3IC0nGdrgSVPOJ8fKhntjWhhwegvItsV9oWO70gMr75X2FgYJ0z5He/v7fuBk
	WSusOT7Ye5E0jNK4/DXo0PrbAJwQNq+0bHA4X3dqHOUYK2vNPWoHXQv2zN19BcWI
	lp3ZffkQWPUJybUftmLfSvDaDpSYdm0dVwQ==
X-ME-Sender: <xms:IF5lZycIMVT_vWwaZW4bjtCcLQQRA0J6dbzfcgSBxCpI6TWQZiViDg>
    <xme:IF5lZ8OeHYSHdjqxsGIvw7skyD5mvBK1H1nMwLlattRUzKHJ37mJb7U6OrPEhDLYT
    wKfcvbl44iVINMwfw>
X-ME-Received: <xmr:IF5lZzgjZErPCGsea-OLjJ3yB_TUGyidHg_hxvPcE6C6pFbhqOIvy5zUiU_JQvU-npkTKzU_PaJYIs8j3-7VsKdzrN9cQ8KxUhI9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddruddtvddgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjsehgtdfsredttdejnecu
    hfhrohhmpeetlhihshhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenucggtf
    frrghtthgvrhhnpeegteegkeefudehueekgeelteekjefhgeeukeegudehjefffeffueeu
    gfdvtdfhveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehhihesrghlhihsshgrrdhishdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtohepjhhoshhhuhgrlhgrnhhtsehgohhoghhlvghmrghilhdrtg
    homhdprhgtphhtthhopehphhhilhesnhiflhdrtggtpdhrtghpthhtohepnhgvthhfihhl
    thgvrhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:IF5lZ_-6yvBa10nRdghiQ2WNes8vtmZ-i9dqLIDBwWLq2dqlieaHnw>
    <xmx:IF5lZ-t8qmv-KKtqNyV5oSFtLJ9iRT8ZR4hcckBw0I2KbVoNqfiQOw>
    <xmx:IF5lZ2HuXHeUDc2PTIKxtW8bj3tOHxcjdsXKof5Bx1FcSdE8n5fq9A>
    <xmx:IF5lZ9M2xqJiHvHZyzjJDoApVnty_o39AfGUs6hXq4eeUoRdjlOU4g>
    <xmx:IF5lZyJftrMv1zRWiiYCgLHVgVFuMruhJm9UETCoDllyw-ED0rXwzg4b>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Dec 2024 07:08:00 -0500 (EST)
Received: by mbp.qyliss.net (Postfix, from userid 1000)
	id 2A4AACA36; Fri, 20 Dec 2024 13:07:56 +0100 (CET)
Date: Fri, 20 Dec 2024 13:07:56 +0100
From: Alyssa Ross <hi@alyssa.is>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, 
	Joshua Lant <joshualant@googlemail.com>
Subject: Re: [PATCH nftables] include: fix for musl with iptables v1.8.11
Message-ID: <v654rm6mbtymzhavlbg2fu7irth4mkz4motq7vb7rzjql5ccqa@u7xv7uvdfvsl>
References: <20241219231001.1166085-2-hi@alyssa.is>
 <Z2VaEv0u3ZPcWqye@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gfwc22ddowwi62kd"
Content-Disposition: inline
In-Reply-To: <Z2VaEv0u3ZPcWqye@orbyte.nwl.cc>


--gfwc22ddowwi62kd
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH nftables] include: fix for musl with iptables v1.8.11
MIME-Version: 1.0

On Fri, Dec 20, 2024 at 12:50:42PM +0100, Phil Sutter wrote:
> Hi Alyssa,
>
> On Fri, Dec 20, 2024 at 12:10:02AM +0100, Alyssa Ross wrote:
> > Since iptables commit 810f8568 (libxtables: xtoptions: Implement
> > XTTYPE_ETHERMACMASK), nftables failed to build for musl libc:
> >
> > 	In file included from /nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl=
-1.2.5-dev/include/netinet/et=E2=80=A6
> > 	                 from /nix/store/kz6fymqpgbrj6330s6wv4idcf9pwsqs4-ipta=
bles-1.8.10-de=E2=80=A6
> > 	                 from src/xt.c:30:
> > 	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/net=
inet/if_ether.h:115:8: error: redefinition of 'struct ethhdr'
> > 	  115 | struct ethhdr {
> > 	      |        ^~~~~~
> > 	In file included from ./include/linux/netfilter_bridge.h:8,
> > 	                 from ./include/linux/netfilter_bridge/ebtables.h:1,
> > 	                 from src/xt.c:27:
> > 	/nix/store/bvffdqfhyxvx66bqlqqdmjmkyklkafv6-musl-1.2.5-dev/include/lin=
ux/if_ether.h:173:8: note: originally defined here
> > 	  173 | struct ethhdr {
> > 	      |        ^~~~~~
> >
> > The fix is to use libc's version of if_ether.h before any kernel
> > headers, which takes care of conflicts with the kernel's struct ethhdr
> > definition by defining __UAPI_DEF_ETHHDR, which will tell the kernel's
> > header not to define its own version.
>
> What I don't like about this is how musl tries to force projects to not
> include linux/if_ether.h directly. From the project's view, this is a
> workaround not a fix.

My understanding is that it's a general principle of using any libc on
Linux that if there's both a libc and kernel header for the same thing,
the libc header should be used.  libc headers will of course include
other libc headers in preference to kernel headers, so if you also
include the kernel headers you're likely to end up with conflicts.
Whether conflicts occur in any particular case depends on how a
particular libc chooses to expose a particular kernel API.  I could be
misremembering, but I believe the same thing can happen with Glibc =E2=80=94
some headers under sys/ cause conflicts with their corresponding kernel
headers if both are included.  While this case is musl specific, I
think the principle applies to all libcs.

> > Signed-off-by: Alyssa Ross <hi@alyssa.is>
> > ---
> > A similar fix would solve the problem properly in iptables, which was
> > worked around with 76fce228 ("configure: Determine if musl is used for =
build").
> > The __UAPI_DEF_ETHHDR is supposed to be set by netinet/if_ether.h,
> > rather than manually by users.
>
> Why does 76fce228 not work for you?

It does work, but that's a fix for iptables.  This is a fix for
nftables.  I could have submitted a copy of the iptables fix, but I
don't think it's the best fix due to its reliance on internal macros
that are not part of the public interface.

--gfwc22ddowwi62kd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRV/neXydHjZma5XLJbRZGEIw/wogUCZ2VeEgAKCRBbRZGEIw/w
oltEAQDAh02JFiXSsaPfhX5M3csr3gIE4q1cbWHJIKB4rWsLgQD/YiBwFtd7dGzV
m6L1e5jYIhxmH/Ql/UGxTDm0YGvF/QE=
=E6JZ
-----END PGP SIGNATURE-----

--gfwc22ddowwi62kd--
