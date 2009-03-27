From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/5] netfilter: conntrack: use nf_ct_kill() to destroy
	conntracks
Date: Fri, 27 Mar 2009 10:39:25 +0100
Message-ID: <20090327093925.8259.69472.stgit@Decadence>
References: <20090327093822.8259.50902.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47512 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754616AbZC0Jjc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:39:32 -0400
In-Reply-To: <20090327093822.8259.50902.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch replaces several direct del_timer() and destroy callback
invocation by nf_ct_kill() which does the same. This patch is a
cleanup.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_core.c |    8 ++------
 net/netfilter/nf_conntrack_pptp.c |    3 +--
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 342ea30..188090f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -455,8 +455,7 @@ static noinline int early_drop(struct net *net, unsigned int hash)
 	if (!ct)
 		return dropped;
 
-	if (del_timer(&ct->timeout)) {
-		death_by_timeout((unsigned long)ct);
+	if (nf_ct_kill(ct)) {
 		dropped = 1;
 		NF_CT_STAT_INC_ATOMIC(net, early_drop);
 	}
@@ -964,10 +963,7 @@ void nf_ct_iterate_cleanup(struct net *net,
 
 	while ((ct = get_next_corpse(net, iter, data, &bucket)) != NULL) {
 		/* Time to push up daises... */
-		if (del_timer(&ct->timeout))
-			death_by_timeout((unsigned long)ct);
-		/* ... else the timer will get him soon. */
-
+		nf_ct_kill(ct);
 		nf_ct_put(ct);
 	}
 }
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 72cca63..5ca1780 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -152,8 +152,7 @@ static int destroy_sibling_or_exp(struct net *net,
 		pr_debug("setting timeout of conntrack %p to 0\n", sibling);
 		sibling->proto.gre.timeout	  = 0;
 		sibling->proto.gre.stream_timeout = 0;
-		if (del_timer(&sibling->timeout))
-			sibling->timeout.function((unsigned long)sibling);
+		nf_ct_kill(sibling);
 		nf_ct_put(sibling);
 		return 1;
 	} else {

