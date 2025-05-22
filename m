Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68574299AB9;
	Thu, 22 May 2025 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932780; cv=none; b=K/+Q0tabSCF8HCH5VpHqbkEsimYIYPZdPwv+7CxZGZxXQAyWqsRA5hnOP8wO73W6mN74rZ4oWoYVDCg7ckwGmD2D2NgEHmaNqr6Oh8tayT38W5/tImCan2Xj0BEwJ1tUlDcdfrJZ+3NfUG4VIQfYjVHrmIk/oGJLEbhMtl4p6lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932780; c=relaxed/simple;
	bh=sJL9Z9DbWuzLwaCcaUovUmv2H3Qk40cqmEWHraNNcCI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qHsFuhkpF3j/Yg0z8aeV4m0WlIRx2pUyhkKXR5mRsfhqJtICP26fOf8a9Zn2X5Ry1jFAEC3E0yyNZ8/yVdKx+dTtxsm2jjNOTLJc9j9T43uq+n0O5AhaiQKroCenQYsawYTGeGpXQvAdtIaTVuOWPaTwOXT80IxLGaEDZ1AAdV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Uk2p9I80; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=En7lPhlm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Uk2p9I80";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="En7lPhlm"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4F9386072A; Thu, 22 May 2025 18:52:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932770;
	bh=eQb0K1FTffzWAje34e2SMmv1VyKYoMyZidRKD4P6FeQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Uk2p9I80gKpuZWcefZPuypQIaw0TLS2bwk1OuV/pgtKo47sxAxcZWKJJmG3wvJcke
	 S3SW4+7ybvQFGOv+oWVc8+IAJ6ZoaRag8MSOhHF+68PRHqPReG7P/NvZp6F3Tt6pGx
	 ApFqgLO0iLC9as6rD+SLlGjnY9GDmHZez3xRr9ZVcyaEK/DauaEWKhMh6vOMt+Ct7y
	 DQ0XMli1qfZJawiXvZFYBewzVxI2iYT9lgjvafaIbkuuGPAiAdV+CJ/ZTH3c+3wyXD
	 xAPXPvrh2aEKT5Jq+yJ8IGZCE0tyFjZQU1L0t2rayJCDupUMBTY5NDk7M7NJJY2rhu
	 OcLXZ7DSwlACA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 16D0260717;
	Thu, 22 May 2025 18:52:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932766;
	bh=eQb0K1FTffzWAje34e2SMmv1VyKYoMyZidRKD4P6FeQ=;
	h=From:To:Cc:Subject:Date:From;
	b=En7lPhlm7CNh03r6R1kJlNvDu/JaDzXbSKENj0SFTQ36mtd9PQ2OO+j3HV+6/+KoA
	 wZZx2BxcdpqIQiZ171Z6gfKD869C3e5ZYYNP6sk99ZLaHzMT+F7gGSW1euOjk5XWWB
	 z1fO4DZFeCEw/mBwWajooixKd87fygdJ1xFmQMT9FznlMHby3r6aMB225RhKzjd8OZ
	 mRyqS3CabNhpNtaZk5Ik1WgnIbUHeGs2NKDyOyuhB3jzceOHy8cDxDbCvQVtzdei/1
	 O3ILskcY/9yJEBd87nTfvBS0gkGWvrqKrpf9duHjna8LOAjgdZ+xglBLjJ6m9IZp0K
	 dubSNPyZw3SAw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 00/26] Netfilter updates for net-next
Date: Thu, 22 May 2025 18:52:12 +0200
Message-Id: <20250522165238.378456-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-05-22

Thanks.

----------------------------------------------------------------

The following changes since commit f685204c57e87d2a88b159c7525426d70ee745c9:

  Merge branch 'queue_api-reduce-risk-of-name-collision-over-txq' (2025-05-19 20:09:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-05-22

for you to fetch changes up to abc77025d71fcc1dc7315eda8d7ca50860d56f47:

  selftests: netfilter: Torture nftables netdev hooks (2025-05-22 17:47:32 +0200)

----------------------------------------------------------------
netfilter pull request 25-05-22

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
 include/net/netfilter/nft_fib.h                    |  16 +
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
 31 files changed, 1511 insertions(+), 230 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_interface_stress.sh
