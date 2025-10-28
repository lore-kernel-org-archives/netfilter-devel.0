Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F448246BD8
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 14:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761662002; cv=none; b=P7SGstv4cpB8Wi0zFKhlaOLwZ+mX8xAEImTWcF9TPa8ehDK72+PWN7zjN+D4GZDyLQlLqYP+POJ20oqJhHKeIz4neSc3JLxM7iTXP4ChYeGgyYnc0Kg1vymXoAab76H/uKYS6YvDKdXd1f9G+Af+B/Ka8+UPIIvx35oQHUk9Z8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761662002; c=relaxed/simple;
	bh=64Jcim7KMhHX83R0qyuR9GbplQ9gwYLBb2nrTwHK/Ss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QyqiC5QiUm1v1F8lMeD+E9R6yxWJQLgUc8zV7aUoxvwIauUxPi/gMIufQDzLHt5XBi/5jvz0ADt1E22YqAWTdi8KyKzP0EntiKmpQAyPdXT9hr/xtMRqlx1s9+JQqQQr/UtcllKrvYtiLqwnN3QkErR9lERLmlYo65qLitMbClk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bDLMDaeD; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bDLMDaeD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761662001; x=1793198001;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=64Jcim7KMhHX83R0qyuR9GbplQ9gwYLBb2nrTwHK/Ss=;
  b=bDLMDaeDHMXGyPeW7a+jpWQYc9sMvfxjDR4c7Cf1H2AUbS7s68p7CZXw
   qeL98JTOQFBNLs+m7uRMVr0761UHJiX5Y4mO+qFuAZDUEKJfO5v3+azgW
   AaMloCM9FEdEW3kORfMKij6TjJyG3JR8zgiU5+wrUTOxb78I+EpEPBA+H
   6M2wR7A7k9fJeTEDcvn5C1piW1pAmBwyfOKSQg8338qiJKLtonsIqJAbz
   hdON+G3VUGVltPFuRnumTEPvEWbweruSkvBfapePRBI5yl62I0rEOLIBw
   wfG8A6/oZK20MgDeRt5Lj/ok9VTbZGATHxzbhSix713aQVzFY0A/4MEmD
   Q==;
X-CSE-ConnectionGUID: 4gHoCQAsSRqG7b58E1QfHA==
X-CSE-MsgGUID: hDlegBmcT2WkPRGDCrpusw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62967631"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="62967631"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 07:33:20 -0700
X-CSE-ConnectionGUID: X+djC2PqTW+G8TFGqIIyOA==
X-CSE-MsgGUID: IQ3IPyQYRWme89TbhkbvkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="185279688"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 28 Oct 2025 07:33:17 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vDkl9-000JEd-0Y;
	Tue, 28 Oct 2025 14:33:15 +0000
Date: Tue, 28 Oct 2025 22:32:57 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, fw@strlen.de, ffmancera@suse.de,
	brady.1345@gmail.com
Subject: Re: [PATCH nf 1/2] netfilter: nf_tables: limit maximum number of
 jumps/gotos per netns
Message-ID: <202510282205.FvXf2zL5-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on linus/master v6.18-rc3 next-20251028]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables-limit-maximum-number-of-jumps-gotos-per-netns/20251028-062221
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20251027221722.183398-2-pablo%40netfilter.org
patch subject: [PATCH nf 1/2] netfilter: nf_tables: limit maximum number of jumps/gotos per netns
config: arm-aspeed_g5_defconfig (https://download.01.org/0day-ci/archive/20251028/202510282205.FvXf2zL5-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251028/202510282205.FvXf2zL5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510282205.FvXf2zL5-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   net/netfilter/core.c: In function 'netfilter_init':
>> net/netfilter/core.c:832:1: warning: label 'err_nft_pernet' defined but not used [-Wunused-label]
     832 | err_nft_pernet:
         | ^~~~~~~~~~~~~~
--
>> net/netfilter/nf_tables_sysctl.c:15:47: error: 'struct netns_nf' has no member named 'nf_tables_jumps_max_netns'
      15 |                 .data           = &init_net.nf.nf_tables_jumps_max_netns,
         |                                               ^
   net/netfilter/nf_tables_sysctl.c:16:53: error: 'struct netns_nf' has no member named 'nf_tables_jumps_max_netns'
      16 |                 .maxlen         = sizeof(init_net.nf.nf_tables_jumps_max_netns),
         |                                                     ^
   net/netfilter/nf_tables_sysctl.c: In function 'nf_tables_sysctl_init':
   net/netfilter/nf_tables_sysctl.c:33:24: error: 'struct netns_nf' has no member named 'nf_tables_jumps_max_netns'
      33 |                 net->nf.nf_tables_jumps_max_netns = NFT_TABLE_DEFAULT_JUMPS_MAX;
         |                        ^
   net/netfilter/nf_tables_sysctl.c:40:24: error: 'struct netns_nf' has no member named 'nf_tables_jumps_max_netns'
      40 |                 net->nf.nf_tables_jumps_max_netns =
         |                        ^
   net/netfilter/nf_tables_sysctl.c:41:36: error: 'struct netns_nf' has no member named 'nf_tables_jumps_max_netns'
      41 |                         init_net.nf.nf_tables_jumps_max_netns;
         |                                    ^
   net/netfilter/nf_tables_sysctl.c:43:33: error: 'struct netns_nf' has no member named 'nf_tables_jumps_max_netns'
      43 |                         &net->nf.nf_tables_jumps_max_netns;
         |                                 ^
>> net/netfilter/nf_tables_sysctl.c:49:17: error: 'struct netns_nf' has no member named 'nf_tables_dir_header'; did you mean 'nf_log_dir_header'?
      49 |         net->nf.nf_tables_dir_header =
         |                 ^~~~~~~~~~~~~~~~~~~~
         |                 nf_log_dir_header
   net/netfilter/nf_tables_sysctl.c:52:22: error: 'struct netns_nf' has no member named 'nf_tables_dir_header'; did you mean 'nf_log_dir_header'?
      52 |         if (!net->nf.nf_tables_dir_header)
         |                      ^~~~~~~~~~~~~~~~~~~~
         |                      nf_log_dir_header
   net/netfilter/nf_tables_sysctl.c: In function 'nf_tables_sysctl_exit':
   net/netfilter/nf_tables_sysctl.c:68:45: error: 'struct netns_nf' has no member named 'nf_tables_dir_header'; did you mean 'nf_log_dir_header'?
      68 |         unregister_net_sysctl_table(net->nf.nf_tables_dir_header);
         |                                             ^~~~~~~~~~~~~~~~~~~~
         |                                             nf_log_dir_header
   net/netfilter/nf_tables_sysctl.c:69:25: error: 'struct netns_nf' has no member named 'nf_tables_dir_header'; did you mean 'nf_log_dir_header'?
      69 |         table = net->nf.nf_tables_dir_header->ctl_table_arg;
         |                         ^~~~~~~~~~~~~~~~~~~~
         |                         nf_log_dir_header


vim +15 net/netfilter/nf_tables_sysctl.c

    11	
    12	static struct ctl_table nf_tables_sysctl_table[] = {
    13		[NF_SYSCTL_NFT_JUMPS_MAX] = {
    14			.procname       = "nf_tables_jumps_max_netns",
  > 15			.data           = &init_net.nf.nf_tables_jumps_max_netns,
    16			.maxlen         = sizeof(init_net.nf.nf_tables_jumps_max_netns),
    17			.mode           = 0644,
    18			.proc_handler   = proc_dointvec,
    19			.extra1		= SYSCTL_ONE,
    20			.extra2		= SYSCTL_INT_MAX,
    21		},
    22	};
    23	
    24	#define NFT_TABLE_DEFAULT_JUMPS_MAX 65535
    25	
    26	static int __net_init nf_tables_sysctl_init(struct net *net)
    27	{
    28		struct ctl_table *table = nf_tables_sysctl_table;
    29	
    30		BUILD_BUG_ON(ARRAY_SIZE(nf_tables_sysctl_table) != NF_SYSCTL_NFT_LAST_SYSCTL);
    31	
    32		if (net_eq(net, &init_net)) {
    33			net->nf.nf_tables_jumps_max_netns = NFT_TABLE_DEFAULT_JUMPS_MAX;
    34		} else {
    35			table = kmemdup(nf_tables_sysctl_table,
    36					sizeof(nf_tables_sysctl_table), GFP_KERNEL);
    37			if (!table)
    38				return -ENOMEM;
    39	
    40			net->nf.nf_tables_jumps_max_netns =
    41				init_net.nf.nf_tables_jumps_max_netns;
    42			table[NF_SYSCTL_NFT_JUMPS_MAX].data =
    43				&net->nf.nf_tables_jumps_max_netns;
    44	
    45			if (net->user_ns != &init_user_ns)
    46				table[NF_SYSCTL_NFT_JUMPS_MAX].mode &= ~0222;
    47		}
    48	
  > 49		net->nf.nf_tables_dir_header =
    50			register_net_sysctl_sz(net, "net/netfilter", table,
    51					       ARRAY_SIZE(nf_tables_sysctl_table));
    52		if (!net->nf.nf_tables_dir_header)
    53			goto err_tbl_free;
    54	
    55		return 0;
    56	
    57	err_tbl_free:
    58		if (table != nf_tables_sysctl_table)
    59			kfree(table);
    60	
    61		return -ENOMEM;
    62	}
    63	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
