Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F64A22083;
	Tue,  7 Apr 2026 14:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775572430; cv=none; b=LJleGqVeVhTAhUwxv1VWRYOOP+D2smD8RXxpKr0OuqIAtvLCKaEa0tF3xuZ0OhgyIwcuUdfiYDd7PTCjlmd4zJIZGeRtIUg1TYhdYd2WMtBI+SR/w33LXHB4X3Z2Z+Dg07pac3oZBm+zMtKv0F90Rr3glf4Af3ZIRUzfN7jKAcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775572430; c=relaxed/simple;
	bh=c1UWCjgwFCzeY3oC22UZNQKZhUQeoeGwKeI7oZChdzk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KWXVQtUlqd636ikoVtUceE2F85E6QCR41D72JcvXszrorS/ayx/wTav7ip3WFPUNj6nd9HE5xYlCptHbe4QkcZYZB+gMuQhRehpmF6Rg58ANTMBhCok02lmYxje6dGTORZvLHV7n8SNHU5mrvpfs+7sVBfIkKCCdEX6VtWE6M9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F77WaqmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F77WaqmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBAFC116C6;
	Tue,  7 Apr 2026 14:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775572430;
	bh=c1UWCjgwFCzeY3oC22UZNQKZhUQeoeGwKeI7oZChdzk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=F77WaqmBAH9iU0nJ2xb+VzdV0jLmo7aypOBP3uqgytPiv5roeC2nq8DxgSQDZFEs0
	 +/NL5Ux6Rti5wwKEtQDn4xxDGREld11yHoLVEn9UUzUxhISAbl4a5FKNaPV0YRY8qK
	 fnUKaU2Rrc097AcglXWNjYHaE3WgrfJUHVhchJSbl7VwU7/2q+xnFDUFhoby9bG97F
	 cQODvHx/iap8crqKFc3+AAQML/3Vpt2wLv8bEVVIh+aAfdClY58h15NB3G6BrLiQyU
	 +BR2d9yRvsX0uavWrkm+LaZrtWw+sJwQkSoeHAH2cbMTqbFxLQUxyBI92JAMDP4sXz
	 CFIaJFbHBQgCQ==
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Calvin Owens <calvin@wbinvd.org>, Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker
 <frederic@kernel.org>, Ingo Molnar <mingo@kernel.org>, John Stultz
 <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, Sebastian Reichel
 <sre@kernel.org>, linux-pm@vger.kernel.org, Pablo Neira Ayuso
 <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter
 <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 01/12] clockevents: Prevent timer interrupt starvation
In-Reply-To: <20260407083247.562657657@kernel.org>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
Date: Tue, 07 Apr 2026 16:33:46 +0200
Message-ID: <87zf3e4z79.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Calvin!

On Tue, Apr 07 2026 at 10:54, Thomas Gleixner wrote:
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

It'd be great if you could re-test this one independently of the other
changes, so we can get that on the way ASAP.

Thanks,

        tglx
