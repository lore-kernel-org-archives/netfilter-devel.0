From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/4] psd: rip out scanlogd leftovers
Date: Thu, 14 Jun 2012 22:13:31 +0200
Message-ID: <1339704814-1605-2-git-send-email-fw@strlen.de>
References: <1339704814-1605-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41691 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345Ab2FNUOt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:14:49 -0400
In-Reply-To: <1339704814-1605-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

scanlogd remembers tcp flags and uses the *_CHANGING values
in its logger function to determine the best log format to
use (e.g. TTL isn't logged if HF_TTL_CHANGING was set, as TTL
values were different).

As psd doesn't log at all, we don't need track this.

Also get rid of bogus/misleading comments.
---
 extensions/xt_psd.c |   43 ++-----------------------------------------
 1 files changed, 2 insertions(+), 41 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index acb5e8e..c044c25 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -40,10 +40,6 @@ MODULE_AUTHOR(" Mohd Nawawi Mohamad Jamili <nawawi@tracenetworkcorporation.com>"
 MODULE_DESCRIPTION("Xtables: PSD - portscan detection");
 MODULE_ALIAS("ipt_psd");
 
-#define HF_DADDR_CHANGING   0x01
-#define HF_SPORT_CHANGING   0x02
-#define HF_TOS_CHANGING	    0x04
-#define HF_TTL_CHANGING	    0x08
 
 /*
  * Information we keep per each target port
@@ -51,8 +47,6 @@ MODULE_ALIAS("ipt_psd");
 struct port {
 	u_int16_t number;      /* port number */
 	u_int8_t proto;        /* protocol number */
-	u_int8_t and_flags;    /* tcp ANDed flags */
-	u_int8_t or_flags;     /* tcp ORed flags */
 };
 
 /*
@@ -67,9 +61,6 @@ struct host {
 	int count;								/* Number of ports in the list */
 	int weight;								/* Total weight of ports in the list */
 	struct port ports[SCAN_MAX_COUNT - 1];	/* List of ports */
-	unsigned char tos;						/* TOS */
-	unsigned char ttl;						/* TTL */
-	unsigned char flags;					/* HF_ flags bitmask */
 };
 
 /*
@@ -111,26 +102,20 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	} _buf;
 	struct in_addr addr;
 	u_int16_t src_port,dest_port;
-  	u_int8_t tcp_flags, proto;
+	u_int8_t proto;
 	unsigned long now;
 	struct host *curr, *last, **head;
 	int hash, index, count;
 	/* Parameters from userspace */
 	const struct xt_psd_info *psdinfo = match->matchinfo;
 
-	/* IP header */
 	iph = ip_hdr(pskb);
-
-	/* Sanity check */
 	if (iph->frag_off & htons(IP_OFFSET)) {
 		pr_debug("sanity check failed\n");
 		return false;
 	}
 
-	/* TCP or UDP ? */
 	proto = iph->protocol;
-	/* Get the source address, source & destination ports, and TCP flags */
-
 	addr.s_addr = iph->saddr;
 	/* We're using IP address 0.0.0.0 for a special purpose here, so don't let
 	 * them spoof us. [DHCP needs this feature - HW] */
@@ -148,7 +133,6 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 		/* Yep, it's dirty */
 		src_port = tcph->source;
 		dest_port = tcph->dest;
-		tcp_flags = *((u_int8_t*)tcph + 13);
 	} else if (proto == IPPROTO_UDP || proto == IPPROTO_UDPLITE) {
 		udph = skb_header_pointer(pskb, match->thoff,
 		       sizeof(_buf.udph), &_buf.udph);
@@ -156,14 +140,11 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 			return false;
 		src_port  = udph->source;
 		dest_port = udph->dest;
-		tcp_flags = 0;
 	} else {
 		pr_debug("protocol not supported\n");
 		return false;
 	}
 
-	/* Use jiffies here not to depend on someone setting the time while we're
-	 * running; we need to be careful with possible return value overflows. */
 	now = jiffies;
 
 	spin_lock(&state.lock);
@@ -181,7 +162,6 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 		} while ((curr = curr->next) != NULL);
 
 	if (curr != NULL) {
-
 		/* We know this address, and the entry isn't too old. Update it. */
 		if (now - curr->timestamp <= (psdinfo->delay_threshold*HZ)/100 &&
 		    time_after_eq(now, curr->timestamp)) {
@@ -190,8 +170,6 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 			for (index = 0; index < curr->count; index++) {
 				if (curr->ports[index].number == dest_port) {
 					curr->ports[index].proto = proto;
-					curr->ports[index].and_flags &= tcp_flags;
-					curr->ports[index].or_flags |= tcp_flags;
 					goto out_no_match;
 				}
 			}
@@ -203,26 +181,15 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 			/* Packet to a new port, and not TCP/ACK: update the timestamp */
 			curr->timestamp = now;
 
-			/* Logged this scan already? Then drop the packet. */
+			/* Matched this scan already? Then Leave. */
 			if (curr->weight >= psdinfo->weight_threshold)
 				goto out_match;
 
-			/* Specify if destination address, source port, TOS or TTL are not fixed */
-			if (curr->dest_addr.s_addr != iph->daddr)
-				curr->flags |= HF_DADDR_CHANGING;
-			if (curr->src_port != src_port)
-				curr->flags |= HF_SPORT_CHANGING;
-			if (curr->tos != iph->tos)
-				curr->flags |= HF_TOS_CHANGING;
-			if (curr->ttl != iph->ttl)
-				curr->flags |= HF_TTL_CHANGING;
-
 			/* Update the total weight */
 			curr->weight += (ntohs(dest_port) < 1024) ?
 				psdinfo->lo_ports_weight : psdinfo->hi_ports_weight;
 
 			/* Got enough destination ports to decide that this is a scan? */
-			/* Then log it and drop the packet. */
 			if (curr->weight >= psdinfo->weight_threshold)
 				goto out_match;
 
@@ -230,8 +197,6 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 			if (curr->count < ARRAY_SIZE(curr->ports)) {
 				curr->ports[curr->count].number = dest_port;
 				curr->ports[curr->count].proto = proto;
-				curr->ports[curr->count].and_flags = tcp_flags;
-				curr->ports[curr->count].or_flags = tcp_flags;
 				curr->count++;
 			}
 
@@ -303,10 +268,6 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	curr->weight = (ntohs(dest_port) < 1024) ? psdinfo->lo_ports_weight : psdinfo->hi_ports_weight;
 	curr->ports[0].number = dest_port;
 	curr->ports[0].proto = proto;
-	curr->ports[0].and_flags = tcp_flags;
-	curr->ports[0].or_flags = tcp_flags;
-	curr->tos = iph->tos;
-	curr->ttl = iph->ttl;
 
 out_no_match:
 	spin_unlock(&state.lock);
-- 
1.7.3.4

