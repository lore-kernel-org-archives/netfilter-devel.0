From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 36/69]: nf_conntrack_core: avoid taking nf_conntrack_lock in nf_conntrack_alter_reply
Date: Wed, 30 Jan 2008 21:17:50 +0100 (MET)
Message-ID: <20080130201748.29874.74328.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60736 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbYA3URw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:52 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_core: avoid taking nf_conntrack_lock in nf_conntrack_alter_reply

The conntrack is unconfirmed, so we have an exclusive reference, which means
that the write_lock is definitely unneeded. A read_lock used to be needed
for the helper lookup, but since we're using RCU for helpers now rcu_read_lock
is enough.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 23cf79fc3f39291ad9e98a00584d1f0c0b8c5d25
tree 6b4f9cb8b2e0cb7dff253b256ee392e018add46a
parent 4e4ce3f8b47acaf70dc99ce8c50fe64e4f1a098f
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:11 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:06 +0100

 net/netfilter/nf_conntrack_core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index aa042c4..1025607 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -729,7 +729,6 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 	struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_helper *helper;
 
-	write_lock_bh(&nf_conntrack_lock);
 	/* Should be unconfirmed, so not in hash table yet */
 	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
 
@@ -738,8 +737,9 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 
 	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
 	if (ct->master || (help && help->expecting != 0))
-		goto out;
+		return;
 
+	rcu_read_lock();
 	helper = __nf_ct_helper_find(newreply);
 	if (helper == NULL) {
 		if (help)
@@ -757,7 +757,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 
 	rcu_assign_pointer(help->helper, helper);
 out:
-	write_unlock_bh(&nf_conntrack_lock);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
 
