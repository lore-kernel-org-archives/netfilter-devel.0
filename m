Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714596;
	b=LbtZBpI1V7A4dvrGeYt6SX8Pqt6FBPCZFxLEZOz76jp6Ja2ivji1OGnZW2ueYBGdPIzh
	 Pm0goXj4gM41DIUv+tV+zu+h11BXhgHWp5izZF1k686HKN9VcEx1CF5PwuI8ZwbA51ZGW
	 +i2k9Kp4X8EmImhsKyZdqAlJ4QOyB4KqaTQXcSZWTr6zhCxQshoBqVpUTXWd0bqiIUa2U
	 T8wnTHLKBHFYWLDwVEKVoy8pNWnzVs8zQSc+OzvW8WP3oTM+buZICc3+WvcMDPHxc97YO
	 SHLZUMptMMXQbnCwNqB9gP9awuRFQ5Q56P5FjEvYG4AN7GPzwDCyVYM5H/leZdjIj5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714596;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=+wylt6RbGzfu0iLn3PRuFAv0GzJgNhiFARw/Scn53Ok=;
	b=z46riQTbe1N7xrsMR+1JF0MBcwv4Az7hdG0L7oi3ZX/VO5mE1tj4tRPzeFswujLrrK4f
	 t/bR2S01nJVnu5nbT9CxJeWSh98GzPHSgmVa7JdTtGJTNmYJWNC120MHVKf4V1nkAV7Vz
	 9FofkAjplXMy4HhCdcQyA55oKTDpStYj+O0/uBHxSt/DrvxIYZU8lTNAqeFADA7bHSC8K
	 wZv162x8KnQH4mjRWNYTcAfpUnCcsoqbWg1wsqscOMGR6qFkwJ5tYyRArHzBaZUgTtaQp
	 Ms//0T3Hjjl+GwIY5F3KEJSQOOE2c/t4n4yzWJ0bnu8L2VsNfzoN1tkjr2vZhZCJrDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Hzacjfpz;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F011606EE90;
	Tue,  3 Nov 2026 14:03:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F011606EE90
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Hzacjfpz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714593;
	bh=+wylt6RbGzfu0iLn3PRuFAv0GzJgNhiFARw/Scn53Ok=;
	h=From:To:Cc:Subject:Date:From;
	b=HzacjfpzEiXXqjO4PQdIzjCzJ2OXVhsScFci/qTPARozIiDZAnp3UGa/J0h6kqSMP
	 Ks4GKCBPbcgfJe3vfXfkTFZTykp3UDqAjkU4l0lqUVUmNSm8fIGWAcrceXp65Evzlg
	 uC7MWqdBzfEFTQ17ba6dj0wlN2cjrrI67rvqXKtgJzeAVRu53Uz5uU/AL3MUJX5hU9
	 eb8gSlh+EorCBH2oEwnRem9aZj4pT/bd1FvYWkrP94PXSTFefabAgxmdp96CYiRYhS
	 TqPoJxgn+PJOLyma6/KFmxyElx1K3itiIyuHWjnEqAXEsQzi5E6ThWfujSxWAoePS6
	 qm9F2gE6W/YOQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 09B7960085;
	Tue,  3 Nov 2026 15:03:12 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net,v2 00/15] Netfilter/IPVS fixes for net
Date: Tue,  3 Nov 2026 15:02:52 +0100
Message-ID: <20261103140308.591690-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2: remove kdoc update in nf_conntrack_expect.
    anything else, just like v1.

-o-

Hi,

The following batch contains Netfilter/IPVS fixes for net, this batch
addresses LLM findings, several of these fixes has been reproduced by
syzbot:
 
1) Add recursion count to nf_reject infrastructure to prevent stack
   overflow, from Fernando F. Mancera.
 
2) Address a infinite loop in RCU list traversal with the TWOS IPVS
   scheduler, from Darong Lu and Julian Anastasov.
 
3) Use kfree_rcu() to release IPVS parent application to fix UaF,
   from Chengfeng Ye.
 
4) Fix UaF in IPVS netns removal path due to releasing per-net protocol
   data too early, from Chengfeng Ye.
 
5) Fix unbounded growth of stale, unmatchable IPVS connection entries,
   from Julian Anastasov.
 
6) Restrict maximum master conntrack chain depth in ctnetlink,
   from Florian Westphal.
 
7) Preserve recursion count on nfqueue reinjection, from Zihan Xi.
 
8) Restore GRE timeout in the flowtable, otherwise, WARN_ON_ONCE()
   is reachable, from Michail Andreas Michalopoulos.
 
9) Check non-null gc transaction in nft_rbtree before queuing it for
   processing, from Xingyuan Mo.
 
10) Replace WARN_ON_ONCE() by DEBUG_NET_WARN_ON_ONCE() in
    nf_conntrack_bridge which is reachable if the protocol of the tag
    of a frame differs from the vlan_protocol of the bridge.
    From Laveesh Bansal.

11) Check x_tables target name is non-null before accessing it when
    building a new table, from Fernando F. Mancera.
 
12) Fix out-of-bound memory read in nf_conntrack_sip, from
    Joas Antonio Dos Santos.
 
13) Fix a memleak in nf_tables hardware offload when double deleting
    the same rule, in the same batch.
 
14) Use a mutex in xt_recent netns exit path instead of spinlock,
    since proc unregistration might sleep. From Cen Zhang.
 
15) Zero the nf_nat_range2 struct before filling it up, to avoid
    using stale uninitialized stack data to configure NAT with
    an esoteric NAT flags combination. From Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-03

Thanks.

----------------------------------------------------------------

The following changes since commit cb284914e749388eef402938bdb3115fe1f6d337:

  net: ipa: Fix double free of the interrupt structure on config error (2026-10-30 19:04:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-03

for you to fetch changes up to 3d234337bbb1e32fab38e4e30da72edc5ddc241f:

  netfilter: nat: zero newrange before filling it in (2026-11-03 14:50:15 +0100)

----------------------------------------------------------------
netfilter pull request 26-11-03

----------------------------------------------------------------
Cen Zhang (Microsoft) (1):
      netfilter: xt_recent: do not call remove_proc_entry() under recent_lock

Chengfeng Ye (2):
      ipvs: Defer application parent freeing until after RCU readers
      ipvs: fix protocol data lifetime during namespace teardown

Darong Lu (1):
      ipvs: wait grace period while reusing dest from trash

Fernando Fernandez Mancera (2):
      netfilter: nft_reject: prevent unbounded recursion in output hooks
      netfilter: x_tables: check target name before accessing verdict

Florian Westphal (2):
      netfilter: nf_conntrack: limit expectation master chain depth
      netfilter: nat: zero newrange before filling it in

Joas Antonio dos Santos (1):
      netfilter: nf_conntrack_sip: fix OOB read in ct_sip_parse_transport()

Julian Anastasov (1):
      ipvs: do not create conns from packets with port 0

Laveesh Bansal (1):
      netfilter: bridge: use DEBUG_NET_WARN_ON_ONCE in nf_ct_bridge_refrag()

Michail Andreas Michalopoulos (1):
      netfilter: flowtable: extend ct timeout of offloaded GRE flows

Pablo Neira Ayuso (1):
      netfilter: nf_tables: fix memleak when rule deletion fails with hardware offload

Xingyuan Mo (1):
      netfilter: nft_set_rbtree: check catchall_sync return before queue_done

Zihan Xi (1):
      netfilter: nf_dup: preserve guard across NFQUEUE reinjection

 include/linux/netdevice_xmit.h              |   4 +-
 include/net/ip_vs.h                         |   4 +-
 include/net/netfilter/nf_conntrack_helper.h |  15 ++++
 include/net/netfilter/nf_dup_netdev.h       |  35 ---------
 include/net/netfilter/nf_queue.h            |   1 +
 include/net/netfilter/nf_recursion.h        |  42 +++++++++++
 net/bridge/netfilter/nf_conntrack_bridge.c  |   2 +-
 net/ipv4/netfilter/arp_tables.c             |   5 +-
 net/ipv4/netfilter/ip_tables.c              |   5 +-
 net/ipv4/netfilter/nf_reject_ipv4.c         |  12 +++
 net/ipv6/netfilter/ip6_tables.c             |   5 +-
 net/ipv6/netfilter/nf_reject_ipv6.c         |  13 ++++
 net/netfilter/ipvs/ip_vs_app.c              |   2 +-
 net/netfilter/ipvs/ip_vs_core.c             |  15 ++--
 net/netfilter/ipvs/ip_vs_ctl.c              | 109 ++++++++++++++++++++++------
 net/netfilter/ipvs/ip_vs_proto_sctp.c       |   5 ++
 net/netfilter/ipvs/ip_vs_proto_tcp.c        |   5 ++
 net/netfilter/ipvs/ip_vs_proto_udp.c        |   4 +
 net/netfilter/nf_conntrack_expect.c         |   3 +
 net/netfilter/nf_conntrack_netlink.c        |  36 ++++++---
 net/netfilter/nf_conntrack_sip.c            |   4 +-
 net/netfilter/nf_dup_netdev.c               |   1 +
 net/netfilter/nf_flow_table_core.c          |   1 +
 net/netfilter/nf_nat_masquerade.c           |   4 +-
 net/netfilter/nf_queue.c                    |   1 +
 net/netfilter/nf_tables_api.c               |  21 +++---
 net/netfilter/nf_tables_offload.c           |   3 +
 net/netfilter/nfnetlink_queue.c             |  17 ++++-
 net/netfilter/nft_fwd_netdev.c              |   1 +
 net/netfilter/nft_set_rbtree.c              |   3 +-
 net/netfilter/xt_NETMAP.c                   |   4 +-
 net/netfilter/xt_recent.c                   |   7 +-
 32 files changed, 279 insertions(+), 110 deletions(-)
 create mode 100644 include/net/netfilter/nf_recursion.h
