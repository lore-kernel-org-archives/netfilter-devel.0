Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE00230B51F
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 20:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774038640; cv=none; b=JRQq9mgszPexCi2W2CcQ0Oee2Urm+QGnid68rhDymQtv+qQ++HW25xT72udp5uUi5fk3NxQ+XauMJPWq1G33qsSkp9lOMepuNNaTb2SzCh7on0idqSQhn/MHTgUlEqVPyoC0ChoJr4tQOwcK0nAaJcvOfZ6sw9e8XX+k7hJoKwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774038640; c=relaxed/simple;
	bh=EbAhMe30/Ca+EXOXk7BRxayd11V8Yn1m+5rHs7nJRkY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=ZA9rwX/rbNjo3pqBhLpbTOWT9+C9lRl3tsX7IjenVClX7tQ/NIMQb5YDxdppC9jcXVmaMvRjBBf3G8zN/uU0HvrMhX9OEK+1zu/RabYXgD2s83eGVbOzKTFf80Mmsl5MjkTuQV0hZoR29cCpIFJrEotehBRQ9nMjFoBObTINle0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bMPyBIXg; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bMPyBIXg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774038639; x=1805574639;
  h=date:from:to:cc:subject:message-id;
  bh=EbAhMe30/Ca+EXOXk7BRxayd11V8Yn1m+5rHs7nJRkY=;
  b=bMPyBIXgNpgNrDKAb544d0oe9lzERRm8gqwq7KowrCXIzmdvl1HFQPuI
   2ejDa/IBqc9ohtPlz4LSit8yBBxeAhXYQdTWRfKqszU2Rsh6cyFPoR0Ym
   eCjzUF+KrzVAwxa/J71SGk01Cz0bg6wufNDUgTCjqK9mp6Z0GYU+Cn21m
   I9sCFfMSpaE5V1C+1jLLb2GWwNZacj8PugWqDXNUpByiG1lKWORTU2ltp
   DVBKLOSLlbAEysQ9SVS49U5fLX5dWzoNnxGFDXHLjv7z1CksGplR6JUKK
   iNkVIm7TxTOm50hQdKeJM7M5mlpknmVBgjY2UlY3ve9Y9JFSqU3vrUJlh
   g==;
X-CSE-ConnectionGUID: A7a6WRWDRXOQ/Lqmf6Iqpw==
X-CSE-MsgGUID: DkO26057RH+ikGH4vDXUTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="75022441"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="75022441"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 13:30:39 -0700
X-CSE-ConnectionGUID: ayoQEIYbTjqerOihRWYWdQ==
X-CSE-MsgGUID: hGCxaikCTVSxcgJXUqck4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="219150077"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 20 Mar 2026 13:30:36 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3gUM-0000000056r-19d9;
	Fri, 20 Mar 2026 20:30:34 +0000
Date: Fri, 20 Mar 2026 21:30:03 +0100
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [netfilter-nf:testing 7/9]
 ./arch/powerpc/include/asm/syscall.h:26:25: warning: unused variable
 'compat_sys_call_table'
Message-ID: <202603202156.EVAKEnwj-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git testing
head:   b1bad43d8b00ab31c8f93145a4c8db1567f0d2fe
commit: 20d564bba6b3806c26498061299a88330561efa5 [7/9] netfilter: ctnetlink: ensure safe access to master conntrack
config: powerpc64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260320/202603202156.EVAKEnwj-lkp@intel.com/config)
compiler: powerpc64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260320/202603202156.EVAKEnwj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603202156.EVAKEnwj-lkp@intel.com/

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
>> ./arch/powerpc/include/asm/syscall.h:26:25: warning: unused variable 'compat_sys_call_table' [-Wunused-variable]
      26 | extern const syscall_fn compat_sys_call_table[];
         |                         ^~~~~~~~~~~~~~~~~~~~~
>> ./arch/powerpc/include/asm/syscall.h:25:25: warning: unused variable 'sys_call_table' [-Wunused-variable]
      25 | extern const syscall_fn sys_call_table[];
         |                         ^~~~~~~~~~~~~~
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
   In file included from ./arch/powerpc/include/asm/mmu.h:230,
                    from ./arch/powerpc/include/asm/paca.h:18,
                    from ./arch/powerpc/include/asm/current.h:13,
                    from ./include/linux/thread_info.h:23,
                    from ./include/asm-generic/preempt.h:5,
                    from ./arch/powerpc/include/asm/preempt.h:5,
                    from ./include/linux/preempt.h:79,
                    from ./include/linux/spinlock.h:56:
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


vim +/compat_sys_call_table +26 ./arch/powerpc/include/asm/syscall.h

8640de0dee49ce Rohan McLure 2022-09-21  23  
02424d8966d803 Ian Munsie   2011-02-02  24  /* ftrace syscalls requires exporting the sys_call_table */
8640de0dee49ce Rohan McLure 2022-09-21 @25  extern const syscall_fn sys_call_table[];
8640de0dee49ce Rohan McLure 2022-09-21 @26  extern const syscall_fn compat_sys_call_table[];
02424d8966d803 Ian Munsie   2011-02-02  27  

:::::: The code at line 26 was first introduced by commit
:::::: 8640de0dee49cec50040d9845a2bc96fd15adc9e powerpc: Use common syscall handler type

:::::: TO: Rohan McLure <rmclure@linux.ibm.com>
:::::: CC: Michael Ellerman <mpe@ellerman.id.au>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
