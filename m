Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E47F3ACEE0;
	Tue,  7 Apr 2026 11:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775561553; cv=none; b=YON2nyg65iBX3h6vpoD18318V3hm0QFuL8fd9/TjGDknROBwHY2BLhuN38K6tFbH2d+qtr5AX81yGaFntbb0jGmlRqbo2JtGpLEtmYrzqgvnOA5ChcpKtSzzpr4cWOFBaOvj2KIfwY0uT4beDktVOzWPIGEhv6cKsF4M6M7+PLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775561553; c=relaxed/simple;
	bh=zEpIb1DowHXXHcAi/mnSRKMnbVGwODsD4BMvq/qGzb8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FS0DYDqcs6Z/W7ZRVx6dDhkpfUwG9iDBqHNzamM8owrItCP9ZbRf7kQebhNEM7j6XLApAsMQOpclFl2/BS1uqT+jktIW5sybr2z/YvbpK9DFxH3EWP71AQl2qC8/xQ4jpHCVY5AEUxuLcRb5AkXrtCsHWIOAo/TlqLaqOhZVbUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WSrAj41I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSrAj41I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C45C116C6;
	Tue,  7 Apr 2026 11:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775561553;
	bh=zEpIb1DowHXXHcAi/mnSRKMnbVGwODsD4BMvq/qGzb8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=WSrAj41Ib39zggoqaJ9MDss07O5NLMJ8dWPsDVAzLYvu55WSpZZV6in+Me1/IqYlG
	 6jCzsReNOCYLMP8sXbnKDIL9BKUeg+XncA2iKEQyB9d06XmVpbC8JAip0MVJVe6tzQ
	 BLY6tzVhdYsiq9FCRagvyKwh3U7vAtuSkLLCxgd9k785LNdoBcTyaKYm0BBz/cyzAE
	 +F74vTiWkk033bgRWoLNGv1FsLhrtHLGD03DoNkGk4FFQtNUKEaj37zRBJnPkrnWd+
	 Ej+TmKEj73taCfhM+adExAhtzC+pkFJdbagEDTYpu5i8khxyhKc9hp2Z8cD7v39oFg
	 4WGYPtiuzhl7g==
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
Subject: Re: [patch 02/12] hrtimer: Provide hrtimer_start_range_ns_user()
In-Reply-To: <20260407095421.GM2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.630389532@kernel.org>
 <20260407095421.GM2872@noisy.programming.kicks-ass.net>
Date: Tue, 07 Apr 2026 13:32:29 +0200
Message-ID: <87ldez57le.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 07 2026 at 11:54, Peter Zijlstra wrote:
> On Tue, Apr 07, 2026 at 10:54:22AM +0200, Thomas Gleixner wrote:
>> -	if (__hrtimer_start_range_ns(timer, tim, delta_ns, mode, base))
>> +	switch (hrtimer_start_range_ns_common(timer, tim, delta_ns, mode, base)) {
>> +	case HRTIMER_REPROGRAM:
>>  		hrtimer_reprogram(timer, true);
>> +		break;
>> +	case HRTIMER_REPROGRAM_FORCE:
>> +		hrtimer_force_reprogram(timer->base->cpu_base, 1);
>> +		break;
>> +	}
>>  
>>  	unlock_hrtimer_base(timer, &flags);
>>  }
>
> Something is going to figure out that hrtimer_start_range_ns_common() is
> really returning that enum and then complain you don't handle NONE :-)

:)

> Anyway, to me it would make sense to instead pass that value to
> hrtimer_reprogram() as the second argument. But this works I suppose.

I can do that too. Splitting it this way made me more comfortable to
validate the logic I was implementing.
