Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7B338C2B5;
	Tue,  7 Apr 2026 08:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775552061; cv=none; b=YWvNSgnfzumMH6xF/ShiFugPmXW0xjML4ng8l/EilGXY5LlISWgzIIPYLxQkBerCLPT3XYrYN/ySFMeJ7mV6fxG6Ven8ISk1HkLo8pDj0yJ1fL4GNnEUk28wPdbI1jC5hO+r6T8Po6PFle6fvMi35dAz3uM0evJyul/HXSvdo7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775552061; c=relaxed/simple;
	bh=/xYs3O0kL0sYfj4X83LKJJkUOaxeLjU6FZ9MnfIN9Dc=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=Jxh4wDHm3/s2DkWqy7oSJrSXMzeUtVvPvarNLuE+s5WwwgLEN6X2ZDOl+V8Lbg7zGJQ0IKhaBuR/ZsN3WIVIxKr2pt6vtEQzTSV8bbqI5ATe72JK8vnzwBd333VgC06XJPsafFJ+OgT03e7S3GXJ9qUuh46EwFyJHRn25Ine1SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eexOg75U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eexOg75U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58966C116C6;
	Tue,  7 Apr 2026 08:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775552060;
	bh=/xYs3O0kL0sYfj4X83LKJJkUOaxeLjU6FZ9MnfIN9Dc=;
	h=Date:From:To:Cc:Subject:References:From;
	b=eexOg75UKzbZNb3GzltnQtK9klmrNpQkDWWUEByY54h7u0xNb/ev5e5LtUKXPRgfB
	 Me1olXlOEEahjOtRCXiK9JcGOnEx/asFDIl5YcflKbJ5dGWGtNCpAK4wPI25vjnv1W
	 eftegC0fHHElzJcLwlnFbGwyHkG0u7yipY5s64/tCMGtnBbyaL+e7V120l/Sxld9x8
	 z4GeZCc8f4llZv7kDVmCqk7hmzK+XxZ4UNcw88vStrFc2HCtyyR/3+rsOvNH7yXy3K
	 i1345GBKs2uaUWn3DdImYl8CnvsoAaWmMOfxbVZyV9nPwXsouXnh0TRak+Us4k5D/M
	 acST9SMUSQU+Q==
Date: Tue, 07 Apr 2026 10:54:17 +0200
Message-ID: <20260407083247.562657657@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Calvin Owens <calvin@wbinvd.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 Ingo Molnar <mingo@kernel.org>,
 John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org,
 Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Subject: [patch 01/12] clockevents: Prevent timer interrupt starvation
References: <20260407083219.478203185@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Thomas Gleixner <tglx@kernel.org>

Calvin reported an odd NMI watchdog lockup which claims that the CPU locked
up in user space. He provided a reproducer, which sets up a timerfd based
timer and then rearms it in a loop with an absolute expiry time of 1ns.

As the expiry time is in the past, the timer ends up as the first expiring
timer in the per CPU hrtimer base and the clockevent device is programmed
with the minimum delta value. If the machine is fast enough, this ends up
in a endless loop of programming the delta value to the minimum value
defined by the clock event device, before the timer interrupt can fire,
which starves the interrupt and consequently triggers the lockup detector
because the hrtimer callback of the lockup mechanism is never invoked.

As a first step to prevent this, avoid reprogramming the clock event device
when:
     - a forced minimum delta event is pending
     - the new expiry delta is less then or equal to the minimum delta

Thanks to Calvin for providing the reproducer and to Borislav for testing
and providing data from his Zen5 machine.

The problem is not limited to Zen5, but depending on the underlying
clock event device (e.g. TSC deadline timer on Intel) and the CPU speed
not necessarily observable.

This change serves only as the last resort and further changes will be made
to prevent this scenario earlier in the call chain as far as possible.

Fixes: d316c57ff6bf ("[PATCH] clockevents: add core functionality")
Reported-by: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/lkml/acMe-QZUel-bBYUh@mozart.vkv.me/
---
V2: Simplified the clockevents code - Peter
---
 include/linux/clockchips.h |    2 ++
 kernel/time/clockevents.c  |   23 +++++++++++++++--------
 kernel/time/hrtimer.c      |    1 +
 kernel/time/tick-common.c  |    1 +
 kernel/time/tick-sched.c   |    1 +
 5 files changed, 20 insertions(+), 8 deletions(-)
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -80,6 +80,7 @@ enum clock_event_state {
  * @shift:		nanoseconds to cycles divisor (power of two)
  * @state_use_accessors:current state of the device, assigned by the core code
  * @features:		features
+ * @next_event_forced:	True if the last programming was a forced event
  * @retries:		number of forced programming retries
  * @set_state_periodic:	switch state to periodic
  * @set_state_oneshot:	switch state to oneshot
@@ -108,6 +109,7 @@ struct clock_event_device {
 	u32			shift;
 	enum clock_event_state	state_use_accessors;
 	unsigned int		features;
+	unsigned int		next_event_forced;
 	unsigned long		retries;
 
 	int			(*set_state_periodic)(struct clock_event_device *);
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -172,6 +172,7 @@ void clockevents_shutdown(struct clock_e
 {
 	clockevents_switch_state(dev, CLOCK_EVT_STATE_SHUTDOWN);
 	dev->next_event = KTIME_MAX;
+	dev->next_event_forced = 0;
 }
 
 /**
@@ -305,7 +306,6 @@ int clockevents_program_event(struct clo
 {
 	unsigned long long clc;
 	int64_t delta;
-	int rc;
 
 	if (WARN_ON_ONCE(expires < 0))
 		return -ETIME;
@@ -324,16 +324,23 @@ int clockevents_program_event(struct clo
 		return dev->set_next_ktime(expires, dev);
 
 	delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
-	if (delta <= 0)
-		return force ? clockevents_program_min_delta(dev) : -ETIME;
 
-	delta = min(delta, (int64_t) dev->max_delta_ns);
-	delta = max(delta, (int64_t) dev->min_delta_ns);
+	if (delta > (int64_t)dev->min_delta_ns) {
+		delta = min(delta, (int64_t) dev->max_delta_ns);
+		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
+		if (!dev->set_next_event((unsigned long) clc, dev))
+			return 0;
+	}
 
-	clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
-	rc = dev->set_next_event((unsigned long) clc, dev);
+	if (dev->next_event_forced)
+		return 0;
 
-	return (rc && force) ? clockevents_program_min_delta(dev) : rc;
+	if (dev->set_next_event(dev->min_delta_ticks, dev)) {
+		if (!force || clockevents_program_min_delta(dev))
+			return -ETIME;
+	}
+	dev->next_event_forced = 1;
+	return 0;
 }
 
 /*
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1888,6 +1888,7 @@ void hrtimer_interrupt(struct clock_even
 	BUG_ON(!cpu_base->hres_active);
 	cpu_base->nr_events++;
 	dev->next_event = KTIME_MAX;
+	dev->next_event_forced = 0;
 
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 	entry_time = now = hrtimer_update_base(cpu_base);
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -110,6 +110,7 @@ void tick_handle_periodic(struct clock_e
 	int cpu = smp_processor_id();
 	ktime_t next = dev->next_event;
 
+	dev->next_event_forced = 0;
 	tick_periodic(cpu);
 
 	/*
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1513,6 +1513,7 @@ static void tick_nohz_lowres_handler(str
 	struct tick_sched *ts = this_cpu_ptr(&tick_cpu_sched);
 
 	dev->next_event = KTIME_MAX;
+	dev->next_event_forced = 0;
 
 	if (likely(tick_nohz_handler(&ts->sched_timer) == HRTIMER_RESTART))
 		tick_program_event(hrtimer_get_expires(&ts->sched_timer), 1);

