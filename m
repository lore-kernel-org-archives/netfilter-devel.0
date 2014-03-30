From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/8] new transaction infrastructure for nf_tables (v2)
Date: Sun, 30 Mar 2014 14:04:46 +0200
Message-ID: <1396181094-8140-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45385 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbaC3MFE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Mar 2014 08:05:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset contains updates to the transaction infrastructure and a new
batch API to userspace for updating tables, chains and sets. Basically, it
generalises the existing rule batching so we can also include sets, chains
and tables in one single batch.

This helps to:

* speed up updates since we save many netlink messages between kernel and
  userspace and this also improves several batch loading error cases.

* leave things in consistent state if we have to abort a batch in the middle
  of the processing.

The patchset includes userspace changes that allow new versions of nft to
operate with the with old and new nf_tables kernels. This means that old nft
binaries (ie. 0.099) will not work after this change unless we add some glue
code to the kernel. However, I don't find a good reason why someone would be
willing to stick to nft-0.099 at this moment, it contains many bugs that we
will be resolved in the upcoming version and we also changed some semantic
aspects in the upcoming version. If there is someone really willing to stick
to nft-0.099 for some reason, I can send patches to add the compatibility code
to the kernel.

Changes with v1:

* Simplify the approach by adding a new message type to the transaction and
  by early addition/deletion of objects from the lists, then undo that in the
  abort step if needed. Based on suggestions from Patrick.

* Chain counter, rename and policy updates happen in an all or nothing
  fashion, so the chain is left in consistent state if we have to abort.

* The table configuration are also left in consistent state if we have to
  abort.

Pablo Neira Ayuso (8):
  netfilter: nf_tables: generalise transaction infrastructure
  netfilter: nf_tables: relocate commit and abort routines in the source file
  netfilter: nf_tables: add message type to transactions
  netfilter: nf_tables: move set handling to the transaction infrastructure
  netfilter: nf_tables: move chain handling to the transaction infrastructure
  netfilter: nf_tables: disabling table hooks always succeeds
  netfilter: nf_tables: pass context to nf_tables_uptable
  netfilter: nf_tables: move table handling to the transaction infrastructure

 include/net/netfilter/nf_tables.h        |   28 +-
 include/uapi/linux/netfilter/nf_tables.h |    6 +
 net/netfilter/nf_tables_api.c            |  788 ++++++++++++++++++++++--------
 net/netfilter/nft_lookup.c               |   10 +-
 4 files changed, 610 insertions(+), 222 deletions(-)

-- 
1.7.10.4

