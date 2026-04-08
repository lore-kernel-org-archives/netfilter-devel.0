Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690B73BB9F3;
	Wed,  8 Apr 2026 11:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649235; cv=none; b=J65AcozGT0/CIflFnRcEbrHKGRRL6o1eJltHPrY5AvfpFdKgewfUljVU9c5ysBpa57lDixsjIoLZ3/KYoiqul7WqT7z0dbD2TnNihTnBw9O2SNvbOZtY7OajHME1Wp1sCMYMHKbYw5ZuPLxypKVyVRiwGyDPgJ/HaifZ9re1e3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649235; c=relaxed/simple;
	bh=l6wY0qxLdk/x5El2G70gv1eRbDyNVtHmMtimpYI4jGY=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=Uk4fzTPAFMRv+rGy3Hq2CAjc/5g4tb4cGfoNWD9UIaMXADL8Xj57vbnqY9w1z2ELMzKh9y1cRpkLXbdiLoXAoEtaNNipj1eREt8EjkEPexOFnNixQpS19Vp01rCPOoClGmqN+Q1otkt4BUj0PhmZednYOqZbkr5qIaevDmaUQ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvHoN7iD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvHoN7iD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1547C2BCB5;
	Wed,  8 Apr 2026 11:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649235;
	bh=l6wY0qxLdk/x5El2G70gv1eRbDyNVtHmMtimpYI4jGY=;
	h=Date:From:To:Cc:Subject:References:From;
	b=fvHoN7iDlcOoDX5wUQ0iBHqPn12l/BthKcIDoc/dGoGhT8O2JjBvH6HjzqASJvUmO
	 3Ux9oTqGupW/zM2tPAcLOZMEIrvlzcThPj9QtVhVJo2Gq/gZ+KLpK1iAltEUYnOY/O
	 JH9W4acyuLHyYFvFLqpeT8k0/hoLprLNo5WvvVp3MWbYvS+zCjv/dzcqsV4098Zw+z
	 eKy46J9CYGtDtH9aTVcBCeWe+JkM/LGi+vZFuLPcQqKYCUiykvZG/4LklmyiqUD4VW
	 5nTc6a8v0+X6LaujPoWjBDUVaTc6dndy36u5/2HgJASlvUy7UjwB9s9d0KfUjxgy58
	 gmwC4W+jsxK2g==
Date: Wed, 08 Apr 2026 13:53:52 +0200
Message-ID: <20260408114952.062400833@kernel.org>
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
Subject: [patch V2 02/11] hrtimer: Use hrtimer_start_expires_user() for
 hrtimer sleepers
References: <20260408102356.783133335@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Most hrtimer sleepers are user controlled and user space can hand arbitrary
expiry values in as long as they are valid timespecs. If the expiry value
is in the past then this requires a full loop through reprogramming the
clock event device, taking the hrtimer interrupt, waking the task and
reprogram again.

Use hrtimer_start_expires_user() which avoids the full round trip by
checking the timer for expiry on enqueue.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Frederic Weisbecker <frederic@kernel.org>

---
 kernel/time/hrtimer.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2152,7 +2152,11 @@ void hrtimer_sleeper_start_expires(struc
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && sl->timer.is_hard)
 		mode |= HRTIMER_MODE_HARD;
 
-	hrtimer_start_expires(&sl->timer, mode);
+	/* If already expired, clear the task pointer and set current state to running */
+	if (!hrtimer_start_expires_user(&sl->timer, mode)) {
+		sl->task = NULL;
+		__set_current_state(TASK_RUNNING);
+	}
 }
 EXPORT_SYMBOL_GPL(hrtimer_sleeper_start_expires);
 



