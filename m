Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5101221D92
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 16:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741366665; cv=none; b=j/mWd9M1VYrdyYK9PIMOhGB5/lE2dHEpIV5GJAcsAIeuNgkAbR2H3DR20okC1A+I/9FqB+DMDirH5LvNqxJJsgR523zXNgieORuN+wCCA5zansJ+tMmNmqMjsTpXnfwFzvzQblZjGaxgnkXXergS5YUcThIaSs33B9tML2Kp0E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741366665; c=relaxed/simple;
	bh=IQ6HQwZ7TCeX/NPxmjiqm7WPTN6mOoKtVm8u8rj3cCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ptkBduNVJWr8ZZemOlHdLHneYadpNT6vXB8CGEp2VPzGMBnheGWtt2r8dA0rPzucgg88AJvmZoTJxs6DWjpLzjfBtzgQDR6xoaVT2G+TvP1QPQ7eMfxV0D5p40KJtzPO6AG+hRElMrwtn19tQ15EuIxbjNMjq1Drkz637Lp93/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=BK4YUcuv; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=b8pvlwcc; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="BK4YUcuv";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="b8pvlwcc"
Date: Fri, 7 Mar 2025 17:57:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1741366662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=erRaoD3AeHBHeKwFmtfL2aXp8syX8RuaSemTxmr2Lq0=;
	b=BK4YUcuvLU3wPUEQydAKfyOiUPoJkCzi9pl8NlAQZLqjVUQmG/pgzUM4PT/gNEoec3Yx/C
	Ezwi2gS0NMmJSIHbWLUPwRg7xVvW9mKFuRAW5daQhjRGmPvuT6ZwD6LFbaq/XyafEMZH3r
	rNNgqg33oRFxCpI+oxhRJmsAT89ftjQwxD4sjDsf34IUqORyC3DaxDIIydKbJCdeO4ToWS
	blc/idfvgVjJVoyK+GRDvdFE/Kl18G9uDVe2c3i4POcIq5xgcukkAqfay3zuYnHoB/9let
	x2/yc05aNI3TJ5lU+TnJA1UmX9YxCOtpFXf+uQbpXjvZn0kJULikQ+CYdQM0kg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1741366662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=erRaoD3AeHBHeKwFmtfL2aXp8syX8RuaSemTxmr2Lq0=;
	b=b8pvlwccZnrc3zwZKKeeez2ETtmPMRToVZGNY+Y7qHg1e5j2OKDedrYxzvSb3DEPX/cWEZ
	D/wO309axdy35wDQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 0/3] Replace xt_recseq with u64_stats.
Message-ID: <20250307165740.5rhR7Deu@linutronix.de>
References: <20250221133143.5058-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250221133143.5058-1-bigeasy@linutronix.de>

On 2025-02-21 14:31:40 [+0100], To netfilter-devel@vger.kernel.org wrote:
> The per-CPU xt_recseq is a custom netfilter seqcount. It provides
> synchronisation for the replacement of the xt_table::private pointer and
> ensures that the two counter in xt_counters are properly observed during
> an update on 32bit architectures. xt_recseq also supports recursion.
> 
> This construct is less than optimal on PREMPT_RT because the lack of an
> associated lock (with the seqcount) can lead to a deadlock if a high
> priority reader interrupts a writter. Also xt_recseq relies on locking
> with BH-disable which becomes problematic if the lock, currently part of
> local_bh_disable() on PREEMPT_RT, gets removed.
> 
> This can be optimized unrelated to PREEMPT_RT:
> - Use RCU for synchronisation. This means ipt_do_table() (and the two
>   other) access xt_table::private within a RCU section.
>   xt_replace_table() replaces the pointer with rcu_assign_pointer() and
>   uses synchronize_rcu() to wait until each reader left RCU section.
> 
> - Use u64_stats_t for the statistics. The advantage here is that
>   u64_stats_sync which is use a seqcount is optimized away on 64bit
>   architectures. The increment becomes just an add, the read just a read
>   of the variable without a loop. On 32bit architectures the seqcount
>   remains but the scope is smaller.
> 
> The struct xt_counters is defined in a user exported header (uapi). So
> in patch #2 I tried to split the regular u64 access and the "internal   
> access" which treats the struct either as two counter or a per-CPU
> pointer. In order not to expose u64_stats_t to userland I added a "pad"
> which is cast to the internal type. I hoped that this makes it obvious
> that a function like xt_get_this_cpu_counter() expects the possible
> per-CPU type but mark_source_chains() or get_counters() expect the u64
> type without pointers.

A gentle ping in case this got forgotten.

Sebastian
