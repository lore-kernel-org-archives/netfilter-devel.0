From: pablo@netfilter.org
Subject: [PATCH] [RFC] nf_tables: dormant tables
Date: Tue, 13 Nov 2012 17:33:18 +0100
Message-ID: <1352824399-3641-1-git-send-email-pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48418 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab2KMQdj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:33:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi,

The following patch adds the concept of dormant tables. Basically,
it's a flag that you can set to get a table (and all they chains)
inactive. Dormant tables have no effect and see no traffic.

This operation can be also used to support atomic replacement
at chain level, that can be done following these steps:

1) set table as dormant
2) flush the rule-set in all their chains
3) add the new rule-set
4) set table as active

The main target of this patch is to provide a way to load the
rule-set in a chain at once, avoiding possible some inconsistent
state at the chain level.

Coments welcome.

Pablo Neira Ayuso (1):
  netfilter: nf_tables: add support for dormant tables

 include/linux/netfilter/nf_tables.h |   10 ++++
 include/net/netfilter/nf_tables.h   |    2 +
 net/netfilter/nf_tables_api.c       |   90 +++++++++++++++++++++++++++++++++--
 3 files changed, 98 insertions(+), 4 deletions(-)

-- 
1.7.10.4

