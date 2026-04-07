Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF8739A7E5;
	Tue,  7 Apr 2026 08:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775552096; cv=none; b=PbSKRZtuU1oTUQx8s71NRqLueEc+13VnHwgIglxoF3FZeDk0ekNMSgnnXJxxlAk2E1zayKURrLP3M1dbrZCPWk0Q0Y4+gTFTCPHObWTxyK/MdIzDcbbD9vJPIgL44OV5dS3sPXKrrrfp0Sq3SzeeYhfHfwCqzin+IL5L0LbNEkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775552096; c=relaxed/simple;
	bh=SGqb2Nn/k7ufjxJEqlr54Yc4uqryYsKlaFtjHcAKMnA=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=gA3b/DZGfSqtSo+kudHxZdPJlMnIaq1S/TlQuQXeNpUTyLRg8h9ADreqKG9MbqdgiAH0ZPKzNHciIGnQmjoNDw8Hrbs0N73E20ihuXF3IsQOlwhhan9o64mVvLjnFk2ZJlpRHbzOUBOs9pnmsioYF89yU4TcoF8Nt3PYC4K0kEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uXYP2mPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uXYP2mPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E21C2BCB1;
	Tue,  7 Apr 2026 08:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775552096;
	bh=SGqb2Nn/k7ufjxJEqlr54Yc4uqryYsKlaFtjHcAKMnA=;
	h=Date:From:To:Cc:Subject:References:From;
	b=uXYP2mPtISsacH9fy9EJuFy4Trw0qj4yNykTHl4pjDjZfkkniz6W2Dzi+hEQJahkJ
	 uWOGIWvrO1JzKx15louDi4it6yg1tzfakFRXyb+QrDw8w6o+nPHNXtux4Kp+3I1tw7
	 wJ4XkBnKJh76eUNHSKCDKV0Q4Eg0BvZcUkp6JSKh3DZp2YUSnWW1JGaA/vqrMkjHPp
	 EDJcIaN8r0dYv4YQgqq8Qnt7l3a3o+Ldw1IVYvoMb02z9cKM0yOIweaF7LrfYR7QSW
	 qBnkERgrjTO45WN+HI4XrB8Rh44jcY1s9O9VdRLTC2smXp5yXgKB1p7j+f4MEFsT90
	 0KIcOFpN6L1DA==
Date: Tue, 07 Apr 2026 10:54:53 +0200
Message-ID: <20260407083248.035227538@kernel.org>
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
Subject: [patch 08/12] alarmtimer: Convert posix timer functions to
 alarmtimer_start()
References: <20260407083219.478203185@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Use the new alarmtimer_start() for arming and rearming posix interval
timers and for clock_nanosleep() so that already expired timers do not go
through the full timer interrupt cycle.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: John Stultz <jstultz@google.com>
Cc: Stephen Boyd <sboyd@kernel.org>
---
 kernel/time/alarmtimer.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -556,8 +556,7 @@ static bool alarm_timer_rearm(struct k_i
 	struct alarm *alarm = &timr->it.alarm.alarmtimer;
 
 	timr->it_overrun += alarm_forward_now(alarm, timr->it_interval);
-	alarm_start(alarm, alarm->node.expires);
-	return true;
+	return alarmtimer_start(alarm, alarm->node.expires, false);
 }
 
 /**
@@ -621,11 +620,16 @@ static bool alarm_timer_arm(struct k_iti
 
 	if (!absolute)
 		expires = ktime_add_safe(expires, base->get_ktime());
-	if (sigev_none)
+
+	/*
+	 * sigev_none needs to update the expires value and pretend
+	 * that the timer is queued
+	 */
+	if (sigev_none) {
 		alarm->node.expires = expires;
-	else
-		alarm_start(&timr->it.alarm.alarmtimer, expires);
-	return true;
+		return true;
+	}
+	return alarmtimer_start(&timr->it.alarm.alarmtimer, expires, false);
 }
 
 /**
@@ -732,7 +736,9 @@ static int alarmtimer_do_nsleep(struct a
 	alarm->data = (void *)current;
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
-		alarm_start(alarm, absexp);
+		if (!alarmtimer_start(alarm, absexp, false))
+			alarm->data = NULL;
+
 		if (likely(alarm->data))
 			schedule();
 

