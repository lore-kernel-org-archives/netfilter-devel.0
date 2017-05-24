From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 0/9] nf_tables set updates
Date: Wed, 24 May 2017 11:50:44 +0200
Message-ID: <1495619453-22307-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41138 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936372AbdEXJvF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 05:51:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2DC5B1EC2C2
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:50:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E722100A6E
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:50:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF69BFF137
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 11:50:54 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The following patchset contains updates for the nf_tables set
infrastructure, specifically new infrastructure to select between
several set backend operation of one single type, a new fixed hashtable
set implementation and general performance improvements for the
hashtable set type:

1) Remove unnecessary forward declaration in nft_set_hash.

2) Do not lie to the set backend selection algorithm. If we don't know the
   number of set elements, we cannot provide any size. We now have the
   memory scalability notation to use it in this case.

3) Rename nft_hash_ to nft_rhash_ for the resizable hash implementation.

4) Pass set description to ->privsize, this is required by the new fixed
   size hashtable implementation.

5) Add nft_hash_buckets() helper function to calculate the number of
   hashtable buckets both for fixed and resizable hashtables.

6) Add infrastructure to select between several set backend variants,
   so we can accomodate the fixed hashtable implementation in the
   nf_tables hashtable set type.

7) Allow large allocation for new sets, the fixed size hashtable places
   the bucket array in a flexible array, and its size may trigger memory
   allocation failures via kmalloc(), thus, fall back to vmalloc().

8) Add faster fixed size hashtable implementation. ~10% faster than the
   resizable hashtable, and this is just ~200 lines of code of a very
   simple hashtable implementation.

9) Add faster 2-byte and 4-byte lookup function for fixed hashtable,
   using the new set operation selection infrastructure.

Pablo Neira Ayuso (9):
  netfilter: nft_set_hash: unnecessary forward declaration
  netfilter: nf_tables: no size estimation if number of set elements is unknown
  netfilter: nft_set_hash: use nft_rhash prefix for resizable set backend
  netfilter: nf_tables: select set backend flavour depending on description
  netfilter: nf_tables: pass set description to ->privsize
  netfilter: nft_set_hash: add nft_hash_buckets()
  netfilter: nf_tables: allow large allocations for new sets
  netfilter: nft_set_hash: add non-resizable hashtable implementation
  netfilter: nft_set_hash: add lookup variant for fixed size hashtable

 include/net/netfilter/nf_tables.h |  29 ++-
 net/netfilter/nf_tables_api.c     |  80 ++++---
 net/netfilter/nft_set_bitmap.c    |  13 +-
 net/netfilter/nft_set_hash.c      | 471 +++++++++++++++++++++++++++++---------
 net/netfilter/nft_set_rbtree.c    |  21 +-
 5 files changed, 457 insertions(+), 157 deletions(-)

-- 
2.1.4

