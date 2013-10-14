From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables-kernel PATCH 0/7] API minor fixes and improvement proposals
Date: Mon, 14 Oct 2013 15:46:49 +0300
Message-ID: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab3JNMrD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:47:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, 

First 2 minor fixes:
-------------------

patch 1: don't know why I messed up here in my previous documentation patch, my mistake anyway.
patch 2: an old left-over. Why has priv->len been corrupted before?

And 5 proposals:
---------------

patch 3: Let's expose table's usage (so user might decide if it's worth dumping table's content, it can useful info finally)

patch 4: That one is debatable: NFTA_CHAIN_USE is - imho - not enough self-explanatory.
NFTA_CHAIN_REFS (or NFTA_CHAIN_REFERENCES?) is much better. If there is a time to change such minor details, it's now or never.

patch 5: add a meta key to get dev->addr_len

patch 6: add lshift/rshift to bitwise expression. It's a first shot, which should work pretty well already. Maybe there are improvments which could be done, depending on data length (2 or 4: we could cast to u64 thus reducing shifts by 2).
	At least I tried to keep the API sane, and c/p the byteorder way. sreg, dreg, op, len, mask are mandatory. xor and shift are related to the selected op.

patch 7: patch's commit message says all.

Tomasz Bursztyka (7):
  netfilter: nf_tables: Fix API documentation on a missing part
  netfilter: nf_tables: Use byteorder operands length relevantly
  netfilter: nf_tables: Expose the table's chain usage to the netlink
    API
  netfilter: nf_tables: Use a semantically relevant name on chain's refs
  netfilter: nf_tables: Add a meta key to get the device address length
  netfilter: nf_tables: Add left and right shifts to bitwise expression
  netfilter: nf_tables: Improve payload expression for an extra offset

 include/net/netfilter/nf_tables_core.h   |  1 +
 include/uapi/linux/netfilter/nf_tables.h | 42 +++++++++++++++++--
 net/netfilter/nf_tables_api.c            |  5 ++-
 net/netfilter/nf_tables_core.c           |  6 ++-
 net/netfilter/nft_bitwise.c              | 70 +++++++++++++++++++++++++++-----
 net/netfilter/nft_byteorder.c            |  2 -
 net/netfilter/nft_meta.c                 | 12 +++++-
 net/netfilter/nft_payload.c              | 25 +++++++++---
 8 files changed, 136 insertions(+), 27 deletions(-)

-- 
1.8.3.2

