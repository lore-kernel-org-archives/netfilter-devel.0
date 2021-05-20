Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B5FC433ED
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 May 2021 12:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 946D061163
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 May 2021 12:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbhETMPV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 May 2021 08:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240989AbhETMPQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 May 2021 08:15:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2714C05BD07
        for <netfilter-devel@vger.kernel.org>; Thu, 20 May 2021 03:53:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ljgIo-0005YX-H6; Thu, 20 May 2021 12:53:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Ali Abdallah <aabdallah@suse.de>, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: improve RST handling when tuple is re-used
Date:   Thu, 20 May 2021 12:53:11 +0200
Message-Id: <20210520105311.20745-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Ali Abdallah <aabdallah@suse.de>

If we receive a SYN packet in original direction on an existing
connection tracking entry, we let this SYN through because conntrack
might be out-of-sync.

Conntrack gets back in sync when server responds with SYN/ACK and state
gets updated accordingly.

However, if server replies with RST, this packet might be marked as
INVALID because td_maxack value reflects the *old* conntrack state
and not the state of the originator of the RST.

Avoid td_maxack-based checks if previous packet was a SYN.

Unfortunately that is not be enough: an out of order ACK in original
direction updates last_index, so we still end up marking valid RST.

Thus disable the sequence check when we are not in established state and
the received RST has a sequence of 0.

Because marking RSTs as invalid usually leads to unwanted timeouts,
also skip RST sequence checks if a conntrack entry is already closing.

Such entries can already be evicted via GC in case the table is full.

Co-developed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Ali Abdallah <aabdallah@suse.de>
---
 Ali, this is still slightly different to last version.
 tcp_can_early_drop() check doesn't need to depend on MAXACK_SET,
 so I moved it a bit earlier.

 MAXACK flag doesn't have to be unset either, it should be sufficient
 to skip the 'old sequence' test when the previous packet was a SYN
 packet we let through just before.

 I retained your seq == 0 check and added a few comments to explain
 why its still required even with the TCP_SYN_SET check in place.

 I also ran the packetdrill test from
 be0502a3f2e94211a8 ('netfilter: conntrack: tcp: only close if RST
 matches exact sequence') and that still has the expected result.

 net/netfilter/nf_conntrack_proto_tcp.c | 53 +++++++++++++++++---------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 34e22416a721..3e6e2cfc480a 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -822,6 +822,22 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return true;
 }
 
+static bool tcp_can_early_drop(const struct nf_conn *ct)
+{
+	switch (ct->proto.tcp.state) {
+	case TCP_CONNTRACK_FIN_WAIT:
+	case TCP_CONNTRACK_LAST_ACK:
+	case TCP_CONNTRACK_TIME_WAIT:
+	case TCP_CONNTRACK_CLOSE:
+	case TCP_CONNTRACK_CLOSE_WAIT:
+		return true;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			    struct sk_buff *skb,
@@ -1029,9 +1045,28 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		if (index != TCP_RST_SET)
 			break;
 
-		if (ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_MAXACK_SET) {
+		/* If we are closing, tuple might have been re-used already.
+		 * last_index, last_ack, and all other ct fields used for
+		 * sequence/window validation are outdated in that case.
+		 *
+		 * As the conntrack can already be expired by GC under pressure,
+		 * just skip validation checks.
+		 */
+		if (tcp_can_early_drop(ct))
+			goto in_window;
+
+		/* td_maxack might be outdated if we let a SYN through earlier */
+		if ((ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_MAXACK_SET) &&
+		    ct->proto.tcp.last_index != TCP_SYN_SET) {
 			u32 seq = ntohl(th->seq);
 
+			/* If we are not in established state and SEQ=0 this is most
+			 * likely an answer to a SYN we let go through above (last_index
+			 * can be updated due to out-of-order ACKs).
+			 */
+			if (seq == 0 && !nf_conntrack_tcp_established(ct))
+				break;
+
 			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack)) {
 				/* Invalid RST  */
 				spin_unlock_bh(&ct->lock);
@@ -1154,22 +1189,6 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	return NF_ACCEPT;
 }
 
-static bool tcp_can_early_drop(const struct nf_conn *ct)
-{
-	switch (ct->proto.tcp.state) {
-	case TCP_CONNTRACK_FIN_WAIT:
-	case TCP_CONNTRACK_LAST_ACK:
-	case TCP_CONNTRACK_TIME_WAIT:
-	case TCP_CONNTRACK_CLOSE:
-	case TCP_CONNTRACK_CLOSE_WAIT:
-		return true;
-	default:
-		break;
-	}
-
-	return false;
-}
-
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 
 #include <linux/netfilter/nfnetlink.h>
-- 
2.26.3

