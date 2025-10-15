Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95BE3233E4;
	Wed, 15 Oct 2025 11:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760529013; cv=none; b=hfPLHRYGrQwBi+DIGOZcx7BqGE+4tiH8AsKfh7qSTLThHfqLQKaxGhmbp0YmiE1M5oo3elDy/acc/XaE8y3X2uMqHTbcoN7ESti2jvpchLPhXkWm0Nqp4MUSagT+mmJoEQIoY3Txev6/n/KBZcPVl5TBqRwkSh26R7Oci7ja1KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760529013; c=relaxed/simple;
	bh=TSwGRKO19D5XKRsLC+m0YijxQmVTUeTgmcZAf31qOyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KbQ3+3951YwkAf3Zm6YuBqmhNyG3UjAeSB21YB62aZXhUfQDPLGU67bcKq8cOoeF0aCcjRBZodnFK8H/D3KJ1d8emSeaIubUOeAWN9VaUrY2Srksqb0mX6Y+9q+qZiklVYTXzVf3sj+RfGazRINJbqN8aIYLmJlRAn9SKl7WfpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O4w/yyDX; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O4w/yyDX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Mt0I59thcwaJmpT1dL/1ZLqBuvZvsWajANy7tBk0r08=; b=O4w/yyDXqYZN8yjFLH9VkztTFf
	0d3ht1xExsNpZ8qvqxLGUng0i5NMsyG3zkEt1hXZJtL8r7Zre6xgbqs1/JO0VT58YbMoCr3Yqb0Aa
	Yj1UodhDfpH4lLWMLn7nYJ/JrBV9S1mmmwOZAVjF4uyOt0tugV1QSuW6LVcCaIOVVhz13A1AS3iZ+
	ZYBo41lp8Wk9yKb5mnqNDjzYXPCXnD3ofwiYxs9mI4aU/4/mVfwqJms2OS2ww7LTJzFP5DdTEfmhS
	ywD/Ij7GqH5N7J9BQYqt2AoHD8/qxJmxjzIR9g4hyHnSQ7NWee11wqoJayrhPsfIAAJNCdhP1FYWT
	hlTymeUw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v900z-0000000ESV9-0C0C;
	Wed, 15 Oct 2025 11:49:58 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E508330043F; Wed, 15 Oct 2025 13:49:56 +0200 (CEST)
Date: Wed, 15 Oct 2025 13:49:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Florian Westphal <fw@strlen.de>
Cc: "Li,Rongqing" <lirongqing@baidu.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next] netfilter: conntrack: Reduce cond_resched
 frequency in gc_worker
Message-ID: <20251015114956.GC3419281@noisy.programming.kicks-ass.net>
References: <20251014115103.2678-1-lirongqing@baidu.com>
 <aO5K4mICGHVNlkHJ@strlen.de>
 <13de94827815469193e10d6fb0c0d45b@baidu.com>
 <aO-ADi4UJhOFz4zr@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO-ADi4UJhOFz4zr@strlen.de>

On Wed, Oct 15, 2025 at 01:06:01PM +0200, Florian Westphal wrote:
> Li,Rongqing <lirongqing@baidu.com> wrote:
> 
> [ CC scheduler experts & drop netfilter maintainers ]
> 
> Context: proposed patch
> (https://patchwork.ozlabs.org/project/netfilter-devel/patch/20251014115103.2678-1-lirongqing@baidu.com/)
> does:
> 
> -		cond_resched();
> +		if (jiffies - resched_time > msecs_to_jiffies(1)) {
> +			cond_resched();
> +			resched_time = jiffies;
> +		}
> 
> ... and my knee-jerk reaction was "reject".
> 
> But author pointed me at:
> commit 271557de7cbfdecb08e89ae1ca74647ceb57224f
> xfs: reduce the rate of cond_resched calls inside scrub
> 
> So:
> 
> Is calling cond_resched() unconditionally while walking hashtable/tree etc.
> really discouraged?  I see a truckload of cond_resched() calls in similar
> walkers all over networking. I find it hard to believe that conntrack is
> somehow special and should call it only once per ms.
> 
> If cond_resched() is really so expensive even just for *checking*
> (retval 0), then maybe we should only call it for every n-th hash slot?
> (every L1_CACHE_BYTES?).
> 
> But even in that case it would be good to have a comment or documentation
> entry about recommended usage, or better yet, make a variant of
> xchk_maybe_relax() available via sched.h...

The plan is to remove cond_resched() and friends entirely and have
PREEMPT_LAZY fully replace PREEMPT_VOLUNTARY.

But I don't think we currently have anybody actively working on this.
Ideally distros should be switching to LAZY and report performance vs
VOLUNTARY such that we can try and address things.

Perhaps the thing to do is to just disable VOLUNTARY and see what
happens :-)
