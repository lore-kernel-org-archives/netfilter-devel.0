From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/04]: nf_conntrack: fix ct_extend ->move operation
Date: Wed,  6 Feb 2008 14:34:02 +0100 (MET)
Message-ID: <20080206133401.15303.81869.sendpatchset@localhost.localdomain>
References: <20080206133359.15303.62098.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54118 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763037AbYBFNeD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:34:03 -0500
In-Reply-To: <20080206133359.15303.62098.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: fix ct_extend ->move operation

The ->move operation has two bugs:

- It is called with the same extension as source and destination,
  so it doesn't update the new extension.

- The address of the old extension is calculated incorrectly,
  instead of (void *)ct->ext + ct->ext->offset[i] it uses
  ct->ext + ct->ext->offset[i].

Fixes a crash on x86_64 reported by Chuck Ebbert <cebbert@redhat.com>
and Thomas Woerner <twoerner@redhat.com>.

Tested-by: Thomas Woerner <twoerner@redhat.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9f2e0b6690028db2397bee5d50aaaea0e3993f7a
tree 2eea2d069b5bc8c880c17ad40d2afd1774cdd418
parent e57c5fa967bbd2afcd57f902b32d7037f1030932
author Patrick McHardy <kaber@trash.net> Wed, 06 Feb 2008 02:51:14 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 06 Feb 2008 02:51:14 +0100

 include/net/netfilter/nf_conntrack_extend.h |    2 +-
 net/ipv4/netfilter/nf_nat_core.c            |    6 +++---
 net/netfilter/nf_conntrack_extend.c         |    3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 73b5711..49aac63 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -67,7 +67,7 @@ struct nf_ct_ext_type
 	void (*destroy)(struct nf_conn *ct);
 	/* Called when realloacted (can be NULL).
 	   Contents has already been moved. */
-	void (*move)(struct nf_conn *ct, void *old);
+	void (*move)(void *new, void *old);
 
 	enum nf_ct_ext_id id;
 
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index dd07362..0d5fa3a 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -600,10 +600,10 @@ static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 	spin_unlock_bh(&nf_nat_lock);
 }
 
-static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
+static void nf_nat_move_storage(void *new, void *old)
 {
-	struct nf_conn_nat *new_nat = nf_ct_ext_find(conntrack, NF_CT_EXT_NAT);
-	struct nf_conn_nat *old_nat = (struct nf_conn_nat *)old;
+	struct nf_conn_nat *new_nat = new;
+	struct nf_conn_nat *old_nat = old;
 	struct nf_conn *ct = old_nat->ct;
 
 	if (!ct || !(ct->status & IPS_NAT_DONE_MASK))
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index cf6ba66..8b9be1e 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -109,7 +109,8 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 			rcu_read_lock();
 			t = rcu_dereference(nf_ct_ext_types[i]);
 			if (t && t->move)
-				t->move(ct, ct->ext + ct->ext->offset[i]);
+				t->move((void *)new + new->offset[i],
+					(void *)ct->ext + ct->ext->offset[i]);
 			rcu_read_unlock();
 		}
 		kfree(ct->ext);
