Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4A73806A1;
	Fri, 10 Apr 2026 20:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775854330; cv=none; b=dUJ+R2M207IBv8ZLgzRkkpbA5FkC44xg1zWgpCgEQ8rSun9AtixU9zqBQErITxUFO3HCNUwJ8ZbAB7+CdRNkRIOwEYr5IVvGKCqUnxH98kL44GbxZ4ykKtQlvNyvX1HcUGGEGxCGUfbtw4wDOQ4t/NbbU7BW4nOHema6WyvLewk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775854330; c=relaxed/simple;
	bh=hBqpsCVdBkMH3lEvzZjgPQlx4m7L2aIZuZIfc35yxMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hLN/nRPfq2mx/s0CxcMimK09y8Fd8p2BA9O3eJlq4jklK6yAdj9Ck3lbjG8Q+/4x5P+bB0VelkzjswFqdLYe1JBkFvaQt9WpGWy208rZAkVNsdKmOCg6nYAmZALETguuZMVe9f1B5lz0u240eqqgYhia3tmc82DUjhUorcwDAVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LkPaaR1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LkPaaR1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AF0C19421;
	Fri, 10 Apr 2026 20:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775854330;
	bh=hBqpsCVdBkMH3lEvzZjgPQlx4m7L2aIZuZIfc35yxMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LkPaaR1xRFqDx54O67j4HSoPLu47W6nIYCxJYd3O0OcKuVWWFKtVAELoM+emOfe2M
	 xAq01klxGmncNFQ5pVyXlRfHFRTnDPJBnpYkPrUqUiQyYrT5staWKtvAeQHqrrsOW6
	 oPi4cb1XEhHPfSDWkLn2bF+VHYrsHqdIhk7J8Cjk7XIYsAOGmp6UUTJhaQlo7/bobw
	 o4n4v8eliqMr5ecBxiUtoUZYwVvvqYuPczwGAc46iaNI/JLyT9UqQMBTiFxFNZbvIy
	 3WGqZiK414YBZAJgDjnJ+f/CGivBXH8I99MTqKZBaBcSEoYu7fOKlCln30wZVvfd6a
	 tk9PQlaDgsivQ==
Date: Fri, 10 Apr 2026 13:52:03 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@kernel.org>, John Stultz <jstultz@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 01/12] clockevents: Prevent timer interrupt starvation
Message-ID: <20260410205203.GA3922321@ax162>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407083247.562657657@kernel.org>

Hi Thomas,

On Tue, Apr 07, 2026 at 10:54:17AM +0200, Thomas Gleixner wrote:
> From: Thomas Gleixner <tglx@kernel.org>
> 
> Calvin reported an odd NMI watchdog lockup which claims that the CPU locked
> up in user space. He provided a reproducer, which sets up a timerfd based
> timer and then rearms it in a loop with an absolute expiry time of 1ns.
> 
> As the expiry time is in the past, the timer ends up as the first expiring
> timer in the per CPU hrtimer base and the clockevent device is programmed
> with the minimum delta value. If the machine is fast enough, this ends up
> in a endless loop of programming the delta value to the minimum value
> defined by the clock event device, before the timer interrupt can fire,
> which starves the interrupt and consequently triggers the lockup detector
> because the hrtimer callback of the lockup mechanism is never invoked.
> 
> As a first step to prevent this, avoid reprogramming the clock event device
> when:
>      - a forced minimum delta event is pending
>      - the new expiry delta is less then or equal to the minimum delta
> 
> Thanks to Calvin for providing the reproducer and to Borislav for testing
> and providing data from his Zen5 machine.
> 
> The problem is not limited to Zen5, but depending on the underlying
> clock event device (e.g. TSC deadline timer on Intel) and the CPU speed
> not necessarily observable.
> 
> This change serves only as the last resort and further changes will be made
> to prevent this scenario earlier in the call chain as far as possible.
> 
> Fixes: d316c57ff6bf ("[PATCH] clockevents: add core functionality")
> Reported-by: Calvin Owens <calvin@wbinvd.org>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Link: https://lore.kernel.org/lkml/acMe-QZUel-bBYUh@mozart.vkv.me/

This change in -next as commit 1c2eabb8805d ("clockevents: Prevent timer
interrupt starvation") appears to make one of my test machines
consistently lock up on boot (at least I never get to userspace). Most
of the time I get stall messages such as

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu:    14-...!: (20 GPs behind) idle=f380/0/0x0 softirq=1272/1273 fqs=4 (false positive?)
  rcu:    (detected by 2, t=60002 jiffies, g=3673, q=12382 ncpus=16)
  Sending NMI from CPU 2 to CPUs 14:
  NMI backtrace for cpu 14 skipped: idling at cpu_idle_poll.isra.0+0x50/0x170
  rcu: rcu_preempt kthread timer wakeup didn't happen for 59984 jiffies! g3673 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
  rcu:    Possible timer handling issue on cpu=4 timer-softirq=170
  rcu: rcu_preempt kthread starved for 59987 jiffies! g3673 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=4
  rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
  rcu: RCU grace-period kthread stack dump:
  task:rcu_preempt     state:I stack:0     pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00000010
  Call trace:
   __switch_to+0x100/0x1c8 (T)
   __schedule+0x2b0/0x710
   schedule+0x3c/0xc0
   schedule_timeout+0x88/0x128
   rcu_gp_fqs_loop+0x12c/0x640
   rcu_gp_kthread+0x308/0x350
   kthread+0x10c/0x128
   ret_from_fork+0x10/0x20
  rcu: Stack dump where RCU GP kthread last ran:
  Sending NMI from CPU 2 to CPUs 4:
  NMI backtrace for cpu 4 skipped: idling at cpu_idle_poll.isra.0+0x50/0x170
  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu:    0-...!: (21 GPs behind) idle=a4a0/0/0x0 softirq=1775/1776 fqs=0 (false positive?)
  rcu:    3-...!: (28 GPs behind) idle=5b00/0/0x0 softirq=1437/1438 fqs=0 (false positive?)
  rcu:    7-...!: (21 GPs behind) idle=0c18/0/0x0 softirq=1658/1659 fqs=0 (false positive?)
  rcu:    8-...!: (21 GPs behind) idle=1418/0/0x0 softirq=1231/1231 fqs=0 (false positive?)
  rcu:    9-...!: (18 GPs behind) idle=1288/0/0x0 softirq=1440/1440 fqs=0 (false positive?)
  rcu:    12-...!: (21 GPs behind) idle=ae70/0/0x0 softirq=1339/1339 fqs=0 (false positive?)
  rcu:    13-...!: (28 GPs behind) idle=02c8/0/0x0 softirq=1785/1787 fqs=0 (false positive?)
  rcu:    14-...!: (21 GPs behind) idle=f428/0/0x0 softirq=1272/1273 fqs=0 (false positive?)
  rcu:    15-...!: (21 GPs behind) idle=0fb8/0/0x0 softirq=1562/1562 fqs=0 (false positive?)
  rcu:    (detected by 5, t=60002 jiffies, g=3677, q=12637 ncpus=16)
  Sending NMI from CPU 5 to CPUs 0:
  NMI backtrace for cpu 0 skipped: idling at cpu_idle_poll.isra.0+0x38/0x170
  Sending NMI from CPU 5 to CPUs 3:
  NMI backtrace for cpu 3 skipped: idling at cpu_idle_poll.isra.0+0x38/0x170
  Sending NMI from CPU 5 to CPUs 7:
  NMI backtrace for cpu 7 skipped: idling at cpu_idle_poll.isra.0+0x40/0x170
  Sending NMI from CPU 5 to CPUs 8:
  NMI backtrace for cpu 8 skipped: idling at cpu_idle_poll.isra.0+0x40/0x170
  Sending NMI from CPU 5 to CPUs 9:
  NMI backtrace for cpu 9 skipped: idling at cpu_idle_poll.isra.0+0x40/0x170
  Sending NMI from CPU 5 to CPUs 12:
  NMI backtrace for cpu 12 skipped: idling at cpu_idle_poll.isra.0+0x40/0x170
  Sending NMI from CPU 5 to CPUs 13:
  NMI backtrace for cpu 13 skipped: idling at cpu_idle_poll.isra.0+0x50/0x170
  Sending NMI from CPU 5 to CPUs 14:
  NMI backtrace for cpu 14 skipped: idling at cpu_idle_poll.isra.0+0x50/0x170
  Sending NMI from CPU 5 to CPUs 15:
  NMI backtrace for cpu 15 skipped: idling at cpu_idle_poll.isra.0+0x38/0x170
  rcu: rcu_preempt kthread timer wakeup didn't happen for 60008 jiffies! g3677 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
  rcu:    Possible timer handling issue on cpu=4 timer-softirq=170
  rcu: rcu_preempt kthread starved for 60011 jiffies! g3677 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=4
  rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
  rcu: RCU grace-period kthread stack dump:
  task:rcu_preempt     state:I stack:0     pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00000010
  Call trace:
   __switch_to+0x100/0x1c8 (T)
   __schedule+0x2b0/0x710
   schedule+0x3c/0xc0
   schedule_timeout+0x88/0x128
   rcu_gp_fqs_loop+0x12c/0x640
   rcu_gp_kthread+0x308/0x350
   kthread+0x10c/0x128
   ret_from_fork+0x10/0x20
  rcu: Stack dump where RCU GP kthread last ran:
  Sending NMI from CPU 5 to CPUs 4:
  NMI backtrace for cpu 4
  CPU: 4 UID: 0 PID: 0 Comm: swapper/4 Not tainted 7.0.0-rc7-next-20260409 #1 PREEMPT(lazy)
  Hardware name: SolidRun Ltd. SolidRun CEX7 Platform, BIOS EDK II Jun 21 2022
  pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : tick_check_broadcast_expired+0x4/0x40
  lr : cpu_idle_poll.isra.0+0x54/0x170
  sp : ffff80008017be20
  x29: ffff80008017be20 x28: 0000000000000000 x27: 0000000000000000
  x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
  x23: 00000000000000c0 x22: ffffb3ce21fad000 x21: 0000000000000004
  x20: ffffb3ce21fadd50 x19: ffffb3ce21fad000 x18: 0000000000000004
  x17: 0000000000000000 x16: 0000000000000000 x15: ffffb3ce21fb3b98
  x14: ffffb3ce21788180 x13: 0000000000000000 x12: 000000124d69be59
  x11: 00000000000000c0 x10: 0000000000001c80 x9 : ffffb3ce1f8a6e68
  x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000004
  x5 : ffff00275c3682c8 x4 : 0000000000020a3c x3 : 0000000000000000
  x2 : 0000000000000004 x1 : ffffb3ce223ca0c0 x0 : ffff002020da2140
  Call trace:
   tick_check_broadcast_expired+0x4/0x40 (P)
   do_idle+0x64/0x130
   cpu_startup_entry+0x40/0x50
   secondary_start_kernel+0xe4/0x128
   __secondary_switched+0xc0/0xc8
  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu:    0-...!: (22 GPs behind) idle=ae48/0/0x0 softirq=1775/1776 fqs=0 (false positive?)
  rcu:    3-...!: (29 GPs behind) idle=7ce8/0/0x0 softirq=1437/1438 fqs=0 (false positive?)
  rcu:    7-...!: (22 GPs behind) idle=0df8/0/0x0 softirq=1658/1659 fqs=0 (false positive?)
  rcu:    8-...!: (22 GPs behind) idle=1548/0/0x0 softirq=1231/1231 fqs=0 (false positive?)
  rcu:    9-...!: (19 GPs behind) idle=1360/0/0x0 softirq=1440/1440 fqs=0 (false positive?)
  rcu:    12-...!: (22 GPs behind) idle=af40/0/0x0 softirq=1339/1339 fqs=0 (false positive?)
  rcu:    13-...!: (29 GPs behind) idle=04e0/0/0x0 softirq=1785/1787 fqs=0 (false positive?)
  rcu:    14-...!: (22 GPs behind) idle=f528/0/0x0 softirq=1272/1273 fqs=0 (false positive?)
  rcu:    15-...!: (22 GPs behind) idle=0fd8/0/0x0 softirq=1562/1562 fqs=0 (false positive?)
  rcu:    (detected by 5, t=60002 jiffies, g=3681, q=13149 ncpus=16)

but other times, there is no output after it locks up. Is there any
initial information I can provide to help debug this? Reverting the
change on top of next-20260409 avoids the issue.

Cheers,
Nathan

# bad: [3fa7d958829eb9bc3b469ed07f11de3d2804ef71] Add linux-next specific files for 20260409
# good: [7f87a5ea75f011d2c9bc8ac0167e5e2d1adb1594] Merge tag 'hid-for-linus-2026040801' of git://git.kernel.org/pub/scm/linux/kernel/git/hid/hid
git bisect start '3fa7d958829eb9bc3b469ed07f11de3d2804ef71' '7f87a5ea75f011d2c9bc8ac0167e5e2d1adb1594'
# bad: [443e04732ac2cdc17e3b90aa2345730a298fab37] Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
git bisect bad 443e04732ac2cdc17e3b90aa2345730a298fab37
# bad: [ea33e83d9fa24b34e79c8df57b8927a8d94deb15] Merge branch 'xtensa-for-next' of https://github.com/jcmvbkbc/linux-xtensa.git
git bisect bad ea33e83d9fa24b34e79c8df57b8927a8d94deb15
# bad: [429057750b3d3a7477df48d17aa605dc47bc2344] Merge branch 'for-next/perf' of https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git
git bisect bad 429057750b3d3a7477df48d17aa605dc47bc2344
# bad: [e98894f89da72f392141d9eecf1c7a8f13faa67f] Merge branch 'mm-stable' of https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
git bisect bad e98894f89da72f392141d9eecf1c7a8f13faa67f
# good: [668937b7b2256f4b2a982e8f69b07d9ee8f81d36] mm: allow handling of stacked mmap_prepare hooks in more drivers
git bisect good 668937b7b2256f4b2a982e8f69b07d9ee8f81d36
# good: [a0fbc8dd44a27011537268e2a974b1180b848796] Merge branch 'dma-mapping-fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux.git
git bisect good a0fbc8dd44a27011537268e2a974b1180b848796
# good: [8a23051ed8584215b22368e9501f771ef98f0c1d] Merge tag 'pin-init-v7.1' of https://github.com/Rust-for-Linux/linux into rust-next
git bisect good 8a23051ed8584215b22368e9501f771ef98f0c1d
# good: [716b25a9dc20f4fb94d521581331a0565a43f3bb] Merge branch 'urgent' of https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
git bisect good 716b25a9dc20f4fb94d521581331a0565a43f3bb
# bad: [1a49dc272e25dae6cbb506a02bb70e0201a1498e] Merge branch 'tip/urgent' of https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
git bisect bad 1a49dc272e25dae6cbb506a02bb70e0201a1498e
# good: [30023353b2171cd36b10615a788a985f5caa29e3] Merge branch into tip/master: 'sched/urgent'
git bisect good 30023353b2171cd36b10615a788a985f5caa29e3
# good: [34ef164adaf00982d5f45037a7e37689c4555271] Merge branch 'i2c/i2c-host-fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/andi.shyti/linux.git
git bisect good 34ef164adaf00982d5f45037a7e37689c4555271
# bad: [4fc7108ff756267ad53ecdeaa1e847d378887511] Merge branch into tip/master: 'timers/urgent'
git bisect bad 4fc7108ff756267ad53ecdeaa1e847d378887511
# bad: [1c2eabb8805d9fd79a19de5c76d4a64c9ad3cdf4] clockevents: Prevent timer interrupt starvation
git bisect bad 1c2eabb8805d9fd79a19de5c76d4a64c9ad3cdf4
# good: [82b915051d32a68ea3bbe261c93f5620699ff047] tick/nohz: Fix inverted return value in check_tick_dependency() fast path
git bisect good 82b915051d32a68ea3bbe261c93f5620699ff047
# first bad commit: [1c2eabb8805d9fd79a19de5c76d4a64c9ad3cdf4] clockevents: Prevent timer interrupt starvation
