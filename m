From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/7] new transaction infrastructure for nf_tables
Date: Thu, 27 Mar 2014 22:53:10 +0100
Message-ID: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49498 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917AbaC0Vxc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:53:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset contains updates to the transaction infrastructure and a new
batch API to userspace to update tables, chains and sets. Basically, it
generalises the existing rule batching so we can also include sets, chains and
tables in one single batch. This helps to speed up updates since we save many
netlink messages between kernel and userspace and this also improves several
batch loading error cases that resulted in inconsistent configurations.

Still, this patchset doesn't address the abortion of chain policy/counter
updates and new set elements addition/removals. Basically, this means that we
don't have atomic set element updates yet, but that wasn't possible with the
former API either.

Pablo Neira Ayuso (7):
  netfilter: nf_tables: deconstify table and chain in context structure
  netfilter: nf_tables: generalise transaction infrastructure
  netfilter: nf_tables: relocate commit and abort routines in the source file
  netfilter: nf_tables: better encapsulation for the rule transaction code
  netfilter: nf_tables: move set handling to the transaction infrastructure
  netfilter: nf_tables: move chain handling to the transaction infrastructure
  netfilter: nf_tables: move table handling to the transaction infrastructure

 include/net/netfilter/nf_tables.h        |   31 +-
 include/uapi/linux/netfilter/nf_tables.h |    6 +
 net/netfilter/nf_tables_api.c            |  830 ++++++++++++++++++++++--------
 net/netfilter/nft_lookup.c               |   15 +-
 4 files changed, 656 insertions(+), 226 deletions(-)

-- 
1.7.10.4

