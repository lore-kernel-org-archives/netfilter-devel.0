From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: use_nf_conn_expires helper in more places
Date: Wed,  3 Aug 2016 02:45:07 +0200
Message-ID: <1470185107-17332-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54550 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978AbcHCBMA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Aug 2016 21:12:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... so we don't need to touch all of these places when we get rid of the
timer in nf_conn.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c | 3 +--
 net/netfilter/nf_conntrack_netlink.c                  | 5 +----
 net/netfilter/nf_conntrack_standalone.c               | 3 +--
 net/netfilter/xt_conntrack.c                          | 4 +---
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 6392371..67bfc69 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -163,8 +163,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	ret = -ENOSPC;
 	seq_printf(s, "%-8s %u %ld ",
 		   l4proto->name, nf_ct_protonum(ct),
-		   timer_pending(&ct->timeout)
-		   ? (long)(ct->timeout.expires - jiffies)/HZ : 0);
+		   nf_ct_expires(ct) / HZ);
 
 	if (l4proto->print_conntrack)
 		l4proto->print_conntrack(s, ct);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 050bb34..68800c1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -149,10 +149,7 @@ nla_put_failure:
 
 static int ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	long timeout = ((long)ct->timeout.expires - (long)jiffies) / HZ;
-
-	if (timeout < 0)
-		timeout = 0;
+	long timeout = nf_ct_expires(ct) / HZ;
 
 	if (nla_put_be32(skb, CTA_TIMEOUT, htonl(timeout)))
 		goto nla_put_failure;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 958a145..4e7becd 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -224,8 +224,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	seq_printf(s, "%-8s %u %-8s %u %ld ",
 		   l3proto->name, nf_ct_l3num(ct),
 		   l4proto->name, nf_ct_protonum(ct),
-		   timer_pending(&ct->timeout)
-		   ? (long)(ct->timeout.expires - jiffies)/HZ : 0);
+		   nf_ct_expires(ct)  / HZ);
 
 	if (l4proto->print_conntrack)
 		l4proto->print_conntrack(s, ct);
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 188404b9..a3b8f69 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -233,10 +233,8 @@ conntrack_mt(const struct sk_buff *skb, struct xt_action_param *par,
 		return false;
 
 	if (info->match_flags & XT_CONNTRACK_EXPIRES) {
-		unsigned long expires = 0;
+		unsigned long expires = nf_ct_expires(ct) / HZ;
 
-		if (timer_pending(&ct->timeout))
-			expires = (ct->timeout.expires - jiffies) / HZ;
 		if ((expires >= info->expires_min &&
 		    expires <= info->expires_max) ^
 		    !(info->invert_flags & XT_CONNTRACK_EXPIRES))
-- 
2.7.3

