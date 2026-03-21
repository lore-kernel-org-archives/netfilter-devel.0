Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6240F346AFB
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 08:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774081414; cv=none; b=uD7miDsX9fLDN4hz8dbBIrrSQskIpbwgls0r8T7sPkqEZBnNQiQUBaDg97ca8VvJ3Y8o4LRDC7IMOBx9NHcM05izoBdhGrkDoNAg2dsW2WxAMugh9KXPdTO/0MP9LAihCLV+84ORmMNN41BEhr5aRHBnvUoRzPLj2GGJVfU8YoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774081414; c=relaxed/simple;
	bh=hbFgvJSFm2EVOB3WiiZS5TaOg4K5jhU142IhDTiUJhM=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ueOJ/XurbRrCkXndOwTap+m7dmWcuLwBBDWCKneA05/AYIFL4M3HE83o70q+cA0QOyzqKVOjgYrOH2Ut3bzxpxpAXSbYh6ysdpSVm8x59BPvGQ/EN+D9m2ycZssvd0DWehv/T+29b6gBML6C0DRS/m2kA+7opIN4pFd3Fw3VDdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OwVoHqJZ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OwVoHqJZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774081411; x=1805617411;
  h=date:from:to:cc:subject:message-id;
  bh=hbFgvJSFm2EVOB3WiiZS5TaOg4K5jhU142IhDTiUJhM=;
  b=OwVoHqJZ/HgxRz8/U1lrfC9dv6T67gcB6YMyXsaQ1OvGd/XwrbkD0RhR
   NJN2rA0O8kdGktCLruqxYIdM76D1lWJNOH/pWfgv4FBkT0ghF3PLQ1oAy
   BiqrmoZZYkn0QPHbzlCTYjPI0xCOxVE/0Nwm5xeAFdRUWRf52w21RC55h
   szNGafTSYNLbBWgvBXgGTlW/5VZcL3JuY9dbFwEUV/ycGoACDN7bDgLFk
   BISP42zrnSZepH70N2Q6FONKDPqDcziGeBVX56vwuD69ebJLV9E/gCeii
   4FJdk7JYNt4L41/mOvjOeqoTiSaxmnEDn1jo6Ubt2T7G+uA09dGkGPeYQ
   g==;
X-CSE-ConnectionGUID: MshD+N/7S7+01VgATgiPyQ==
X-CSE-MsgGUID: u34L0oT9T0yPecNdg9hamQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="75186342"
X-IronPort-AV: E=Sophos;i="6.23,133,1770624000"; 
   d="scan'208";a="75186342"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2026 01:23:30 -0700
X-CSE-ConnectionGUID: Bxaye6LMQRGvzt+q0zdRzw==
X-CSE-MsgGUID: RKRwSgepTy66Ekot9QmRGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,133,1770624000"; 
   d="scan'208";a="218805304"
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 21 Mar 2026 01:23:27 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3rbv-000000000Tf-021B;
	Sat, 21 Mar 2026 08:23:09 +0000
Date: Sat, 21 Mar 2026 16:21:51 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [netfilter-nf:testing 7/9] include/net/ip6_fib.h:663:33:
 error: invalid storage class for function 'fib6_rules_init'
Message-ID: <202603211611.4ulHj95G-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git testing
head:   b1bad43d8b00ab31c8f93145a4c8db1567f0d2fe
commit: 20d564bba6b3806c26498061299a88330561efa5 [7/9] netfilter: ctnetlink: ensure safe access to master conntrack
config: x86_64-randconfig-002-20260321 (https://download.01.org/0day-ci/archive/20260321/202603211611.4ulHj95G-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603211611.4ulHj95G-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603211611.4ulHj95G-lkp@intel.com/

All errors (new ones prefixed by >>):

   include/net/inet_ecn.h:222:19: error: invalid storage class for function 'INET_ECN_set_ect1'
     222 | static inline int INET_ECN_set_ect1(struct sk_buff *skb)
         |                   ^~~~~~~~~~~~~~~~~
   include/net/inet_ecn.h: In function 'INET_ECN_set_ect1':
   include/net/inet_ecn.h:232:54: error: invalid application of 'sizeof' to incomplete type 'struct ipv6hdr'
     232 |                 if (skb_network_header(skb) + sizeof(struct ipv6hdr) <=
         |                                                      ^~~~~~
   include/net/inet_ecn.h:234:54: error: passing argument 2 of 'IP6_ECN_set_ect1' from incompatible pointer type [-Wincompatible-pointer-types]
     234 |                         return IP6_ECN_set_ect1(skb, ipv6_hdr(skb));
         |                                                      ^~~~~~~~~~~~~
         |                                                      |
         |                                                      struct ipv6hdr *
   include/net/inet_ecn.h:164:73: note: expected 'struct ipv6hdr *' but argument is of type 'struct ipv6hdr *'
     164 | static inline int IP6_ECN_set_ect1(struct sk_buff *skb, struct ipv6hdr *iph)
         |                                                         ~~~~~~~~~~~~~~~~^~~
   include/net/inet_ecn.h: In function 'lockdep_nfct_expect_lock_not_held':
   include/net/inet_ecn.h:265:19: error: invalid storage class for function '__INET_ECN_decapsulate'
     265 | static inline int __INET_ECN_decapsulate(__u8 outer, __u8 inner, bool *set_ce)
         |                   ^~~~~~~~~~~~~~~~~~~~~~
   include/net/inet_ecn.h:283:19: error: invalid storage class for function 'INET_ECN_decapsulate'
     283 | static inline int INET_ECN_decapsulate(struct sk_buff *skb,
         |                   ^~~~~~~~~~~~~~~~~~~~
   include/net/inet_ecn.h:300:19: error: invalid storage class for function 'IP_ECN_decapsulate'
     300 | static inline int IP_ECN_decapsulate(const struct iphdr *oiph,
         |                   ^~~~~~~~~~~~~~~~~~
   include/net/inet_ecn.h:319:19: error: invalid storage class for function 'IP6_ECN_decapsulate'
     319 | static inline int IP6_ECN_decapsulate(const struct ipv6hdr *oipv6h,
         |                   ^~~~~~~~~~~~~~~~~~~
   include/net/inet_ecn.h: In function 'IP6_ECN_decapsulate':
   include/net/inet_ecn.h:335:59: error: passing argument 1 of 'ipv6_get_dsfield' from incompatible pointer type [-Wincompatible-pointer-types]
     335 |         return INET_ECN_decapsulate(skb, ipv6_get_dsfield(oipv6h), inner);
         |                                                           ^~~~~~
         |                                                           |
         |                                                           const struct ipv6hdr *
   include/net/dsfield.h:22:59: note: expected 'const struct ipv6hdr *' but argument is of type 'const struct ipv6hdr *'
      22 | static inline __u8 ipv6_get_dsfield(const struct ipv6hdr *ipv6h)
         |                                     ~~~~~~~~~~~~~~~~~~~~~~^~~~~
   In file included from include/net/dst_cache.h:8,
                    from include/net/ip_tunnels.h:21:
   include/net/ip6_fib.h: In function 'lockdep_nfct_expect_lock_not_held':
   include/net/ip6_fib.h:91:20: error: invalid storage class for function 'fib6_routes_require_src'
      91 | static inline bool fib6_routes_require_src(const struct net *net)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:96:20: error: invalid storage class for function 'fib6_routes_require_src_inc'
      96 | static inline void fib6_routes_require_src_inc(struct net *net) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:97:20: error: invalid storage class for function 'fib6_routes_require_src_dec'
      97 | static inline void fib6_routes_require_src_dec(struct net *net) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:240:33: error: invalid storage class for function 'ip6_dst_idev'
     240 | static inline struct inet6_dev *ip6_dst_idev(const struct dst_entry *dst)
         |                                 ^~~~~~~~~~~~
   include/net/ip6_fib.h:245:20: error: invalid storage class for function 'fib6_requires_src'
     245 | static inline bool fib6_requires_src(const struct fib6_info *rt)
         |                    ^~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:253:20: error: invalid storage class for function 'fib6_clean_expires'
     253 | static inline void fib6_clean_expires(struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:262:20: error: invalid storage class for function 'fib6_set_expires'
     262 | static inline void fib6_set_expires(struct fib6_info *f6i,
         |                    ^~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:269:20: error: invalid storage class for function 'fib6_check_expired'
     269 | static inline bool fib6_check_expired(const struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:281:20: error: invalid storage class for function 'fib6_get_cookie_safe'
     281 | static inline bool fib6_get_cookie_safe(const struct fib6_info *f6i,
         |                    ^~~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:299:19: error: invalid storage class for function 'rt6_get_cookie'
     299 | static inline u32 rt6_get_cookie(const struct rt6_info *rt)
         |                   ^~~~~~~~~~~~~~
   include/net/ip6_fib.h:318:20: error: invalid storage class for function 'ip6_rt_put'
     318 | static inline void ip6_rt_put(struct rt6_info *rt)
         |                    ^~~~~~~~~~
   include/net/ip6_fib.h:330:20: error: invalid storage class for function 'fib6_info_hold'
     330 | static inline void fib6_info_hold(struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~
   include/net/ip6_fib.h:335:20: error: invalid storage class for function 'fib6_info_hold_safe'
     335 | static inline bool fib6_info_hold_safe(struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:340:20: error: invalid storage class for function 'fib6_info_release'
     340 | static inline void fib6_info_release(struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:474:6: error: invalid storage class for function 'rt6_get_prefsrc'
     474 | void rt6_get_prefsrc(const struct rt6_info *rt, struct in6_addr *addr)
         |      ^~~~~~~~~~~~~~~
   include/net/ip6_fib.h:520:20: error: invalid storage class for function 'fib6_add_gc_list'
     520 | static inline void fib6_add_gc_list(struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:542:20: error: invalid storage class for function 'fib6_remove_gc_list'
     542 | static inline void fib6_remove_gc_list(struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:576:20: error: invalid storage class for function 'fib6_metric_locked'
     576 | static inline bool fib6_metric_locked(struct fib6_info *f6i, int metric)
         |                    ^~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:610:32: error: invalid storage class for function 'pol_lookup_func'
     610 | static inline struct rt6_info *pol_lookup_func(pol_lookup_t lookup,
         |                                ^~~~~~~~~~~~~~~
   include/net/ip6_fib.h:659:20: error: invalid storage class for function 'fib6_has_custom_rules'
     659 | static inline bool fib6_has_custom_rules(const struct net *net)
         |                    ^~~~~~~~~~~~~~~~~~~~~
>> include/net/ip6_fib.h:663:33: error: invalid storage class for function 'fib6_rules_init'
     663 | static inline int               fib6_rules_init(void)
         |                                 ^~~~~~~~~~~~~~~
>> include/net/ip6_fib.h:667:33: error: invalid storage class for function 'fib6_rules_cleanup'
     667 | static inline void              fib6_rules_cleanup(void)
         |                                 ^~~~~~~~~~~~~~~~~~
>> include/net/ip6_fib.h:671:20: error: invalid storage class for function 'fib6_rule_default'
     671 | static inline bool fib6_rule_default(const struct fib_rule *rule)
         |                    ^~~~~~~~~~~~~~~~~
>> include/net/ip6_fib.h:675:19: error: invalid storage class for function 'fib6_rules_dump'
     675 | static inline int fib6_rules_dump(struct net *net, struct notifier_block *nb,
         |                   ^~~~~~~~~~~~~~~
>> include/net/ip6_fib.h:680:28: error: invalid storage class for function 'fib6_rules_seq_read'
     680 | static inline unsigned int fib6_rules_seq_read(const struct net *net)
         |                            ^~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:684:20: error: invalid storage class for function 'fib6_rules_early_flow_dissect'
     684 | static inline bool fib6_rules_early_flow_dissect(struct net *net,
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/dst_cache.h:77:20: error: invalid storage class for function 'dst_cache_reset'
      77 | static inline void dst_cache_reset(struct dst_cache *dst_cache)
         |                    ^~~~~~~~~~~~~~~
   In file included from include/net/ip_tunnels.h:22:
   include/net/netdev_lock.h:10:20: error: invalid storage class for function 'netdev_trylock'
      10 | static inline bool netdev_trylock(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~
   include/net/netdev_lock.h:15:20: error: invalid storage class for function 'netdev_assert_locked'
      15 | static inline void netdev_assert_locked(const struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:21:1: error: invalid storage class for function 'netdev_assert_locked_or_invisible'
      21 | netdev_assert_locked_or_invisible(const struct net_device *dev)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:28:20: error: invalid storage class for function 'netdev_need_ops_lock'
      28 | static inline bool netdev_need_ops_lock(const struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:39:20: error: invalid storage class for function 'netdev_lock_ops'
      39 | static inline void netdev_lock_ops(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~
   include/net/netdev_lock.h:45:20: error: invalid storage class for function 'netdev_unlock_ops'
      45 | static inline void netdev_unlock_ops(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:51:20: error: invalid storage class for function 'netdev_lock_ops_to_full'
      51 | static inline void netdev_lock_ops_to_full(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:59:20: error: invalid storage class for function 'netdev_unlock_full_to_ops'
      59 | static inline void netdev_unlock_full_to_ops(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:67:20: error: invalid storage class for function 'netdev_ops_assert_locked'
      67 | static inline void netdev_ops_assert_locked(const struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:76:1: error: invalid storage class for function 'netdev_ops_assert_locked_or_invisible'
      76 | netdev_ops_assert_locked_or_invisible(const struct net_device *dev)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:83:20: error: invalid storage class for function 'netdev_lock_ops_compat'
      83 | static inline void netdev_lock_ops_compat(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:91:20: error: invalid storage class for function 'netdev_unlock_ops_compat'
      91 | static inline void netdev_unlock_ops_compat(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:99:19: error: invalid storage class for function 'netdev_lock_cmp_fn'
      99 | static inline int netdev_lock_cmp_fn(const struct lockdep_map *a,
         |                   ^~~~~~~~~~~~~~~~~~
   In file included from include/net/ip6_route.h:13,
                    from include/net/ip_tunnels.h:27:
   include/net/nexthop.h:264:20: error: invalid storage class for function 'nexthop_get'
     264 | static inline bool nexthop_get(struct nexthop *nh)
         |                    ^~~~~~~~~~~
   include/net/nexthop.h:269:20: error: invalid storage class for function 'nexthop_put'
     269 | static inline void nexthop_put(struct nexthop *nh)
         |                    ^~~~~~~~~~~
   include/net/nexthop.h:275:20: error: invalid storage class for function 'nexthop_cmp'
     275 | static inline bool nexthop_cmp(const struct nexthop *nh1,
         |                    ^~~~~~~~~~~
   include/net/nexthop.h:281:20: error: invalid storage class for function 'nexthop_is_fdb'
     281 | static inline bool nexthop_is_fdb(const struct nexthop *nh)
         |                    ^~~~~~~~~~~~~~
   include/net/nexthop.h:296:20: error: invalid storage class for function 'nexthop_has_v4'
     296 | static inline bool nexthop_has_v4(const struct nexthop *nh)
         |                    ^~~~~~~~~~~~~~
   include/net/nexthop.h:307:20: error: invalid storage class for function 'nexthop_is_multipath'
     307 | static inline bool nexthop_is_multipath(const struct nexthop *nh)
         |                    ^~~~~~~~~~~~~~~~~~~~
   include/net/nexthop.h:320:28: error: invalid storage class for function 'nexthop_num_path'
     320 | static inline unsigned int nexthop_num_path(const struct nexthop *nh)
         |                            ^~~~~~~~~~~~~~~~
   include/net/nexthop.h:336:17: error: invalid storage class for function 'nexthop_mpath_select'
     336 | struct nexthop *nexthop_mpath_select(const struct nh_group *nhg, int nhsel)
         |                 ^~~~~~~~~~~~~~~~~~~~
   include/net/nexthop.h:348:5: error: invalid storage class for function 'nexthop_mpath_fill_node'
     348 | int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh,
         |     ^~~~~~~~~~~~~~~~~~~~~~~
   include/net/nexthop.h:368:20: error: invalid storage class for function 'nexthop_is_blackhole'
     368 | static inline bool nexthop_is_blackhole(const struct nexthop *nh)
         |                    ^~~~~~~~~~~~~~~~~~~~
   include/net/nexthop.h:386:20: error: invalid storage class for function 'nexthop_path_fib_result'
     386 | static inline void nexthop_path_fib_result(struct fib_result *res, int hash)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
   include/net/nexthop.h: In function 'nexthop_path_fib_result':
   include/net/nexthop.h:391:41: error: passing argument 1 of 'nexthop_select_path' from incompatible pointer type [-Wincompatible-pointer-types]
     391 |         nh = nexthop_select_path(res->fi->nh, hash);
         |                                  ~~~~~~~^~~~
         |                                         |
         |                                         struct nexthop *
   include/net/nexthop.h:318:53: note: expected 'struct nexthop *' but argument is of type 'struct nexthop *'
     318 | struct nexthop *nexthop_select_path(struct nexthop *nh, int hash);
         |                                     ~~~~~~~~~~~~~~~~^~
   include/net/nexthop.h: In function 'lockdep_nfct_expect_lock_not_held':
   include/net/nexthop.h:398:23: error: invalid storage class for function 'nexthop_fib_nhc'
     398 | struct fib_nh_common *nexthop_fib_nhc(struct nexthop *nh, int nhsel)
         |                       ^~~~~~~~~~~~~~~
   include/net/nexthop.h:422:23: error: invalid storage class for function 'nexthop_get_nhc_lookup'
     422 | struct fib_nh_common *nexthop_get_nhc_lookup(const struct nexthop *nh,
         |                       ^~~~~~~~~~~~~~~~~~~~~~
   include/net/nexthop.h:453:20: error: invalid storage class for function 'nexthop_uses_dev'
--
   include/net/inet_ecn.h:222:19: error: invalid storage class for function 'INET_ECN_set_ect1'
     222 | static inline int INET_ECN_set_ect1(struct sk_buff *skb)
         |                   ^~~~~~~~~~~~~~~~~
   include/net/inet_ecn.h: In function 'INET_ECN_set_ect1':
   include/net/inet_ecn.h:232:54: error: invalid application of 'sizeof' to incomplete type 'struct ipv6hdr'
     232 |                 if (skb_network_header(skb) + sizeof(struct ipv6hdr) <=
         |                                                      ^~~~~~
   include/net/inet_ecn.h:234:54: error: passing argument 2 of 'IP6_ECN_set_ect1' from incompatible pointer type [-Wincompatible-pointer-types]
     234 |                         return IP6_ECN_set_ect1(skb, ipv6_hdr(skb));
         |                                                      ^~~~~~~~~~~~~
         |                                                      |
         |                                                      struct ipv6hdr *
   include/net/inet_ecn.h:164:73: note: expected 'struct ipv6hdr *' but argument is of type 'struct ipv6hdr *'
     164 | static inline int IP6_ECN_set_ect1(struct sk_buff *skb, struct ipv6hdr *iph)
         |                                                         ~~~~~~~~~~~~~~~~^~~
   include/net/inet_ecn.h: In function 'lockdep_nfct_expect_lock_not_held':
   include/net/inet_ecn.h:265:19: error: invalid storage class for function '__INET_ECN_decapsulate'
     265 | static inline int __INET_ECN_decapsulate(__u8 outer, __u8 inner, bool *set_ce)
         |                   ^~~~~~~~~~~~~~~~~~~~~~
   include/net/inet_ecn.h:283:19: error: invalid storage class for function 'INET_ECN_decapsulate'
     283 | static inline int INET_ECN_decapsulate(struct sk_buff *skb,
         |                   ^~~~~~~~~~~~~~~~~~~~
   include/net/inet_ecn.h:300:19: error: invalid storage class for function 'IP_ECN_decapsulate'
     300 | static inline int IP_ECN_decapsulate(const struct iphdr *oiph,
         |                   ^~~~~~~~~~~~~~~~~~
   include/net/inet_ecn.h:319:19: error: invalid storage class for function 'IP6_ECN_decapsulate'
     319 | static inline int IP6_ECN_decapsulate(const struct ipv6hdr *oipv6h,
         |                   ^~~~~~~~~~~~~~~~~~~
   include/net/inet_ecn.h: In function 'IP6_ECN_decapsulate':
   include/net/inet_ecn.h:335:59: error: passing argument 1 of 'ipv6_get_dsfield' from incompatible pointer type [-Wincompatible-pointer-types]
     335 |         return INET_ECN_decapsulate(skb, ipv6_get_dsfield(oipv6h), inner);
         |                                                           ^~~~~~
         |                                                           |
         |                                                           const struct ipv6hdr *
   include/net/dsfield.h:22:59: note: expected 'const struct ipv6hdr *' but argument is of type 'const struct ipv6hdr *'
      22 | static inline __u8 ipv6_get_dsfield(const struct ipv6hdr *ipv6h)
         |                                     ~~~~~~~~~~~~~~~~~~~~~~^~~~~
   In file included from include/net/dst_cache.h:8,
                    from include/net/ip_tunnels.h:21:
   include/net/ip6_fib.h: In function 'lockdep_nfct_expect_lock_not_held':
   include/net/ip6_fib.h:91:20: error: invalid storage class for function 'fib6_routes_require_src'
      91 | static inline bool fib6_routes_require_src(const struct net *net)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:96:20: error: invalid storage class for function 'fib6_routes_require_src_inc'
      96 | static inline void fib6_routes_require_src_inc(struct net *net) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:97:20: error: invalid storage class for function 'fib6_routes_require_src_dec'
      97 | static inline void fib6_routes_require_src_dec(struct net *net) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:240:33: error: invalid storage class for function 'ip6_dst_idev'
     240 | static inline struct inet6_dev *ip6_dst_idev(const struct dst_entry *dst)
         |                                 ^~~~~~~~~~~~
   include/net/ip6_fib.h:245:20: error: invalid storage class for function 'fib6_requires_src'
     245 | static inline bool fib6_requires_src(const struct fib6_info *rt)
         |                    ^~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:253:20: error: invalid storage class for function 'fib6_clean_expires'
     253 | static inline void fib6_clean_expires(struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:262:20: error: invalid storage class for function 'fib6_set_expires'
     262 | static inline void fib6_set_expires(struct fib6_info *f6i,
         |                    ^~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:269:20: error: invalid storage class for function 'fib6_check_expired'
     269 | static inline bool fib6_check_expired(const struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:281:20: error: invalid storage class for function 'fib6_get_cookie_safe'
     281 | static inline bool fib6_get_cookie_safe(const struct fib6_info *f6i,
         |                    ^~~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:299:19: error: invalid storage class for function 'rt6_get_cookie'
     299 | static inline u32 rt6_get_cookie(const struct rt6_info *rt)
         |                   ^~~~~~~~~~~~~~
   include/net/ip6_fib.h:318:20: error: invalid storage class for function 'ip6_rt_put'
     318 | static inline void ip6_rt_put(struct rt6_info *rt)
         |                    ^~~~~~~~~~
   include/net/ip6_fib.h:330:20: error: invalid storage class for function 'fib6_info_hold'
     330 | static inline void fib6_info_hold(struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~
   include/net/ip6_fib.h:335:20: error: invalid storage class for function 'fib6_info_hold_safe'
     335 | static inline bool fib6_info_hold_safe(struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:340:20: error: invalid storage class for function 'fib6_info_release'
     340 | static inline void fib6_info_release(struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:474:6: error: invalid storage class for function 'rt6_get_prefsrc'
     474 | void rt6_get_prefsrc(const struct rt6_info *rt, struct in6_addr *addr)
         |      ^~~~~~~~~~~~~~~
   include/net/ip6_fib.h:520:20: error: invalid storage class for function 'fib6_add_gc_list'
     520 | static inline void fib6_add_gc_list(struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:542:20: error: invalid storage class for function 'fib6_remove_gc_list'
     542 | static inline void fib6_remove_gc_list(struct fib6_info *f6i)
         |                    ^~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:576:20: error: invalid storage class for function 'fib6_metric_locked'
     576 | static inline bool fib6_metric_locked(struct fib6_info *f6i, int metric)
         |                    ^~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:610:32: error: invalid storage class for function 'pol_lookup_func'
     610 | static inline struct rt6_info *pol_lookup_func(pol_lookup_t lookup,
         |                                ^~~~~~~~~~~~~~~
   include/net/ip6_fib.h:659:20: error: invalid storage class for function 'fib6_has_custom_rules'
     659 | static inline bool fib6_has_custom_rules(const struct net *net)
         |                    ^~~~~~~~~~~~~~~~~~~~~
>> include/net/ip6_fib.h:663:33: error: invalid storage class for function 'fib6_rules_init'
     663 | static inline int               fib6_rules_init(void)
         |                                 ^~~~~~~~~~~~~~~
>> include/net/ip6_fib.h:667:33: error: invalid storage class for function 'fib6_rules_cleanup'
     667 | static inline void              fib6_rules_cleanup(void)
         |                                 ^~~~~~~~~~~~~~~~~~
>> include/net/ip6_fib.h:671:20: error: invalid storage class for function 'fib6_rule_default'
     671 | static inline bool fib6_rule_default(const struct fib_rule *rule)
         |                    ^~~~~~~~~~~~~~~~~
>> include/net/ip6_fib.h:675:19: error: invalid storage class for function 'fib6_rules_dump'
     675 | static inline int fib6_rules_dump(struct net *net, struct notifier_block *nb,
         |                   ^~~~~~~~~~~~~~~
>> include/net/ip6_fib.h:680:28: error: invalid storage class for function 'fib6_rules_seq_read'
     680 | static inline unsigned int fib6_rules_seq_read(const struct net *net)
         |                            ^~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:684:20: error: invalid storage class for function 'fib6_rules_early_flow_dissect'
     684 | static inline bool fib6_rules_early_flow_dissect(struct net *net,
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/dst_cache.h:77:20: error: invalid storage class for function 'dst_cache_reset'
      77 | static inline void dst_cache_reset(struct dst_cache *dst_cache)
         |                    ^~~~~~~~~~~~~~~
   In file included from include/net/ip_tunnels.h:22:
   include/net/netdev_lock.h:10:20: error: invalid storage class for function 'netdev_trylock'
      10 | static inline bool netdev_trylock(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~
   include/net/netdev_lock.h:15:20: error: invalid storage class for function 'netdev_assert_locked'
      15 | static inline void netdev_assert_locked(const struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:21:1: error: invalid storage class for function 'netdev_assert_locked_or_invisible'
      21 | netdev_assert_locked_or_invisible(const struct net_device *dev)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:28:20: error: invalid storage class for function 'netdev_need_ops_lock'
      28 | static inline bool netdev_need_ops_lock(const struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:39:20: error: invalid storage class for function 'netdev_lock_ops'
      39 | static inline void netdev_lock_ops(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~
   include/net/netdev_lock.h:45:20: error: invalid storage class for function 'netdev_unlock_ops'
      45 | static inline void netdev_unlock_ops(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:51:20: error: invalid storage class for function 'netdev_lock_ops_to_full'
      51 | static inline void netdev_lock_ops_to_full(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:59:20: error: invalid storage class for function 'netdev_unlock_full_to_ops'
      59 | static inline void netdev_unlock_full_to_ops(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:67:20: error: invalid storage class for function 'netdev_ops_assert_locked'
      67 | static inline void netdev_ops_assert_locked(const struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:76:1: error: invalid storage class for function 'netdev_ops_assert_locked_or_invisible'
      76 | netdev_ops_assert_locked_or_invisible(const struct net_device *dev)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:83:20: error: invalid storage class for function 'netdev_lock_ops_compat'
      83 | static inline void netdev_lock_ops_compat(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:91:20: error: invalid storage class for function 'netdev_unlock_ops_compat'
      91 | static inline void netdev_unlock_ops_compat(struct net_device *dev)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~
   include/net/netdev_lock.h:99:19: error: invalid storage class for function 'netdev_lock_cmp_fn'
      99 | static inline int netdev_lock_cmp_fn(const struct lockdep_map *a,
         |                   ^~~~~~~~~~~~~~~~~~
   In file included from include/net/ip6_route.h:13,
                    from include/net/ip_tunnels.h:27:
   include/net/nexthop.h:264:20: error: invalid storage class for function 'nexthop_get'
     264 | static inline bool nexthop_get(struct nexthop *nh)
         |                    ^~~~~~~~~~~
   include/net/nexthop.h:269:20: error: invalid storage class for function 'nexthop_put'
     269 | static inline void nexthop_put(struct nexthop *nh)
         |                    ^~~~~~~~~~~
   include/net/nexthop.h:275:20: error: invalid storage class for function 'nexthop_cmp'
     275 | static inline bool nexthop_cmp(const struct nexthop *nh1,
         |                    ^~~~~~~~~~~
   include/net/nexthop.h:281:20: error: invalid storage class for function 'nexthop_is_fdb'
     281 | static inline bool nexthop_is_fdb(const struct nexthop *nh)
         |                    ^~~~~~~~~~~~~~
   include/net/nexthop.h:296:20: error: invalid storage class for function 'nexthop_has_v4'
     296 | static inline bool nexthop_has_v4(const struct nexthop *nh)
         |                    ^~~~~~~~~~~~~~
   include/net/nexthop.h:307:20: error: invalid storage class for function 'nexthop_is_multipath'
     307 | static inline bool nexthop_is_multipath(const struct nexthop *nh)
         |                    ^~~~~~~~~~~~~~~~~~~~
   include/net/nexthop.h:320:28: error: invalid storage class for function 'nexthop_num_path'
     320 | static inline unsigned int nexthop_num_path(const struct nexthop *nh)
         |                            ^~~~~~~~~~~~~~~~
   include/net/nexthop.h:336:17: error: invalid storage class for function 'nexthop_mpath_select'
     336 | struct nexthop *nexthop_mpath_select(const struct nh_group *nhg, int nhsel)
         |                 ^~~~~~~~~~~~~~~~~~~~
   include/net/nexthop.h:348:5: error: invalid storage class for function 'nexthop_mpath_fill_node'
     348 | int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh,
         |     ^~~~~~~~~~~~~~~~~~~~~~~
   include/net/nexthop.h:368:20: error: invalid storage class for function 'nexthop_is_blackhole'
     368 | static inline bool nexthop_is_blackhole(const struct nexthop *nh)
         |                    ^~~~~~~~~~~~~~~~~~~~
   include/net/nexthop.h:386:20: error: invalid storage class for function 'nexthop_path_fib_result'
     386 | static inline void nexthop_path_fib_result(struct fib_result *res, int hash)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
   include/net/nexthop.h: In function 'nexthop_path_fib_result':
   include/net/nexthop.h:391:41: error: passing argument 1 of 'nexthop_select_path' from incompatible pointer type [-Wincompatible-pointer-types]
     391 |         nh = nexthop_select_path(res->fi->nh, hash);
         |                                  ~~~~~~~^~~~
         |                                         |
         |                                         struct nexthop *
   include/net/nexthop.h:318:53: note: expected 'struct nexthop *' but argument is of type 'struct nexthop *'
     318 | struct nexthop *nexthop_select_path(struct nexthop *nh, int hash);
         |                                     ~~~~~~~~~~~~~~~~^~
   include/net/nexthop.h: In function 'lockdep_nfct_expect_lock_not_held':
   include/net/nexthop.h:398:23: error: invalid storage class for function 'nexthop_fib_nhc'
     398 | struct fib_nh_common *nexthop_fib_nhc(struct nexthop *nh, int nhsel)
         |                       ^~~~~~~~~~~~~~~
   include/net/nexthop.h:422:23: error: invalid storage class for function 'nexthop_get_nhc_lookup'
     422 | struct fib_nh_common *nexthop_get_nhc_lookup(const struct nexthop *nh,
         |                       ^~~~~~~~~~~~~~~~~~~~~~
   include/net/nexthop.h:453:20: error: invalid storage class for function 'nexthop_uses_dev'


vim +/fib6_rules_init +663 include/net/ip6_fib.h

180ca444b985c4 Wei Wang         2017-10-06  574  
8d1c802b2815ed David Ahern      2018-04-17  575  void fib6_metric_set(struct fib6_info *f6i, int metric, u32 val);
8d1c802b2815ed David Ahern      2018-04-17 @576  static inline bool fib6_metric_locked(struct fib6_info *f6i, int metric)
d4ead6b34b67fd David Ahern      2018-04-17  577  {
d4ead6b34b67fd David Ahern      2018-04-17  578  	return !!(f6i->fib6_metrics->metrics[RTAX_LOCK - 1] & (1 << metric));
d4ead6b34b67fd David Ahern      2018-04-17  579  }
907eea486888cf Amit Cohen       2021-02-01  580  void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
0c5fcf9e249ee1 Amit Cohen       2021-02-07  581  			    bool offload, bool trap, bool offload_failed);
180ca444b985c4 Wei Wang         2017-10-06  582  
3c32cc1bceba8a Yonghong Song    2020-05-13  583  #if IS_BUILTIN(CONFIG_IPV6) && defined(CONFIG_BPF_SYSCALL)
3c32cc1bceba8a Yonghong Song    2020-05-13  584  struct bpf_iter__ipv6_route {
3c32cc1bceba8a Yonghong Song    2020-05-13  585  	__bpf_md_ptr(struct bpf_iter_meta *, meta);
3c32cc1bceba8a Yonghong Song    2020-05-13  586  	__bpf_md_ptr(struct fib6_info *, rt);
3c32cc1bceba8a Yonghong Song    2020-05-13  587  };
3c32cc1bceba8a Yonghong Song    2020-05-13  588  #endif
3c32cc1bceba8a Yonghong Song    2020-05-13  589  
55cced4f813bec Brian Vazquez    2020-06-23  590  INDIRECT_CALLABLE_DECLARE(struct rt6_info *ip6_pol_route_output(struct net *net,
55cced4f813bec Brian Vazquez    2020-06-23  591  					     struct fib6_table *table,
55cced4f813bec Brian Vazquez    2020-06-23  592  					     struct flowi6 *fl6,
55cced4f813bec Brian Vazquez    2020-06-23  593  					     const struct sk_buff *skb,
55cced4f813bec Brian Vazquez    2020-06-23  594  					     int flags));
55cced4f813bec Brian Vazquez    2020-06-23  595  INDIRECT_CALLABLE_DECLARE(struct rt6_info *ip6_pol_route_input(struct net *net,
55cced4f813bec Brian Vazquez    2020-06-23  596  					     struct fib6_table *table,
55cced4f813bec Brian Vazquez    2020-06-23  597  					     struct flowi6 *fl6,
55cced4f813bec Brian Vazquez    2020-06-23  598  					     const struct sk_buff *skb,
55cced4f813bec Brian Vazquez    2020-06-23  599  					     int flags));
55cced4f813bec Brian Vazquez    2020-06-23  600  INDIRECT_CALLABLE_DECLARE(struct rt6_info *__ip6_route_redirect(struct net *net,
55cced4f813bec Brian Vazquez    2020-06-23  601  					     struct fib6_table *table,
55cced4f813bec Brian Vazquez    2020-06-23  602  					     struct flowi6 *fl6,
55cced4f813bec Brian Vazquez    2020-06-23  603  					     const struct sk_buff *skb,
55cced4f813bec Brian Vazquez    2020-06-23  604  					     int flags));
55cced4f813bec Brian Vazquez    2020-06-23  605  INDIRECT_CALLABLE_DECLARE(struct rt6_info *ip6_pol_route_lookup(struct net *net,
55cced4f813bec Brian Vazquez    2020-06-23  606  					     struct fib6_table *table,
55cced4f813bec Brian Vazquez    2020-06-23  607  					     struct flowi6 *fl6,
55cced4f813bec Brian Vazquez    2020-06-23  608  					     const struct sk_buff *skb,
55cced4f813bec Brian Vazquez    2020-06-23  609  					     int flags));
55cced4f813bec Brian Vazquez    2020-06-23 @610  static inline struct rt6_info *pol_lookup_func(pol_lookup_t lookup,
55cced4f813bec Brian Vazquez    2020-06-23  611  						struct net *net,
55cced4f813bec Brian Vazquez    2020-06-23  612  						struct fib6_table *table,
55cced4f813bec Brian Vazquez    2020-06-23  613  						struct flowi6 *fl6,
55cced4f813bec Brian Vazquez    2020-06-23  614  						const struct sk_buff *skb,
55cced4f813bec Brian Vazquez    2020-06-23  615  						int flags)
55cced4f813bec Brian Vazquez    2020-06-23  616  {
55cced4f813bec Brian Vazquez    2020-06-23  617  	return INDIRECT_CALL_4(lookup,
55cced4f813bec Brian Vazquez    2020-06-23  618  			       ip6_pol_route_output,
55cced4f813bec Brian Vazquez    2020-06-23  619  			       ip6_pol_route_input,
55cced4f813bec Brian Vazquez    2020-06-23  620  			       ip6_pol_route_lookup,
55cced4f813bec Brian Vazquez    2020-06-23  621  			       __ip6_route_redirect,
55cced4f813bec Brian Vazquez    2020-06-23  622  			       net, table, fl6, skb, flags);
55cced4f813bec Brian Vazquez    2020-06-23  623  }
55cced4f813bec Brian Vazquez    2020-06-23  624  
7e5449c21562f1 Daniel Lezcano   2007-12-08  625  #ifdef CONFIG_IPV6_MULTIPLE_TABLES
1f8ac5703037fd Paolo Abeni      2019-11-20  626  static inline bool fib6_has_custom_rules(const struct net *net)
1f8ac5703037fd Paolo Abeni      2019-11-20  627  {
1f8ac5703037fd Paolo Abeni      2019-11-20  628  	return net->ipv6.fib6_has_custom_rules;
1f8ac5703037fd Paolo Abeni      2019-11-20  629  }
1f8ac5703037fd Paolo Abeni      2019-11-20  630  
5c3a0fd7d0fc29 Joe Perches      2013-09-21  631  int fib6_rules_init(void);
5c3a0fd7d0fc29 Joe Perches      2013-09-21  632  void fib6_rules_cleanup(void);
e3ea973159d535 Ido Schimmel     2017-08-03  633  bool fib6_rule_default(const struct fib_rule *rule);
b7a595577ef3dc Jiri Pirko       2019-10-03  634  int fib6_rules_dump(struct net *net, struct notifier_block *nb,
b7a595577ef3dc Jiri Pirko       2019-10-03  635  		    struct netlink_ext_ack *extack);
e60ea45447768c Eric Dumazet     2024-10-09  636  unsigned int fib6_rules_seq_read(const struct net *net);
5e5d6fed374155 Roopa Prabhu     2018-02-28  637  
5e5d6fed374155 Roopa Prabhu     2018-02-28  638  static inline bool fib6_rules_early_flow_dissect(struct net *net,
5e5d6fed374155 Roopa Prabhu     2018-02-28  639  						 struct sk_buff *skb,
5e5d6fed374155 Roopa Prabhu     2018-02-28  640  						 struct flowi6 *fl6,
5e5d6fed374155 Roopa Prabhu     2018-02-28  641  						 struct flow_keys *flkeys)
5e5d6fed374155 Roopa Prabhu     2018-02-28  642  {
5e5d6fed374155 Roopa Prabhu     2018-02-28  643  	unsigned int flag = FLOW_DISSECTOR_F_STOP_AT_ENCAP;
5e5d6fed374155 Roopa Prabhu     2018-02-28  644  
5e5d6fed374155 Roopa Prabhu     2018-02-28  645  	if (!net->ipv6.fib6_rules_require_fldissect)
5e5d6fed374155 Roopa Prabhu     2018-02-28  646  		return false;
5e5d6fed374155 Roopa Prabhu     2018-02-28  647  
8aae7625ff3f0b Florian Westphal 2023-08-30  648  	memset(flkeys, 0, sizeof(*flkeys));
8aae7625ff3f0b Florian Westphal 2023-08-30  649  	__skb_flow_dissect(net, skb, &flow_keys_dissector,
8aae7625ff3f0b Florian Westphal 2023-08-30  650  			   flkeys, NULL, 0, 0, 0, flag);
8aae7625ff3f0b Florian Westphal 2023-08-30  651  
5e5d6fed374155 Roopa Prabhu     2018-02-28  652  	fl6->fl6_sport = flkeys->ports.src;
5e5d6fed374155 Roopa Prabhu     2018-02-28  653  	fl6->fl6_dport = flkeys->ports.dst;
5e5d6fed374155 Roopa Prabhu     2018-02-28  654  	fl6->flowi6_proto = flkeys->basic.ip_proto;
5e5d6fed374155 Roopa Prabhu     2018-02-28  655  
5e5d6fed374155 Roopa Prabhu     2018-02-28  656  	return true;
5e5d6fed374155 Roopa Prabhu     2018-02-28  657  }
7e5449c21562f1 Daniel Lezcano   2007-12-08  658  #else
1f8ac5703037fd Paolo Abeni      2019-11-20 @659  static inline bool fib6_has_custom_rules(const struct net *net)
1f8ac5703037fd Paolo Abeni      2019-11-20  660  {
1f8ac5703037fd Paolo Abeni      2019-11-20  661  	return false;
1f8ac5703037fd Paolo Abeni      2019-11-20  662  }
7e5449c21562f1 Daniel Lezcano   2007-12-08 @663  static inline int               fib6_rules_init(void)
7e5449c21562f1 Daniel Lezcano   2007-12-08  664  {
7e5449c21562f1 Daniel Lezcano   2007-12-08  665  	return 0;
7e5449c21562f1 Daniel Lezcano   2007-12-08  666  }
7e5449c21562f1 Daniel Lezcano   2007-12-08 @667  static inline void              fib6_rules_cleanup(void)
7e5449c21562f1 Daniel Lezcano   2007-12-08  668  {
7e5449c21562f1 Daniel Lezcano   2007-12-08  669  	return ;
7e5449c21562f1 Daniel Lezcano   2007-12-08  670  }
e3ea973159d535 Ido Schimmel     2017-08-03 @671  static inline bool fib6_rule_default(const struct fib_rule *rule)
e3ea973159d535 Ido Schimmel     2017-08-03  672  {
e3ea973159d535 Ido Schimmel     2017-08-03  673  	return true;
e3ea973159d535 Ido Schimmel     2017-08-03  674  }
b7a595577ef3dc Jiri Pirko       2019-10-03 @675  static inline int fib6_rules_dump(struct net *net, struct notifier_block *nb,
b7a595577ef3dc Jiri Pirko       2019-10-03  676  				  struct netlink_ext_ack *extack)
dcb18f762f6ac8 Ido Schimmel     2017-08-03  677  {
dcb18f762f6ac8 Ido Schimmel     2017-08-03  678  	return 0;
dcb18f762f6ac8 Ido Schimmel     2017-08-03  679  }
e60ea45447768c Eric Dumazet     2024-10-09 @680  static inline unsigned int fib6_rules_seq_read(const struct net *net)

:::::: The code at line 663 was first introduced by commit
:::::: 7e5449c21562f1554d2c355db1ec9d3e4f434288 [IPV6]: route6 remove ifdef for fib_rules

:::::: TO: Daniel Lezcano <dlezcano@fr.ibm.com>
:::::: CC: David S. Miller <davem@davemloft.net>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
