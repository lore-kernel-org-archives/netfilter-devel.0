Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62F039B49D;
	Tue,  7 Apr 2026 08:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775552101; cv=none; b=Ev8lGfpFK+EkHPgWV7Bd6Ux0QEF29b7pem5ZqatwcH/ZeZHoFiPh6cl/JXBG6XZoXEwsFcDT2eB0kfM1AHyID6GXhNgRzItuU/7IVaHgyWjBoUPqn7lAE+YLoi8ywi5mTITw3tYGK56mVV+9dBJH8TnpbYum9+ub9LtJLop25rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775552101; c=relaxed/simple;
	bh=u8AI8RDvRZGzX0Utt+A54oYb3DpD5J4mYOgVVmHoy9M=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=Oqqryc4YLJkRpqoqJ6hqdUx5GN8FeqAaVn9xh1BMcq85PJ26E/7anEZ3P7m2CvvE4oW0cAeKHS0GdmxVNb+wdFuOukvgdePWLgKNh7y5zc09u2NbxS89AP5vfLoW3UUwxvin1bCpdvlE6paRqvTc3jHwEaEQ4ggdHYYGksYj8Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rExZgWkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rExZgWkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79D6C2BC9E;
	Tue,  7 Apr 2026 08:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775552101;
	bh=u8AI8RDvRZGzX0Utt+A54oYb3DpD5J4mYOgVVmHoy9M=;
	h=Date:From:To:Cc:Subject:References:From;
	b=rExZgWkbXR9kwaADPjSXATWJ03G725leNaOke/D/1liXugoBCuhBR7WJMwgUgTBj6
	 PgWILOByVuqvSS81yZjMVolMM2Q47l2SbQIcC9HMKtTst9co/63RhTsHoqV215xnr7
	 ZGmQQ/qEhtTdkY9AZYNGEqKsDwiEbmqAop2htdmPIWZTIJZa1myM1Eg51kCjLOSeZ4
	 OT2VzHlzS93usQN2/rpc4q2gGgXJpTKcb+aMSUtgUFSV1LE/W3tFAXu5TK9RgGCjvS
	 lUESNI9jmO5HhlmPtFQBuEY+8B/hn++K+o/IhXr4bJ0O0f0yE3JZSBFeYmqj2wPAHT
	 BXBugYBQPJ4kQ==
Date: Tue, 07 Apr 2026 10:54:58 +0200
Message-ID: <20260407083248.102440187@kernel.org>
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
 Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@kernel.org>,
 John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Subject: [patch 09/12] fs/timerfd: Use the new alarm/hrtimer functions
References: <20260407083219.478203185@kernel.org>
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
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/timerfd.c |  115 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 66 insertions(+), 49 deletions(-)

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
@@ -184,15 +188,52 @@ static ktime_t timerfd_get_remaining(str
 	return remaining < 0 ? 0: remaining;
 }
 
+static void timerfd_alarm_start(struct timerfd_ctx *ctx, ktime_t exp, bool relative)
+{
+	/* Start the timer. If it's expired already, handle the callback. */
+	if (!alarmtimer_start(&ctx->t.alarm, exp, relative))
+		__timerfd_triggered(ctx);
+}
+
+static u64 timerfd_alarm_restart(struct timerfd_ctx *ctx)
+{
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
@@ -206,20 +247,15 @@ static int timerfd_setup(struct timerfd_
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
@@ -287,27 +323,19 @@ static ssize_t timerfd_read_iter(struct
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
@@ -526,18 +554,7 @@ static int do_timerfd_gettime(int ufd, s
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

