Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A42352014
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 07:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779954372; cv=none; b=nN9/fxisQy+h4In+Fj/BOnJigoSoajmDYoj/z0gVjbWzf3PaXdemVk354JRj8GxbOnx2iMtrnvOKhD5fnG2gjgiJUo4k2Lahml32usgcSi+7VrZbFeCMYhvGCZCoZpz7qPZC2gTqPSNyahAPtdTdEakTBK58xUdGKcg++Rfz8Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779954372; c=relaxed/simple;
	bh=WrixeIwcCbX7Tcbln5E6ifRexiMe2PuSwiHwKSvueKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uNldHywo21sctyOZPDIeqLLpA8oGJWT9ghEBVkgIcg9vYnuazS7VPwJUroAFR+0WCi/Qpr+YlwHiZvR421D69g/vIfL2XpZnTKeTQVkfGR4Z6gH5W3DgECBdSLYswMlE43s/V4/RHRIv7JCnbMSgU1HVgJ5ETG0QmSt2qZ0+hmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 98566604A0; Thu, 28 May 2026 09:46:07 +0200 (CEST)
Date: Thu, 28 May 2026 09:46:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools] conntrack.8: Document --stats counters
Message-ID: <ahfyv50suL44m7FX@strlen.de>
References: <20260527173858.2546091-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527173858.2546091-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Provide at least a brief description of each counter's meaning based on
> code-analysis in kernel's nf_conntrack_core.c.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> While most values are pretty obvious, I am not entirely sure I got the
> insert_failed and drop reasons right.

Thanks for working on this.   I think the hardest part is to explain
how to interpret this, i.e. which counters may indicate issues and which
ones do not.

> ---
>  conntrack.8 | 37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/conntrack.8 b/conntrack.8
> index 2bfd80e5d6aa4..b562e16839a32 100644
> --- a/conntrack.8
> +++ b/conntrack.8
> @@ -108,7 +108,42 @@ Flush the whole given table
>  Show the table counter.
>  .TP
>  .BI "-S, --stats "
> -Show the in-kernel connection tracking system statistics.
> +Show the in-kernel connection tracking system statistics. The returned values
> +for each CPU are:
> +.RS
> +.TP
> +.B found
> +Number of successful conntrack table lookups

We don't count those anymore, its too expensive.
This is only incremented when a new connection cannot reuse
the tuple and has to create a new nat mapping.

See nf_conntrack_tuple_taken().

> +.B insert
> +Number of entries inserted into conntrack table

IIRC its only incremented for insertions from netlink path.

> +.B insert_failed
> +Number of failed inserts (clash resolution failure, conntrack extensions in
> +inconsistent state, entry in dying state, oversized hash bucket encountered)

oversized hash buckets should not be mentioned here, they have their own
counter.  Should probably not increment both counters in kernel when it
happens.

Maybe: "Number of NEW connections dropped because of clashes with existing entry."?

> +.B drop
> +Number of packets dropped (clash resolution failure, removed conntrack helper,
> +stress, TCP connection aborted)

Yes, I think we need to fix this in the kernel and not increment two
counters for the same reason.

Drop should mostly mean "incomplete packet / out of memory".

> +.B early_drop
> +Number of packets dropped up front due to full table

AFAICS its number of connections dropped because of a full table.

> +.B search_restart
> +Number of times a table lookup had to be restarted due to table reorg

Not sure about this one.  This is an implementation detail (SLAB_TYPESAFE_BY_RCU).
This can happen at any time when entry is removed from table and
other CPU is re-instantiating a new conection using the just-unlinked
entry.

> +.TP
> +.B clash_resolve
> +Number of entry insert clashes resolved

Maybe mention that this is not a cause for alarm and mostly
expected with DNS these days?

> +.TP
> +.B chaintoolong
> +Number of oversized hash bucket encounters

Maybe mention that this happens only on insert and results in conntrack
to drop the packet.
