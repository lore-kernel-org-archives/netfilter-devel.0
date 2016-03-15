From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/18] ipvs: allow rescheduling after RST
Date: Tue, 15 Mar 2016 02:27:49 +0100
Message-ID: <1458005282-24665-6-git-send-email-pablo@netfilter.org>
References: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33223 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282AbcCOB23 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 21:28:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D69F1114F46
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C9492DA8FA
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6AFFBDA386
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 02:28:23 +0100 (CET)
In-Reply-To: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Julian Anastasov <ja@ssi.bg>

"RFC 5961, 4.2. Mitigation" describes a mechanism to request
client to confirm with RST the restart of TCP connection
before resending its SYN. As result, IPVS can see SYNs for
existing connection in CLOSE state. Add check to allow
rescheduling in this state.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 4da5600..b9a4082 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1089,6 +1089,7 @@ static inline bool is_new_conn_expected(const struct ip_vs_conn *cp,
 	switch (cp->protocol) {
 	case IPPROTO_TCP:
 		return (cp->state == IP_VS_TCP_S_TIME_WAIT) ||
+		       (cp->state == IP_VS_TCP_S_CLOSE) ||
 			((conn_reuse_mode & 2) &&
 			 (cp->state == IP_VS_TCP_S_FIN_WAIT) &&
 			 (cp->flags & IP_VS_CONN_F_NOOUTPUT));
-- 
2.1.4

