Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41B41A9FB0;
	Tue,  7 Apr 2026 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775572996; cv=none; b=k3RNVqHlODmTWBuQLxpAD4oMSiHadDqFlvR+ENGVNhRfmYRCrOgC3hTjcrpqXa1rOnKQ8W9RmgDedu5G+VIkkieLMP7C+vWLKz8nYWl2YW49hIxfsMy2RP8zZLds9o06ATTl0445/RaB05FbnkNojNJKeHMCU5lNYdDBNwXdF8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775572996; c=relaxed/simple;
	bh=x0V8HDMD/+ttteoDJUS2U88l+YhpYc2Fl6aWUWMCqok=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QTr7FUADV7sZqWfL/0/TcCvRtFxqNwmdl/yUHgjuytKLAiGC1gUCsbxGjMfjgdz7gMVsiN5dJt5FHOmL9My4beE4fKr5s2PN2tiO1TEIiCc26JC056b24GhtvltCmGusCrzn1bQJS9BWBGyyoMXH/q7vUTm8eyGIbCsYhLsekkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cgEZXQhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgEZXQhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59A2C116C6;
	Tue,  7 Apr 2026 14:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775572996;
	bh=x0V8HDMD/+ttteoDJUS2U88l+YhpYc2Fl6aWUWMCqok=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cgEZXQhlUkaZWRnOU01DIi6XvkoZTXLmpvxfJEv5ObbEvAfkis42+82Rx1GtRblUH
	 52I4eR2pw8DzuAAkIsYojEYtExUnKEiGccUTWBmxBxYmx5sqLp+cJ2PDbRkeEiS3T6
	 h4D+yrB994XCj2OtlWoL/u+lW34T1uYoLC4ipDC/aOFbRTdmT6OTKpHiaqtecX/fLD
	 uF7FZ6g3UIyXQNi234QAAH6tSrtqxYPWzedwnfBsa48ORmOB4Xr1Fd+nbELRak58w3
	 WPpsp5a4TKpGpL5TEumDy+EKbQY1vkazGFN11WFGsPMsMYQ/mCjCmN4MHAd8uUZind
	 RLvFPmrHC9v9g==
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
Subject: Re: [patch 00/12] hrtimers: Prevent hrtimer interrupt starvation
In-Reply-To: <20260407083219.478203185@kernel.org>
References: <20260407083219.478203185@kernel.org>
Date: Tue, 07 Apr 2026 16:43:12 +0200
Message-ID: <87wlyi4yrj.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 07 2026 at 10:54, Thomas Gleixner wrote:
> There needs to be some discussion about the scope of backporting. The first
> patch preventing the stall is obviously a backport candidate. The remaining
> series can be obviously argued about, but in my opinion it should be
> backported as well as it prevents stupid or malicious user space from
> generating tons of pointless timer interrupts.

Peter and me just discussed it over IRC. With the clockevents prevention
in place, the effect of stupid/malicious code is pretty much affecting
only the user space task itself. As the timer is forced to expire once
the clockevent device has been force armed, it won't have other side
effects as device interrupts or IPIs are not blocked out and in the
worst case marginally delayed by the high frequency timer interrupt.

Once the task is scheduled out that subsides as there is nothing which
re-arms the timer anymore.

So we should be fine with backporting the clockevents fix and leave the
other parts of the series for upstream only. I still need to investigate
how all of that affects the pending changes vs. TSC deadline timer (and
similar devices) which are not going to reach that modified clockevents
code anymore.

Thanks,

        tglx


