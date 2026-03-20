Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F30D317158
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 11:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774006584; cv=none; b=sLSkohsAYVXjkDDShFkywGCEW+Y4261cxtOAecte9a8QmkN5zPDIclSBX0/Funl0NmA6U7rJIND6KafQyRsGtn3qMPXR3rI7GhqsERMmS0G43uU+SyC6wIPQ8Ki0Ltj5A7UXkpchPTFlM6B9aOGb2fJGDUF2YZ8tjx0hhPqUhbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774006584; c=relaxed/simple;
	bh=ev8nqrYsrlj4gbQrTzw2G1xgtnzq2pmxElfMWAUa+v8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNcg1IeIL6NDm3/LDySJQFvwKY3IEUHCOtRKMjVwU8C6dPsx6pnvqo0uAicmJedJYkxJ7kp0NOtSpV2Se/8l5w4DGMoWVfk1DnIEOIS9zLmKs6xef3EefhIj2qFrIXXPtLZJlN1278XZonF5YYut1NjYy9D4i0ffqxA0DCSZymw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ASph4VA2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ASph4VA2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1L066OGMCpWCvyQMsfGEvzdyYFhs3U0ksgnxeBWTEtc=; b=ASph4VA23JH32Ia+9DUFKlVEH2
	e4yXQ5+WIrOot8TGdljdrGhGzNtVdNSmYgU9AJUcsCC91BhjtaroSgZK/YiaQgfRTAEA/ok2yBiA8
	3gybZPoOCKddK7apADtDS8iiMmsD6hWue5v7mIbqAzxwVUXvvnRH3C9M9GJFyFIObLZjAIWZXR0oM
	soD+9rXUzDYOcjyBcfau2Bufaijkj3AGIHzhIQo3S5npHakmJ0TTCkPD0hpFjx7F8o0kPpFLyhkP3
	RtpJyRSTiHBzw7rTK76x0JV46MfH2e32AL4Vz/xCb9SfPitKV+U9eiApppD0r5SvW1qYVK8DX4Jr3
	cdtZKu/Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w3Y9O-0000000079w-0RSR;
	Fri, 20 Mar 2026 12:36:22 +0100
Date: Fri, 20 Mar 2026 12:36:22 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <ab0xNu8tKdWigNQ1@orbyte.nwl.cc>
References: <20260313153220.19662-1-phil@nwl.cc>
 <abwegj2TijkaQVLz@strlen.de>
 <abwraHUuxizN4krg@orbyte.nwl.cc>
 <abwtAkSF8-SmH684@strlen.de>
 <abxlzn7lymOxWUFa@orbyte.nwl.cc>
 <abyTyJBv47f3v9gd@chamomile>
 <ab0enMtOAFiG0mSN@orbyte.nwl.cc>
 <ab0rbTfE7LWIk7f-@orbyte.nwl.cc>
 <ab0tB2o90FukwQxU@strlen.de>
 <ab0u4JS4Z7THrP6B@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab0u4JS4Z7THrP6B@orbyte.nwl.cc>

On Fri, Mar 20, 2026 at 12:26:24PM +0100, Phil Sutter wrote:
> On Fri, Mar 20, 2026 at 12:18:31PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > On Fri, Mar 20, 2026 at 11:17:00AM +0100, Phil Sutter wrote:
> > > [...]
> > > > A remark from a practical perspective: Florian's suggestion to dump the
> > > > nat-type chains in their order with the dispatcher's priority value is
> > > > super-easy to implement (just have to pass the priority value to
> > > > nfnl_hook_dump_one() via parameter) and does not require adjustments in
> > > > user space.
> > > 
> > > Famous last words. :(
> > 
> > diff --git a/src/mnl.c b/src/mnl.c
> > index 4893af8322ae..b9efd3cfd3ce 100644
> > --- a/src/mnl.c
> > +++ b/src/mnl.c
> > @@ -2520,7 +2520,7 @@ static void basehook_list_add_tail(struct basehook *b, struct list_head *head)
> >                         continue;
> >                 if (!basehook_eq(hook, b))
> >                         continue;
> > -               if (hook->prio < b->prio)
> > +               if (hook->prio <= b->prio)
> >                         continue;
> >  
> >                 list_add(&b->list, &hook->list);
> > 
> > ?
> 
> Sure, but <=nftables-1.1.6 will still get it wrong. Can we tolerate
> that?

The kernel could dump them in reverse. :D
