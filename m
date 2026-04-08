Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46AB3B27F9;
	Wed,  8 Apr 2026 11:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649258; cv=none; b=Cndn6ymEpAHpGq9g6oevKC6/0p6ehwvFVWtxcmPPTx6IW4v4hJO+IoROip/FELVbPPsX+nNSFCpyI9P2FHuYFqi85TX+LOIdWMfmnAa3C9GOLjkBtv4Jlgv+WlEx42N+8p8sApLdxJDOO5K+jNuH3Dj7ZSSOwqWUJjNKv1R83dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649258; c=relaxed/simple;
	bh=vG3iCoV1k8fk4KDtM9Pf5Kh5C80uU4kxJ0l9q20QI6Y=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=WWrxFVZciMjirrJLeqzqktc9KewApbO5jIGvlWLeFkH6RoTLyRFMr3lkG1ekZhcD/BfGdTB7NyeA9AZTtCCeBTibOq2n9Ope/gPMJBaWSp7y3QOPssRNmdzlZNvMp6t5SKctbhJzHmsncUulMMpL/g4GzSX4YqJ0Jyk9mj6VG2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EHc079Co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EHc079Co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55788C19421;
	Wed,  8 Apr 2026 11:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649258;
	bh=vG3iCoV1k8fk4KDtM9Pf5Kh5C80uU4kxJ0l9q20QI6Y=;
	h=Date:From:To:Cc:Subject:References:From;
	b=EHc079CovQfn3Hb67IAa3y5x2eFgTcUByt7J7brNa8lC2z93ZsUfavTUqwXKT298r
	 4nPOidEPGfTZWPbSRZZEuINE+OrlB1dO1ThVupyA13zeLqcQPv+EVQnrF8muXJHiWA
	 UqDpPIg853b9QfDoDBUMHltGfZjvs8RwCXe+Sr8yVjD9e22j2x+8EYcD2ObiY9r7Qu
	 yhrl7wRZ3A48nsIcyw0Ex+nApnjNOLWOJg+SvzGmd3obna9XqlIlvElSbuN9HGJ107
	 rXrHccNiXnIUMDg6koAaxLdMxuUg9daC7aS9Hn1E06jsIdv1VyvhOGHdO9jPWxNc5z
	 3kqpVdAFpozNA==
Date: Wed, 08 Apr 2026 13:54:16 +0200
Message-ID: <20260408114952.400451460@kernel.org>
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
Subject: [patch V2 07/11] alarmtimer: Convert posix timer functions to
 alarm_start_timer()
References: <20260408102356.783133335@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Use the new alarm_start_timer() for arming and rearming posix interval
timers and for clock_nanosleep() so that already expired timers do not go
through the full timer interrupt cycle.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: John Stultz <jstultz@google.com>
Cc: Stephen Boyd <sboyd@kernel.org>
---
V2: Rename to alarm_start_timer()
---
 kernel/time/alarmtimer.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -560,8 +560,7 @@ static bool alarm_timer_rearm(struct k_i
 	struct alarm *alarm = &timr->it.alarm.alarmtimer;
 
 	timr->it_overrun += alarm_forward_now(alarm, timr->it_interval);
-	alarm_start(alarm, alarm->node.expires);
-	return true;
+	return alarm_start_timer(alarm, alarm->node.expires, false);
 }
 
 /**
@@ -625,11 +624,16 @@ static bool alarm_timer_arm(struct k_iti
 
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
+	return alarm_start_timer(&timr->it.alarm.alarmtimer, expires, false);
 }
 
 /**
@@ -736,7 +740,9 @@ static int alarmtimer_do_nsleep(struct a
 	alarm->data = (void *)current;
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
-		alarm_start(alarm, absexp);
+		if (!alarm_start_timer(alarm, absexp, false))
+			alarm->data = NULL;
+
 		if (likely(alarm->data))
 			schedule();
 

