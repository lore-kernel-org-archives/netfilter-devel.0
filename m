Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899FD39A7F8;
	Tue,  7 Apr 2026 08:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775552086; cv=none; b=HHPlYP+eHvGoVdqgYf0gE6pQk1FQhAQN1EKYBnMXeCNt/j8GWrEO+TTGyugmYBbCaqqOye1nYpfo3nShgeZ/upr1yhz0rdQ6GMfVcmeab0yrEcuIciU5WB+TMVPDng5OcxVkD3cLBes4D29WzXS5vFls4xz5jf82Vqsy9tZt6uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775552086; c=relaxed/simple;
	bh=SjBcneGtGEBBNpNj//JNTkqgCJxRCk2wahLRcyQu83M=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=IfoR/nuX+re4LJatjJiAaFKOCRl4KFmS2fkNRNVTwHb1PEbSt/gcfafy3OQgNMgvT85vhP83lXyJwvFsNVdVaDXi8PeknpbxM5Z8AlRfQVd2jTnpDqLSkmxddP322BTPHKVb9EX637ArAbU5teb9c859ibHKoICKhikOnsbJDNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndIuyLJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndIuyLJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3B3C2BC9E;
	Tue,  7 Apr 2026 08:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775552086;
	bh=SjBcneGtGEBBNpNj//JNTkqgCJxRCk2wahLRcyQu83M=;
	h=Date:From:To:Cc:Subject:References:From;
	b=ndIuyLJnqI4xTXK8fAk0gJhLGYSqS9IVQnjgQr9yi/hh/j8Z3mUC0glA8C2s4E3AM
	 KL3ziHhdsMj7VZm01vEc18AMd3vMBigSAblgHUV/0NbRGR9GOdHTuJNRZieV0eZ8lx
	 JTco+fCBHhjilmukPJ1hf+QQMGiACiN1fdB6VX4XwN30paB5ZjbHw7nXrCs5CxfqcF
	 vDdStCbbkezwEPf4VASCsLggWtcRWidwcVbiNg49LmV8olNqALIMg1kCv2MIezjUea
	 hWgvdl0UcVAZEUt4UImTRaj5IUSaxPZ+f/E/OF3KljHfDAOlrZ/8oz5pBMHDtdDA1P
	 lfJHo8jlIpypg==
Date: Tue, 07 Apr 2026 10:54:43 +0200
Message-ID: <20260407083247.898494239@kernel.org>
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
Subject: [patch 06/12] posix-timers: Switch to hrtimer_start_expires_user()
References: <20260407083219.478203185@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Switch the arm and rearm callbacks for hrtimer based posix timers over to
hrtimer_start_expires_user() so that already expired timers are not
queued. Hand the result back to the caller, which then queues the signal.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/time/posix-timers.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -293,8 +293,7 @@ static bool common_hrtimer_rearm(struct
 	struct hrtimer *timer = &timr->it.real.timer;
 
 	timr->it_overrun += hrtimer_forward_now(timer, timr->it_interval);
-	hrtimer_restart(timer);
-	return true;
+	return hrtimer_start_expires_user(timer, HRTIMER_MODE_ABS);
 }
 
 static bool __posixtimer_deliver_signal(struct kernel_siginfo *info, struct k_itimer *timr)
@@ -829,9 +828,11 @@ static bool common_hrtimer_arm(struct k_
 		expires = ktime_add_safe(expires, hrtimer_cb_get_time(timer));
 	hrtimer_set_expires(timer, expires);
 
-	if (!sigev_none)
-		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
-	return true;
+	/* For sigev_none pretend that the timer is queued */
+	if (sigev_none)
+		return true;
+
+	return hrtimer_start_expires_user(timer, HRTIMER_MODE_ABS);
 }
 
 static int common_hrtimer_try_to_cancel(struct k_itimer *timr)

