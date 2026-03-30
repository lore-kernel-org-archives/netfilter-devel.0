Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFEF39C003;
	Mon, 30 Mar 2026 21:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774906498; cv=none; b=dBvucjKa0KvjYg8G1XbhbyKpY0Nnk+YMi0K1aMSsR1ccZ754pA9ZB4WlxnqvR2aDSWl7VZyTa9ZRQOEE/fIaMzIWqefSvP/RN4zJdnFLJgjWPM3x/BtYUKqLNEftRvPY79w/I6ZlV0rS8mE2DF36TSOf9JflY0PSHyrsQ1lNClo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774906498; c=relaxed/simple;
	bh=v6ogNXQHJTDTX4v1/AvGYA8+sEBVNoiI9Ngz1bKXkNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNb2UMPVVIQ9KlaG5IavzNjTGBT0Qam6bSTMV8ZhMbcgC1XrrUK/IK0VzJPlpw5PtK+uSmPcTYfobDPg9XjeZTV29VLY/ksIChwtRYeQtsa41cOM0mZ8hCaYztfY0oqBDbYnjeGCDFSO+ZQICPLyFVYH9a9eSuWzU1ajhrBW03E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YOHJ/bms; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YOHJ/bms"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774906496; x=1806442496;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v6ogNXQHJTDTX4v1/AvGYA8+sEBVNoiI9Ngz1bKXkNo=;
  b=YOHJ/bmsIrY1vWN+Nw/lBKlZq/rCMH4B1BSz2hiGmR8IwUrVJIKgbsI8
   WynM6paYoHDEh+bJQ3N7MrdaoFMgfjlrdyWW/gZdhXWvvAEBMRQvigxiR
   1jezxyN41hBBNyF+Yo7NAXW1IMFdzpd0UoUp18cnfnnPYnqHM3oaiRq1q
   XxZHNkm+F+QbnH/vskx619dyrewk3DYHMTlpVko2ZqMxxUqj5jwxajW/q
   JmRH6+zDnerw0sXgMBp7tyktveqkrNdIWjr61ZJBrSMYGkPfp3GyCqHFh
   kFaToQuTVvgA7P1w39dm8MDIlO8vwVIUari6O6MmLWiq48hiz3BtknkV6
   g==;
X-CSE-ConnectionGUID: i35L3VadRPG0SRwrM83M8g==
X-CSE-MsgGUID: cCIdC7LxQgioBAdL+tLaCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="75927261"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="75927261"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 14:34:53 -0700
X-CSE-ConnectionGUID: hSMDTCmdQAS6Fr+I7pGzuw==
X-CSE-MsgGUID: EuWSIXlYQOyv8nI2jfNKsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="230642865"
Received: from lkp-server01.sh.intel.com (HELO 283bf2e1b94a) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 30 Mar 2026 14:34:48 -0700
Received: from kbuild by 283bf2e1b94a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w7KFw-000000001kD-2pDh;
	Mon, 30 Mar 2026 21:34:44 +0000
Date: Tue, 31 Mar 2026 05:34:34 +0800
From: kernel test robot <lkp@intel.com>
To: Qi Tang <tpluszz77@gmail.com>, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: oe-kbuild-all@lists.linux.dev, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Qi Tang <tpluszz77@gmail.com>
Subject: Re: [PATCH] netfilter: ctnetlink: zero expect NAT fields when
 CTA_EXPECT_NAT absent
Message-ID: <202603310541.XVM8V7WG-lkp@intel.com>
References: <20260329165217.241038-1-tpluszz77@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329165217.241038-1-tpluszz77@gmail.com>

Hi Qi,

kernel test robot noticed the following build errors:

[auto build test ERROR on netfilter-nf/main]
[also build test ERROR on linus/master nf-next/master horms-ipvs/master v7.0-rc6 next-20260327]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Qi-Tang/netfilter-ctnetlink-zero-expect-NAT-fields-when-CTA_EXPECT_NAT-absent/20260330-195347
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20260329165217.241038-1-tpluszz77%40gmail.com
patch subject: [PATCH] netfilter: ctnetlink: zero expect NAT fields when CTA_EXPECT_NAT absent
config: sh-randconfig-001-20260331 (https://download.01.org/0day-ci/archive/20260331/202603310541.XVM8V7WG-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260331/202603310541.XVM8V7WG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603310541.XVM8V7WG-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/netfilter/nf_conntrack_netlink.c: In function 'ctnetlink_alloc_expect':
>> net/netfilter/nf_conntrack_netlink.c:3592:28: error: 'struct nf_conntrack_expect' has no member named 'saved_addr'
    3592 |                 memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
         |                            ^~
   net/netfilter/nf_conntrack_netlink.c:3592:55: error: 'struct nf_conntrack_expect' has no member named 'saved_addr'
    3592 |                 memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
         |                                                       ^~
>> net/netfilter/nf_conntrack_netlink.c:3593:28: error: 'struct nf_conntrack_expect' has no member named 'saved_proto'
    3593 |                 memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
         |                            ^~
   net/netfilter/nf_conntrack_netlink.c:3593:56: error: 'struct nf_conntrack_expect' has no member named 'saved_proto'
    3593 |                 memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
         |                                                        ^~
>> net/netfilter/nf_conntrack_netlink.c:3594:20: error: 'struct nf_conntrack_expect' has no member named 'dir'
    3594 |                 exp->dir = 0;
         |                    ^~


vim +3592 net/netfilter/nf_conntrack_netlink.c

  3528	
  3529	static struct nf_conntrack_expect *
  3530	ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
  3531			       struct nf_conntrack_helper *helper,
  3532			       struct nf_conntrack_tuple *tuple,
  3533			       struct nf_conntrack_tuple *mask)
  3534	{
  3535		struct net *net = read_pnet(&ct->ct_net);
  3536		struct nf_conntrack_expect *exp;
  3537		struct nf_conn_help *help;
  3538		u32 class = 0;
  3539		int err;
  3540	
  3541		help = nfct_help(ct);
  3542		if (!help)
  3543			return ERR_PTR(-EOPNOTSUPP);
  3544	
  3545		if (cda[CTA_EXPECT_CLASS] && helper) {
  3546			class = ntohl(nla_get_be32(cda[CTA_EXPECT_CLASS]));
  3547			if (class > helper->expect_class_max)
  3548				return ERR_PTR(-EINVAL);
  3549		}
  3550		exp = nf_ct_expect_alloc(ct);
  3551		if (!exp)
  3552			return ERR_PTR(-ENOMEM);
  3553	
  3554		if (cda[CTA_EXPECT_FLAGS]) {
  3555			exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
  3556			exp->flags &= ~NF_CT_EXPECT_USERSPACE;
  3557		} else {
  3558			exp->flags = 0;
  3559		}
  3560		if (cda[CTA_EXPECT_FN]) {
  3561			const char *name = nla_data(cda[CTA_EXPECT_FN]);
  3562			struct nf_ct_helper_expectfn *expfn;
  3563	
  3564			expfn = nf_ct_helper_expectfn_find_by_name(name);
  3565			if (expfn == NULL) {
  3566				err = -EINVAL;
  3567				goto err_out;
  3568			}
  3569			exp->expectfn = expfn->expectfn;
  3570		} else
  3571			exp->expectfn = NULL;
  3572	
  3573		exp->class = class;
  3574		exp->master = ct;
  3575		write_pnet(&exp->net, net);
  3576	#ifdef CONFIG_NF_CONNTRACK_ZONES
  3577		exp->zone = ct->zone;
  3578	#endif
  3579		if (!helper)
  3580			helper = rcu_dereference(help->helper);
  3581		rcu_assign_pointer(exp->helper, helper);
  3582		exp->tuple = *tuple;
  3583		exp->mask.src.u3 = mask->src.u3;
  3584		exp->mask.src.u.all = mask->src.u.all;
  3585	
  3586		if (cda[CTA_EXPECT_NAT]) {
  3587			err = ctnetlink_parse_expect_nat(cda[CTA_EXPECT_NAT],
  3588							 exp, nf_ct_l3num(ct));
  3589			if (err < 0)
  3590				goto err_out;
  3591		} else {
> 3592			memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
> 3593			memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
> 3594			exp->dir = 0;
  3595		}
  3596		return exp;
  3597	err_out:
  3598		nf_ct_expect_put(exp);
  3599		return ERR_PTR(err);
  3600	}
  3601	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
