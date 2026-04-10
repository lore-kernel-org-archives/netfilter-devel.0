Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D25E235045;
	Fri, 10 Apr 2026 12:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775825145; cv=none; b=Ep/K08XUp5me5CaojqYQPQPCypOlmBzA/FubcelxcM/GODwrOzY1Qh0aA7pktTF0tdhaAzr2ctzSnQnsfI2SScPcB5nXGxPaqEw/LrvXebfgiQyHyNH0c+aj/PTmubtkCUZ0Yo69EoNtSNVbGCS/iiK3D1Ll6mpY5KvsQEXjEQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775825145; c=relaxed/simple;
	bh=XczVCJGkATH2J5Vmf+vdFlnbUhkQSJONVdDbdNdb4hY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cwhqrqp1qJWLKFeLJ8tNF4YuevyZoadrpdnl7WdMU1OPdJhit9mciVdfZawtqA30PyTOyjaZrUk83YcZeTwq32VessdZQDKUsepSTmUkyqWpJbsy6noxT7XGLU5YUTx7tBMkQL1nXua9L71zE8iUglk0WtzqrjVsb17WgagXwco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcKgXXfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcKgXXfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7611FC19421;
	Fri, 10 Apr 2026 12:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775825144;
	bh=XczVCJGkATH2J5Vmf+vdFlnbUhkQSJONVdDbdNdb4hY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fcKgXXfpZq4HapPkze64lgRKmdxxEKpEz//KEdxyl3W+MR7C4nu9UgE/mWlgCtavB
	 expCIP+VZpn8UDiDE3APMSR9HT8ajyhq6D1+KLw5VCFfksqBQBMnGWmLDUxJnLepqR
	 vEOSZ+i3v5svYcnuADxtK3z4Ik+l6ROjjDDCS7D3/pK18BqG1P1994tMKKWvCcC2jp
	 MzekFRAcUOCa5MqkIpdoAJweJ/q5k3Igc08mE57dqIypETBWSZwYUN4H3T64ZUFXGD
	 bd37FgiqbKU8R66UjqHzcZqcR5Uy46bB3SNfaopbiyapDX0L3aTx4BFDNbJ602kvA4
	 4CBjWY3ij/xPw==
Date: Fri, 10 Apr 2026 14:45:42 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <jstultz@google.com>,
	Stephen Boyd <sboyd@kernel.org>, Calvin Owens <calvin@wbinvd.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch V2 06/11] alarmtimer: Provide alarm_start_timer()
Message-ID: <adjw9vtfc4DTR7VE@localhost.localdomain>
References: <20260408102356.783133335@kernel.org>
 <20260408114952.332822525@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260408114952.332822525@kernel.org>

Le Wed, Apr 08, 2026 at 01:54:11PM +0200, Thomas Gleixner a écrit :
> Alarm timers utilize hrtimers for normal operation and only switch to the
> RTC on suspend. In order to catch already expired timers early and without
> going through a timer interrupt cycle, provide a new start function which
> internally uses hrtimer_start_range_ns_user().
> 
> If hrtimer_start_range_ns_user() detects an already expired timer, it does
> not queue it. In that case remove the timer from the alarm base as well.
> 
> Return the status queued or not back to the caller to handle the early
> expiry.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Acked-by: John Stultz <jstultz@google.com>
> Cc: Stephen Boyd <sboyd@kernel.org>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs
