From: gfree.wind@foxmail.com
Subject: [PATCH nf-next v2 1/1] netfilter: SYNPROXY: Return NF_STOLEN instead of NF_DROP during handshaking
Date: Wed, 12 Apr 2017 10:14:50 +0800
Message-ID: <1491963290-84377-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpproxy19.qq.com ([184.105.206.84]:45617 "EHLO
        smtpproxy19.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751951AbdDLCPF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Apr 2017 22:15:05 -0400
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
 v2: Add the check for synproxy_recv_client_ack, per Gao Feng,
 v1: initial version

 net/ipv4/netfilter/ipt_SYNPROXY.c  | 21 ++++++++++++++-------
 net/ipv6/netfilter/ip6t_SYNPROXY.c | 20 ++++++++++++++------
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index 3240a26..ab0f576 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -293,12 +293,16 @@
 					  XT_SYNPROXY_OPT_ECN);
 
 		synproxy_send_client_synack(net, skb, th, &opts);
-		return NF_DROP;
-
+		consume_skb(skb);
+		return NF_STOLEN;
 	} else if (th->ack && !(th->fin || th->rst || th->syn)) {
 		/* ACK from client */
-		synproxy_recv_client_ack(net, skb, th, &opts, ntohl(th->seq));
-		return NF_DROP;
+		if (synproxy_recv_client_ack(net, skb, th, &opts, ntohl(th->seq))) {
+			consume_skb(skb);
+			return NF_STOLEN;
+		} else {
+			return NF_DROP;
+		}
 	}
 
 	return XT_CONTINUE;
@@ -367,10 +371,13 @@ static unsigned int ipv4_synproxy_hook(void *priv,
 			 * number match the one of first SYN.
 			 */
 			if (synproxy_recv_client_ack(net, skb, th, &opts,
-						     ntohl(th->seq) + 1))
+						     ntohl(th->seq) + 1)) {
 				this_cpu_inc(snet->stats->cookie_retrans);
-
-			return NF_DROP;
+				consume_skb(skb);
+				return NF_STOLEN;
+			} else {
+				return NF_DROP;
+			}
 		}
 
 		synproxy->isn = ntohl(th->ack_seq);
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 4ef1ddd..6a4f49e 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -307,12 +307,17 @@
 					  XT_SYNPROXY_OPT_ECN);
 
 		synproxy_send_client_synack(net, skb, th, &opts);
-		return NF_DROP;
+		consume_skb(skb);
+		return NF_STOLEN;
 
 	} else if (th->ack && !(th->fin || th->rst || th->syn)) {
 		/* ACK from client */
-		synproxy_recv_client_ack(net, skb, th, &opts, ntohl(th->seq));
-		return NF_DROP;
+		if (synproxy_recv_client_ack(net, skb, th, &opts, ntohl(th->seq))) {
+			consume_skb(skb);
+			return NF_STOLEN;
+		} else {
+			return NF_DROP;
+		}
 	}
 
 	return XT_CONTINUE;
@@ -388,10 +393,13 @@ static unsigned int ipv6_synproxy_hook(void *priv,
 			 * number match the one of first SYN.
 			 */
 			if (synproxy_recv_client_ack(net, skb, th, &opts,
-						     ntohl(th->seq) + 1))
+						     ntohl(th->seq) + 1)) {
 				this_cpu_inc(snet->stats->cookie_retrans);
-
-			return NF_DROP;
+				consume_skb(skb);
+				return NF_STOLEN;
+			} else {
+				return NF_DROP;
+			}
 		}
 
 		synproxy->isn = ntohl(th->ack_seq);
-- 
1.9.1




