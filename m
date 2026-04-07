Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96243A6F04;
	Tue,  7 Apr 2026 09:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775555677; cv=none; b=g7lKZcvlFPWvMXT44lfI3TWsNu45mkHTZDOW6cdxUiRcOlg0/XM1f7AlVxOIPMiy6B0eeZtKWtvCGyUFFk7BPBGeXGoz7xpveoX5JDI4igb8oC1VwmOBi7Dwfy0h1E+OacDg66dQ+45AfFXw71KHWoUu6er6QYC4RAgypI3NxX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775555677; c=relaxed/simple;
	bh=F+j+RTQvlDjF+jbp7AYolR+jUFD1B3ykRG4D9L2woSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cAdMFMvDouSdfhk9Aw4JKuU2ggltgMnt+a2L7RVuBQYSwMMgNFlKtBZ2lm8kF+E+nP5vLPI1hx5RnF1LCmJJA896KvwL1fU0sPzfPIW1D611k6gGpkXOwvTTKLlvhyg0qb/r1d0y4HvqNrYM7xkQMdy6EylEmPPZO1yLdOVBzQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YXRcs4S5; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YXRcs4S5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=geJJQ+vfMd190DMB8bun8qM40V3WrYOXoU4roUTlPvQ=; b=YXRcs4S5QH4fP9HdfO1A04LyP7
	2miab2cNdQRnnAXhBfWzvyNhKltIVr8com5j6oUMLuG8tw83AyCZy9CucSmp4i1oKXTjfwp3KUAZn
	x4jAVf0R4CQqrCDVSjPobv1uy2kmjAQDSjOG3AvZs8FTleUySJFgn9/xGbzYoHnYRRLparTwRKgDe
	PWcDAd9zB1PjHBHm2Lqem0boF9JaWJ1kW4VIUw+TJeMfyjjHRJVQVnC9QuTNfp1oOoNeLhbHj6lac
	lpRbZiy99XhuoOWHL4xtRbo+7+fsxPrpibA9VgYr47DC3LkzU7fZ4D1NzwX7LIt1fVq+3q1nUOolX
	ATo2Pm6w==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA38Z-00000007yoW-2229;
	Tue, 07 Apr 2026 09:54:23 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9D2DB30035C; Tue, 07 Apr 2026 11:54:21 +0200 (CEST)
Date: Tue, 7 Apr 2026 11:54:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@kernel.org>, John Stultz <jstultz@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 02/12] hrtimer: Provide hrtimer_start_range_ns_user()
Message-ID: <20260407095421.GM2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.630389532@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407083247.630389532@kernel.org>

On Tue, Apr 07, 2026 at 10:54:22AM +0200, Thomas Gleixner wrote:

> +enum {
> +	HRTIMER_REPROGRAM_NONE,
> +	HRTIMER_REPROGRAM,
> +	HRTIMER_REPROGRAM_FORCE,
> +};

> +static int hrtimer_start_range_ns_common(struct hrtimer *timer, ktime_t tim,
> +					 u64 delta_ns, const enum hrtimer_mode mode,
> +					 struct hrtimer_clock_base *base)

> @@ -1315,25 +1337,110 @@ void hrtimer_start_range_ns(struct hrtim
>  	struct hrtimer_clock_base *base;
>  	unsigned long flags;
>  
> -	/*
> -	 * Check whether the HRTIMER_MODE_SOFT bit and hrtimer.is_soft
> -	 * match on CONFIG_PREEMPT_RT = n. With PREEMPT_RT check the hard
> -	 * expiry mode because unmarked timers are moved to softirq expiry.
> -	 */
> -	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> -		WARN_ON_ONCE(!(mode & HRTIMER_MODE_SOFT) ^ !timer->is_soft);
> -	else
> -		WARN_ON_ONCE(!(mode & HRTIMER_MODE_HARD) ^ !timer->is_hard);
> -
>  	base = lock_hrtimer_base(timer, &flags);
>  
> -	if (__hrtimer_start_range_ns(timer, tim, delta_ns, mode, base))
> +	switch (hrtimer_start_range_ns_common(timer, tim, delta_ns, mode, base)) {
> +	case HRTIMER_REPROGRAM:
>  		hrtimer_reprogram(timer, true);
> +		break;
> +	case HRTIMER_REPROGRAM_FORCE:
> +		hrtimer_force_reprogram(timer->base->cpu_base, 1);
> +		break;
> +	}
>  
>  	unlock_hrtimer_base(timer, &flags);
>  }

Something is going to figure out that hrtimer_start_range_ns_common() is
really returning that enum and then complain you don't handle NONE :-)

Anyway, to me it would make sense to instead pass that value to
hrtimer_reprogram() as the second argument. But this works I suppose.
