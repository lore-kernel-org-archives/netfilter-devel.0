Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D994175A87
	for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2026 10:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778064621; cv=none; b=sn4cXLk7htVLJ/UvInxvKYPHaoV9ilRHc+5QfC5JlVs+et8li+6t/0OfN2+riE+eR9Ppj+eM3GSFbHhALTKron3i+69F3MdI8s9xfjOxpJezkEiX1EneJT2Mcg0sG1ZPPtynBkEvPhE0UVm5JEVaal97qWmMMw4645AHCjKi6N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778064621; c=relaxed/simple;
	bh=4jpUi0CyrtrPxTR+07j0vnMzyMea6aKtVymiv4zcvVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLQz06QHXNSaUHNeODQYS0gOpAtEulAsMwh7rCQva/R16+Ck46/i7AanPOJBYmfkIjxPtK2uG0b4n71kZXlNPBG5Pb+AsfP+vcgjv6BGAJHA34KR3ckVvYss3lihpdEtms8FKK8RjyZ4rDge/E1zNOlA+Vm9MvCF0LBq34WEnoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fj/BlJ9F; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fj/BlJ9F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778064619; x=1809600619;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4jpUi0CyrtrPxTR+07j0vnMzyMea6aKtVymiv4zcvVw=;
  b=Fj/BlJ9F//GjdFVnYi+Sxr+z+YzK3CbRjcmO3F1p7rUSZ1Y4eKcXOG3k
   ybF4V4fb3Q9RaA4o/vmJpex2iOnG72zaPJj1Buisze5mjMYsuZQLSJsIJ
   qzcYKyWwmvcuTVRijnPMq49zdFsosTUZrUY4lnSBForvc6K1fA/wrn/Y7
   +bHv0xyg7ivZ+kwK9zGjqI2LamNU0JpJ6EvVzVuUMuvIvi7luqs06SwYn
   /60H7EslywIjILoMpKTfIN1DxvhpVPtwxEGeKUMKgZ2ydbsfefDcS6MH4
   dYpNIS7qzn7wwJUy2CZJLpepq8vSoDkv9gnKZQjmD2JkiKwWANR7DdL0J
   A==;
X-CSE-ConnectionGUID: BwZ3tv8lSQCbKvAleN0EJw==
X-CSE-MsgGUID: +PMfm+NeTNa3LRiIJG8Esg==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="96560899"
X-IronPort-AV: E=Sophos;i="6.23,219,1770624000"; 
   d="scan'208";a="96560899"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 03:50:18 -0700
X-CSE-ConnectionGUID: 6xKQI1ZKRvG8y3xNimhB3g==
X-CSE-MsgGUID: 3ZJuQ+1sQXeKsTWsarmY+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,219,1770624000"; 
   d="scan'208";a="235101075"
Received: from igk-lkp-server01.igk.intel.com (HELO bdf09bfdbd5f) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 06 May 2026 03:50:18 -0700
Received: from kbuild by bdf09bfdbd5f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wKZpX-000000006Y1-2A3H;
	Wed, 06 May 2026 10:50:15 +0000
Date: Wed, 6 May 2026 12:49:36 +0200
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH nf,v2 3/3] netfilter: nft_fwd_netdev: use recursion
 counter in neigh egress path
Message-ID: <202605061200.WFZDZGqQ-lkp@intel.com>
References: <20260422094444.198178-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422094444.198178-3-pablo@netfilter.org>

Hi Pablo,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on linus/master v7.1-rc2 next-20260505]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-nft_fwd_netdev-drop-packet-if-no-device-found-when-forwarding-via-neigh/20260425-072424
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20260422094444.198178-3-pablo%40netfilter.org
patch subject: [PATCH nf,v2 3/3] netfilter: nft_fwd_netdev: use recursion counter in neigh egress path
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20260506/202605061200.WFZDZGqQ-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260506/202605061200.WFZDZGqQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605061200.WFZDZGqQ-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nft_fwd_netdev.c: In function 'nft_fwd_neigh_eval':
>> net/netfilter/nft_fwd_netdev.c:101:40: error: 'skb' undeclared (first use in this function)
     101 |         int nhoff = skb_network_offset(skb);
         |                                        ^~~
   net/netfilter/nft_fwd_netdev.c:101:40: note: each undeclared identifier is reported only once for each function it appears in


vim +/skb +101 net/netfilter/nft_fwd_netdev.c

    93	
    94	static void nft_fwd_neigh_eval(const struct nft_expr *expr,
    95				      struct nft_regs *regs,
    96				      const struct nft_pktinfo *pkt)
    97	{
    98		struct nft_fwd_neigh *priv = nft_expr_priv(expr);
    99		void *addr = &regs->data[priv->sreg_addr];
   100		int oif = regs->data[priv->sreg_dev];
 > 101		int nhoff = skb_network_offset(skb);
   102		unsigned int verdict = NF_STOLEN;
   103		struct sk_buff *skb = pkt->skb;
   104		struct net_device *dev;
   105		int neigh_table;
   106	
   107		switch (priv->nfproto) {
   108		case NFPROTO_IPV4: {
   109			struct iphdr *iph;
   110	
   111			if (skb->protocol != htons(ETH_P_IP)) {
   112				verdict = NFT_BREAK;
   113				goto out;
   114			}
   115			if (skb_ensure_writable(skb, nhoff + sizeof(*iph))) {
   116				verdict = NF_DROP;
   117				goto out;
   118			}
   119			iph = ip_hdr(skb);
   120			if (iph->ttl <= 1) {
   121				verdict = NF_DROP;
   122				goto out;
   123			}
   124	
   125			ip_decrease_ttl(iph);
   126			neigh_table = NEIGH_ARP_TABLE;
   127			break;
   128			}
   129		case NFPROTO_IPV6: {
   130			struct ipv6hdr *ip6h;
   131	
   132			if (skb->protocol != htons(ETH_P_IPV6)) {
   133				verdict = NFT_BREAK;
   134				goto out;
   135			}
   136			if (skb_ensure_writable(skb, nhoff + sizeof(*ip6h))) {
   137				verdict = NF_DROP;
   138				goto out;
   139			}
   140			ip6h = ipv6_hdr(skb);
   141			if (ip6h->hop_limit <= 1) {
   142				verdict = NF_DROP;
   143				goto out;
   144			}
   145	
   146			ip6h->hop_limit--;
   147			neigh_table = NEIGH_ND_TABLE;
   148			break;
   149			}
   150		default:
   151			verdict = NFT_BREAK;
   152			goto out;
   153		}
   154	
   155		dev = dev_get_by_index_rcu(nft_net(pkt), oif);
   156		if (dev == NULL)
   157			return;
   158	
   159		skb->dev = dev;
   160		skb_clear_tstamp(skb);
   161		neigh_xmit(neigh_table, dev, addr, skb);
   162	out:
   163		regs->verdict.code = verdict;
   164	}
   165	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
