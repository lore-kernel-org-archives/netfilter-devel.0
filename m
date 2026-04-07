Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7C233D4F3;
	Tue,  7 Apr 2026 16:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775578653; cv=none; b=Q86eJ/Ds5WnlrVKF0FGe+fXyoEyHNwpJutkNJAReLA3HWcEDwA03A6bcGxErmDp1J0CBncZ27HDgWDi+Fv+E+rO+MxqMFlpjWglM36vH4kbbvypq4xH8lImR16t+u/ZZ1Xt077SQvQnZ/j5FyxPOT+C21z3epHlrHX/3c2/xCiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775578653; c=relaxed/simple;
	bh=TpzE9QxM02oe3UDWE662FRdcVm7uQTpTmnONiXx9w2E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZwKpIwuN/7Iyml7SM1HvE07zNcOEWaX0Flzfg7pr1MGRcV0AQXs0LyQiwDx5hMdfRLpCDSLbA0FqMZRUnJGcKYEls2ZwUT5FBLdYqNTdwBTjS8Ch8U9ua1j6D1XSNuMBf4xHY6It2KZweZ0RN2Hw6sp4EtW7RcvL6fFjK1eOuVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vJC/Xash; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vJC/Xash"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8507C19424;
	Tue,  7 Apr 2026 16:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775578652;
	bh=TpzE9QxM02oe3UDWE662FRdcVm7uQTpTmnONiXx9w2E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=vJC/XashBFAGUqoMTahwwK2LPXUQhnx8iYN66z8szRJSO90ZEjxgvYxZwZ0a0uvfe
	 iCdKNeHU6jdsqOWdqZ9YgoI8qD15tLAlhn99Tvw1Ek0owaeYsFUSgAyFfIcy+eW5b7
	 lscaEdf8esLGHSnsHNi/XO55Td5qXc2kBXUwUwc9oyCdXqcDbmbH5W1/RMJjgEFfFU
	 foOHPmK6802vjKzvmR/tFxF1RCcnDnAYom+5bJDKgG5JJasAaRIEKLjUcTkA5n/gZ3
	 zErn01qFYH2wJNwwebtYzD2UTMuhcyEB8xYSQ2L8y5XD8PFSbcMmQtTWTY8//8Gpa2
	 RvMT8OLyH+J/g==
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
In-Reply-To: <87wlyi4yrj.ffs@tglx>
References: <20260407083219.478203185@kernel.org> <87wlyi4yrj.ffs@tglx>
Date: Tue, 07 Apr 2026 18:17:28 +0200
Message-ID: <87qzoq4uef.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 07 2026 at 16:43, Thomas Gleixner wrote:
> On Tue, Apr 07 2026 at 10:54, Thomas Gleixner wrote:
>> There needs to be some discussion about the scope of backporting. The first
>> patch preventing the stall is obviously a backport candidate. The remaining
>> series can be obviously argued about, but in my opinion it should be
>> backported as well as it prevents stupid or malicious user space from
>> generating tons of pointless timer interrupts.
>
> Peter and me just discussed it over IRC. With the clockevents prevention
> in place, the effect of stupid/malicious code is pretty much affecting
> only the user space task itself. As the timer is forced to expire once
> the clockevent device has been force armed, it won't have other side
> effects as device interrupts or IPIs are not blocked out and in the
> worst case marginally delayed by the high frequency timer interrupt.
>
> Once the task is scheduled out that subsides as there is nothing which
> re-arms the timer anymore.
>
> So we should be fine with backporting the clockevents fix and leave the
> other parts of the series for upstream only. I still need to investigate
> how all of that affects the pending changes vs. TSC deadline timer (and
> similar devices) which are not going to reach that modified clockevents
> code anymore.

It's pretty much the same as the above with the difference that a timer
armed in the past will result in an instantaneous interrupt as the
coupled event devices must provide a less than or equal comparator. So
again the task can only delay itself with hrtimer interrupts.

Thanks,

        tglx


