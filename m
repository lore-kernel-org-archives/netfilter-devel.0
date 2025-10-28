Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DDF336EF9
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761663309; cv=none; b=a59oXtJUsTXtJXxphGNbua+Qg/yT2FNwkhnhWBXFfJ77Zx9uMZf77RV1G7wd7hwRwu/EYmd9VoLQievr/nKLWOw0JMaOGmHQnGZAy/oiI3s9OHvds8mSeHecz14TSFC+DYv7Ji0++BR9WCMfQc6UrC1mV5tCTYIciGAZJ5LhHa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761663309; c=relaxed/simple;
	bh=5MILIsSeWx1iW4Q4sO8gat7oSovZjYkBv0ZRjF7N+3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxWjax2naVcR0YdsZ0CUCtoqeDoSN+YgTrA0u9gteUpRJFDLaK0Ffe8LCHJUq7Ai8Pfy9VltLKUJMdHBMN3lsmoNQhjMCnb0lt3yhhkxi6sB32qdX/Qj6XRFDxIkG/0DPTPgT9Sx/cKzyGce30jJwNqcX86YkZ8KuSx3QxqdJeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kkYf46eY; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kkYf46eY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761663308; x=1793199308;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5MILIsSeWx1iW4Q4sO8gat7oSovZjYkBv0ZRjF7N+3o=;
  b=kkYf46eYU0ViF6HaQ1as4vS/09K8Qtm/CmUQpIa8rH21qmgqafAVNjqH
   3qf8nJr6AsB8v8a8yusnMtzSbMTzMtcAUiyx8nP6JEl97VH+d0NNJbVyX
   Mut0t1DIHK1oXudDI/MlUYtA08cmYCmyDuyh5e6POU3GSucDAjlsRfbMe
   JKWF3jzl/DnU4ag5vuNGJhLIFar21Tr8aB5BdkoiktB7+y1Mx0BvJ2KZb
   8KYDzQctsRZ1L5dU/KDbfutPmogjZa/1CE0bxWNwrcNxzX58AFea+UlgX
   tRD3HEU+PeLWgwWZhRizvh2c+6F9DuaAQjvvQJp4xzYPjyEKHUfQky4ro
   g==;
X-CSE-ConnectionGUID: bylq+gWsRtaoggGD0vPkOA==
X-CSE-MsgGUID: LnEGHJ1lRKuLkZEL7RBWFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63691797"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63691797"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 07:55:07 -0700
X-CSE-ConnectionGUID: /YM3SU32QrunU3hNVMZL3Q==
X-CSE-MsgGUID: SBalOQaqRumEUttp9XVX3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="190487827"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 28 Oct 2025 07:55:04 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vDl6E-000JGb-22;
	Tue, 28 Oct 2025 14:55:02 +0000
Date: Tue, 28 Oct 2025 22:54:03 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, fw@strlen.de,
	ffmancera@suse.de, brady.1345@gmail.com
Subject: Re: [PATCH nf 1/2] netfilter: nf_tables: limit maximum number of
 jumps/gotos per netns
Message-ID: <202510282243.y0oDegX0-lkp@intel.com>
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
config: i386-defconfig (https://download.01.org/0day-ci/archive/20251028/202510282243.y0oDegX0-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251028/202510282243.y0oDegX0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510282243.y0oDegX0-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/netfilter/nf_tables_sysctl.c:15:34: error: no member named 'nf_tables_jumps_max_netns' in 'struct netns_nf'
      15 |                 .data           = &init_net.nf.nf_tables_jumps_max_netns,
         |                                    ~~~~~~~~~~~ ^
   net/netfilter/nf_tables_sysctl.c:16:40: error: no member named 'nf_tables_jumps_max_netns' in 'struct netns_nf'
      16 |                 .maxlen         = sizeof(init_net.nf.nf_tables_jumps_max_netns),
         |                                          ~~~~~~~~~~~ ^
   net/netfilter/nf_tables_sysctl.c:33:11: error: no member named 'nf_tables_jumps_max_netns' in 'struct netns_nf'
      33 |                 net->nf.nf_tables_jumps_max_netns = NFT_TABLE_DEFAULT_JUMPS_MAX;
         |                 ~~~~~~~ ^
   net/netfilter/nf_tables_sysctl.c:40:11: error: no member named 'nf_tables_jumps_max_netns' in 'struct netns_nf'
      40 |                 net->nf.nf_tables_jumps_max_netns =
         |                 ~~~~~~~ ^
   net/netfilter/nf_tables_sysctl.c:41:16: error: no member named 'nf_tables_jumps_max_netns' in 'struct netns_nf'
      41 |                         init_net.nf.nf_tables_jumps_max_netns;
         |                         ~~~~~~~~~~~ ^
   net/netfilter/nf_tables_sysctl.c:43:13: error: no member named 'nf_tables_jumps_max_netns' in 'struct netns_nf'
      43 |                         &net->nf.nf_tables_jumps_max_netns;
         |                          ~~~~~~~ ^
>> net/netfilter/nf_tables_sysctl.c:49:10: error: no member named 'nf_tables_dir_header' in 'struct netns_nf'; did you mean 'nf_log_dir_header'?
      49 |         net->nf.nf_tables_dir_header =
         |                 ^~~~~~~~~~~~~~~~~~~~
         |                 nf_log_dir_header
   include/net/netns/netfilter.h:17:27: note: 'nf_log_dir_header' declared here
      17 |         struct ctl_table_header *nf_log_dir_header;
         |                                  ^
   net/netfilter/nf_tables_sysctl.c:52:15: error: no member named 'nf_tables_dir_header' in 'struct netns_nf'; did you mean 'nf_log_dir_header'?
      52 |         if (!net->nf.nf_tables_dir_header)
         |                      ^~~~~~~~~~~~~~~~~~~~
         |                      nf_log_dir_header
   include/net/netns/netfilter.h:17:27: note: 'nf_log_dir_header' declared here
      17 |         struct ctl_table_header *nf_log_dir_header;
         |                                  ^
   net/netfilter/nf_tables_sysctl.c:68:38: error: no member named 'nf_tables_dir_header' in 'struct netns_nf'; did you mean 'nf_log_dir_header'?
      68 |         unregister_net_sysctl_table(net->nf.nf_tables_dir_header);
         |                                             ^~~~~~~~~~~~~~~~~~~~
         |                                             nf_log_dir_header
   include/net/netns/netfilter.h:17:27: note: 'nf_log_dir_header' declared here
      17 |         struct ctl_table_header *nf_log_dir_header;
         |                                  ^
   net/netfilter/nf_tables_sysctl.c:69:18: error: no member named 'nf_tables_dir_header' in 'struct netns_nf'; did you mean 'nf_log_dir_header'?
      69 |         table = net->nf.nf_tables_dir_header->ctl_table_arg;
         |                         ^~~~~~~~~~~~~~~~~~~~
         |                         nf_log_dir_header
   include/net/netns/netfilter.h:17:27: note: 'nf_log_dir_header' declared here
      17 |         struct ctl_table_header *nf_log_dir_header;
         |                                  ^
   10 errors generated.


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
