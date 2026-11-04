Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782962;
	b=D08tS55CrLuCbJcg2VF96EaAW/K61jGZ/mXsz5uFMXBMDcYfPupU7I1lyylHKubFtd2E
	 9c5RQ6PrTA7x/pZnvYQWD/sqezKOJfWltmHAu6ibMBFK70dpA6hj4emHfIDCCoD/IjQ+Z
	 3lVuUWMVPAHGIgXdDbfDpH0x3gxa9eNtEd7eC9dOs/f5AiWAU4hWKIsGQuQ3vvreLbJio
	 Cgn6YrZKqnvmZl+ai0X5RjHOemoaksmp9SI49IyMXge08bBpGAKEQAiRW42tGE/+GCUKy
	 kPJwg7SXZxStHzI31fs3smOVaoASwn8muMwZwRsbhR0vrUZKzDSfvS545MDGBtba+mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782962;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=GTxT/20Qc2969O2nV6qvd8EoaHo8CyrPGUWwInAaeyA=;
	b=hh67PQacyQwQQtKvaSl0LVlXCunrWjqRBmyh7VPJubvJ1QDVvSOHXoEfz/8CbTSV88PS
	 q5cBhpXp/dVactL7ds2X1GsPJqdc5BzEqQlz9uE6PTsdjjzbZHgx8vggcV57B6B2JFWRn
	 CYaoO9aVQoWnKCv6tUKBDc+GV6edxFkSMes6p4PrpcWxaJmqfnj0u7PDRi9xOyJ9qTiay
	 oiBPetlWs+UNyh58LkqhrtWnHpn704sSAeCdazkuZYCpnUdANV/msmPuQ5ELgq2ytFSGw
	 xOTJFkCQ4MuNuw9aWrns/6er/6imNn6SU41mT2Bp0m7QN2oeqPqj7WgdTSFCJLCbUyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=O4wtIEiM;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07431606A328;
	Wed,  4 Nov 2026 09:02:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07431606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=O4wtIEiM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793782952;
	bh=GTxT/20Qc2969O2nV6qvd8EoaHo8CyrPGUWwInAaeyA=;
	h=From:To:Cc:Subject:Date:From;
	b=O4wtIEiMF/ovYc1Dne66D3v/7pR+rr1s5UldJzkNQCfUzkiDsYltU4oMtJKHt042G
	 elV1caP3T4cga0afXHp6KV7UwTv40Yxj06iwp31C04pzzgTS25nKXEj5RmwREmgW45
	 ov6Kzi0m1LyYVa8uWPICRrq+2CNX2c8DKQbqyJuImnNFTdL7d20/u1xSsnptpMsnFX
	 hmPMEEMcf9jXM/UV7lVOvwo01vHwxcuCGP0o22B55ibBi9V7ybX1iw3rDg0pjHHgD5
	 6528mPnQ6+1qECjoWdxlH4/0I0lOVqzIfdqL4a66Lk7ltkGHmaBijT+WhfODCZEMp0
	 YlmV+8ZJ0r0AA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 086C36007D;
	Wed,  4 Nov 2026 10:02:31 +0100 (CET)
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
Subject: [PATCH net,v3 00/13] Netfilter/IPVS fixes for net
Date: Wed,  4 Nov 2026 10:02:11 +0100
Message-ID: <20261104090224.750548-1-pablo@netfilter.org>
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

v3: keep back two patches in the series with sashiko reports that
    suggest they need a bit more work.

-o-

Hi,
 
The following batch contains Netfilter/IPVS fixes for net, this batch
addresses LLM findings, several of these fixes has been reproduced by
syzbot:
 
1) Add recursion count to nf_reject infrastructure to prevent stack
   overflow, from Fernando F. Mancera.
 
2) Use kfree_rcu() to release IPVS parent application to fix UaF,
   from Chengfeng Ye.
 
3) Fix UaF in IPVS netns removal path due to releasing per-net protocol
   data too early, from Chengfeng Ye.
 
4) Fix unbounded growth of stale, unmatchable IPVS connection entries,
   from Julian Anastasov.
 
5) Preserve recursion count on nfqueue reinjection, from Zihan Xi.
 
6) Restore GRE timeout in the flowtable, otherwise, WARN_ON_ONCE()
   is reachable, from Michail Andreas Michalopoulos.
 
7) Check non-null gc transaction in nft_rbtree before queuing it for
   processing, from Xingyuan Mo.
 
8) Replace WARN_ON_ONCE() by DEBUG_NET_WARN_ON_ONCE() in
   nf_conntrack_bridge which is reachable if the protocol of the tag
   of a frame differs from the vlan_protocol of the bridge.
   From Laveesh Bansal.

9) Check x_tables target name is non-null before accessing it when
    building a new table, from Fernando F. Mancera.
 
10) Fix out-of-bound memory read in nf_conntrack_sip, from
    Joas Antonio Dos Santos.
 
11) Fix a memleak in nf_tables hardware offload when double deleting
    the same rule, in the same batch.
 
12) Use a mutex in xt_recent netns exit path instead of spinlock,
    since proc unregistration might sleep. From Cen Zhang.

13) Zero the nf_nat_range2 struct before filling it up, to avoid
    using stale uninitialized stack data to configure NAT with
    an esoteric NAT flags combination. From Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-04

Thanks.

----------------------------------------------------------------

The following changes since commit cb284914e749388eef402938bdb3115fe1f6d337:

  net: ipa: Fix double free of the interrupt structure on config error (2026-10-30 19:04:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-04

for you to fetch changes up to ec993b526a3114f6c3cdd21cb2b148986370361e:

  netfilter: nat: zero newrange before filling it in (2026-11-04 09:48:34 +0100)

----------------------------------------------------------------
netfilter pull request 26-11-04

----------------------------------------------------------------
Cen Zhang (Microsoft) (1):
      netfilter: xt_recent: do not call remove_proc_entry() under recent_lock

Chengfeng Ye (2):
      ipvs: Defer application parent freeing until after RCU readers
      ipvs: fix protocol data lifetime during namespace teardown

Fernando Fernandez Mancera (2):
      netfilter: nft_reject: prevent unbounded recursion in output hooks
      netfilter: x_tables: check target name before accessing verdict

Florian Westphal (1):
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

 include/linux/netdevice_xmit.h             |  4 +--
 include/net/netfilter/nf_dup_netdev.h      | 35 -------------------------
 include/net/netfilter/nf_queue.h           |  1 +
 include/net/netfilter/nf_recursion.h       | 42 ++++++++++++++++++++++++++++++
 net/bridge/netfilter/nf_conntrack_bridge.c |  2 +-
 net/ipv4/netfilter/arp_tables.c            |  5 ++--
 net/ipv4/netfilter/ip_tables.c             |  5 ++--
 net/ipv4/netfilter/nf_reject_ipv4.c        | 12 +++++++++
 net/ipv6/netfilter/ip6_tables.c            |  5 ++--
 net/ipv6/netfilter/nf_reject_ipv6.c        | 13 +++++++++
 net/netfilter/ipvs/ip_vs_app.c             |  2 +-
 net/netfilter/ipvs/ip_vs_core.c            | 15 ++++++-----
 net/netfilter/ipvs/ip_vs_proto_sctp.c      |  5 ++++
 net/netfilter/ipvs/ip_vs_proto_tcp.c       |  5 ++++
 net/netfilter/ipvs/ip_vs_proto_udp.c       |  4 +++
 net/netfilter/nf_conntrack_sip.c           |  4 +--
 net/netfilter/nf_dup_netdev.c              |  1 +
 net/netfilter/nf_flow_table_core.c         |  1 +
 net/netfilter/nf_nat_masquerade.c          |  4 +--
 net/netfilter/nf_queue.c                   |  1 +
 net/netfilter/nf_tables_api.c              | 21 +++++++--------
 net/netfilter/nf_tables_offload.c          |  3 +++
 net/netfilter/nfnetlink_queue.c            | 17 +++++++++---
 net/netfilter/nft_fwd_netdev.c             |  1 +
 net/netfilter/nft_set_rbtree.c             |  3 ++-
 net/netfilter/xt_NETMAP.c                  |  4 +--
 net/netfilter/xt_recent.c                  |  7 ++---
 27 files changed, 145 insertions(+), 77 deletions(-)
 create mode 100644 include/net/netfilter/nf_recursion.h
