From: pablo@netfilter.org
Subject: [PATCH 2/2] netfilter: nf_ct_tcp: missing per-net support for cttimeout
Date: Fri, 29 Jun 2012 17:23:25 +0200
Message-ID: <1340983405-32118-2-git-send-email-pablo@netfilter.org>
References: <1340983405-32118-1-git-send-email-pablo@netfilter.org>
Cc: gaofeng@cn.fujitsu.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37301 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab2F2PXl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:23:41 -0400
In-Reply-To: <1340983405-32118-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds missing per-net support for the cttimeout
infrastructure to TCP.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 07e56ea..a5ac11e 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -821,7 +821,7 @@ static int tcp_error(struct net *net, struct nf_conn *tmpl,
 
 static unsigned int *tcp_get_timeouts(struct net *net)
 {
-	return tcp_timeouts;
+	return tcp_pernet(net)->timeouts;
 }
 
 /* Returns verdict for packet, or -1 for invalid. */
-- 
1.7.10

