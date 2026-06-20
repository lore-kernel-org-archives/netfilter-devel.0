Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0004D2D595D;
	Sat, 20 Jun 2026 22:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781994532; cv=none; b=ryOUXE7QAU9y4H2KsCJlbUoJQ3p2iT+8xW27w/lEnOBhTcxWtxtrQ5wtSN4/FNRYmjgusJAdzi2qMI+8YbVwo9KGXSpTE6JrnJ0jJWA8W0BDLgtoypog/Y3zQ0o5zC3ekWaqOpsMbtnF/zkqvuZ6rsMr9kaGW8Nx7qj4q9DHpic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781994532; c=relaxed/simple;
	bh=K7QsiNWLCubhl8nNOEmN1zTJrU8vCAXwfeszXOdd/F0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iLV2vgvm8bNj4vHBOqAc3UE5t+M9Bym97bQa/6D3NUbMru6LjCqYsempzqNYJUuoRO+TkbmAs5FFDoNpFShpiAQxZyg1VENrKkFcjqREZhky49iMuLnVinQ10OLlebmmzspW/Qf3F434DKAAJJ28KjRdG1Nn3MXvby0aOT1tEAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hogHcMoX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hogHcMoX"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DEF91601C1;
	Sun, 21 Jun 2026 00:28:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781994529;
	bh=ZyTBSbTlpbm2Mu7VVZ9GNFZ5H3hVUoiuR+BpbTajTGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hogHcMoXtzOTzi1q33MtvyvWptulf9OOe1/Z73EBTIhYZ/cqbQLa1gv9tQBOUGaD1
	 CKWZXvQzwT1PHARVB6p2e+9yPZnHR88vUf6s5UKj3kKCZ5Vj7GZ/utQvSf+nxJLLZs
	 UeZu8FEpNs+DIy8HmkqJykM5fhdquGP2TU+RYBDfomaPPxwsQAsrQMMW3SJp1nEmwv
	 krJ/yu2H7oO/xucqFMRLNZ5kT07ClUIa3aL09d6AIFZkiOPfSc/iUTFFE8WYD5A3kZ
	 X9usAqQNuCCFu3BCUw9Z4pJePr+p/CLkBHVJQWIpv9AGnYmTIP6RO3UcnIaboyKrVx
	 D8Jf85ehVL28w==
Date: Sun, 21 Jun 2026 00:28:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
	horms@kernel.org
Subject: Re: [PATCH net 00/16] Netfilter fixes for net
Message-ID: <ajcUHm_HHIjhANsk@chamomile>
References: <20260619115452.93949-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260619115452.93949-1-pablo@netfilter.org>

Hi,

Please scratch this v1 series.

I have posted a v2 for this series for the net tree.

Thanks.

On Fri, Jun 19, 2026 at 01:54:35PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for net, this contains
> fixes for a few crash, but many of the patches are trivial/correctness
> fixes. There is too one rework of the conntrack expectation timeout
> strategy to deal with a possible race when removing an expectation.
> 
> 1) Fix the incorrect flowtable timeout extension for entries in
>    hw offload, from Adrian Bente. This is correcting a defect in
>    the functionality, no crash.
> 
> 2) Hold reference to device under the fake dst in br_netfilter,
>    from Haoze Xie. This is fixing a possible UaF if the device
>    is removed while packet is sitting in nfqueue.
> 
> 3) Reject template conntrack in xt_cluster, otherwise access to
>    uninitialize conntrack fields are possible leading to WARN_ON
>    due to unset layer 3 protocol. From Wyatt Feng.
> 
> 4) Make sure the IPv6 tunnel header is in the linear skb data
>    area before pulling. While at it remove incomplete NEXTHDR_DEST
>    support. From Lorenzo Bianconi. This possibly leading to crash
>    if IPv4 header is not linear, but GRO already guarantees this,
>    unlikely but still possible.
> 
> 5) Bail out immediately if ENOMEM is seen in a nfnetlink batch,
>    no further processing since this will accumulate more bogus
>    errors. From Florian Westphal. Functionally improvements
>    under memory stress, no crash.
> 
> 6) Use test_bit_acquire in ipset hash set to avoid reordering
>    of subsequent memory access. This is addressing a LLM related
>    report, no crash has been observed. From Jozsef Kadlecsik.
> 
> 7) Use test_bit_acquire in ipset bitmap set too, for the same
>    reason as in the previous patch, from Jozsef Kadlecsik.
> 
> 8) Call kfree_rcu() after rcu_assign_pointer() to address a
>    possible UaF, very hard to trigger. Never observed in practise,
>    reported by LLM. Also from Jozsef Kadlecsik.
> 
> 9) Use disable_delayed_work_sync() instead cancel_delayed_work_sync()
>    to avoid that ipset GC handler re-queues work as reported by LLM.
>    From Jozsef Kadlecsik. This is for correctness.
> 
> 10) Restore the check in nft_payload for exceeding payloda offset
>     over 2^16. From Florian Westphal. This fixes a silent truncation,
>     not a big deal, but better be assertive and reject it.
> 
> 11) Validate NFT_META_BRI_IIFHWADDR can only run from bridge
>     prerouting. From Florian Westphal. Harmless but it could allow
>     to read bytes from skb->cb.
> 
> 12) Zero out destination hardware address during the flowtable
>     path setup, also from Florian. This is a correctness fix, LLM
>     points that possible infoleak can happen but topology to achieve
>     it is not clear.
> 
> 13) Skip IPv4 options if present when building the IPV4 reject reply.
>     Otherwise bytes in the IPv4 options header can be sent back to
>     origin where the ICMP header is being expected. Again from
>     Florian Westphal.
> 
> 14) Replace timer API for expectation by GC worker approach. This
>     is implicitly fixing a race between nf_ct_remove_expectations()
>     which might fail to remove the expectation due to timer_del()
>     returning false because timer has expired and callback is
>     being run concurrently. This fix is addressing a crash that has
>     been already reported with a reproducer.
> 
> 15) Store the master tuple in the expectation, since SLAB_TYPESAFE_BY_RCU
>     does not guarantee that accessing exp->master under rcu read lock
>     refer to the right master conntrack. Found by initial round of
>     fixes for expectation by LLM also found this.
> 
> 16) Check if br_vlan_get_pvid_rcu() fails to address a possible stack
>     infoleak of 4-bytes. From Florian Westphal.
> 
> This is slightly over the 15 patch limit in batches, please, allow this
> round to exceed it by one.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-06-19
> 
> Thanks.
> 
> ----------------------------------------------------------------
> 
> The following changes since commit 96e7f9122aae0ed000ee321f324b812a447906d9:
> 
>   eth: fbnic: take netif_addr_lock_bh() around rx mode address programming (2026-06-18 18:36:26 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-06-19
> 
> for you to fetch changes up to 05477f7a037c127854b58441f60b34210668f5c3:
> 
>   netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak (2026-06-19 12:27:08 +0200)
> 
> ----------------------------------------------------------------
> netfilter pull request 26-06-19
> 
> ----------------------------------------------------------------
> Adrian Bente (1):
>       netfilter: flowtable: fix offloaded ct timeout never being extended
> 
> Florian Westphal (6):
>       netfilter: nfnetlink: make OOM conditions fatal
>       netfilter: nft_payload: reject offsets exceeding 65535 bytes
>       netfilter: nft_meta_bridge: add validate callback for get operations
>       netfilter: nft_flow_offload: zero device address for non-ether case
>       netfilter: nf_reject: skip iphdr options when looking for icmp header
>       netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak
> 
> Haoze Xie (1):
>       netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst
> 
> Jozsef Kadlecsik (4):
>       netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types
>       netfilter: ipset: Don't use test_bit() in lockless RCU readers in bitmap types
>       netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
>       netfilter: ipset: make sure gc is properly stopped
> 
> Lorenzo Bianconi (1):
>       netfilter: flowtable: fix and simplify IP6IP6 tunnel handling
> 
> Pablo Neira Ayuso (2):
>       netfilter: nf_conntrack_expect: use conntrack GC to reap expectations
>       netfilter: nf_conntrack_expect: store master_tuple in expectation
> 
> Wyatt Feng (1):
>       netfilter: xt_cluster: reject template conntracks in hash match
> 
>  include/net/netfilter/nf_conntrack_expect.h        |  17 ++-
>  include/net/netfilter/nf_queue.h                   |   1 +
>  include/net/netfilter/nft_meta.h                   |   2 +
>  include/uapi/linux/netfilter/nf_conntrack_common.h |   1 +
>  net/bridge/netfilter/nft_meta_bridge.c             |  23 +++-
>  net/ipv4/netfilter/nf_reject_ipv4.c                |   2 +-
>  net/ipv6/ip6_tunnel.c                              |   7 +
>  net/netfilter/ipset/ip_set_bitmap_gen.h            |   4 +-
>  net/netfilter/ipset/ip_set_bitmap_ip.c             |   2 +-
>  net/netfilter/ipset/ip_set_bitmap_ipmac.c          |   2 +-
>  net/netfilter/ipset/ip_set_bitmap_port.c           |   2 +-
>  net/netfilter/ipset/ip_set_core.c                  |   4 +-
>  net/netfilter/ipset/ip_set_hash_gen.h              |  12 +-
>  net/netfilter/nf_conntrack_broadcast.c             |   1 +
>  net/netfilter/nf_conntrack_core.c                  |  33 ++++-
>  net/netfilter/nf_conntrack_expect.c                | 147 +++++++++++----------
>  net/netfilter/nf_conntrack_h323_main.c             |   4 +-
>  net/netfilter/nf_conntrack_helper.c                |  10 +-
>  net/netfilter/nf_conntrack_netlink.c               |  31 ++---
>  net/netfilter/nf_conntrack_sip.c                   |  13 +-
>  net/netfilter/nf_flow_table_core.c                 |  13 +-
>  net/netfilter/nf_flow_table_ip.c                   |  80 +++--------
>  net/netfilter/nf_flow_table_path.c                 |   4 +-
>  net/netfilter/nf_queue.c                           |  14 ++
>  net/netfilter/nfnetlink.c                          |   7 +
>  net/netfilter/nfnetlink_queue.c                    |   3 +
>  net/netfilter/nft_ct.c                             |   3 +-
>  net/netfilter/nft_meta.c                           |   5 +-
>  net/netfilter/nft_payload.c                        |  16 ++-
>  net/netfilter/xt_cluster.c                         |   2 +-
>  .../selftests/net/netfilter/nft_flowtable.sh       |   8 +-
>  31 files changed, 268 insertions(+), 205 deletions(-)
> 
