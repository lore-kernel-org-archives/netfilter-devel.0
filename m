From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 41/41]: nf_conntrack: fix incorrect check for expectations
Date: Mon, 14 Apr 2008 12:17:14 +0200 (MEST)
Message-ID: <20080414101711.32717.56129.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36375 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbYDNKRQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:17:16 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: fix incorrect check for expectations

The expectation classes changed help->expectations to an array,
fix use as scalar value.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit db7ae928e7d2fbaea2f3c438d92f1af05963d221
tree 35d4fb46a9dc145e831fe5da026f2bfd9ee6657c
parent 7649b4aade16e08fc9024467d5bfdfc885425961
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:57 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:57 +0200

 net/netfilter/nf_conntrack_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3512373..4eac65c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -766,7 +766,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 	nf_ct_dump_tuple(newreply);
 
 	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-	if (ct->master || (help && help->expecting != 0))
+	if (ct->master || (help && !hlist_empty(&help->expectations)))
 		return;
 
 	rcu_read_lock();
