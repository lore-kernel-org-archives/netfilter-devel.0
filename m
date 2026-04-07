Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3720339A7E5;
	Tue,  7 Apr 2026 08:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775552066; cv=none; b=eag682FHmTBfJ+9fjNGj9ZJfnAL5gFa0lJ6DJuZRJw1+SoeGCObmLgrMVRRIhG7ZzivjTz2tbqC/REWlPbIJ8rGnpmtceFiCRFGUrY19V3sjgvckK6cL74H4i62jpryhqiPxsx2oJihWlilLls08VFDgmcgmb4IvMo11ErZ5l9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775552066; c=relaxed/simple;
	bh=1moD5YRre+7PFAa0cZ6BeO4IeU3BIQxcY31TfBcyn8o=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=X9/5jmv+cUK2i6rH1WZtfQqyvTabUD9sV0vtQPO5Gy9ILzOCMYUpLLdRnIE9uIfDJ3GkUhH5OpiCHKzCA0Dk6vQGE8KzqnQIoxuuUCd0HC5dSrk/vUKFsYKzFqU8T+xlPqwhtPKsULr9b3JYh6QMiWsqWANkmuuCwrxCsGEgSuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwSajaqU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwSajaqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44464C116C6;
	Tue,  7 Apr 2026 08:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775552065;
	bh=1moD5YRre+7PFAa0cZ6BeO4IeU3BIQxcY31TfBcyn8o=;
	h=Date:From:To:Cc:Subject:References:From;
	b=YwSajaqUJG6X1oGQYuQhF19EW9GJXLFGJgVgFOwd38THJA1YukJTodCEUCrtI3ike
	 K1tqccGIUYChfXwIiSZPLId2qP9/PvCRk/QIxGz1MZSYvnxBaAfdU/r4FHv/FMrUUh
	 tfeAnkh1wkF6FkkTn3GMvlkqGjXkOYGt4iGBo5x2c+yWlaVaHKm7X0V9y0FJlvkV5B
	 sSAdLo7+eeEaT789qLZCAkcYN5zdCDUqf2+kyeg6GelLjg9dW9QrymMYqT1KWJe+Cx
	 jE8uvH30NP8oLuzPu9v9+kchbniNFQ8VA3HUy+mrq5+yRG/z+fpYolZqR1e1ZW1eNy
	 ekyM/il3SDSCg==
Date: Tue, 07 Apr 2026 10:54:22 +0200
Message-ID: <20260407083247.630389532@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Calvin Owens <calvin@wbinvd.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
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
Subject: [patch 02/12] hrtimer: Provide hrtimer_start_range_ns_user()
References: <20260407083219.478203185@kernel.org>
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
 include/linux/hrtimer.h      |   20 +++++-
 include/trace/events/timer.h |   13 ++++
 kernel/time/hrtimer.c        |  135 ++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 151 insertions(+), 17 deletions(-)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -230,6 +230,9 @@ static inline void destroy_hrtimer_on_st
 extern void hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 				   u64 range_ns, const enum hrtimer_mode mode);
 
+extern bool hrtimer_start_range_ns_user(struct hrtimer *timer, ktime_t tim,
+					u64 range_ns, const enum hrtimer_mode mode);
+
 /**
  * hrtimer_start - (re)start an hrtimer
  * @timer:	the timer to be added
@@ -247,17 +250,28 @@ static inline void hrtimer_start(struct
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
@@ -297,6 +297,19 @@ DECLARE_EVENT_CLASS(hrtimer_class,
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
@@ -1215,6 +1215,12 @@ hrtimer_update_softirq_timer(struct hrti
 	hrtimer_reprogram(cpu_base->softirq_next_timer, reprogram);
 }
 
+enum {
+	HRTIMER_REPROGRAM_NONE,
+	HRTIMER_REPROGRAM,
+	HRTIMER_REPROGRAM_FORCE,
+};
+
 static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 				    u64 delta_ns, const enum hrtimer_mode mode,
 				    struct hrtimer_clock_base *base)
@@ -1276,7 +1282,7 @@ static int __hrtimer_start_range_ns(stru
 		 * expiring timer there.
 		 */
 		if (hrtimer_base_is_online(this_cpu_base))
-			return first;
+			return first ? HRTIMER_REPROGRAM : HRTIMER_REPROGRAM_NONE;
 
 		/*
 		 * Timer was enqueued remote because the current base is
@@ -1296,8 +1302,24 @@ static int __hrtimer_start_range_ns(stru
 	 * reprogramming on removal and enqueue. Force reprogram the
 	 * hardware by evaluating the new first expiring timer.
 	 */
-	hrtimer_force_reprogram(new_base->cpu_base, 1);
-	return 0;
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
@@ -1315,25 +1337,110 @@ void hrtimer_start_range_ns(struct hrtim
 	struct hrtimer_clock_base *base;
 	unsigned long flags;
 
-	/*
-	 * Check whether the HRTIMER_MODE_SOFT bit and hrtimer.is_soft
-	 * match on CONFIG_PREEMPT_RT = n. With PREEMPT_RT check the hard
-	 * expiry mode because unmarked timers are moved to softirq expiry.
-	 */
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
-		WARN_ON_ONCE(!(mode & HRTIMER_MODE_SOFT) ^ !timer->is_soft);
-	else
-		WARN_ON_ONCE(!(mode & HRTIMER_MODE_HARD) ^ !timer->is_hard);
-
 	base = lock_hrtimer_base(timer, &flags);
 
-	if (__hrtimer_start_range_ns(timer, tim, delta_ns, mode, base))
+	switch (hrtimer_start_range_ns_common(timer, tim, delta_ns, mode, base)) {
+	case HRTIMER_REPROGRAM:
 		hrtimer_reprogram(timer, true);
+		break;
+	case HRTIMER_REPROGRAM_FORCE:
+		hrtimer_force_reprogram(timer->base->cpu_base, 1);
+		break;
+	}
 
 	unlock_hrtimer_base(timer, &flags);
 }
 EXPORT_SYMBOL_GPL(hrtimer_start_range_ns);
 
+static inline bool hrtimer_check_user_timer(struct hrtimer *timer)
+{
+	struct hrtimer_cpu_base *cpu_base = timer->base->cpu_base;
+	ktime_t expires;
+
+	/*
+	 * This uses soft expires because that's the user provided
+	 * expiry time, while expires can be further in the past
+	 * due to a slack value added to the user expiry time.
+	 */
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
+	debug_deactivate(timer);
+	__remove_hrtimer(timer, timer->base, HRTIMER_STATE_INACTIVE, false);
+	trace_hrtimer_start_expired(timer);
+	return false;
+}
+
+static bool hrtimer_reprogram_user(struct hrtimer *timer)
+{
+	if (!hrtimer_check_user_timer(timer))
+		return false;
+	hrtimer_reprogram(timer, true);
+	return true;
+}
+
+static bool hrtimer_force_reprogram_user(struct hrtimer *timer)
+{
+	bool ret = hrtimer_check_user_timer(timer);
+
+	/*
+	 * The base must always be reevaluated, independent of the result
+	 * above because the timer was the first pending timer.
+	 */
+	hrtimer_force_reprogram(timer->base->cpu_base, 1);
+	return ret;
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
+	base = lock_hrtimer_base(timer, &flags);
+	switch (hrtimer_start_range_ns_common(timer, tim, delta_ns, mode, base)) {
+	case HRTIMER_REPROGRAM:
+		ret = hrtimer_reprogram_user(timer);
+		break;
+	case HRTIMER_REPROGRAM_FORCE:
+		ret = hrtimer_force_reprogram_user(timer);
+		break;
+	}
+	unlock_hrtimer_base(timer, &flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hrtimer_start_range_ns_user);
+
 /**
  * hrtimer_try_to_cancel - try to deactivate a timer
  * @timer:	hrtimer to stop

