Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3913B46B5;
	Fri, 25 Jul 2025 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463035; cv=none; b=YAydADhlcR16+7UsV310TyylxULvJP/r7IEsgKtiMFZvmzw4NHK+UUoCQQDz5pCMHhSW8IQuZ9O8ND/VgVWaW7RvZRBHQSloXCyBNlaxOtiiMBkQuljvxLamfvzNcQBMwX2RWbtd2Me1GzajaP96ZMa3T/sCjeTCPfaEgomugss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463035; c=relaxed/simple;
	bh=ohLT75059uY/AALwRcHjjDg4CsZT5MlxmL2DqAeSVWk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YrY20lZCXmyOJkFBmL/xRMXRGpl2bez9sSX2YbUW6GLe5/mF+14Jf/Z9dsxcDBbVhi1aa1wcfHn6l5pZVBVxjgFW3esBTfoY4B4TdtDUMK8Ej9VolmdfDYyOdHnIwNPIN6nfq/zcFMD1IrI8xf6QHkBuFWpsBGKQ+B4R3ujmtuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gskrLaKA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hml2n8RJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gskrLaKA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hml2n8RJ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1836D6026E; Fri, 25 Jul 2025 19:03:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463029;
	bh=5L4NlS16LsmZC/48mEt/E095/99vKHK3eKXGP8snIYA=;
	h=From:To:Cc:Subject:Date:From;
	b=gskrLaKAHMebbo5j85wKt2YzRH3EhBYVClduHzpbgOEAXOodSJ3u3uwtEsbwnka5e
	 fGuQ2IKD9+jeR7YyTFjPojB6W8kt8o0/1RBFUg7Xosz/gn3oy6wjhEvdQq0xnhRtf7
	 Wiu3/0yj3IR+s9v43+CkdhIGphMIk7bLW941RMocOuR0q14/vSUCMz3GJbCF0E4cdk
	 T2YZIxLapuNc6hJqM1XPMw4b0Jn4UElPC3r+Kr4RcNGDbeckWaqfz3MaRFmCYoZi2c
	 Hnd/q6kn73foQ7osl2gXyU7x3iYlXzWDms7nGXmvGFdorMAxkEfxtz+TWAwNxQe+5o
	 2q4OjFXP0WdDQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6F4EE6026E;
	Fri, 25 Jul 2025 19:03:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463026;
	bh=5L4NlS16LsmZC/48mEt/E095/99vKHK3eKXGP8snIYA=;
	h=From:To:Cc:Subject:Date:From;
	b=hml2n8RJWdkqi/5nq5TAzBmVDFTq7b9d7twehsDPem5HEXDplCm3F6dgV+9eZivRo
	 12FzZZUhhlmEpONdgwg84JdiGC02/ldv73jb0Y0NfWTp4n0LbPu7zqxvuKATxelSoR
	 7DWO8Yz4HrFRUR/zGRVypTVvk7olcQY7Ikp5TVrnTsgiN97cId9Eo5TaQYg9pFm1GV
	 yX4CQ6+3dDk4clG7+Rmczhk3A/VUUyMHP9A0fuhxwtj6zW5M4RI4y2ZBW/ZkQHH9mP
	 UMQIPcidMKr7T846GZPjJUlyIDYnhv0LMV9dwwlKZLUxZMOFb7/1B1Refgqrr6rKSS
	 qLqRe7hRPorxw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 00/19] Netfilter/IPVS updates for net-next
Date: Fri, 25 Jul 2025 19:03:21 +0200
Message-Id: <20250725170340.21327-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following series contains Netfilter/IPVS updates for net-next:

1) Display netns inode in conntrack table full log, from lvxiafei.

2) Autoload nf_log_syslog in case no logging backend is available,
   from Lance Yang.

3) Three patches to remove unused functions in x_tables, nf_tables and
   conntrack. From Yue Haibing.

4) Exclude LEGACY TABLES on PREEMPT_RT: Add NETFILTER_XTABLES_LEGACY
   to exclude xtables legacy infrastructure.

5) Restore selftests by toggling NETFILTER_XTABLES_LEGACY where needed.
   From Florian Westphal.

6) Use CONFIG_INET_SCTP_DIAG in tools/testing/selftests/net/netfilter/config,
   from Sebastian Andrzej Siewior.

7) Use timer_delete in comment in IPVS codebase, from WangYuli.

8) Dump flowtable information in nfnetlink_hook, this includes an initial
   patch to consolidate common code in helper function, from Phil Sutter.

9) Remove unused arguments in nft_pipapo set backend, from Florian Westphal.

10) Return nft_set_ext instead of boolean in set lookup function,
    from Florian Westphal.

11) Remove indirection in dynamic set infrastructure, also from Florian.

12) Consolidate pipapo_get/lookup, from Florian.

13) Use kvmalloc in nft_pipapop, from Florian Westphal.

14) syzbot reports slab-out-of-bounds in xt_nfacct log message,
    fix from Florian Westphal.

15) Ignored tainted kernels in selftest nft_interface_stress.sh,
    from Phil Sutter.

16) Fix IPVS selftest by disabling rp_filter with ipip tunnel device,
    from Yi Chen.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-07-25

Thanks.

----------------------------------------------------------------

The following changes since commit faa60990a5414e5a1957adc9434ca0e804ad700b:

  Merge branch 'selftests-drv-net-fix-and-improve-command-requirement-checking' (2025-07-24 18:52:03 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-07-25

for you to fetch changes up to 8b4a1a46e84a17f5d6fde5c506cc6bb141a24772:

  selftests: netfilter: ipvs.sh: Explicity disable rp_filter on interface tunl0 (2025-07-25 18:41:04 +0200)

----------------------------------------------------------------
netfilter pull request 25-07-25

----------------------------------------------------------------
Florian Westphal (7):
      selftests: net: Enable legacy netfilter legacy options.
      netfilter: nft_set_pipapo: remove unused arguments
      netfilter: nft_set: remove one argument from lookup and update functions
      netfilter: nft_set: remove indirection from update API call
      netfilter: nft_set_pipapo: merge pipapo_get/lookup
      netfilter: nft_set_pipapo: prefer kvmalloc for scratch maps
      netfilter: xt_nfacct: don't assume acct name is null-terminated

Lance Yang (1):
      netfilter: load nf_log_syslog on enabling nf_conntrack_log_invalid

Pablo Neira Ayuso (1):
      netfilter: Exclude LEGACY TABLES on PREEMPT_RT.

Phil Sutter (3):
      netfilter: nfnetlink: New NFNLA_HOOK_INFO_DESC helper
      netfilter: nfnetlink_hook: Dump flowtable info
      selftests: netfilter: Ignore tainted kernels in interface stress test

Sebastian Andrzej Siewior (1):
      selftests: netfilter: Enable CONFIG_INET_SCTP_DIAG

WangYuli (1):
      ipvs: Rename del_timer in comment in ip_vs_conn_expire_now()

Yi Chen (1):
      selftests: netfilter: ipvs.sh: Explicity disable rp_filter on interface tunl0

Yue Haibing (3):
      netfilter: x_tables: Remove unused functions xt_{in|out}name()
      netfilter: nf_tables: Remove unused nft_reduce_is_readonly()
      netfilter: conntrack: Remove unused net in nf_conntrack_double_lock()

lvxiafei (1):
      netfilter: conntrack: table full detailed log

 include/linux/netfilter.h                          |   1 +
 include/linux/netfilter/x_tables.h                 |  10 -
 include/net/netfilter/nf_log.h                     |   3 +
 include/net/netfilter/nf_tables.h                  |  19 +-
 include/net/netfilter/nf_tables_core.h             |  50 +++--
 include/uapi/linux/netfilter/nfnetlink_hook.h      |   2 +
 net/bridge/netfilter/Kconfig                       |  10 +-
 net/ipv4/netfilter/Kconfig                         |  24 +--
 net/ipv6/netfilter/Kconfig                         |  19 +-
 net/netfilter/Kconfig                              |  10 +
 net/netfilter/ipvs/ip_vs_conn.c                    |   2 +-
 net/netfilter/nf_conntrack_core.c                  |  16 +-
 net/netfilter/nf_conntrack_standalone.c            |  26 ++-
 net/netfilter/nf_log.c                             |  26 +++
 net/netfilter/nf_tables_api.c                      |  24 +--
 net/netfilter/nfnetlink_hook.c                     |  76 ++++++--
 net/netfilter/nft_dynset.c                         |  10 +-
 net/netfilter/nft_lookup.c                         |  27 +--
 net/netfilter/nft_objref.c                         |   5 +-
 net/netfilter/nft_set_bitmap.c                     |  11 +-
 net/netfilter/nft_set_hash.c                       |  54 +++---
 net/netfilter/nft_set_pipapo.c                     | 204 +++++++--------------
 net/netfilter/nft_set_pipapo_avx2.c                |  26 +--
 net/netfilter/nft_set_rbtree.c                     |  40 ++--
 net/netfilter/x_tables.c                           |  16 +-
 net/netfilter/xt_nfacct.c                          |   4 +-
 tools/testing/selftests/bpf/config                 |   1 +
 tools/testing/selftests/hid/config.common          |   1 +
 tools/testing/selftests/net/config                 |  11 ++
 tools/testing/selftests/net/mptcp/config           |   2 +
 tools/testing/selftests/net/netfilter/config       |   7 +-
 tools/testing/selftests/net/netfilter/ipvs.sh      |   4 +-
 .../net/netfilter/nft_interface_stress.sh          |   5 +-
 .../testing/selftests/wireguard/qemu/kernel.config |   4 +
 34 files changed, 402 insertions(+), 348 deletions(-)
