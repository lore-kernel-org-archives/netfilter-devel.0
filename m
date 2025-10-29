Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AC5221294
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 04:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761713448; cv=none; b=Nw4y/oGsiNlMqDRt6QRx5+4p6Q739n62hUdhJM9YnaW4DFXjOgkujVb1/hykWdg+CygtNhNItKg1QxdpbWSJUSF0MUX6et4CPSkvm6kzgMqGcHFUG4rVTveE1zZyG8jysWtntJlPWVCJLc/RuQkq5ARsXbw/DWsaFoLWukXhAmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761713448; c=relaxed/simple;
	bh=m+xtCQlsQ2W/RTc69IEMvaWvvLYl73pqZWkjRlTO/jY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4ryYl2HBCg6Ti3V/pXkbJSweG1byVWahdWxG/O6YlM49Jfnfz2VAWtFU0iFDezHqeI66iXUqLaoZmyPfAqabwWB+SsUne3mg5CU6PIjN2SB1deNQ2qBfU/ISl+9HzrEeVTM6RE+cC50T/D2hP4vPdS662G8QYXhFS3ACB3Yh9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DkBs+fCh; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DkBs+fCh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761713447; x=1793249447;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m+xtCQlsQ2W/RTc69IEMvaWvvLYl73pqZWkjRlTO/jY=;
  b=DkBs+fChhr1Qr0A62jxyxR/+V1s16qNWvzVmweEGHFza3T67Yf4eM3sV
   SxobzLehCaJtoAdLW1RR7uKg3aoREocNuqf2HngAxRMPdx5MSEmoLICUb
   LqOoKuj4hEh7RIkg7KqNl4qUxyv4YuutpKsHE55GLVVSyL70ROagXCuoU
   x1gWll+gJ6R54/XLFUujwNu0/I6pG8Dxkh31AMaJcz54H3uF6Xyf5jAo6
   /IlYjaL9bpnSg+PDnuN6zCt9Z/fliYVRt0UbiOB/bZkwHMgrDKzDOeBOU
   mSx4rqtadJyoVXuFcnGXaD2Olo94+DJozBu/tjul0/fhuHMtY71qOZXpA
   w==;
X-CSE-ConnectionGUID: 5IsovDsNR+2we3S2DNCukg==
X-CSE-MsgGUID: 6wpnCpjORfqfOGh4pzYa/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63753424"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63753424"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 21:50:46 -0700
X-CSE-ConnectionGUID: 7z1IadphTougDt3CqOkDFw==
X-CSE-MsgGUID: pKbUsDDKTZ63BTHknyyYSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,263,1754982000"; 
   d="scan'208";a="216199959"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 28 Oct 2025 21:50:44 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vDy8p-000K9B-11;
	Wed, 29 Oct 2025 04:50:36 +0000
Date: Wed, 29 Oct 2025 12:49:58 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, fw@strlen.de,
	ffmancera@suse.de, brady.1345@gmail.com
Subject: Re: [PATCH nf 1/2] netfilter: nf_tables: limit maximum number of
 jumps/gotos per netns
Message-ID: <202510291201.P7nkKt1R-lkp@intel.com>
References: <20251027221722.183398-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027221722.183398-2-pablo@netfilter.org>

Hi Pablo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on linus/master v6.18-rc3 next-20251029]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables-limit-maximum-number-of-jumps-gotos-per-netns/20251028-062221
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20251027221722.183398-2-pablo%40netfilter.org
patch subject: [PATCH nf 1/2] netfilter: nf_tables: limit maximum number of jumps/gotos per netns
config: arm-randconfig-003-20251028 (https://download.01.org/0day-ci/archive/20251029/202510291201.P7nkKt1R-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project d1c086e82af239b245fe8d7832f2753436634990)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251029/202510291201.P7nkKt1R-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510291201.P7nkKt1R-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from net/netfilter/core.c:27:
   In file included from include/net/netfilter/nf_tables.h:13:
   In file included from include/net/netfilter/nf_flow_table.h:13:
   In file included from include/linux/if_pppox.h:17:
   include/uapi/linux/if_pppox.h:71:4: warning: field sa_addr within 'struct sockaddr_pppox' is less aligned than 'union (unnamed union at include/uapi/linux/if_pppox.h:68:2)' and is usually due to 'struct sockaddr_pppox' being packed, which can lead to unaligned accesses [-Wunaligned-access]
      71 |         } sa_addr;
         |           ^
>> net/netfilter/core.c:832:1: warning: unused label 'err_nft_pernet' [-Wunused-label]
     832 | err_nft_pernet:
         | ^~~~~~~~~~~~~~~
   2 warnings generated.


vim +/err_nft_pernet +832 net/netfilter/core.c

   805	
   806	int __init netfilter_init(void)
   807	{
   808		int ret;
   809	
   810		ret = register_pernet_subsys(&netfilter_net_ops);
   811		if (ret < 0)
   812			goto err;
   813	
   814	#ifdef CONFIG_LWTUNNEL
   815		ret = netfilter_lwtunnel_init();
   816		if (ret < 0)
   817			goto err_lwtunnel_pernet;
   818	#endif
   819	#if IS_ENABLED(CONFIG_NF_TABLES)
   820		ret = netfilter_nf_tables_sysctl_init();
   821		if (ret < 0)
   822			goto err_nft_pernet;
   823	#endif
   824		ret = netfilter_log_init();
   825		if (ret < 0)
   826			goto err_log_pernet;
   827	
   828		return 0;
   829	
   830	err_log_pernet:
   831		netfilter_nf_tables_sysctl_fini();
 > 832	err_nft_pernet:

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
