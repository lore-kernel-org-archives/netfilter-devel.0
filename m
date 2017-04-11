From: gfree.wind@foxmail.com
Subject: [PATCH nf-next 1/1] netfilter: SYNPROXY: Return NF_STOLEN instead of NF_DROP during handshaking
Date: Tue, 11 Apr 2017 12:09:10 +0800
Message-ID: <1491883750-78913-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg299.qq.com ([184.105.67.99]:50631 "EHLO smtpbg299.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752179AbdDKEJZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Apr 2017 00:09:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Current SYNPROXY codes return NF_DROP during normal TCP handshaking,
it is not friendly to caller. Because the nf_hook_slow would treat
the NF_DROP as an error, and return -EPERM.
As a result, it may cause the top caller think it meets one error.

So use NF_STOLEN instead of NF_DROP now because there is no error
happened indeed, and free the skb directly.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/ipv4/netfilter/ipt_SYNPROXY.c  | 7 ++++---
 net/ipv6/netfilter/ip6t_SYNPROXY.c | 6 ++++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index 3240a26..9ed80d4 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -293,12 +293,13 @@
 					  XT_SYNPROXY_OPT_ECN);
 
 		synproxy_send_client_synack(net, skb, th, &opts);
-		return NF_DROP;
-
+		consume_skb(skb);
+		return NF_STOLEN;
 	} else if (th->ack && !(th->fin || th->rst || th->syn)) {
 		/* ACK from client */
 		synproxy_recv_client_ack(net, skb, th, &opts, ntohl(th->seq));
-		return NF_DROP;
+		consume_skb(skb);
+		return NF_STOLEN;
 	}
 
 	return XT_CONTINUE;
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 4ef1ddd..d5d5725 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -307,12 +307,14 @@
 					  XT_SYNPROXY_OPT_ECN);
 
 		synproxy_send_client_synack(net, skb, th, &opts);
-		return NF_DROP;
+		consume_skb(skb);
+		return NF_STOLEN;
 
 	} else if (th->ack && !(th->fin || th->rst || th->syn)) {
 		/* ACK from client */
 		synproxy_recv_client_ack(net, skb, th, &opts, ntohl(th->seq));
-		return NF_DROP;
+		consume_skb(skb);
+		return NF_STOLEN;
 	}
 
 	return XT_CONTINUE;
-- 
1.9.1


