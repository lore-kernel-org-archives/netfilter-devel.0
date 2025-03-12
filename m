Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0976B1F0E38
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 23:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821371; cv=none; b=BiTXmYwX3gd/MGuBdCNHfdsZBLUStu9+vQ9e2btLQg8zHSVmPGTu+/iay043hC8O5MS6njP+aAaO098HIq9wksGAMntO55lkeXe+onGGOg0Qqd9HnDzoMZlKyUvNpIErZnOCowV9ivs7l07sFN2QIh18VXjn7vnnAYd/jsBW188=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821371; c=relaxed/simple;
	bh=NOX5x6c/mn2a7cwLTb2x2tVoHK/wEQFsDF6kbDxq538=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGLc7F/Bj+aaW8s5P4p8FHsXvHBud8JnHKhJKg0tw2ngOsyJEUAkMAlqYib3sC+O35sClUnfmpdJ5lcQRXLEm/lHnSNePj5ULv1f7BvXPmHNEgbfpn/rY0CQ63Ifwf5T43/V4gyLrdYDKg/y2aR7WxEXrJNMFSvGnnCzdnRAoBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vnxJPBNu; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TMVB+0zZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vnxJPBNu";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TMVB+0zZ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 71137602C0; Thu, 13 Mar 2025 00:16:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821368;
	bh=ZHjXQGDQch7XovF23NV53q14IqlwxqvRf5k/PaU0B78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vnxJPBNuWYKGvzabpaRjTx2MMJbug/a0+IkpHxJCc3WCj8XzQfaS6JOyKeLCp5x/v
	 bbMRiT0X4UE0VHObzrMJXFWg3BN6lJOU0PplIRzUWt3c9gz4lEeeWpT2J41TKqD4VN
	 jYRZP3ipP+zA4OHOadEUx2dSR9UxPIBTlekJ0aJHJT7dqDdxrYbR6TpBsLK65YJDVM
	 FhZBAZaj6BomMmqJPA/3HU9hEAVvcoaL07rnhnhLQlVfioO+MI5acY4asWMmvfvMYl
	 XL26XCkk2VUA5G6r7xDn3w1p149ASbdCrVQTRC38uyeR6PSLctoYzrFT4zq2xt7ebi
	 u4U0oU1X9ka5Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B075D602B2;
	Thu, 13 Mar 2025 00:16:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821366;
	bh=ZHjXQGDQch7XovF23NV53q14IqlwxqvRf5k/PaU0B78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TMVB+0zZOwXhOC4ifQwh8esmqV9t8bLsPGBFY8ngF7fDWgU8yP8v6m1t/31P1A/CV
	 2mP/cW1ZnRzhwFbW+00UEK5mZ5K/vB+fqeAkfLeE6/IIioqqjkPvXg6gey/01dCI6g
	 woPrqU5rR5fs/3SoDFgzbnlAbe4O1C+qq4gyFvlIKwbHxzbe1cYHFzbX6HUqR7nUDS
	 lPnjBJS2GECNTCj5ubNr0Fux8NfOmXrwZgFuykoBTfbbwkmuXfJriP9mSwku+izXJz
	 1Trh4UTzqnElYUI8qH5deCtOlrV/IAy09jtBTqRdnBu5E9XdZroYaP3TkrKMOnoBLS
	 Ioe3jNULcMZqA==
Date: Thu, 13 Mar 2025 00:16:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 0/3] Replace xt_recseq with u64_stats.
Message-ID: <Z9IVs3LD3A1HPSS0@calendula>
References: <20250221133143.5058-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250221133143.5058-1-bigeasy@linutronix.de>

Hi Sebastian,

On Fri, Feb 21, 2025 at 02:31:40PM +0100, Sebastian Andrzej Siewior wrote:
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
> 
> v1…v2 https://lore.kernel.org/all/20250216125135.3037967-1-bigeasy@linutronix.de/
>   - Updated kerneldoc in 2/3 so that the renamed parameter is part of
>     it.
>   - Updated description 1/3 in case there are complains regarding the
>     synchronize_rcu(). The suggested course of action is to motivate
>     people to move away from "legacy" towards "nft" tooling. Last resort
>     is not to wait for the in-flight counter and just copy what is
>     there.

Kconfig !PREEMPT_RT for this is not an option, right?

Thanks.
