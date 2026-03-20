Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887DE344DB0
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 20:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774038642; cv=none; b=rxogFvsr+2UGIQsisw3XW4K01O/iFR6cXt+bAn1X1GlJ0PNRDXvEBsf0mpVb8ksgBUvppKANQLAx9arfZOUchupALKY7MqYcLAYbJ5a1ylMK5qdwcOIBi0Dbf35sW4fuj88Hb6Yb2AokmxN8ImMapahwEJfxhQy09CQb6odyVsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774038642; c=relaxed/simple;
	bh=K/x1A9CIWuk7LBGjjj4O8XkJDL4M8s5D9zg7EYPMU+o=;
	h=Date:From:To:Cc:Subject:Message-ID; b=EDifEAk55W09hYqWFv1wLMy7MusjZYy699CkwXTRgg+ijgkbgpjyP5MzYysQw/3grUWHeeIB9OkJ5jMwEUuSrTFo4h7XAbRITdX0hqtkkQGWS7ySKz5TAnPi1jU0IRv8lo4yPB8nmxbBmBkAQC1x/nOpfKnDcYSalhdCoaxv5T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kenL9eO7; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kenL9eO7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774038640; x=1805574640;
  h=date:from:to:cc:subject:message-id;
  bh=K/x1A9CIWuk7LBGjjj4O8XkJDL4M8s5D9zg7EYPMU+o=;
  b=kenL9eO72/0zpWHVekFoLuDeHH+CUBXvuV6trxxV0bSLE/gAAIJphpoJ
   BZrT1wXh8JOq+OEVsdNewaKKklJ/5FYhl59r/JGgoxnWXrAcGha9CiYIP
   9hn3/gAsPesUOYu+yZx/MIUdp3KfZ0Tcly0/mTWU/oMSgexEb9e6Saldk
   Be6HXFkRmG9bkht2aSr3WJsN9hh8U0/egQG/2zmxJr1eF8Mzb7D6eIO2T
   aRrgdzi6tJxeu7EnEps/IQHLA4dTpIvVUW5l3yrHEMv/aEl/uGIXl/X16
   F1qLsvuk74Vc4a2XdVxpHyo1uvgYq8gLlyGzlK/14Zdncp2xABX2CaTnN
   g==;
X-CSE-ConnectionGUID: Q9rIMBc+TbCwQUjoh/Tewg==
X-CSE-MsgGUID: ivbkUGY9R9Gxrxd2IE+YJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="85758451"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="85758451"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 13:30:39 -0700
X-CSE-ConnectionGUID: RnmfSTxGS16+wLbdsRMs6A==
X-CSE-MsgGUID: EQI2n7ANSfSuOpw7lFZwqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="222478666"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 20 Mar 2026 13:30:37 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3gUM-0000000056t-1M6L;
	Fri, 20 Mar 2026 20:30:34 +0000
Date: Fri, 20 Mar 2026 21:30:04 +0100
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [netfilter-nf:testing 7/9]
 ./arch/arm64/include/asm/syscall.h:14:27: warning: unused variable
 'sys_call_table'
Message-ID: <202603202110.Tkuhxfco-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git testing
head:   b1bad43d8b00ab31c8f93145a4c8db1567f0d2fe
commit: 20d564bba6b3806c26498061299a88330561efa5 [7/9] netfilter: ctnetlink: ensure safe access to master conntrack
config: arm64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260320/202603202110.Tkuhxfco-lkp@intel.com/config)
compiler: aarch64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260320/202603202110.Tkuhxfco-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603202110.Tkuhxfco-lkp@intel.com/

All warnings (new ones prefixed by >>):

     136 | void nf_conntrack_icmp_init_net(struct net *net);
         |                                 ~~~~~~~~~~~~^~~
   net/netfilter/nf_conntrack_proto.c:679:38: error: passing argument 1 of 'nf_conntrack_icmpv6_init_net' from incompatible pointer type [-Wincompatible-pointer-types]
     679 |         nf_conntrack_icmpv6_init_net(net);
         |                                      ^~~
         |                                      |
         |                                      struct net *
   ./include/net/netfilter/nf_conntrack_l4proto.h:137:47: note: expected 'struct net *' but argument is of type 'struct net *'
     137 | void nf_conntrack_icmpv6_init_net(struct net *net);
         |                                   ~~~~~~~~~~~~^~~
   net/netfilter/nf_conntrack_proto.c:682:36: error: passing argument 1 of 'nf_conntrack_sctp_init_net' from incompatible pointer type [-Wincompatible-pointer-types]
     682 |         nf_conntrack_sctp_init_net(net);
         |                                    ^~~
         |                                    |
         |                                    struct net *
   ./include/net/netfilter/nf_conntrack_l4proto.h:135:45: note: expected 'struct net *' but argument is of type 'struct net *'
     135 | void nf_conntrack_sctp_init_net(struct net *net);
         |                                 ~~~~~~~~~~~~^~~
   net/netfilter/nf_conntrack_proto.c: In function 'lockdep_nfct_expect_lock_not_held':
   net/netfilter/nf_conntrack_proto.c:696:1: error: expected declaration or statement at end of input
     696 | MODULE_DESCRIPTION("IPv4 and IPv6 connection tracking");
         | ^~~~~~~~~~~~~~~~~~
   ./include/net/netfilter/nf_conntrack_helper.h:164:21: warning: unused variable 'nf_ct_helper_hsize' [-Wunused-variable]
     164 | extern unsigned int nf_ct_helper_hsize;
         |                     ^~~~~~~~~~~~~~~~~~
   ./include/net/netfilter/nf_conntrack_helper.h:163:27: warning: unused variable 'nf_ct_helper_hash' [-Wunused-variable]
     163 | extern struct hlist_head *nf_ct_helper_hash;
         |                           ^~~~~~~~~~~~~~~~~
   ./include/linux/netfilter/x_tables.h:342:26: warning: unused variable 'xt_tee_enabled' [-Wunused-variable]
     342 | extern struct static_key xt_tee_enabled;
         |                          ^~~~~~~~~~~~~~
   ./include/net/tcp.h:2480:42: warning: unused variable 'tcp_request_sock_ipv6_ops' [-Wunused-variable]
    2480 | extern const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops;
         |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/tcp.h:2478:42: warning: unused variable 'tcp_request_sock_ipv4_ops' [-Wunused-variable]
    2478 | extern const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops;
         |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/tcp.h:2371:32: warning: unused variable 'tcp6_request_sock_ops' [-Wunused-variable]
    2371 | extern struct request_sock_ops tcp6_request_sock_ops;
         |                                ^~~~~~~~~~~~~~~~~~~~~
   ./include/net/tcp.h:2370:32: warning: unused variable 'tcp_request_sock_ops' [-Wunused-variable]
    2370 | extern struct request_sock_ops tcp_request_sock_ops;
         |                                ^~~~~~~~~~~~~~~~~~~~
   ./include/net/tcp.h:1358:34: warning: unused variable 'tcp_reno' [-Wunused-variable]
    1358 | extern struct tcp_congestion_ops tcp_reno;
         |                                  ^~~~~~~~
   ./include/net/tcp.h:1136:49: warning: unused variable 'ipv6_specific' [-Wunused-variable]
    1136 | extern const struct inet_connection_sock_af_ops ipv6_specific;
         |                                                 ^~~~~~~~~~~~~
   ./include/net/tcp.h:1108:49: warning: unused variable 'ipv4_specific' [-Wunused-variable]
    1108 | extern const struct inet_connection_sock_af_ops ipv4_specific;
         |                                                 ^~~~~~~~~~~~~
   ./include/net/tcp.h:344:21: warning: unused variable 'tcp_prot' [-Wunused-variable]
     344 | extern struct proto tcp_prot;
         |                     ^~~~~~~~
   ./include/net/tcp.h:297:30: warning: unused variable 'tcp_sockets_allocated' [-Wunused-variable]
     297 | extern struct percpu_counter tcp_sockets_allocated;
         |                              ^~~~~~~~~~~~~~~~~~~~~
   ./include/net/tcp.h:295:22: warning: unused variable 'tcp_memory_per_cpu_fw_alloc' [-Wunused-variable]
     295 | DECLARE_PER_CPU(int, tcp_memory_per_cpu_fw_alloc);
         |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/linux/percpu-defs.h:100:51: note: in definition of macro 'DECLARE_PER_CPU_SECTION'
     100 |         extern __PCPU_ATTRS(sec) __typeof__(type) name
         |                                                   ^~~~
   ./include/net/tcp.h:295:1: note: in expansion of macro 'DECLARE_PER_CPU'
     295 | DECLARE_PER_CPU(int, tcp_memory_per_cpu_fw_alloc);
         | ^~~~~~~~~~~~~~~
   ./include/net/tcp.h:289:13: warning: unused variable 'sysctl_tcp_mem' [-Wunused-variable]
     289 | extern long sysctl_tcp_mem[3];
         |             ^~~~~~~~~~~~~~
   ./include/net/tcp.h:288:12: warning: unused variable 'sysctl_tcp_max_orphans' [-Wunused-variable]
     288 | extern int sysctl_tcp_max_orphans;
         |            ^~~~~~~~~~~~~~~~~~~~~~
   ./include/net/tcp.h:68:22: warning: unused variable 'tcp_tw_isn' [-Wunused-variable]
      68 | DECLARE_PER_CPU(u32, tcp_tw_isn);
         |                      ^~~~~~~~~~
   ./include/linux/percpu-defs.h:100:51: note: in definition of macro 'DECLARE_PER_CPU_SECTION'
     100 |         extern __PCPU_ATTRS(sec) __typeof__(type) name
         |                                                   ^~~~
   ./include/net/tcp.h:68:1: note: in expansion of macro 'DECLARE_PER_CPU'
      68 | DECLARE_PER_CPU(u32, tcp_tw_isn);
         | ^~~~~~~~~~~~~~~
   ./include/net/tcp.h:53:29: warning: unused variable 'tcp_hashinfo' [-Wunused-variable]
      53 | extern struct inet_hashinfo tcp_hashinfo;
         |                             ^~~~~~~~~~~~
   ./include/net/xfrm.h:2242:32: warning: unused variable 'xfrma_policy' [-Wunused-variable]
    2242 | extern const struct nla_policy xfrma_policy[XFRMA_MAX+1];
         |                                ^~~~~~~~~~~~
   ./include/net/xfrm.h:2241:18: warning: unused variable 'xfrm_msg_min' [-Wunused-variable]
    2241 | extern const int xfrm_msg_min[XFRM_NR_MSGTYPES];
         |                  ^~~~~~~~~~~~
   ./include/net/ip6_fib.h:556:36: warning: unused variable 'ipv6_route_seq_ops' [-Wunused-variable]
     556 | extern const struct seq_operations ipv6_route_seq_ops;
         |                                    ^~~~~~~~~~~~~~~~~~
   ./include/linux/audit.h:593:12: warning: unused variable 'audit_signals' [-Wunused-variable]
     593 | extern int audit_signals;
         |            ^~~~~~~~~~~~~
   ./include/linux/audit.h:592:12: warning: unused variable 'audit_n_rules' [-Wunused-variable]
     592 | extern int audit_n_rules;
         |            ^~~~~~~~~~~~~
>> ./arch/arm64/include/asm/syscall.h:14:27: warning: unused variable 'sys_call_table' [-Wunused-variable]
      14 | extern const syscall_fn_t sys_call_table[];
         |                           ^~~~~~~~~~~~~~
   In file included from ./include/linux/audit.h:14:
   ./include/linux/audit_arch.h:31:17: warning: unused variable 'compat_signal_class' [-Wunused-variable]
      31 | extern unsigned compat_signal_class[];
         |                 ^~~~~~~~~~~~~~~~~~~
   ./include/linux/audit_arch.h:30:17: warning: unused variable 'compat_chattr_class' [-Wunused-variable]
      30 | extern unsigned compat_chattr_class[];
         |                 ^~~~~~~~~~~~~~~~~~~
   ./include/linux/audit_arch.h:29:17: warning: unused variable 'compat_dir_class' [-Wunused-variable]
      29 | extern unsigned compat_dir_class[];
         |                 ^~~~~~~~~~~~~~~~
   ./include/linux/audit_arch.h:28:17: warning: unused variable 'compat_read_class' [-Wunused-variable]
      28 | extern unsigned compat_read_class[];
         |                 ^~~~~~~~~~~~~~~~~
   ./include/linux/audit_arch.h:27:17: warning: unused variable 'compat_write_class' [-Wunused-variable]
      27 | extern unsigned compat_write_class[];
         |                 ^~~~~~~~~~~~~~~~~~
   ./include/net/inet_ecn.h:21:12: warning: unused variable 'sysctl_tunnel_ecn_log' [-Wunused-variable]
      21 | extern int sysctl_tunnel_ecn_log;
         |            ^~~~~~~~~~~~~~~~~~~~~
   ./include/net/sock_reuseport.h:11:19: warning: unused variable 'reuseport_lock' [-Wunused-variable]
      11 | extern spinlock_t reuseport_lock;
         |                   ^~~~~~~~~~~~~~
   ./include/linux/filter.h:1610:32: warning: unused variable 'bpf_sk_lookup_enabled' [-Wunused-variable]
    1610 | extern struct static_key_false bpf_sk_lookup_enabled;
         |                                ^~~~~~~~~~~~~~~~~~~~~
   ./include/linux/filter.h:1266:13: warning: unused variable 'bpf_jit_limit_max' [-Wunused-variable]
    1266 | extern long bpf_jit_limit_max;
         |             ^~~~~~~~~~~~~~~~~
   ./include/linux/filter.h:1265:13: warning: unused variable 'bpf_jit_limit' [-Wunused-variable]
    1265 | extern long bpf_jit_limit;
         |             ^~~~~~~~~~~~~
   In file included from ./include/linux/static_key.h:1,
                    from ./include/linux/kasan-enabled.h:5,
                    from ./arch/arm64/include/asm/cache.h:41,
                    from ./include/vdso/cache.h:5,
                    from ./include/linux/cache.h:6,
                    from ./include/linux/time.h:5:
   ./include/linux/filter.h:1014:26: warning: unused variable 'bpf_master_redirect_enabled_key' [-Wunused-variable]
    1014 | DECLARE_STATIC_KEY_FALSE(bpf_master_redirect_enabled_key);
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/linux/jump_label.h:392:40: note: in definition of macro 'DECLARE_STATIC_KEY_FALSE'
     392 |         extern struct static_key_false name
         |                                        ^~~~
   In file included from ./include/linux/security.h:35:
   ./include/linux/bpf.h:1528:38: warning: unused variable 'bpf_dispatcher_xdp' [-Wunused-variable]
    1528 |         extern struct bpf_dispatcher bpf_dispatcher_##name;
         |                                      ^~~~~~~~~~~~~~~
   ./include/linux/filter.h:1012:1: note: in expansion of macro 'DECLARE_BPF_DISPATCHER'
    1012 | DECLARE_BPF_DISPATCHER(xdp)
         | ^~~~~~~~~~~~~~~~~~~~~~
   ./include/linux/filter.h:691:14: warning: unused variable 'nfct_btf_struct_access' [-Wunused-variable]
     691 | extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log,
         |              ^~~~~~~~~~~~~~~~~~~~~~
   ./include/linux/filter.h:690:21: warning: unused variable 'nf_conn_btf_access_lock' [-Wunused-variable]
     690 | extern struct mutex nf_conn_btf_access_lock;
         |                     ^~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/sch_generic.h:618:25: warning: unused variable 'noqueue_qdisc_ops' [-Wunused-variable]
     618 | extern struct Qdisc_ops noqueue_qdisc_ops;
         |                         ^~~~~~~~~~~~~~~~~
   ./include/net/sch_generic.h:617:25: warning: unused variable 'mq_qdisc_ops' [-Wunused-variable]
     617 | extern struct Qdisc_ops mq_qdisc_ops;
         |                         ^~~~~~~~~~~~
   ./include/net/sch_generic.h:616:17: warning: unused variable 'sch_default_prio2band' [-Wunused-variable]
     616 | extern const u8 sch_default_prio2band[TC_PRIO_MAX + 1];
         |                 ^~~~~~~~~~~~~~~~~~~~~
   ./include/net/sch_generic.h:614:25: warning: unused variable 'noop_qdisc_ops' [-Wunused-variable]
     614 | extern struct Qdisc_ops noop_qdisc_ops;
         |                         ^~~~~~~~~~~~~~
   ./include/crypto/sha1.h:21:17: warning: unused variable 'sha1_zero_message_hash' [-Wunused-variable]
      21 | extern const u8 sha1_zero_message_hash[SHA1_DIGEST_SIZE];
         |                 ^~~~~~~~~~~~~~~~~~~~~~
   ./include/linux/etherdevice.h:41:32: warning: unused variable 'eth_header_ops' [-Wunused-variable]
      41 | extern const struct header_ops eth_header_ops;
         |                                ^~~~~~~~~~~~~~
   ./include/net/ip.h:803:26: warning: unused variable 'ip4_min_ttl' [-Wunused-variable]
     803 | DECLARE_STATIC_KEY_FALSE(ip4_min_ttl);
         |                          ^~~~~~~~~~~
   ./include/linux/jump_label.h:392:40: note: in definition of macro 'DECLARE_STATIC_KEY_FALSE'
     392 |         extern struct static_key_false name
         |                                        ^~~~
   ./include/net/ip.h:397:12: warning: unused variable 'inet_peer_maxttl' [-Wunused-variable]
     397 | extern int inet_peer_maxttl;
         |            ^~~~~~~~~~~~~~~~
   ./include/net/ip.h:396:12: warning: unused variable 'inet_peer_minttl' [-Wunused-variable]
     396 | extern int inet_peer_minttl;
         |            ^~~~~~~~~~~~~~~~
   ./include/net/ip.h:395:12: warning: unused variable 'inet_peer_threshold' [-Wunused-variable]
     395 | extern int inet_peer_threshold;
         |            ^~~~~~~~~~~~~~~~~~~
   ./include/net/ip.h:43:21: warning: unused variable 'sysctl_fib_sync_mem_max' [-Wunused-variable]
      43 | extern unsigned int sysctl_fib_sync_mem_max;
         |                     ^~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/ip.h:42:21: warning: unused variable 'sysctl_fib_sync_mem_min' [-Wunused-variable]
      42 | extern unsigned int sysctl_fib_sync_mem_min;
         |                     ^~~~~~~~~~~~~~~~~~~~~~~
   ./include/net/ip.h:41:21: warning: unused variable 'sysctl_fib_sync_mem' [-Wunused-variable]
      41 | extern unsigned int sysctl_fib_sync_mem;
         |                     ^~~~~~~~~~~~~~~~~~~


vim +/sys_call_table +14 ./arch/arm64/include/asm/syscall.h

27d83e68f307ee Mark Rutland 2018-07-11  13  
27d83e68f307ee Mark Rutland 2018-07-11 @14  extern const syscall_fn_t sys_call_table[];
f27bb139c38768 Marc Zyngier 2012-03-05  15  

:::::: The code at line 14 was first introduced by commit
:::::: 27d83e68f307ee55b70fdfdc7a9ba3f25f276189 arm64: introduce syscall_fn_t

:::::: TO: Mark Rutland <mark.rutland@arm.com>
:::::: CC: Will Deacon <will.deacon@arm.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
