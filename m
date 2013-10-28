From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC PATCH 0/2 nf_tables] 32/64/128-bits word addressing in nf_tables
Date: Mon, 28 Oct 2013 13:59:37 +0100
Message-ID: <1382965180-9400-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49939 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756409Ab3J1M7s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:59:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a preliminary patchset to allow nf_tables to address registers
at 32/64/128 bits word size. This is something that Patrick and I have
been discussing for a while.

The proposed approach in this patchset adds the new register addressing
to the nf_tables core, the overlapping register approach describe in
patch 1/2 is backward compatible.

Still missing a kernel patch to allow set elements higher than 128 bits,
so we can have concatenations including IPv6 addresses, but that limitation
should be easy to remove. Explicit set type selection is also required,
currently, it is selecting the rb-tree set type here, which is suboptimal.

Comments welcome.

Pablo Neira Ayuso (2):
  netfilter: nf_tables: allow 32/64/128-bits register addressing
  netfilter: nf_tables: round to 32 bits in payload operations

 include/net/netfilter/nf_tables.h        |   16 +++++-
 include/uapi/linux/netfilter/nf_tables.h |   35 ++++++++++++-
 net/netfilter/nf_tables_api.c            |    4 +-
 net/netfilter/nf_tables_core.c           |   81 +++++++++++++++++++++++-------
 net/netfilter/nft_bitwise.c              |   10 ++--
 net/netfilter/nft_byteorder.c            |   10 ++--
 net/netfilter/nft_cmp.c                  |    8 +--
 net/netfilter/nft_compat.c               |   16 +++---
 net/netfilter/nft_ct.c                   |   35 +++++++------
 net/netfilter/nft_exthdr.c               |    9 ++--
 net/netfilter/nft_hash.c                 |   13 +++--
 net/netfilter/nft_immediate.c            |    5 +-
 net/netfilter/nft_limit.c                |    5 +-
 net/netfilter/nft_log.c                  |    3 +-
 net/netfilter/nft_lookup.c               |    9 ++--
 net/netfilter/nft_meta.c                 |   37 +++++++-------
 net/netfilter/nft_nat.c                  |   27 +++++-----
 net/netfilter/nft_payload.c              |    9 ++--
 net/netfilter/nft_rbtree.c               |    5 +-
 19 files changed, 207 insertions(+), 130 deletions(-)

-- 
1.7.10.4

