Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EF82DEA75;
	Wed,  8 Apr 2026 11:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649230; cv=none; b=STSuqKs0XVh8ZJbQC49gjrBee5dPzLYjTIZPCg+FVMCKBgTNDyPcuc8ohIfmcc1TW1j2XN9rfP4fRvFZPxIuFQLiHE9rDd1/6vhkweJgZ4kxL/XFLLcX/rg0k+nS4lqK3EWLJdsZyNI5pilmoV9oiM0clvGIooxGAIpAatmnLrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649230; c=relaxed/simple;
	bh=nTGiCk6OwHsxQG7elt4n6Y4G5bqO6SNPXj/FFhihf5o=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=W8zpSiKd7t3gJ35cO6Y8VFWkLlhlh2B2XUU2m1UK3XPxkj9MwyOytMDMymBE04DWKz4kE5mPnm3GiSRGR4blRTwmqKhzJsTg8KgqumgJ1bdzojN64X05vdT7Bpl7dZTK2at6iPShYMxTqCEnqfQX56veEm/FIoyTDHZtok5vi0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cWw1Uu1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cWw1Uu1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D20FC19421;
	Wed,  8 Apr 2026 11:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649230;
	bh=nTGiCk6OwHsxQG7elt4n6Y4G5bqO6SNPXj/FFhihf5o=;
	h=Date:From:To:Cc:Subject:References:From;
	b=cWw1Uu1nn+G+uRwDaYTdrftv+JwOEh/qjfHRZln5GBZu4GBXrKGzW3Xqhq7/WAWKi
	 QnNod7yGjHAREtgSXLzxH6v27qzmKjhQ520cklT+o3M0lWpaglwD1wVe784EM258tA
	 qdotW01P0e6b+bR6ovK62S+wT4ZaMFma92J2JE8CjA1sgFa2vx8bgy2NESaBZWpwt4
	 f2KYjF2UJIoThBWciFev3XskcLYO1HbuvSb0u1sdaNJDRgGZyfWoq8suyAss4otNZQ
	 aP8gbsg1zH6H01PB7wZY6HfFG+3HR67ycA/vXFUiai2bCZuVczLqTdNLF0UxzLWwjb
	 riUVRt0wFy8Ew==
Date: Wed, 08 Apr 2026 13:53:46 +0200
Message-ID: <20260408114951.995031895@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Calvin Owens <calvin@wbinvd.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
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
Subject: [patch V2 01/11] hrtimer: Provide hrtimer_start_range_ns_user()
References: <20260408102356.783133335@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Calvin reported an odd NMI watchdog lockup which claims that the CPU locked
up in user space. He provided a reproducer, which set's up a timerfd based
timer and then rearms it in a loop with an absolute expiry time of 1ns.

As the expiry time is in the past, the timer ends up as the first expiring
timer in the per CPU hrtimer base and the clockevent device is programmed
with the minimum delta value. If the machine is fast enough, this ends up
in a endless loop of programming the delta value to the minimum value
defined by the clock event device, before the timer interrupt can fire,
which starves the interrupt and consequently triggers the lockup detector
because the hrtimer callback of the lockup mechanism is never invoked.

The clockevents code already has a last resort mechanism to prevent that,
but it's sensible to catch such issues before trying to reprogram the clock
event device.

Provide a variant of hrtimer_start_range_ns(), which sanity checks the
timer after queueing it. It does not so before because the timer might be
armed and therefore needs to be dequeued. also we optimize for the latest
possible point to check, so that the clock event prevention is avoided as
much as possible.

If the timer is already expired _before_ the clock event is reprogrammed,
remove the timer from the queue and signal to the caller that the operation
failed by returning false.

That allows the caller to take immediate action without going through the
loops and hoops of the hrtimer interrupt.

The queueing code can't invoke the timer callback as the caller might hold
a lock which is taken in the callback.

Add a tracepoint which allows to analyze the expired at start situation.

Reported-by: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Frederic Weisbecker <frederic@kernel.org>
---
V2: Moved the user check into hrtimer_start_range_ns_user() and handled
    the NONE case explictly. - PeterZ
    Rebased on tip timers/core
---
 include/linux/hrtimer.h      |   20 +++++-
 include/trace/events/timer.h |   13 ++++
 kernel/time/hrtimer.c        |  134 +++++++++++++++++++++++++++++++++++++------
 3 files changed, 148 insertions(+), 19 deletions(-)
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -206,6 +206,9 @@ static inline void destroy_hrtimer_on_st
 extern void hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 				   u64 range_ns, const enum hrtimer_mode mode);
 
+extern bool hrtimer_start_range_ns_user(struct hrtimer *timer, ktime_t tim,
+					u64 range_ns, const enum hrtimer_mode mode);
+
 /**
  * hrtimer_start - (re)start an hrtimer
  * @timer:	the timer to be added
@@ -223,17 +226,28 @@ static inline void hrtimer_start(struct
 extern int hrtimer_cancel(struct hrtimer *timer);
 extern int hrtimer_try_to_cancel(struct hrtimer *timer);
 
-static inline void hrtimer_start_expires(struct hrtimer *timer,
-					 enum hrtimer_mode mode)
+static inline void hrtimer_start_expires(struct hrtimer *timer, enum hrtimer_mode mode)
 {
-	u64 delta;
 	ktime_t soft, hard;
+	u64 delta;
+
 	soft = hrtimer_get_softexpires(timer);
 	hard = hrtimer_get_expires(timer);
 	delta = ktime_to_ns(ktime_sub(hard, soft));
 	hrtimer_start_range_ns(timer, soft, delta, mode);
 }
 
+static inline bool hrtimer_start_expires_user(struct hrtimer *timer, enum hrtimer_mode mode)
+{
+	ktime_t soft, hard;
+	u64 delta;
+
+	soft = hrtimer_get_softexpires(timer);
+	hard = hrtimer_get_expires(timer);
+	delta = ktime_to_ns(ktime_sub(hard, soft));
+	return hrtimer_start_range_ns_user(timer, soft, delta, mode);
+}
+
 void hrtimer_sleeper_start_expires(struct hrtimer_sleeper *sl,
 				   enum hrtimer_mode mode);
 
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -299,6 +299,19 @@ DECLARE_EVENT_CLASS(hrtimer_class,
 );
 
 /**
+ * hrtimer_start_expired - Invoked when a expired timer was started
+ * @hrtimer:	pointer to struct hrtimer
+ *
+ * Preceeded by a hrtimer_start tracepoint.
+ */
+DEFINE_EVENT(hrtimer_class, hrtimer_start_expired,
+
+	TP_PROTO(struct hrtimer *hrtimer),
+
+	TP_ARGS(hrtimer)
+);
+
+/**
  * hrtimer_expire_exit - called immediately after the hrtimer callback returns
  * @hrtimer:	pointer to struct hrtimer
  *
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1352,6 +1352,12 @@ static inline bool hrtimer_keep_base(str
 	return hrtimer_prefer_local(is_local, is_first, is_pinned);
 }
 
+enum {
+	HRTIMER_REPROGRAM_NONE,
+	HRTIMER_REPROGRAM,
+	HRTIMER_REPROGRAM_FORCE,
+};
+
 static bool __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim, u64 delta_ns,
 				     const enum hrtimer_mode mode, struct hrtimer_clock_base *base)
 {
@@ -1410,7 +1416,7 @@ static bool __hrtimer_start_range_ns(str
 	/* If a deferred rearm is pending skip reprogramming the device */
 	if (cpu_base->deferred_rearm) {
 		cpu_base->deferred_needs_update = true;
-		return false;
+		return HRTIMER_REPROGRAM_NONE;
 	}
 
 	if (!was_first || cpu_base != this_cpu_base) {
@@ -1423,7 +1429,7 @@ static bool __hrtimer_start_range_ns(str
 		 * callbacks.
 		 */
 		if (likely(hrtimer_base_is_online(this_cpu_base)))
-			return first;
+			return first ? HRTIMER_REPROGRAM : HRTIMER_REPROGRAM_NONE;
 
 		/*
 		 * Timer was enqueued remote because the current base is
@@ -1432,7 +1438,7 @@ static bool __hrtimer_start_range_ns(str
 		 */
 		if (first)
 			smp_call_function_single_async(cpu_base->cpu, &cpu_base->csd);
-		return false;
+		return HRTIMER_REPROGRAM_NONE;
 	}
 
 	/*
@@ -1446,7 +1452,7 @@ static bool __hrtimer_start_range_ns(str
 	 */
 	if (timer->is_lazy) {
 		if (cpu_base->expires_next <= hrtimer_get_expires(timer))
-			return false;
+			return HRTIMER_REPROGRAM_NONE;
 	}
 
 	/*
@@ -1455,8 +1461,24 @@ static bool __hrtimer_start_range_ns(str
 	 * reprogram the hardware by evaluating the new first expiring
 	 * timer.
 	 */
-	hrtimer_force_reprogram(cpu_base, /* skip_equal */ true);
-	return false;
+	return HRTIMER_REPROGRAM_FORCE;
+}
+
+static int hrtimer_start_range_ns_common(struct hrtimer *timer, ktime_t tim,
+					 u64 delta_ns, const enum hrtimer_mode mode,
+					 struct hrtimer_clock_base *base)
+{
+	/*
+	 * Check whether the HRTIMER_MODE_SOFT bit and hrtimer.is_soft
+	 * match on CONFIG_PREEMPT_RT = n. With PREEMPT_RT check the hard
+	 * expiry mode because unmarked timers are moved to softirq expiry.
+	 */
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		WARN_ON_ONCE(!(mode & HRTIMER_MODE_SOFT) ^ !timer->is_soft);
+	else
+		WARN_ON_ONCE(!(mode & HRTIMER_MODE_HARD) ^ !timer->is_hard);
+
+	return __hrtimer_start_range_ns(timer, tim, delta_ns, mode, base);
 }
 
 /**
@@ -1476,24 +1498,104 @@ void hrtimer_start_range_ns(struct hrtim
 
 	debug_hrtimer_assert_init(timer);
 
+	base = lock_hrtimer_base(timer, &flags);
+
+	switch (hrtimer_start_range_ns_common(timer, tim, delta_ns, mode, base)) {
+	case HRTIMER_REPROGRAM:
+		hrtimer_reprogram(timer, true);
+		break;
+	case HRTIMER_REPROGRAM_FORCE:
+		hrtimer_force_reprogram(timer->base->cpu_base, 1);
+		break;
+	case HRTIMER_REPROGRAM_NONE:
+		break;
+	}
+
+	unlock_hrtimer_base(timer, &flags);
+}
+EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
+
+static inline bool hrtimer_check_user_timer(struct hrtimer *timer)
+{
+	struct hrtimer_cpu_base *cpu_base = timer->base->cpu_base;
+	ktime_t expires;
+
 	/*
-	 * Check whether the HRTIMER_MODE_SOFT bit and hrtimer.is_soft
-	 * match on CONFIG_PREEMPT_RT = n. With PREEMPT_RT check the hard
-	 * expiry mode because unmarked timers are moved to softirq expiry.
+	 * This uses soft expires because that's the user provided
+	 * expiry time, while expires can be further in the past
+	 * due to a slack value added to the user expiry time.
 	 */
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
-		WARN_ON_ONCE(!(mode & HRTIMER_MODE_SOFT) ^ !timer->is_soft);
-	else
-		WARN_ON_ONCE(!(mode & HRTIMER_MODE_HARD) ^ !timer->is_hard);
+	expires = hrtimer_get_softexpires(timer);
+
+	/* Convert to monotonic */
+	expires = ktime_sub(expires, timer->base->offset);
+
+	/*
+	 * Check whether this timer will end up as the first expiring timer in
+	 * the CPU base. If not, no further checks required as it's then
+	 * guaranteed to expire in the future.
+	 */
+	if (expires >= cpu_base->expires_next)
+		return true;
+
+	/* Validate that the expiry time is in the future. */
+	if (expires > ktime_get())
+		return true;
+
+	debug_hrtimer_deactivate(timer);
+	__remove_hrtimer(timer, timer->base, HRTIMER_STATE_INACTIVE, false);
+	trace_hrtimer_start_expired(timer);
+	return false;
+}
+
+/**
+ * hrtimer_start_range_ns_user - (re)start an user controlled hrtimer
+ * @timer:	the timer to be added
+ * @tim:	expiry time
+ * @delta_ns:	"slack" range for the timer
+ * @mode:	timer mode: absolute (HRTIMER_MODE_ABS) or
+ *		relative (HRTIMER_MODE_REL), and pinned (HRTIMER_MODE_PINNED);
+ *		softirq based mode is considered for debug purpose only!
+ *
+ * Returns: True when the timer was queued, false if it was already expired
+ *
+ * This function cannot invoke the timer callback for expired timers as it might
+ * be called under a lock which the timer callback needs to acquire. So the
+ * caller has to handle that case.
+ */
+bool hrtimer_start_range_ns_user(struct hrtimer *timer, ktime_t tim,
+				 u64 delta_ns, const enum hrtimer_mode mode)
+{
+	struct hrtimer_clock_base *base;
+	unsigned long flags;
+	bool ret = true;
+
+	debug_hrtimer_assert_init(timer);
 
 	base = lock_hrtimer_base(timer, &flags);
 
-	if (__hrtimer_start_range_ns(timer, tim, delta_ns, mode, base))
-		hrtimer_reprogram(timer, true);
+	switch (hrtimer_start_range_ns_common(timer, tim, delta_ns, mode, base)) {
+	case HRTIMER_REPROGRAM:
+		ret = hrtimer_check_user_timer(timer);
+		if (ret)
+			hrtimer_reprogram(timer, true);
+		break;
+	case HRTIMER_REPROGRAM_FORCE:
+		ret = hrtimer_check_user_timer(timer);
+		/*
+		 * The base must always be reevaluated, independent of the
+		 * result above because the timer was the first pending timer.
+		 */
+		hrtimer_force_reprogram(timer->base->cpu_base, 1);
+		break;
+	case HRTIMER_REPROGRAM_NONE:
+		break;
+	}
 
 	unlock_hrtimer_base(timer, &flags);
+	return ret;
 }
-EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
+EXPORT_SYMBOL_GPL(hrtimer_start_range_ns_user);
 
 /**
  * hrtimer_try_to_cancel - try to deactivate a timer

