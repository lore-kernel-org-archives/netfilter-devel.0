Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEAD225404
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2025 15:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739807824; cv=none; b=nMDwbLoGFfPrzMBIvnYvOq6Z7lfXNDqlEc55f5kMVToVvjbeVDBf+cyWvu4ytFXMj9KjDVzxTueSVtTmdm0gPsoadb1mI/9CpzUY9t8Z0a/LTj98E6kWAWwe+GI48NLdQxz2Nv8Pb8zytRo/yOwit27a9QbHtWWNl6Sy/zwHd/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739807824; c=relaxed/simple;
	bh=D7T2GXcZW7LJhTvlGYnQz2Gc7XXUUBsjNubYlMcKSp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNdEtLm5C2pPLkMhh5BxgE04rC2uFj+SAZN5XEaGEhLgFT5znnfSsqcnOn5asPVAgfVQc1eZ6I9cGpGxERYzB+OHK6dORFNvV8/DwlyxqDDPAx57z/ngDg7nO+PbO/72nFrIl4xT2Aztc2jRaSpbq2t09UGIgMPCGibyMPQTCks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=LEufmaUs; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=rG05p3Gq; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="LEufmaUs";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="rG05p3Gq"
Date: Mon, 17 Feb 2025 16:56:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1739807821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lTG6U2DpHl/DWf2UTTlHd6gwb2+C0XIRkfe7jGgxNIA=;
	b=LEufmaUsomLgu/jCCBBPEQfDEry2kVVgB8IgcrcRddL2bRgp/PMKnG01lsuzK8bVRG5a3e
	9fa3xExgcDKQGLq57/Z2ynedekJOlskAOCLmLwUauTt3Um5tdl8kDRk63EYYYs9dbSTs3m
	xjr0uLFcP7H3XEDsi+wLmFHRvoXzLLZ+5fhuKu1VVsVBBxdrbw/rUkhSIRdbZWQNV7LvFm
	HCAEmOUzBt/PLS2foTD/a3vAqu30Wuvi1PAK2AwuUxbXlGtTrsS/oX+MEhXLJazP15NNnh
	d0KZHQniOBDNPiKHRvhfGefK6OD/cluVMvc4cHd8siIX/RTIYZ0OYNpKwrb7dQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1739807821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lTG6U2DpHl/DWf2UTTlHd6gwb2+C0XIRkfe7jGgxNIA=;
	b=rG05p3GqQbHsQvyt8QChXeD3EEUQJQxwN1zWWWtjQ7i8Pldyn12PD9NXTf4arYzUzOzR+L
	1GlKy+zxzO/AMmDw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/3] netfilter: Make xt_table::private RCU
 protected.
Message-ID: <20250217155659.jHVTdebO@linutronix.de>
References: <20250216125135.3037967-1-bigeasy@linutronix.de>
 <20250216125135.3037967-2-bigeasy@linutronix.de>
 <20250217140538.GA16351@breakpoint.cc>
 <20250217145754.KVUio79e@linutronix.de>
 <20250217153548.GB16351@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250217153548.GB16351@breakpoint.cc>

On 2025-02-17 16:35:48 [+0100], Florian Westphal wrote:
> 
> > What are the counters used in userland for? I've seen that they are
> > copied but did not understood why.
> >   iptables-legacy -A INPUT -j ACCEPT
> > ends up in xt_replace_table() but iptables-nft doesn't. Different
> > interface, better design? Or I just used legacy and now it is considered
> > as the only?
> 
> iptables-nft uses the nftables netlink API, I don't think it suffers
> from the preempt_rt issues you're resolving in the setsockopt api.

The thing is it there so I would like to see fixed one way or another.
But if this is the old API, it means the counter change in #3 is not
beneficial to iptables-nft.

> It won't go anywhere near xt_replace_table and it doesn't use the
> xtables binary format on the user/kernel api side.
> 
> > I see two invocations on iptables-legacy-restore.
> > 
> > But the question remains: Why copy counters after replacing the rule
> > set?
> 
> Good question.  What I can gather from
> https://git.netfilter.org/iptables/tree/libiptc/libiptc.c#n2597
> 
> After replace we get copy of the old counters, depending on mode
> we can force-update counters post-replace in kernel, via
> 
> 	ret = setsockopt(handle->sockfd, TC_IPPROTO, SO_SET_ADD_COUNTERS,
> 			 newcounters, counterlen);
> 
> I suspect this is whats used by 'iptables -L -v -Z INPUT'.
> But I don't know if anyone uses this in practice.

Oh. Wonderful. So even if skip counter updates after pointer
replacement, the damage is very limited.

> Maybe Pablo remembers the details, this is ancient code by kernel
> standards.
> 
> I think we might get away with losing counters on the update
> side, i.e. rcu_update_pointer() so new CPUs won't find the old
> binary blob, copy the counters, then defer destruction via rcu_work
> or similar and accept that the counters might have marginally
> changed after the copy to userland and before last cpu left its
> rcu critical section.

I could do that if we want to accelerate it. That is if we don't have
the muscle to point people to iptables-nft or iptables-legacy-restore.

Speaking of: Are there plans to remove the legacy interface? This could
be used as meet the users ;) But seriously, the nft part is around for
quite some time and there is not downside to it.

Sebastian
