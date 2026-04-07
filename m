Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1B039A800;
	Tue,  7 Apr 2026 08:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775552081; cv=none; b=pnSfIM0qHDT+gmIXKOekO1B7V2wsG9INdCW27+5QXskyUez5ctP0QZ7vDWaJ5tl72QZHXXZ1uiEs0pFmRqJK+O91IN3fT4pt16fjkSsfCv37ccKOQbXsvMuMbMLAzQet+UkyH0y4jt986rfO4gaV0XMUw6w2nbdNveM2uRyyCuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775552081; c=relaxed/simple;
	bh=UL+6LCFKPk7yFRK5fJynV3ISPtCdF2Q7VprzdKpG5nY=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=XJinogf5mieRT8HeTB34aYb9g8qBj31p4O9yWrLowDKfBSpYOgu9N5lndr3OmOSLB3nkeAmng/drdZToeEtnlbnMOoHd7yoGIaO+h3SeoKolcxq80BoryjZJc2FBGPttnmUoBYRL09klh1CQMclZ9EdXTwhgbsmaPYz2iSnpq/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dc+oyp3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dc+oyp3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3577C116C6;
	Tue,  7 Apr 2026 08:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775552081;
	bh=UL+6LCFKPk7yFRK5fJynV3ISPtCdF2Q7VprzdKpG5nY=;
	h=Date:From:To:Cc:Subject:References:From;
	b=Dc+oyp3HDzq2W0AHQxB+zsNiplHE4y7RN7NfWpV/DCznDKnLMSQoWq+MVs9GN00i2
	 opR4INWui9lEgMqTXmR1Wy0Hyq75xHwCuQHQzImwLD9EcSWfw0VAWXreqxOmXgh/dV
	 rdyQnC9PpKDAoPf5P7f1IX0/LKeswUNawNvRa4bdrMDdCRZQ05MjKxtSBRYoICXPl4
	 ysgI13NMqf2MFyEk1AUXbxA1MN9Bjci2QkTtBnfZgWK28EKi+F8zBNbdYSfQ8CG0b4
	 e/VoJ3R6R/945cQUaZjaqyPOWQRkgM6U19oZNIi3+sO2cJH1nvIV49ex/x1XNiTTmA
	 VkVtbr80y39TQ==
Date: Tue, 07 Apr 2026 10:54:38 +0200
Message-ID: <20260407083247.831143104@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 Calvin Owens <calvin@wbinvd.org>,
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
Subject: [patch 05/12] posix-timers: Handle the timer_[re]arm() return value
References: <20260407083219.478203185@kernel.org>
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
when the timer was already expired.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
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
 

