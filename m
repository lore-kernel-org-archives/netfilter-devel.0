Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E4D137932
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2026 22:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768689938; cv=none; b=HwOaKcQWzVonVsu37ry0A+4T5+DSTJHD5v2wn31K+r75FRjQCK9nD5oN/qvxX/pKjDHaTyelevCgqNNXLyuBsrc0f17aZo4Mnp1BuAeN6OZ5pzcd6TtYfJzj88qmFgg7zy2zLOWkVTqUSB/yfQEcPiljf3+CqF5xk3JzjWn8Kvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768689938; c=relaxed/simple;
	bh=9888gudvCbFACUxK6jeC4rYPMANIUqOGUAe8k+Kpci4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pNS/gqJxJVjtJ2hq+2g6OkIZAJdu7UuIhJVEPnuwLTwe45z7bvxrHboCrLn/WO5m4zKCC04rs+ldBknQTiitReZ/0JNWBBi5VeIdhDF+rYcWcXz6xji4+gykeOFa2htM7c8jEeRHaovQKe4FaExLJ8IpIqOQ1ZFYoviK+k/2Cwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5B384603A1; Sat, 17 Jan 2026 23:45:29 +0100 (CET)
Date: Sat, 17 Jan 2026 23:45:28 +0100
From: Florian Westphal <fw@strlen.de>
To: scott.k.mitch1@gmail.com
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v6 1/2] netfilter: nfnetlink_queue: nfqnl_instance
 GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation
Message-ID: <aWwRCM4YZZ3gUP85@strlen.de>
References: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
 <20260117173231.88610-2-scott.k.mitch1@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260117173231.88610-2-scott.k.mitch1@gmail.com>

scott.k.mitch1@gmail.com <scott.k.mitch1@gmail.com> wrote:
> +	/* Lookup queue under RCU. After peer_portid check (or for new queue
> +	 * in BIND case), the queue is owned by the socket sending this message.
> +	 * A socket cannot simultaneously send a message and close, so while
> +	 * processing this CONFIG message, nfqnl_rcv_nl_event() (triggered by
> +	 * socket close) cannot destroy this queue. Safe to use without RCU.
> +	 */

Could you add a

WARN_ON_ONCE(!lockdep_nfnl_is_held(NFNL_SUBSYS_QUEUE));

somewhere in this function?

Just to assert that this is serialized vs. other config messages.

Thanks.
