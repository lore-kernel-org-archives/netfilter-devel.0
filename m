From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/11] new transaction infrastructure for nf_tables (v4)
Date: Wed,  9 Apr 2014 20:36:01 +0200
Message-ID: <1397068572-3916-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59202 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933440AbaDISgW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:36:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

A new round of the new transaction infrastructure patches for nf_tables,
main changes from the previous version are:

* In patch 11/11 ("use new transaction infrastructure to handle elements"),
  the abort path has been simplified.

* The patch 6/11 ("netfilter: nf_tables: refactor chain statistic routines")
  is new in this stack, it basically reworks the chain counters so the
  follow up patch 7/11 to introduce chain transaction becomes smaller.

Comments welcome.

Pablo Neira Ayuso (11):
  netfilter: nf_tables: deconstify table and chain in context structure
  netfilter: nf_tables: generalise transaction infrastructure
  netfilter: nf_tables: relocate commit and abort routines in the  source file
  netfilter: nf_tables: add message type to transactions
  netfilter: nf_tables: use new transaction infrastructure to handle sets
  netfilter: nf_tables: refactor chain statistic routines
  netfilter: nf_tables: use new transaction infrastructure to handle chain
  netfilter: nf_tables: disabling table hooks always succeeds
  netfilter: nf_tables: pass context to nf_tables_uptable
  netfilter: nf_tables: use new transaction infrastructure to handle table
  netfilter: nf_tables: use new transaction infrastructure to handle elements

 include/net/netfilter/nf_tables.h        |   72 ++-
 include/uapi/linux/netfilter/nf_tables.h |    6 +
 net/netfilter/nf_tables_api.c            |  923 +++++++++++++++++++++---------
 net/netfilter/nft_lookup.c               |   10 +-
 4 files changed, 737 insertions(+), 274 deletions(-)

-- 
1.7.10.4

