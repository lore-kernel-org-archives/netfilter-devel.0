Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADB226ED45;
	Tue,  7 Apr 2026 09:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775554939; cv=none; b=Gt6D+JjAqnjqdO/iOo2rmgvqdCNENWLBxnYdb8S1DLXn6cem5dM/zlvSwBNd6NJ8IPMjpgaG5CXOC2pjLoSnuDbqbHvkPGImw5rx+u9kkmil/cmB7uD0ux6N8rm25+hqo2PTLG61LmKZAV8YkpONoY4o4GTppa4xCYHcEhtnUuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775554939; c=relaxed/simple;
	bh=TAAVNXJt51bsnk1asDblEQR6M53ygAwyLlFgg2d2NI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jXk2v7tg3EGST2c/GFI3pazJOF24qX4dTjRAri1nfc1qDgr3JgpzFbVaLcraz+IZRwM84WfMpTmfxMwH6DV8K514rOxTrR/9atjGfqIdxum00ZtA3mpM2IqAtpRrfHaCM1iXbK7iXGhYbVRitAVabJ3dKko+Q6Enc5oTSSte5U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GL3fX06D; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GL3fX06D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jtdKMQ8pJX5L5Lx4J8z/WcoGP9UCW0UUWoW6S6I0dcg=; b=GL3fX06DnxaApfB2NuKQVa8Jcx
	dPUkc+Md8AanQXzfLXAQ53elA+FIaav91uAiWNdqdEz4ZTRm2sb7rhWM1tUCcQqMVyUWgdt1+5H39
	O86QS2n2KbzJIoTC70euaDqplpYU8TB0piauT/PRjQpkeU144lk4o0cf57LqTJU5hkQBuHFeP7OMf
	EUxsGgvrej6riIHzP2YtwTskl/Ob9s0myC9YXgZBE3hWB445AtJd/J+9ITckmU/qUWFBjE0I8Nkjm
	1LX+tYhk6wTc0wRbJ5RQYtnyrsEfvzi91jBO7IXZl9GoTKXb0tMdDGIDeryKGCUx1GxizWypbT7FR
	Nh8B/WYA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA2wh-00000003LSG-2XYi;
	Tue, 07 Apr 2026 09:42:07 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3821730035C; Tue, 07 Apr 2026 11:42:06 +0200 (CEST)
Date: Tue, 7 Apr 2026 11:42:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
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
Message-ID: <20260407094206.GL2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407083247.562657657@kernel.org>

On Tue, Apr 07, 2026 at 10:54:17AM +0200, Thomas Gleixner wrote:


> @@ -324,16 +324,23 @@ int clockevents_program_event(struct clo
>  		return dev->set_next_ktime(expires, dev);
>  
>  	delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
> -	if (delta <= 0)
> -		return force ? clockevents_program_min_delta(dev) : -ETIME;
>  
> -	delta = min(delta, (int64_t) dev->max_delta_ns);
> -	delta = max(delta, (int64_t) dev->min_delta_ns);
>  
> -	clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
> -	rc = dev->set_next_event((unsigned long) clc, dev);
>  
> -	return (rc && force) ? clockevents_program_min_delta(dev) : rc;
>  }

> @@ -324,16 +324,23 @@ int clockevents_program_event(struct clo
>  		return dev->set_next_ktime(expires, dev);
>  
>  	delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
>  
> +	if (delta > (int64_t)dev->min_delta_ns) {
> +		delta = min(delta, (int64_t) dev->max_delta_ns);
> +		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
> +		if (!dev->set_next_event((unsigned long) clc, dev))
> +			return 0;
> +	}
>  
> +	if (dev->next_event_forced)
> +		return 0;
>  
> +	if (dev->set_next_event(dev->min_delta_ticks, dev)) {
> +		if (!force || clockevents_program_min_delta(dev))
> +			return -ETIME;
> +	}
> +	dev->next_event_forced = 1;
> +	return 0;
>  }

Looking at the implementation of clockevents_program_min_delta() doing
that dev->set_next_event(dev->min_delta_ticks,) right before it seems a
bit daft.

But yes, this is effectively also what the old code did.

The only thing that seems to be different, is that the old code would
return the ->set_next_event() error code, rather than 0 in the !force
case.
