Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC5113959D;
	Tue,  7 Apr 2026 08:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775552056; cv=none; b=eTxdr9G6JgaLAiZQ9p6d8W/oi9dEk4FnIFFIu0nxJXekK31jUp+a6+tOv02fv/Eb98t3c5FJzhWIhoDtgL/dofWM73JyYzu61knTFnEK7nGmt9ohGbciUtX80A2UzkFKQaN9bk5/hbcKW8KsRvvEv9pEZMRiK5LfK6icIc79+88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775552056; c=relaxed/simple;
	bh=/UVoU8W1t8K+EOuKoQSmXAaZim6qPp6ckYNHHxZ9hfM=;
	h=Date:Message-ID:From:To:Subject:cc; b=WUpx0Bt6GCSXph0QMM1Z28b3R38hn2BGX9e3LYld5LC06Z9Lxsn2Rt8LuldhPZJupoOX7hQCGFyoEeIhgwi0my/LLbW+mOXhYSV7VNYFy1E2eJqGrWMigMUYlMWLlbdI2Iilcd6V+j2npEVIw9+qNQlbGYPpTxswZp39LhA+It8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HugIpB0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HugIpB0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4457C116C6;
	Tue,  7 Apr 2026 08:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775552055;
	bh=/UVoU8W1t8K+EOuKoQSmXAaZim6qPp6ckYNHHxZ9hfM=;
	h=Date:From:To:Subject:cc:From;
	b=HugIpB0fmydogp5EXRfDc4cCc5LM83rTvVXhu5K0HStS9X6dGvHkUivRxy1LpkvCI
	 kCp5zccEBfFQkwsWbW9SOKKPD3VM+PwcPmUULsXhj2Gwo4EcF7OAOHtsa+1vOXD3dV
	 MGvYCMPtUTACJI8xtB8ErH+jORoSYazaTyozMRLHbpUXr5HWa/VpOxCPiCBcM3FaQ9
	 2aueWXdJ5OXgIW982W5kscBjtD0CzVGXdO6tXe00RtRTqqJSls760tRXvh4l93mH1k
	 hkIZvX53+xSxZtE/WmrN/Wbo/yAuWsch0IEWYF8/5GT7g/TubOn+C6Ko6M7wmbn2BY
	 Chc6BEo/CkDRg==
Date: Tue, 07 Apr 2026 10:54:12 +0200
Message-ID: <20260407083219.478203185@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 00/12] hrtimers: Prevent hrtimer interrupt starvation
cc: Calvin Owens <calvin@wbinvd.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
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
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

Calvin reported an odd NMI watchdog lockup which claims that the CPU locked
up in user space:

  https://lore.kernel.org/lkml/acMe-QZUel-bBYUh@mozart.vkv.me/

He provided a reproducer, which sets up a timerfd based timer and then
rearms it in a loop with an absolute expiry time of 1ns.

As the expiry time is in the past, the timer ends up as the first expiring
timer in the per CPU hrtimer base and the clockevent device is programmed
with the minimum delta value. If the machine is fast enough, this ends up
in a endless loop of programming the delta value to the minimum value
defined by the clock event device, before the timer interrupt can fire,
which starves the interrupt and consequently triggers the lockup detector
because the hrtimer callback of the lockup mechanism is never invoked.

The first patch in the series changes the clockevent set next event
mechanism to prevent reprogramming of the clockevent device when the
minimum delta value was programmed unless the new delta is larger than
that. It's a less convoluted variant of the patch which was posted in the
above linked thread and was confirmed to prevent the starvation problem.

But that's only to be considered the last resort because it results in an
insane amount of avoidable hrtimer interrupts.

The problem of user controlled timers is that the input value is only
sanity checked vs. validity of the provided timespec and clamped to be in
the maximum allowable range. But for performance reasons for in kernel
usage there is no check whether a to be armed timer might have been expired
already at enqueue time.

The rest of the series addresses this by providing a separate interface to
arm user controlled timers. This works the same way as the existing
hrtimer_start_range_ns(), but in case that the timer ends up as the first
timer in the clock base after enqueue it provides additional checks:

      - Whether the timer becomes the first expiring timer in the CPU base.

      	If not the timer is considered to expire in the future as there is
	already an earlier event programmed.

      - Whether the timer has expired already by comparing the expiry value
        against current time.

	If it is expired, the timer is removed from the clock base and the
	function returns false, so that the caller can handle it. That's
	required because the function cannot invoke the callback as that
	might need to acquire a lock which is held by the caller.

This function is then used for the user controlled timer arming interfaces
mainly by converting hrtimer sleeper over to it. That affects a few in
kernel users too, but the overhead is minimal in that case and it spares a
tedious whack the mole game all over the tree.

The other usage sites in posixtimers, alarmtimers and timerfd are converted
as well, which should cover the vast majority of user space controllable
timers as far as my investigation goes.

The series applies against Linux tree and is also available from git:

    git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git hrtimer-exp-v1

There needs to be some discussion about the scope of backporting. The first
patch preventing the stall is obviously a backport candidate. The remaining
series can be obviously argued about, but in my opinion it should be
backported as well as it prevents stupid or malicious user space from
generating tons of pointless timer interrupts.

Thanks,

	tglx
---
 drivers/power/supply/charger-manager.c |   12 +-
 fs/timerfd.c                           |  115 +++++++++++++++-----------
 include/linux/alarmtimer.h             |    9 +-
 include/linux/clockchips.h             |    2 
 include/linux/hrtimer.h                |   20 +++-
 include/trace/events/timer.h           |   13 +++
 kernel/time/alarmtimer.c               |   70 +++++++---------
 kernel/time/clockevents.c              |   23 +++--
 kernel/time/hrtimer.c                  |  142 +++++++++++++++++++++++++++++----
 kernel/time/posix-cpu-timers.c         |   18 ++--
 kernel/time/posix-timers.c             |   35 +++++---
 kernel/time/posix-timers.h             |    4 
 kernel/time/tick-common.c              |    1 
 kernel/time/tick-sched.c               |    1 
 net/netfilter/xt_IDLETIMER.c           |   24 ++++-
 15 files changed, 341 insertions(+), 148 deletions(-)


