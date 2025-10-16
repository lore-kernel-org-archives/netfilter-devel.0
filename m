Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523E0186284
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 14:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760623419; cv=none; b=YgMrhl2CGa/sqFRERJPPG0NiyEIaljNdnBY8fR2npIAKma1quAJLQOc5lJ6VljfQfXwNRTLfhspRoLvABbeug0wXRdnyT8D3/bm7nD+tXFrDKJ9g/fxuX72YzHXvpyhJt+qeWrONvjzaV6V/1wgF4QQ6l57NIY5VEfHGmRsIfLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760623419; c=relaxed/simple;
	bh=iE6F88400xjFh+3HUySSQnB79/84gahCPlsl5IdIGbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UKgDAa4aYO7jFeuybZXkpRfz2ElGsCn4Pr9pvtBYsRj0GUOFEwWsTGqPg7vbyxFbUID8ECYttcd4Zz+RuDQo9at3HIZO2uwpwx7HkvoJnxah1zBwlmmHmCnDboYPC3YoeuYgNeKcr/1k5ftSGMplyBLi03Cy9Q3drxqZpgqOQ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bHaT9WWG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bHaT9WWG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8raS0bpJlq53M6l5LPLz4DGNxD4Iws3lkcF3Arqwzn4=; b=bHaT9WWGIxL2FYshxHM45rNNdJ
	WhV5sLi4hM5SY0XUsj+mI0LI/T6vv1vmd24WvHxYYWtgKLUHHYeK6oqJAZ/gVmDgt+gfFxNuVD1sH
	chqG9VDJHP9eWyEB8EYTduWj8qTyLZ0Fuwu8w3l1PUsTGoPtIXca4okP3KHclotFbbFr94xSDm7Bz
	CQ2yuS3n4zBAGVuzA1hFEC1iO50SEXVLPumAyUWcArHEUVeXWJT/xBTOqsxP5ShCL12mVqRdp3DQx
	D8ogLaRVbUA9dW9ztkLcBrjfyM6vRq/ZRSO5dqJ3XBhnzWiKCPzaJV/Q7ayFKq4VKyETI7sy8Elic
	PDidcZCA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1v9OZo-0000000057A-2ggh;
	Thu, 16 Oct 2025 16:03:32 +0200
Date: Thu, 16 Oct 2025 16:03:32 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] utils: Introduce nftnl_parse_str_attr()
Message-ID: <aPD7NGL19sNV9uEf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251015202436.17486-1-phil@nwl.cc>
 <aPDQljEef_EXGmFy@strlen.de>
 <aPD4mgdtY4DjLrEH@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPD4mgdtY4DjLrEH@calendula>

Hi!

On Thu, Oct 16, 2025 at 03:52:26PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 16, 2025 at 01:01:42PM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > Wrap the common parsing of string attributes into a function. Apart from
> > > slightly reducing code size, this unifies callers in conditional freeing
> > > of the field in case it was set before (missing in twelve spots) and
> > > error checking for failing strdup()-calls (missing in four spots).
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  include/utils.h         |  3 +++
> > >  src/chain.c             | 33 +++++++++------------------------
> > >  src/expr/dynset.c       | 12 +++++-------
> > >  src/expr/flow_offload.c | 12 +++++-------
> > >  src/expr/log.c          | 13 ++++---------
> > >  src/expr/lookup.c       | 12 +++++-------
> > >  src/expr/objref.c       | 18 ++++++++----------
> > >  src/flowtable.c         | 24 ++++++++----------------
> > >  src/object.c            | 14 ++++++--------
> > >  src/rule.c              | 22 ++++++----------------
> > >  src/set.c               | 22 ++++++----------------
> > >  src/set_elem.c          | 38 +++++++++++++-------------------------
> > >  src/table.c             | 11 +++--------
> > >  src/trace.c             | 28 ++++++++++------------------
> > >  src/utils.c             | 15 +++++++++++++++
> > >  15 files changed, 106 insertions(+), 171 deletions(-)
> > 
> > Nice compaction.

Thanks. :)

> > Acked-by: Florian Westphal <fw@strlen.de>
> 
> I started different infrastructure to compact this, I can rebase at
> some point on top this if Phil is having time to make cleanups.

You're OK with me pushing this out? Feel free to send me your draft,
I'll review and maybe we can cross the beams^W^W^Wjoin forces.

Cheers, Phil
