Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A0F19FA9F
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2024 15:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723562895; cv=none; b=OyacW26WucIuQh55b2jCUDh6St1EZpOdBmCyW3Q16u1VDdM00FCmuuU+frr03K1CpdPKiLQTaYrp+by2XFpQy16u/HDMcQiOEPIK6zxqaY0JV9f9sGa2DeAWmXskKQPyiMfoMkRAMaRdDBdEVTepMDBowhreplObdzk9vj7G1eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723562895; c=relaxed/simple;
	bh=C49rAeDdVufTtwKZp4VaLnzK/JeZ8KzEjmezXCGMcPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hecWsV/w/MwNu6q1+zKwRIjICfJfUS7pYo50U/dpjf/4xiIZ9ZvVWw1L48ijpjZ2nne1mFDZPCXXtlsK02Pjn4TNpmV7Pie48K/j5169pH6RL3OiN+dK+zr42Zi8s1WcIZwDwJjjCNBhg9dAB+R5mSKopwIAK4NJQJ5xZ7b5NJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=vIec755f; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=n1UL+gwj; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="vIec755f";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="n1UL+gwj"
Date: Tue, 13 Aug 2024 17:28:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1723562892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vxny4/21ve5chpTQhV5UYyf1NaStBHZqcTlTXoRoHJI=;
	b=vIec755fVJSayWqfhyol8ry64+c9LPdxOpOJk451SroD7Eo1hm2FpqfUXHgb7joLeqjA6j
	ZGDgA6Ics+481WgkpbwEWIsv24myKwYK4Px7rASPf8tpks/bfukbXxwpNIpGiBzD0X56Ri
	J6Kfw2QzXjE61FyyYeBmJ01bSwwLEhFlvTqbN/aVIkG/oxnv8aVejvvvN9zT1qkMMqzYh0
	0Y2WjtqGSyheke2+Lzvwr/ZrRIVfEHibWFHXyQuwy9Mlws1cg1iMcyednontNUWwzlkh+y
	wO8uOS5ZnKyR2K6XB3Tjm8SWLN6PUjU5URkQbrhqHGU0fQCPPVUuS+nBKary4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1723562892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vxny4/21ve5chpTQhV5UYyf1NaStBHZqcTlTXoRoHJI=;
	b=n1UL+gwjRLvxa9D3kvazleZclDQu7nUzMc6uP7CbCKVzkYynCb1LL+XqePevYov1oioGaO
	krmGjOCFchVeigBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [netfilter-core] [Q] The usage of xt_recseq.
Message-ID: <20240813152810.iBu4Tg20@linutronix.de>
References: <20240813140121.QvV8fMbm@linutronix.de>
 <20240813143719.GA5147@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240813143719.GA5147@breakpoint.cc>

On 2024-08-13 16:37:19 [+0200], Florian Westphal wrote:
> Hi Sebastian!
Hi Florian,

> > While trying to trigger the writer side, I managed only to trigger a
> > single reader and only while using iptables-legacy/ arptables-legacy
> > commands. The nft did not trigger it. So it is legacy code only.
> 
> Yes, this is legacy only.

perfect.

> > Would it work to convert the counters to u64_stats_sync? On 32bit
> > there would be a seqcount_t with preemption disabling during the
> > update which means the xt_write_recseq_begin()/ xt_write_recseq_end()
> > has to be limited the counter update only. On 64bit architectures there
> > would be just the update. This means that number of packets and bytes
> > might be "off" (the one got updated, the other not "yet") but I don't
> > think that this is a problem here.
> 
> Unfortunately its not only about counters; local_bh_disable() is also
> used to prevent messing up the chain jump stack.

Okay. But I could get rid of the counters/ seqcount and worry about the
other things later on?

> For local hooks, this is called from process context, so in order
> to avoid timers kicking in and then re-using the jumpstack, this
> local_bh_disable avoids that.
> 
> The chain stack is percpu in -legacy, and on-stack in nf_tables.
> 
> Then, there is also recursion via xt_TEE.c, hence this strange
>         if (static_key_false(&xt_tee_enabled))
> 
> in ipt_do_table() (We'll switch to a shadow-stack for that case).

Yeah. That is another per-CPU thingy. 
So my plan was to replace the seqcount/ counters with u64_stats_sync,
make this per-CPU nf_skb_duplicated per-TASK and then come back and
check what local_bh_disable() is actually protecting other than skb
alloc/ free during callback invocation (as in TEE).

So jumpstack. This is exclusively used by ipt_do_table(). Not sure how a
timer comes here but I goes any softirq (as in NAPI) would do the job
without actually disabling BH.
Can this be easily transformed to the on-stack thingy that nft is using
or is it completely different? If the latter I would just a add a lock. 
local_lock_nested_bh() would be the easiest to not upset anyone but this
is using hand crafted per-CPU memory instead of alloc_percpu(). Can
stacksize get extremely huge?

In case I made a wrong turn somewhere, do you have better suggestions?

Sebastian
