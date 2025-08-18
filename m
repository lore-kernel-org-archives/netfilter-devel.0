Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91DC30FF29
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2025 09:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755511001; cv=none; b=marDKv6vRy5Hyg/YkDcOeTy+sEtTBg3gp0xs9Yh1rmVDt40LET/0gyX/EACQQQrF/OoO9UQFmJItrfQpJTtMzpXgnnSk8K0JhtfQ/EImY55suEtNAELFvoO8BUyOV4fKL42YTn9ujZ/a2PfV+XEqZSMoxUL0Mptbq102rp/iEzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755511001; c=relaxed/simple;
	bh=ZVu1qw2pV2wps2RhxIY/YdPeCI9STKQa2mfFtIuez78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W8Q7Ey6D4Tzw/dklqUHjvxa8MPxy3J50iwPJyB1ocNNUX0cado40g6jkFh3bd3+fkHDKFeqOme6R8ivKKKVt30NG2KTTf0OaLfDV1uPeVsHip6cpbdaBcxSsn/bamMXzzRa+hqOZj2i5GHPzjOt18RgdfK/af7nZJStoeFm2viA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=CfWHMbUt; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=AX7/FuEu; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="CfWHMbUt";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="AX7/FuEu"
Date: Mon, 18 Aug 2025 11:56:36 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755510997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/JzTu5/LuzCXb9lqpgwNirvubykzb98WyaNwunKK+Wg=;
	b=CfWHMbUtZNQQ6+QNdwgDRjDdJJMQHlYhdvOLKSB1UJKou2JvgYaiEiL901z/WFRkt7Wgxo
	zdMjNepeSvvWTthiSTXvIEExVqKK1Evb7O+GFRKi7IStjgSjbVIpgiwofVyBb+hLXebfT/
	Q+nmStMwgfVL+et3bnHEGrvZr8xXav+MLy7HrYrEsJgb02MgKFu4+4LOueaBd8gPkdpfwM
	drYv7RDqRnGc67WB6pvqRxZu7+kpPzhIhMe5lXMphhytNgJ+CmiIm7TzEk54LkOshcbTia
	DcXPlT087n26Na3YtkxSly9vLogq6/U7TWBonM62QAPr9y1vVMXAsatZoBPdsg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755510997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/JzTu5/LuzCXb9lqpgwNirvubykzb98WyaNwunKK+Wg=;
	b=AX7/FuEuZivRJ4nBLVYPAMo7fgjKxQjhc+1HshYpWzpTmE/igG+I/gMzlwA8yqK8BgS2Zs
	kVbsOrwQNPvM3QAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nft_set_pipapo: Use nested-BH
 locking for nft_pipapo_scratch
Message-ID: <20250818095636.ImJ2E3_f@linutronix.de>
References: <20250815160937.1192748-1-bigeasy@linutronix.de>
 <20250815160937.1192748-4-bigeasy@linutronix.de>
 <aKCU6GGY05WO3p_7@strlen.de>
 <20250818091133.YJHx2Qmu@linutronix.de>
 <aKLxN7j8BTTxja8B@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aKLxN7j8BTTxja8B@strlen.de>

On 2025-08-18 11:24:07 [+0200], Florian Westphal wrote:
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > > Not sure this is correct.  If RT allows to migrate in BH before
> > > the local lock is taken, then the if (unlikely(!irq_fpu_usable()))
> > > check needs to be done after the local lock was taken, no?
> > 
> > Looking at this again, that irq_fpu_usable() itself looks slightly
> > placed at the wrong spot. It should be
> > |	if (!irq_fpu_usable())
> > |		return fallback_variant(); 
> > |	local_bh_disable();
> > 
> > The reason is that if you expect calls from hardirq context then you
> > shouldn't disable BH. Lockdep enabled kernels should complain in this
> > case. But then this is networking and I would expect everything here
> > should be injected via NAPI/ softirq (either via driver's NAPI or
> > backlog's).
> 
> This is never called from hardirq context, its always process context
> or softirq.  Are you saying that the irq_fpu_usable() is bogus
> and can be axed?

Process context could use the FPU (say btrfs for crc32 checking) and
then in softirq you would have to check if you are allowed to used them.
This was the original requirement for softirq usage.

x86 does disable BH in kernel_fpu_begin() before the FPU can be used.
This "new" development required while the check was added. The
fpu-begin() change has been added around v5.2-rc1 while the FPU
registers are restored on return to user land (in order to make kernel
fpu begin/ end cheaper). 

Since this is x86 only you could drop it without breaking anything as of
today. I don't think this will change but I also don't feel like I
should advice dropping it. This does not look performance critical and
all users call it first.

> > I've just started rebasing this patch on top of the testing branch. I
> > see that you moved that code a bit around. I can't acquire the
> > local_lock_t within kernel_fpu_begin(). I would need to move this back
> > to pipapo_get_avx2().
> 
> Sure, I don't see why it can't be moved back to pipapo_get_avx2().
> 
> You can also just resubmit vs. nf-next main and I can rebase my
> patches on top of the local_lock changes, up to you.

I'm half way done ;)

Sebastian
