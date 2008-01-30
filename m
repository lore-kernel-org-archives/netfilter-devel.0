From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 44/69]: nf_conntrack: don't inline early_drop()
Date: Wed, 30 Jan 2008 21:18:02 +0100 (MET)
Message-ID: <20080130201759.29874.96930.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60743 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765152AbYA3USE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:04 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: don't inline early_drop()

early_drop() is only called *very* rarely, unfortunately gcc inlines it
into the hotpath because there is only a single caller. Explicitly mark
it noinline.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9dcd796f052a9383e55d81e7da5912e0a6cd4b19
tree 6ad978cd8fb12dd20a265eec3a42d75d874a5aff
parent 7b2624034f45ce13ecfdf13847cbf7ad67bb7137
author Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:08 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:08 +0100

 net/netfilter/nf_conntrack_core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 24a0863..fabc9eb 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -420,7 +420,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_tuple_taken);
 
 /* There's a small race here where we may free a just-assured
    connection.  Too bad: we're in trouble anyway. */
-static int early_drop(unsigned int hash)
+static noinline int early_drop(unsigned int hash)
 {
 	/* Use oldest entry, which is roughly LRU */
 	struct nf_conntrack_tuple_hash *h;
@@ -472,8 +472,8 @@ struct nf_conn *nf_conntrack_alloc(const struct nf_conntrack_tuple *orig,
 	/* We don't want any race condition at early drop stage */
 	atomic_inc(&nf_conntrack_count);
 
-	if (nf_conntrack_max
-	    && atomic_read(&nf_conntrack_count) > nf_conntrack_max) {
+	if (nf_conntrack_max &&
+	    unlikely(atomic_read(&nf_conntrack_count) > nf_conntrack_max)) {
 		unsigned int hash = hash_conntrack(orig);
 		if (!early_drop(hash)) {
 			atomic_dec(&nf_conntrack_count);
