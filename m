From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/10] new transaction infrastructure for nf_tables (v3)
Date: Fri,  4 Apr 2014 15:48:04 +0200
Message-ID: <1396619294-26212-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48504 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbaDDNsa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:48:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

This patchset contains updates to the transaction infrastructure and a new
batch API to userspace to include table, chain, set and set element in one
single batch updates.

This helps to:

* speed up updates since we save many netlink messages between kernel and
  userspace and this also improves several batch loading error cases.

* leave things in consistent state if we have to abort a batch in the middle
  of the processing. We don't leave any of the objects in intermediate state
  if we hit a problem in the middle of the batch handling.

Basically, the idea is to allocate a transaction object (struct nft_trans)
which contains the context of the request, the command type and specific
information which depends on the transaction command type. These transaction
objects are added to the per-netns commit list. The batch and transaction
processing is done in two steps:

1) Batch processing, which consists of digesting the batch, updating objects
   (table, chains, etc.) in the nf_tables database and feeding the commit
   list with transaction objects. New objects are left in inactive state
   whenever possible or added to the list in a speculative fashion that we
   can easily undo. Since the batch processing may fail, we can call the
   abort procedure to unroll changes and leave things in consistent state,
   ie. just like they were before we failed to update things.

2) Transaction processing, which consists of activating the objects and
   deliver netlink events to userspace, also known as the commit routine.
   The transaction objects are also released in this stage.

The patchset includes userspace changes that allow new versions of nft to
operate with the with old and new nf_tables kernels. This means that old nft
binaries (ie. 0.099) will not work after this change unless we add some glue
code to the kernel. However, I don't find a good reason why someone would be
willing to stick to nft-0.099 at this moment, it contains many bugs that we
will be resolved in the upcoming version and we also changed some semantic
aspects in the upcoming version. If there is someone really willing to stick
to nft-0.099 for some reason, I can send patches to add the compatibility code
to the kernel.

Changes with v2:

* Generalise the transaction object to allocate variable length private
  area depending on the object type.

* Include the set element transactions (patch 10/10).

* Fix named set handling.

Pablo Neira Ayuso (10):
  netfilter: nf_tables: deconstify table and chain in context structure
  netfilter: nf_tables: generalise transaction infrastructure
  netfilter: nf_tables: relocate commit and abort routines in the source file
  netfilter: nf_tables: add message type to transactions
  netfilter: nf_tables: use new transaction infrastructure to handle sets
  netfilter: nf_tables: use new transaction infrastructure to handle chain
  netfilter: nf_tables: disabling table hooks always succeeds
  netfilter: nf_tables: pass context to nf_tables_uptable
  netfilter: nf_tables: use new transaction infrastructure to handle table
  netfilter: nf_tables: use new transaction infrastructure to handle elements

 include/net/netfilter/nf_tables.h        |   72 ++-
 include/uapi/linux/netfilter/nf_tables.h |    6 +
 net/netfilter/nf_tables_api.c            |  941 +++++++++++++++++++++---------
 net/netfilter/nft_lookup.c               |   10 +-
 4 files changed, 756 insertions(+), 273 deletions(-)

-- 
1.7.10.4

