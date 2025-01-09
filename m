Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6278F2080C9
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2025 04:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736397803; cv=none; b=M0U2Baxqe6YoEzZ2Wm6doSXI0XHGljB4jijenlFV0BMm5eXh25tth/VmqPaSpeSQC+9C5/LML8zBdjtAqtZowvuIKK7oKsqGWDpLJiplwQqHNvYBJ5ca+kq+dxvIvObKOVDGe6tKcbKXMjhvx7ZgzVx5kUsYxzNExvNLL1az0/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736397803; c=relaxed/simple;
	bh=11KPqA/gxRc//PDrf33m5JdxZGWGXkl/t+XjgvuemDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PEp3kCy8/uN9gXwX/+aaqLXIiMFuVav9P1uL+BDWIk2Wn/zXl4Li0CzHF3h9ACt9A5UVQ0EbRnYDyQydIBTgx768GQZSmqNyDuJCLpF8Hs7lccdvtWZLTAqVUdAaaTi1+LCEfqYuuuuTsXNkO1Z1Zby27sTdlgrfWLJ08qwX+QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d3RQCN7Q; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d3RQCN7Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736397801; x=1767933801;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=11KPqA/gxRc//PDrf33m5JdxZGWGXkl/t+XjgvuemDI=;
  b=d3RQCN7Q5W01h20N4G8JV/ANOFp8XxX2C6lz4fCnn+L26CwUrwlYiRwI
   XQ9vRXEm3HenIeIwQFS997+yCk5Eti+HOWCBJcujH1zGELEYUTEYmzP5c
   zxiKD490eNYBhsGjoizKFJdrnk4NrWZf12JXBTTSl2t/dVADKS54VijcE
   oazMK5iUBJNBQRD4PZN7uppmZOtPHrGh9fnpd6OCF2euRkMoImgpXmcki
   qTSS0dZ0Wew0rVRblONycxfgVKooqK5shhli6OXrdunDwfaSnmjzAZDzv
   M3qFWwcQRCQUvr6kKLSXeYDSYF4J/UcRSvKZKf6+kW78h6MxRzWDDLtKj
   Q==;
X-CSE-ConnectionGUID: BnT/19EqRYCYlJ8Co9C4Mg==
X-CSE-MsgGUID: uyQ3wZmJRGWkxisCBfanQg==
X-IronPort-AV: E=McAfee;i="6700,10204,11309"; a="35929493"
X-IronPort-AV: E=Sophos;i="6.12,300,1728975600"; 
   d="scan'208";a="35929493"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2025 20:43:20 -0800
X-CSE-ConnectionGUID: Apeu8x60SI6qssaaxDk7Cg==
X-CSE-MsgGUID: RCnCRpkdS+Kvbxk61hvrgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103159219"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 08 Jan 2025 20:43:19 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tVkO4-000H39-0U;
	Thu, 09 Jan 2025 04:43:16 +0000
Date: Thu, 9 Jan 2025 12:42:35 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, fw@strlen.de
Subject: Re: [PATCH nf-next,v2 6/6] netfilter: flowtable: add CLOSING state
Message-ID: <202501091229.n0ldd7t2-lkp@intel.com>
References: <20250107235038.115651-6-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107235038.115651-6-pablo@netfilter.org>

Hi Pablo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on linus/master v6.13-rc6 next-20250108]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-nft_flow_offload-update-tcp-state-flags-under-lock/20250108-075203
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20250107235038.115651-6-pablo%40netfilter.org
patch subject: [PATCH nf-next,v2 6/6] netfilter: flowtable: add CLOSING state
config: hexagon-allyesconfig (https://download.01.org/0day-ci/archive/20250109/202501091229.n0ldd7t2-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250109/202501091229.n0ldd7t2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501091229.n0ldd7t2-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/netfilter/nf_flow_table_core.c:217:13: warning: variable 'expired' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
     217 |         } else if (l4num == IPPROTO_UDP) {
         |                    ^~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_flow_table_core.c:229:6: note: uninitialized use occurs here
     229 |         if (expired)
         |             ^~~~~~~
   net/netfilter/nf_flow_table_core.c:217:9: note: remove the 'if' if its condition is always false
     217 |         } else if (l4num == IPPROTO_UDP) {
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
     218 |                 const struct nf_udp_net *tn = nf_udp_pernet(net);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     219 |                 enum udp_conntrack state =
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~
     220 |                         test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
         |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     221 |                         UDP_CT_REPLIED : UDP_CT_UNREPLIED;
         |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     222 | 
     223 |                 timeout = READ_ONCE(tn->timeouts[state]);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     224 |                 offload_timeout = READ_ONCE(tn->offload_timeout);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     225 |         } else {
         |         ~~~~~~
   net/netfilter/nf_flow_table_core.c:194:14: note: initialize the variable 'expired' to silence this warning
     194 |         bool expired;
         |                     ^
         |                      = 0
   1 warning generated.


vim +217 net/netfilter/nf_flow_table_core.c

da5984e51063a2 Felix Fietkau     2018-02-26  187  
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  188  static void flow_offload_fixup_ct(struct flow_offload *flow)
da5984e51063a2 Felix Fietkau     2018-02-26  189  {
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  190  	struct nf_conn *ct = flow->ct;
1d91d2e1a7f767 Oz Shlomo         2021-06-03  191  	struct net *net = nf_ct_net(ct);
1e5b2471bcc483 Pablo Neira Ayuso 2019-08-09  192  	int l4num = nf_ct_protonum(ct);
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  193  	u32 offload_timeout = 0;
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  194  	bool expired;
4592ee7f525c46 Florian Westphal  2021-08-04  195  	s32 timeout;
da5984e51063a2 Felix Fietkau     2018-02-26  196  
1d91d2e1a7f767 Oz Shlomo         2021-06-03  197  	if (l4num == IPPROTO_TCP) {
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  198  		const struct nf_tcp_net *tn = nf_tcp_pernet(net);
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  199  		u8 tcp_state;
1d91d2e1a7f767 Oz Shlomo         2021-06-03  200  
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  201  		/* Enter CLOSE state if fin/rst packet has been seen, this
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  202  		 * allows TCP reopen from conntrack. Otherwise, pick up from
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  203  		 * the last seen TCP state.
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  204  		 */
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  205  		if (test_bit(NF_FLOW_CLOSING, &flow->flags)) {
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  206  			flow_offload_fixup_tcp(ct, TCP_CONNTRACK_CLOSE);
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  207  			timeout = READ_ONCE(tn->timeouts[TCP_CONNTRACK_CLOSE]);
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  208  			expired = false;
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  209  		} else {
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  210  			tcp_state = READ_ONCE(ct->proto.tcp.state);
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  211  			flow_offload_fixup_tcp(ct, tcp_state);
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  212  			timeout = READ_ONCE(tn->timeouts[tcp_state]);
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  213  			expired = nf_flow_has_expired(flow);
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  214  		}
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  215  		offload_timeout = READ_ONCE(tn->offload_timeout);
e5eaac2beb54f0 Pablo Neira Ayuso 2022-05-17  216  
1d91d2e1a7f767 Oz Shlomo         2021-06-03 @217  	} else if (l4num == IPPROTO_UDP) {
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  218  		const struct nf_udp_net *tn = nf_udp_pernet(net);
0eb5acb1641889 Vlad Buslov       2023-02-01  219  		enum udp_conntrack state =
0eb5acb1641889 Vlad Buslov       2023-02-01  220  			test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
0eb5acb1641889 Vlad Buslov       2023-02-01  221  			UDP_CT_REPLIED : UDP_CT_UNREPLIED;
1d91d2e1a7f767 Oz Shlomo         2021-06-03  222  
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  223  		timeout = READ_ONCE(tn->timeouts[state]);
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  224  		offload_timeout = READ_ONCE(tn->offload_timeout);
1d91d2e1a7f767 Oz Shlomo         2021-06-03  225  	} else {
da5984e51063a2 Felix Fietkau     2018-02-26  226  		return;
1d91d2e1a7f767 Oz Shlomo         2021-06-03  227  	}
da5984e51063a2 Felix Fietkau     2018-02-26  228  
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  229  	if (expired)
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  230  		timeout -= offload_timeout;
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  231  
4592ee7f525c46 Florian Westphal  2021-08-04  232  	if (timeout < 0)
4592ee7f525c46 Florian Westphal  2021-08-04  233  		timeout = 0;
4592ee7f525c46 Florian Westphal  2021-08-04  234  
e622d94ec73f66 Pablo Neira Ayuso 2025-01-08  235  	nf_ct_refresh(ct, timeout);
da5984e51063a2 Felix Fietkau     2018-02-26  236  }
da5984e51063a2 Felix Fietkau     2018-02-26  237  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
