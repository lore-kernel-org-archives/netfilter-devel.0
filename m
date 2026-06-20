Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE35C245012;
	Sat, 20 Jun 2026 22:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781994472; cv=none; b=FT0e2NCk4U9WcC73eQquIpRTEElSJcy6HbMIuZe+Rs8smdeXpqBMrxoKUs0ZpSO67xZ5JwnL0DBU/oTc3yFu1rygkUXnD+HjHCsKJcIV9rLiJPAwnHtF/39IowZAJzr0Cty73Dg1eGqdDMn9kmkmBwGIXSycI+iNOs9TOuk2MzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781994472; c=relaxed/simple;
	bh=yFeInGN8/7o+tZoQbmXXBsP9WSVWpIVFWrtrtn8E9so=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YoM2VdPV8CnrVuWN9OFhtkUURzdEKEnnmJRXVRkoaaZRrqSldO5mlBnFO0aFs7XGyhrd7hdW215HfzvtkuoowU+swuAgcXhKSI0J5k2EMUJC0APN8ONpLyMjfjQg2B0FBHJ4FefAKVUYZdCRJ48JEbaq457pfkTePaVIHshRkjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Lb49wHwb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Lb49wHwb"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 747F16017F;
	Sun, 21 Jun 2026 00:27:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781994461;
	bh=5k69O7fD1Bw2qx2xivpEkR+HfEgX3b0iZRcmEoabePY=;
	h=From:To:Cc:Subject:Date:From;
	b=Lb49wHwbjJqpsDa6hQ+2umLAMGVLpBhV4W5GsVfVfHLAQzQKyeYM54b1+zMtAE01D
	 p6uBvimQsNGQxcf/em+mvRy7AVkl8gVLPdYt/38VqITdQRlQxGhmjUgYBNW1RJ6LAu
	 H9qw5TVWzJ8uhRvzFMJJkRWTjpdU2xD5LHwqpN4eV/eMl3mMZoL0gIHrzs92clAEhM
	 Nv8Pjy3Eqnk5bGJyJlhKATtrFq0BMWsR6QUv/qm6l4VKNeVxwqZCAk4v2RUNwIO1uj
	 EBVf7wir+9v9OcRt+cJlAWeRMqgxKCUmwowMBhAw4EEgppDyd3Ziq+TBPXHs5gLYQU
	 4mWp81u2LbHGA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net,v2 00/14] Netfilter fixes for net
Date: Sun, 21 Jun 2026 00:27:24 +0200
Message-ID: <20260620222738.112506-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v2, dropping two patches that need a bit more work,
uncovered by sashiko. I have revisit the working of this cover
letter to refine it.

-o-

Hi,
 
The following patchset contains Netfilter fixes for net. This batches
fixes for real crashes with trivial/correctness fixes. There is too
a rework of the conntrack expectation timeout strategy to deal with
a possible race when removing an expectation.
 
1) Fix the incorrect flowtable timeout extension for entries in
   hw offload, from Adrian Bente. This is correcting a defect in
   the functionality, no crash.
 
2) Hold reference to device under the fake dst in br_netfilter,
   from Haoze Xie. This is fixing a possible UaF if the device
   is removed while packet is sitting in nfqueue.
 
3) Reject template conntrack in xt_cluster, otherwise access to
   uninitialize conntrack fields are possible leading to WARN_ON
   due to unset layer 3 protocol. From Wyatt Feng.
 
4) Make sure the IPv6 tunnel header is in the linear skb data
   area before pulling. While at it remove incomplete NEXTHDR_DEST
   support. From Lorenzo Bianconi. This possibly leading to crash
   if IPv4 header is not in the linear area.
 
5) Use test_bit_acquire in ipset hash set to avoid reordering
   of subsequent memory access. This is addressing a LLM related
   report, no crash has been observed. From Jozsef Kadlecsik.
 
6) Use test_bit_acquire in ipset bitmap set too, for the same
   reason as in the previous patch, from Jozsef Kadlecsik.
 
7) Call kfree_rcu() after rcu_assign_pointer() to address a
   possible UaF if kfree_rcu() runs inmediately, which to my
   understanding never happens. Never observed in practise,
   reported by LLM. Also from Jozsef Kadlecsik.

8) Use disable_delayed_work_sync() instead cancel_delayed_work_sync()
   to avoid that ipset GC handler re-queues work as reported by LLM.
   From Jozsef Kadlecsik. This is for correctness.
 
9) Restore the check in nft_payload for exceeding payloda offset
    over 2^16. From Florian Westphal. This fixes a silent truncation,
    not a big deal, but better be assertive and reject it.
 
10) Validate NFT_META_BRI_IIFHWADDR can only run from bridge
    prerouting. From Florian Westphal. Harmless but it could allow
    to read bytes from skb->cb.
 
11) Zero out destination hardware address during the flowtable
    path setup, also from Florian. This is a correctness fix, LLM
    points that possible infoleak can happen but topology to achieve
    it is not clear.

12) Skip IPv4 options if present when building the IPV4 reject reply.
    Otherwise bytes in the IPv4 options header can be sent back to
    origin where the ICMP header is being expected. Again from
    Florian Westphal.
 
13) Replace timer API for expectation by GC worker approach. This
    is implicitly fixing a race between nf_ct_remove_expectations()
    which might fail to remove the expectation due to timer_del()
    returning false because timer has expired and callback is
    being run concurrently. This fix is addressing a crash that has
    been already reported with a reproducer.

14) Check if br_vlan_get_pvid_rcu() fails, otherwise possible stack
    infoleak of 4-bytes. From Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-06-21

Thanks.

----------------------------------------------------------------

The following changes since commit 96e7f9122aae0ed000ee321f324b812a447906d9:

  eth: fbnic: take netif_addr_lock_bh() around rx mode address programming (2026-06-18 18:36:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-06-21

for you to fetch changes up to 27dd2997746d54ebc079bb13161cc1bdd401d4a6:

  netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak (2026-06-21 00:18:37 +0200)

----------------------------------------------------------------
netfilter pull request 26-06-21

----------------------------------------------------------------
Adrian Bente (1):
      netfilter: flowtable: fix offloaded ct timeout never being extended

Florian Westphal (5):
      netfilter: nft_payload: reject offsets exceeding 65535 bytes
      netfilter: nft_meta_bridge: add validate callback for get operations
      netfilter: nft_flow_offload: zero device address for non-ether case
      netfilter: nf_reject: skip iphdr options when looking for icmp header
      netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak

Haoze Xie (1):
      netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst

Jozsef Kadlecsik (4):
      netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types
      netfilter: ipset: Don't use test_bit() in lockless RCU readers in bitmap types
      netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
      netfilter: ipset: make sure gc is properly stopped

Lorenzo Bianconi (1):
      netfilter: flowtable: fix and simplify IP6IP6 tunnel handling

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack_expect: use conntrack GC to reap expectations

Wyatt Feng (1):
      netfilter: xt_cluster: reject template conntracks in hash match

 include/net/netfilter/nf_conntrack_expect.h        |  16 ++-
 include/net/netfilter/nf_queue.h                   |   1 +
 include/net/netfilter/nft_meta.h                   |   2 +
 include/uapi/linux/netfilter/nf_conntrack_common.h |   1 +
 net/bridge/netfilter/nft_meta_bridge.c             |  23 +++-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   2 +-
 net/ipv6/ip6_tunnel.c                              |   7 +
 net/netfilter/ipset/ip_set_bitmap_gen.h            |   4 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |   2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c           |   2 +-
 net/netfilter/ipset/ip_set_core.c                  |   4 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |  12 +-
 net/netfilter/nf_conntrack_core.c                  |  33 ++++-
 net/netfilter/nf_conntrack_expect.c                | 145 ++++++++++-----------
 net/netfilter/nf_conntrack_h323_main.c             |   4 +-
 net/netfilter/nf_conntrack_helper.c                |  10 +-
 net/netfilter/nf_conntrack_netlink.c               |  22 ++--
 net/netfilter/nf_conntrack_sip.c                   |  13 +-
 net/netfilter/nf_flow_table_core.c                 |  13 +-
 net/netfilter/nf_flow_table_ip.c                   |  80 +++---------
 net/netfilter/nf_flow_table_path.c                 |   4 +-
 net/netfilter/nf_queue.c                           |  14 ++
 net/netfilter/nfnetlink_queue.c                    |   3 +
 net/netfilter/nft_ct.c                             |   3 +-
 net/netfilter/nft_meta.c                           |   5 +-
 net/netfilter/nft_payload.c                        |  16 ++-
 net/netfilter/xt_cluster.c                         |   2 +-
 .../selftests/net/netfilter/nft_flowtable.sh       |   8 +-
 29 files changed, 254 insertions(+), 199 deletions(-)
