From: gfree.wind@foxmail.com
Subject: [PATCH nf-next v3] netfilter: SYNPROXY: Return NF_STOLEN instead of NF_DROP during handshaking
Date: Thu, 20 Apr 2017 14:01:45 +0800
Message-ID: <1492668105-69086-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgbr2.qq.com ([54.207.22.56]:41479 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938966AbdDTGCK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 02:02:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Current SYNPROXY codes return NF_DROP during normal TCP handshaking,
it is not friendly to caller. Because the nf_hook_slow would treat
the NF_DROP as an error, and return -EPERM.
As a result, it may cause the top caller think it meets one error.

For example, the following codes are from cfv_rx_poll()
	err = netif_receive_skb(skb);
	if (unlikely(err)) {
		++cfv->ndev->stats.rx_dropped;
	} else {
		++cfv->ndev->stats.rx_packets;
		cfv->ndev->stats.rx_bytes += skb_len;
	}
When SYNPROXY returns NF_DROP, then netif_receive_skb returns -EPERM.
As a result, the cfv driver would treat it as an error, and increase
the rx_dropped counter.

So use NF_STOLEN instead of NF_DROP now because there is no error
happened indeed, and free the skb directly.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v2: Add more comments
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




