Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E69C38C434;
	Wed,  8 Apr 2026 11:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649225; cv=none; b=S9intXw45/HmCToV4U6vQKJpPw/9QWjbi4wgZavltOcf2Fx5iXn0xTn1tmIETL056CsCGQl8B8+AX/+4KpsbISlZjv3wWOnO4HBQ5ZI2e7LY+vbDNQsMCQ2bxR4SmwZMy64PWQPx/Ea0oQmdDmTvw2HwQr0xT0MLDXeyXM8vP1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649225; c=relaxed/simple;
	bh=7Psi4PCmg4NxRRGlQRXmH+F3BN6jVuP2qTBx5cq2iQE=;
	h=Date:Message-ID:From:To:Subject:cc; b=RkYI5fBn4bfjJ7iyapi+N0Dab1hru6CRFM076YPTtrvTyjyUFqyvz+BdqmYp1ecWJRsJ+2yyLIQcWP8t6lmB2ZudsTLqjRehKQooXCWQqRiio84ISeDzWYhhmFEsTD2rDwE27lsc+l2o8Zdiiac++aTlpsgGBbudH/92yBfeikQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsGJ/oyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsGJ/oyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E08C19421;
	Wed,  8 Apr 2026 11:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649224;
	bh=7Psi4PCmg4NxRRGlQRXmH+F3BN6jVuP2qTBx5cq2iQE=;
	h=Date:From:To:Subject:cc:From;
	b=lsGJ/oyOvX6cfoHwkNDEvgoFQSDMESpcA7Am+qQqDX+ZczSfpk7BYkv1wxn/o+Y6x
	 uV70JUMAWZQzZVTa4JXQVPgruXx8VEkY8kRAOSxt/0U9/KY79XCbOCWoa36mOHp++n
	 cLbbn5Yp/9dKUFYtiPGRKT+LzTESjO0um/rXgHWuKcDcgp0caxdQcg1ivEDbv+MuTG
	 R5m9V1pZUDtUZsq/xIGGTNooKNCKPEGayFkS2CC7P20z5WN3bdaMCQhUtBzOUDptor
	 sfAxoAJoNL62cfrL/HoXNfnC8F0A/KeFxL4x5SUIQNk8vw11q+9jO2TOfsdK0yIPQm
	 TyhVHe5A8x0Bw==
Date: Wed, 08 Apr 2026 13:53:41 +0200
Message-ID: <20260408102356.783133335@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch V2 00/11] hrtimers: Prevent hrtimer interrupt starvation
cc: Calvin Owens <calvin@wbinvd.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
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

This is a follow up to V1 which can be found here:

 https://lore.kernel.org/lkml/20260407083219.478203185@kernel.org

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

The first patch in the V1 series changes the clockevent set next event
mechanism to prevent reprogramming of the clockevent device when the
minimum delta value was programmed unless the new delta is larger than
that. It's a less convoluted variant of the patch which was posted in the
above linked thread and was confirmed to prevent the starvation problem.

But that's only to be considered the last resort because it results in an
insane amount of avoidable hrtimer interrupts. That patch has been merged
into the tip tree already.

The problem of user controlled timers is that the input value is only
sanity checked vs. validity of the provided timespec and clamped to be in
the maximum allowable range. But for performance reasons for in kernel
usage there is no check whether a to be armed timer might have been expired
already at enqueue time.

This series addresses this by providing a separate interface to arm user
controlled timers. This works the same way as the existing
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

Changes vs. V1:

   - Dropped the clockevents patch as it is already merged

   - Rebased on tip timers/core

   - Moved the user check into hrtimer_start_range_ns_user() - Peter

   - Renamed alarmtimer_start() to alarm_start_timer() - Peter

   - Picked up tags as appropriate
   
The series applies against tip timers/core and is also available from git:

    git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git hrtimer-exp-v2

Thanks,

	tglx
---
 drivers/power/supply/charger-manager.c |   12 +-
 fs/timerfd.c                           |  117 ++++++++++++++++-----------
 include/linux/alarmtimer.h             |    9 +-
 include/linux/hrtimer.h                |   20 ++++
 include/trace/events/timer.h           |   13 +++
 kernel/time/alarmtimer.c               |   70 +++++++---------
 kernel/time/hrtimer.c                  |  140 ++++++++++++++++++++++++++++-----
 kernel/time/posix-cpu-timers.c         |   18 ++--
 kernel/time/posix-timers.c             |   35 +++++---
 kernel/time/posix-timers.h             |    4 
 net/netfilter/xt_IDLETIMER.c           |   24 ++++-
 11 files changed, 320 insertions(+), 142 deletions(-)

