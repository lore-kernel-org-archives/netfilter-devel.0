Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281BC29B216
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 02:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769567400; cv=none; b=TbQkmoYQ8JwARuXtxgypBcJt0BCe14rd/jHWOgFBxkQasDOe733ASOZFPa7xp83Y6lPpTi89xlA83M1300pseZ5H1RWjt8Ak0aXPqmyk5YGv5b/WsCtFNHkxIWXngA3pcl3SGlGDlZ2Iw1RAc5iqB24COtKqZqH4CiMNB22m+0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769567400; c=relaxed/simple;
	bh=Yl0EFztl0SboNzoQK69hvdbgcFIiVyw2ni8Rt2IZC5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ah/x0ixdbjZrOsMT5GwuR6JqBAFUYNL6Ay0g2BmqUBHufNAjGXu0g1F0mHMzlH2CNoTDawBu1lud+0LERZmCx/wdUQ5o3rhStmVGnBSM9PThHdNOesT0ZPIuHonOEDDP2bGUkpl++5qFrwY0eRU4hgks3DRwPBqyXxttoCu11TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NxVe6Qxm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NxVe6Qxm"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3677360181;
	Wed, 28 Jan 2026 03:29:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1769567397;
	bh=TvMGIhhpowEU/IH7j793Wv4z2nCuw1AZ0j0JIj7Cvrw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NxVe6QxmcG6+c5i7y/TBbGIiFe9sFKhAPZfds7NIV6E5uM4+5uDXxU5uL+Dz8hYrD
	 WT4DCvu9h4w+0REME2WDgpd+IR9UHSkAwvxY3nWXJafNe9SzRJqWYczhIoB8nmAhvL
	 ilL+SAOfiVCn75kcQFGICXV/Eja2dOE9G0TTqobPPehEpL0ckwCmB/TprB4eMZ2pEw
	 QmmLwJxE4/f6rBhM9yxxAPup2wRPc1pukrzU7a3+iKVnukNTMB4Y5Stok+2TPn6+MU
	 g/pFzb+JWTlemst9s5T/T84WH2VUeJQ23qvvURMOjV79BSQ7OKq4oJMT9OfJMxPguB
	 DMjTb5snz0CIQ==
Date: Wed, 28 Jan 2026 03:29:54 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: netfilter-devel@vger.kernel.org, Philipp Bartsch <phil@grmr.de>,
	Arnout Engelen <arnout@bzzt.net>, fw@strlen.de, phil@nwl.cc
Subject: Re: [nftables PATCH] build: support SOURCE_DATE_EPOCH for
 reproducible build
Message-ID: <aXl0orzXWNXUumUB@chamomile>
References: <20260123123137.2327427-1-phil@amsel.grmr.de>
 <20260123163615.GB1387959@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260123163615.GB1387959@celephais.dreamlands>

Cc'ing Phil.

On Fri, Jan 23, 2026 at 04:36:15PM +0000, Jeremy Sowden wrote:
> On 2026-01-23, at 13:30:40 +0100, Philipp Bartsch wrote:
> > Including build timestamps in artifacts makes it harder to
> > reproducibly build them.
> > 
> > Allow to overwrite build timestamp MAKE_STAMP by setting the
> > SOURCE_DATE_EPOCH environment variable.
> > 
> > More details on SOURCE_DATE_EPOCH and reproducible builds:
> > https://reproducible-builds.org/docs/source-date-epoch/
> > 
> > Fixes: 64c07e38f049 ("table: Embed creating nft version into userdata")
> > Reported-by: Arnout Engelen <arnout@bzzt.net>
> > Closes: https://github.com/NixOS/nixpkgs/issues/478048
> > Signed-off-by: Philipp Bartsch <phil@grmr.de>
> > ---
> >  configure.ac | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/configure.ac b/configure.ac
> > index dd172e88..3c672c99 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -165,7 +165,7 @@ AC_CONFIG_COMMANDS([nftversion.h], [
> >  ])
> >  # Current date should be fetched exactly once per build,
> >  # so have 'make' call date and pass the value to every 'gcc' call
> > -AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
> > +AC_SUBST([MAKE_STAMP], ["\$(shell printenv SOURCE_DATE_EPOCH || date +%s)"])
> > 
> >  AC_ARG_ENABLE([distcheck],
> >  	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
> 
> Apart from the reproducibility problem, the original code doesn't actual
> do what the comment says.  `date` is called every time a file is
> compiled.  Here are the first and last half-dozen time-stamps snipped
> from a recent build:
> 
> 	-DMAKE_STAMP=1769185524
> 	-DMAKE_STAMP=1769185524
> 	-DMAKE_STAMP=1769185524
> 	-DMAKE_STAMP=1769185524
> 	-DMAKE_STAMP=1769185525
> 	-DMAKE_STAMP=1769185525
> 	...
> 	-DMAKE_STAMP=1769185536
> 	-DMAKE_STAMP=1769185536
> 	-DMAKE_STAMP=1769185539
> 	-DMAKE_STAMP=1769185539
> 	-DMAKE_STAMP=1769185540
> 	-DMAKE_STAMP=1769185540
> 
> Generating one time-stamp in the Makefile is a pain in backside.  I have
> come up with a way to do it, but it's fiddly.  Florian, Phil, would it
> suffice to generate the time-stamp in configure?

Due to this issue, I can also see bogus:

# Warning: table ip x was created by a newer version of nftables? Content may be incomplete!

with partial recompilations while developing on nftables, it is a bit
annoying because I have to: make clean and compile again. This
occasionally triggers spurious tests failures here for that reason.
