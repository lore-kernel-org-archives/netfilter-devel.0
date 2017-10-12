From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: make l3proto trackers const
Date: Thu, 12 Oct 2017 09:38:30 +0200
Message-ID: <20171012073830.9102-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44380 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750716AbdJLHiO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2017 03:38:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

previous patches removed all writes to them.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h | 2 +-
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h | 2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 919e4e8af327..5534ecca7a5d 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -10,7 +10,7 @@
 #define _NF_CONNTRACK_IPV4_H
 
 
-extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
+const extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
 
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
index eaea968f8657..30dc57980866 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -1,7 +1,7 @@
 #ifndef _NF_CONNTRACK_IPV6_H
 #define _NF_CONNTRACK_IPV6_H
 
-extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
+extern const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
 
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index fe374da4bc13..89af9d88ca21 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -344,7 +344,7 @@ static void ipv4_hooks_unregister(struct net *net)
 	mutex_unlock(&register_ipv4_hooks);
 }
 
-struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
+const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 = {
 	.l3proto	 = PF_INET,
 	.pkt_to_tuple	 = ipv4_pkt_to_tuple,
 	.invert_tuple	 = ipv4_invert_tuple,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index fe01dc953c56..3b80a38f62b8 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -339,7 +339,7 @@ static void ipv6_hooks_unregister(struct net *net)
 	mutex_unlock(&register_ipv6_hooks);
 }
 
-struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 __read_mostly = {
+const struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 = {
 	.l3proto		= PF_INET6,
 	.pkt_to_tuple		= ipv6_pkt_to_tuple,
 	.invert_tuple		= ipv6_invert_tuple,
-- 
2.13.6

