Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D5A2003A8
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2024 18:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729794068; cv=none; b=VAjbUWWRTNbMJj5TOqQh4S8VT/A1oJLdFAbHPUPcPTBk9wd0aZQvq5glS5P+g4bP4Cf1QoScC7l2Kcyor1ptoqlfAat04u6Jl0flaCGA6BvVl8rigZl51v3gqkWtNJc4ClLbZ/yd0BnGNPAai4dZLKRoSHGwObOe1IOiqUy4AHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729794068; c=relaxed/simple;
	bh=jI8a6DHoq+S4xBSj/EWDo88AMXnIVIOI4n0Tl6/WKk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lx+P/id3ASP6P5JDgopX/JLpTvvzOHGrf8EYpkvOOQT1iOnVu0AhN+jqEFfG8t7GFftEMp+4LZsL7Tszlcnkl8dTlAHXAqhRgbeH04hOrmE6ReUORg2HjUXu2IC1UkkicHQXud3jBzwthaE9ET8cI0uGV5NOxqS9Z6HZF/NucMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=36052 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t42SD-004eJ5-BS; Thu, 24 Oct 2024 20:21:03 +0200
Date: Thu, 24 Oct 2024 20:20:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org
Subject: Re: Netfilter: suspicious RCU usage in __nft_rule_lookup
Message-ID: <ZxqQAIlQx8C1E6FK@calendula>
References: <da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org>
 <ZxqKkVCnyOqHjFq-@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZxqKkVCnyOqHjFq-@calendula>
X-Spam-Score: -1.8 (-)

On Thu, Oct 24, 2024 at 07:57:40PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Thu, Oct 24, 2024 at 06:56:43PM +0200, Matthieu Baerts wrote:
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
> > > =============================
> > > WARNING: suspicious RCU usage
> > > 6.12.0-rc3+ #7 Not tainted
> > > -----------------------------
> > > net/netfilter/nf_tables_api.c:3420 RCU-list traversed in non-reader section!!
> > > 
> > > other info that might help us debug this:
> > > 
> > > 
> > > rcu_scheduler_active = 2, debug_locks = 1
> > > 1 lock held by iptables/134:
> > >   #0: ffff888008c4fcc8 (&nft_net->commit_mutex){+.+.}-{3:3}, at: nf_tables_valid_genid (include/linux/jiffies.h:101) nf_tables
> > > 
> > > stack backtrace:
> > > CPU: 1 UID: 0 PID: 134 Comm: iptables Not tainted 6.12.0-rc3+ #7
> > > Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> > > Call Trace:
> > >  <TASK>
> > >  dump_stack_lvl (lib/dump_stack.c:123)
> > >  lockdep_rcu_suspicious (kernel/locking/lockdep.c:6822)
> > >  __nft_rule_lookup (net/netfilter/nf_tables_api.c:3420 (discriminator 7)) nf_tables
> 
> This is a _rcu notation which is not correct, while mutex is held, it
> was introduced here:
> 
> d9adf22a2918 ("netfilter: nf_tables: use call_rcu in netlink dumps")

Hm. There is also:

3cb03edb4de3 ("netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests")

this comment below is also not valid anymore:

/* called with rcu_read_lock held */
static struct sk_buff *
nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
                         const struct nlattr * const nla[], bool reset)

This is not the only spot that can trigger rcu splats.
