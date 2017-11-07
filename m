From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/23] netfilter: conntrack: make l3proto trackers const
Date: Tue,  7 Nov 2017 01:52:00 +0100
Message-ID: <20171107005213.22618-11-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934797AbdKGAxG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 19:53:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6DA531F4B6F
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:53:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B845DA80B
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:53:05 +0100 (CET)
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

previous patches removed all writes to them.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0

