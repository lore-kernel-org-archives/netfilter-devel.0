Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873BD1FAEE0
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2024 17:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729791343; cv=none; b=Gp1Y5MHi51LhheiCY05nGDcVpLledFsFMgIugieuG/9ecm162546CvxHxJu6cq93E7Yp/pNa1QUX5mxxj7DH0GtrksP21F7kDn1Vs7YNKrJ/3ypWu5xryyy6/wE1SsArmi7UwGyIqTiCUdboDhh/zxPPZTXxEDqvTxxmQPBgWZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729791343; c=relaxed/simple;
	bh=g5ji9L0VmySsOekN9d+u3YbWvXD5IXFer0M/BlLMITU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJZDTPwkXtJ7MeC3/DnIMaQMm55H5FDVUj8WjDC8/2q/OCJQ5ewbb3G03yqt79LjDnJZMywUUDrmsQzbhXXoTqnkIrkRZwZbdYqSvdvkqKDD9QAL+mJk/ENrhLyZYJLiILTAvPgbfX3bJ/n6RmF0SW1Jsx8+GDM7pp+k/y5armA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t41kG-0002xp-7k; Thu, 24 Oct 2024 19:35:36 +0200
Date: Thu, 24 Oct 2024 19:35:36 +0200
From: Florian Westphal <fw@strlen.de>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org
Subject: Re: Netfilter: suspicious RCU usage in __nft_rule_lookup
Message-ID: <20241024173536.GA11075@breakpoint.cc>
References: <da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Matthieu Baerts <matttbe@kernel.org> wrote:
> Hello,
> 
> First, thank you for all the work you did and are still doing around
> Netfilter!
> 
> I'm writing you this email, because when I run the MPTCP test suite with
> a VM running a kernel built with a debug config including
> CONFIG_PROVE_RCU_LIST=y (and CONFIG_RCU_EXPERT=y), I get the following
> warning:
> 
> 
> > 6.12.0-rc3+ #7 Not tainted
> > -----------------------------
> > net/netfilter/nf_tables_api.c:3420 RCU-list traversed in non-reader section!!
> > 
> > other info that might help us debug this:
> > 
> > rcu_scheduler_active = 2, debug_locks = 1
> > 1 lock held by iptables/134:
> >   #0: ffff888008c4fcc8 (&nft_net->commit_mutex){+.+.}-{3:3}, at: nf_tables_valid_genid (include/linux/jiffies.h:101) nf_tables

List is protected by transaction mutex, but we can't switch to plain
for_each_entry as this is also called from rcu-only context.

We either need two functions or pass nft_net + lockdep_is_held() check
as extra arg.
