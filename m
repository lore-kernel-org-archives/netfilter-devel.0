Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB1C32861C
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Oct 2025 11:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761132379; cv=none; b=Bfr+OFWjOUJdxGrZSKpUOczztC0s8pwBPIGGFxwJWgJOyUBEqMiD59/EWOEAv7n38A8O9loGxjdxyNI0xI9qDS0U/5KNRIXoHZ9sCMqjncBJywMeOveBmBO2BTY1C2ulrmtZw+ell4BTIGRq6eei6MxIrLUgXbR0N/bBrJoWaEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761132379; c=relaxed/simple;
	bh=1z5fX7oHjKhZbPwh/qe6b1grz+heE7CVp39d4GIsxZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SvvvQIwyUYS0zHA+VjwlHLnyvCMZFE0pX60E4ItOu8Jo9sXfHFsapMN9TTJxkE8+CVOScVfsDLe7j3hJAj3rNA27fbwNhFsuzYjWgjO8kd8jmCUNJpr7MSmBeiDu5SoRCztrszIKIF5W+2j1b9My+yf5zI2+oBPCrmL/nh1VWM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2B7896031F; Wed, 22 Oct 2025 13:26:14 +0200 (CEST)
Date: Wed, 22 Oct 2025 13:26:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] selftests: nft_queue: conntrack expiration requeue
Message-ID: <aPi_VdZpVjWujZ29@strlen.de>
References: <20251020200805.298670-1-aojea@google.com>
 <aPah2y2pdhIjwHBU@strlen.de>
 <CAAdXToT14bjkvCrP=tG4V4XJhhyGMfuJz+FdfTO+xJ10Z-RezA@mail.gmail.com>
 <aPay1RM9jdkEnPbM@strlen.de>
 <CAAdXToQs8wPYyf=GEnNnmGXVTHQM0bkDfHGqVbLhber04AyM_w@mail.gmail.com>
 <aPdkVOTuUElaFKZZ@strlen.de>
 <CAAdXToRzRoCX4Cvwifq9Yr7U663o4YLCh1VC=_yhAYqAUZsvUA@mail.gmail.com>
 <aPd6Ch7h6wdJa-eE@strlen.de>
 <CAAdXToQ+DuBsPGQUgSCk2=f_b2222iTD4-rT=0gVuaYWT7A2HQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdXToQ+DuBsPGQUgSCk2=f_b2222iTD4-rT=0gVuaYWT7A2HQ@mail.gmail.com>

Antonio Ojea <aojea@google.com> wrote:
> > So I went with 'no rules that adds one, no need for ct label
> > extension space allocation'.
> 
> But that does not consider the people that just use netlink to set the
> labels ... from a 1k altitude , can you do a check on the first
> update/create/delete label to initialize the extension?

Yes, but in that case it is not possible to disable it again.

Rule based on/off means we can disable it once the rule is gone.

I'd propose to extend the label allocation to when a 'ct lablel'
rule is added rather than just 'ct label set'.

> Another question related, is it required for the label value to be
> always 16 bytes?

As far as I can see ctnetlink enforces the len must be a multiple of 4
and at most 16 bytes.
