Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0911D248166;
	Tue, 14 Apr 2026 18:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776189880; cv=none; b=MZ80eeUYqXYFf7d79cMxMwMHQNs+RdnF2sd2XGCFoGsQ15V5hVelJS7WJRLophORPl6Wo1Va29uuOLbjA2LFsHEVubT1ldTa61jMpUg2wuJvvt2JftwBY4+1WMONduyEqgAMuN1yQ5SK0iaGKLmVat7fn1PI+wRUPDJ4Jc7fyCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776189880; c=relaxed/simple;
	bh=iR7rlrGmwA/rHAX7iIBtarDaDTWAcc7zO/ecbr5nem8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eun3raj8kHWgjjUjKChkFcCiW6T9WBPVWU4O19sjS5HzKCuSv6f22a2QEdo564RzTcH7qUHdIw6fSOQKs9F1B5KnjlmPHYHX7g/UPBvA+HFXirH84f82+W/Gz9vdpykqGsHqiubJPAqJCouT/sZdOvNRtshlAjermcsWgMt93iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SItFgwXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SItFgwXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D36DC19425;
	Tue, 14 Apr 2026 18:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776189879;
	bh=iR7rlrGmwA/rHAX7iIBtarDaDTWAcc7zO/ecbr5nem8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SItFgwXNnrWiBMII6fkX82ETct3p5t0zsp5Sq1G712Zw7c0tO3M49217Bs6JOnTtP
	 l2r3+F6zbLRk/wXIputOEMrbAEzfYhqiJNrVklo82qAMJMnQkmH1yfJkYODdZ3/g+Y
	 PG87DYavrhwzXiBx5hqPgjVJt+lEUaJyyGkgP8WhGUKIPaygOGT/uIQGec6zDy+55n
	 x/kBiqbxEQV8WL1hm8JD8qsi959poFXqctAmhqtmWalm877JgmefZkyJKhZ6zc2Uoa
	 MEJR4H5/u73eZ9viNG+uL4xQ7qNyJZkWMdpoDAi7DfiGwOnoi2ph7+YVjNkuVT/kmV
	 mZlBSAUJW/Liw==
Date: Tue, 14 Apr 2026 20:04:36 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Eric Naim <dnaim@cachyos.org>
Cc: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Calvin Owens <calvin@wbinvd.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, John Stultz <jstultz@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: The "clockevents: Prevent timer interrupt starvation" patch
 causes lockups
Message-ID: <ad6BtKRj1GyreNCS@localhost.localdomain>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
 <68d1e9ac-2780-4be3-8ee3-0788062dd3a4@gmail.com>
 <aeb848aa-404a-40fb-bd41-329644623b1d@cachyos.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aeb848aa-404a-40fb-bd41-329644623b1d@cachyos.org>

Le Tue, Apr 14, 2026 at 03:39:00PM +0000, Eric Naim a écrit :
> On 4/14/26 5:20 AM, Hanabishi wrote:
> > 
> > Hello.
> > 
> > Sorry, but this patch as of 7.0 introduced *severe* periodic lockups on my
> > Ryzen 7700X machine.
> > I see such messages in the log:
> > 
> > clocksource: Long readout interval, skipping watchdog check: cs_nsec:
> > 2897344852 wd_nsec: 2897356996
> > 
> > Reverting d6e152d905bdb1f32f9d99775e2f453350399a6a for mainline fixes the
> > issue for me.
> > 
> 
> Hi maintainers,
> 
> several users from CachyOS has reported this regression as well. We landed on
> the same bisection. One of the users that could reproduce this reliably
> reproduced this just by watching a YouTube video in a browser, and observed
> freezes and stutters when interacting with the system.
> 
> I had an LLM generate a fix (patch attached), and it fixed the regression for
> that user. Full disclosure: it is written completely by AI, and I am also not
> familiar with this subsystem. I just hope that this patch can be helpful in
> fixing the regression.
> 
> Please don't hesitate to tell me off if utilizing AI in this way is not
> helpful, so I can keep this in mind for future contributions.
> 
> 
> -- 
> Regards,
>   Eric

> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> index 38570998a19b..37b10045572e 100644
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -332,8 +332,10 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
>  	if (delta > (int64_t)dev->min_delta_ns) {
>  		delta = min(delta, (int64_t) dev->max_delta_ns);
>  		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
> -		if (!dev->set_next_event((unsigned long) clc, dev))
> +		if (!dev->set_next_event((unsigned long) clc, dev)) {
> +			dev->next_event_forced = 0;
>  			return 0;
> +		}
>  	}
>  
>  	if (dev->next_event_forced)
> diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
> index 7472597f3225..bf411472d4f7 100644
> --- a/kernel/time/tick-oneshot.c
> +++ b/kernel/time/tick-oneshot.c
> @@ -34,6 +34,7 @@ int tick_program_event(ktime_t expires, int force)
>  		 */
>  		clockevents_switch_state(dev, CLOCK_EVT_STATE_ONESHOT_STOPPED);
>  		dev->next_event = KTIME_MAX;
> +		dev->next_event_forced = 0;
>  		return 0;
>  	}
>  
> @@ -43,6 +44,7 @@ int tick_program_event(ktime_t expires, int force)
>  		 * before using it.
>  		 */
>  		clockevents_switch_state(dev, CLOCK_EVT_STATE_ONESHOT);
> +		dev->next_event_forced = 0;
>  	}
>  
>  	return clockevents_program_event(dev, expires, force);

That diff suggest that dev->next_event_forced is not properly cleared by
a handler or when the device is stopped.

For example it's not cleared when the device is oneshot stopped.

It's also not cleared when the device is detached (though that shouldn't
matter much) and also when the broadcast wakeup thing is used.

Can you try the following?

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index b4d730604972..5c6dfd6bed28 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -100,6 +100,7 @@ static int __clockevents_switch_state(struct clock_event_device *dev,
 		/* The clockevent device is getting replaced. Shut it down. */
 
 	case CLOCK_EVT_STATE_SHUTDOWN:
+		dev->next_event_forced = 0;
 		if (dev->set_state_shutdown)
 			return dev->set_state_shutdown(dev);
 		return 0;
@@ -127,10 +128,12 @@ static int __clockevents_switch_state(struct clock_event_device *dev,
 			      clockevent_get_state(dev)))
 			return -EINVAL;
 
-		if (dev->set_state_oneshot_stopped)
+		if (dev->set_state_oneshot_stopped) {
+			dev->next_event_forced = 0;
 			return dev->set_state_oneshot_stopped(dev);
-		else
+		} else {
 			return -ENOSYS;
+		}
 
 	default:
 		return -ENOSYS;
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 7e57fa31ee26..115e0bf01276 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -108,6 +108,7 @@ static struct clock_event_device *tick_get_oneshot_wakeup_device(int cpu)
 
 static void tick_oneshot_wakeup_handler(struct clock_event_device *wd)
 {
+	wd->next_event_forced = 0;
 	/*
 	 * If we woke up early and the tick was reprogrammed in the
 	 * meantime then this may be spurious but harmless.
