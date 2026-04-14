Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0855C275AFB;
	Tue, 14 Apr 2026 20:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776200106; cv=none; b=kJtsUuDBVXefHlQhixiDXskL0YjfWhxkFSadZRQOTscbw8+REmh9XigA6suwvuO1xF6h9J5EhspXOHt9Ogv+PmR4S6AhfzTHR0JN1cAGNMzq1mUwH2lT6wJFZrEq8Nt4BlGcgyfNTtwaktRCsK3uLuTcfjvHGm7Pcd985RSq/TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776200106; c=relaxed/simple;
	bh=EDu18GVFDioQPQHdsolEuUt692hxrgbWXQqdtx2/xsg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MRmLOktNKE03z3AgKUSv+pPN6YubUb+YWi6Kjs00SfnxdAEejgEbTBJ8jOApDaGYjpPQcT5Clzz5cQgFa1siCUnT2ZElHdoPPYpw/Z/FUBhSmmBXt656aDz7p2R4pt6NOXeFr+uYkpca9XmfYr6QdMrahppzQmTBg8zP7HlATws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0sc6Cc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0sc6Cc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D4BC19425;
	Tue, 14 Apr 2026 20:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776200105;
	bh=EDu18GVFDioQPQHdsolEuUt692hxrgbWXQqdtx2/xsg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=G0sc6Cc5UKUVzzxbQ16k8r9RRuAiMS6T5iAx4FH6QLNxGLx0j5r01VxJsc0UD417h
	 XutpQWK+tHXTGKkkGk97epHbPm5dIxq1J5kTPyN0RhlM3h5JtGpqUHyB6/8kHCXmIc
	 q/YHMB5/YqKPT8jniFghDr2L2RLBaVfoDHtRb7tvFd24xr3MZrZl6vFA0LPxPQLuHI
	 aY8bGfCFsTemtxunJfZzCPh8q16CzXn/bRveQzqkEtfEuhc0HZ6dClesGUpEmbP3ku
	 sTLCgFLw1mpk1zH4kO8fRpK2NcrRYoEnbrCWJ29fYz1+3MZjPjhJJMQL/eTw3BITbx
	 jKxiG9TqOxECg==
From: Thomas Gleixner <tglx@kernel.org>
To: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>, Frederic Weisbecker
 <frederic@kernel.org>
Cc: Eric Naim <dnaim@cachyos.org>, LKML <linux-kernel@vger.kernel.org>,
 Calvin Owens <calvin@wbinvd.org>, Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Ingo Molnar
 <mingo@kernel.org>, John Stultz <jstultz@google.com>, Stephen Boyd
 <sboyd@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, Florian
 Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: The "clockevents: Prevent timer interrupt starvation" patch
 causes lockups
In-Reply-To: <a3ac856c-914c-4b39-949f-634bed501e7c@gmail.com>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
 <68d1e9ac-2780-4be3-8ee3-0788062dd3a4@gmail.com>
 <aeb848aa-404a-40fb-bd41-329644623b1d@cachyos.org>
 <ad6BtKRj1GyreNCS@localhost.localdomain>
 <a3ac856c-914c-4b39-949f-634bed501e7c@gmail.com>
Date: Tue, 14 Apr 2026 22:55:01 +0200
Message-ID: <87340xfeje.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 14 2026 at 18:25, Hanabishi wrote:
> On 14/04/2026 18:04, Frederic Weisbecker wrote:
>
> This patch doesn't help me unfortunately. Thanks.

The one below should cover all possible holes.

Thanks,

        tglx
---
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index b4d730604972..5e22697b098d 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -94,6 +94,9 @@ static int __clockevents_switch_state(struct clock_event_device *dev,
 	if (dev->features & CLOCK_EVT_FEAT_DUMMY)
 		return 0;
 
+	/* On state transitions clear the forced flag unconditionally */
+	dev->next_event_forced = 0;
+
 	/* Transition with new state-specific callbacks */
 	switch (state) {
 	case CLOCK_EVT_STATE_DETACHED:
@@ -366,8 +369,10 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires, b
 	if (delta > (int64_t)dev->min_delta_ns) {
 		delta = min(delta, (int64_t) dev->max_delta_ns);
 		cycles = ((u64)delta * dev->mult) >> dev->shift;
-		if (!dev->set_next_event((unsigned long) cycles, dev))
+		if (!dev->set_next_event((unsigned long) cycles, dev)) {
+			dev->next_event_forced = 0;
 			return 0;
+		}
 	}
 
 	if (dev->next_event_forced)
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 7e57fa31ee26..115e0bf01276 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -108,6 +108,7 @@ static struct clock_event_device *tick_get_oneshot_wakeup_device(int cpu)
 
 static void tick_oneshot_wakeup_handler(struct clock_event_device *wd)
 {
+	wd->next_event_forced = 0;
 	/*
 	 * If we woke up early and the tick was reprogrammed in the
 	 * meantime then this may be spurious but harmless.
