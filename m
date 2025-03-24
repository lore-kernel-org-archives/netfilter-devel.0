Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139352AE72
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Mar 2025 16:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742833768; cv=none; b=WL0BBE/XkiBWq/vkojJbUTcKM9dvlJygq9iyYDlncFPgi8EGC8JWh4pHoII5hxrqvShA73+P/SMFHdm74UE8YWoTMAI2gqDvDhY9w6VyE1E2csILP5UUDazsSiQl4WR2Cv0IKlLK5sg2iX3f7h7K73tgOuqpMjqkW4OQwVy/VFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742833768; c=relaxed/simple;
	bh=9F8Ou1QYFH9FV9yiPRjTETE2yBYk9CRihlxlcXALa5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/BHbMICP+Ufv+4D56biHoKY8CHFgJq0dnTAO83NLC7Gwi/p45WOAZ+VsJ7VtLB82a1mKo1PkF/th2O/ePc7Z1EU0MzGTV5+X5NajpXNaDrnVETSpIMyJEIcXAVLIN369lrhu73/XImdnQIpzGUPSDiBgYu0mDDmy4V7ZDQRbhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=3KReyxde; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=TLbru1jr; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="3KReyxde";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="TLbru1jr"
Date: Mon, 24 Mar 2025 17:29:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742833765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YW5yd7rKHOHutHs/5mNSnirmVmr+zWBSC0Na7fYCrI8=;
	b=3KReyxdec+bVpQ7nRoBZgarw3MIhgTOoiutmInvDATlVqEypRUAvVvFcXR/c+02Y8Q8rPc
	lVEyz6PcNDJIhHi+cKFtgjJGZZh8VmxtBo6V01+2YHVPcr85Meo0SBP3VChuHu0O5bgr8o
	y59Zo1ECrsARm6ZXzWEPWDWMpaQzybwaVVTSah2Jy4vBgoxmf43Pu6uR0I+bjq7oJLBZTt
	t4Y1Wal4ypOW1uH6rrMWiczC6IYGiQMbeN+Vyqcdhk02LB3Tb8xZbbiOO7+lF9EggbRp3o
	CAX1jzhqwLxB6NjxNCZA0s5dFdBt5bKRacK1JH2GMtdVMB83cQY/gctfnl6VCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742833765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YW5yd7rKHOHutHs/5mNSnirmVmr+zWBSC0Na7fYCrI8=;
	b=TLbru1jrkH26BWgdFfd3Z5sGDneLZ9E/L/4JCxN+Mi8vOFg0O0hmt1OkVSfuX9gVa8C4li
	RLqEILuCgBy7tICg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v2 0/3] Replace xt_recseq with u64_stats.
Message-ID: <20250324162923.O308UeBw@linutronix.de>
References: <20250221133143.5058-1-bigeasy@linutronix.de>
 <Z9IVs3LD3A1HPSS0@calendula>
 <20250313083440.yn5kdvv5@linutronix.de>
 <Z9wM9mqJIkHwyU1J@calendula>
 <Z90-Q3zyEHDWPBNr@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z90-Q3zyEHDWPBNr@calendula>

On 2025-03-21 11:24:03 [+0100], Pablo Neira Ayuso wrote:
> Hi Sebastian,
Hi Pablo,

> I have been discussing this with Florian, our proposal:
> 
> 1. Make ipatbles legacy depend on !PREEMPT_RT which effectively
>    disabled iptables classic for RT.
> 
> This should be ok, iptables-nft should work for RT.
> 
> 2. make iptables-legacy user-selectable.
> 
> these two are relatively simple.

Okay. Let me try that.

> If this does not make you happy, it should be possible to take your
> patches plus hide synchronize_rcu() latency behind deferred free
> (call_rcu+workqueue).

I will try the suggested above and then will see who complains. But I
think it should be doable to roll with nft only for future releases.

> Thanks.

Sebastian
