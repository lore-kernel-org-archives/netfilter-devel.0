Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882743;
	b=IKa31BNFpRQHWtHNXpz9TmoaQM78X1AXppFBvzNY0fkHd3UpsiBTKcLioxVb9jX8Th+W
	 lrPGnH3Wjypv5GVSsL7lGALgoYXAhSHdEArX7qI250f/4YRFgw3XBcm0k++wDGr1OJKzD
	 NkSyZzRGjwDiCF/RD+w1lqXMyeHBrTE5hQgYN19PtfPaxXtvcZVhYegtr7cFBGuJPo7dm
	 Y1YQzzhgqvQlx5Uvef67nNp53G5/F8XKMHh2bqhXmQ/Atm62tCzQ+wh+CfRPDyfEeY0N4
	 PFy/WDXBasNe+9SHCHSfckPf2FRXkSVo2bY0X7zjo11fcY5firccekhpweXYr7T++dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882743;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=3yj6avl1hgRLvpVkxyEnWdK250pZvSjfL6HyI1vCCNE=;
	b=nnUx9ean3KAXVpr3+/Ux2m0D4gkIRUiwsjpUyo6M6MAzze+61LevA5uDYakuvF90G/Fx
	 NDsmLl1u9ta/tzZa8hSDgzeW1jo0n0EEOnlYqtXKpLr4BxdLKmT0gytoCqcX+arU+oiuA
	 S0hzW1xm/434go91YVU3/6Fi4JyZjRfokg+1DqNTtJQt3s+wRPEbnFhp4APtXlCCWejxL
	 m+IpQQRlDpEZemRF/uM+T7DXaFYvAwNDOoiUvZ11I7Ce483HSgd8yre2ruw2NspVSQzHj
	 bfZVkFghTubmZj7bJmepqjfbM3LPoZs3aQNOFdZK132mlyBrxi6h21OQj96trz4P4jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=hsyk7EkE;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4577606A326;
	Thu,  5 Nov 2026 12:45:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4577606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=hsyk7EkE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793882740;
	bh=3yj6avl1hgRLvpVkxyEnWdK250pZvSjfL6HyI1vCCNE=;
	h=From:To:Cc:Subject:Date:From;
	b=hsyk7EkEFbZo0lwE+8XsHcrvj1RAEZKpkhqclpQfUQx30mcI+RsKg97E9JsiY9/fs
	 BNKz64aoHQo4U5FWftJ9jKU9BFBYWYsSx6Tp8hDPrTKgiZY/AH0Lw8HTZbKWdolI2n
	 zhLAaEOWmOzlxu6KXKhwqcX5Vb3BwXPD2pzFC1ol8ThqYAWjFQ+ypi3ao9AD6Vis+C
	 /gdbONhQbzvZxZ2LrIPurWhhW1xeLCrxNuOlATLS1FGWCyvo6FpjeoZ6s4ar/ORhX3
	 3Skvpze5U1yzjogYVMm5EMlcrPOfmvSiZr0TOiq8eVC0cbdJPkh5aLGiPxYK1HE9uw
	 vYc1xJiwpgscw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A6EC660082;
	Thu,  5 Nov 2026 13:45:39 +0100 (CET)
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
Subject: [PATCH net,v4 00/12] Netfilter/IPVS fixes
Date: Thu,  5 Nov 2026 13:45:24 +0100
Message-ID: <20261105124536.1009301-1-pablo@netfilter.org>
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

v4: - Drop "ipvs: do not create conns from packets with port 0".

      This PR was already reviewed in its v2 by netdev-ai-bots.
      I have dropped all the patches that LLM flagged as needing
      more work even since.

      But I really think v3 was good enough and a follow up for
      "ipvs: do not create conns from packets with port 0"
      was just fine to proceed.

      Maybe patchbot will ban this pull request again, v3 was
      blocklisted for not fulfulling the 24 hours rule, that is
      why it was not reviewed.

      But, as said, this was all reviewed in PR v2 already, this
      is just keeping back 3 patches included in PR v1 needing
      more work.
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
 
4) Preserve recursion count on nfqueue reinjection, from Zihan Xi.
 
5) Restore GRE timeout in the flowtable, otherwise, WARN_ON_ONCE()
   is reachable, from Michail Andreas Michalopoulos.
 
6) Check non-null gc transaction in nft_rbtree before queuing it for
   processing, from Xingyuan Mo.
 
7) Replace WARN_ON_ONCE() by DEBUG_NET_WARN_ON_ONCE() in
   nf_conntrack_bridge which is reachable if the protocol of the tag
   of a frame differs from the vlan_protocol of the bridge.
   From Laveesh Bansal.
 
8) Check x_tables target name is non-null before accessing it when
    building a new table, from Fernando F. Mancera.

9) Fix out-of-bound memory read in nf_conntrack_sip, from
   Joas Antonio Dos Santos.
 
10) Fix a memleak in nf_tables hardware offload when double deleting
    the same rule, in the same batch.
 
11) Use a mutex in xt_recent netns exit path instead of spinlock,
    since proc unregistration might sleep. From Cen Zhang.
 
12) Zero the nf_nat_range2 struct before filling it up, to avoid
    using stale uninitialized stack data to configure NAT with
    an esoteric NAT flags combination. From Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-05

Thanks.

----------------------------------------------------------------

The following changes since commit cb284914e749388eef402938bdb3115fe1f6d337:

  net: ipa: Fix double free of the interrupt structure on config error (2026-10-30 19:04:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-05

for you to fetch changes up to d1bb235aa409a4e5aeba6c748d953d948625b1e9:

  netfilter: nat: zero newrange before filling it in (2026-11-05 13:31:11 +0100)

----------------------------------------------------------------
netfilter pull request 26-11-05

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
 net/netfilter/ipvs/ip_vs_core.c            | 12 ++++-----
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
 24 files changed, 129 insertions(+), 76 deletions(-)
 create mode 100644 include/net/netfilter/nf_recursion.h
