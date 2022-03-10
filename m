Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D12C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Mar 2022 16:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241352AbiCJQlq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 11:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239583AbiCJQlp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 11:41:45 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A787194162
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2022 08:40:44 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nSLqE-0005Uz-QX; Thu, 10 Mar 2022 17:40:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     kadlec@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/4] netfilter: conntrack: remove unneeded indent level
Date:   Thu, 10 Mar 2022 17:40:17 +0100
Message-Id: <20220310164017.7317-5-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220310164017.7317-1-fw@strlen.de>
References: <20220310164017.7317-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After previous patch, the conditional branch is obsolete, reformat it.
gcc generates same code as before this change.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 100 +++++++++++--------------
 1 file changed, 45 insertions(+), 55 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index edfbbfa3ad3c..793e84f78e3f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -644,63 +644,53 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 					  "ignored ACK under lower bound %u (possible overly delayed)",
 					  receiver->td_end - MAXACKWINDOW(sender) - 1);
 
-
-	if (1) {
-		/*
-		 * Take into account window scaling (RFC 1323).
-		 */
-		if (!tcph->syn)
-			win <<= sender->td_scale;
-
-		/*
-		 * Update sender data.
-		 */
-		swin = win + (sack - ack);
-		if (sender->td_maxwin < swin)
-			sender->td_maxwin = swin;
-		if (after(end, sender->td_end)) {
-			sender->td_end = end;
-			sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
-		}
-		if (tcph->ack) {
-			if (!(sender->flags & IP_CT_TCP_FLAG_MAXACK_SET)) {
-				sender->td_maxack = ack;
-				sender->flags |= IP_CT_TCP_FLAG_MAXACK_SET;
-			} else if (after(ack, sender->td_maxack))
-				sender->td_maxack = ack;
-		}
-
-		/*
-		 * Update receiver data.
-		 */
-		if (receiver->td_maxwin != 0 && after(end, sender->td_maxend))
-			receiver->td_maxwin += end - sender->td_maxend;
-		if (after(sack + win, receiver->td_maxend - 1)) {
-			receiver->td_maxend = sack + win;
-			if (win == 0)
-				receiver->td_maxend++;
+	/* Take into account window scaling (RFC 1323). */
+	if (!tcph->syn)
+		win <<= sender->td_scale;
+
+	/* Update sender data. */
+	swin = win + (sack - ack);
+	if (sender->td_maxwin < swin)
+		sender->td_maxwin = swin;
+	if (after(end, sender->td_end)) {
+		sender->td_end = end;
+		sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
+	}
+	if (tcph->ack) {
+		if (!(sender->flags & IP_CT_TCP_FLAG_MAXACK_SET)) {
+			sender->td_maxack = ack;
+			sender->flags |= IP_CT_TCP_FLAG_MAXACK_SET;
+		} else if (after(ack, sender->td_maxack)) {
+			sender->td_maxack = ack;
 		}
-		if (ack == receiver->td_end)
-			receiver->flags &= ~IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
+	}
 
-		/*
-		 * Check retransmissions.
-		 */
-		if (index == TCP_ACK_SET) {
-			if (state->last_dir == dir
-			    && state->last_seq == seq
-			    && state->last_ack == ack
-			    && state->last_end == end
-			    && state->last_win == win_raw)
-				state->retrans++;
-			else {
-				state->last_dir = dir;
-				state->last_seq = seq;
-				state->last_ack = ack;
-				state->last_end = end;
-				state->last_win = win_raw;
-				state->retrans = 0;
-			}
+	/* Update receiver data. */
+	if (receiver->td_maxwin != 0 && after(end, sender->td_maxend))
+		receiver->td_maxwin += end - sender->td_maxend;
+	if (after(sack + win, receiver->td_maxend - 1)) {
+		receiver->td_maxend = sack + win;
+		if (win == 0)
+			receiver->td_maxend++;
+	}
+	if (ack == receiver->td_end)
+		receiver->flags &= ~IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
+
+	/* Check retransmissions. */
+	if (index == TCP_ACK_SET) {
+		if (state->last_dir == dir &&
+		    state->last_seq == seq &&
+		    state->last_ack == ack &&
+		    state->last_end == end &&
+		    state->last_win == win_raw) {
+			state->retrans++;
+		} else {
+			state->last_dir = dir;
+			state->last_seq = seq;
+			state->last_ack = ack;
+			state->last_end = end;
+			state->last_win = win_raw;
+			state->retrans = 0;
 		}
 	}
 
-- 
2.34.1

