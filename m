Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B25D39B96A;
	Tue,  7 Apr 2026 10:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775556565; cv=none; b=VA19Swjx87M/d1xzBwhMatQ5simE10bXp4NrS2A5ueTEX/n/TKfW4xb2joHdK7jdvmrOKXrRcG1RePg++wNWp4gKgCOS4V1aPS3qaLrdv5YrOviXYP45zidSt0Px59o+77azAlSCZFcqv0nmQsYl0LWfomopAJH3h8WQN3AX7dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775556565; c=relaxed/simple;
	bh=cQloyn2Ud+z/jB9mfpqEggLuossDg+Q8/XeUvB75ZcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnFGu+wotkNg2Anp4M/WwoHSXawBC1g6GIh9GNoRF70pOd9RG6jwyg6BWN31Fmz22kxSSSPYCrejYgnjVTWdQwA8oHyoAXWgtMsNP40MOQmM0lvNVGloyjRlOvt3milYMidBxz2P1LLHjT56UgVpJ3LlE4OlBxOCvCIhOxzXyNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dG7LFnnD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dG7LFnnD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y+pchSuJjEJZKfsWlXfM5v2Cr04XgbOInZ4IMbge9O4=; b=dG7LFnnDS5cqPFNugwTGaC7nJg
	b3ANd1WEscfLfkBbBg652O5a2BbKjODvLxHBjqEf/IQ2r1gqwBUDLny8ehDpN2pIFPem5aAg8wC0i
	dSNOi5/Pt+J7UJtlXGGMWMbNY3AELZmOdmUpD4dPJjqkq4f6TYuvM1OpJ44z4PXYJ9u6JSzdBtFHz
	bIRWne6gADgw3cbL4DiykUjfcWt4SkQkIC49Sv8DKdlJ/90xjMGuhcJiPLQc0ftfQCWUveQe+3LXR
	slP3zQDj+yNxg7dxEZCWwbaNkplT67zcgTc15wPLubU4dkder6hGn1tFXXrub8rw9nfpbur2j9z8C
	g+GDs8Ug==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA3N3-00000003PTk-01PM;
	Tue, 07 Apr 2026 10:09:21 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 662803005E5; Tue, 07 Apr 2026 12:09:20 +0200 (CEST)
Date: Tue, 7 Apr 2026 12:09:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-fsdevel@vger.kernel.org, Calvin Owens <calvin@wbinvd.org>,
	Ingo Molnar <mingo@kernel.org>, John Stultz <jstultz@google.com>,
	Stephen Boyd <sboyd@kernel.org>, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 09/12] fs/timerfd: Use the new alarm/hrtimer functions
Message-ID: <20260407100920.GT2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083248.102440187@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407083248.102440187@kernel.org>

On Tue, Apr 07, 2026 at 10:54:58AM +0200, Thomas Gleixner wrote:

> +static u64 timerfd_alarm_restart(struct timerfd_ctx *ctx)
> +{
> +	u64 ticks = alarm_forward_now(&ctx->t.alarm, ctx->tintv) - 1;

(still confused on the alarm_forward_now() vs alarmtimer_start()
namespacing)

> +
> +	timerfd_alarm_start(ctx, alarm_get_expires(&ctx->t.alarm), false);
> +	return ticks;
> +}
> +
> +static void timerfd_hrtimer_start(struct timerfd_ctx *ctx, ktime_t exp,
> +				  const enum hrtimer_mode mode)
> +{
> +	/* Start the timer. If it's expired already, handle the callback. */
> +	if (!hrtimer_start_range_ns_user(&ctx->t.tmr, exp, 0, mode))
> +		__timerfd_triggered(ctx);
> +}
> +
> +static u64 timerfd_hrtimer_restart(struct timerfd_ctx *ctx)
> +{
> +	u64 ticks = hrtimer_forward_now(&ctx->t.tmr, ctx->tintv) - 1;
> +
> +	timerfd_hrtimer_start(ctx, hrtimer_get_expires(&ctx->t.tmr), HRTIMER_MODE_ABS);
> +	return ticks;
> +}

> -		if (ctx->expired && ctx->tintv) {
> -			/*
> -			 * If tintv != 0, this is a periodic timer that
> -			 * needs to be re-armed. We avoid doing it in the timer
> -			 * callback to avoid DoS attacks specifying a very
> -			 * short timer period.
> -			 */
> -			if (isalarm(ctx)) {
> -				ticks += alarm_forward_now(
> -					&ctx->t.alarm, ctx->tintv) - 1;
> -				alarm_restart(&ctx->t.alarm);
> -			} else {
> -				ticks += hrtimer_forward_now(&ctx->t.tmr,
> -							     ctx->tintv) - 1;
> -				hrtimer_restart(&ctx->t.tmr);
> -			}
> -		}
> +		ticks = ctx->ticks;
>  		ctx->expired = 0;
>  		ctx->ticks = 0;
> +
> +		/*
> +		 * If tintv != 0, this is a periodic timer that needs to be
> +		 * re-armed. We avoid doing it in the timer callback to avoid
> +		 * DoS attacks specifying a very short timer period.
> +		 */
> +		if (expired && ctx->tintv)
> +			ticks += timerfd_restart(ctx);
>  	}
>  	spin_unlock_irq(&ctx->wqh.lock);
>  	if (ticks) {
> @@ -526,18 +554,7 @@ static int do_timerfd_gettime(int ufd, s
>  	spin_lock_irq(&ctx->wqh.lock);
>  	if (ctx->expired && ctx->tintv) {
>  		ctx->expired = 0;
> -
> -		if (isalarm(ctx)) {
> -			ctx->ticks +=
> -				alarm_forward_now(
> -					&ctx->t.alarm, ctx->tintv) - 1;
> -			alarm_restart(&ctx->t.alarm);
> -		} else {
> -			ctx->ticks +=
> -				hrtimer_forward_now(&ctx->t.tmr, ctx->tintv)
> -				- 1;

(argh!)

> -			hrtimer_restart(&ctx->t.tmr);
> -		}
> +		ctx->ticks += timerfd_restart(ctx);
>  	}
>  	t->it_value = ktime_to_timespec64(timerfd_get_remaining(ctx));
>  	t->it_interval = ktime_to_timespec64(ctx->tintv);

What's with the -1 thing?

Anyway, this looks about right.
