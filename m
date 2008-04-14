From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 29/41]: nf_conntrack_extend: warn on confirmed conntracks
Date: Mon, 14 Apr 2008 12:16:58 +0200 (MEST)
Message-ID: <20080414101654.32717.44350.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36328 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbYDNKQ7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:59 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_extend: warn on confirmed conntracks

New extensions may only be added to unconfirmed conntracks to avoid races
when reallocating the storage.

Also change NF_CT_ASSERT to use WARN_ON to get backtraces.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b2a3c0b71517472b86ecb38cbf30fbdd1b27eb95
tree 9c394ddf15e28d19d903dc82205854dd36480aea
parent 6cad3b7ff5971feef96758c159ee689ab14118ee
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:54 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:54 +0200

 include/net/netfilter/nf_conntrack.h |    9 +--------
 net/netfilter/nf_conntrack_extend.c  |    3 +++
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index bb9fc85..4a0496a 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -65,14 +65,7 @@ union nf_conntrack_help {
 #include <linux/timer.h>
 
 #ifdef CONFIG_NETFILTER_DEBUG
-#define NF_CT_ASSERT(x)							\
-do {									\
-	if (!(x))							\
-		/* Wooah!  I'm tripping my conntrack in a frenzy of	\
-		   netplay... */					\
-		printk("NF_CT_ASSERT: %s:%i(%s)\n",			\
-		       __FILE__, __LINE__, __FUNCTION__);		\
-} while(0)
+#define NF_CT_ASSERT(x)		WARN_ON(!(x))
 #else
 #define NF_CT_ASSERT(x)
 #endif
diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index 2bd9963..bcc19fa 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -71,6 +71,9 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	int i, newlen, newoff;
 	struct nf_ct_ext_type *t;
 
+	/* Conntrack must not be confirmed to avoid races on reallocation. */
+	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
+
 	if (!ct->ext)
 		return nf_ct_ext_create(&ct->ext, id, gfp);
 
