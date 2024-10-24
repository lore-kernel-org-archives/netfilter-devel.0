Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403E41F585D
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2024 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729792824; cv=none; b=AvGnWVoW9WB44B/g6ImMYYw0kZIjKU3ojx++RhEN/bOYppJLkcMJ/U6Kwzl989VDvLkRPB6FWfrSUjIoCOG5/W/R4VWGwmfaelPQzAIvNLYyhPNxycLHVZDUpfPGp93lD8u7qIWSf/C9vH8QeX9arIBbLayoBnkAtDlynQMLJvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729792824; c=relaxed/simple;
	bh=tc0ARmi81lPvv4L+FRrLX2fd70uBvFCtOKLPWW4fczU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=upl3meIsbCFi2+GrlIHkfYsGcueKtCFdZHVobPMRJ6nh27Y+VsvvUIsAc1+ewdEflW9jSYILF+Kb+NPiU6+v20FfThLNLf65UbKbROk6X6VHIygFDyXi6E22YLW1bng4gY9GVOhxjgJy3a+AhM0rojnajzeXmN+asb/2ljdSXL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=60664 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t4289-004aaY-U7; Thu, 24 Oct 2024 20:00:20 +0200
Date: Thu, 24 Oct 2024 20:00:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Matthieu Baerts <matttbe@kernel.org>, netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org
Subject: Re: Netfilter: suspicious RCU usage in __nft_rule_lookup
Message-ID: <ZxqLMbWzJfSsJOCF@calendula>
References: <da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org>
 <20241024173536.GA11075@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241024173536.GA11075@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Thu, Oct 24, 2024 at 07:35:36PM +0200, Florian Westphal wrote:
> Matthieu Baerts <matttbe@kernel.org> wrote:
> > Hello,
> > 
> > First, thank you for all the work you did and are still doing around
> > Netfilter!
> > 
> > I'm writing you this email, because when I run the MPTCP test suite with
> > a VM running a kernel built with a debug config including
> > CONFIG_PROVE_RCU_LIST=y (and CONFIG_RCU_EXPERT=y), I get the following
> > warning:
> > 
> > 
> > > 6.12.0-rc3+ #7 Not tainted
> > > -----------------------------
> > > net/netfilter/nf_tables_api.c:3420 RCU-list traversed in non-reader section!!
> > > 
> > > other info that might help us debug this:
> > > 
> > > rcu_scheduler_active = 2, debug_locks = 1
> > > 1 lock held by iptables/134:
> > >   #0: ffff888008c4fcc8 (&nft_net->commit_mutex){+.+.}-{3:3}, at: nf_tables_valid_genid (include/linux/jiffies.h:101) nf_tables
> 
> List is protected by transaction mutex, but we can't switch to plain
> for_each_entry as this is also called from rcu-only context.
> 
> We either need two functions or pass nft_net + lockdep_is_held() check
> as extra arg.

Right, I can see _rcu is still needed for the nf_tables_getrule_single() case.
