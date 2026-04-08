Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480333B9D98;
	Wed,  8 Apr 2026 11:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649245; cv=none; b=RvV9WDn1UNKSuyKhUFM645aHiMzbleiarp+oePgMBGYcDW9uF+w4P16WjBoqo5eZmMo3z1l1fCHJZPYK2hPM9MyPw71shbhGRlvcFzDTwjbxHBa37oEh4md10kCqXkN6ZfKBrBY8whpXqse0wU26Q75+s5M2fsCpWZ63jRFh/6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649245; c=relaxed/simple;
	bh=C9YlNozrQiTNSBjvrTYffGhKh+u7r91EEMREnD1qMfE=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=Uub1BpEHk+MCjIU40/+3Dfpp+tpHJKYuvL+Db+rK0HbWbhPwJrEmqeXDZOlhN1RhOUtv8U9rWDy1C5Z/RkUduCTdEf8ww+p2ppVBnn2v4/eAc4MOzZqyfOsG8Cy9wo7XLzS28xb3Y3HM3rFGRMHqnyfle+hPTAgIpEMilEl4nQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTd0P04Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTd0P04Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B744C19424;
	Wed,  8 Apr 2026 11:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649245;
	bh=C9YlNozrQiTNSBjvrTYffGhKh+u7r91EEMREnD1qMfE=;
	h=Date:From:To:Cc:Subject:References:From;
	b=cTd0P04QcW5sWAV4M3ecA9ZwxuQBkVlEfmkCIPp8nQ/F4/6lVOWvXT7jxqAUk2sAX
	 s3EbPUYjjJI8hhcC0p1xpvFTOY/5ZtAnNAasYrfciwcZrKMu1SvFRCUtrgG1hzQYH0
	 7mutRly4w14FSfisZHRYME0s2HKa3y6KdyBoujOKJCG0CgYojtG3N+F0d7Kfv4sRdl
	 gYCyixZut4E5c6mVxFgLjFIjjW5GIPDWWDNm9CIvL195lk1Jmo3HsYbTlf3ziueIzF
	 UHNs6riSum5VfwPitpt9Zjlf5pOu4D/q6mHnsRguNsit13UlUEbdT6A9/v8gDFsfm2
	 hDqWXeZrXHVMA==
Date: Wed, 08 Apr 2026 13:54:01 +0200
Message-ID: <20260408114952.198028466@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 Calvin Owens <calvin@wbinvd.org>,
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
Subject: [patch V2 04/11] posix-timers: Handle the timer_[re]arm() return
 value
References: <20260408102356.783133335@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

The [re]arm callbacks will return true when the timer was queued and false
if it was already expired at enqueue time.

In both cases the call sites can trivially queue the signal right there,
when the timer was already expired. That avoids a full round trip through
the hrtimer interrupt.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Frederic Weisbecker <frederic@kernel.org>

---
 kernel/time/posix-timers.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -299,6 +299,8 @@ static bool common_hrtimer_rearm(struct
 
 static bool __posixtimer_deliver_signal(struct kernel_siginfo *info, struct k_itimer *timr)
 {
+	bool queued;
+
 	guard(spinlock)(&timr->it_lock);
 
 	/*
@@ -312,12 +314,18 @@ static bool __posixtimer_deliver_signal(
 	if (!timr->it_interval || WARN_ON_ONCE(timr->it_status != POSIX_TIMER_REQUEUE_PENDING))
 		return true;
 
-	timr->kclock->timer_rearm(timr);
-	timr->it_status = POSIX_TIMER_ARMED;
+	/* timer_rearm() updates timr::it_overrun */
+	queued = timr->kclock->timer_rearm(timr);
+
 	timr->it_overrun_last = timr->it_overrun;
 	timr->it_overrun = -1LL;
 	++timr->it_signal_seq;
 	info->si_overrun = timer_overrun_to_int(timr);
+
+	if (queued)
+		timr->it_status = POSIX_TIMER_ARMED;
+	else
+		posix_timer_queue_signal(timr);
 	return true;
 }
 
@@ -905,9 +913,13 @@ int common_timer_set(struct k_itimer *ti
 		expires = timens_ktime_to_host(timr->it_clock, expires);
 	sigev_none = timr->it_sigev_notify == SIGEV_NONE;
 
-	kc->timer_arm(timr, expires, flags & TIMER_ABSTIME, sigev_none);
-	if (!sigev_none)
-		timr->it_status = POSIX_TIMER_ARMED;
+	if (kc->timer_arm(timr, expires, flags & TIMER_ABSTIME, sigev_none)) {
+		if (!sigev_none)
+			timr->it_status = POSIX_TIMER_ARMED;
+	} else {
+		/* Timer was already expired, queue the signal */
+		posix_timer_queue_signal(timr);
+	}
 	return 0;
 }
 



