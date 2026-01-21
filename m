Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF7B421F07
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Jan 2026 15:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769010582; cv=none; b=Ohj1BmFYPk2/mCcDh9VIpt5lQfOG6/NCI6gIyiHGrGYOds9vdSnMlOspQGcVpLzJUO3Wa/UFo6MF2349FSvAbbHhJc2obPzycLOD3V90vRZSSdqZrwIN0fcNbrdeW2t5TIdcdYkgMOl5CPglvRJolnaxVHBhvGWib/6XnqNJZ7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769010582; c=relaxed/simple;
	bh=pcS0wmqCJqfeupPkMwGdzlw68rOiVEuF0BDHpThppNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UqN2hrXCGH8VuMAmcw1F2XjuH47+pRtg8rbBSc+61XrKTXq9G5Wc3y3hR9sLoWlv7pJAB6iCYlTwyfT6xeIsSF7Nc+gMIk08d4/mk2sk4fRw89UUOAx4CfP1qVTtxMmKhlvUrqkNdI6QPxg0Gd1GeQpFZ3KaVLyTOzoMYng/BYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 66E6B604E3; Wed, 21 Jan 2026 16:49:36 +0100 (CET)
Date: Wed, 21 Jan 2026 16:49:30 +0100
From: Florian Westphal <fw@strlen.de>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v6 2/2] netfilter: nfnetlink_queue: optimize verdict
 lookup with hash table
Message-ID: <aXD1ior73lU4LYwm@strlen.de>
References: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
 <20260117173231.88610-3-scott.k.mitch1@gmail.com>
 <aWwUd1Z8xz5Kk30j@strlen.de>
 <CAFn2buDVyipnvn8iW1dsPN827D1BBrZ9xLjcuJHC7W00xjioSg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFn2buDVyipnvn8iW1dsPN827D1BBrZ9xLjcuJHC7W00xjioSg@mail.gmail.com>

Scott Mitchell <scott.k.mitch1@gmail.com> wrote:
> > > +#define NFQNL_HASH_MAX_SIZE        131072
> >
> > Is there a use case for such a large table?
> 
> Order of magnitude goal is to gracefully handle 64k verdicts in a
> queue (w/ out of order verdicting).

Ouch.  I fear this will need way more work, we will have to implement
some form of memory accounting for the queued skbs, e.g. by tracking
queued bytes instead of queue length.

nfqueue comes from a time when GSO did not exist, now even a single
skb can easily have 2mb worth of data.

> > What is the deal-breaker wrt. rhashtable so that one would start to
> > reimplement the features it already offers?
> 
> Agreed if global rhashtable is within the ballpark of v6 performance
> it would be preferred. I've implemented the global rhashtable approach
> locally and I've also implemented an isolated test harness to assess
> performance so we have data to drive the decision.
>
> I captured the rationale for current approach here:
> https://lore.kernel.org/netfilter-devel/CAFn2buB-Pnn_kXFov+GEPST=XCbHwyW5HhidLMotqJxYoaW-+A@mail.gmail.com/#t.

OK, but I'm not keen on maintaining an rhashtable clone in nfqueue.

If the shrinker logic in rhashtable has bad effects then
maybe its better to extend rhashtable first so its behaviour can
be influenced better, e.g. by adding a delayed shrink process that
is canceled when the low watermark is below threshold for less than
X seconds.
