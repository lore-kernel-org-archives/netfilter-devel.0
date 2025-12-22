Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9814C92;
	Mon, 22 Dec 2025 11:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766402179; cv=none; b=F6KQ4OI5FShknNS9pqx7K4QKbU4C1q5gfiwqHABJPs5JbuhyR/BNtvn9cE13Ugg37GfWvDpX1yX+drJFoidJpDd0NA//BpUsM1GMQXNELuveME1Vgfp5sMKDRR7rS1ZqFeesvheWbym7NpwoFjJLr2jfJAuQhHoI67eC4tvlMQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766402179; c=relaxed/simple;
	bh=sQUk61QA1ZJkorbZTrc9V1U1NZi5XOWVjC84QQSvmtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vl0+sAYpP92iG9bDQuesnTvsSVqvYvJRtuXgMLyJnR3L+zHZbifCqc89iGkDqz0vHCcjLZarNAXwIGPs0PeFmlmRWzAQ8maAxDKiITRMNvxmqhk7lgeIZpXKp756lqR6TO9AExxxegQ3n8ZMASH+4Lqe5teSr0A+1dE90elhFUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8363B60298; Mon, 22 Dec 2025 12:16:14 +0100 (CET)
Date: Mon, 22 Dec 2025 12:16:14 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: syzbot <syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com>,
	coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, phil@nwl.cc,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] possible deadlock in
 nf_tables_dumpreset_obj
Message-ID: <aUkofscPurmzJ0Sh@strlen.de>
References: <6945f4b4.a70a0220.207337.0121.GAE@google.com>
 <aUh_3mVRV8OrGsVo@strlen.de>
 <aUkNtgPyic8_fBd5@chamomile>
 <aUkPz0extqKuB7Bl@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUkPz0extqKuB7Bl@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > CPU0: 'nft reset'.
> > > CPU1: 'ipset list' (anything in ipset doing a netlink dump op)
> > > CPU2: 'iptables-nft -A ... -m set ...'
> > > 
> > > ... can result in:
> > > 
> > > CPU0                    CPU1                            CPU2
> > > ----                    ----                            ----
> > > lock(nlk_cb_mutex-NETFILTER);
> > >                         lock(nfnl_subsys_ipset);
> > >                                                        lock(&nft_net->commit_mutex);
> > >                         lock(nlk_cb_mutex-NETFILTER);
> > >                                                        lock(nfnl_subsys_ipset);
> > > lock(&nft_net->commit_mutex);
> 
> Would it work to use a separated mutex for reset itself?

I think so, yes, its only job is to prevent concurrent reset actions,
the objects themselves are protected by rcu.

Parallel add/removal should be fine.
