Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FB33B8BA1;
	Wed,  8 Apr 2026 11:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649276; cv=none; b=TXjm5ZAGYNF99+ZY+TfF2oEY+zfEkv2kkG0WEubbD2QVB02dvTHOQPbITMfjc5zh2fH4gdISTnuSSkLYNkXlisfNoouNSgRKTBOz12uHDUOzYCbO5t0+XEfscR948OL7J1j76MLexkaB2350W/DVb7i59LfKJnZ4YqLHmELAm3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649276; c=relaxed/simple;
	bh=i/wmEqzr8cLPxjWlHlsd+92dfmzqBOEHLkGGWjyw9LI=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=gr7iWNf5NXVCCrubHrBuXgLSi2+q2oEjP0x4VwtBj8ZvA/SQDfXsW5gLGktbXcF9Eq4zp/vDcUw1t9wguSoR6NMQV+jFT0vuCw0g3Vhqccd0nmmlZTbmI9EFMh4O45fePkcJiu3iBTFiiHeS/6Nk+YAVrtzgWu54xeXg3TBCgEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iyB1bTwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iyB1bTwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76911C19421;
	Wed,  8 Apr 2026 11:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649275;
	bh=i/wmEqzr8cLPxjWlHlsd+92dfmzqBOEHLkGGWjyw9LI=;
	h=Date:From:To:Cc:Subject:References:From;
	b=iyB1bTwkN+T08pJYvRFU5eniRw5AJo7Sm893nl3t1fkXfREHMYyh5j1ra1e7Vp8yS
	 TzXasolokBsFZJ4CEqS+Zsf+Img6CFTsRxClak5P98JNVMQvZxZ+OAfmCoCKlfFy0C
	 UTIxkgEXOOS2mCBYjFIM4p5Eh/hoKrT9dh3nZD/LdjIcARxhVMF+MUP3zqDdyz96H5
	 NJSmC6Ex8eaYtdmIb32tUQ3Of9Jf2VPrECZrr/XRpCkSUaSDeWqTP2zY24vXXoGAKj
	 dkwGt3f07u0s1l9xZWaUslyQ2SLw5JSCBJ9ijNXCs/mJTn3bQPGKGBpxZPzrmLJOvu
	 7jmoaGC9YNAog==
Date: Wed, 08 Apr 2026 13:54:33 +0200
Message-ID: <20260408114952.670899355@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Calvin Owens <calvin@wbinvd.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
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
Subject: [patch V2 11/11] alarmtimer: Remove unused interfaces
References: <20260408102356.783133335@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

All alarmtimer users are converted to alarm_start_timer(). Remove the now
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
 bool alarm_start_timer(struct alarm *alarm, ktime_t expires, bool relative);
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
  * alarm_start_timer - Sets an alarm to fire
  * @alarm:	Pointer to alarm to set
  * @expires:	Expiry time
@@ -393,17 +360,6 @@ bool alarm_start_timer(struct alarm *ala
 }
 EXPORT_SYMBOL_GPL(alarm_start_timer);
 
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

