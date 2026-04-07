Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8142386452;
	Tue,  7 Apr 2026 16:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775578135; cv=none; b=A9iG4YBj3AnKj2iC9MdhsyL/mXC7ydkihTHChFVOOz7/SVyuoo0n06wcXiR1TwxG5PqcediRSQpK5q94NdM3Wz4B6hkZtF8TcVbv8+olsvalVKLPRXJ+I+JruyBSUi2zsB0i9TfixXaQpjUQXwNsUrIBPge44kgRZf6zV3cBhto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775578135; c=relaxed/simple;
	bh=8+XrLn44M7bWBGgQWnF9XOkYXae8VKwXxigNC9f7p5Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=uVCQiZ3YOezyuwgQnqxcC/zp4kGGNKVg6vqH1s+86pyQxWu2SQXQ1OqPOzHQtU2a8ISHTDZe9qlCNdfeNi6nFn4pL5fl+Ypx61PqAX2T4kmA/zKZI1O4mnhzuqiW4AU1XkUtKcbsC7DXou6yjxnUJlCT9iy0tTw5cLPO0l+jD50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jVEf/NAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVEf/NAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C4BC116C6;
	Tue,  7 Apr 2026 16:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775578134;
	bh=8+XrLn44M7bWBGgQWnF9XOkYXae8VKwXxigNC9f7p5Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jVEf/NAMTgWPARpL0vC+sFTI8tqsrEnzyPWqT3nNIl6r71v2yGLuhTPICyAKAmc70
	 E4q4W7aLkI0YZmKrqmIObJahH9pmu13mFJ0CtDdycy5AlxmUVWhLKyBAwENWvDaW0w
	 xtpcJp5uQFoQ7gEQgdluN3gkROsbSVHEox98nQInI2KL71Abd8+TDm9WaTleYvy0hO
	 SbTEI7DzzX9uIMf8e6ppiah5IcmMRaAJ35KiJW12GuWoUk/PAT1YPbSREA8bEUUogd
	 ZVEiMDH0bITT6kvsfppVt94bPQDsSeHEXVGXOX0dHmewM8Sfpom7giRoGPd6VtFzHx
	 vE0PxN8dXzXWw==
From: Thomas Gleixner <tglx@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
 Peter Zijlstra <peterz@infradead.org>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Ingo Molnar <mingo@kernel.org>, John Stultz
 <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, Sebastian Reichel
 <sre@kernel.org>, linux-pm@vger.kernel.org, Pablo Neira Ayuso
 <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter
 <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 01/12] clockevents: Prevent timer interrupt starvation
In-Reply-To: <adUN5Y9-1kx5FVHd@localhost.localdomain>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
 <adUN5Y9-1kx5FVHd@localhost.localdomain>
Date: Tue, 07 Apr 2026 18:08:51 +0200
Message-ID: <87tstm4uss.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 07 2026 at 16:00, Frederic Weisbecker wrote:
> Le Tue, Apr 07, 2026 at 10:54:17AM +0200, Thomas Gleixner a =C3=A9crit :
>> From: Thomas Gleixner <tglx@kernel.org>
>>=20
>> Calvin reported an odd NMI watchdog lockup which claims that the CPU loc=
ked
>> up in user space. He provided a reproducer, which sets up a timerfd based
>> timer and then rearms it in a loop with an absolute expiry time of 1ns.
>>=20
>> As the expiry time is in the past, the timer ends up as the first expiri=
ng
>> timer in the per CPU hrtimer base and the clockevent device is programmed
>> with the minimum delta value. If the machine is fast enough, this ends up
>> in a endless loop of programming the delta value to the minimum value
>> defined by the clock event device, before the timer interrupt can fire,
>> which starves the interrupt and consequently triggers the lockup detector
>> because the hrtimer callback of the lockup mechanism is never invoked.
>>=20
>> As a first step to prevent this, avoid reprogramming the clock event dev=
ice
>> when:
>>      - a forced minimum delta event is pending
>>      - the new expiry delta is less then or equal to the minimum delta
>>=20
>> Thanks to Calvin for providing the reproducer and to Borislav for testing
>> and providing data from his Zen5 machine.
>>=20
>> The problem is not limited to Zen5, but depending on the underlying
>> clock event device (e.g. TSC deadline timer on Intel) and the CPU speed
>> not necessarily observable.
>>=20
>> This change serves only as the last resort and further changes will be m=
ade
>> to prevent this scenario earlier in the call chain as far as possible.
>>=20
>> Fixes: d316c57ff6bf ("[PATCH] clockevents: add core functionality")
>> Reported-by: Calvin Owens <calvin@wbinvd.org>
>> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
>> Cc: Frederic Weisbecker <frederic@kernel.org>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Link: https://lore.kernel.org/lkml/acMe-QZUel-bBYUh@mozart.vkv.me/
>> ---
>> V2: Simplified the clockevents code - Peter
>
> Isn't it possible to rely on dev->next_event instead? In the above scenar=
io,
> subsequent 0 delta would not reprogram if dev->next_event is already below
> the new call to ktime_get() ?

It does if force is set and that is set when hrtimer calls into it:

	if (delta <=3D 0)
		return force ? clockevents_program_min_delta(dev) : -ETIME;

I can't change that for various reasons.

But we always need the flag which tells us that the programming was
forced in order to prevent the above scenario. And delta <=3D 0 is not the
only way how to achieve that. You can have a delta > 0 and < min_delta
anc achieve the same effect. That needs more effort on the callsite, but
it's trivially doable as the systemcall to reprogram time is pretty
constant.

As I had to introduce the flag and prevent the other scenraio I just
consolidated everything into one code path.

Thanks,

        tglx
