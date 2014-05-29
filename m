From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nftables 0/4] more transaction updates
Date: Thu, 29 May 2014 11:48:23 +0200
Message-ID: <1401356907-6840-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45811 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792AbaE2Jsi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 05:48:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset contains updates for the new transaction infrastructure,
they are:

* Make sure that this releases objects in reverse order in the abort path
  to avoid possible use after free. No need the reverse iteration this in
  the commit path since they already come in the right order according
  to object dependencies.

* Introduce locking to the rbtree that is used for interval sets.

* Allow to delete several objects using a batch, this updates the use
  counter semantics applying the following rules:

  1) If you add/delete a chain, it increments/decrements the table use counter.
  2) If you add/delete a rule, it increments/decrements the chain use counter.
  3) If you add/delete a set, it increments/decrements the table use counter.
  4) If you bind an anonymous set to a rule, it decrements the table use
     counter. This avoids an -EBUSY error since bound anonymous sets are
     released quite late in the commit/abort path, from the rcu callback. This
     should be safe since the rule updated the chain use counter, so it is not
     possible to remove a table with bound anonymous sets. This rules does not
     apply to unbound anonymous sets.

* Use atomic memory allocations in the anonymous set notification path from
  the rcu callback.

Pablo Neira Ayuso (4):
  netfilter: nf_tables: release objects in reverse order in the abort path
  netfilter: nf_rbtree: introduce locking
  netfilter: nf_tables: allow to delete several objects from a batch
  netfilter: nf_tables: atomic allocation in set notifications from rcu callback

 net/netfilter/nf_tables_api.c |   55 +++++++++++++++++++++++++++++------------
 net/netfilter/nft_rbtree.c    |   22 ++++++++++++++++-
 2 files changed, 60 insertions(+), 17 deletions(-)

-- 
1.7.10.4

