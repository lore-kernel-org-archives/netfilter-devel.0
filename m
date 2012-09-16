From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 01/11] xt_psd: consider protocol when searching port list
Date: Sun, 16 Sep 2012 23:29:45 +0200
Message-ID: <1347830995-19226-2-git-send-email-fw@strlen.de>
References: <1347830995-19226-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33802 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223Ab2IPVcc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Sep 2012 17:32:32 -0400
In-Reply-To: <1347830995-19226-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

if we saw a TCP packet on port X, and we receive a UDP
packet from the same host to port X, we counted this
as "port X", and didn't see this as a new packet.

Change compare to also consider protocol number and
move it to a helper to de-bloat the overlay large match
function.

This change makes psd more aggressive with mixed tcp/udp traffic.
---
 extensions/xt_psd.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index b67b64e..1588631 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -106,6 +106,18 @@ static inline int hashfunc(struct in_addr addr)
 	return hash & (HASH_SIZE - 1);
 }
 
+static bool port_in_list(struct host *host, u8 proto, u16 port)
+{
+	int i;
+	for (i = 0; i < host->count; i++) {
+		if (host->ports[i].proto != proto)
+			continue;
+		if (host->ports[i].number == port)
+			return true;
+	}
+	return false;
+}
+
 static bool
 xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 {
@@ -121,7 +133,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 	u_int8_t proto;
 	unsigned long now;
 	struct host *curr, *last, **head;
-	int hash, index, count;
+	int hash, count;
 	/* Parameters from userspace */
 	const struct xt_psd_info *psdinfo = match->matchinfo;
 
@@ -182,14 +194,8 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 		if (now - curr->timestamp <= (psdinfo->delay_threshold*HZ)/100 &&
 		    time_after_eq(now, curr->timestamp)) {
 
-			/* Just update the appropriate list entry if we've seen this port already */
-			for (index = 0; index < curr->count; index++) {
-				if (curr->ports[index].number == dest_port) {
-					curr->ports[index].proto = proto;
-					goto out_no_match;
-				}
-			}
-
+			if (port_in_list(curr, proto, dest_port))
+				goto out_no_match;
 			/* TCP/ACK and/or TCP/RST to a new port? This could be an outgoing connection. */
 			if (proto == IPPROTO_TCP && (tcph->ack || tcph->rst))
 				goto out_no_match;
-- 
1.7.8.6

