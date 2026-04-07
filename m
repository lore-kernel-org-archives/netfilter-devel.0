Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559C713959D;
	Tue,  7 Apr 2026 08:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775552116; cv=none; b=RHGqdxxtSeyrH6Wt7jYtbl1I7TBqUQR2YT9c+f6qkG8Vr73w/G9LRTDWQx1wtjOORMtiXqott0RpqKkBbsBWBYfZGyssb9iOElpdoXN/mUVz/Dk8a54w39fJ1HGrtIu713ndFQMl8YvTYOtfLjqmoNrdXIVAodx5D/3ZAtokgpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775552116; c=relaxed/simple;
	bh=9FM/2kY5c9jnURSRNKlLV3ziUYO+2vbuP2OQgTOa3p4=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=mHxc+WOjDo3ySJMF8HwBK4+zcosqKTjl6jTA5PdfsKYyZ1E2D20yNC3QNYMVEOeuh5OTxNnV5cARuclQR7fkp9ed7ao/d8JBZUBRsK7LHbW+0BLNxzfy+vxfHFo9Qp5zzRMuxyQ8dmJHZKpURHKu0nlRz1iHkLdgXnRvhafZ2Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bM76w13/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bM76w13/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716C0C2BCAF;
	Tue,  7 Apr 2026 08:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775552116;
	bh=9FM/2kY5c9jnURSRNKlLV3ziUYO+2vbuP2OQgTOa3p4=;
	h=Date:From:To:Cc:Subject:References:From;
	b=bM76w13/WCTo4sBXQSs0QFxAyU9HZUW0hjydi5Lvptkm1KE+Sei6sq1QJ6jOhIsQo
	 Z7m0RpHmMZQIl2ERxgtgfoOlyHHbY1zjeIkk1fn3hsmfnOXk0b1p/DW0TenYIL00ge
	 uCVH3/1CvL7SemR+jKutq6EMZ1COpw31d6niE/EvkrfkAjLnOYc2rkBGzxSzLtoVG8
	 O4D9vg7xMTrubrBNAbcqbEzfugmUf2Taf5iUYfZeX+5qsmBfQpVK1ppByqDuGATUGO
	 G3c9XKSXA5jWcLCPqWRlO+5Fjm/yXmB6MD3P92c07CiG3w4m+HT/T30EDEeaDhsD83
	 SvmtIPVDrLH1Q==
Date: Tue, 07 Apr 2026 10:55:13 +0200
Message-ID: <20260407083248.303293327@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Calvin Owens <calvin@wbinvd.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 Ingo Molnar <mingo@kernel.org>,
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
Subject: [patch 12/12] alarmtimer: Remove unused interfaces
References: <20260407083219.478203185@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

All alarmtimer users are converted to alarmtimer_start(). Remove the now
unused interfaces.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: John Stultz <jstultz@google.com>
Cc: Stephen Boyd <sboyd@kernel.org>
---
 include/linux/alarmtimer.h |    3 ---
 kernel/time/alarmtimer.c   |   44 --------------------------------------------
 2 files changed, 47 deletions(-)

--- a/include/linux/alarmtimer.h
+++ b/include/linux/alarmtimer.h
@@ -50,9 +50,6 @@ static __always_inline ktime_t alarm_get
 void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
 		void (*function)(struct alarm *, ktime_t));
 bool alarmtimer_start(struct alarm *alarm, ktime_t expires, bool relative);
-void alarm_start(struct alarm *alarm, ktime_t start);
-void alarm_start_relative(struct alarm *alarm, ktime_t start);
-void alarm_restart(struct alarm *alarm);
 int alarm_try_to_cancel(struct alarm *alarm);
 int alarm_cancel(struct alarm *alarm);
 
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -333,39 +333,6 @@ void alarm_init(struct alarm *alarm, enu
 EXPORT_SYMBOL_GPL(alarm_init);
 
 /**
- * alarm_start - Sets an absolute alarm to fire
- * @alarm: ptr to alarm to set
- * @start: time to run the alarm
- */
-void alarm_start(struct alarm *alarm, ktime_t start)
-{
-	struct alarm_base *base = &alarm_bases[alarm->type];
-
-	scoped_guard(spinlock_irqsave, &base->lock) {
-		alarm->node.expires = start;
-		alarmtimer_enqueue(base, alarm);
-		hrtimer_start(&alarm->timer, alarm->node.expires, HRTIMER_MODE_ABS);
-	}
-
-	trace_alarmtimer_start(alarm, base->get_ktime());
-}
-EXPORT_SYMBOL_GPL(alarm_start);
-
-/**
- * alarm_start_relative - Sets a relative alarm to fire
- * @alarm: ptr to alarm to set
- * @start: time relative to now to run the alarm
- */
-void alarm_start_relative(struct alarm *alarm, ktime_t start)
-{
-	struct alarm_base *base = &alarm_bases[alarm->type];
-
-	start = ktime_add_safe(start, base->get_ktime());
-	alarm_start(alarm, start);
-}
-EXPORT_SYMBOL_GPL(alarm_start_relative);
-
-/**
  * alarmtimer_start - Sets an alarm to fire
  * @alarm:	Pointer to alarm to set
  * @expires:	Expiry time
@@ -393,17 +360,6 @@ bool alarmtimer_start(struct alarm *alar
 }
 EXPORT_SYMBOL_GPL(alarmtimer_start);
 
-void alarm_restart(struct alarm *alarm)
-{
-	struct alarm_base *base = &alarm_bases[alarm->type];
-
-	guard(spinlock_irqsave)(&base->lock);
-	hrtimer_set_expires(&alarm->timer, alarm->node.expires);
-	hrtimer_restart(&alarm->timer);
-	alarmtimer_enqueue(base, alarm);
-}
-EXPORT_SYMBOL_GPL(alarm_restart);
-
 /**
  * alarm_try_to_cancel - Tries to cancel an alarm timer
  * @alarm: ptr to alarm to be canceled

