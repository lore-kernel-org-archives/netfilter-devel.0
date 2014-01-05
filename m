From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/3 nftables RFC] set infrastructure updates
Date: Sun,  5 Jan 2014 22:18:45 +0100
Message-ID: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52010 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaAEVS7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:18:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The following patchset contains three updates for the set
infrastructure in nf_tables, they are:

1) Fix suboptimal set selection. In my testbed, all anonymous/constant sets
   are being created via the rb-tree set type, which is not optimal. To
   resolve this problem I have added a priority field, so in case that we
   find several set types that are suitable for the features that are
   requested. As a result, the hash is prefered to the rb-tree set type
   whenever possible.

2) Limit maximum number of elements per sets: Currently we have no way to set
   this limit. This adds two new netlink attributes, one to set the maximum
   number of elements and another to return the current number of elements
   per sets. The default maximum size is set to 1024, thus, the hashtable
   array consumes 16 KBytes in x86_64.

3) Calculate the number of buckets in the hash set based on the maximum
   number of elements to achieve a load factor of .75. For anonymous/constant
   sets, the maximum element number that nft specifies is exactly the amount
   of elements that the set contains to optimize memory consumption.

In this direction, by adding more specific set descriptions (via a new netlink
attributes that contains configuration information specified by the user) it
should be possible to allow space-time trade-offs for named sets.

Pablo Neira Ayuso (3):
  netfilter: nf_tables: fix suboptimal set selection
  netfilter: nf_tables: limit maximum number of elements
  netfilter: nft_hash: use set->maxelems to calculate number of buckets

 include/net/netfilter/nf_tables.h        |   17 +++++++++++++++++
 include/uapi/linux/netfilter/nf_tables.h |    4 ++++
 net/netfilter/nf_tables_api.c            |   25 ++++++++++++++++++++-----
 net/netfilter/nft_hash.c                 |    5 ++---
 net/netfilter/nft_rbtree.c               |    1 +
 5 files changed, 44 insertions(+), 8 deletions(-)

-- 
1.7.10.4

