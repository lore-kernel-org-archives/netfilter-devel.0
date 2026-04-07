Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5D338AC86;
	Tue,  7 Apr 2026 11:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775561646; cv=none; b=hGvQgHiKXoR6/UGlt6PE9FsS0THDsGiGwGzANhibfP0VTZevJEQumNnIYb2KdBl/NjsPrly02WJnqZv7gbbCUPYzXi+x4C2tKJXOnCrJvudMcF3HGe3tB1CG54/1GIpduTiHAI1lvftI8xJ1n7OvzNTUJfyOI7cgCbT1ix8kfQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775561646; c=relaxed/simple;
	bh=yUDM3hFghJ6baIkLXjXRO9LIWzDz12fJ6chmAdiLZG8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Fd3WG9NBzTOosT1ke8gtoZe4Ohaa6tiTGeqoXuv5fkF2L4hD6mQZDTflhafopdHkgOlQlpwQbJ94q7+xY+gOR1EYIj18vjyGBIRejgBCnL6+IKnEwZIwtxNehlUBmTZYWS7JlN3Ko3BzmLA59WKFvaYPrsBvfbyw2Qaw8Zq/l6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FYid9cix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FYid9cix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC040C2BCB1;
	Tue,  7 Apr 2026 11:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775561645;
	bh=yUDM3hFghJ6baIkLXjXRO9LIWzDz12fJ6chmAdiLZG8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=FYid9cixGFlaEndKwF1W5Z/APgig2klLq1AAkPKmWkbCqjZvvb2y1nlR1R0AYLmQx
	 NdNdarAy7GAUMUOdjE2F8aDM1KCDAovw3k0ubMvVSIXcM7kpaGtLqkjrAXOfb9mdJM
	 OH0oOetFFUq4i/d/I+wPCkw/L/LVmq9k9bkzzOg0ElgQhWRAmbfzTEzP8x6EnUQmaC
	 5F1YvUwxJ9hn7IV+2BEvmT2Rn1UAmBxD1teksdxj3TTMbBjp31gTUQu1WFcpP+tCgC
	 eBLqoSkPViaEsoCZJk0CV90aCbh7dWaxIbF8wBk8HsWFlGwTNEUcB7/AzjdwR4fGk2
	 yfumHFLut2Azw==
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
In-Reply-To: <20260407095758.GN2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.630389532@kernel.org>
 <20260407095758.GN2872@noisy.programming.kicks-ass.net>
Date: Tue, 07 Apr 2026 13:34:02 +0200
Message-ID: <87ika357it.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Apr 07 2026 at 11:57, Peter Zijlstra wrote:
> On Tue, Apr 07, 2026 at 10:54:22AM +0200, Thomas Gleixner wrote:
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(hrtimer_start_range_ns_user);
>
> Can we do that hrtimer_check_user_timer() in
> hrtimer_start_range_ns_user() and then not duplicate
> hrtimer_*reprogram() ?

We probably can. Let me have a look.
