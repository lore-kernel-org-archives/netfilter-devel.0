Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A342E3387
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Oct 2025 20:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760993760; cv=none; b=awmW91vxZ3XYFy9YcxiaTcZ50D5633CbE854uifmYk/Ya63Luy8ExWJAEdE8Ee/Z2wYzbyVdRZoztzSkCeO+NIdCOBSP4SPXE4E4gaYF3jhgRrvOayDk/yyhZ5MO1wMs5TYHhmIG9IWvT75zgVxOadgVwnxsgDrr3Iu84v2B4kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760993760; c=relaxed/simple;
	bh=fYdatVeUziEFLwe6Ig83DTUvqWXLkfTjt/Tf1yFCivE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0PTj88HQiff3/g5BYCKI0RhyPMyFdvej+PHKkuGdqW0fLXIUfHXQ195/CQtlu0GtZiFbgKZSZ0xwAXZkXvg4QnH2BwvbA07TcfSREJvoaHdsrkckqhBLJD43ehhvf/OSh81bV+0Nm0wxVxR0OzTIlQhm0FDTy9Fuzbbhw8K+PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7271C6017F; Mon, 20 Oct 2025 22:55:55 +0200 (CEST)
Date: Mon, 20 Oct 2025 22:55:55 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] selftests: nft_queue: conntrack expiration requeue
Message-ID: <aPah2y2pdhIjwHBU@strlen.de>
References: <20251020200805.298670-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020200805.298670-1-aojea@google.com>

Antonio Ojea <aojea@google.com> wrote:
> The nfqueue mechanism allows userspace daemons to implement complex,
> dynamic filtering rules. This is particularly useful in distributed
> platforms like Kubernetes, where security policies may be too numerous
> or change too frequently (in the order of seconds) to be implemented
> efficiently in the dataplane.
> 
> To avoid the performance penalty of crossing between kernel and
> userspace for every packet, a common optimization is to use stateful
> nftables rules (e.g., ct state established,related accept) to bypass the
> queue for packets belonging to known flows.
> 
> However, if there is the need to reevaluate the established connections
> using the existing rules, we should have a way to stop tracking the
> connections so they are sent back to the queue for reevaluation.
> 
> Simply flushing the conntrack entries does not work for TCP if tcp_loose
> is enabled, since the conntrack stack will recover the connection

you mean disabled?
loose tracking (midstream pickup) is on by default.

> state. Setting the conntrack entry timeout to 0 allows to remove the state
> and the packet is sent to the queue.

But its the same as --delete, entry gets tossed (its timed out) and is
re-created from scratch.

> This tests validates this scenario, it establish a TCP connection,
> confirms that established packets bypass the queue, and that after
> setting the conntrack entry timeout to 0 subsequent packets are
> requeued.

That zaps the entry and re-creates it, all state is lost.
Wouldn't it make more sense to bypass based on connmark or ctlabels?

I'm not sure what the test is supposed to assert.

That setting timeout via ctnetlink to 0 kicks the entry out of the ct hash?
