Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE9A350A16
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 12:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769604293; cv=none; b=CSySwAsCknhhzFylGbwC5XbV4FQGLPEAMW/+Eh4g1iyxB+NvyW3xvDmjAoBDs5h+K88OPLGTeR0c1HcA99edQjuu24Yd8YmEX17R2VKKEKDnX60F7wfrn2LxMAE+//BC0c7pkCyCt+Q3C5lgz+NfgMwBWtRZeuiD0dhGDXNeN4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769604293; c=relaxed/simple;
	bh=aYaifD8O4wPqFBzvReRMpwmlYrSoggZoXLUWNFmqs1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wawh6hlJzmXybr68wMvfr+8QV2EZ5TOZ86pXoNviinhTOVMTwZ7cG2LNxJW1fFA1YrsE5+BOWAmm+HiSsGAL5VSRl9kGMagTON4yomw/B+2P41S62RyWrq8ruwMKWfAAc35FYVDgPS1LNENWaX2JVX0hePGWZyINbsut0LDKR6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=QC4Hecb0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="QC4Hecb0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EX/EgCu78b/RFH7O1ZfSE9gF3rPpmZkUCmXRCDfljs8=; b=QC4Hecb0G9Vjh5+UwlbjiQlckB
	tT9c28MbBceZ4K9jSLvjSnlIL1XrB4tGyey/Q9qnYxJd9rjH63kK+O19MxQ9Itdw7wzsspQXASWe3
	Y+9GC2bFDJOHjO/B+kYeWGCgpp43sfDTqHub5mzIDHuRsVwW8f2rsjYOnyWDJT4g7qQd7mZvgHXqW
	FPOUaQ83E7Q2DAMxcRJUgEJodDQ64fL+KUl4e2bVynAdJak/TOi27jZVQPBE8VLIxz+EbLeLeZjjm
	g8zhmz7u4oCte8dNmGC54uqkmb2eg2+SlAfJQ2bs34535llAbv/lMexBoxkm7xABWHinSAIJY0YrQ
	bNmbCjKg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vl4ua-000000003sS-2NqK;
	Wed, 28 Jan 2026 13:44:44 +0100
Date: Wed, 28 Jan 2026 13:44:44 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jeremy Sowden <jeremy@azazel.net>, netfilter-devel@vger.kernel.org,
	Philipp Bartsch <phil@grmr.de>, Arnout Engelen <arnout@bzzt.net>,
	fw@strlen.de
Subject: Re: [nftables PATCH] build: support SOURCE_DATE_EPOCH for
 reproducible build
Message-ID: <aXoEvAQnTjh31ImG@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jeremy Sowden <jeremy@azazel.net>, netfilter-devel@vger.kernel.org,
	Philipp Bartsch <phil@grmr.de>, Arnout Engelen <arnout@bzzt.net>,
	fw@strlen.de
References: <20260123123137.2327427-1-phil@amsel.grmr.de>
 <20260123163615.GB1387959@celephais.dreamlands>
 <aXl0orzXWNXUumUB@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXl0orzXWNXUumUB@chamomile>

On Wed, Jan 28, 2026 at 03:29:54AM +0100, Pablo Neira Ayuso wrote:
> Cc'ing Phil.

Thanks!

> On Fri, Jan 23, 2026 at 04:36:15PM +0000, Jeremy Sowden wrote:
> > On 2026-01-23, at 13:30:40 +0100, Philipp Bartsch wrote:
> > > Including build timestamps in artifacts makes it harder to
> > > reproducibly build them.
> > > 
> > > Allow to overwrite build timestamp MAKE_STAMP by setting the
> > > SOURCE_DATE_EPOCH environment variable.
> > > 
> > > More details on SOURCE_DATE_EPOCH and reproducible builds:
> > > https://reproducible-builds.org/docs/source-date-epoch/
> > > 
> > > Fixes: 64c07e38f049 ("table: Embed creating nft version into userdata")
> > > Reported-by: Arnout Engelen <arnout@bzzt.net>
> > > Closes: https://github.com/NixOS/nixpkgs/issues/478048
> > > Signed-off-by: Philipp Bartsch <phil@grmr.de>

Acked-by: Phil Sutter <phil@nwl.cc>

> > > ---
> > >  configure.ac | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/configure.ac b/configure.ac
> > > index dd172e88..3c672c99 100644
> > > --- a/configure.ac
> > > +++ b/configure.ac
> > > @@ -165,7 +165,7 @@ AC_CONFIG_COMMANDS([nftversion.h], [
> > >  ])
> > >  # Current date should be fetched exactly once per build,
> > >  # so have 'make' call date and pass the value to every 'gcc' call
> > > -AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
> > > +AC_SUBST([MAKE_STAMP], ["\$(shell printenv SOURCE_DATE_EPOCH || date +%s)"])
> > > 
> > >  AC_ARG_ENABLE([distcheck],
> > >  	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
> > 
> > Apart from the reproducibility problem, the original code doesn't actual
> > do what the comment says.  `date` is called every time a file is
> > compiled.  Here are the first and last half-dozen time-stamps snipped
> > from a recent build:
> > 
> > 	-DMAKE_STAMP=1769185524
> > 	-DMAKE_STAMP=1769185524
> > 	-DMAKE_STAMP=1769185524
> > 	-DMAKE_STAMP=1769185524
> > 	-DMAKE_STAMP=1769185525
> > 	-DMAKE_STAMP=1769185525
> > 	...
> > 	-DMAKE_STAMP=1769185536
> > 	-DMAKE_STAMP=1769185536
> > 	-DMAKE_STAMP=1769185539
> > 	-DMAKE_STAMP=1769185539
> > 	-DMAKE_STAMP=1769185540
> > 	-DMAKE_STAMP=1769185540

Ugh, that's indeed a bug.

> > Generating one time-stamp in the Makefile is a pain in backside.  I have
> > come up with a way to do it, but it's fiddly.  Florian, Phil, would it
> > suffice to generate the time-stamp in configure?

I deliberately chose a build timestamp, not a configure one. In most
cases it won't matter, but since one could defeat the stamp by
recompiling after making changes without calling configure.

> Due to this issue, I can also see bogus:
> 
> # Warning: table ip x was created by a newer version of nftables? Content may be incomplete!
> 
> with partial recompilations while developing on nftables, it is a bit
> annoying because I have to: make clean and compile again. This
> occasionally triggers spurious tests failures here for that reason.

Requesting simple expansion by assigning to MAKE_STAMP using ':='
operator fixes the value throughout one build, but partial recompiling
still leads to objects compiled with different MAKE_STAMP values.

Looks like nftbuildstamp should reside in an object file which is forced
to recompile each time. MAKE_STAMP being consumed by a single object
also mitigates the recursive expansion. WDYT? Am I missing a detail?

Thanks, Phil
