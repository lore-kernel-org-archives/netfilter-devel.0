Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFE51917DA
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Sep 2024 03:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726976537; cv=none; b=T3kqXQ4exWg5xYIwVsct2xDBC7VqMLcAds00BbZVf2gYjXOKHYgjHscePim1d5ffJfGx8GuFcoOvJEDh+JHEgySqMGkv37sRLhFfS5v3QonpRyrawtr1XL3wxbRAUgjYv22S2qoNQGEmy2lQKnJvGbYC/4sny4zdGitEXwSgFsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726976537; c=relaxed/simple;
	bh=wizCxCVLJ52oD70kvuI8PpPw1dGbD5jBEovylcm46cg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cMm3UMNixHL2T2P7p2m1acmKz4TbyJFYc4IuHBnjNxnwp5nYt8oP6Q9GhxCjA//20gMNy0ZVMgMShsPjWdvyZ4IFUAbHE+XgBSAfSO04UMzNujizvZ3LrLiWuocNNeq2X9bKe2d1rsj80hd9dsEKb5CoHmf8I8G4ldzPorNz99g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KR16hSj0; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KR16hSj0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726976536; x=1758512536;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=wizCxCVLJ52oD70kvuI8PpPw1dGbD5jBEovylcm46cg=;
  b=KR16hSj0LbgpkpYEGVV3okvj92bzBq7ZGppDIi4NF/10cF72lwjsCeMV
   P0Np06YSPoSCvwjSa+u95XGOfP8EQAZQyel9i3IMihcZf/TmgRmXhsx4D
   TG4kSa7BAVvnix8Ajgd52WGpblpc3OAojpRLlmxbZC0wxIWIggPBTDlAl
   qUPXbB5t3OrOXQIAL2fFkJBDou2mIoZ7vrUnrpOfqaiSnV0uYB5hjdOBG
   PhRWEZxvx7pCm3kEDWBklqgT7SYWSIAtLv1qK+zSDfl+Mxrp9f2RY/5Ig
   giC/eq5T42a8/GPMW+yVZBgAT+vpHcPoVml6Me4gVFUluItQAoFpqOcXL
   w==;
X-CSE-ConnectionGUID: XThNvxEeTBO0Ge2BIjZNzA==
X-CSE-MsgGUID: kXvBRKRWQKyA7pU5w5XzrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11202"; a="26099284"
X-IronPort-AV: E=Sophos;i="6.10,248,1719903600"; 
   d="scan'208";a="26099284"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2024 20:42:15 -0700
X-CSE-ConnectionGUID: Ey5I3YQHSY6nFwSxaJwC2w==
X-CSE-MsgGUID: nfEpDfR7QUGTZAk2+y2Zbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,248,1719903600"; 
   d="scan'208";a="71153594"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 21 Sep 2024 20:42:14 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ssDUB-000G0E-1Y;
	Sun, 22 Sep 2024 03:42:11 +0000
Date: Sun, 22 Sep 2024 11:41:20 +0800
From: kernel test robot <lkp@intel.com>
To: Florian Westphal <fw@strlen.de>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [nf-next:testing 4/5] net/netfilter/nf_nat_masquerade.c:273:6:
 warning: variable 'ret' is uninitialized when used here
Message-ID: <202409221130.jIDto0hf-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git testing
head:   eb5a3496084f9a3ea3fb4c4d22b4c661d46a2743
commit: ecc701a3bd9890f83ea89337c64d4f14aba9f091 [4/5] netfilter: nf_nat: use skb_drop_reason
config: arm-aspeed_g4_defconfig (https://download.01.org/0day-ci/archive/20240922/202409221130.jIDto0hf-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 8663a75fa2f31299ab8d1d90288d9df92aadee88)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240922/202409221130.jIDto0hf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409221130.jIDto0hf-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from net/netfilter/nf_nat_masquerade.c:5:
   In file included from include/linux/inetdevice.h:9:
   In file included from include/linux/ip.h:16:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/arm/include/asm/cacheflush.h:10:
   In file included from include/linux/mm.h:2232:
   include/linux/vmstat.h:517:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     517 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> net/netfilter/nf_nat_masquerade.c:273:6: warning: variable 'ret' is uninitialized when used here [-Wuninitialized]
     273 |         if (ret == NF_DROP)
         |             ^~~
   net/netfilter/nf_nat_masquerade.c:253:9: note: initialize the variable 'ret' to silence this warning
     253 |         int ret;
         |                ^
         |                 = 0
   2 warnings generated.


vim +/ret +273 net/netfilter/nf_nat_masquerade.c

   243	
   244	unsigned int
   245	nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
   246			       const struct net_device *out)
   247	{
   248		enum ip_conntrack_info ctinfo;
   249		struct nf_conn_nat *nat;
   250		struct in6_addr src;
   251		struct nf_conn *ct;
   252		struct nf_nat_range2 newrange;
   253		int ret;
   254	
   255		ct = nf_ct_get(skb, &ctinfo);
   256		WARN_ON(!(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
   257				 ctinfo == IP_CT_RELATED_REPLY)));
   258	
   259		if (nat_ipv6_dev_get_saddr(nf_ct_net(ct), out,
   260					   &ipv6_hdr(skb)->daddr, 0, &src) < 0)
   261			return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EADDRNOTAVAIL);
   262	
   263		nat = nf_ct_nat_ext_add(ct);
   264		if (nat)
   265			nat->masq_index = out->ifindex;
   266	
   267		newrange.flags		= range->flags | NF_NAT_RANGE_MAP_IPS;
   268		newrange.min_addr.in6	= src;
   269		newrange.max_addr.in6	= src;
   270		newrange.min_proto	= range->min_proto;
   271		newrange.max_proto	= range->max_proto;
   272	
 > 273		if (ret == NF_DROP)
   274			return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
   275	
   276		return ret;
   277	}
   278	EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6);
   279	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
