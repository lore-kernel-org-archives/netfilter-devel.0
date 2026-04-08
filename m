Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9F13B3C11;
	Wed,  8 Apr 2026 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775667200; cv=none; b=ZWL1yA3IhSlnEZyOJKQUP7PfpJFAhi23USwepzbmnjFzUmWejjQk/ljzDCurEmXyCTHScQWRbrtHCvwNVHCWfGlXFJ5BV9hyrbl7BK4okhuBnXj38QWBWwTbtDeKvk/CG5wkcfZI1a4U5h+AjIQ6Pq3ANnOUX2KzZ5tK5aJ5XV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775667200; c=relaxed/simple;
	bh=UHeo9KUp++AkJnjsJTxVP1fyHnDvaWVtuwwTMYh7KXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hc4fLm96T2XEO97BY6KuBOUJCJ6+yUt8vI20IzL0dcp3lQ2c2D9mCnzQ1J1WRXo4SS7/9YifztTAMClaAKhiaWiIfdGjORv3Y9BJavpWpHVD2zz19lYmdpG+3LezEzn5cNdEXncCJ2jsVqKBMidV/Lz4x98QvMUNTzb+4J3lWQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKj5Xyn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKj5Xyn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBADC19421;
	Wed,  8 Apr 2026 16:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775667200;
	bh=UHeo9KUp++AkJnjsJTxVP1fyHnDvaWVtuwwTMYh7KXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eKj5Xyn44yw+/kc20bOe9qdOUnx5JhnFtYFLhBd78PWku/RJpIwHEXW6G2p+QUov9
	 25JNMovX8caRkCFarah5c7Qc/Dv+RC6rM4LKoRCe/iDYOiUezcM+HA73ze1CYgpPY2
	 ir6dcAUOIYmS+cPqELdX3n2m1h2JDO+p2VmmMtgR7hmo6iOVc2OP6s5CBHCw/ipbOV
	 ku0sYua9fnOqk+2PsvFgzzmFlE82njHeyXL3wEMJEg1IPxZSyy4ahHTJxH1fh7rOA1
	 2brrJji5bUreS9JE/5kgalhWfdmG+k/RdcWSF3JjwisyxUNymlvCJW/T7it+zGwEk6
	 MOnSbvf95/DGQ==
Date: Wed, 8 Apr 2026 18:53:16 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch V2 01/11] hrtimer: Provide hrtimer_start_range_ns_user()
Message-ID: <adaH_AVmNLlRd3ep@localhost.localdomain>
References: <20260408102356.783133335@kernel.org>
 <20260408114951.995031895@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260408114951.995031895@kernel.org>

Le Wed, Apr 08, 2026 at 01:53:46PM +0200, Thomas Gleixner a écrit :
> Calvin reported an odd NMI watchdog lockup which claims that the CPU locked
> up in user space. He provided a reproducer, which set's up a timerfd based
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
> The clockevents code already has a last resort mechanism to prevent that,
> but it's sensible to catch such issues before trying to reprogram the clock
> event device.
> 
> Provide a variant of hrtimer_start_range_ns(), which sanity checks the
> timer after queueing it. It does not so before because the timer might be
> armed and therefore needs to be dequeued. also we optimize for the latest
> possible point to check, so that the clock event prevention is avoided as
> much as possible.
> 
> If the timer is already expired _before_ the clock event is reprogrammed,
> remove the timer from the queue and signal to the caller that the operation
> failed by returning false.
> 
> That allows the caller to take immediate action without going through the
> loops and hoops of the hrtimer interrupt.
> 
> The queueing code can't invoke the timer callback as the caller might hold
> a lock which is taken in the callback.
> 
> Add a tracepoint which allows to analyze the expired at start situation.
> 
> Reported-by: Calvin Owens <calvin@wbinvd.org>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
> Cc: Frederic Weisbecker <frederic@kernel.org>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs
