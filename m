Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B97B3AE1BF;
	Tue,  7 Apr 2026 11:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775561692; cv=none; b=m33YAg5/AvoKiEV9nRyeOvGqDHPFoB1DlcLCIXnksfze/6YqcRm63d2ktGgQpPoFZgvcR5dQ0g6iNub65fe75FDHQmbfqyHS+AFXkpGJbaM2DIfBa0l598Psut1phOhYEbr2VpmClJ12e6Wa7qF6urllpF6iz25EniAZzTTB7fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775561692; c=relaxed/simple;
	bh=9YUToimfNgX1iEDORmfH2a1+7N4GQzss93G8dfjn7xE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=O6lkbZQJ55JYgEd2+ZJ9vtgKtjmPbpMGE/SM+nRtvKOgbomzTJgAUK8Qj1etwsOH3ZB82zQNMoK9ls0FyywmO2Sst6B/geaIktox3MY9w50lMy8fPEvEvwI1Itx0MwCNcr046gze/rMQnidiHtFg1iA5QBBBdetyPVG2wOXMjh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4h2cCUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4h2cCUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2545EC116C6;
	Tue,  7 Apr 2026 11:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775561692;
	bh=9YUToimfNgX1iEDORmfH2a1+7N4GQzss93G8dfjn7xE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=T4h2cCUqPSmHABYXH9ls7T8waWlPkOcbpwZuyGm1DVzNg5x4iXCXrhOPaL4qaYFZS
	 A/IdYXdAL84mW121UZUw7cCbDMGUE7iC631fYOqSIUPfK4IBCe1mGHOKyZZD0ATn/g
	 RluSEI1SMVpgphGFtLU/DTADxkQJgxybep0IRYDrm2gVQywgv8bbxOJiBPK+aFIdPk
	 txhniMQ02nkVV00yY0pOHBWTeVJqtgJ1NUHHa/5xjocPEuHepNTVUV3PcaE5IKj7b5
	 tEP6O2SpqkT3XMTyotXt18Pceala/UXQ8cFgbTbSEhs6fTrw1BiwyDAqgKHL0z75zC
	 pVMjN5mSpNOTw==
From: Thomas Gleixner <tglx@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>, Calvin Owens <calvin@wbinvd.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker
 <frederic@kernel.org>, Ingo Molnar <mingo@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, Sebastian Reichel
 <sre@kernel.org>, linux-pm@vger.kernel.org, Pablo Neira Ayuso
 <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter
 <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 07/12] alarmtimer: Provide alarmtimer_start()
In-Reply-To: <20260407100427.GS2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.965539525@kernel.org>
 <20260407100427.GS2872@noisy.programming.kicks-ass.net>
Date: Tue, 07 Apr 2026 13:34:48 +0200
Message-ID: <87fr5757hj.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 07 2026 at 12:04, Peter Zijlstra wrote:
> On Tue, Apr 07, 2026 at 10:54:48AM +0200, Thomas Gleixner wrote:
>> Alarm timers utilize hrtimers for normal operation and only switch to the
>> RTC on suspend. In order to catch already expired timers early and without
>> going through a timer interrupt cycle, provide a new start function which
>> internally uses hrtimer_start_range_ns_user().
>> 
>> If hrtimer_start_range_ns_user() detects an already expired timer, it does
>> not queue it. In that case remove the timer from the alarm base as well.
>> 
>> Return the status queued or not back to the caller to handle the early
>> expiry.
>> 
>> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
>
> Not familiar with this code, but my head hurts from the:
>
> alarm_
> alarm_timer_
> alarmtimer_
>
> prefixes, what's what?

Yeah. I should have named it alarm_timer_start(). Let me fix this.
