Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A21331215;
	Tue,  7 Apr 2026 11:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775561446; cv=none; b=Ov46tzhAm+YWDesyD1pjw2QNEShLPDQvGCcyqlf7zIwbmoCtSHoYMO/dGH1yOrntOXlMvOY//AexmxjMhOUB88O5136wFM+Rn6GMfOb1WTmz8PKeStPeCAcyZQHlFMULeOAlBRHJBUQhXB+UU/C6AVYqABd3IEH3SuXWwO4a3r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775561446; c=relaxed/simple;
	bh=6BhrKoeoCszgRC/OODlv5pmb3yGXumLFVq2zS+cwJuA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KDuDM2o88c8ErzzP5shDieoDlrXbSaHsbE9TVdoZy+rwbAZL9ByRskN03UuZ4mt9YKd2LeA+W9uY25K1z72CJ5+uCzYQRCy3F7EmUlzsa0VQJ9qa874Mgc+FqdjrlulRhzyHjM2IiRtXeshHsE/p08bDw4/g/vwbuFdgzCovA7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pu1umOkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pu1umOkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E2AC19421;
	Tue,  7 Apr 2026 11:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775561446;
	bh=6BhrKoeoCszgRC/OODlv5pmb3yGXumLFVq2zS+cwJuA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=pu1umOkZ0u5gBSIXckgOLS/jcNaO9PbaoX3hg0T687IsqJ1ftpl8ffesbVVAoTLD0
	 DUJuYgHbG6ylBu7LtnghFJCjFz9DZr945R4b3VZgQW9/IN2OO7VrYqAOVJUHj2eIB/
	 vvN+O0e0kGOvdni3IK1O/2UZkSjt07P5jyengoEZ1Yjpzgpzn6E7T7f+9Ywjcrv/TJ
	 FbTMmYeXFQEC8/b19o61InykP2ov2eMeF7nD13wnFT9mfN6Q5AvGk+AhU86kN7gEUZ
	 EeppeLzuxp517ay6Mr3ECCuA00DQr3annnMnyR0wNRArd45qacOh5t60fkBoDNZ1qt
	 +8+VG49bFNgNQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker
 <frederic@kernel.org>, Ingo Molnar <mingo@kernel.org>, John Stultz
 <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, Sebastian Reichel
 <sre@kernel.org>, linux-pm@vger.kernel.org, Pablo Neira Ayuso
 <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter
 <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 01/12] clockevents: Prevent timer interrupt starvation
In-Reply-To: <20260407094206.GL2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
 <20260407094206.GL2872@noisy.programming.kicks-ass.net>
Date: Tue, 07 Apr 2026 13:30:42 +0200
Message-ID: <87o6jv57od.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 07 2026 at 11:42, Peter Zijlstra wrote:
> On Tue, Apr 07, 2026 at 10:54:17AM +0200, Thomas Gleixner wrote:
>> @@ -324,16 +324,23 @@ int clockevents_program_event(struct clo
>>  		return dev->set_next_ktime(expires, dev);
>>  
>>  	delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
>>  
>> +	if (delta > (int64_t)dev->min_delta_ns) {
>> +		delta = min(delta, (int64_t) dev->max_delta_ns);
>> +		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
>> +		if (!dev->set_next_event((unsigned long) clc, dev))
>> +			return 0;
>> +	}
>>  
>> +	if (dev->next_event_forced)
>> +		return 0;
>>  
>> +	if (dev->set_next_event(dev->min_delta_ticks, dev)) {
>> +		if (!force || clockevents_program_min_delta(dev))
>> +			return -ETIME;
>> +	}
>> +	dev->next_event_forced = 1;
>> +	return 0;
>>  }
>
> Looking at the implementation of clockevents_program_min_delta() doing
> that dev->set_next_event(dev->min_delta_ticks,) right before it seems a
> bit daft.
>
> But yes, this is effectively also what the old code did.

yes. I looked at that and didn't come up with a good plan.

> The only thing that seems to be different, is that the old code would
> return the ->set_next_event() error code, rather than 0 in the !force
> case.

You mean when dev->next_event_forced is set and the set_event() callback
above failed?

Thanks,

        tglx


