Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DD31D618A
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 14:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747838449; cv=none; b=BR2ppMOlEgpRwbpSh6/8NP/6TPW5QhFKyFwVTN2vYfJmKN5p83+3CHUJgbcHLfwtDy4lzJq5M6QJPB0f6RNzOuNIyBfDMnce+0fxYHlqFSELZG/DE38JN6/PK2Nmy+hh34Xrs3hKPAOw1IBXHtiQGlgnnVszDPNFlFj7ASQo730=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747838449; c=relaxed/simple;
	bh=vOOnUMnkrIXmJ01pfQ2OILcsQnrRdIeb5vT8tap26K8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/gvMbnfHh6FAnBFsYP5RUi8zQK/4RkvCKAkWYpf8GvYOxqFDy0QJA8GTYC2VrF7CbMdp7JqATopO7y4ZsovElpxYVqyRF3tNiLUoLpIe+w1DuZABhtXd8b5Z5gN6SZ1qRVb7OB5xh5tMqePXL2M3KVpTaK7A9KJZdef+4C+8Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=hztkJFx1; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=BxNOiDjh; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="hztkJFx1";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="BxNOiDjh"
Date: Wed, 21 May 2025 16:40:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1747838445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gSQHsAYM89P0VfgA2H+Gi2ThTGHxt7V5bozecxij+es=;
	b=hztkJFx1pw4MBIYe60NACKiQ1XocINPxHLHEv6FC/qBTVM1Hzlbg9pgRyp/Ev4hzdFsze2
	OfSirX6f63olubJD10Z4o2RNq7ksksyDbmXPpOIeTTbzZHd1s452hh0v8KyO215qsp6J08
	6/rREanubcGqSxMPGx77RTJkBMzSXtTHLfSYBsjMHsM7f7HPu2J2HcD8hxYRKQq5pJrT9I
	wzBDxLEQjTaDbvEIOVSXIE3gW131AgxWdGciqjhQnVMK9gi3sjvkIKpINkmE7TJTq9s7/G
	q3aEQpCaA3N9/RWPxEoE2xtRwPqP1qPD7i6G4NwXy7QD2mi92DsdnRnst5mvsQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1747838445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gSQHsAYM89P0VfgA2H+Gi2ThTGHxt7V5bozecxij+es=;
	b=BxNOiDjhMZKxIFcHxk4SXxBw59ZmaxKIyKHh7qNb9AV1sEv/4U5jlij+etxAh7XlUOQaNw
	pHg0FY4TyAGUMtCg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>
Subject: Re: [PATCH nf-next v1 1/3] netfilter: nf_dup{4, 6}: Move duplication
 check to task_struct
Message-ID: <20250521144043.GFZkHbrX@linutronix.de>
References: <20250512102846.234111-1-bigeasy@linutronix.de>
 <20250512102846.234111-2-bigeasy@linutronix.de>
 <aC3iO9FJo1FvdloW@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aC3iO9FJo1FvdloW@calendula>

On 2025-05-21 16:24:59 [+0200], Pablo Neira Ayuso wrote:
> Hi Sebastian,
Hi Pablo,

> On Mon, May 12, 2025 at 12:28:44PM +0200, Sebastian Andrzej Siewior wrote:
> [...]
> > diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
> > index 0c39c77fe8a8a..b903c62c00c9e 100644
> > --- a/net/ipv6/netfilter/nf_dup_ipv6.c
> > +++ b/net/ipv6/netfilter/nf_dup_ipv6.c
> > @@ -48,7 +48,7 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
> >  		 const struct in6_addr *gw, int oif)
> >  {
> >  	local_bh_disable();
> > -	if (this_cpu_read(nf_skb_duplicated))
> > +	if (current->in_nf_duplicate)
> 
> Netfilter runs from the forwarding path too, where no current process
> is available.

If you refer to in-softirq with no task running then there is the idle
task/ swapper which is pointed to by current in this case. There is one
idle task for each CPU, they don't migrate.

> >  		goto out;
> >  	skb = pskb_copy(skb, GFP_ATOMIC);
> >  	if (skb == NULL)
> > @@ -64,9 +64,9 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
> >  		--iph->hop_limit;
> >  	}
> >  	if (nf_dup_ipv6_route(net, skb, gw, oif)) {
> > -		__this_cpu_write(nf_skb_duplicated, true);
> > +		current->in_nf_duplicate = true;
> >  		ip6_local_out(net, skb->sk, skb);
> > -		__this_cpu_write(nf_skb_duplicated, false);
> > +		current->in_nf_duplicate = false;
> >  	} else {
> >  		kfree_skb(skb);
> >  	}

Sebastian
