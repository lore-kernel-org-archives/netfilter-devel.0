Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC628275AE3
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 09:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755508298; cv=none; b=uwKE8YnHDRiLVwkK4LgeR/bbdKUxRPovQgHtHav88stIkKuXjqSP8PRrp1x297yGf4BA9WCGzxlx0V2TBklXHnttG9L7sHPnQWW4CBPvYWA7lOb8PpNzDgYyUB7VahI8ku9iypgJ5zeaY7j1wOsB8S7yZ9T9/OdBt378YiJtBy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755508298; c=relaxed/simple;
	bh=7EE6Cx1EdtNBr2e4Z0pGYJxS8mqU0ECM+YB3EL6JEI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PEyABmoLCthFaggd/9QqDr8M0A8qetEGW44RNa56EAEmM8WigIsXaJZOO0w7cNmsSXjEM7bvU5RThFCz+GUkMIZpAjqdoM+J5tTTtcXVrjY1qZVNJDExY4tISYfYrVjbJjSsUMQyZyGh6VJFdqiTizhwsvy9NX+2rZzKTvn1840=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=JLaj8Svb; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=GqRXQM7a; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="JLaj8Svb";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="GqRXQM7a"
Date: Mon, 18 Aug 2025 11:11:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755508294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kAmqsEjsQLHYInjhnfoG2Vo6BPf63dCTM6lKiQLf8us=;
	b=JLaj8SvbyEOjebRoQ+hKZUIrNsPEH2CVnFkI4X2o+M84n+hAXveFnojTCORN9foR/v0ckP
	qoYEIQziZZXgIRiYJEMaEx+3t0BOnffmo0w6/Flj03E35cogcEp87zX/Is3q6ghEcBnpPC
	YiyZOZTXofaA2Qq48VGPOOzRQovnLpzMv/aF3uzvs77Rr/bbqxYqbIzbf0PfiJvS8fXOrA
	ffDjvq6zUBOBf+j/+H8KTuNku7OJ+5V7qw1dDgug/Am/P5DgKpkMhg9RunyrxhWgPjZJyv
	pkKx2g/rY0xUOeOVHvpYe5K9aW2vK57jRdiWthbm5CbmAQBF1qBlx09Pwl+sPw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755508294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kAmqsEjsQLHYInjhnfoG2Vo6BPf63dCTM6lKiQLf8us=;
	b=GqRXQM7aaKIB9fevVk+InbsS5UyWyxP5WejfV/I/bupgRly6vtYzrEcTD0ZvSkhQV4kZR1
	IxVCCgN218uf5ECA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nft_set_pipapo: Use nested-BH
 locking for nft_pipapo_scratch
Message-ID: <20250818091133.YJHx2Qmu@linutronix.de>
References: <20250815160937.1192748-1-bigeasy@linutronix.de>
 <20250815160937.1192748-4-bigeasy@linutronix.de>
 <aKCU6GGY05WO3p_7@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aKCU6GGY05WO3p_7@strlen.de>

On 2025-08-16 16:25:44 [+0200], Florian Westphal wrote:
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > @@ -1170,20 +1170,18 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
> >  	}
> >  
> >  	m = rcu_dereference(priv->match);
> > -
> > +	scratch = *raw_cpu_ptr(m->scratch);
> > +	if (unlikely(!scratch)) {
> > +		local_bh_enable();
> > +		return false;
> 
> The function has been changed upstream to return a pointer.

Sorry. Missed that and gcc didn't do much of complaining.

> > +	}
> > +	__local_lock_nested_bh(&scratch->bh_lock);
> >  	/* Note that we don't need a valid MXCSR state for any of the
> >  	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
> >  	 * instruction.
> >  	 */
> >  	kernel_fpu_begin_mask(0);
> 
> Not sure this is correct.  If RT allows to migrate in BH before
> the local lock is taken, then the if (unlikely(!irq_fpu_usable()))
> check needs to be done after the local lock was taken, no?

Looking at this again, that irq_fpu_usable() itself looks slightly
placed at the wrong spot. It should be
|	if (!irq_fpu_usable())
|		return fallback_variant(); 
|	local_bh_disable();

The reason is that if you expect calls from hardirq context then you
shouldn't disable BH. Lockdep enabled kernels should complain in this
case. But then this is networking and I would expect everything here
should be injected via NAPI/ softirq (either via driver's NAPI or
backlog's).

But back to your question: This is usually called from softirq so the
thread can't migrate to another CPU. If this would have been called from
process context then it could migrate to another CPU. However everything
that would block the FPU needs to disable BH (preemption on RT) so that
a tasks does not migrate there while the FPU is blocked.

> I will place a pending pipapo change in the nf-next:testing
> branch shortly in case you need to resend.
> 
> If its fine as-is, I can also rebase the pending pipapo_avx2 patches.
> 
> Let me know.

I've just started rebasing this patch on top of the testing branch. I
see that you moved that code a bit around. I can't acquire the
local_lock_t within kernel_fpu_begin(). I would need to move this back
to pipapo_get_avx2().

Sebastian
