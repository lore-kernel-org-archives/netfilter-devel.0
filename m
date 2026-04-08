Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95D83B9D98;
	Wed,  8 Apr 2026 11:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649250; cv=none; b=Y2JU4dpbDvoVFLqy/UwlKxe7/4vQMTun36S38A8b04ofiVFOZhfqt731HQg04XsaxxYS8XSKx9VjSp5esenRgxeZ0WPF+ihde/n1zYAa9DhfzP8R64l/iujNxVS4oCSMrHcmmEGi1V6SQGy8k8Fa//ZpNJeMKqRY9/cbOm1I1Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649250; c=relaxed/simple;
	bh=9cyhTTNUI7vvmGeh4y3PgC23aszprgLvvdj3n9KWWNo=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=cvVW0x84i+/6iIjVmtDegK3VHfUjO72I1piJiJ0Ivj8toN/2JnSHkXUydJOAXbWqMa3szxhIHH48EsJt1tyaCz/hvadPKtOPIDQLyfNzY+PZicMsJdu75zEeJV7VGkIRKgE+tS8z6rCV7enF/ldioOKQMl+VQkMPRQgVc9ksH8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=upKcUMJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="upKcUMJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549D8C19424;
	Wed,  8 Apr 2026 11:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649250;
	bh=9cyhTTNUI7vvmGeh4y3PgC23aszprgLvvdj3n9KWWNo=;
	h=Date:From:To:Cc:Subject:References:From;
	b=upKcUMJWCV0W6vbYYCBoBXgS6F0Og3/hxcaGGNNVFz+wGufJ9kL2JIGYHwlPa+4vf
	 Y8Tbnzq5R/lUO+pLlNkaufE6ugG+v0NmGgsoyAgjoRcbK4MztPNSPSKkXZ9bQajrrv
	 kDtzhH9Tu+R2bdYRFd6QXMQpM7LXUezMcyY84oARjMe4tIgPcH+W2geFsKva3LLzwI
	 n3tTm5PQ8s5hcvMChP5AoTa2qIvNkcZSYjkSV9EVuFtxBxxMG0RBzSczsy5DdPw+Zq
	 Zfjmy2X1VAWVFzIkFhnqmrNPqGB6gT7z4/v81w/0A25kxxRfQLuZ9BjW2KWu3zF12v
	 RXy5G5bYt8+Ag==
Date: Wed, 08 Apr 2026 13:54:06 +0200
Message-ID: <20260408114952.266001916@kernel.org>
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
Subject: [patch V2 05/11] posix-timers: Switch to hrtimer_start_expires_user()
References: <20260408102356.783133335@kernel.org>
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
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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



