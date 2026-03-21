Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01453221F1C
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 07:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774078121; cv=none; b=TD+NrfZKYMFximotwW0d250QY+90Hn+r00QJQuSd+5VQHjgL8HoR36R0ZlRwyRMyXSywZ96zW5uq2wjb/Er9wx+bkc1F3VHw2tM+E+1EekrAoOZsHKTTnGct+sWVmizibu2Fdx/onAk03NLk5Bt+gB52/rQRPDw7ZKZ9hCZ53hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774078121; c=relaxed/simple;
	bh=jN8+sbTgPzWN0Uh56qdNa/p6mzJ107yGOJt1/wpgst0=;
	h=Date:From:To:Cc:Subject:Message-ID; b=pMgqv3E9YxN1Y3gcqIObwXxrTk/c5PCIFbo+wJ9G2r/QP03iZI6QB4PGf0bhFth7V+QZ4KDj6JC85j/n51LxxPSBUSpoY+u7lpCX0vko6sZbnaGew5rbxvh1zo/6Z7HiZnCr7zSzdHJEKz7mG3QYRFjZybekZlKH6Tae6OykvWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AifZvaXZ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AifZvaXZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774078119; x=1805614119;
  h=date:from:to:cc:subject:message-id;
  bh=jN8+sbTgPzWN0Uh56qdNa/p6mzJ107yGOJt1/wpgst0=;
  b=AifZvaXZ1jpBOpIkHetfnJfXRR3mtASVIhoHpV3JNnLusst7rJoJ46lV
   XxEgy4dB6K2dWUg5sqVjqBQeimkoMLgmlcgviSX3vmms5mdjKdqr6aewj
   4akcwloh5UvaCDq1c1c51RD+SmepAeNvYtQvq7f/ljjPc76PxAsmzJCO7
   643vytGpx1h1NmGBTfCkts/j840x3T32fs4iMcnpwk43egtJdUBycNrOB
   xLZMlseApA5cH+X1t7le+G3qhNo8r03CzNqQujjzAlqv8LYZ6jdIkHiw0
   CQS437ktl+WjhA2NZl4dCetxh/XLJ6sKICTaRy6UHUMew/JQr0Blm/v6E
   A==;
X-CSE-ConnectionGUID: mGdLrkaWRaeTBEsyhphTTg==
X-CSE-MsgGUID: MI0mg9y2Tdq3BtTR83V0iQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="75184941"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="75184941"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2026 00:28:38 -0700
X-CSE-ConnectionGUID: 1Z1CyaFSSFycwcaMI5I9Hg==
X-CSE-MsgGUID: 3QH7w2zXQGGB/b06UHX52w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="220370628"
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 21 Mar 2026 00:28:35 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3qky-000000000Qv-2dBa;
	Sat, 21 Mar 2026 07:28:28 +0000
Date: Sat, 21 Mar 2026 15:27:51 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [netfilter-nf:testing 7/9]
 arch/mips/include/asm/kexec.h:47:15: warning: unused variable
 '_crash_smp_send_stop'
Message-ID: <202603211508.hPFgpNxL-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git testing
head:   b1bad43d8b00ab31c8f93145a4c8db1567f0d2fe
commit: 20d564bba6b3806c26498061299a88330561efa5 [7/9] netfilter: ctnetlink: ensure safe access to master conntrack
config: mips-allyesconfig (https://download.01.org/0day-ci/archive/20260321/202603211508.hPFgpNxL-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603211508.hPFgpNxL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603211508.hPFgpNxL-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/mellanox/mlx5/core/en_stats.h:522:8: note: in expansion of macro 'MLX5E_DECLARE_STATS_GRP'
     522 | extern MLX5E_DECLARE_STATS_GRP(qcnt);
         |        ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en_stats.h:97:30: warning: unused variable 'mlx5e_stats_grp_sw' [-Wunused-variable]
      97 | #define MLX5E_STATS_GRP(grp) mlx5e_stats_grp_ ## grp
         |                              ^~~~~~~~~~~~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en_stats.h:100:38: note: in expansion of macro 'MLX5E_STATS_GRP'
     100 |         const struct mlx5e_stats_grp MLX5E_STATS_GRP(grp)
         |                                      ^~~~~~~~~~~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en_stats.h:521:8: note: in expansion of macro 'MLX5E_DECLARE_STATS_GRP'
     521 | extern MLX5E_DECLARE_STATS_GRP(sw);
         |        ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/en_stats.h:518:26: warning: unused variable 'mlx5e_nic_stats_grps' [-Wunused-variable]
     518 | extern mlx5e_stats_grp_t mlx5e_nic_stats_grps[];
         |                          ^~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h:46:13: warning: unused variable 'mlx5_core_debug_mask' [-Wunused-variable]
      46 | extern uint mlx5_core_debug_mask;
         |             ^~~~~~~~~~~~~~~~~~~~
   include/linux/filter.h:1610:32: warning: unused variable 'bpf_sk_lookup_enabled' [-Wunused-variable]
    1610 | extern struct static_key_false bpf_sk_lookup_enabled;
         |                                ^~~~~~~~~~~~~~~~~~~~~
   include/linux/filter.h:1266:13: warning: unused variable 'bpf_jit_limit_max' [-Wunused-variable]
    1266 | extern long bpf_jit_limit_max;
         |             ^~~~~~~~~~~~~~~~~
   include/linux/filter.h:1265:13: warning: unused variable 'bpf_jit_limit' [-Wunused-variable]
    1265 | extern long bpf_jit_limit;
         |             ^~~~~~~~~~~~~
   In file included from include/linux/security.h:35:
   include/linux/bpf.h:1528:38: warning: unused variable 'bpf_dispatcher_xdp' [-Wunused-variable]
    1528 |         extern struct bpf_dispatcher bpf_dispatcher_##name;
         |                                      ^~~~~~~~~~~~~~~
   include/linux/filter.h:1012:1: note: in expansion of macro 'DECLARE_BPF_DISPATCHER'
    1012 | DECLARE_BPF_DISPATCHER(xdp)
         | ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/filter.h:691:14: warning: unused variable 'nfct_btf_struct_access' [-Wunused-variable]
     691 | extern int (*nfct_btf_struct_access)(struct bpf_verifier_log *log,
         |              ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/filter.h:690:21: warning: unused variable 'nf_conn_btf_access_lock' [-Wunused-variable]
     690 | extern struct mutex nf_conn_btf_access_lock;
         |                     ^~~~~~~~~~~~~~~~~~~~~~~
   include/crypto/sha1.h:21:17: warning: unused variable 'sha1_zero_message_hash' [-Wunused-variable]
      21 | extern const u8 sha1_zero_message_hash[SHA1_DIGEST_SIZE];
         |                 ^~~~~~~~~~~~~~~~~~~~~~
   include/net/udp.h:579:36: warning: unused variable 'udp6_seq_ops' [-Wunused-variable]
     579 | extern const struct seq_operations udp6_seq_ops;
         |                                    ^~~~~~~~~~~~
   include/net/udp.h:578:36: warning: unused variable 'udp_seq_ops' [-Wunused-variable]
     578 | extern const struct seq_operations udp_seq_ops;
         |                                    ^~~~~~~~~~~
   include/net/udp.h:213:12: warning: unused variable 'sysctl_udp_wmem_min' [-Wunused-variable]
     213 | extern int sysctl_udp_wmem_min;
         |            ^~~~~~~~~~~~~~~~~~~
   include/net/udp.h:212:12: warning: unused variable 'sysctl_udp_rmem_min' [-Wunused-variable]
     212 | extern int sysctl_udp_rmem_min;
         |            ^~~~~~~~~~~~~~~~~~~
   include/net/udp.h:211:13: warning: unused variable 'sysctl_udp_mem' [-Wunused-variable]
     211 | extern long sysctl_udp_mem[3];
         |             ^~~~~~~~~~~~~~
   include/net/udp.h:208:22: warning: unused variable 'udp_memory_per_cpu_fw_alloc' [-Wunused-variable]
     208 | DECLARE_PER_CPU(int, udp_memory_per_cpu_fw_alloc);
         |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/percpu-defs.h:87:51: note: in definition of macro 'DECLARE_PER_CPU_SECTION'
      87 |         extern __PCPU_ATTRS(sec) __typeof__(type) name
         |                                                   ^~~~
   include/net/udp.h:208:1: note: in expansion of macro 'DECLARE_PER_CPU'
     208 | DECLARE_PER_CPU(int, udp_memory_per_cpu_fw_alloc);
         | ^~~~~~~~~~~~~~~
   include/net/udp.h:206:21: warning: unused variable 'udp_prot' [-Wunused-variable]
     206 | extern struct proto udp_prot;
         |                     ^~~~~~~~
   include/net/udp.h:106:25: warning: unused variable 'udp_table' [-Wunused-variable]
     106 | extern struct udp_table udp_table;
         |                         ^~~~~~~~~
   include/net/ip_tunnels.h:440:32: warning: unused variable 'ip_tunnel_header_ops' [-Wunused-variable]
     440 | extern const struct header_ops ip_tunnel_header_ops;
         |                                ^~~~~~~~~~~~~~~~~~~~
   include/net/ip6_fib.h:556:36: warning: unused variable 'ipv6_route_seq_ops' [-Wunused-variable]
     556 | extern const struct seq_operations ipv6_route_seq_ops;
         |                                    ^~~~~~~~~~~~~~~~~~
   include/net/inet_ecn.h:21:12: warning: unused variable 'sysctl_tunnel_ecn_log' [-Wunused-variable]
      21 | extern int sysctl_tunnel_ecn_log;
         |            ^~~~~~~~~~~~~~~~~~~~~
   include/linux/crash_dump.h:18:27: warning: unused variable 'dm_crypt_keys_addr' [-Wunused-variable]
      18 | extern unsigned long long dm_crypt_keys_addr;
         |                           ^~~~~~~~~~~~~~~~~~
   include/linux/crash_dump.h:16:27: warning: unused variable 'elfcorehdr_size' [-Wunused-variable]
      16 | extern unsigned long long elfcorehdr_size;
         |                           ^~~~~~~~~~~~~~~
   include/linux/kexec.h:528:13: warning: unused variable 'kexec_file_dbg_print' [-Wunused-variable]
     528 | extern bool kexec_file_dbg_print;
         |             ^~~~~~~~~~~~~~~~~~~~
   include/linux/kexec.h:470:13: warning: unused variable 'kexec_in_progress' [-Wunused-variable]
     470 | extern bool kexec_in_progress;
         |             ^~~~~~~~~~~~~~~~~
   include/linux/kexec.h:448:23: warning: unused variable 'kexec_crash_image' [-Wunused-variable]
     448 | extern struct kimage *kexec_crash_image;
         |                       ^~~~~~~~~~~~~~~~~
   include/linux/kexec.h:447:23: warning: unused variable 'kexec_image' [-Wunused-variable]
     447 | extern struct kimage *kexec_image;
         |                       ^~~~~~~~~~~
>> arch/mips/include/asm/kexec.h:47:15: warning: unused variable '_crash_smp_send_stop' [-Wunused-variable]
      47 | extern void (*_crash_smp_send_stop)(void);
         |               ^~~~~~~~~~~~~~~~~~~~
>> arch/mips/include/asm/kexec.h:46:17: warning: unused variable 'kexec_ready_to_reboot' [-Wunused-variable]
      46 | extern atomic_t kexec_ready_to_reboot;
         |                 ^~~~~~~~~~~~~~~~~~~~~
>> arch/mips/include/asm/kexec.h:45:22: warning: unused variable 'secondary_kexec_args' [-Wunused-variable]
      45 | extern unsigned long secondary_kexec_args[4];
         |                      ^~~~~~~~~~~~~~~~~~~~
>> arch/mips/include/asm/kexec.h:44:28: warning: unused variable 'kexec_smp_wait' [-Wunused-variable]
      44 | extern const unsigned char kexec_smp_wait[];
         |                            ^~~~~~~~~~~~~~
>> arch/mips/include/asm/kexec.h:39:15: warning: unused variable '_machine_crash_shutdown' [-Wunused-variable]
      39 | extern void (*_machine_crash_shutdown)(struct pt_regs *regs);
         |               ^~~~~~~~~~~~~~~~~~~~~~~
>> arch/mips/include/asm/kexec.h:38:15: warning: unused variable '_machine_kexec_shutdown' [-Wunused-variable]
      38 | extern void (*_machine_kexec_shutdown)(void);
         |               ^~~~~~~~~~~~~~~~~~~~~~~
>> arch/mips/include/asm/kexec.h:37:14: warning: unused variable '_machine_kexec_prepare' [-Wunused-variable]
      37 | extern int (*_machine_kexec_prepare)(struct kimage *);
         |              ^~~~~~~~~~~~~~~~~~~~~~
>> arch/mips/include/asm/kexec.h:36:22: warning: unused variable 'kexec_args' [-Wunused-variable]
      36 | extern unsigned long kexec_args[4];
         |                      ^~~~~~~~~~
>> arch/mips/include/asm/stacktrace.h:10:12: warning: unused variable 'raw_show_trace' [-Wunused-variable]
      10 | extern int raw_show_trace;
         |            ^~~~~~~~~~~~~~
   include/linux/crash_reserve.h:16:21: warning: unused variable 'crashk_cma_ranges' [-Wunused-variable]
      16 | extern struct range crashk_cma_ranges[];
         |                     ^~~~~~~~~~~~~~~~~
   include/linux/crash_reserve.h:15:24: warning: unused variable 'crashk_low_res' [-Wunused-variable]
      15 | extern struct resource crashk_low_res;
         |                        ^~~~~~~~~~~~~~
   include/linux/crash_reserve.h:14:24: warning: unused variable 'crashk_res' [-Wunused-variable]
      14 | extern struct resource crashk_res;
         |                        ^~~~~~~~~~
   include/linux/vmcore_info.h:76:13: warning: unused variable 'vmcoreinfo_note' [-Wunused-variable]
      76 | extern u32 *vmcoreinfo_note;
         |             ^~~~~~~~~~~~~~~
   include/linux/vmcore_info.h:75:15: warning: unused variable 'vmcoreinfo_size' [-Wunused-variable]
      75 | extern size_t vmcoreinfo_size;
         |               ^~~~~~~~~~~~~~~
   include/linux/vmcore_info.h:74:23: warning: unused variable 'vmcoreinfo_data' [-Wunused-variable]
      74 | extern unsigned char *vmcoreinfo_data;
         |                       ^~~~~~~~~~~~~~~
   include/linux/kexec.h:26:29: warning: unused variable 'crash_notes' [-Wunused-variable]
      26 | extern note_buf_t __percpu *crash_notes;
         |                             ^~~~~~~~~~~
   include/net/pkt_cls.h:1075:26: warning: unused variable 'tc_skb_ext_tc' [-Wunused-variable]
    1075 | DECLARE_STATIC_KEY_FALSE(tc_skb_ext_tc);
         |                          ^~~~~~~~~~~~~
   include/linux/jump_label.h:392:40: note: in definition of macro 'DECLARE_STATIC_KEY_FALSE'
     392 |         extern struct static_key_false name
         |                                        ^~~~
   include/net/pkt_cls.h:78:26: warning: unused variable 'tcf_sw_enabled_key' [-Wunused-variable]
      78 | DECLARE_STATIC_KEY_FALSE(tcf_sw_enabled_key);
         |                          ^~~~~~~~~~~~~~~~~~
   include/linux/jump_label.h:392:40: note: in definition of macro 'DECLARE_STATIC_KEY_FALSE'
     392 |         extern struct static_key_false name
         |                                        ^~~~
   include/linux/mlx5/driver.h:895:23: warning: unused variable 'mlx5_debugfs_root' [-Wunused-variable]
     895 | extern struct dentry *mlx5_debugfs_root;
         |                       ^~~~~~~~~~~~~~~~~
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
>> arch/mips/include/asm/pci.h:104:22: warning: unused variable 'PCIBIOS_MIN_MEM' [-Wunused-variable]
     104 | extern unsigned long PCIBIOS_MIN_MEM;
         |                      ^~~~~~~~~~~~~~~
>> arch/mips/include/asm/pci.h:103:22: warning: unused variable 'PCIBIOS_MIN_IO' [-Wunused-variable]
     103 | extern unsigned long PCIBIOS_MIN_IO;
         |                      ^~~~~~~~~~~~~~
>> include/linux/of.h:144:28: warning: unused variable 'of_stdout' [-Wunused-variable]
     144 | extern struct device_node *of_stdout;
         |                            ^~~~~~~~~
>> include/linux/of.h:143:28: warning: unused variable 'of_aliases' [-Wunused-variable]
     143 | extern struct device_node *of_aliases;
         |                            ^~~~~~~~~~
>> include/linux/of.h:142:28: warning: unused variable 'of_chosen' [-Wunused-variable]
     142 | extern struct device_node *of_chosen;
         |                            ^~~~~~~~~
   include/linux/pci.h:2016:12: warning: unused variable 'pci_domains_supported' [-Wunused-variable]
    2016 | extern int pci_domains_supported;
         |            ^~~~~~~~~~~~~~~~~~~~~
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


vim +/_crash_smp_send_stop +47 arch/mips/include/asm/kexec.h

583bb86fbb9e852 include/asm-mips/kexec.h      Nicolas Schichan 2006-10-18  33  
8cd2accb71f5eb8 arch/mips/include/asm/kexec.h Baoquan He       2023-12-08  34  #ifdef CONFIG_KEXEC_CORE
7aa1c8f47e7e792 arch/mips/include/asm/kexec.h Ralf Baechle     2012-10-11  35  struct kimage;
7aa1c8f47e7e792 arch/mips/include/asm/kexec.h Ralf Baechle     2012-10-11 @36  extern unsigned long kexec_args[4];
7aa1c8f47e7e792 arch/mips/include/asm/kexec.h Ralf Baechle     2012-10-11 @37  extern int (*_machine_kexec_prepare)(struct kimage *);
7aa1c8f47e7e792 arch/mips/include/asm/kexec.h Ralf Baechle     2012-10-11 @38  extern void (*_machine_kexec_shutdown)(void);
7aa1c8f47e7e792 arch/mips/include/asm/kexec.h Ralf Baechle     2012-10-11 @39  extern void (*_machine_crash_shutdown)(struct pt_regs *regs);
62cac480f33f8f9 arch/mips/include/asm/kexec.h Dengcheng Zhu    2018-09-11  40  void default_machine_crash_shutdown(struct pt_regs *regs);
62cac480f33f8f9 arch/mips/include/asm/kexec.h Dengcheng Zhu    2018-09-11  41  void kexec_nonboot_cpu_jump(void);
62cac480f33f8f9 arch/mips/include/asm/kexec.h Dengcheng Zhu    2018-09-11  42  void kexec_reboot(void);
7aa1c8f47e7e792 arch/mips/include/asm/kexec.h Ralf Baechle     2012-10-11  43  #ifdef CONFIG_SMP
7aa1c8f47e7e792 arch/mips/include/asm/kexec.h Ralf Baechle     2012-10-11 @44  extern const unsigned char kexec_smp_wait[];
7aa1c8f47e7e792 arch/mips/include/asm/kexec.h Ralf Baechle     2012-10-11 @45  extern unsigned long secondary_kexec_args[4];
7aa1c8f47e7e792 arch/mips/include/asm/kexec.h Ralf Baechle     2012-10-11 @46  extern atomic_t kexec_ready_to_reboot;
54c721b857fd45f arch/mips/include/asm/kexec.h Hidehiro Kawai   2016-10-11 @47  extern void (*_crash_smp_send_stop)(void);
7aa1c8f47e7e792 arch/mips/include/asm/kexec.h Ralf Baechle     2012-10-11  48  #endif
7aa1c8f47e7e792 arch/mips/include/asm/kexec.h Ralf Baechle     2012-10-11  49  #endif
7aa1c8f47e7e792 arch/mips/include/asm/kexec.h Ralf Baechle     2012-10-11  50  

:::::: The code at line 47 was first introduced by commit
:::::: 54c721b857fd45f3ad3bda695ee4f472518db02a mips/panic: replace smp_send_stop() with kdump friendly version in panic path

:::::: TO: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
