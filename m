Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05EE3FC8
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Feb 2024 00:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707437950; cv=none; b=mD5wgSYtqWilbHQg9/UpDZV5z/aLRWPISwyxYU6i3uBPajitnMhj6PsQhAgZTK3jXSPbDursh9PPtm6rSzwsoNoKfwgs/YsYqsmudw+qE4Gx1lr+O3Lchd687HzSsqQ9a2r1+JA2mXNo2sHmJco11l8N7GKAXIAQveHdCe9/S1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707437950; c=relaxed/simple;
	bh=ka3DpBTExdCsDP7cUtbhPqxbUYk7McHMjF+6nMhPRuk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZeWpjeSRxwtRdxYOe7hJdu5hJXzu01hp9OVgMycNID1r13sNgxc+Af2NrzqdHWfOzZCD7/cyYod7QPmoxkXJyqMI06fQEP31AI2by4MrQYplw/9s56/PlTk54Y5pWqBp3CcWWeRC3d2szMbFWoXkkoyOdLJwQH53gsB8vNWJdfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O2qkT+fD; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O2qkT+fD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707437948; x=1738973948;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ka3DpBTExdCsDP7cUtbhPqxbUYk7McHMjF+6nMhPRuk=;
  b=O2qkT+fDSJ/WL6nSHvQyRcAN5GuPqAHjkY7ZY2ojGyRWJI+fb9NS9+un
   Zagm/zrVeyX5gWzlXapWuAAdbctUFMmveKGQOqDSqFJu1wxTadFULLm0Y
   UucSgJ6muMKo/ze7uI5ZBtaoy68lVROhjBWrbXaHWegVpufWvogmiVjQS
   taqJRG8mRs8X8v9b3H3ITxqqFKlaKeKUotlPB6DVAl96n9gP5HiaU26oX
   AqhVB673HCMAKLGdV0YsVPxCvvCbEhf33arIyhdMFMtK2eBuW1ToBoKM8
   do+KyEUiS/14/bznFgO8TBOVTa1Th0A3Fuf4BZ2BPB5MZwOrgxMByowLR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="5164392"
X-IronPort-AV: E=Sophos;i="6.05,255,1701158400"; 
   d="scan'208";a="5164392"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2024 16:19:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,255,1701158400"; 
   d="scan'208";a="2103718"
Received: from lkp-server01.sh.intel.com (HELO 01f0647817ea) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 08 Feb 2024 16:19:05 -0800
Received: from kbuild by 01f0647817ea with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rYEbe-0004EK-2d;
	Fri, 09 Feb 2024 00:19:02 +0000
Date: Fri, 9 Feb 2024 08:18:28 +0800
From: kernel test robot <lkp@intel.com>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [netfilter-nf:testing 5/13]
 net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type
 in assignment (different address spaces)
Message-ID: <202402090822.jJ0z40yz-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git testing
head:   a7eaa3316ffa17957ee70a705000a3a942128820
commit: 6099505cd2a2652bbb4156582a22feb6d651b6d6 [5/13] netfilter: ipset: Missing gc cancellations fixed
config: x86_64-randconfig-123-20240208 (https://download.01.org/0day-ci/archive/20240209/202402090822.jJ0z40yz-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240209/202402090822.jJ0z40yz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202402090822.jJ0z40yz-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   net/netfilter/ipset/ip_set_hash_mac.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
--
   net/netfilter/ipset/ip_set_hash_ip.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
   net/netfilter/ipset/ip_set_hash_ip.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
--
   net/netfilter/ipset/ip_set_hash_ipportip.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
   net/netfilter/ipset/ip_set_hash_ipportip.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
--
   net/netfilter/ipset/ip_set_hash_ipport.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
   net/netfilter/ipset/ip_set_hash_ipport.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
--
   net/netfilter/ipset/ip_set_hash_netiface.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
   net/netfilter/ipset/ip_set_hash_netiface.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
--
   net/netfilter/ipset/ip_set_hash_netport.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
   net/netfilter/ipset/ip_set_hash_netport.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
--
   net/netfilter/ipset/ip_set_hash_net.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
   net/netfilter/ipset/ip_set_hash_net.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
--
   net/netfilter/ipset/ip_set_hash_ipportnet.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table
   net/netfilter/ipset/ip_set_hash_ipportnet.c: note: in included file:
>> net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct hbucket *n @@     got struct hbucket [noderef] __rcu * @@
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     expected struct hbucket *n
   net/netfilter/ipset/ip_set_hash_gen.h:435:19: sparse:     got struct hbucket [noderef] __rcu *
>> net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct htable *t @@     got struct htable [noderef] __rcu *table @@
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     expected struct htable *t
   net/netfilter/ipset/ip_set_hash_gen.h:455:35: sparse:     got struct htable [noderef] __rcu *table

vim +435 net/netfilter/ipset/ip_set_hash_gen.h

   426	
   427	/* Destroy the hashtable part of the set */
   428	static void
   429	mtype_ahash_destroy(struct ip_set *set, struct htable *t, bool ext_destroy)
   430	{
   431		struct hbucket *n;
   432		u32 i;
   433	
   434		for (i = 0; i < jhash_size(t->htable_bits); i++) {
 > 435			n = hbucket(t, i);
   436			if (!n)
   437				continue;
   438			if (set->extensions & IPSET_EXT_DESTROY && ext_destroy)
   439				mtype_ext_cleanup(set, n);
   440			/* FIXME: use slab cache */
   441			kfree(n);
   442		}
   443	
   444		ip_set_free(t->hregion);
   445		ip_set_free(t);
   446	}
   447	
   448	/* Destroy a hash type of set */
   449	static void
   450	mtype_destroy(struct ip_set *set)
   451	{
   452		struct htype *h = set->data;
   453		struct list_head *l, *lt;
   454	
 > 455		mtype_ahash_destroy(set, h->table, true);
   456		list_for_each_safe(l, lt, &h->ad) {
   457			list_del(l);
   458			kfree(l);
   459		}
   460		kfree(h);
   461	
   462		set->data = NULL;
   463	}
   464	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
