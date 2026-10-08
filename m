Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA58D3B6BFA
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 09:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791452817; cv=none; b=O1X2hUv+cZvU0wZ+7tu+rmyHqjTN7spe5w2/qDhv0CGI+ufsi0eLiHJ4fPgtwdqFNvdElOoN6oMejLiqSZTXQYO0LAPJMcQLovqAYj9A2HCtQ6SJg01F95YSoKCYe+a8H3kRvUhLu5dNxccr4yy03v/sdPTDnPBWGaAtHHbnpV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791452817; c=relaxed/simple;
	bh=X33O9maeQCsCXYaIiVKGDwXxjSvXnjSLx2O7U6342Vs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tf/cTYiu6OUK6MByUdrHvKGk0X83KDNpo3jpIksNXHSbpajkEReeEKY81HHXZHN5vlq6rbFraHKHI675NJTr90ypkCosdHgxCP4cb7xDe5dAc1ErSeClk0fekb6j+P6aO4XLRXtL1DQQtyQsEyNqnIfeaXC/PP9Ub1DcZizsfy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N50Mk+7P; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N50Mk+7P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791452815; x=1822988815;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X33O9maeQCsCXYaIiVKGDwXxjSvXnjSLx2O7U6342Vs=;
  b=N50Mk+7PkFHgiEQ1Mr+bi09cXzpDKEkPXxRtE3snLJSbHmJe6xOOvkhh
   jF+l7A8Wda3xkFax4EWk54xDKpTi1zsSHUMadZkwF6U3+ycY/fHukNgOA
   gaY6SN7/N+prSs6OVNJemIkh8rMzwOMOMXfzbhR+MIOZzH+YKBq6zfOmv
   pJhUll7BEBzcVf2c8MSEvR57cG5wsSKYPEUltFDnNTRfitnxF2QjrfVC1
   kOf7OosH+a9G5gBZ9J/9vKpxSZczdGEPYUcTUzySNaR3FbJQ6jRjJx4FW
   Dueu7d8QEm9+lSjeGAyeIvuBJFK/4LG9FOtOsZknFSA19YV+2v3YPcBBJ
   w==;
X-CSE-ConnectionGUID: 2tRoNutdRjmkKuRbAG5aHw==
X-CSE-MsgGUID: oKunrT92T3+Hw2pU0fc6rw==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="120562"
X-IronPort-AV: E=Sophos;i="6.27,146,1787036400"; 
   d="scan'208";a="120562"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 02:46:54 -0700
X-CSE-ConnectionGUID: yflCDbmGT2qBPZhJLYHi0Q==
X-CSE-MsgGUID: F2fYfCWqTy6FzVWV+gohDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,146,1787036400"; 
   d="scan'208";a="4059"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 08 Oct 2026 02:46:53 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xEkiB-000000004F6-0ryV;
	Thu, 08 Oct 2026 09:46:51 +0000
Date: Thu, 8 Oct 2026 17:46:15 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH nf-next,v5] netfilter: flowtable: initial bridge support
Message-ID: <202610081758.VzMeMAKv-lkp@intel.com>
References: <20261007222057.1141093-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007222057.1141093-1-pablo@netfilter.org>

Hi Pablo,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on nf-next/main linus/master v7.3-rc6 next-20261006]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-flowtable-initial-bridge-support/20261008-002056
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20261007222057.1141093-1-pablo%40netfilter.org
patch subject: [PATCH nf-next,v5] netfilter: flowtable: initial bridge support
config: parisc-randconfig-1001-20261008 (https://download.01.org/0day-ci/archive/20261008/202610081758.VzMeMAKv-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261008/202610081758.VzMeMAKv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610081758.VzMeMAKv-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nft_flow_offload.c: In function 'nft_flow_offload_bridge_eval':
>> net/netfilter/nft_flow_offload.c:153:35: error: 'skb' undeclared (first use in this function)
     153 |  if (!pkt->flags || skb_ext_exist(skb, SKB_EXT_BRIDGE_NF))
         |                                   ^~~
   net/netfilter/nft_flow_offload.c:153:35: note: each undeclared identifier is reported only once for each function it appears in
>> net/netfilter/nft_flow_offload.c:153:40: error: 'SKB_EXT_BRIDGE_NF' undeclared (first use in this function)
     153 |  if (!pkt->flags || skb_ext_exist(skb, SKB_EXT_BRIDGE_NF))
         |                                        ^~~~~~~~~~~~~~~~~
--
   net/netfilter/nf_flow_table_path.c: In function 'nft_dev_fill_bridge_path':
>> net/netfilter/nf_flow_table_path.c:342:28: error: passing argument 1 of 'dev_fill_forward_path' from incompatible pointer type [-Werror=incompatible-pointer-types]
     342 |  if (dev_fill_forward_path(dev, dst_ha, &stack) < 0 ||
         |                            ^~~
         |                            |
         |                            const struct net_device *
   In file included from include/linux/etherdevice.h:21,
                    from net/netfilter/nf_flow_table_path.c:5:
   include/linux/netdevice.h:3440:55: note: expected 'struct net_device_path_ctx *' but argument is of type 'const struct net_device *'
    3440 | int dev_fill_forward_path(struct net_device_path_ctx *ctx,
         |                           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   net/netfilter/nf_flow_table_path.c:342:33: error: passing argument 2 of 'dev_fill_forward_path' from incompatible pointer type [-Werror=incompatible-pointer-types]
     342 |  if (dev_fill_forward_path(dev, dst_ha, &stack) < 0 ||
         |                                 ^~~~~~
         |                                 |
         |                                 unsigned char *
   In file included from include/linux/etherdevice.h:21,
                    from net/netfilter/nf_flow_table_path.c:5:
   include/linux/netdevice.h:3441:36: note: expected 'struct net_device_path_stack *' but argument is of type 'unsigned char *'
    3441 |      struct net_device_path_stack *stack);
         |      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~
>> net/netfilter/nf_flow_table_path.c:342:6: error: too many arguments to function 'dev_fill_forward_path'
     342 |  if (dev_fill_forward_path(dev, dst_ha, &stack) < 0 ||
         |      ^~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/etherdevice.h:21,
                    from net/netfilter/nf_flow_table_path.c:5:
   include/linux/netdevice.h:3440:5: note: declared here
    3440 | int dev_fill_forward_path(struct net_device_path_ctx *ctx,
         |     ^~~~~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_flow_table_path.c:343:47: error: passing argument 4 of 'nft_dev_path_info' from incompatible pointer type [-Werror=incompatible-pointer-types]
     343 |      nft_dev_path_info(&stack, &info, dst_ha, &ft->data) < 0)
         |                                               ^~~~~~~~~
         |                                               |
         |                                               struct nf_flowtable *
   net/netfilter/nf_flow_table_path.c:108:50: note: expected 'struct nft_flowtable *' but argument is of type 'struct nf_flowtable *'
     108 |         unsigned char *ha, struct nft_flowtable *ft)
         |                            ~~~~~~~~~~~~~~~~~~~~~~^~
>> net/netfilter/nf_flow_table_path.c:346:35: error: 'struct nft_forward_info' has no member named 'indev'; did you mean 'dev'?
     346 |  if (!nft_flowtable_find_dev(info.indev, ft))
         |                                   ^~~~~
         |                                   dev
   net/netfilter/nf_flow_table_path.c:349:28: error: 'struct nft_forward_info' has no member named 'indev'; did you mean 'dev'?
     349 |  this_tuple->iifidx = info.indev->ifindex;
         |                            ^~~~~
         |                            dev
   cc1: some warnings being treated as errors


vim +/skb +153 net/netfilter/nft_flow_offload.c

   138	
   139	static void nft_flow_offload_bridge_eval(const struct nft_expr *expr,
   140						 struct nft_regs *regs,
   141						 const struct nft_pktinfo *pkt)
   142	{
   143		struct nft_flow_offload *priv = nft_expr_priv(expr);
   144		struct nf_flowtable *flowtable = &priv->flowtable->data;
   145		struct tcphdr _tcph, *tcph = NULL;
   146		enum ip_conntrack_info ctinfo;
   147		struct flow_offload *flow;
   148		enum ip_conntrack_dir dir;
   149		struct nf_conn *ct;
   150		int ret;
   151	
   152		/* Is this a non-IP packet or br_netfilter? If so, skip. */
 > 153		if (!pkt->flags || skb_ext_exist(skb, SKB_EXT_BRIDGE_NF))
   154			goto out;
   155	
   156		ct = nf_ct_get(pkt->skb, &ctinfo);
   157		if (!ct || !nf_ct_is_confirmed(ct))
   158			goto out;
   159	
   160		/* Unlikely, conntrack bridge should not see neither helpers nor NAT in
   161		 * the bridge forward path.
   162		 */
   163		if (nf_ct_ext_exist(ct, NF_CT_EXT_HELPER) ||
   164		    ct->status & (IPS_SEQ_ADJUST | IPS_NAT_CLASH))
   165			goto out;
   166	
   167		switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
   168		case IPPROTO_TCP:
   169			tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
   170						  sizeof(_tcph), &_tcph);
   171			if (unlikely(!tcph || tcph->fin || tcph->rst ||
   172				     !nf_conntrack_tcp_established(ct)))
   173				goto out;
   174			break;
   175		case IPPROTO_UDP:
   176			break;
   177		default:
   178			goto out;
   179		}
   180	
   181		if (test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status))
   182			goto out;
   183	
   184		flow = flow_offload_alloc(ct);
   185		if (!flow)
   186			goto err_flow_forward;
   187	
   188		dir = CTINFO2DIR(ctinfo);
   189		if (nft_flow_bridge(flow, pkt, dir, priv->flowtable) < 0)
   190			goto err_flow_add;
   191	
   192		if (tcph)
   193			flow_offload_ct_tcp(ct);
   194	
   195		__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
   196		ret = flow_offload_add(flowtable, flow);
   197		if (ret < 0)
   198			goto err_flow_add;
   199	
   200		return;
   201	
   202	err_flow_add:
   203		flow_offload_free(flow);
   204	err_flow_forward:
   205		clear_bit(IPS_OFFLOAD_BIT, &ct->status);
   206	out:
   207		regs->verdict.code = NFT_BREAK;
   208	}
   209	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
