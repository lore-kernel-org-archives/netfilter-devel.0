Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B09374172
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 06:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774076102; cv=none; b=kI8RZSX3uzwdfsghWw9Z06Sf/k7O4yP7y+UIM1emPYsfr5IYEcCumJ1MzwgydY1PIA96Z/p7BLLJzfGh1nWDzVxsF8KBb/wbR21Vw4KkNtxNIUq1hXUqxHbfv1FuSzSjEhF5knJqj1aEVtK95al9mR0R/ORONIXLKVax2HYIlsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774076102; c=relaxed/simple;
	bh=TiEmvvU0MAm2qA2mMAYEH9ODxmid+XwudzbqLiVXzUw=;
	h=Date:From:To:Cc:Subject:Message-ID; b=A5sVTctAd027I4ejIELTNnatl25oMHGSEYnmkgR2mcvFWMcuYDH0DAWxv/2slJP3vnBD48R0JTryhfJte1NVmbqCPNVUc5uUKGSUE1jNf/gFErXYP2HS6Ly/qrNlxZ00zI2t9rwrRV0E6mfpNQC0Ftj6d/eUAWHGP2p3I4BGs/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PH1BFecs; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PH1BFecs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774076100; x=1805612100;
  h=date:from:to:cc:subject:message-id;
  bh=TiEmvvU0MAm2qA2mMAYEH9ODxmid+XwudzbqLiVXzUw=;
  b=PH1BFecsmwIAte1hxddjvdIraTzqYoRqz+UTSf1E1WgTRXH/JqUe2QO9
   SUzWkOZvhnPTv2TbXwuCvVWTVltS8Bn+uCkrN5QPvegMLVn7oKNCQ3mwS
   sidcWynppFdFKNevSFU2h+T2FIA+9HayM/9ijIRG8XiUQ+yGf080HCtPh
   urRonIm4g5JwGeH0KeetHzRheHngJD+OkUMWBuiSc5b9sUVx9wQwe+JFq
   e0M+yz6JhPG7tBxwvuH6lb1rE8Bdw078PhIWlwyUfu9q1VvWMavv9UtzN
   1F32qb65DSrvUvUUXl4VXbkAZDPIZsI7r0MfNVP0SMx0xGo5VG7c49kav
   g==;
X-CSE-ConnectionGUID: x35leoXEQCmyI9sTEHhfXA==
X-CSE-MsgGUID: eUPNHuz9RnmzfvgpvAXpJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="75352222"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="75352222"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 23:54:59 -0700
X-CSE-ConnectionGUID: ijMG5SLSQny5WBgyvT21YA==
X-CSE-MsgGUID: zfC+Ee32QwKT7+H6OYPS8w==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 20 Mar 2026 23:54:57 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3qEY-000000000PH-0wW9;
	Sat, 21 Mar 2026 06:54:54 +0000
Date: Sat, 21 Mar 2026 14:54:49 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [netfilter-nf:testing 7/9]
 arch/parisc/include/asm/pci.h:129:29: warning: unused variable 'pci_bios'
Message-ID: <202603211424.jYqP0M00-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git testing
head:   b1bad43d8b00ab31c8f93145a4c8db1567f0d2fe
commit: 20d564bba6b3806c26498061299a88330561efa5 [7/9] netfilter: ctnetlink: ensure safe access to master conntrack
config: parisc-allyesconfig (https://download.01.org/0day-ci/archive/20260321/202603211424.jYqP0M00-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603211424.jYqP0M00-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603211424.jYqP0M00-lkp@intel.com/

All warnings (new ones prefixed by >>):

   include/net/devlink.h:1871:36: warning: unused variable 'devlink_dpipe_header_ipv6' [-Wunused-variable]
    1871 | extern struct devlink_dpipe_header devlink_dpipe_header_ipv6;
         |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/devlink.h:1870:36: warning: unused variable 'devlink_dpipe_header_ipv4' [-Wunused-variable]
    1870 | extern struct devlink_dpipe_header devlink_dpipe_header_ipv4;
         |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/devlink.h:1869:36: warning: unused variable 'devlink_dpipe_header_ethernet' [-Wunused-variable]
    1869 | extern struct devlink_dpipe_header devlink_dpipe_header_ethernet;
         |                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/rdma/ib_verbs.h:141:21: warning: unused variable 'zgid' [-Wunused-variable]
     141 | extern union ib_gid zgid;
         |                     ^~~~
   include/rdma/ib_verbs.h:61:33: warning: unused variable 'ib_comp_unbound_wq' [-Wunused-variable]
      61 | extern struct workqueue_struct *ib_comp_unbound_wq;
         |                                 ^~~~~~~~~~~~~~~~~~
   include/rdma/ib_verbs.h:60:33: warning: unused variable 'ib_comp_wq' [-Wunused-variable]
      60 | extern struct workqueue_struct *ib_comp_wq;
         |                                 ^~~~~~~~~~
   include/rdma/ib_verbs.h:59:33: warning: unused variable 'ib_wq' [-Wunused-variable]
      59 | extern struct workqueue_struct *ib_wq;
         |                                 ^~~~~
   include/net/ip.h:803:26: warning: unused variable 'ip4_min_ttl' [-Wunused-variable]
     803 | DECLARE_STATIC_KEY_FALSE(ip4_min_ttl);
         |                          ^~~~~~~~~~~
   include/linux/jump_label.h:392:40: note: in definition of macro 'DECLARE_STATIC_KEY_FALSE'
     392 |         extern struct static_key_false name
         |                                        ^~~~
   include/net/ip.h:397:12: warning: unused variable 'inet_peer_maxttl' [-Wunused-variable]
     397 | extern int inet_peer_maxttl;
         |            ^~~~~~~~~~~~~~~~
   include/net/ip.h:396:12: warning: unused variable 'inet_peer_minttl' [-Wunused-variable]
     396 | extern int inet_peer_minttl;
         |            ^~~~~~~~~~~~~~~~
   include/net/ip.h:395:12: warning: unused variable 'inet_peer_threshold' [-Wunused-variable]
     395 | extern int inet_peer_threshold;
         |            ^~~~~~~~~~~~~~~~~~~
   include/net/ip.h:43:21: warning: unused variable 'sysctl_fib_sync_mem_max' [-Wunused-variable]
      43 | extern unsigned int sysctl_fib_sync_mem_max;
         |                     ^~~~~~~~~~~~~~~~~~~~~~~
   include/net/ip.h:42:21: warning: unused variable 'sysctl_fib_sync_mem_min' [-Wunused-variable]
      42 | extern unsigned int sysctl_fib_sync_mem_min;
         |                     ^~~~~~~~~~~~~~~~~~~~~~~
   include/net/ip.h:41:21: warning: unused variable 'sysctl_fib_sync_mem' [-Wunused-variable]
      41 | extern unsigned int sysctl_fib_sync_mem;
         |                     ^~~~~~~~~~~~~~~~~~~
   include/net/lwtunnel.h:58:26: warning: unused variable 'nf_hooks_lwtunnel_enabled' [-Wunused-variable]
      58 | DECLARE_STATIC_KEY_FALSE(nf_hooks_lwtunnel_enabled);
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/jump_label.h:392:40: note: in definition of macro 'DECLARE_STATIC_KEY_FALSE'
     392 |         extern struct static_key_false name
         |                                        ^~~~
   include/net/route.h:126:36: warning: unused variable 'ip_rt_acct' [-Wunused-variable]
     126 | extern struct ip_rt_acct __percpu *ip_rt_acct;
         |                                    ^~~~~~~~~~
   include/net/ipv6_stubs.h:100:36: warning: unused variable 'ipv6_bpf_stub' [-Wunused-variable]
     100 | extern const struct ipv6_bpf_stub *ipv6_bpf_stub __read_mostly;
         |                                    ^~~~~~~~~~~~~
   include/net/ip_fib.h:447:32: warning: unused variable 'rtm_ipv4_policy' [-Wunused-variable]
     447 | extern const struct nla_policy rtm_ipv4_policy[];
         |                                ^~~~~~~~~~~~~~~
   include/net/ipv6.h:1163:31: warning: unused variable 'inet6_sockraw_ops' [-Wunused-variable]
    1163 | extern const struct proto_ops inet6_sockraw_ops;
         |                               ^~~~~~~~~~~~~~~~~
   include/net/ipv6.h:1162:31: warning: unused variable 'inet6_dgram_ops' [-Wunused-variable]
    1162 | extern const struct proto_ops inet6_dgram_ops;
         |                               ^~~~~~~~~~~~~~~
   include/net/ipv6.h:1161:31: warning: unused variable 'inet6_stream_ops' [-Wunused-variable]
    1161 | extern const struct proto_ops inet6_stream_ops;
         |                               ^~~~~~~~~~~~~~~~
   include/net/ipv6.h:1113:26: warning: unused variable 'ip6_min_hopcount' [-Wunused-variable]
    1113 | DECLARE_STATIC_KEY_FALSE(ip6_min_hopcount);
         |                          ^~~~~~~~~~~~~~~~
   include/linux/jump_label.h:392:40: note: in definition of macro 'DECLARE_STATIC_KEY_FALSE'
     392 |         extern struct static_key_false name
         |                                        ^~~~
   include/net/ipv6.h:284:17: warning: unused variable 'ip6_ra_lock' [-Wunused-variable]
     284 | extern rwlock_t ip6_ra_lock;
         |                 ^~~~~~~~~~~
   include/net/ipv6.h:283:34: warning: unused variable 'ip6_ra_chain' [-Wunused-variable]
     283 | extern struct ip6_ra_chain      *ip6_ra_chain;
         |                                  ^~~~~~~~~~~~
   include/net/ipv6.h:205:12: warning: unused variable 'sysctl_mld_qrv' [-Wunused-variable]
     205 | extern int sysctl_mld_qrv;
         |            ^~~~~~~~~~~~~~
   include/net/ipv6.h:204:12: warning: unused variable 'sysctl_mld_max_msf' [-Wunused-variable]
     204 | extern int sysctl_mld_max_msf;
         |            ^~~~~~~~~~~~~~~~~~
   include/linux/ipv6.h:102:27: warning: unused variable 'ipv6_defaults' [-Wunused-variable]
     102 | extern struct ipv6_params ipv6_defaults;
         |                           ^~~~~~~~~~~~~
   include/linux/pci.h:2486:11: warning: unused variable 'pci_cache_line_size' [-Wunused-variable]
    2486 | extern u8 pci_cache_line_size;
         |           ^~~~~~~~~~~~~~~~~~~
   include/linux/pci.h:2485:11: warning: unused variable 'pci_dfl_cache_line_size' [-Wunused-variable]
    2485 | extern u8 pci_dfl_cache_line_size;
         |           ^~~~~~~~~~~~~~~~~~~~~~~
   include/linux/pci.h:2476:12: warning: unused variable 'pci_pci_problems' [-Wunused-variable]
    2476 | extern int pci_pci_problems;
         |            ^~~~~~~~~~~~~~~~
   In file included from include/linux/pci.h:2246:
>> arch/parisc/include/asm/pci.h:129:29: warning: unused variable 'pci_bios' [-Wunused-variable]
     129 | extern struct pci_bios_ops *pci_bios;
         |                             ^~~~~~~~
>> arch/parisc/include/asm/pci.h:128:29: warning: unused variable 'pci_port' [-Wunused-variable]
     128 | extern struct pci_port_ops *pci_port;
         |                             ^~~~~~~~
   include/linux/pci.h:1874:13: warning: unused variable 'pcie_ports_native' [-Wunused-variable]
    1874 | extern bool pcie_ports_native;
         |             ^~~~~~~~~~~~~~~~~
   include/linux/pci.h:1873:13: warning: unused variable 'pcie_ports_disabled' [-Wunused-variable]
    1873 | extern bool pcie_ports_disabled;
         |             ^~~~~~~~~~~~~~~~~~~
   include/linux/pci.h:1436:21: warning: unused variable 'pcibios_max_latency' [-Wunused-variable]
    1436 | extern unsigned int pcibios_max_latency;
         |                     ^~~~~~~~~~~~~~~~~~~
   include/linux/pci.h:1195:25: warning: unused variable 'pci_root_buses' [-Wunused-variable]
    1195 | extern struct list_head pci_root_buses; /* List of all known PCI buses */
         |                         ^~~~~~~~~~~~~~
   include/linux/pci.h:1191:30: warning: unused variable 'pci_bus_type' [-Wunused-variable]
    1191 | extern const struct bus_type pci_bus_type;
         |                              ^~~~~~~~~~~~
   include/linux/pci.h:1189:35: warning: unused variable 'pcie_bus_config' [-Wunused-variable]
    1189 | extern enum pcie_bus_config_types pcie_bus_config;
         |                                   ^~~~~~~~~~~~~~~
   include/linux/debugfs.h:46:23: warning: unused variable 'arch_debugfs_dir' [-Wunused-variable]
      46 | extern struct dentry *arch_debugfs_dir;
         |                       ^~~~~~~~~~~~~~~~
   include/net/sock.h:3054:26: warning: unused variable 'net_high_order_alloc_disable_key' [-Wunused-variable]
    3054 | DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/jump_label.h:392:40: note: in definition of macro 'DECLARE_STATIC_KEY_FALSE'
     392 |         extern struct static_key_false name
         |                                        ^~~~
   include/net/sock.h:3051:14: warning: unused variable 'sysctl_rmem_default' [-Wunused-variable]
    3051 | extern __u32 sysctl_rmem_default;
         |              ^~~~~~~~~~~~~~~~~~~
   include/net/sock.h:3050:14: warning: unused variable 'sysctl_wmem_default' [-Wunused-variable]
    3050 | extern __u32 sysctl_wmem_default;
         |              ^~~~~~~~~~~~~~~~~~~
   include/net/sock.h:3048:14: warning: unused variable 'sysctl_rmem_max' [-Wunused-variable]
    3048 | extern __u32 sysctl_rmem_max;
         |              ^~~~~~~~~~~~~~~
   include/net/sock.h:3047:14: warning: unused variable 'sysctl_wmem_max' [-Wunused-variable]
    3047 | extern __u32 sysctl_wmem_max;
         |              ^~~~~~~~~~~~~~~
   include/net/neighbour.h:281:32: warning: unused variable 'nda_policy' [-Wunused-variable]
     281 | extern const struct nla_policy nda_policy[];
         |                                ^~~~~~~~~~
   In file included from include/net/netfilter/nf_nat.h:7:
   include/linux/netfilter/nf_conntrack_pptp.h:320:45: warning: unused variable 'nf_nat_pptp_hook' [-Wunused-variable]
     320 | extern const struct nf_nat_pptp_hook __rcu *nf_nat_pptp_hook;
         |                                             ^~~~~~~~~~~~~~~~
   include/net/act_api.h:273:26: warning: unused variable 'tcf_frag_xmit_count' [-Wunused-variable]
     273 | DECLARE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
         |                          ^~~~~~~~~~~~~~~~~~~
   include/linux/jump_label.h:392:40: note: in definition of macro 'DECLARE_STATIC_KEY_FALSE'
     392 |         extern struct static_key_false name
         |                                        ^~~~
   include/net/pkt_sched.h:126:32: warning: unused variable 'rtm_tca_policy' [-Wunused-variable]
     126 | extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
         |                                ^~~~~~~~~~~~~~
   include/net/pkt_sched.h:88:25: warning: unused variable 'pfifo_head_drop_qdisc_ops' [-Wunused-variable]
      88 | extern struct Qdisc_ops pfifo_head_drop_qdisc_ops;
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/net/pkt_sched.h:87:25: warning: unused variable 'bfifo_qdisc_ops' [-Wunused-variable]
      87 | extern struct Qdisc_ops bfifo_qdisc_ops;
         |                         ^~~~~~~~~~~~~~~
   include/net/pkt_sched.h:86:25: warning: unused variable 'pfifo_qdisc_ops' [-Wunused-variable]
      86 | extern struct Qdisc_ops pfifo_qdisc_ops;
         |                         ^~~~~~~~~~~~~~~
   include/linux/etherdevice.h:41:32: warning: unused variable 'eth_header_ops' [-Wunused-variable]
      41 | extern const struct header_ops eth_header_ops;
         |                                ^~~~~~~~~~~~~~
   include/net/sch_generic.h:617:25: warning: unused variable 'mq_qdisc_ops' [-Wunused-variable]
     617 | extern struct Qdisc_ops mq_qdisc_ops;
         |                         ^~~~~~~~~~~~
   include/net/sch_generic.h:616:17: warning: unused variable 'sch_default_prio2band' [-Wunused-variable]
     616 | extern const u8 sch_default_prio2band[TC_PRIO_MAX + 1];
         |                 ^~~~~~~~~~~~~~~~~~~~~
   include/net/sch_generic.h:614:25: warning: unused variable 'noop_qdisc_ops' [-Wunused-variable]
     614 | extern struct Qdisc_ops noop_qdisc_ops;
         |                         ^~~~~~~~~~~~~~
   include/linux/rtnetlink.h:53:28: warning: unused variable 'net_rwsem' [-Wunused-variable]
      53 | extern struct rw_semaphore net_rwsem;
         |                            ^~~~~~~~~
   include/linux/rtnetlink.h:52:28: warning: unused variable 'pernet_ops_rwsem' [-Wunused-variable]
      52 | extern struct rw_semaphore pernet_ops_rwsem;
         |                            ^~~~~~~~~~~~~~~~
   include/linux/rtnetlink.h:51:17: warning: unused variable 'dev_unreg_count' [-Wunused-variable]
      51 | extern atomic_t dev_unreg_count;
         |                 ^~~~~~~~~~~~~~~
   include/linux/rtnetlink.h:50:26: warning: unused variable 'netdev_unregistering_wq' [-Wunused-variable]
      50 | extern wait_queue_head_t netdev_unregistering_wq;
         |                          ^~~~~~~~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_helper.h:164:21: warning: unused variable 'nf_ct_helper_hsize' [-Wunused-variable]
     164 | extern unsigned int nf_ct_helper_hsize;
         |                     ^~~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_helper.h:163:27: warning: unused variable 'nf_ct_helper_hash' [-Wunused-variable]
     163 | extern struct hlist_head *nf_ct_helper_hash;
         |                           ^~~~~~~~~~~~~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c: At top level:
   drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c:2489:6: warning: 'mlx5e_tc_ct_is_valid_flow_rule' defined but not used [-Wunused-function]
    2489 | bool mlx5e_tc_ct_is_valid_flow_rule(const struct net_device *dev, struct flow_rule *flow_rule)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/pci_bios +129 arch/parisc/include/asm/pci.h

^1da177e4c3f415 include/asm-parisc/pci.h Linus Torvalds 2005-04-16  124  
^1da177e4c3f415 include/asm-parisc/pci.h Linus Torvalds 2005-04-16  125  /*
^1da177e4c3f415 include/asm-parisc/pci.h Linus Torvalds 2005-04-16  126  ** Stuff declared in arch/parisc/kernel/pci.c
^1da177e4c3f415 include/asm-parisc/pci.h Linus Torvalds 2005-04-16  127  */
^1da177e4c3f415 include/asm-parisc/pci.h Linus Torvalds 2005-04-16 @128  extern struct pci_port_ops *pci_port;
^1da177e4c3f415 include/asm-parisc/pci.h Linus Torvalds 2005-04-16 @129  extern struct pci_bios_ops *pci_bios;
^1da177e4c3f415 include/asm-parisc/pci.h Linus Torvalds 2005-04-16  130  

:::::: The code at line 129 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
