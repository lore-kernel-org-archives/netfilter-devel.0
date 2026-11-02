Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793581025;
	b=nGQnD6MuH67bGw7Upba7I6n/F1uZcZPa6sGyRKo6gKDbdHQ+aD1S+WFuwN+/l603hfRG
	 d3d/5pcclPIAAHYvLBxtThHijUUr6R07w7uEx22aSaHCDAUTCGLOAAW02ErLEoefUWYVT
	 BpgBqaABnVqmeBCfkvkCq75JMt4Ml62SL4qdfdnAOCsy/fZoaidNKNMHLj2gZc4F8sSWn
	 13EBoxX2Nh8Di3i6/GpXM8QtFwHS63abVt1y3UzT8Lv3M1a4QeFTF6YWYm+nRUOQbdl5I
	 9iszz+Mx+o1qNfv+u5ZY2C0xAsqVwR9Ev9Wxcu593QaVyZD4iDDJqA2SaItaJUl9sAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793581025;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=usJHA7vnDU8xmqr7VHOA8iVLiYpBVbjQqdKPLjipYNE=;
	b=EjZOpAp9ObDtgGpkgsm1qjVha1eCn6UG+vwu26ei4LqeqDYZP0Sz7bihb+7S28Ry9tQp
	 91q4Ad45zdVhSsEgydh4fodfCs8fwbK9eSgdiG6vZ+Y8hkRFSEbPMirYMLlJRgH9ZjBqg
	 X8xC5r646YYFGFaUnwupDFTym6uxrPM0vdg64QarXAIaVKiW65BqqQEowe+jG2WOyS8gp
	 Q/tXHrx+aH3n/J3sHLk6nTMEF1FhFwa4qzZe/GneoY/lH/Hm1rMuAfKLhZpjXNvvIN6Ws
	 XaAgSbOkz8jP4giUr4/RbCoHLEdD8a/hvhuefXkthOaH8j23x4pZHe5z3/FvjSCL5CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=vDafDNej;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC2C606A324;
	Mon,  2 Nov 2026 00:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CCC2C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=vDafDNej
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793581022;
	bh=usJHA7vnDU8xmqr7VHOA8iVLiYpBVbjQqdKPLjipYNE=;
	h=From:To:Cc:Subject:Date:From;
	b=vDafDNejAi8P3jUuE7ExPU9UrFAxojq5JwDz4V9MlWEzdfli+4KN3yXtCKjevaq3u
	 8Fm5tZ5/M8imhqtYXYsWY1AjK+FkP/B8bNxTjCxtuaqdHWiKL7PhxLsV8gm0rGW1k0
	 d8qmikDgVv3aHqAIQcZlzNeRMQTs+1XXGU+i29uPyDjXpojshDG2toktapd1EpVV2F
	 p/Dz94pXTU7owyHZZa9KRTv/FLUbFw9IFh3e/Qm3ZhrRmec5Dl6oGX8VAj6ZxZXGWx
	 vridnqyzNcjR5D4Wjtfjetsz2IkQcx11vCRLMfkTx5amTcv+LiJ7aImJOFa6ypg5BR
	 vzYtymmndXFcA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6396A6005D;
	Mon,  2 Nov 2026 01:57:01 +0100 (CET)
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
Subject: [PATCH net 00/15] Netfilter/IPVS fixes for net
Date: Mon,  2 Nov 2026 01:56:39 +0100
Message-ID: <20261102005654.532438-1-pablo@netfilter.org>
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

Hi,

The following batch contains Netfilter/IPVS fixes for net:

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

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-02

Thanks.

----------------------------------------------------------------

The following changes since commit cb284914e749388eef402938bdb3115fe1f6d337:

  net: ipa: Fix double free of the interrupt structure on config error (2026-10-30 19:04:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-02

for you to fetch changes up to f2cbeed50b68f547a70288e2aaa581bc6a366411:

  netfilter: nat: zero newrange before filling it in (2026-11-02 01:20:11 +0100)

----------------------------------------------------------------
netfilter pull request 26-11-02

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
 net/netfilter/nf_conntrack_expect.c         |  15 +++-
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
 32 files changed, 288 insertions(+), 113 deletions(-)
 create mode 100644 include/net/netfilter/nf_recursion.h
