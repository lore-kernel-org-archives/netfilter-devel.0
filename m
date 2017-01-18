From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 0/7] nf_tables set enhancements
Date: Wed, 18 Jan 2017 18:30:06 +0100
Message-ID: <1484760613-17236-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752551AbdARRaX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 12:30:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D0D1D1392A2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4D3BFF126
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7595EA8257
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 18:30:17 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The following patches contains enhancements for the set infrastructure:

1) Introduce memory scalability notation for sets, this is useful in
   case that userspace provides no explicit number of elements for this
   set and to break ties if the set selection routine finds two backends
   providing similar runtime performance which is now possible with hash
   and the new bitmap set type.

2) Add new bitmap set type that represents an element using two bits.  In
   order to reduce memory consumption, this set type is selected if the key
   size is smaller than 16 bit. For 8 bit keys, the bitmap consumes 66
   bytes. For 16 bit keys, the bitmap takes 16388 bytes.

Comments welcome, thanks.

Pablo Neira Ayuso (7):
  netfilter: nf_tables: pass netns to set->ops->remove()
  netfilter: nf_tables: use struct nft_set_iter in set element flush
  netfilter: nf_tables: rename deactivate_one() to flush()
  netfilter: nf_tables: add flush field to struct nft_set_iter
  netfilter: nf_tables: rename struct nft_set_estimate class field
  netfilter: nf_tables: add space notation to sets
  netfilter: nf_tables: add bitmap set type

 include/net/netfilter/nf_tables.h |  18 ++-
 net/netfilter/Kconfig		   |   6 +
 net/netfilter/Makefile		   |   1 +
 net/netfilter/nf_tables_api.c	   |  49 +++---
 net/netfilter/nft_set_bitmap.c    | 314 ++++++++++++++++++++++++++++++++++++++
 net/netfilter/nft_set_hash.c	   |  14 +-
 net/netfilter/nft_set_rbtree.c    |  14 +-
 7 files changed, 378 insertions(+), 38 deletions(-)
 create mode 100644 net/netfilter/nft_set_bitmap.c

--
2.1.4

