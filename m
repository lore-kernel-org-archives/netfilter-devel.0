Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAE83A3817;
	Tue,  7 Apr 2026 09:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775556001; cv=none; b=VM2D2RLtVUp14l2WT+u1zCNEC1zpp4OK4Zin0Wd/JR8fpVZOV/N+9fvYyQ+81kOhkJ/6ZS7CqW9O94CEhOKK7CTuWSFHxczd65nWpjQiwffrE/SRvIlrVTsnN1xyYOCFEQ1b61SBXPxAlWywTqodJNgkmm1teaSntroJCP2SaTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775556001; c=relaxed/simple;
	bh=3NdvxjEP2tw3cILkE1W+iAvam5QB+6V4vghaDnuuv9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCQyB5uhWY2ghi/Y4KL2YCZgbycZ7Eh348XEPsO+xTzymfp6WdClr5IWYud3mr8H5dEvMgBsu+/TI1LbY9ZjxL3f9s7Zk76xA7uRfPew10aX4S9uqK4jzRmvno9vLvvtZNyN2Z8OVCHN3goopea+yOVk8BtdZsGSEwb5cgTajUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wZeNWmtu; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wZeNWmtu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SBqiX9dwutRSoxZynSS6034CtvIP8my3GlNM6Fn1uOE=; b=wZeNWmtuROtU65+wwVqZ0FC6Lu
	a63CxLEutuH+xWOBzloX+ZCcawzFnqMVTUVMkCrr8pp0FuRMmXJtUVuUmc+yIVOajP1H4NNDkZ9Lq
	XlHrUlLAXfRJ8kQzA5hN0u3DEuT72627noPDJXvEl2qx4X/vOpBp8L6ROxsWloRXUA8VeiipIrtSg
	2WrkgaEI45oHXO4Zb/pwfMwpUMpjrOhBwCKIiC3Wxs+rMHPxEIN3oafgKIEGAm2AiCTF5Tke2P3+1
	lfaQaJdlQvkqUoSZnG0qjOuBMFZ/F6lms48dJ812zMLZWKh10z6E4jwLuStQX+kSHxT6iVPYFpH9T
	My5B0nKg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA3Dv-00000003OmK-3mKc;
	Tue, 07 Apr 2026 09:59:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 786C830035C; Tue, 07 Apr 2026 11:59:55 +0200 (CEST)
Date: Tue, 7 Apr 2026 11:59:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Calvin Owens <calvin@wbinvd.org>, Ingo Molnar <mingo@kernel.org>,
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 03/12] hrtimer: Use hrtimer_start_expires_user() for
 hrtimer sleepers
Message-ID: <20260407095955.GO2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.696142908@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407083247.696142908@kernel.org>

On Tue, Apr 07, 2026 at 10:54:27AM +0200, Thomas Gleixner wrote:
> Most hrtimer sleepers are user controlled and user space can hand arbitrary
> expiry values in as long as they are valid timespecs. If the expiry value
> is in the past then this requires a full loop through reprogramming the
> clock event device, taking the hrtimer interrupt, waking the task and
> reprogram again.
> 
> Use hrtimer_start_expires_user() which avoids the full round trip by
> checking the timer for expiry on enqueue.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
> Cc: Frederic Weisbecker <frederic@kernel.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> ---
>  kernel/time/hrtimer.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/kernel/time/hrtimer.c
> +++ b/kernel/time/hrtimer.c
> @@ -2152,7 +2152,11 @@ void hrtimer_sleeper_start_expires(struc
>  	if (IS_ENABLED(CONFIG_PREEMPT_RT) && sl->timer.is_hard)
>  		mode |= HRTIMER_MODE_HARD;
>  
> -	hrtimer_start_expires(&sl->timer, mode);
> +	/* If already expired, clear the task pointer and set current state to running */
> +	if (!hrtimer_start_expires_user(&sl->timer, mode)) {
> +		sl->task = NULL;
> +		__set_current_state(TASK_RUNNING);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(hrtimer_sleeper_start_expires);
>  
> 
