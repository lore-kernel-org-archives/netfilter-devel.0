Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A249C3BE17C;
	Wed,  8 Apr 2026 11:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649240; cv=none; b=pFcyog3RCgDb9iYH2/J9sAwOlPVymzY9Hlvmxm55dg4s3mTaHjQdKTxuJzO7ox/p2KJqU0dNuQHenzxGb0fg0gcTexhnqjMLWCUg/aECXNhPS3D+PSjBMkR/GkAxm0gHHhO8r2Won159B7lfLp1rAXEnfsnEuV3rC5Dtv1mSgoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649240; c=relaxed/simple;
	bh=oEkNKRlMqQdHenWzq/XG7pKeJ9UvzaFKdXhbrVbFvYI=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=V1yQIXH9RUhqGdp8MSMsHyEeW4uCkRFEY78ZmmaT41MvNQJAZUcDns8V0GhKouUVmY3kkJ4tOGx8wutPOqW6CwqYPwuMqP+bynlsWPg62MOwtdtptFXUNywd/ZzfNCXBK3wActdvzjk2+1rLflaE3apRkaCz43gzKi/Zwr0IiWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=USfOR16j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="USfOR16j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA5FC19421;
	Wed,  8 Apr 2026 11:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649240;
	bh=oEkNKRlMqQdHenWzq/XG7pKeJ9UvzaFKdXhbrVbFvYI=;
	h=Date:From:To:Cc:Subject:References:From;
	b=USfOR16jQhkS0mgICQgAfc4UwZX4zRHIG5sbx1xTTTU6ZAwFFQFOdTgGG5M3AJ21h
	 k96QLHpArsD3PJ96pYpkZ9PA13mD5r7nMZMloDwFOqb8ueo2GNxjoJHCb8QHi0cZHl
	 FmvL2nWfbMKYCrRxGgekMEzBjtJqRBiphlU0J6UtDi9XupjQXuanSHGNiJ2hzZKGFw
	 56tsvw3Y1qpqAxc4LAsLDAxBl6Xa5GgA+TgSMCTO5n387aYAPYE5xZDdMI4oFfWfGl
	 wpllRYbHn3YTMCYdMq83mNBoTvSwVw1BHjG/yR6h1eaka3/fmNRiUMfhlzwv0BUPAm
	 vU5s2vr6VyWRA==
Date: Wed, 08 Apr 2026 13:53:56 +0200
Message-ID: <20260408114952.130222296@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 Calvin Owens <calvin@wbinvd.org>,
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
Subject: [patch V2 03/11] posix-timers: Expand timer_[re]arm() callbacks with
 a boolean return value
References: <20260408102356.783133335@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

In order to catch expiry times which are already in the past the
timer_arm() and timer_rearm() callbacks need to be able to report back to
the caller whether the timer has been queued or not.

Change the function signature and let all implementations return true for
now. While at it simplify posix_cpu_timer_rearm().

No functional change intended.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: John Stultz <jstultz@google.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Frederic Weisbecker <frederic@kernel.org>

---
 kernel/time/alarmtimer.c       |    6 ++++--
 kernel/time/posix-cpu-timers.c |   18 ++++++++++--------
 kernel/time/posix-timers.c     |    6 ++++--
 kernel/time/posix-timers.h     |    4 ++--
 4 files changed, 20 insertions(+), 14 deletions(-)
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -527,12 +527,13 @@ static void alarm_handle_timer(struct al
  * alarm_timer_rearm - Posix timer callback for rearming timer
  * @timr:	Pointer to the posixtimer data struct
  */
-static void alarm_timer_rearm(struct k_itimer *timr)
+static bool alarm_timer_rearm(struct k_itimer *timr)
 {
 	struct alarm *alarm = &timr->it.alarm.alarmtimer;
 
 	timr->it_overrun += alarm_forward_now(alarm, timr->it_interval);
 	alarm_start(alarm, alarm->node.expires);
+	return true;
 }
 
 /**
@@ -588,7 +589,7 @@ static void alarm_timer_wait_running(str
  * @absolute:	Expiry value is absolute time
  * @sigev_none:	Posix timer does not deliver signals
  */
-static void alarm_timer_arm(struct k_itimer *timr, ktime_t expires,
+static bool alarm_timer_arm(struct k_itimer *timr, ktime_t expires,
 			    bool absolute, bool sigev_none)
 {
 	struct alarm *alarm = &timr->it.alarm.alarmtimer;
@@ -600,6 +601,7 @@ static void alarm_timer_arm(struct k_iti
 		alarm->node.expires = expires;
 	else
 		alarm_start(&timr->it.alarm.alarmtimer, expires);
+	return true;
 }
 
 /**
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -19,7 +19,7 @@
 
 #include "posix-timers.h"
 
-static void posix_cpu_timer_rearm(struct k_itimer *timer);
+static bool posix_cpu_timer_rearm(struct k_itimer *timer);
 
 void posix_cputimers_group_init(struct posix_cputimers *pct, u64 cpu_limit)
 {
@@ -1011,24 +1011,27 @@ static void check_process_timers(struct
 /*
  * This is called from the signal code (via posixtimer_rearm)
  * when the last timer signal was delivered and we have to reload the timer.
+ *
+ * Return true unconditionally so the core code assumes the timer to be
+ * armed. Otherwise it would requeue the signal.
  */
-static void posix_cpu_timer_rearm(struct k_itimer *timer)
+static bool posix_cpu_timer_rearm(struct k_itimer *timer)
 {
 	clockid_t clkid = CPUCLOCK_WHICH(timer->it_clock);
-	struct task_struct *p;
 	struct sighand_struct *sighand;
+	struct task_struct *p;
 	unsigned long flags;
 	u64 now;
 
-	rcu_read_lock();
+	guard(rcu)();
 	p = cpu_timer_task_rcu(timer);
 	if (!p)
-		goto out;
+		return true;
 
 	/* Protect timer list r/w in arm_timer() */
 	sighand = lock_task_sighand(p, &flags);
 	if (unlikely(sighand == NULL))
-		goto out;
+		return true;
 
 	/*
 	 * Fetch the current sample and update the timer's expiry time.
@@ -1045,8 +1048,7 @@ static void posix_cpu_timer_rearm(struct
 	 */
 	arm_timer(timer, p);
 	unlock_task_sighand(p, &flags);
-out:
-	rcu_read_unlock();
+	return true;
 }
 
 /**
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -288,12 +288,13 @@ static inline int timer_overrun_to_int(s
 	return (int)timr->it_overrun_last;
 }
 
-static void common_hrtimer_rearm(struct k_itimer *timr)
+static bool common_hrtimer_rearm(struct k_itimer *timr)
 {
 	struct hrtimer *timer = &timr->it.real.timer;
 
 	timr->it_overrun += hrtimer_forward_now(timer, timr->it_interval);
 	hrtimer_restart(timer);
+	return true;
 }
 
 static bool __posixtimer_deliver_signal(struct kernel_siginfo *info, struct k_itimer *timr)
@@ -795,7 +796,7 @@ SYSCALL_DEFINE1(timer_getoverrun, timer_
 		return timer_overrun_to_int(scoped_timer);
 }
 
-static void common_hrtimer_arm(struct k_itimer *timr, ktime_t expires,
+static bool common_hrtimer_arm(struct k_itimer *timr, ktime_t expires,
 			       bool absolute, bool sigev_none)
 {
 	struct hrtimer *timer = &timr->it.real.timer;
@@ -822,6 +823,7 @@ static void common_hrtimer_arm(struct k_
 
 	if (!sigev_none)
 		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
+	return true;
 }
 
 static int common_hrtimer_try_to_cancel(struct k_itimer *timr)
--- a/kernel/time/posix-timers.h
+++ b/kernel/time/posix-timers.h
@@ -27,11 +27,11 @@ struct k_clock {
 	int	(*timer_del)(struct k_itimer *timr);
 	void	(*timer_get)(struct k_itimer *timr,
 			     struct itimerspec64 *cur_setting);
-	void	(*timer_rearm)(struct k_itimer *timr);
+	bool	(*timer_rearm)(struct k_itimer *timr);
 	s64	(*timer_forward)(struct k_itimer *timr, ktime_t now);
 	ktime_t	(*timer_remaining)(struct k_itimer *timr, ktime_t now);
 	int	(*timer_try_to_cancel)(struct k_itimer *timr);
-	void	(*timer_arm)(struct k_itimer *timr, ktime_t expires,
+	bool	(*timer_arm)(struct k_itimer *timr, ktime_t expires,
 			     bool absolute, bool sigev_none);
 	void	(*timer_wait_running)(struct k_itimer *timr);
 };

