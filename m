Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FBD18E036
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2024 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136710; cv=none; b=hNOQK26BcNbN1B8npIPr5TqZUJYmcseiOmmK53Vy9VgLdkbO5MmWKcNgbASepYjqWS4WmE4GIL8s+UWn2TyiRDN4WL0Dyd0zYlLUrBWhY8Sp0B9odHdtRh8PYFs9bmnC21EkeXRmdXuP4yhmUw16M4Hcz2xFyzzB0yZJBCB7+/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136710; c=relaxed/simple;
	bh=62ELqt+mORtB6oJS5Xw2fdqzo2ZG5HaBDvytX6JkZgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zco+HxHpt7Zxs65wTeT1ElRpibcDs0mj/S5oKdD//TUY/poh1TZ98ofpGnqxBlQtB+SWaknvEQjtTl9jmLbHuHSIV3O4eqV9fYc/MBsd9Nhe2sKRnM3jVaTJTabECUwWDjgsBlu+re71wXRbJqQoszChp8KvqkOPzrDuC3OKvDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ARvJc/Ms; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ARvJc/Ms"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723136707; x=1754672707;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=62ELqt+mORtB6oJS5Xw2fdqzo2ZG5HaBDvytX6JkZgY=;
  b=ARvJc/MsPjiElq31A8JB20YqbQg0NP+up7yiH1FKTc4bl35QrI1NDv8P
   NFRfYCT+koNZjRJ4AWdLJhZnouDrMv/dm1omrU0x1dmdHlY2ScBKWDwcO
   mQLiTLXNuDwq7ZO/2DzgCJWHjkaKEsgqi5mr8dqo4hTfaxjEMP68TLiKH
   L/OY4U9TAHCkwLskS3+irsQD1MzWJRsvVV4jibj8isCYPAMEDKWpBU9f9
   htjhswuCGz6H6sWV4IDQcO7pLSJPJ8/IyHkgNL7g+qBzb0Ni5uqgQ84Xp
   dAFP9tTCRksliSkxnVSKSPZ9i+TTx7WB4uFku9kkNVRUSV1ZIGLQwqOpp
   A==;
X-CSE-ConnectionGUID: zCFhupfNRyicRwutZhDt8g==
X-CSE-MsgGUID: t/Uq5wTiR7aOjxSJ2gvhyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="25044781"
X-IronPort-AV: E=Sophos;i="6.09,273,1716274800"; 
   d="scan'208";a="25044781"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 10:03:14 -0700
X-CSE-ConnectionGUID: Y2ssEFPxRV2TsQsk5UVbFg==
X-CSE-MsgGUID: 3ZYx2MuLRjqAcVoSzMMeAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,273,1716274800"; 
   d="scan'208";a="61674257"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 08 Aug 2024 10:03:13 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sc6Xa-0006Lb-0P;
	Thu, 08 Aug 2024 17:03:07 +0000
Date: Fri, 9 Aug 2024 01:01:46 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH nf-next 7/8] netfilter: nf_tables: add never expires
 marker to elements
Message-ID: <202408090046.7kJeFHf4-lkp@intel.com>
References: <20240807142357.90493-8-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807142357.90493-8-pablo@netfilter.org>

Hi Pablo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on netfilter-nf/main]
[also build test WARNING on linus/master v6.11-rc2 next-20240808]
[cannot apply to nf-next/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pablo-Neira-Ayuso/netfilter-nf_tables-elements-with-timeout-less-than-HZ-10-never-expire/20240807-222806
base:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git main
patch link:    https://lore.kernel.org/r/20240807142357.90493-8-pablo%40netfilter.org
patch subject: [PATCH nf-next 7/8] netfilter: nf_tables: add never expires marker to elements
config: x86_64-randconfig-123-20240808 (https://download.01.org/0day-ci/archive/20240809/202408090046.7kJeFHf4-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240809/202408090046.7kJeFHf4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408090046.7kJeFHf4-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   net/netfilter/nf_tables_api.c:1905:25: sparse: sparse: cast between address spaces (__percpu -> __rcu)
   net/netfilter/nf_tables_api.c:1905:25: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_tables_api.c:1905:25: sparse:    struct nft_stats [noderef] __rcu *
   net/netfilter/nf_tables_api.c:1905:25: sparse:    struct nft_stats [noderef] __percpu *
   net/netfilter/nf_tables_api.c:2077:31: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected struct nft_stats [noderef] __percpu * @@     got void * @@
   net/netfilter/nf_tables_api.c:2080:31: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected struct nft_stats [noderef] __percpu * @@     got void * @@
   net/netfilter/nf_tables_api.c:2084:31: sparse: sparse: incorrect type in return expression (different address spaces) @@     expected struct nft_stats [noderef] __percpu * @@     got void * @@
   net/netfilter/nf_tables_api.c:2107:17: sparse: sparse: cast between address spaces (__percpu -> __rcu)
   net/netfilter/nf_tables_api.c:2107:17: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_tables_api.c:2107:17: sparse:    struct nft_stats [noderef] __rcu *
   net/netfilter/nf_tables_api.c:2107:17: sparse:    struct nft_stats [noderef] __percpu *
   net/netfilter/nf_tables_api.c:2107:17: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_tables_api.c:2107:17: sparse:    struct nft_stats [noderef] __rcu *
   net/netfilter/nf_tables_api.c:2107:17: sparse:    struct nft_stats [noderef] __percpu *
   net/netfilter/nf_tables_api.c:2150:21: sparse: sparse: cast between address spaces (__percpu -> __rcu)
   net/netfilter/nf_tables_api.c:2150:21: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_tables_api.c:2150:21: sparse:    struct nft_stats [noderef] __rcu *
   net/netfilter/nf_tables_api.c:2150:21: sparse:    struct nft_stats [noderef] __percpu *
   net/netfilter/nf_tables_api.c:2533:25: sparse: sparse: cast between address spaces (__percpu -> __rcu)
   net/netfilter/nf_tables_api.c:2533:25: sparse: sparse: incompatible types in comparison expression (different address spaces):
   net/netfilter/nf_tables_api.c:2533:25: sparse:    struct nft_stats [noderef] __rcu *
   net/netfilter/nf_tables_api.c:2533:25: sparse:    struct nft_stats [noderef] __percpu *
   net/netfilter/nf_tables_api.c:2740:23: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct nft_stats *stats @@     got struct nft_stats [noderef] __percpu * @@
   net/netfilter/nf_tables_api.c:2752:38: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct nft_stats [noderef] __percpu *stats @@     got struct nft_stats *stats @@
   net/netfilter/nf_tables_api.c:2798:21: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void [noderef] __percpu *__pdata @@     got struct nft_stats *stats @@
>> net/netfilter/nf_tables_api.c:5829:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [assigned] [usertype] msecs @@     got restricted __be64 @@
   net/netfilter/nf_tables_api.c:5831:31: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [assigned] [usertype] msecs @@     got restricted __be64 @@
>> net/netfilter/nf_tables_api.c:5834:62: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __be64 [usertype] value @@     got unsigned long long [assigned] [usertype] msecs @@
   net/netfilter/nf_tables_api.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/umh.h, include/linux/kmod.h, ...):
   include/linux/page-flags.h:235:46: sparse: sparse: self-comparison always evaluates to false
   include/linux/page-flags.h:235:46: sparse: sparse: self-comparison always evaluates to false
   net/netfilter/nf_tables_api.c: note: in included file (through include/linux/rbtree.h, include/linux/mm_types.h, include/linux/mmzone.h, ...):
   include/linux/rcupdate.h:867:9: sparse: sparse: context imbalance in 'nft_netlink_dump_start_rcu' - unexpected unlock

vim +5829 net/netfilter/nf_tables_api.c

  5778	
  5779	static int nf_tables_fill_setelem(struct sk_buff *skb,
  5780					  const struct nft_set *set,
  5781					  const struct nft_elem_priv *elem_priv,
  5782					  bool reset)
  5783	{
  5784		const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
  5785		unsigned char *b = skb_tail_pointer(skb);
  5786		struct nlattr *nest;
  5787	
  5788		nest = nla_nest_start_noflag(skb, NFTA_LIST_ELEM);
  5789		if (nest == NULL)
  5790			goto nla_put_failure;
  5791	
  5792		if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY) &&
  5793		    nft_data_dump(skb, NFTA_SET_ELEM_KEY, nft_set_ext_key(ext),
  5794				  NFT_DATA_VALUE, set->klen) < 0)
  5795			goto nla_put_failure;
  5796	
  5797		if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END) &&
  5798		    nft_data_dump(skb, NFTA_SET_ELEM_KEY_END, nft_set_ext_key_end(ext),
  5799				  NFT_DATA_VALUE, set->klen) < 0)
  5800			goto nla_put_failure;
  5801	
  5802		if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
  5803		    nft_data_dump(skb, NFTA_SET_ELEM_DATA, nft_set_ext_data(ext),
  5804				  nft_set_datatype(set), set->dlen) < 0)
  5805			goto nla_put_failure;
  5806	
  5807		if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPRESSIONS) &&
  5808		    nft_set_elem_expr_dump(skb, set, ext, reset))
  5809			goto nla_put_failure;
  5810	
  5811		if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
  5812		    nla_put_string(skb, NFTA_SET_ELEM_OBJREF,
  5813				   (*nft_set_ext_obj(ext))->key.name) < 0)
  5814			goto nla_put_failure;
  5815	
  5816		if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
  5817		    nla_put_be32(skb, NFTA_SET_ELEM_FLAGS,
  5818			         htonl(*nft_set_ext_flags(ext))))
  5819			goto nla_put_failure;
  5820	
  5821		if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
  5822			u64 timeout = nft_set_ext_timeout(ext)->timeout, msecs = 0;
  5823			u64 set_timeout = READ_ONCE(set->timeout);
  5824	
  5825			if (set_timeout > 0) {
  5826				if (timeout == NFT_NEVER_EXPIRES)
  5827					msecs = NFT_NEVER_EXPIRES;
  5828				else if (timeout != set_timeout)
> 5829					msecs = nf_jiffies64_to_msecs(timeout);
  5830			} else if (timeout && timeout != NFT_NEVER_EXPIRES)
  5831				msecs = nf_jiffies64_to_msecs(timeout);
  5832	
  5833			if (msecs &&
> 5834			    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT, msecs,
  5835					 NFTA_SET_ELEM_PAD))
  5836				goto nla_put_failure;
  5837	
  5838			if (timeout != NFT_NEVER_EXPIRES) {
  5839				u64 expires, now = get_jiffies_64();
  5840	
  5841				expires = READ_ONCE(nft_set_ext_timeout(ext)->expiration);
  5842				if (time_before64(now, expires))
  5843					expires -= now;
  5844				else
  5845					expires = 0;
  5846	
  5847				if (nla_put_be64(skb, NFTA_SET_ELEM_EXPIRATION,
  5848						 nf_jiffies64_to_msecs(expires),
  5849						 NFTA_SET_ELEM_PAD))
  5850					goto nla_put_failure;
  5851			}
  5852		}
  5853	
  5854		if (nft_set_ext_exists(ext, NFT_SET_EXT_USERDATA)) {
  5855			struct nft_userdata *udata;
  5856	
  5857			udata = nft_set_ext_userdata(ext);
  5858			if (nla_put(skb, NFTA_SET_ELEM_USERDATA,
  5859				    udata->len + 1, udata->data))
  5860				goto nla_put_failure;
  5861		}
  5862	
  5863		nla_nest_end(skb, nest);
  5864		return 0;
  5865	
  5866	nla_put_failure:
  5867		nlmsg_trim(skb, b);
  5868		return -EMSGSIZE;
  5869	}
  5870	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
