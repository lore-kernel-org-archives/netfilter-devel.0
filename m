Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335F6175A5;
	Wed,  8 Apr 2026 13:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775656507; cv=none; b=S2AeLpEvGa0nNlpnc/FwtlTCxfGnHAdLEp7omuS6gFuMnB1SsX3pp7YdG8rNSY0/Wcd/BEroZKGk2uGEmxW6sLhztxi4jY1TjSrcCrxkOn+NEciJ6RQm90/5vDo8CkQvpA4TIW9Z1deVJgAJ84B8R2mGPPLoSe76nXghJ+Ezdbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775656507; c=relaxed/simple;
	bh=9V0aEgsGhkLU/YHXT2F9l9I/XcSpUtYjb0B6llutNFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y46Fjrxw5AZ9Hdnr03LyFJwEuDAdhhgw/ETjs+BA5q27soWXNqO/Nh7PWj0vC3n1d1c7VTlY3dPaNKBvzkAXETpqq6zOzzt2SHaeUkl1UFLzqLuFA1QncV1YG1kCFjH8LvRKf2v371jG9Bq10Ho3oF6w/hqNpeQ5buvBcuu2wxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=g/7igT7Y; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=bXbgFQGF; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="g/7igT7Y";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="bXbgFQGF"
Date: Wed, 8 Apr 2026 15:55:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1775656503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I/7IhEnruGQc+1CW/jI+NpDLfCCCOrjwQ3Z++94aDzE=;
	b=g/7igT7YVTjK17e006TVC9a2gKMuvkRBxfOLbKucZK/ors+kGDdqRhg/OqIAPoq5L2zYiR
	NHS9iN2kPybQQCMzb0hTPTlJ3hMU1aWfJnzlmiv0KNZqY4Wwi26yUcu/VEQmZb3LrFtLeJ
	v9Hj8r5rg9mxwgzJi9+isM2ogGz4hxoBiRV1S6JCNrSj/EZ9vO2oq9kkJwhikSW2SV/nRF
	yNWHpa5z8hiS3Hk82KmrT84xlKxjjdnZZkn0SPpkbAL0sSSDZqoPQ1o2o0e5Bm/LDTrW9/
	URrBKH+giHCjz0pRM4cLUth3lWFPudMBl7mwDYZfzksl5HySlYmwbAWqBhZ6QQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1775656503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I/7IhEnruGQc+1CW/jI+NpDLfCCCOrjwQ3Z++94aDzE=;
	b=bXbgFQGFM845UyMTzIaKnx+U/0W1qwvKf9VT1aZH2aehpEPkr35D05t97plT1GQ4P43LR/
	E8qif45B75rf6LAQ==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>, 
	Peter Zijlstra <peterz@infradead.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>, 
	Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@kernel.org>, John Stultz <jstultz@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 01/12] clockevents: Prevent timer interrupt starvation
Message-ID: <20260408155353-42aeefa4-db66-48aa-ab07-0538a8cfdbf0@linutronix.de>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
 <20260408143313-ac6c3b82-70e6-4ce3-b33a-20f5e6ba160b@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260408143313-ac6c3b82-70e6-4ce3-b33a-20f5e6ba160b@linutronix.de>

On Wed, Apr 08, 2026 at 02:41:20PM +0200, Thomas Weißschuh wrote:
> Hi Thomas,
> 
> On Tue, Apr 07, 2026 at 10:54:17AM +0200, Thomas Gleixner wrote:
> > From: Thomas Gleixner <tglx@kernel.org>
> > 
> > Calvin reported an odd NMI watchdog lockup which claims that the CPU locked
> > up in user space. He provided a reproducer, which sets up a timerfd based
> > timer and then rearms it in a loop with an absolute expiry time of 1ns.
> > 
> > As the expiry time is in the past, the timer ends up as the first expiring
> > timer in the per CPU hrtimer base and the clockevent device is programmed
> > with the minimum delta value. If the machine is fast enough, this ends up
> > in a endless loop of programming the delta value to the minimum value
> > defined by the clock event device, before the timer interrupt can fire,
> > which starves the interrupt and consequently triggers the lockup detector
> > because the hrtimer callback of the lockup mechanism is never invoked.
> > 
> > As a first step to prevent this, avoid reprogramming the clock event device
> > when:
> >      - a forced minimum delta event is pending
> >      - the new expiry delta is less then or equal to the minimum delta
> 
> with this patch now in the tip tree my QEMU/virtme-ng based machine
> fails to boot. The startup seems to freeze in:
> start_kernel() -> rest_init() -> schedule_preempt_disabled() -> schedule()
> 
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST_IDLE=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_HZ=1000
> 
> CPU: i5-1135G7
> clock event device: lapic-deadline
> 
> The clockevent device is still reprogrammed each millisecond,
> presumably for the tick.
> 
> (...)

This fixes the issue for me:

--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -369,7 +369,7 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires, b
        if (dev->next_event_forced)
                return 0;
 
-       if (dev->set_next_event(dev->min_delta_ticks, dev)) {
+       if (dev->set_next_event(dev->min_delta_ns, dev)) {
                if (!force || clockevents_program_min_delta(dev))
                        return -ETIME;
        }


Thomas
