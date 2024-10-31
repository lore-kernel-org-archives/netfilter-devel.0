Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4078E156CF
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 14:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730384384; cv=none; b=TAMJc1lnbsgSaSAVNJjjgI9K22sIDPt4wCt4mIVYwLRIj3XBjMMogoXS4hzzcHfylbZdvR/VNieQ7ERPvk1oitKy2sGCN6xUKnLXY4G0oESVAc0EsGMxOsKm7tRhqOuFK9xTlWGMLjI2XF5tyjJmTQkJ0LF5f5F2OnBSWd9ywgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730384384; c=relaxed/simple;
	bh=PqnTZOQ9gwg2UQQCeuabF9o2lw49xUOLxsLXVyamakY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYKuxqSlyD7a04MhC9Aqrnisw4W9oZ/e2RmlFBYdIqTFReMgWyGjIx7M3/84CVEBmH5MQt8BsdzJchjQaXJF9uAUNNvRkYFukuOKjtG4SPgKijIzg9X25c8vE7CJdI8ImOfNuzRaTVP0pj1Xt3yI8elTEUvA9pqjpxRDvlfG3GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=T0AdyBsV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="T0AdyBsV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Y2dDCspGykYPZOWDcH9NJVSFIa7rpdq6RJpUzYthk1g=; b=T0AdyBsV12MWVx5xbdOVM8Vt7X
	u90zoR9c7eotC2zTl6lYtlbj6uwjvmAJfEXGeXd7++rLkb6/PMZkr/wdGwk+k97J97o6uuu55VS15
	ISQ2YYD/v2W9nQTB1nKDBQ9cEG0os7RNpmdvaYCHvU+XUi4eKcNsMj1tu64d7q4/sRO7kAA5q2vZL
	Bi399FmtuOpvNCQuwce6HmJM/3i8wV+ylmbtOIcL0o4l9aOfCGXbrlMzMz3Ls3L5UuPULnemsKtz6
	OIp6/KIVRBHdWWKVoe9hP+vPxIQUNWFgUmZlV+V9z+AHkVkRhZXk+x0AnWLjVNcRn6mJ6FuoC+tBy
	VswrgpGA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t6W1R-000000000Go-0PT6;
	Thu, 31 Oct 2024 15:19:38 +0100
Date: Thu, 31 Oct 2024 15:19:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 06/16] netfilter: nf_tables: Tolerate chains
 with no remaining hooks
Message-ID: <ZyOR-X0c6ToIR90y@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-7-phil@nwl.cc>
 <20241031140104.GA21912@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031140104.GA21912@breakpoint.cc>

On Thu, Oct 31, 2024 at 03:01:04PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Do not drop a netdev-family chain if the last interface it is registered
> > for vanishes. Users dumping and storing the ruleset upon shutdown for
> > restore upon next boot may otherwise lose the chain and all contained
> > rules. They will still lose the list of devices, a later patch will fix
> > that. For now, this aligns the event handler's behaviour with that for
> > flowtables.
> > The controversal situation at netns exit should be no problem here:
> > event handler will unregister the hooks, core nftables cleanup code will
> > drop the chain itself.
> 
> This "breaks" 
> W: [DUMP FAIL]  1/2 tests/shell/testcases/json/netdev
> W: [DUMP FAIL]  2/2 tests/shell/testcases/chains/netdev_chain_0
> 
> any suggestions on how to handle this?
> 
> We can't fix the dump because old kernel will axe the empty basechain.

AFAIR, we did just that in the past with such cases. I agree, it pretty
much breaks any efforts at making the testsuite usable with stable
kernels.

> Should the dump files be removed?

Maybe "feature flag" it and introduce a mechanism for test cases to
revert to a different dump file?

Or we convince Pablo to axe his efforts at fixing chain deletion in
stable kernels and instead backport my "zombie chain" feature. ;)

Cheers, Phil
