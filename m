Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 651DDEC5;
	Thu, 22 Aug 2024 22:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724365191; cv=none; b=ot58+ZQCEDaxBZzmAnKEfin1sotG0UoTpj/lrbthovPZcVzThPaQGB++VIq4/JlHRb4tHEhcYzCNfujUqCssPnmw7wWtu3203t6KVmwQXLfb4x7IK/CnGdodsOINYB3d0WOrymOuwAd5mkNm3xJHRU2f62dgtMeKEXy3ZQ/rJe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724365191; c=relaxed/simple;
	bh=bvKXhIPH4XSxDxhKsbl13VXICBG4mXNHJB1McYEY3po=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pnP4AG/4Cq5MewNbvRC4tr5rsBUmLYlCG84jnboZMemqg/E8XeXx5Pjt7G+jnsa4jMx6Wl+Cz8J95IbiZY09qoCGofeBAdluUrhouwvLTv1SIaNLaa9FT6sa266vBHwIXdG7RrxRLnH7BhK9zu6rShs/DtPzplpmcDw3x9H3ohk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 0/9] Netfilter updates for net-next
Date: Fri, 23 Aug 2024 00:19:30 +0200
Message-Id: <20240822221939.157858-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains Netfilter updates for net-next:

Patch #1 fix checksum calculation in nfnetlink_queue with SCTP,
	 segment GSO packet since skb_zerocopy() does not support
	 GSO_BY_FRAGS, from Antonio Ojea.

Patch #2 extend nfnetlink_queue coverage to handle SCTP packets,
	 from Antonio Ojea.

Patch #3 uses consume_skb() instead of kfree_skb() in nfnetlink,
         from Donald Hunter.

Patch #4 adds a dedicate commit list for sets to speed up
	 intra-transaction lookups, from Florian Westphal.

Patch #5 skips removal of element from abort path for the pipapo
         backend, ditching the shadow copy of this datastructure
	 is sufficient.

Patch #6 moves nf_ct_netns_get() out of nf_conncount_init() to
	 let users of conncoiunt decide when to enable conntrack,
	 this is needed by openvswitch, from Xin Long.

Patch #7 pass context to all nft_parse_register_load() in
	 preparation for the next patch.

Patches #8 and #9 reject loads from uninitialized registers from
	 control plane to remove register initialization from
	 datapath. From Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-24-08-23

Thanks.

----------------------------------------------------------------

The following changes since commit 1bf8e07c382bd4f04ede81ecc05267a8ffd60999:

  dt-binding: ptp: fsl,ptp: add pci1957,ee02 compatible string for fsl,enetc-ptp (2024-08-19 09:48:53 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-24-08-23

for you to fetch changes up to c88baabf16d1ef74ab8832de9761226406af5507:

  netfilter: nf_tables: don't initialize registers in nft_do_chain() (2024-08-20 12:37:25 +0200)

----------------------------------------------------------------
netfilter pull request 24-08-23

----------------------------------------------------------------
Antonio Ojea (2):
      netfilter: nfnetlink_queue: unbreak SCTP traffic
      selftests: netfilter: nft_queue.sh: sctp coverage

Donald Hunter (1):
      netfilter: nfnetlink: convert kfree_skb to consume_skb

Florian Westphal (4):
      netfilter: nf_tables: store new sets in dedicated list
      netfilter: nf_tables: pass context structure to nft_parse_register_load
      netfilter: nf_tables: allow loads only when register is initialized
      netfilter: nf_tables: don't initialize registers in nft_do_chain()

Pablo Neira Ayuso (1):
      netfilter: nf_tables: do not remove elements if set backend implements .abort

Xin Long (1):
      netfilter: move nf_ct_netns_get out of nf_conncount_init

 include/net/netfilter/nf_conntrack_count.h         |  6 +-
 include/net/netfilter/nf_tables.h                  |  6 +-
 net/bridge/netfilter/nft_meta_bridge.c             |  2 +-
 net/core/dev.c                                     |  1 +
 net/ipv4/netfilter/nft_dup_ipv4.c                  |  4 +-
 net/ipv6/netfilter/nft_dup_ipv6.c                  |  4 +-
 net/netfilter/nf_conncount.c                       | 15 +---
 net/netfilter/nf_tables_api.c                      | 75 +++++++++++++++----
 net/netfilter/nf_tables_core.c                     |  2 +-
 net/netfilter/nfnetlink.c                          | 14 ++--
 net/netfilter/nfnetlink_queue.c                    | 12 ++-
 net/netfilter/nft_bitwise.c                        |  4 +-
 net/netfilter/nft_byteorder.c                      |  2 +-
 net/netfilter/nft_cmp.c                            |  6 +-
 net/netfilter/nft_ct.c                             |  2 +-
 net/netfilter/nft_dup_netdev.c                     |  2 +-
 net/netfilter/nft_dynset.c                         |  4 +-
 net/netfilter/nft_exthdr.c                         |  2 +-
 net/netfilter/nft_fwd_netdev.c                     |  6 +-
 net/netfilter/nft_hash.c                           |  2 +-
 net/netfilter/nft_lookup.c                         |  2 +-
 net/netfilter/nft_masq.c                           |  4 +-
 net/netfilter/nft_meta.c                           |  2 +-
 net/netfilter/nft_nat.c                            |  8 +-
 net/netfilter/nft_objref.c                         |  2 +-
 net/netfilter/nft_payload.c                        |  2 +-
 net/netfilter/nft_queue.c                          |  2 +-
 net/netfilter/nft_range.c                          |  2 +-
 net/netfilter/nft_redir.c                          |  4 +-
 net/netfilter/nft_tproxy.c                         |  4 +-
 net/netfilter/xt_connlimit.c                       | 15 +++-
 net/openvswitch/conntrack.c                        |  5 +-
 tools/testing/selftests/net/netfilter/config       |  2 +
 tools/testing/selftests/net/netfilter/nft_queue.sh | 85 +++++++++++++++++++++-
 34 files changed, 226 insertions(+), 84 deletions(-)
