Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87962D7D42
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 09:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755509057; cv=none; b=JGQ2lSk+n4Lzz6oxp2u9k4bDBOyQzJgA2xYd0MEfNmO+280zya5xlstOGzs8qc+h7VCNE/sn6KKKaXCF5f/tmwggOhcBh3LwlR5wBrEqcc0Y02rew1Hi3JMnSnSa3FpBOonpvnNkZR3N06htdnKlFvaTE7LsdhoADvw6upL002E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755509057; c=relaxed/simple;
	bh=ptDEYTD2ly4iMgDOJaBwFgyF4jBa9SvCBWo057sBjz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YE1uTyagDNfp6rbFYZkiECKXLG7lAh+zfT5WV8DXNqf98LnepjneYDmjzcf44hQYxTLEAoBkySp7WvfkLhiKqa1XalTklG5+6LHU/dUl102IRJzIwDYXNukZEih0IoMvzCvBdqpfzqwmEjvvL2oYEKZQAjaTHVyZlhxZNsbrOHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4EACA60F64; Mon, 18 Aug 2025 11:24:08 +0200 (CEST)
Date: Mon, 18 Aug 2025 11:24:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nft_set_pipapo: Use nested-BH
 locking for nft_pipapo_scratch
Message-ID: <aKLxN7j8BTTxja8B@strlen.de>
References: <20250815160937.1192748-1-bigeasy@linutronix.de>
 <20250815160937.1192748-4-bigeasy@linutronix.de>
 <aKCU6GGY05WO3p_7@strlen.de>
 <20250818091133.YJHx2Qmu@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818091133.YJHx2Qmu@linutronix.de>

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > Not sure this is correct.  If RT allows to migrate in BH before
> > the local lock is taken, then the if (unlikely(!irq_fpu_usable()))
> > check needs to be done after the local lock was taken, no?
> 
> Looking at this again, that irq_fpu_usable() itself looks slightly
> placed at the wrong spot. It should be
> |	if (!irq_fpu_usable())
> |		return fallback_variant(); 
> |	local_bh_disable();
> 
> The reason is that if you expect calls from hardirq context then you
> shouldn't disable BH. Lockdep enabled kernels should complain in this
> case. But then this is networking and I would expect everything here
> should be injected via NAPI/ softirq (either via driver's NAPI or
> backlog's).

This is never called from hardirq context, its always process context
or softirq.  Are you saying that the irq_fpu_usable() is bogus
and can be axed?

> I've just started rebasing this patch on top of the testing branch. I
> see that you moved that code a bit around. I can't acquire the
> local_lock_t within kernel_fpu_begin(). I would need to move this back
> to pipapo_get_avx2().

Sure, I don't see why it can't be moved back to pipapo_get_avx2().

You can also just resubmit vs. nf-next main and I can rebase my
patches on top of the local_lock changes, up to you.
