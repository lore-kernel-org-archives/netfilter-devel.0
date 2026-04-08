Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9A93C0637;
	Wed,  8 Apr 2026 11:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649263; cv=none; b=ZG/Toh6fP8px6qzj8MkyS43RE1R0fi8amQf0wfzwPidM4fHuOn4O2B9KmGfrVSYOkIib0stubuAnvzrgg3olsnOw3wht2xJbj6U5hOIKiZ229C44oLULDcsdrLAbUJiX3ZjZSCEjhMoF6o153CghUQPiUHqmT44zw1bSI3aiAfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649263; c=relaxed/simple;
	bh=AmXtfF4jtxZEbEeyDADO/h7k4NvT+7oGErqgeL3DMs8=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=PXN19xbUV8WHNkqgPOM7LRhZxObpouoEhpQrqFTiNEGvxaJAj7Cg7PMprhzidQ/MfmzQtimopBy07fXU08imqZNgpxd+H0P369wcfAf3EWnG1sQrYSrCBCIfjqowEz/IlWmryAKinW844QfMKpiwVRTaE3tQ+1js65zk/58Jtj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hVQIPgcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hVQIPgcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E19C2BCB1;
	Wed,  8 Apr 2026 11:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649263;
	bh=AmXtfF4jtxZEbEeyDADO/h7k4NvT+7oGErqgeL3DMs8=;
	h=Date:From:To:Cc:Subject:References:From;
	b=hVQIPgcYUlGTF66So4NHJf9DvuRHxOeII9qOniI0mX0lk8qkX8mLbQv5WFlNjnhwP
	 JH9/ISSRZJdAmx5DChK1qvwUIqUAlMJLvUJhnI2T4jUXWy+BUNMaIYVV5c7fh8LoMh
	 ULpCl7u/JPmbEmYUHJQv/FVXJX9WgXnB0RZyq+O6dpz3grdO1yafn/Z86433lg3RKq
	 KPpOZDMZdEzGnk0NiTHO9sDJY4t0lLZ4836yZrD+8o4b1GAsWBjnKTc9uSYNDOF3iW
	 J3T3eNZKJ3J2WfkX/kJ4bgwKNlc3w3BLDGzFMnVU7WrU8hu5P6BBx5RgDoy5JzMZMN
	 ZFXKYK48NC8tQ==
Date: Wed, 08 Apr 2026 13:54:20 +0200
Message-ID: <20260408114952.469141112@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 linux-fsdevel@vger.kernel.org,
 Calvin Owens <calvin@wbinvd.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Subject: [patch V2 08/11] fs/timerfd: Use the new alarm/hrtimer functions
References: <20260408102356.783133335@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Like any other user controlled interface, timerfd based timers can be
programmed with expiry times in the past or vary small intervals.

Both hrtimer and alarmtimer provide new interfaces which return the queued
state of the timer. If the timer was already expired, then let the callsite
handle the timerfd context update so that the full round trip through the
hrtimer interrupt is avoided.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: linux-fsdevel@vger.kernel.org
---
V2: Rename to alarm_timer_start() and add a comment explaining the -1 in
    the tick accounting. - Peter
---
 fs/timerfd.c |  117 ++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 68 insertions(+), 49 deletions(-)
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -55,6 +55,15 @@ static inline bool isalarm(struct timerf
 		ctx->clockid == CLOCK_BOOTTIME_ALARM;
 }
 
+static void __timerfd_triggered(struct timerfd_ctx *ctx)
+{
+	lockdep_assert_held(&ctx->wqh.lock);
+
+	ctx->expired = 1;
+	ctx->ticks++;
+	wake_up_locked_poll(&ctx->wqh, EPOLLIN);
+}
+
 /*
  * This gets called when the timer event triggers. We set the "expired"
  * flag, but we do not re-arm the timer (in case it's necessary,
@@ -62,13 +71,8 @@ static inline bool isalarm(struct timerf
  */
 static void timerfd_triggered(struct timerfd_ctx *ctx)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->wqh.lock, flags);
-	ctx->expired = 1;
-	ctx->ticks++;
-	wake_up_locked_poll(&ctx->wqh, EPOLLIN);
-	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
+	guard(spinlock_irqsave)(&ctx->wqh.lock);
+	__timerfd_triggered(ctx);
 }
 
 static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
@@ -184,15 +188,54 @@ static ktime_t timerfd_get_remaining(str
 	return remaining < 0 ? 0: remaining;
 }
 
+static void timerfd_alarm_start(struct timerfd_ctx *ctx, ktime_t exp, bool relative)
+{
+	/* Start the timer. If it's expired already, handle the callback. */
+	if (!alarm_start_timer(&ctx->t.alarm, exp, relative))
+		__timerfd_triggered(ctx);
+}
+
+static u64 timerfd_alarm_restart(struct timerfd_ctx *ctx)
+{
+	/* -1 to account for ctx->ticks++ in __timerfd_triggered() */
+	u64 ticks = alarm_forward_now(&ctx->t.alarm, ctx->tintv) - 1;
+
+	timerfd_alarm_start(ctx, alarm_get_expires(&ctx->t.alarm), false);
+	return ticks;
+}
+
+static void timerfd_hrtimer_start(struct timerfd_ctx *ctx, ktime_t exp,
+				  const enum hrtimer_mode mode)
+{
+	/* Start the timer. If it's expired already, handle the callback. */
+	if (!hrtimer_start_range_ns_user(&ctx->t.tmr, exp, 0, mode))
+		__timerfd_triggered(ctx);
+}
+
+static u64 timerfd_hrtimer_restart(struct timerfd_ctx *ctx)
+{
+	/* -1 to account for ctx->ticks++ in __timerfd_triggered() */
+	u64 ticks = hrtimer_forward_now(&ctx->t.tmr, ctx->tintv) - 1;
+
+	timerfd_hrtimer_start(ctx, hrtimer_get_expires(&ctx->t.tmr), HRTIMER_MODE_ABS);
+	return ticks;
+}
+
+static u64 timerfd_restart(struct timerfd_ctx *ctx)
+{
+	if (isalarm(ctx))
+		return timerfd_alarm_restart(ctx);
+	return timerfd_hrtimer_restart(ctx);
+}
+
 static int timerfd_setup(struct timerfd_ctx *ctx, int flags,
 			 const struct itimerspec64 *ktmr)
 {
+	int clockid = ctx->clockid;
 	enum hrtimer_mode htmode;
 	ktime_t texp;
-	int clockid = ctx->clockid;
 
-	htmode = (flags & TFD_TIMER_ABSTIME) ?
-		HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
+	htmode = (flags & TFD_TIMER_ABSTIME) ? HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
 
 	texp = timespec64_to_ktime(ktmr->it_value);
 	ctx->expired = 0;
@@ -206,20 +249,15 @@ static int timerfd_setup(struct timerfd_
 			   timerfd_alarmproc);
 	} else {
 		hrtimer_setup(&ctx->t.tmr, timerfd_tmrproc, clockid, htmode);
-		hrtimer_set_expires(&ctx->t.tmr, texp);
 	}
 
 	if (texp != 0) {
 		if (flags & TFD_TIMER_ABSTIME)
 			texp = timens_ktime_to_host(clockid, texp);
-		if (isalarm(ctx)) {
-			if (flags & TFD_TIMER_ABSTIME)
-				alarm_start(&ctx->t.alarm, texp);
-			else
-				alarm_start_relative(&ctx->t.alarm, texp);
-		} else {
-			hrtimer_start(&ctx->t.tmr, texp, htmode);
-		}
+		if (isalarm(ctx))
+			timerfd_alarm_start(ctx, texp, !(flags & TFD_TIMER_ABSTIME));
+		else
+			timerfd_hrtimer_start(ctx, texp, htmode);
 
 		if (timerfd_canceled(ctx))
 			return -ECANCELED;
@@ -287,27 +325,19 @@ static ssize_t timerfd_read_iter(struct
 	}
 
 	if (ctx->ticks) {
-		ticks = ctx->ticks;
+		unsigned int expired = ctx->expired;
 
-		if (ctx->expired && ctx->tintv) {
-			/*
-			 * If tintv != 0, this is a periodic timer that
-			 * needs to be re-armed. We avoid doing it in the timer
-			 * callback to avoid DoS attacks specifying a very
-			 * short timer period.
-			 */
-			if (isalarm(ctx)) {
-				ticks += alarm_forward_now(
-					&ctx->t.alarm, ctx->tintv) - 1;
-				alarm_restart(&ctx->t.alarm);
-			} else {
-				ticks += hrtimer_forward_now(&ctx->t.tmr,
-							     ctx->tintv) - 1;
-				hrtimer_restart(&ctx->t.tmr);
-			}
-		}
+		ticks = ctx->ticks;
 		ctx->expired = 0;
 		ctx->ticks = 0;
+
+		/*
+		 * If tintv != 0, this is a periodic timer that needs to be
+		 * re-armed. We avoid doing it in the timer callback to avoid
+		 * DoS attacks specifying a very short timer period.
+		 */
+		if (expired && ctx->tintv)
+			ticks += timerfd_restart(ctx);
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 	if (ticks) {
@@ -526,18 +556,7 @@ static int do_timerfd_gettime(int ufd, s
 	spin_lock_irq(&ctx->wqh.lock);
 	if (ctx->expired && ctx->tintv) {
 		ctx->expired = 0;
-
-		if (isalarm(ctx)) {
-			ctx->ticks +=
-				alarm_forward_now(
-					&ctx->t.alarm, ctx->tintv) - 1;
-			alarm_restart(&ctx->t.alarm);
-		} else {
-			ctx->ticks +=
-				hrtimer_forward_now(&ctx->t.tmr, ctx->tintv)
-				- 1;
-			hrtimer_restart(&ctx->t.tmr);
-		}
+		ctx->ticks += timerfd_restart(ctx);
 	}
 	t->it_value = ktime_to_timespec64(timerfd_get_remaining(ctx));
 	t->it_interval = ktime_to_timespec64(ctx->tintv);

