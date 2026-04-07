Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC383B8934;
	Tue,  7 Apr 2026 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775570408; cv=none; b=no7Y+78q7IyfmSBDSAR76v2eZdHr0UPxIOpzEJzC2W19spCgDpuZ0OB9HU5S8+bRYhWVc4LKvXFGIb/1fLKgUgnzHd8wr3nEEqmDYB3pAU81vR+Vz2qp3wid9LQqmoIQxcplbC9iaZCqF1MAm0kzrio2EsjsGRQnJQel8yX60CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775570408; c=relaxed/simple;
	bh=R3FPgUBIyXd8toX27lC987LhlBPlcjngidTNB968ukE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lNy97JZSWijwL7eTz1UEE7TxUKJXTPFrVAd43Qzj7uO9BbNXHGdJgLxKemBBKK1Xu0Imc4blLsrb+SBZJPbS9NJmArKabS24cy7zSyK3E6IjxWdJoOBwoSeYNlBGi6aX0XJFwGg5y4W3QWrtBiDKyImAMvGAWCbHO1p1yh3eWj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pq6cE2vr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pq6cE2vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE54C4AF0B;
	Tue,  7 Apr 2026 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775570408;
	bh=R3FPgUBIyXd8toX27lC987LhlBPlcjngidTNB968ukE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pq6cE2vrKQZVnXXOiLpQL4qQvqmd0t+4rQFuqwO2IdzMK9GyGbNUnZFL0pOGWkVT9
	 Ui/8NTG1IZsJ+hVF08dqQAwGZP+ymY9CZySkCDFKVgQRgNodoWVUBaPPTHS885UJ5W
	 V7QtdOk133p2fCFZZnslBSF9NxkNio22U5EjuyAicxG0IjFw21VYhUs0S8lm5roDak
	 NXkiKRSfmTPETsDQ7Yj1g8T/z6YO+fjFF7FmLP1TN2uZbnwSZXeeAEQ0ce62XoxW6g
	 5eA5jKZLoORFdDoaN21mLjrrzefSvy4cLOEeZtPDYdh+UWktRGJyulgE9KN4333u1A
	 dSJZXJpXrUH7A==
Date: Tue, 7 Apr 2026 16:00:05 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
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
Subject: Re: [patch 01/12] clockevents: Prevent timer interrupt starvation
Message-ID: <adUN5Y9-1kx5FVHd@localhost.localdomain>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260407083247.562657657@kernel.org>

Le Tue, Apr 07, 2026 at 10:54:17AM +0200, Thomas Gleixner a écrit :
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
> ---
> V2: Simplified the clockevents code - Peter

Isn't it possible to rely on dev->next_event instead? In the above scenario,
subsequent 0 delta would not reprogram if dev->next_event is already below
the new call to ktime_get() ?

Thanks.

-- 
Frederic Weisbecker
SUSE Labs
