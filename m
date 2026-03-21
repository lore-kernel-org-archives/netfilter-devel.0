Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0AB365A11
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 05:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774072379; cv=none; b=CKqhI6qzdkcuORrwKBGGpz8PTk+Pv/wP66mFcerRpkrUyPMflQgR3GyEaJz5KTZlx8yGlaZEniGRDZl5qpjqMcKUAscw9sVpX8AepHYjRBQe1Iq4bEWPHEqqqt9j6GPFv9kqskHVmmvusHq9rO7PaaSDx28H93Elv8vIJxpLOKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774072379; c=relaxed/simple;
	bh=+OXEMr+jwugelQah7wMt6C+u3Ix4Uk6Ywa1hJynoegM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=oZNxuxUBfcPIhbtAnUW8Lz3a5bwjEjauA0JbR0nwE4Zb5bEkWrGaEAqO1v6J3nQMR11UZ9ypEBojllfCQj/bqWJKjok0NZbEM7MxGJnGcWivZdKm7QJ2JDMcVxju1f/sav92gkYKsmEkpaXQoVGmzLfdQ7bcBi8Tph6Vh8sIWtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LnmZ1tkY; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LnmZ1tkY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774072378; x=1805608378;
  h=date:from:to:cc:subject:message-id;
  bh=+OXEMr+jwugelQah7wMt6C+u3Ix4Uk6Ywa1hJynoegM=;
  b=LnmZ1tkYoEyi16TCnpsBSNkU5Q+7L/ulxtc57V4iByADDiD2QueqmEbM
   BUeuhVlL4zIw4S+TQNDlWBXglPSTCM/uQRKehuLdcrjTC+vasZulSPJ6e
   QxCmJAe4Q/NFrsyk5XLgwZnvS8G+VdaLVTQr9fRHWsVldfOkoynuLbOUL
   oRW6qF+4IdpySEO2nOVyGCeDy/y3UI+7uRzcCpoy8rxi1BxGWaNQRBIlQ
   S1hI+qGJO0gqEOSiXraXxlhQ6oaAYYnai82ccNrf5tcyIllAk9Co3PklI
   Z5jwlJQzkIYQkCMjGYwvHOi6ncvoDUvNMBp+Zu5ucgfkZukMkqirNOw8Z
   g==;
X-CSE-ConnectionGUID: Tcxb2T5HT5yfn8eCHWBW7Q==
X-CSE-MsgGUID: kmcGqthGSYO0FqgyuQe4kQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="79018574"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="79018574"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 22:52:58 -0700
X-CSE-ConnectionGUID: 55ACnREOTACEqqGV0EM2Ew==
X-CSE-MsgGUID: g4QcGpwARKqUGcB80k4WYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="223473271"
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 20 Mar 2026 22:52:55 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3pGP-000000000ND-3eQR;
	Sat, 21 Mar 2026 05:52:47 +0000
Date: Sat, 21 Mar 2026 13:52:10 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 Florian Westphal <fw@strlen.de>
Subject: [netfilter-nf:testing 8/9]
 net/netfilter/nf_conntrack_netlink.c:3583:7: error: no member named 'zone' in
 'struct nf_conntrack_expect'
Message-ID: <202603211353.vSxiy3Az-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git testing
head:   b1bad43d8b00ab31c8f93145a4c8db1567f0d2fe
commit: 5559719129b7370573ae4892829ea7c55f702b27 [8/9] netfilter: nf_conntrack_expect: store netns and zone in expectation
config: arm-randconfig-002-20260321 (https://download.01.org/0day-ci/archive/20260321/202603211353.vSxiy3Az-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 4abb927bacf37f18f6359a41639a6d1b3bffffb5)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603211353.vSxiy3Az-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603211353.vSxiy3Az-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/netfilter/nf_conntrack_netlink.c:3583:7: error: no member named 'zone' in 'struct nf_conntrack_expect'
    3583 |         exp->zone = ct->zone;
         |         ~~~  ^
>> net/netfilter/nf_conntrack_netlink.c:3583:18: error: no member named 'zone' in 'struct nf_conn'
    3583 |         exp->zone = ct->zone;
         |                     ~~  ^
   2 errors generated.
--
>> net/netfilter/nf_conntrack_expect.c:341:7: error: no member named 'zone' in 'struct nf_conntrack_expect'
     341 |         exp->zone = exp->master->zone;
         |         ~~~  ^
>> net/netfilter/nf_conntrack_expect.c:341:27: error: no member named 'zone' in 'struct nf_conn'
     341 |         exp->zone = exp->master->zone;
         |                     ~~~~~~~~~~~  ^
   2 errors generated.


vim +3583 net/netfilter/nf_conntrack_netlink.c

  3535	
  3536	static struct nf_conntrack_expect *
  3537	ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
  3538			       struct nf_conntrack_helper *helper,
  3539			       struct nf_conntrack_tuple *tuple,
  3540			       struct nf_conntrack_tuple *mask)
  3541	{
  3542		struct net *net = read_pnet(&ct->ct_net);
  3543		struct nf_conntrack_expect *exp;
  3544		struct nf_conn_help *help;
  3545		u_int32_t class = 0;
  3546		int err;
  3547	
  3548		help = nfct_help(ct);
  3549		if (!help)
  3550			return ERR_PTR(-EOPNOTSUPP);
  3551	
  3552		if (cda[CTA_EXPECT_CLASS] && helper) {
  3553			class = ntohl(nla_get_be32(cda[CTA_EXPECT_CLASS]));
  3554			if (class > helper->expect_class_max)
  3555				return ERR_PTR(-EINVAL);
  3556		}
  3557		exp = nf_ct_expect_alloc(ct);
  3558		if (!exp)
  3559			return ERR_PTR(-ENOMEM);
  3560	
  3561		if (cda[CTA_EXPECT_FLAGS]) {
  3562			exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
  3563			exp->flags &= ~NF_CT_EXPECT_USERSPACE;
  3564		} else {
  3565			exp->flags = 0;
  3566		}
  3567		if (cda[CTA_EXPECT_FN]) {
  3568			const char *name = nla_data(cda[CTA_EXPECT_FN]);
  3569			struct nf_ct_helper_expectfn *expfn;
  3570	
  3571			expfn = nf_ct_helper_expectfn_find_by_name(name);
  3572			if (expfn == NULL) {
  3573				err = -EINVAL;
  3574				goto err_out;
  3575			}
  3576			exp->expectfn = expfn->expectfn;
  3577		} else
  3578			exp->expectfn = NULL;
  3579	
  3580		exp->class = class;
  3581		exp->master = ct;
  3582		write_pnet(&exp->net, net);
> 3583		exp->zone = ct->zone;
  3584		rcu_assign_pointer(exp->helper, helper ? : help->helper);
  3585		exp->tuple = *tuple;
  3586		exp->mask.src.u3 = mask->src.u3;
  3587		exp->mask.src.u.all = mask->src.u.all;
  3588	
  3589		if (cda[CTA_EXPECT_NAT]) {
  3590			err = ctnetlink_parse_expect_nat(cda[CTA_EXPECT_NAT],
  3591							 exp, nf_ct_l3num(ct));
  3592			if (err < 0)
  3593				goto err_out;
  3594		}
  3595		return exp;
  3596	err_out:
  3597		nf_ct_expect_put(exp);
  3598		return ERR_PTR(err);
  3599	}
  3600	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
