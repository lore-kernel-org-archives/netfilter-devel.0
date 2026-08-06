Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A959DDA9
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 01:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785979665; cv=none; b=mLj272JKSn1tXf2cyGGT2DSM091MC13jo7McQhbKKA1OE7yEqlhJH99SdQH0zS3YWt5NJU5KLbrx7hq/OWY/odI5TKcdzIbwQezzGq4UGhCN9x5TCuADZqzYDJi7yIDBMKPdIMF7GpKj0m6x3L2PjVsGKUKI20QPcfUfPb08Xzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785979665; c=relaxed/simple;
	bh=LJr84/ufAH8R/Sxi/uyEeNl1mRm+h/wTBaV2da/pzyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpgMnpWy+92qIbSqbAsn+UY2y8rNB3oOlsN3lwgQBgdcmuCUuOmzajBYpGwgPbOBjJNX9GsCXIDfc/4zG2QU+OYfc/xa7QueSxwU4uJ5CdOa1tyK32oWGfwdhrIa7UqQeiQx27K6iFVsDRX8By30tqs0OVb91GEQNOfyI/NwTf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O4Aon/6S; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O4Aon/6S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785979664; x=1817515664;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LJr84/ufAH8R/Sxi/uyEeNl1mRm+h/wTBaV2da/pzyc=;
  b=O4Aon/6S9jqsBYQJ4LgjnfxMhUCzvxPfU9u8LbdJo8SOYw2Ii1O4j0YN
   riuRnVERd9P5eMFmKLUSRGq9/LJkG/GUpPWOT+0ITUR3xQQco8e8xguvn
   qZDYUCN7cw+D6njpUa8QpJsKneJfRNCpvxbdMNCGp5JxUUAUSyK3aFlFP
   2BE40Ww4y1S/9pfu57pI1jvv7TgrJRNQeyp7NUaShDfaby98/wCK8z9TZ
   GBFzBMmQxygA4/WIEsohDWLHXa62Gxnd5++rS9tTKlcY2aEigydrNGARY
   36kw05R8Y8H7DBrqfnIgdCPy3ZOJBZ5Xg0VzHtbacHjnmOmgtaWqnrrA1
   A==;
X-CSE-ConnectionGUID: NTn7zRhUScW0lNc/31pUGA==
X-CSE-MsgGUID: 0JeO0wulSSmZsKn/t5D4sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="86594413"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="86594413"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 18:27:43 -0700
X-CSE-ConnectionGUID: y3zXd28/Tca7ZVV8+p6mmw==
X-CSE-MsgGUID: C5nXk/HJTVSKkuH1op5EzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="267098328"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 05 Aug 2026 18:27:42 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wrmtX-00000000Dt7-2dgn;
	Thu, 06 Aug 2026 01:27:39 +0000
Date: Thu, 6 Aug 2026 09:27:39 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, fw@strlen.de,
	ericwouds@gmail.com
Subject: Re: [PATCH nf-next,v5] netfilter: flowtable: initial bridge support
Message-ID: <202608060907.TfJm13ei-lkp@intel.com>
References: <20260713123650.1656551-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713123650.1656551-1-pablo@netfilter.org>

Hi Pablo,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on nf-next/main linus/master v7.2-rc6 next-20260805]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-flowtable-initial-bridge-support/20260805-124729
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20260713123650.1656551-1-pablo%40netfilter.org
patch subject: [PATCH nf-next,v5] netfilter: flowtable: initial bridge support
config: loongarch-randconfig-001-20260806 (https://download.01.org/0day-ci/archive/20260806/202608060907.TfJm13ei-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260806/202608060907.TfJm13ei-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608060907.TfJm13ei-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/netfilter/nft_flow_offload.c:153:21: error: call to undeclared function 'nf_bridge_info_exists'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     153 |         if (!pkt->flags || nf_bridge_info_exists(pkt->skb))
         |                            ^
   1 error generated.


vim +/nf_bridge_info_exists +153 net/netfilter/nft_flow_offload.c

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
 > 153		if (!pkt->flags || nf_bridge_info_exists(pkt->skb))
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
