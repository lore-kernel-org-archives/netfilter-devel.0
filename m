Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C983342CB4
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Apr 2026 17:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775583492; cv=none; b=ssP4faDD9wVSIV29UzO+WqhbaSuCkPK/Kbma3D5Ldgid0bv0fkenYzX+a+eV8Iik0CSlC0WcdIkNBK7YAbiJli5kjR4ZdlVedh3w6tW7LRiLeDXEPv9ssJXHyWqxU605HdWZBJ0vk5UuCN6u0h5I0JYVlABMcbsXymZtip4fT9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775583492; c=relaxed/simple;
	bh=tvdUOATrbfQbm/otRmotSEVug48Q7PpH/fmsCZHFm/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MSWMeMfi+79/xzdar4oOiBpSC488kciP9gdhYgHTqZ7ixtI6KGAUcCyZrLa27vSL/uifRfQMTsVXiXZ4RpBXq6hjhTHQX2WoWf8wTbrWCERMGqYbJvZ+VcIDsRn4PDSNZzbde56XKxzWaYoWx4lmPMHRbRfH1ccGP95o/3fe5nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wbinvd.org; spf=pass smtp.mailfrom=wbinvd.org; dkim=pass (2048-bit key) header.d=wbinvd.org header.i=@wbinvd.org header.b=W0VTYY3f; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wbinvd.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wbinvd.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wbinvd.org header.i=@wbinvd.org header.b="W0VTYY3f"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2c156c4a9efso6901070eec.1
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Apr 2026 10:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wbinvd.org; s=wbinvd; t=1775583490; x=1776188290; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hqUr7UMuRskj68PpjSrDblmslOlX4kFlkF++X6DCkjE=;
        b=W0VTYY3ft7bUlo7blCkv7uvh2n+fbI1geytaWAqleOxemFlBdqAOBh2yH73beInRyr
         p0fueHUxvNR4a3YdozjFgRWwPRgNPsMUAbuSKfCsSK9pG29BKZGAyiGOgLiPGijgs4BY
         Fa3s+Qodwcnci/Q8bNt4481CyvK18QpJciMvhWQmf7tDtyi/TxTW7kO7XsgaeVrkhkNi
         8R65EmNicM5ZjtPYsgwuRexusJGwlwQLEugTdKSNQHs6NSdkDcOV4zR4W8K5Ln+3SAIa
         yysFTD1Bmh09jwfz4RSqo11OVqw8mOsvdwU+QxFHnLmNVazJF/1XCs3WVb7AiFW8/PQu
         YIbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775583490; x=1776188290;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hqUr7UMuRskj68PpjSrDblmslOlX4kFlkF++X6DCkjE=;
        b=gNSYDhekwbOfWfewom8MY9IDuoti/wJA1fqH95a17L/KAIux4aPlCipwtU9rWNqc7V
         Wl3bSoDgYz3OIy3cMZqRQChLZ1Q2JgurOLneN8F+8V5dqidNR/qVW0INoUBkEmtcyyMq
         1I7elxikfZhEtRqDfpz0viifu0zIfUfrh2ZnkZptf2I9W8d7JJMJ5gb9G1eoH0WtQN26
         7hjUkLCdmrqAN21pIiYLlA3X2f+9PcMXVuENF8tEX7A3DnKeCv3T7cF68YGiIUAKvYB9
         h6zcsWR60Ayis0GSX3KaVSfuUPwYOYNc1Bc2ewprlpbEra8eSYxtOlbwgcXOCcNWR43F
         q57Q==
X-Forwarded-Encrypted: i=1; AJvYcCXwjNWeiAxAhlJazrR2ZQrjLqjFO7+MbsZcuBeWC6nTtkSFymV5tYIa15ahc4edYikHBnXLT5mIFFN1ThbLD2s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoqW1VBwSKyiRiMtArENJ/5+SgVyr3YYI+AmBJdk03sGrpSilW
	O/krqB8BlgLbGjqrDG3ncqIxzbW5bZWBrkhlfSHnaq5ZiGpc6cPN8imSPTD9SYUgFBU=
X-Gm-Gg: AeBDievjzrwlBvO4ZyHB2WtzB6vWl+0LYM9eF0IWK19NzhlC+kDPTLf5f+ZTyfURNdo
	/fhOwXkR1oqIlNkZ8Ta0OJ7ruUVQLu+d4c9/Id6F+qJGumOcc9lKCl/AKs7sYcK6P8tK5aQ/MB6
	M7epxJFl6GMigITeDEdfGEij5HmNr99QMWQgtqH3RA/3LCHePjtFtEI1IhwccFzsh1qChazjVvX
	6T6ZkOBtiKMLJtjjdeK2JxHji8WNmi5ZFM9rCu64DSiKtFg3BF3OM4SuoJkDA1UDdeOCk1iay+n
	OcH4nwq57peW2NPQ+8rlTPg2adqck1H8px4Mv0rF92Aif6P7E4I2SaaJ5uUPUxpZbQVrOefgPE0
	P+m5RzX+nB2Xh6TO4nZ4v9F3EEZm9nRM8PI48Ur/KSZ+erwTAoub9glBJXzDpWwP3x9R2z0iIQ9
	1SlsVPahG4Xha0421y9nYR2N/AfQ==
X-Received: by 2002:a05:7301:1010:b0:2ba:a2fb:403f with SMTP id 5a478bee46e88-2cbfb995d49mr8269797eec.21.1775583490260;
        Tue, 07 Apr 2026 10:38:10 -0700 (PDT)
Received: from mozart.vkv.me ([2001:5a8:468b:d015:412a:9f09:7acb:b69f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2cba5df5c24sm15761050eec.27.2026.04.07.10.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 10:38:09 -0700 (PDT)
Date: Tue, 7 Apr 2026 10:38:06 -0700
From: Calvin Owens <calvin@wbinvd.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
Subject: Re: [patch 00/12] hrtimers: Prevent hrtimer interrupt starvation
Message-ID: <adVA_uv1srA_bsKj@mozart.vkv.me>
References: <20260407083219.478203185@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260407083219.478203185@kernel.org>

On Tuesday 04/07 at 10:54 +0200, Thomas Gleixner wrote:
> Calvin reported an odd NMI watchdog lockup which claims that the CPU locked
> up in user space:
> 
>   https://lore.kernel.org/lkml/acMe-QZUel-bBYUh@mozart.vkv.me/
> 
> He provided a reproducer, which sets up a timerfd based timer and then
> rearms it in a loop with an absolute expiry time of 1ns.

The original AMD machines survive the reproducer with this series.

Tested-by: Calvin Owens <calvin@wbinvd.org>

I'm happy to test subsets of it and stable backports too, if that's
helpful, just let me know.

Thanks,
Calvin

> As the expiry time is in the past, the timer ends up as the first expiring
> timer in the per CPU hrtimer base and the clockevent device is programmed
> with the minimum delta value. If the machine is fast enough, this ends up
> in a endless loop of programming the delta value to the minimum value
> defined by the clock event device, before the timer interrupt can fire,
> which starves the interrupt and consequently triggers the lockup detector
> because the hrtimer callback of the lockup mechanism is never invoked.
> 
> The first patch in the series changes the clockevent set next event
> mechanism to prevent reprogramming of the clockevent device when the
> minimum delta value was programmed unless the new delta is larger than
> that. It's a less convoluted variant of the patch which was posted in the
> above linked thread and was confirmed to prevent the starvation problem.
> 
> But that's only to be considered the last resort because it results in an
> insane amount of avoidable hrtimer interrupts.
> 
> The problem of user controlled timers is that the input value is only
> sanity checked vs. validity of the provided timespec and clamped to be in
> the maximum allowable range. But for performance reasons for in kernel
> usage there is no check whether a to be armed timer might have been expired
> already at enqueue time.
> 
> The rest of the series addresses this by providing a separate interface to
> arm user controlled timers. This works the same way as the existing
> hrtimer_start_range_ns(), but in case that the timer ends up as the first
> timer in the clock base after enqueue it provides additional checks:
> 
>       - Whether the timer becomes the first expiring timer in the CPU base.
> 
>       	If not the timer is considered to expire in the future as there is
> 	already an earlier event programmed.
> 
>       - Whether the timer has expired already by comparing the expiry value
>         against current time.
> 
> 	If it is expired, the timer is removed from the clock base and the
> 	function returns false, so that the caller can handle it. That's
> 	required because the function cannot invoke the callback as that
> 	might need to acquire a lock which is held by the caller.
> 
> This function is then used for the user controlled timer arming interfaces
> mainly by converting hrtimer sleeper over to it. That affects a few in
> kernel users too, but the overhead is minimal in that case and it spares a
> tedious whack the mole game all over the tree.
> 
> The other usage sites in posixtimers, alarmtimers and timerfd are converted
> as well, which should cover the vast majority of user space controllable
> timers as far as my investigation goes.
> 
> The series applies against Linux tree and is also available from git:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git hrtimer-exp-v1
> 
> There needs to be some discussion about the scope of backporting. The first
> patch preventing the stall is obviously a backport candidate. The remaining
> series can be obviously argued about, but in my opinion it should be
> backported as well as it prevents stupid or malicious user space from
> generating tons of pointless timer interrupts.
> 
> Thanks,
> 
> 	tglx
> ---
>  drivers/power/supply/charger-manager.c |   12 +-
>  fs/timerfd.c                           |  115 +++++++++++++++-----------
>  include/linux/alarmtimer.h             |    9 +-
>  include/linux/clockchips.h             |    2 
>  include/linux/hrtimer.h                |   20 +++-
>  include/trace/events/timer.h           |   13 +++
>  kernel/time/alarmtimer.c               |   70 +++++++---------
>  kernel/time/clockevents.c              |   23 +++--
>  kernel/time/hrtimer.c                  |  142 +++++++++++++++++++++++++++++----
>  kernel/time/posix-cpu-timers.c         |   18 ++--
>  kernel/time/posix-timers.c             |   35 +++++---
>  kernel/time/posix-timers.h             |    4 
>  kernel/time/tick-common.c              |    1 
>  kernel/time/tick-sched.c               |    1 
>  net/netfilter/xt_IDLETIMER.c           |   24 ++++-
>  15 files changed, 341 insertions(+), 148 deletions(-)
> 
> 
