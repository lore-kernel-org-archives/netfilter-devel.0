Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F275B1FAEE3
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 13:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731590069; cv=none; b=qlxTXJZ3GUeV7Z3k4k6aAU0qZ1Bhz3tGanBsKg1qynqfJN30g6gK6QKxAHq6J6OD8GFqUjXQGAK+7j/RdLsjncbVNAsl6nXJKHCWZfFly4mN/iUoYRPMexhaU+EcCWF4VqUXUR/n+xYDho2DSqt1quoBOPn9lAGrKwGdZpieGeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731590069; c=relaxed/simple;
	bh=Vj/bLAMkTdxIM0VlMu6nw2+5UTax95SuOZ91Qi+G6Ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u2CbR4B17MrZooUV+/mUvzKYe+8YkL2b8wpAeCthbX71wMWYxhUs+IDX1sgXIeTXbSmgQa41pds0PJdawxSstioaI+Kj3dJ7m1q9ghUcr0LGmKSZeUD+dqVu5aw+OEV0zAQOV5Un43dnXGWsHG51DXnJtE7lpQLsaxXbL8/goQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=58892 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tBZfx-002PM7-ME; Thu, 14 Nov 2024 14:14:23 +0100
Date: Thu, 14 Nov 2024 14:14:20 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nft set statistics/info
Message-ID: <ZzX3rLsszfjj_kG4@calendula>
References: <20241114113441.GA25382@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241114113441.GA25382@breakpoint.cc>
X-Spam-Score: -1.9 (-)

Hi Florian,

On Thu, Nov 14, 2024 at 12:34:41PM +0100, Florian Westphal wrote:
> Hello,
> 
> nftables hides set details from userspace, in particular,
> the backend that is used to store set elements.

Right.

> For debugging it would be good to export the chosen
> backend to userspace.
> 
> Another item i'd like to export is set->nelems counter.
> 
> Before I start working on this, how should that look like?
> 
> Option 1 is to just include two exta attributes in nf_tables_fill_set().
> 
> We could restrict it to nft --debug=netlink so the information isn't
> shown by nftables but by libnftnl.

Yes, --debug=netlink or similar approach should be fine to expose the
backend implementation.

> Option 2 is to add a new type of GET request that only dumps
> such extra set info.  Frontend could then support something like
> 
> nft get setinfo inet mytable set3
> 
> which would dump the set backend name and the set->nelems counter.
> 
> Yet another option would be to include the info in normal
> list ruleset/list sets etc, but print it just like a comment, e.g.
> 
>  nft list ruleset
> table inet t {
>         set s1 {
>                 type ipv4_addr			# nft_rbtree_lookup
>                 flags interval
>                 elements = { 10.0.0.0-11.0.0.0, 172.16.0.0/16 }
> 		# nelems 4
>         }
> 
> 
> Whats your take on this?

Exposing nelems 4 for rbtree is confusing, better expose this
implementation detail only in debug.

I would like rbtree uses the new netlink attribute representation
which provides both sides of the range rather than providing
independent elements with the flag notation, that was a early design
mistake in that API that was fixed by pipapo.

Thanks.
