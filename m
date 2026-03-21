Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505B18F48
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 07:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774077491; cv=none; b=KdrRvVN/zTWF/5i1a0BsDG/j/jR/SzQCPF+Cc9ZnIEH/dAsrA4wTdkRoKP630URa1Ca27a6eiN5/rOcmLjyFcRKXXQ9O0ncqmvRUigCDusYFAYvWaB3F/gJF4ZaWXyUjkDwbSCnn6rIxxseXhRmVbAyhArGCJo0tRXgqfE8KwBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774077491; c=relaxed/simple;
	bh=z11qS4hII8B0rcEjyEFfo8aGRaoK6PSfKRJTKuwbZJY=;
	h=Date:From:To:Cc:Subject:Message-ID; b=N3JU94oVOjYEjdHdELY24zIwxo7s3G4b8FCHqoDGjv0p6JttFM6zgv2bKNpFsjaGJEdsr2/UudozKGHn4epuoxZCSspl12e1u52TNtygJjGXxvZn5QNAkuHTN6j5iclFixBGF0K4vfanhxQv90g27jZaie7POIoYdzvNgdXY034=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kkCmw8h9; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kkCmw8h9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774077487; x=1805613487;
  h=date:from:to:cc:subject:message-id;
  bh=z11qS4hII8B0rcEjyEFfo8aGRaoK6PSfKRJTKuwbZJY=;
  b=kkCmw8h9PfzaxGpkCfXBGA62Coe2SRAIXxm2Uzz2wS7HD4VF+7OwpSEU
   Dgy50iDVDww0Yb0BQ7AFrg4llfk52cqQAga52D7KdpJsDkt9CTye8WLXL
   ZX+1xWddC8OhWGd9+nKYlsQQchUSHzvYQh09HFOt3W6sHhZ5aD/rQRRwE
   bqb+jXa+7rvadwIeEqVXY3eS2m+Cm4Xu1dfADqH81mkNo5Y5KXQdPSuW/
   6LxhMU57boy47j+pqq19c+OTi2tpw+L05knaGg52VFbz4qFUV6Cr26JEz
   6RCcDXbZJv1JR5+gU7QOwK7MBAJGwukPUGMiWQ78wqa9fg4sp9NWV1v4b
   A==;
X-CSE-ConnectionGUID: VSRe72WBSPyQZfSUjoxGJg==
X-CSE-MsgGUID: PbbyRfbMT2WvpNZa9iOQ0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="100612615"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="100612615"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2026 00:17:52 -0700
X-CSE-ConnectionGUID: ctZWWYcES22NoPkLRSgA7g==
X-CSE-MsgGUID: htexbna6Ruqdfwuyg2ILAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="220804220"
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 21 Mar 2026 00:17:48 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3qa3-000000000QP-1Td7;
	Sat, 21 Mar 2026 07:17:18 +0000
Date: Sat, 21 Mar 2026 15:16:47 +0800
From: kernel test robot <lkp@intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: oe-kbuild-all@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [netfilter-nf:testing 7/9] include/net/route.h:382:19:
 error: invalid use of undefined type 'const struct sk_buff'
Message-ID: <202603211547.w5VSMetj-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git testing
head:   b1bad43d8b00ab31c8f93145a4c8db1567f0d2fe
commit: 20d564bba6b3806c26498061299a88330561efa5 [7/9] netfilter: ctnetlink: ensure safe access to master conntrack
config: i386-randconfig-007-20260321 (https://download.01.org/0day-ci/archive/20260321/202603211547.w5VSMetj-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603211547.w5VSMetj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603211547.w5VSMetj-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from net/netfilter/nf_conntrack_netlink.c:39:
   include/net/netfilter/nf_conntrack_core.h: In function 'lockdep_nfct_expect_lock_not_held':
   include/net/netfilter/nf_conntrack_core.h:111: error: unterminated argument list invoking macro "WARN_ON_ONCE"
     111 | #endif /* _NF_CONNTRACK_CORE_H */
   include/net/netfilter/nf_conntrack_core.h:90:17: error: 'WARN_ON_ONCE' undeclared (first use in this function)
      90 |                 WARN_ON_ONCE(lockdep_is_held(&nf_conntrack_expect_lock);
         |                 ^~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_core.h:90:17: note: each undeclared identifier is reported only once for each function it appears in
   include/net/netfilter/nf_conntrack_core.h:90:29: error: expected ';' before 'struct'
      90 |                 WARN_ON_ONCE(lockdep_is_held(&nf_conntrack_expect_lock);
         |                             ^
         |                             ;
   In file included from net/netfilter/nf_conntrack_netlink.c:41:
   include/net/netfilter/nf_conntrack_helper.h:125:36: error: invalid storage class for function 'nfct_help'
     125 | static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
         |                                    ^~~~~~~~~
   include/net/netfilter/nf_conntrack_helper.h:130:21: error: invalid storage class for function 'nfct_help_data'
     130 | static inline void *nfct_help_data(const struct nf_conn *ct)
         |                     ^~~~~~~~~~~~~~
   In file included from net/netfilter/nf_conntrack_netlink.c:42:
   include/net/netfilter/nf_conntrack_seqadj.h:24:38: error: invalid storage class for function 'nfct_seqadj'
      24 | static inline struct nf_conn_seqadj *nfct_seqadj(const struct nf_conn *ct)
         |                                      ^~~~~~~~~~~
   include/net/netfilter/nf_conntrack_seqadj.h:29:38: error: invalid storage class for function 'nfct_seqadj_ext_add'
      29 | static inline struct nf_conn_seqadj *nfct_seqadj_ext_add(struct nf_conn *ct)
         |                                      ^~~~~~~~~~~~~~~~~~~
   In file included from net/netfilter/nf_conntrack_netlink.c:45:
   include/net/netfilter/nf_conntrack_acct.h:24:22: error: invalid storage class for function 'nf_conn_acct_find'
      24 | struct nf_conn_acct *nf_conn_acct_find(const struct nf_conn *ct)
         |                      ^~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_acct.h:30:22: error: invalid storage class for function 'nf_ct_acct_ext_add'
      30 | struct nf_conn_acct *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
         |                      ^~~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_acct.h:51:20: error: invalid storage class for function 'nf_ct_acct_enabled'
      51 | static inline bool nf_ct_acct_enabled(struct net *net)
         |                    ^~~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_acct.h:61:20: error: invalid storage class for function 'nf_ct_set_acct'
      61 | static inline void nf_ct_set_acct(struct net *net, bool enable)
         |                    ^~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_acct.h:71:20: error: invalid storage class for function 'nf_ct_acct_update'
      71 | static inline void nf_ct_acct_update(struct nf_conn *ct, u32 dir,
         |                    ^~~~~~~~~~~~~~~~~
   In file included from net/netfilter/nf_conntrack_netlink.c:47:
   include/net/netfilter/nf_conntrack_timestamp.h:17:24: error: invalid storage class for function 'nf_conn_tstamp_find'
      17 | struct nf_conn_tstamp *nf_conn_tstamp_find(const struct nf_conn *ct)
         |                        ^~~~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_timestamp.h:27:24: error: invalid storage class for function 'nf_ct_tstamp_ext_add'
      27 | struct nf_conn_tstamp *nf_ct_tstamp_ext_add(struct nf_conn *ct, gfp_t gfp)
         |                        ^~~~~~~~~~~~~~~~~~~~
>> include/net/netfilter/nf_conntrack_timestamp.h:44:20: error: invalid storage class for function 'nf_conntrack_tstamp_pernet_init'
      44 | static inline void nf_conntrack_tstamp_pernet_init(struct net *net) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from net/netfilter/nf_conntrack_netlink.c:48:
   include/net/netfilter/nf_conntrack_labels.h:23:38: error: invalid storage class for function 'nf_ct_labels_find'
      23 | static inline struct nf_conn_labels *nf_ct_labels_find(const struct nf_conn *ct)
         |                                      ^~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_labels.h:37:38: error: invalid storage class for function 'nf_ct_labels_ext_add'
      37 | static inline struct nf_conn_labels *nf_ct_labels_ext_add(struct nf_conn *ct)
         |                                      ^~~~~~~~~~~~~~~~~~~~
>> include/net/netfilter/nf_conntrack_labels.h:58:19: error: invalid storage class for function 'nf_connlabels_get'
      58 | static inline int nf_connlabels_get(struct net *net, unsigned int bit) { return 0; }
         |                   ^~~~~~~~~~~~~~~~~
>> include/net/netfilter/nf_conntrack_labels.h:59:20: error: invalid storage class for function 'nf_connlabels_put'
      59 | static inline void nf_connlabels_put(struct net *net) {}
         |                    ^~~~~~~~~~~~~~~~~
   In file included from net/netfilter/nf_conntrack_netlink.c:49:
   include/net/netfilter/nf_conntrack_synproxy.h:14:40: error: invalid storage class for function 'nfct_synproxy'
      14 | static inline struct nf_conn_synproxy *nfct_synproxy(const struct nf_conn *ct)
         |                                        ^~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_synproxy.h:23:40: error: invalid storage class for function 'nfct_synproxy_ext_add'
      23 | static inline struct nf_conn_synproxy *nfct_synproxy_ext_add(struct nf_conn *ct)
         |                                        ^~~~~~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_synproxy.h:32:20: error: invalid storage class for function 'nf_ct_add_synproxy'
      32 | static inline bool nf_ct_add_synproxy(struct nf_conn *ct,
         |                    ^~~~~~~~~~~~~~~~~~
   In file included from net/netfilter/nf_conntrack_netlink.c:51:
   include/net/netfilter/nf_nat.h:48:35: error: invalid storage class for function 'nfct_nat'
      48 | static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
         |                                   ^~~~~~~~
   include/net/netfilter/nf_nat.h:57:20: error: invalid storage class for function 'nf_nat_oif_changed'
      57 | static inline bool nf_nat_oif_changed(unsigned int hooknum,
         |                    ^~~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_nat.h:111:19: error: invalid storage class for function 'nf_nat_initialized'
     111 | static inline int nf_nat_initialized(const struct nf_conn *ct,
         |                   ^~~~~~~~~~~~~~~~~~
   In file included from net/netfilter/nf_conntrack_netlink.c:52:
   include/net/netfilter/nf_nat_helper.h:17:20: error: invalid storage class for function 'nf_nat_mangle_tcp_packet'
      17 | static inline bool nf_nat_mangle_tcp_packet(struct sk_buff *skb,
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from net/netfilter/nf_conntrack_netlink.c:55:
   include/linux/netfilter/nfnetlink.h:62:19: error: invalid storage class for function 'nfnl_msg_type'
      62 | static inline u16 nfnl_msg_type(u8 subsys, u8 msg_type)
         |                   ^~~~~~~~~~~~~
   include/linux/netfilter/nfnetlink.h:67:20: error: invalid storage class for function 'nfnl_fill_hdr'
      67 | static inline void nfnl_fill_hdr(struct nlmsghdr *nlh, u8 family, u8 version,
         |                    ^~~~~~~~~~~~~
   include/linux/netfilter/nfnetlink.h:78:32: error: invalid storage class for function 'nfnl_msg_put'
      78 | static inline struct nlmsghdr *nfnl_msg_put(struct sk_buff *skb, u32 portid,
         |                                ^~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:69:12: error: invalid storage class for function 'ctnetlink_dump_tuples_proto'
      69 | static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:93:12: error: invalid storage class for function 'ipv4_tuple_to_nlattr'
      93 | static int ipv4_tuple_to_nlattr(struct sk_buff *skb,
         |            ^~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:102:12: error: invalid storage class for function 'ipv6_tuple_to_nlattr'
     102 | static int ipv6_tuple_to_nlattr(struct sk_buff *skb,
         |            ^~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:111:12: error: invalid storage class for function 'ctnetlink_dump_tuples_ip'
     111 | static int ctnetlink_dump_tuples_ip(struct sk_buff *skb,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:138:12: error: invalid storage class for function 'ctnetlink_dump_tuples'
     138 | static int ctnetlink_dump_tuples(struct sk_buff *skb,
         |            ^~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:155:12: error: invalid storage class for function 'ctnetlink_dump_zone_id'
     155 | static int ctnetlink_dump_zone_id(struct sk_buff *skb, int attrtype,
         |            ^~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:168:12: error: invalid storage class for function 'ctnetlink_dump_status'
     168 | static int ctnetlink_dump_status(struct sk_buff *skb, const struct nf_conn *ct)
         |            ^~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:178:12: error: invalid storage class for function 'ctnetlink_dump_timeout'
     178 | static int ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct,
         |            ^~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:199:12: error: invalid storage class for function 'ctnetlink_dump_protoinfo'
     199 | static int ctnetlink_dump_protoinfo(struct sk_buff *skb, struct nf_conn *ct,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:224:12: error: invalid storage class for function 'ctnetlink_dump_helpinfo'
     224 | static int ctnetlink_dump_helpinfo(struct sk_buff *skb,
         |            ^~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:259:1: error: invalid storage class for function 'dump_counters'
     259 | dump_counters(struct sk_buff *skb, struct nf_conn_acct *acct,
         | ^~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:294:1: error: invalid storage class for function 'ctnetlink_dump_acct'
     294 | ctnetlink_dump_acct(struct sk_buff *skb, const struct nf_conn *ct, int type)
         | ^~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:310:1: error: invalid storage class for function 'ctnetlink_dump_timestamp'
     310 | ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
         | ^~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:415:1: error: invalid storage class for function 'ctnetlink_dump_labels'
     415 | ctnetlink_dump_labels(struct sk_buff *skb, const struct nf_conn *ct)
         | ^~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:436:12: error: invalid storage class for function 'ctnetlink_dump_master'
     436 | static int ctnetlink_dump_master(struct sk_buff *skb, const struct nf_conn *ct)
         |            ^~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:457:1: error: invalid storage class for function 'dump_ct_seq_adj'
     457 | dump_ct_seq_adj(struct sk_buff *skb, const struct nf_ct_seqadj *seq, int type)
         | ^~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:481:12: error: invalid storage class for function 'ctnetlink_dump_ct_seq_adj'
     481 | static int ctnetlink_dump_ct_seq_adj(struct sk_buff *skb, struct nf_conn *ct)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:505:12: error: invalid storage class for function 'ctnetlink_dump_ct_synproxy'
     505 | static int ctnetlink_dump_ct_synproxy(struct sk_buff *skb, struct nf_conn *ct)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:530:12: error: invalid storage class for function 'ctnetlink_dump_id'
     530 | static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
         |            ^~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:542:12: error: invalid storage class for function 'ctnetlink_dump_use'
     542 | static int ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
         |            ^~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:556:12: error: invalid storage class for function 'ctnetlink_dump_extinfo'
     556 | static int ctnetlink_dump_extinfo(struct sk_buff *skb,
         |            ^~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_netlink.c:570:12: error: invalid storage class for function 'ctnetlink_dump_info'
--
   In file included from net/netfilter/nf_conntrack_standalone.c:19:
   include/net/netfilter/nf_conntrack_core.h: In function 'lockdep_nfct_expect_lock_not_held':
   include/net/netfilter/nf_conntrack_core.h:111: error: unterminated argument list invoking macro "WARN_ON_ONCE"
     111 | #endif /* _NF_CONNTRACK_CORE_H */
   include/net/netfilter/nf_conntrack_core.h:90:17: error: 'WARN_ON_ONCE' undeclared (first use in this function)
      90 |                 WARN_ON_ONCE(lockdep_is_held(&nf_conntrack_expect_lock);
         |                 ^~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_core.h:90:17: note: each undeclared identifier is reported only once for each function it appears in
   include/net/netfilter/nf_conntrack_core.h:90:29: error: expected ';' before 'struct'
      90 |                 WARN_ON_ONCE(lockdep_is_held(&nf_conntrack_expect_lock);
         |                             ^
         |                             ;
   In file included from net/netfilter/nf_conntrack_standalone.c:22:
   include/net/netfilter/nf_conntrack_helper.h:125:36: error: invalid storage class for function 'nfct_help'
     125 | static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
         |                                    ^~~~~~~~~
   include/net/netfilter/nf_conntrack_helper.h:130:21: error: invalid storage class for function 'nfct_help_data'
     130 | static inline void *nfct_help_data(const struct nf_conn *ct)
         |                     ^~~~~~~~~~~~~~
   In file included from net/netfilter/nf_conntrack_standalone.c:23:
   include/net/netfilter/nf_conntrack_acct.h:24:22: error: invalid storage class for function 'nf_conn_acct_find'
      24 | struct nf_conn_acct *nf_conn_acct_find(const struct nf_conn *ct)
         |                      ^~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_acct.h:30:22: error: invalid storage class for function 'nf_ct_acct_ext_add'
      30 | struct nf_conn_acct *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
         |                      ^~~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_acct.h:51:20: error: invalid storage class for function 'nf_ct_acct_enabled'
      51 | static inline bool nf_ct_acct_enabled(struct net *net)
         |                    ^~~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_acct.h:61:20: error: invalid storage class for function 'nf_ct_set_acct'
      61 | static inline void nf_ct_set_acct(struct net *net, bool enable)
         |                    ^~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_acct.h:71:20: error: invalid storage class for function 'nf_ct_acct_update'
      71 | static inline void nf_ct_acct_update(struct nf_conn *ct, u32 dir,
         |                    ^~~~~~~~~~~~~~~~~
   In file included from net/netfilter/nf_conntrack_standalone.c:25:
   include/net/netfilter/nf_conntrack_timestamp.h:17:24: error: invalid storage class for function 'nf_conn_tstamp_find'
      17 | struct nf_conn_tstamp *nf_conn_tstamp_find(const struct nf_conn *ct)
         |                        ^~~~~~~~~~~~~~~~~~~
   include/net/netfilter/nf_conntrack_timestamp.h:27:24: error: invalid storage class for function 'nf_ct_tstamp_ext_add'
      27 | struct nf_conn_tstamp *nf_ct_tstamp_ext_add(struct nf_conn *ct, gfp_t gfp)
         |                        ^~~~~~~~~~~~~~~~~~~~
>> include/net/netfilter/nf_conntrack_timestamp.h:44:20: error: invalid storage class for function 'nf_conntrack_tstamp_pernet_init'
      44 | static inline void nf_conntrack_tstamp_pernet_init(struct net *net) {}
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/module.h:23,
                    from include/linux/device/driver.h:21,
                    from include/linux/device.h:32,
                    from include/linux/dma-mapping.h:5,
                    from include/linux/skbuff.h:28,
                    from include/linux/netfilter.h:6,
                    from net/netfilter/nf_conntrack_standalone.c:3:
   include/linux/moduleparam.h:442:45: error: invalid storage class for function '__check_enable_hooks'
     442 |         static inline type __always_unused *__check_##name(void) { return(p); }
         |                                             ^~~~~~~~
   include/linux/moduleparam.h:501:35: note: in expansion of macro '__param_check'
     501 | #define param_check_bool(name, p) __param_check(name, p, bool)
         |                                   ^~~~~~~~~~~~~
   include/linux/moduleparam.h:163:9: note: in expansion of macro 'param_check_bool'
     163 |         param_check_##type(name, &(value));                                \
         |         ^~~~~~~~~~~~
   include/linux/moduleparam.h:140:9: note: in expansion of macro 'module_param_named'
     140 |         module_param_named(name, name, type, perm)
         |         ^~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:30:1: note: in expansion of macro 'module_param'
      30 | module_param(enable_hooks, bool, 0000);
         | ^~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:32:14: error: section attribute cannot be specified for local variables
      32 | unsigned int nf_conntrack_net_id __read_mostly;
         |              ^~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:517:12: error: invalid storage class for function 'nf_conntrack_standalone_init_proc'
     517 | static int nf_conntrack_standalone_init_proc(struct net *net)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:522:13: error: invalid storage class for function 'nf_conntrack_standalone_fini_proc'
     522 | static void nf_conntrack_standalone_fini_proc(struct net *net)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/linkage.h:7,
                    from include/linux/kernel.h:18,
                    from include/linux/skbuff.h:13:
   net/netfilter/nf_conntrack_standalone.c:533:19: error: non-static declaration of 'nf_conntrack_count' follows static declaration
     533 | EXPORT_SYMBOL_GPL(nf_conntrack_count);
         |                   ^~~~~~~~~~~~~~~~~~
   include/linux/export.h:76:28: note: in definition of macro '__EXPORT_SYMBOL'
      76 |         extern typeof(sym) sym;                                 \
         |                            ^~~
   include/linux/export.h:90:41: note: in expansion of macro '_EXPORT_SYMBOL'
      90 | #define EXPORT_SYMBOL_GPL(sym)          _EXPORT_SYMBOL(sym, "GPL")
         |                                         ^~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:533:1: note: in expansion of macro 'EXPORT_SYMBOL_GPL'
     533 | EXPORT_SYMBOL_GPL(nf_conntrack_count);
         | ^~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:527:5: note: previous definition of 'nf_conntrack_count' with type 'u32(const struct net *)' {aka 'unsigned int(const struct net *)'}
     527 | u32 nf_conntrack_count(const struct net *net)
         |     ^~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:542:1: error: invalid storage class for function 'nf_conntrack_hash_sysctl'
     542 | nf_conntrack_hash_sysctl(const struct ctl_table *table, int write,
         | ^~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:563:1: error: invalid storage class for function 'nf_conntrack_log_invalid_sysctl'
     563 | nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:665:35: error: initializer element is not constant
     665 |                 .proc_handler   = nf_conntrack_hash_sysctl,
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:665:35: note: (near initialization for 'nf_ct_sysctl_table[2].proc_handler')
   net/netfilter/nf_conntrack_standalone.c:681:35: error: initializer element is not constant
     681 |                 .proc_handler   = nf_conntrack_log_invalid_sysctl,
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:681:35: note: (near initialization for 'nf_ct_sysctl_table[4].proc_handler')
   net/netfilter/nf_conntrack_standalone.c:937:13: error: invalid storage class for function 'nf_conntrack_standalone_init_tcp_sysctl'
     937 | static void nf_conntrack_standalone_init_tcp_sysctl(struct net *net,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:972:13: error: invalid storage class for function 'nf_conntrack_standalone_init_sctp_sysctl'
     972 | static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:994:13: error: invalid storage class for function 'nf_conntrack_standalone_init_gre_sysctl'
     994 | static void nf_conntrack_standalone_init_gre_sysctl(struct net *net,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:1005:12: error: invalid storage class for function 'nf_conntrack_standalone_init_sysctl'
    1005 | static int nf_conntrack_standalone_init_sysctl(struct net *net)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:1061:13: error: invalid storage class for function 'nf_conntrack_standalone_fini_sysctl'
    1061 | static void nf_conntrack_standalone_fini_sysctl(struct net *net)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:1081:13: error: invalid storage class for function 'nf_conntrack_fini_net'
    1081 | static void nf_conntrack_fini_net(struct net *net)
         |             ^~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:1090:12: error: invalid storage class for function 'nf_conntrack_pernet_init'
    1090 | static int nf_conntrack_pernet_init(struct net *net)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:1125:13: error: invalid storage class for function 'nf_conntrack_pernet_exit'
    1125 | static void nf_conntrack_pernet_exit(struct list_head *net_exit_list)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:1136:27: error: initializer element is not constant
    1136 |         .init           = nf_conntrack_pernet_init,
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:1136:27: note: (near initialization for 'nf_conntrack_net_ops.init')
   net/netfilter/nf_conntrack_standalone.c:1137:27: error: initializer element is not constant
    1137 |         .exit_batch     = nf_conntrack_pernet_exit,
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~
   net/netfilter/nf_conntrack_standalone.c:1137:27: note: (near initialization for 'nf_conntrack_net_ops.exit_batch')
   net/netfilter/nf_conntrack_standalone.c:1138:27: error: initializer element is not constant
    1138 |         .id             = &nf_conntrack_net_id,
         |                           ^
..


vim +382 include/net/route.h

510c321b557121 Xin Long           2018-02-14  274  
ee28906fd7a143 Stefano Brivio     2019-06-21  275  int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
ee28906fd7a143 Stefano Brivio     2019-06-21  276  		       u32 table_id, struct fib_info *fi,
e93fb3e9521abf John Fastabend     2019-08-23  277  		       int *fa_index, int fa_start, unsigned int flags);
ee28906fd7a143 Stefano Brivio     2019-06-21  278  
^1da177e4c3f41 Linus Torvalds     2005-04-16 @279  static inline void ip_rt_put(struct rtable *rt)
^1da177e4c3f41 Linus Torvalds     2005-04-16  280  {
6da025fa23bb10 Eric Dumazet       2012-10-28  281  	/* dst_release() accepts a NULL parameter.
6da025fa23bb10 Eric Dumazet       2012-10-28  282  	 * We rely on dst being first structure in struct rtable
6da025fa23bb10 Eric Dumazet       2012-10-28  283  	 */
6da025fa23bb10 Eric Dumazet       2012-10-28  284  	BUILD_BUG_ON(offsetof(struct rtable, dst) != 0);
d8d1f30b95a635 Changli Gao        2010-06-10  285  	dst_release(&rt->dst);
^1da177e4c3f41 Linus Torvalds     2005-04-16  286  }
^1da177e4c3f41 Linus Torvalds     2005-04-16  287  
4839c52b01ca91 Philippe De Muyter 2007-07-09  288  extern const __u8 ip_tos2prio[16];
^1da177e4c3f41 Linus Torvalds     2005-04-16  289  
^1da177e4c3f41 Linus Torvalds     2005-04-16 @290  static inline char rt_tos2priority(u8 tos)
^1da177e4c3f41 Linus Torvalds     2005-04-16  291  {
^1da177e4c3f41 Linus Torvalds     2005-04-16  292  	return ip_tos2prio[IPTOS_TOS(tos)>>1];
^1da177e4c3f41 Linus Torvalds     2005-04-16  293  }
^1da177e4c3f41 Linus Torvalds     2005-04-16  294  
2d7192d6cbab20 David S. Miller    2011-04-26  295  /* ip_route_connect() and ip_route_newports() work in tandem whilst
2d7192d6cbab20 David S. Miller    2011-04-26  296   * binding a socket for a new outgoing connection.
2d7192d6cbab20 David S. Miller    2011-04-26  297   *
2d7192d6cbab20 David S. Miller    2011-04-26  298   * In order to use IPSEC properly, we must, in the end, have a
2d7192d6cbab20 David S. Miller    2011-04-26  299   * route that was looked up using all available keys including source
2d7192d6cbab20 David S. Miller    2011-04-26  300   * and destination ports.
2d7192d6cbab20 David S. Miller    2011-04-26  301   *
2d7192d6cbab20 David S. Miller    2011-04-26  302   * However, if a source port needs to be allocated (the user specified
2d7192d6cbab20 David S. Miller    2011-04-26  303   * a wildcard source port) we need to obtain addressing information
2d7192d6cbab20 David S. Miller    2011-04-26  304   * in order to perform that allocation.
2d7192d6cbab20 David S. Miller    2011-04-26  305   *
2d7192d6cbab20 David S. Miller    2011-04-26  306   * So ip_route_connect() looks up a route using wildcarded source and
2d7192d6cbab20 David S. Miller    2011-04-26  307   * destination ports in the key, simply so that we can get a pair of
2d7192d6cbab20 David S. Miller    2011-04-26  308   * addresses to use for port allocation.
2d7192d6cbab20 David S. Miller    2011-04-26  309   *
2d7192d6cbab20 David S. Miller    2011-04-26  310   * Later, once the ports are allocated, ip_route_newports() will make
2d7192d6cbab20 David S. Miller    2011-04-26  311   * another route lookup if needed to make sure we catch any IPSEC
2d7192d6cbab20 David S. Miller    2011-04-26  312   * rules keyed on the port information.
2d7192d6cbab20 David S. Miller    2011-04-26  313   *
2d7192d6cbab20 David S. Miller    2011-04-26  314   * The callers allocate the flow key on their stack, and must pass in
2d7192d6cbab20 David S. Miller    2011-04-26  315   * the same flowi4 object to both the ip_route_connect() and the
2d7192d6cbab20 David S. Miller    2011-04-26  316   * ip_route_newports() calls.
2d7192d6cbab20 David S. Miller    2011-04-26  317   */
2d7192d6cbab20 David S. Miller    2011-04-26  318  
67e1e2f4854bb2 Guillaume Nault    2022-04-21 @319  static inline void ip_route_connect_init(struct flowi4 *fl4, __be32 dst,
67e1e2f4854bb2 Guillaume Nault    2022-04-21  320  					 __be32 src, int oif, u8 protocol,
b23dd4fe42b455 David S. Miller    2011-03-02  321  					 __be16 sport, __be16 dport,
67e1e2f4854bb2 Guillaume Nault    2022-04-21  322  					 const struct sock *sk)
^1da177e4c3f41 Linus Torvalds     2005-04-16  323  {
2d7192d6cbab20 David S. Miller    2011-04-26  324  	__u8 flow_flags = 0;
79876874ce20d3 KOVACS Krisztian   2008-10-01  325  
4bd0623f04eef6 Eric Dumazet       2023-08-16  326  	if (inet_test_bit(TRANSPARENT, sk))
94b92b88344641 David S. Miller    2011-03-31  327  		flow_flags |= FLOWI_FLAG_ANYSRC;
94b92b88344641 David S. Miller    2011-03-31  328  
65e9024643c751 Willem de Bruijn   2025-04-24  329  	if (IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) && !sport)
65e9024643c751 Willem de Bruijn   2025-04-24  330  		flow_flags |= FLOWI_FLAG_ANY_SPORT;
65e9024643c751 Willem de Bruijn   2025-04-24  331  
3c5b4d69c358a9 Eric Dumazet       2023-07-28  332  	flowi4_init_output(fl4, oif, READ_ONCE(sk->sk_mark), ip_sock_rt_tos(sk),
67e1e2f4854bb2 Guillaume Nault    2022-04-21  333  			   ip_sock_rt_scope(sk), protocol, flow_flags, dst,
e84a4927a404f3 Eric Dumazet       2025-06-20  334  			   src, dport, sport, sk_uid(sk));
2d7192d6cbab20 David S. Miller    2011-04-26  335  }
2d7192d6cbab20 David S. Miller    2011-04-26  336  
67e1e2f4854bb2 Guillaume Nault    2022-04-21 @337  static inline struct rtable *ip_route_connect(struct flowi4 *fl4, __be32 dst,
67e1e2f4854bb2 Guillaume Nault    2022-04-21  338  					      __be32 src, int oif, u8 protocol,
2d7192d6cbab20 David S. Miller    2011-04-26  339  					      __be16 sport, __be16 dport,
8d6eba33a2726e Guillaume Nault    2023-07-11  340  					      const struct sock *sk)
2d7192d6cbab20 David S. Miller    2011-04-26  341  {
2d7192d6cbab20 David S. Miller    2011-04-26  342  	struct net *net = sock_net(sk);
2d7192d6cbab20 David S. Miller    2011-04-26  343  	struct rtable *rt;
2d7192d6cbab20 David S. Miller    2011-04-26  344  
67e1e2f4854bb2 Guillaume Nault    2022-04-21  345  	ip_route_connect_init(fl4, dst, src, oif, protocol, sport, dport, sk);
79876874ce20d3 KOVACS Krisztian   2008-10-01  346  
^1da177e4c3f41 Linus Torvalds     2005-04-16  347  	if (!dst || !src) {
2d7192d6cbab20 David S. Miller    2011-04-26  348  		rt = __ip_route_output_key(net, fl4);
b23dd4fe42b455 David S. Miller    2011-03-02  349  		if (IS_ERR(rt))
b23dd4fe42b455 David S. Miller    2011-03-02  350  			return rt;
b23dd4fe42b455 David S. Miller    2011-03-02  351  		ip_rt_put(rt);
3f06760c00f56c Guillaume Nault    2023-06-01  352  		flowi4_update_output(fl4, oif, fl4->daddr, fl4->saddr);
^1da177e4c3f41 Linus Torvalds     2005-04-16  353  	}
3df98d79215ace Paul Moore         2020-09-27  354  	security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
2d7192d6cbab20 David S. Miller    2011-04-26  355  	return ip_route_output_flow(net, fl4, sk);
^1da177e4c3f41 Linus Torvalds     2005-04-16  356  }
^1da177e4c3f41 Linus Torvalds     2005-04-16  357  
2d7192d6cbab20 David S. Miller    2011-04-26 @358  static inline struct rtable *ip_route_newports(struct flowi4 *fl4, struct rtable *rt,
2d7192d6cbab20 David S. Miller    2011-04-26  359  					       __be16 orig_sport, __be16 orig_dport,
2d7192d6cbab20 David S. Miller    2011-04-26  360  					       __be16 sport, __be16 dport,
8d6eba33a2726e Guillaume Nault    2023-07-11  361  					       const struct sock *sk)
^1da177e4c3f41 Linus Torvalds     2005-04-16  362  {
dca8b089c95d94 David S. Miller    2011-02-24  363  	if (sport != orig_sport || dport != orig_dport) {
2d7192d6cbab20 David S. Miller    2011-04-26  364  		fl4->fl4_dport = dport;
2d7192d6cbab20 David S. Miller    2011-04-26  365  		fl4->fl4_sport = sport;
b23dd4fe42b455 David S. Miller    2011-03-02  366  		ip_rt_put(rt);
3f06760c00f56c Guillaume Nault    2023-06-01  367  		flowi4_update_output(fl4, sk->sk_bound_dev_if, fl4->daddr,
e6b45241c57a83 Julian Anastasov   2012-02-04  368  				     fl4->saddr);
3df98d79215ace Paul Moore         2020-09-27  369  		security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
2d7192d6cbab20 David S. Miller    2011-04-26  370  		return ip_route_output_flow(sock_net(sk), fl4, sk);
^1da177e4c3f41 Linus Torvalds     2005-04-16  371  	}
b23dd4fe42b455 David S. Miller    2011-03-02  372  	return rt;
^1da177e4c3f41 Linus Torvalds     2005-04-16  373  }
^1da177e4c3f41 Linus Torvalds     2005-04-16  374  
1668e010cbe1a7 KOVACS Krisztian   2008-10-01 @375  static inline int inet_iif(const struct sk_buff *skb)
1668e010cbe1a7 KOVACS Krisztian   2008-10-01  376  {
0340d0b9e0e2dc Tom Herbert        2016-04-05  377  	struct rtable *rt = skb_rtable(skb);
0340d0b9e0e2dc Tom Herbert        2016-04-05  378  
0340d0b9e0e2dc Tom Herbert        2016-04-05  379  	if (rt && rt->rt_iif)
0340d0b9e0e2dc Tom Herbert        2016-04-05  380  		return rt->rt_iif;
13378cad02afc2 David S. Miller    2012-07-23  381  
13378cad02afc2 David S. Miller    2012-07-23 @382  	return skb->skb_iif;
1668e010cbe1a7 KOVACS Krisztian   2008-10-01  383  }
1668e010cbe1a7 KOVACS Krisztian   2008-10-01  384  
323e126f0c5995 David S. Miller    2010-12-12 @385  static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
323e126f0c5995 David S. Miller    2010-12-12  386  {
323e126f0c5995 David S. Miller    2010-12-12  387  	int hoplimit = dst_metric_raw(dst, RTAX_HOPLIMIT);
323e126f0c5995 David S. Miller    2010-12-12  388  
469308552ca456 Eric Dumazet       2025-02-05  389  	if (hoplimit == 0) {
469308552ca456 Eric Dumazet       2025-02-05  390  		const struct net *net;
469308552ca456 Eric Dumazet       2025-02-05  391  
469308552ca456 Eric Dumazet       2025-02-05  392  		rcu_read_lock();
99a2ace61b211b Eric Dumazet       2025-08-28 @393  		net = dst_dev_net_rcu(dst);
8281b7ec5c56b7 Kuniyuki Iwashima  2022-07-13 @394  		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
469308552ca456 Eric Dumazet       2025-02-05  395  		rcu_read_unlock();
469308552ca456 Eric Dumazet       2025-02-05  396  	}
323e126f0c5995 David S. Miller    2010-12-12  397  	return hoplimit;
323e126f0c5995 David S. Miller    2010-12-12  398  }
323e126f0c5995 David S. Miller    2010-12-12  399  
5c9f7c1dfc2e07 David Ahern        2019-04-05 @400  static inline struct neighbour *ip_neigh_gw4(struct net_device *dev,
5c9f7c1dfc2e07 David Ahern        2019-04-05  401  					     __be32 daddr)
5c9f7c1dfc2e07 David Ahern        2019-04-05  402  {
5c9f7c1dfc2e07 David Ahern        2019-04-05  403  	struct neighbour *neigh;
5c9f7c1dfc2e07 David Ahern        2019-04-05  404  
3c42b2019863b3 Eric Dumazet       2022-01-26 @405  	neigh = __ipv4_neigh_lookup_noref(dev, (__force u32)daddr);
5c9f7c1dfc2e07 David Ahern        2019-04-05  406  	if (unlikely(!neigh))
5c9f7c1dfc2e07 David Ahern        2019-04-05 @407  		neigh = __neigh_create(&arp_tbl, &daddr, dev, false);
5c9f7c1dfc2e07 David Ahern        2019-04-05  408  
5c9f7c1dfc2e07 David Ahern        2019-04-05  409  	return neigh;
5c9f7c1dfc2e07 David Ahern        2019-04-05  410  }
5c9f7c1dfc2e07 David Ahern        2019-04-05  411  
5c9f7c1dfc2e07 David Ahern        2019-04-05 @412  static inline struct neighbour *ip_neigh_for_gw(struct rtable *rt,
5c9f7c1dfc2e07 David Ahern        2019-04-05  413  						struct sk_buff *skb,
5c9f7c1dfc2e07 David Ahern        2019-04-05  414  						bool *is_v6gw)
5c9f7c1dfc2e07 David Ahern        2019-04-05  415  {
5c9f7c1dfc2e07 David Ahern        2019-04-05 @416  	struct net_device *dev = rt->dst.dev;
5c9f7c1dfc2e07 David Ahern        2019-04-05  417  	struct neighbour *neigh;
5c9f7c1dfc2e07 David Ahern        2019-04-05  418  
5c9f7c1dfc2e07 David Ahern        2019-04-05  419  	if (likely(rt->rt_gw_family == AF_INET)) {
5c9f7c1dfc2e07 David Ahern        2019-04-05  420  		neigh = ip_neigh_gw4(dev, rt->rt_gw4);
5c9f7c1dfc2e07 David Ahern        2019-04-05  421  	} else if (rt->rt_gw_family == AF_INET6) {
5c9f7c1dfc2e07 David Ahern        2019-04-05  422  		neigh = ip_neigh_gw6(dev, &rt->rt_gw6);
5c9f7c1dfc2e07 David Ahern        2019-04-05  423  		*is_v6gw = true;
5c9f7c1dfc2e07 David Ahern        2019-04-05  424  	} else {
5c9f7c1dfc2e07 David Ahern        2019-04-05 @425  		neigh = ip_neigh_gw4(dev, ip_hdr(skb)->daddr);
5c9f7c1dfc2e07 David Ahern        2019-04-05  426  	}
5c9f7c1dfc2e07 David Ahern        2019-04-05  427  	return neigh;
5c9f7c1dfc2e07 David Ahern        2019-04-05  428  }
5c9f7c1dfc2e07 David Ahern        2019-04-05  429  

:::::: The code at line 382 was first introduced by commit
:::::: 13378cad02afc2adc6c0e07fca03903c7ada0b37 ipv4: Change rt->rt_iif encoding.

:::::: TO: David S. Miller <davem@davemloft.net>
:::::: CC: David S. Miller <davem@davemloft.net>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
