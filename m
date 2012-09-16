From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 02/11] xt_psd: move parts of main match function to helpers
Date: Sun, 16 Sep 2012 23:29:46 +0200
Message-ID: <1347830995-19226-3-git-send-email-fw@strlen.de>
References: <1347830995-19226-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33803 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab2IPVce (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Sep 2012 17:32:34 -0400
In-Reply-To: <1347830995-19226-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

the match function is way too large, start to split this
into smaller chunks.
---
 extensions/xt_psd.c |   55 +++++++++++++++++++++++++++++---------------------
 1 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index 1588631..442c05a 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -118,6 +118,36 @@ static bool port_in_list(struct host *host, u8 proto, u16 port)
 	return false;
 }
 
+static u16 get_port_weight(const struct xt_psd_info *psd, __be16 port)
+{
+	return ntohs(port) < 1024 ? psd->lo_ports_weight : psd->hi_ports_weight;
+}
+
+static bool
+is_portscan(struct host *host, const struct xt_psd_info *psdinfo,
+            u8 proto, __be16 dest_port)
+{
+	host->timestamp = jiffies;
+
+	if (host->weight >= psdinfo->weight_threshold) /* already matched */
+		return true;
+
+	/* Update the total weight */
+	host->weight += get_port_weight(psdinfo, dest_port);
+
+	/* Got enough destination ports to decide that this is a scan? */
+	if (host->weight >= psdinfo->weight_threshold)
+		return true;
+
+	/* Remember the new port */
+	if (host->count < ARRAY_SIZE(host->ports)) {
+		host->ports[host->count].number = dest_port;
+		host->ports[host->count].proto = proto;
+		host->count++;
+	}
+	return false;
+}
+
 static bool
 xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 {
@@ -200,31 +230,10 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 			if (proto == IPPROTO_TCP && (tcph->ack || tcph->rst))
 				goto out_no_match;
 
-			/* Packet to a new port, and not TCP/ACK: update the timestamp */
-			curr->timestamp = now;
-
-			/* Matched this scan already? Then Leave. */
-			if (curr->weight >= psdinfo->weight_threshold)
-				goto out_match;
-
-			/* Update the total weight */
-			curr->weight += (ntohs(dest_port) < 1024) ?
-				psdinfo->lo_ports_weight : psdinfo->hi_ports_weight;
-
-			/* Got enough destination ports to decide that this is a scan? */
-			if (curr->weight >= psdinfo->weight_threshold)
+			if (is_portscan(curr, psdinfo, proto, dest_port))
 				goto out_match;
-
-			/* Remember the new port */
-			if (curr->count < ARRAY_SIZE(curr->ports)) {
-				curr->ports[curr->count].number = dest_port;
-				curr->ports[curr->count].proto = proto;
-				curr->count++;
-			}
-
 			goto out_no_match;
 		}
-
 		/* We know this address, but the entry is outdated. Mark it unused, and
 		 * remove from the hash table. We'll allocate a new entry instead since
 		 * this one might get re-used too soon. */
@@ -287,7 +296,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	curr->dest_addr.s_addr = iph->daddr;
 	curr->src_port = src_port;
 	curr->count = 1;
-	curr->weight = (ntohs(dest_port) < 1024) ? psdinfo->lo_ports_weight : psdinfo->hi_ports_weight;
+	curr->weight = get_port_weight(psdinfo, dest_port);
 	curr->ports[0].number = dest_port;
 	curr->ports[0].proto = proto;
 
-- 
1.7.8.6

