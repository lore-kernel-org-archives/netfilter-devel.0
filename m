Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D899933D4FB;
	Fri, 10 Apr 2026 21:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775855598; cv=none; b=OMA1IYu7Ex8UF3oKxWeAnPaDRNbIO66e2npnPUS06lwFGDY99xuRxtunRghqIk5mrhsFcRBcZxJ19Azq9B7o3vNlzE/sl5kHVdVt5QDO/I/+tz59Ijup32EsTIHrw6rEqf03JBMXpRmrhCAwI9qNykXOnqicWFL5fKhDCQZThSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775855598; c=relaxed/simple;
	bh=mQJOWz1mk2jWZG3BMZyiHaKvboqLwGGiEp7a3M2LQUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oR69NNZlAwsqimSOOxomu1Z7+JRJ5qsHjPz8WdYwA69M9ApB29bsP9CIrbPCOBYMohfkWlmX+PXFwUd5ltpNfzkP00rtaGUWWMatBiniR2lgDi14G8nTnFkxis4axfFm9DfBm7C6w3sf0cCa1qRX8HmAtdwjDxn3nGb8B9x+70Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sYVC0+sF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sYVC0+sF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E41C19421;
	Fri, 10 Apr 2026 21:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775855597;
	bh=mQJOWz1mk2jWZG3BMZyiHaKvboqLwGGiEp7a3M2LQUs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sYVC0+sFX1aEJf0c7xfC4XoWL0ytVF+4O9Zg0r27VZsNFINtVGuLBSAvpvzoxy71D
	 PHOOg7Pw+a22q9Ql52heJTR0EPgfrVpvHHfk2i8sGQAybjla0xizkCmFq9y2XSO6my
	 PjDBSifY5eWNykKWXtfAEpTIaiG3vU5ApMNdpJHnXS8n37Ug7rbUmu03jjba8zwK8M
	 FH29NmCT846ZYG0CtKPChBfmsQQwxha9z6OMzW/1ijB/E/8rjaOcdQeXUWK0y8P+BT
	 kWVE1WDN9lnbPxQTJPkULlHvz96Gbl+kTW/3oX5ilGPb0lhTLhWY5NgZOJ8BF8bGH3
	 NPGbvWoCdpbRQ==
Date: Fri, 10 Apr 2026 14:13:10 -0700
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
Message-ID: <20260410211310.GA3924786@ax162>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
 <20260410205203.GA3922321@ax162>
 <87fr52zfze.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fr52zfze.ffs@tglx>

On Fri, Apr 10, 2026 at 11:02:13PM +0200, Thomas Gleixner wrote:
> On Fri, Apr 10 2026 at 13:52, Nathan Chancellor wrote:
> >> Link: https://lore.kernel.org/lkml/acMe-QZUel-bBYUh@mozart.vkv.me/
> >
> > This change in -next as commit 1c2eabb8805d ("clockevents: Prevent timer
> > interrupt starvation") appears to make one of my test machines
> > consistently lock up on boot (at least I never get to userspace). Most
> > of the time I get stall messages such as
> 
> Can you please retest the changes I just pushed out into:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/urgent
>     
> namely: d6e152d905bd ("clockevents: Prevent timer interrupt starvation")

Hah, funny timing. I can confirm that the following diff against the
version in -next appears to fix the issue for me. Thanks for the quick
response!

Cheers,
Nathan

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f63c65881364..7e57fa31ee26 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -76,8 +76,10 @@ const struct clock_event_device *tick_get_wakeup_device(int cpu)
  */
 static void tick_broadcast_start_periodic(struct clock_event_device *bc)
 {
-	if (bc)
+	if (bc) {
+		bc->next_event_forced = 0;
 		tick_setup_periodic(bc, 1);
+	}
 }
 
 /*
@@ -403,6 +405,7 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 	bool bc_local;
 
 	raw_spin_lock(&tick_broadcast_lock);
+	tick_broadcast_device.evtdev->next_event_forced = 0;
 
 	/* Handle spurious interrupts gracefully */
 	if (clockevent_state_shutdown(tick_broadcast_device.evtdev)) {
@@ -696,6 +699,7 @@ static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
 
 	raw_spin_lock(&tick_broadcast_lock);
 	dev->next_event = KTIME_MAX;
+	tick_broadcast_device.evtdev->next_event_forced = 0;
 	next_event = KTIME_MAX;
 	cpumask_clear(tmpmask);
 	now = ktime_get();
@@ -1063,6 +1067,7 @@ static void tick_broadcast_setup_oneshot(struct clock_event_device *bc,
 
 
 	bc->event_handler = tick_handle_oneshot_broadcast;
+	bc->next_event_forced = 0;
 	bc->next_event = KTIME_MAX;
 
 	/*
@@ -1175,6 +1180,7 @@ void hotplug_cpu__broadcast_tick_pull(int deadcpu)
 		}
 
 		/* This moves the broadcast assignment to this CPU: */
+		bc->next_event_forced = 0;
 		clockevents_program_event(bc, bc->next_event, 1);
 	}
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
