From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 04/17] netfilter: x_tables: kill check_entry helper
Date: Fri,  1 Apr 2016 14:17:24 +0200
Message-ID: <1459513057-30652-5-git-send-email-fw@strlen.de>
References: <1459513057-30652-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46464 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757135AbcDAMRd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2016 08:17:33 -0400
In-Reply-To: <1459513057-30652-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Once we add more sanity testing to xt_check_entry_offsets it
becomes relvant if we're expecting a 32bit 'config_compat' blob
or a normal one.

Since we already have a lot of similar-named functions (check_entry,
compat_check_entry, find_and_check_entry, etc.) and the current
incarnation is short just fold its contents into the callers.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 19 ++++++++-----------
 net/ipv4/netfilter/ip_tables.c  | 20 ++++++++------------
 net/ipv6/netfilter/ip6_tables.c | 20 ++++++++------------
 3 files changed, 24 insertions(+), 35 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 74668c1..24ad92a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -494,14 +494,6 @@ next:
 	return 1;
 }
 
-static inline int check_entry(const struct arpt_entry *e)
-{
-	if (!arp_checkentry(&e->arp))
-		return -EINVAL;
-
-	return xt_check_entry_offsets(e, e->target_offset, e->next_offset);
-}
-
 static inline int check_target(struct arpt_entry *e, const char *name)
 {
 	struct xt_entry_target *t = arpt_get_target(e);
@@ -597,7 +589,10 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 		return -EINVAL;
 	}
 
-	err = check_entry(e);
+	if (!arp_checkentry(&e->arp))
+		return -EINVAL;
+
+	err = xt_check_entry_offsets(e, e->target_offset, e->next_offset);
 	if (err)
 		return err;
 
@@ -1256,8 +1251,10 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 		return -EINVAL;
 	}
 
-	/* For purposes of check_entry casting the compat entry is fine */
-	ret = check_entry((struct arpt_entry *)e);
+	if (!arp_checkentry(&e->arp))
+		return -EINVAL;
+
+	ret = xt_check_entry_offsets(e, e->target_offset, e->next_offset);
 	if (ret)
 		return ret;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 71c204d..cdf1850 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -588,15 +588,6 @@ static void cleanup_match(struct xt_entry_match *m, struct net *net)
 }
 
 static int
-check_entry(const struct ipt_entry *e)
-{
-	if (!ip_checkentry(&e->ip))
-		return -EINVAL;
-
-	return xt_check_entry_offsets(e, e->target_offset, e->next_offset);
-}
-
-static int
 check_match(struct xt_entry_match *m, struct xt_mtchk_param *par)
 {
 	const struct ipt_ip *ip = par->entryinfo;
@@ -760,7 +751,10 @@ check_entry_size_and_hooks(struct ipt_entry *e,
 		return -EINVAL;
 	}
 
-	err = check_entry(e);
+	if (!ip_checkentry(&e->ip))
+		return -EINVAL;
+
+	err = xt_check_entry_offsets(e, e->target_offset, e->next_offset);
 	if (err)
 		return err;
 
@@ -1516,8 +1510,10 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 		return -EINVAL;
 	}
 
-	/* For purposes of check_entry casting the compat entry is fine */
-	ret = check_entry((struct ipt_entry *)e);
+	if (!ip_checkentry(&e->ip))
+		return -EINVAL;
+
+	ret = xt_check_entry_offsets(e, e->target_offset, e->next_offset);
 	if (ret)
 		return ret;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 24ae7f4..e378311 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -599,15 +599,6 @@ static void cleanup_match(struct xt_entry_match *m, struct net *net)
 	module_put(par.match->me);
 }
 
-static int
-check_entry(const struct ip6t_entry *e)
-{
-	if (!ip6_checkentry(&e->ipv6))
-		return -EINVAL;
-
-	return xt_check_entry_offsets(e, e->target_offset, e->next_offset);
-}
-
 static int check_match(struct xt_entry_match *m, struct xt_mtchk_param *par)
 {
 	const struct ip6t_ip6 *ipv6 = par->entryinfo;
@@ -772,7 +763,10 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 		return -EINVAL;
 	}
 
-	err = check_entry(e);
+	if (!ip6_checkentry(&e->ipv6))
+		return -EINVAL;
+
+	err = xt_check_entry_offsets(e, e->target_offset, e->next_offset);
 	if (err)
 		return err;
 
@@ -1528,8 +1522,10 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 		return -EINVAL;
 	}
 
-	/* For purposes of check_entry casting the compat entry is fine */
-	ret = check_entry((struct ip6t_entry *)e);
+	if (!ip6_checkentry(&e->ipv6))
+		return -EINVAL;
+
+	ret = xt_check_entry_offsets(e, e->target_offset, e->next_offset);
 	if (ret)
 		return ret;
 
-- 
2.7.3

