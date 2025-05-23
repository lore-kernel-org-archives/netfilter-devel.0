Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742C51FDD;
	Fri, 23 May 2025 13:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006847; cv=none; b=JhWsnuiNZCe7sIhPfiUcLhCPvwAgobJUwJbeeYIgCiTVrqN+zcjlXjYvIkzWdoz5o8F9TjAgbOszChUNgiVpHYB+uyqkKUL2FS5Q7EDH7iqtfHBzrq0xIxoiUK6Zs3IB7ilT4kbngpg8hn+b/Qz4s3PLvkvqBufXnyEH+iDiw60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006847; c=relaxed/simple;
	bh=/x0XWzWOxsH3FnjaHSNOMVQkhx9uVIy12Eys8Ywkvps=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OTKdSvYJzxhiYWh41Ztme/ocPN9Rbs4kHf6cHc2rA3y4wuFqNe1JLI4nmvk38sI6cQ72qFNqFFFQ9en341aG1FctlA2zKb//Der/7LIPz/aYiUzpH8euATBujVv49ZvgZGVtv7TeJyn3QN/9wgd6v6gvJOafyd/tVj4rFgPj+6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hofZ7FjL; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nZMZdvs6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hofZ7FjL";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nZMZdvs6"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B154C60765; Fri, 23 May 2025 15:27:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006842;
	bh=04JCSTRb+q6/BonbgucE0G7lB8ElifakTKVJiczH7MQ=;
	h=From:To:Cc:Subject:Date:From;
	b=hofZ7FjL6+0aURfBcblc3S/QJc+IpolGbvlEOPt4TczQJBQG5d+JO/Tv1FsI/9H+b
	 T66psMo3msvcqVyhE1m2pbC7CMWZwreCQXGPSSK3R6yRn/LTXcfrmjO+XmgpsYFeDS
	 x34C9rUSbEZK+UA7bo58ivYEZx88Yj+s+6QXmr1MBaWMzKoZQLEdGliluFGUtTECbi
	 KbvEaPp1gYBQRjoJ+k1JyP/Th9R0a8LJftr39E3yXsxwzADnCuqIuFB66q7G8rChZY
	 vvWNIU/Nr5OyE7h/jTL97JPCAGYJDqHwttRYsvOm0vmNz97jp2MzydDZiYDekq4QEz
	 1phj/pvaGypZg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0A23A6075E;
	Fri, 23 May 2025 15:27:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006839;
	bh=04JCSTRb+q6/BonbgucE0G7lB8ElifakTKVJiczH7MQ=;
	h=From:To:Cc:Subject:Date:From;
	b=nZMZdvs6asbrJw3v/miXPxBEn0qbOwXz1URfCJj4P8j9IdxvSUwesUsRdiLKJVVDP
	 WMukIWjYkD/lOWqoX3+uS1qbrD5xaMEix3hezfoiPi5JDI295SWZQMh58wHDLQ58V4
	 si7dkWJ2RlLi6HCSvm8p1d1iaC1c0M0A/GytH5Hfh+fSQqUObjq6HFUyiRdlPWCFS1
	 JyVshBcYCA7fHMDsS08ekmcpNaLavF/9E3wiJTosq1fFQKEHF8U6XrucCcagrUd5n/
	 jqWkL6nh/vKnwrqFrqwdDFm2cDA5uSi17IUaigUPJ+yJxMpo1WBjyaZF4UeqPIZaNw
	 0FymVQqut4eeg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next,v2 00/26] Netfilter updates for net-next
Date: Fri, 23 May 2025 15:26:46 +0200
Message-Id: <20250523132712.458507-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: fixing kdoc issue reported by Simon Horman.

-o-

Hi,

The following batch contains Netfilter updates for net-next,
specifically 26 patches: 5 patches adding/updating selftests,
4 fixes, 3 PREEMPT_RT fixes, and 14 patches to enhance nf_tables):

1) Improve selftest coverage for pipapo 4 bit group format, from
   Florian Westphal.

2) Fix incorrect dependencies when compiling a kernel without
   legacy ip{6}tables support, also from Florian.

3) Two patches to fix nft_fib vrf issues, including selftest updates
   to improve coverage, also from Florian Westphal.

4) Fix incorrect nesting in nft_tunnel's GENEVE support, from
   Fernando F. Mancera.

5) Three patches to fix PREEMPT_RT issues with nf_dup infrastructure
   and nft_inner to match in inner headers, from Sebastian Andrzej Siewior.

6) Integrate conntrack information into nft trace infrastructure,
   from Florian Westphal.

7) A series of 13 patches to allow to specify wildcard netdevice in
   netdev basechain and flowtables, eg.

   table netdev filter {
       chain ingress {
           type filter hook ingress devices = { eth0, eth1, vlan* } priority 0; policy accept;
       }
   }

   This also allows for runtime hook registration on NETDEV_{UN}REGISTER
   event, from Phil Sutter.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-05-23

Thanks.

----------------------------------------------------------------

The following changes since commit f685204c57e87d2a88b159c7525426d70ee745c9:

  Merge branch 'queue_api-reduce-risk-of-name-collision-over-txq' (2025-05-19 20:09:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-05-23

for you to fetch changes up to 73db1b5dab6fe17baf9fe2b0d7c8dfd1d4a5b3e5:

  selftests: netfilter: Torture nftables netdev hooks (2025-05-23 13:57:14 +0200)

----------------------------------------------------------------
netfilter pull request 25-05-23

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nft_tunnel: fix geneve_opt dump

Florian Westphal (9):
      selftests: netfilter: nft_concat_range.sh: add coverage for 4bit group representation
      netfilter: xtables: support arpt_mark and ipv6 optstrip for iptables-nft only builds
      selftests: netfilter: nft_fib.sh: add 'type' mode tests
      selftests: netfilter: move fib vrf test to nft_fib.sh
      netfilter: nf_tables: nft_fib_ipv6: fix VRF ipv4/ipv6 result discrepancy
      netfilter: nf_tables: nft_fib: consistent l3mdev handling
      selftests: netfilter: nft_fib.sh: add type and oif tests with and without VRFs
      netfilter: conntrack: make nf_conntrack_id callable without a module dependency
      netfilter: nf_tables: add packets conntrack state to debug trace info

Phil Sutter (13):
      netfilter: nf_tables: Introduce functions freeing nft_hook objects
      netfilter: nf_tables: Introduce nft_hook_find_ops{,_rcu}()
      netfilter: nf_tables: Introduce nft_register_flowtable_ops()
      netfilter: nf_tables: Pass nf_hook_ops to nft_unregister_flowtable_hook()
      netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook
      netfilter: nf_tables: Prepare for handling NETDEV_REGISTER events
      netfilter: nf_tables: Respect NETDEV_REGISTER events
      netfilter: nf_tables: Wrap netdev notifiers
      netfilter: nf_tables: Handle NETDEV_CHANGENAME events
      netfilter: nf_tables: Sort labels in nft_netdev_hook_alloc()
      netfilter: nf_tables: Support wildcard netdev hook specs
      netfilter: nf_tables: Add notifications for hook changes
      selftests: netfilter: Torture nftables netdev hooks

Sebastian Andrzej Siewior (3):
      netfilter: nf_dup{4, 6}: Move duplication check to task_struct
      netfilter: nft_inner: Use nested-BH locking for nft_pcpu_tun_ctx
      netfilter: nf_dup_netdev: Move the recursion counter struct netdev_xmit

 include/linux/netdevice_xmit.h                     |   3 +
 include/linux/netfilter.h                          |  15 +-
 include/linux/sched.h                              |   1 +
 include/net/netfilter/nf_tables.h                  |  12 +-
 include/net/netfilter/nft_fib.h                    |   9 +
 include/uapi/linux/netfilter/nf_tables.h           |  18 +
 include/uapi/linux/netfilter/nfnetlink.h           |   2 +
 net/ipv4/netfilter/ip_tables.c                     |   2 +-
 net/ipv4/netfilter/nf_dup_ipv4.c                   |   6 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |  11 +-
 net/ipv6/netfilter/ip6_tables.c                    |   2 +-
 net/ipv6/netfilter/nf_dup_ipv6.c                   |   6 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |  17 +-
 net/netfilter/core.c                               |   3 -
 net/netfilter/nf_conntrack_core.c                  |   6 +
 net/netfilter/nf_dup_netdev.c                      |  22 +-
 net/netfilter/nf_tables_api.c                      | 402 ++++++++++----
 net/netfilter/nf_tables_offload.c                  |  51 +-
 net/netfilter/nf_tables_trace.c                    |  54 +-
 net/netfilter/nfnetlink.c                          |   1 +
 net/netfilter/nft_chain_filter.c                   |  94 +++-
 net/netfilter/nft_flow_offload.c                   |   2 +-
 net/netfilter/nft_inner.c                          |  18 +-
 net/netfilter/nft_tunnel.c                         |   8 +-
 net/netfilter/xt_TCPOPTSTRIP.c                     |   4 +-
 net/netfilter/xt_mark.c                            |   2 +-
 tools/testing/selftests/net/netfilter/Makefile     |   1 +
 .../selftests/net/netfilter/conntrack_vrf.sh       |  34 --
 .../selftests/net/netfilter/nft_concat_range.sh    | 165 +++++-
 tools/testing/selftests/net/netfilter/nft_fib.sh   | 612 ++++++++++++++++++++-
 .../net/netfilter/nft_interface_stress.sh          | 151 +++++
 31 files changed, 1504 insertions(+), 230 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh
