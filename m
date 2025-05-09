Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B51A280330
	for <netfilter-devel@vger.kernel.org>; Fri,  9 May 2025 09:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746782874; cv=none; b=gH+cTOc/6xOM+TgdI0gSRamFrDaDuywdC3WF4Urr3LGFGPlSBFF8DP77j/XOwSa2fIYpiHtBQB8fr4YfhAbFzOetZ5zo0tZljMsZ2JKcXeJkjhRWy1EUMdzPAdf0iq7IPaKiKcrgAyG1lUoRwnyvi5ycLWCfISoXobUisDVcq/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746782874; c=relaxed/simple;
	bh=1J8MT/W/0uZNPCfPqtdak0LydosPKFFHLJG8zEaKAHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCvVacB2A7rE9Zx9vRPZc9YdFCtUAVzwAQ7SXqMI7CLxPs31dX5ty4Jq2uU7p3vcNhQTslr+KVZZ5VxCXozNrodgO1xE6gcgzUz7C2/g+ZVINE5ZRhNvqXXi+eL34KuXLhqU0ZctghyN6I5oF9OTch40M23rgVib62FDpdV218o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jtCHjnrK; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jtCHjnrK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746782873; x=1778318873;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1J8MT/W/0uZNPCfPqtdak0LydosPKFFHLJG8zEaKAHY=;
  b=jtCHjnrKD0dFZO2F4WJBdyK7T0g2VVxmTKDPPzENuPnr1Tf7Uie78LYA
   uVBN9TA53Wn8LANZ7H6RXIoVTGbaOYqF8fSA3Wr4wDazDwdHDqiswixGz
   vlq5T2pTg800cRGBOcilc5pIMViEVd+b0AaEBDsWtuzwxsTGPQge5Q36+
   jF2QUh47xZxZ1kTNgtn25nOVZmAge1j1MPFUAXF24TenUbNGV93Ji5VHm
   4Psh57ewczsDdZ8JiCtNQhOG8EmUDimqu2MIklXrC3WeFhpThzGJRE8oG
   UKZ46h/WtCjCQ+g74VBE5jAJRXU3nH9MXpnbpbOiY/0O+buMsnjCzfj32
   g==;
X-CSE-ConnectionGUID: Xbao6bruQty5ptRIr8vaEA==
X-CSE-MsgGUID: Jp6dbXfdSROVS1/MwweFmQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48760107"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="48760107"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:27:52 -0700
X-CSE-ConnectionGUID: Zc/9gTJfSf+UO74vrpbDSA==
X-CSE-MsgGUID: Y4IogcLHSRu65rTzJ2cz9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="136450591"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 09 May 2025 02:27:51 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uDK1E-000Brb-0m;
	Fri, 09 May 2025 09:27:48 +0000
Date: Fri, 9 May 2025 17:27:22 +0800
From: kernel test robot <lkp@intel.com>
To: Shaun Brady <brady.1345@gmail.com>, netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, ppwaskie@kernel.org, fw@strlen.de
Subject: Re: [PATCH v2] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <202505091702.01RMXhZx-lkp@intel.com>
References: <20250506024900.1568391-1-brady.1345@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506024900.1568391-1-brady.1345@gmail.com>

Hi Shaun,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on linus/master v6.15-rc5 next-20250508]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shaun-Brady/netfilter-nf_tables-Implement-jump-limit-for-nft_table_validate/20250506-150258
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20250506024900.1568391-1-brady.1345%40gmail.com
patch subject: [PATCH v2] netfilter: nf_tables: Implement jump limit for nft_table_validate
config: arm-randconfig-001-20250509 (https://download.01.org/0day-ci/archive/20250509/202505091702.01RMXhZx-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 7.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250509/202505091702.01RMXhZx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505091702.01RMXhZx-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nf_tables_api.c: In function 'nft_chain_validate':
>> net/netfilter/nf_tables_api.c:4022:29: error: 'struct netns_nf' has no member named 'nf_max_table_jumps_netns'
       jump_check = ctx->net->nf.nf_max_table_jumps_netns;
                                ^


vim +4022 net/netfilter/nf_tables_api.c

  4003	
  4004	/** nft_chain_validate - loop detection and hook validation
  4005	 *
  4006	 * @ctx: context containing call depth and base chain
  4007	 * @chain: chain to validate
  4008	 *
  4009	 * Walk through the rules of the given chain and chase all jumps/gotos
  4010	 * and set lookups until either the jump limit is hit or all reachable
  4011	 * chains have been validated.
  4012	 */
  4013	int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
  4014	{
  4015		struct nft_expr *expr, *last;
  4016		struct nft_rule *rule;
  4017		int err;
  4018		u32 jump_check = nf_max_table_jumps_netns;
  4019	
  4020		if (IS_ENABLED(CONFIG_SYSCTL)) {
  4021			if (!net_eq(ctx->net, &init_net))
> 4022				jump_check = ctx->net->nf.nf_max_table_jumps_netns;
  4023		}
  4024	
  4025		if (ctx->level == NFT_JUMP_STACK_SIZE ||
  4026		    (!net_eq(ctx->net, &init_net) &&
  4027		    ctx->total_jump_count >= jump_check))
  4028			return -EMLINK;
  4029	
  4030		list_for_each_entry(rule, &chain->rules, list) {
  4031			if (fatal_signal_pending(current))
  4032				return -EINTR;
  4033	
  4034			if (!nft_is_active_next(ctx->net, rule))
  4035				continue;
  4036	
  4037			nft_rule_for_each_expr(expr, last, rule) {
  4038				if (!expr->ops->validate)
  4039					continue;
  4040	
  4041				/* This may call nft_chain_validate() recursively,
  4042				 * callers that do so must increment ctx->level.
  4043				 */
  4044				err = expr->ops->validate(ctx, expr);
  4045				if (err < 0)
  4046					return err;
  4047			}
  4048		}
  4049	
  4050		return 0;
  4051	}
  4052	EXPORT_SYMBOL_GPL(nft_chain_validate);
  4053	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
