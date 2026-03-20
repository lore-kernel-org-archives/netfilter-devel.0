Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46F41925BC
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774012585; cv=none; b=bYQWv1xXuSqwrwQSlvpioP/WmJ4BE6y5mru62xntp9vWoI8EQyrxuB89Z7/uQonG3/WEi7D2BAi0KTrf1mBbAO/gcA3fMnYQE+lCKZBeTekQS9YwPif6RIXIz7MR7fKlwkRiy87MGFOn+X/Trl9tkwd+SHCGfGdmwAd8yo9P9kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774012585; c=relaxed/simple;
	bh=cKmvhWCSD5E6pn40XfZlO6aWym2bKpaQa1j+1Z37RP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ysgddb2ny4ZEhgU6pa7IZ6PZ43+OgSPOXuydvuukUmXY/cbmHzi+m0fPjBYNMDp2yKEqtYScnGuOe66jzp3tjOQ61RaGD8C0DDeTkp2JMzxyMemMGgwBpv1oXhmd1lPNS5+7pbnh0xrILiQQRKmZbpfhYeoLPgv3px8ga6/hjh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 254816080C; Fri, 20 Mar 2026 14:16:20 +0100 (CET)
Date: Fri, 20 Mar 2026 14:16:19 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 4/5] netfilter: nf_conntrack_expect: store netns and
 zone in expectation
Message-ID: <ab1Io4C98cfENWZj@strlen.de>
References: <20260320125947.305117-1-pablo@netfilter.org>
 <20260320125947.305117-5-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320125947.305117-5-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> __nf_ct_expect_find() and nf_ct_expect_find_get() are called under
> rcu_read_lock() but they dereference the master conntrack via
> exp->master.
> 
> Since the expectation does not hold a reference on the master conntrack,
> this could be dying conntrack or different recycled conntrack than the
> real master due to SLAB_TYPESAFE_RCU.

Grrr, good point, I was about to say that you can safely check net
via exp->ct netns.  But yeah, object recycling is an issue.

I'll push this to nf.git:testing to let build bots have a go at
this over the weekend and will review this more closely next week.

But at first glance this series LGTM, thanks Pablo.
