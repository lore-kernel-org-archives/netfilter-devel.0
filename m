Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E8D395D8C
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 15:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774108414; cv=none; b=jT1KTX3VBs6hCc4fV1vyON0UmZPuRHsXxVMi/UvwR8L55BWBYm4fDpsYK3CiP3J+INrADyi3buEg8RKGqo7PIqVuLqDeQGEZX2xhoHmBkZsE+2v7vJTwevsjZbeJDateUoj0+iMmBUWlObnqMkCs9B+d+Lj+fR2uBD4P7bablTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774108414; c=relaxed/simple;
	bh=6Qy9m5/XB0EGAW6+nv+MY/W6ZaZqFmIwRbvKsX05doY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=nXdyRrTUfzfZdjohetv4NSHpnb0xNsfGpT+QUwZlN9hjMfOQBXelxckIqa3++5/hJj+W2+h865j7wh3gsxHNJI25rLy+YD6GX1TASfujkfVdRBx0cZCyS5TdQKPvDC+Msw/Gj8BWFuOTHiCsVgi0qGXNsRsZS21rTSgUCjd3sn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kDteg8sK; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kDteg8sK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774108411; x=1805644411;
  h=date:from:to:cc:subject:message-id;
  bh=6Qy9m5/XB0EGAW6+nv+MY/W6ZaZqFmIwRbvKsX05doY=;
  b=kDteg8sKJHCVduLxdcPuKN2SenEEDCXVtJDZdzilxgG51YLhfaxnzAS6
   5Wc/meWuCPC/3MAkB+aN3KlkwQGh7vAeAm+ZWgcTZg7T87l9jMznD0sz3
   oqehNHlVMmL7X0eaiWq5M1mcW+zugl7USPdvHZtp116au9bA8Dp2FO7yB
   Bt944T5usuGPv5rxYBW4lWn2gB+D3TB5eeckMT33axAhkdXNUpgunKvdD
   +fK3DueUesr7M1mSYMV1mrpKM61NLy+B9EHUCkW4zi0eUVmPc5CddbKt6
   V7+lO4AdU+Pi0tiSDSHLuo/7q6zDZduybqPgGHl8fniFaUJkK/MzshMqM
   Q==;
X-CSE-ConnectionGUID: 0BwGyfyjSiiO7QaWLj2jjw==
X-CSE-MsgGUID: mg/cteBTQEmaTT1wPF1Bhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11736"; a="75368235"
X-IronPort-AV: E=Sophos;i="6.23,133,1770624000"; 
   d="scan'208";a="75368235"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2026 08:53:31 -0700
X-CSE-ConnectionGUID: z0Y2MwFeSmKFhZ5F01YH2A==
X-CSE-MsgGUID: drBgilfvSOqSghSmnFRIlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,133,1770624000"; 
   d="scan'208";a="222664286"
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 21 Mar 2026 08:53:29 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3ydi-000000000xj-0292;
	Sat, 21 Mar 2026 15:53:26 +0000
Date: Sat, 21 Mar 2026 23:53:04 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [netfilter-nf:testing 5/9]
 net/netfilter/nf_conntrack_helper.c:402:25: sparse: sparse: incompatible
 types in comparison expression (different address spaces):
Message-ID: <202603212305.2cOqvegt-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git testing
head:   b1bad43d8b00ab31c8f93145a4c8db1567f0d2fe
commit: c3de6e5d6e373eb2110c6c64d205b202bc26f8ab [5/9] netfilter: nf_conntrack_expect: honor expectation helper field
config: sparc-randconfig-r122-20260321 (https://download.01.org/0day-ci/archive/20260321/202603212305.2cOqvegt-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603212305.2cOqvegt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603212305.2cOqvegt-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> net/netfilter/nf_conntrack_helper.c:402:25: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_conntrack_helper.c:402:25: sparse:    struct nf_conntrack_helper [noderef] __rcu *
   net/netfilter/nf_conntrack_helper.c:402:25: sparse:    struct nf_conntrack_helper const *

vim +402 net/netfilter/nf_conntrack_helper.c

7e5d03bb9d2b96f Martin Josefsson 2006-11-29  395  
ac7b848390036da Florian Westphal 2017-07-26  396  static bool expect_iter_me(struct nf_conntrack_expect *exp, void *data)
7e5d03bb9d2b96f Martin Josefsson 2006-11-29  397  {
ac7b848390036da Florian Westphal 2017-07-26  398  	struct nf_conn_help *help = nfct_help(exp->master);
ac7b848390036da Florian Westphal 2017-07-26  399  	const struct nf_conntrack_helper *me = data;
ac7b848390036da Florian Westphal 2017-07-26  400  	const struct nf_conntrack_helper *this;
ac7b848390036da Florian Westphal 2017-07-26  401  
ac7b848390036da Florian Westphal 2017-07-26 @402  	if (exp->helper == me)
ac7b848390036da Florian Westphal 2017-07-26  403  		return true;
436a850dd9cac09 Florian Westphal 2016-05-15  404  
ac7b848390036da Florian Westphal 2017-07-26  405  	this = rcu_dereference_protected(help->helper,
ac7b848390036da Florian Westphal 2017-07-26  406  					 lockdep_is_held(&nf_conntrack_expect_lock));
ac7b848390036da Florian Westphal 2017-07-26  407  	return this == me;
ac7b848390036da Florian Westphal 2017-07-26  408  }
ac7b848390036da Florian Westphal 2017-07-26  409  

:::::: The code at line 402 was first introduced by commit
:::::: ac7b848390036dadd4351899d2a23748075916bd netfilter: expect: add and use nf_ct_expect_iterate helpers

:::::: TO: Florian Westphal <fw@strlen.de>
:::::: CC: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
