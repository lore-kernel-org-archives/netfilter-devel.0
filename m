Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E73347ECDD
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 10:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455580; cv=none; b=TE6pG485FL7qIc00Z7f/6bVKkWRWo0uUGrlq4Aci9LkyE4baNghbRTwlVdrRVOOsaiMptzlE8HQCesRSOWFtCY6IbKkfCfY449k5Hvx+iYNlhBMt0oRdQS0utj8c2BezAbBZ1JbRWqjV6JB6jLKkNzQv0489HhYqj+cVWEEw6qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455580; c=relaxed/simple;
	bh=F8oB4nz+KzCOmBWhs+99SSv9SKow9ZXFPyytgyJJoII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FqLfZzz24DdhzODXBMA2PXp9ObG/V3m0J4M1ntUJ0vZ/MbclunAtJnBivjCnNSS5dFmBuZMUMYZv/cSe19tReNlI6+ymVT8Ji5WIt1Uq3P7aK/C5lHXgTxSsECw21ZfCBjulzGiNNBktES2ap3z9J9yr4pW8+gnCWGt+KPTg9MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J8AMiEqZ; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J8AMiEqZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791455578; x=1822991578;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F8oB4nz+KzCOmBWhs+99SSv9SKow9ZXFPyytgyJJoII=;
  b=J8AMiEqZ9NHtSc2KiDJVQHTldKQKlI+XDUVMQKZxL+lY5vj0WOuitckx
   jZuVfl5mCGLOk1FEp8xPwN00aAmyEW8CALKXMxJj7D5b9seopT6PUlRMV
   yfTgK+wheO7h7bVrw/9Zlfm4+vNoMEGH/4mvY1WCq02vSw5HZlgZGhoLo
   A71O9UGZuiEwoxcnmQGjtpPWQVTCio1Fz4c+y+mFrZfGBf0zFFSnJvA0r
   8pzprFGRCvEPzs6SE2ohHNkpV0Q4WNzykGcfYEx97DvsXI49vtZ4Y45WU
   bnf6/Y5oxTDPHfBVpwjFuRjma+6/d30mR+ATC6rScRQfXUIzfrS5KDOwH
   g==;
X-CSE-ConnectionGUID: GRO9tsPxSuqoI/A11ot/1g==
X-CSE-MsgGUID: 6vDu4ZXlQVGffV/2PewQgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="132376"
X-IronPort-AV: E=Sophos;i="6.27,146,1787036400"; 
   d="scan'208";a="132376"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 03:32:57 -0700
X-CSE-ConnectionGUID: pbe7iY/nRPKiGyMX9QXRMw==
X-CSE-MsgGUID: AHj+kF7zQViLj4rrLr1B4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,146,1787036400"; 
   d="scan'208";a="1835113"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa012.fm.intel.com with ESMTP; 08 Oct 2026 03:32:56 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xElQj-000000004Hs-3EsZ;
	Thu, 08 Oct 2026 10:32:53 +0000
Date: Thu, 8 Oct 2026 18:32:13 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH nf-next,v5] netfilter: flowtable: initial bridge support
Message-ID: <202610081819.r6CZgkAI-lkp@intel.com>
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
config: s390-defconfig (https://download.01.org/0day-ci/archive/20261008/202610081819.r6CZgkAI-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261008/202610081819.r6CZgkAI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610081819.r6CZgkAI-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/netfilter/nft_flow_offload.c:153:35: error: use of undeclared identifier 'skb'
     153 |         if (!pkt->flags || skb_ext_exist(skb, SKB_EXT_BRIDGE_NF))
         |                                          ^
   1 error generated.
--
>> net/netfilter/nf_flow_table_path.c:342:41: error: too many arguments to function call, expected 2, have 3
     342 |         if (dev_fill_forward_path(dev, dst_ha, &stack) < 0 ||
         |             ~~~~~~~~~~~~~~~~~~~~~              ^~~~~~
   include/linux/netdevice.h:3440:5: note: 'dev_fill_forward_path' declared here
    3440 | int dev_fill_forward_path(struct net_device_path_ctx *ctx,
         |     ^                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    3441 |                           struct net_device_path_stack *stack);
         |                           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> net/netfilter/nf_flow_table_path.c:343:47: error: incompatible pointer types passing 'struct nf_flowtable *' to parameter of type 'struct nft_flowtable *' [-Werror,-Wincompatible-pointer-types]
     343 |             nft_dev_path_info(&stack, &info, dst_ha, &ft->data) < 0)
         |                                                      ^~~~~~~~~
   net/netfilter/nf_flow_table_path.c:108:50: note: passing argument to parameter 'ft' here
     108 |                              unsigned char *ha, struct nft_flowtable *ft)
         |                                                                       ^
>> net/netfilter/nf_flow_table_path.c:346:35: error: no member named 'indev' in 'struct nft_forward_info'
     346 |         if (!nft_flowtable_find_dev(info.indev, ft))
         |                                     ~~~~ ^
   net/netfilter/nf_flow_table_path.c:349:28: error: no member named 'indev' in 'struct nft_forward_info'
     349 |         this_tuple->iifidx = info.indev->ifindex;
         |                              ~~~~ ^
   4 errors generated.


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
