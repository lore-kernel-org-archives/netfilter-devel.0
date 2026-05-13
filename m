Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A17136D4E4;
	Wed, 13 May 2026 12:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778677062; cv=none; b=bNAwhxBWSujwvKp1ZZyjfd/6QfZyOAvctEQvEcZySl2AP4bPt9vmr7C+RigzKH5HwNgoz20xv5dwvZ+QBkf4FrZZJYMrB+u75QYpD/gtpzmQWj6CM80bpRw9FUmRtD02ib3AKHlEdO2haCbxVmMbvLh6+iSlCY45yPelZhfv+34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778677062; c=relaxed/simple;
	bh=lgKLUMReZlkJVnwJxFYAv74XGD7vVCHGZVXTfs65Qa8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BaH8pRnSHe0mz4MtUyMFdC2O6WKEiAtOBUqCZPvPrVS8lobQG/j1Nd82npLe1fav+jEXd792JKtO/R6i1NF0RaXMOQTABSrAineCuUdG8CqrtOWPCIJ+yA6BWYUs4hsh6M3nnDz9mf6QZQrbFeQKCJwr1LpCvajAHQoatRirv4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0Pn3Xpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0Pn3Xpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEABC2BCB7;
	Wed, 13 May 2026 12:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778677061;
	bh=lgKLUMReZlkJVnwJxFYAv74XGD7vVCHGZVXTfs65Qa8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=b0Pn3XpuZg23jIkbHo0OfOHaMz1KojnyHGQHu2sFS/+dvU7dxMhfRu8ONJz/vWi8x
	 gskYh193yof5zXc0yg5pb9zutE/fDJ/47nv/cFYDJuSJTm/YB2M+aB9HRK4dS2b93l
	 oDO0K/dq9PDXAxT3jA/VUy9s6fwHZ3EsbJSJCfD9pct70Z+LZ+ZQZyvOpT6r+g+cT5
	 CCK9qGiztx8FD5Ri9L2aatytEOm4oyr8oTHIot8kQmHfukH53f0YEkmzh16Tkng3mA
	 wAoQr5SJ4S7gaOBBirBcc+8MHc0zsZWTJR56iPrKhqYZyP7XN1FbSp7t3pLGkN8Fus
	 xTVAFkYbnwN0A==
From: Thomas Gleixner <tglx@kernel.org>
To: Dan Carpenter <error27@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker
 <frederic@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, Florian
 Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch V2 01/11] hrtimer: Provide hrtimer_start_range_ns_user()
In-Reply-To: <agLfbp9yEiQlTYYl@stanley.mountain>
References: <20260408102356.783133335@kernel.org>
 <20260408114951.995031895@kernel.org> <agLfbp9yEiQlTYYl@stanley.mountain>
Date: Wed, 13 May 2026 14:57:38 +0200
Message-ID: <87wlx779h9.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, May 12 2026 at 11:06, Dan Carpenter wrote:
> On Wed, Apr 08, 2026 at 01:53:46PM +0200, Thomas Gleixner wrote:
>> +enum {
>> +	HRTIMER_REPROGRAM_NONE,
>> +	HRTIMER_REPROGRAM,
>> +	HRTIMER_REPROGRAM_FORCE,
>> +};
>> +
>>  static bool __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim, u64 delta_ns,
>>  				     const enum hrtimer_mode mode, struct hrtimer_clock_base *base)
>
> The return type for this function needs to changed from bool to
> enum whatever...  Otherwise HRTIMER_REPROGRAM and HRTIMER_REPROGRAM_FORCE
> are both just true.

Duh, yes.
