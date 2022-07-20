Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F28AC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Jul 2022 17:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiGTRwt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 13:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiGTRwt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 13:52:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED99A5C9EB
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2022 10:52:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oEDsM-0008MF-Hj; Wed, 20 Jul 2022 19:52:46 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     kadlec@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: conntrack: remove unneeded indent level
Date:   Wed, 20 Jul 2022 19:52:28 +0200
Message-Id: <20220720175228.17880-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720175228.17880-1-fw@strlen.de>
References: <20220720175228.17880-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

After previous patch, the conditional branch is obsolete, reformat it.
gcc generates same code as before this change.

Also includes cleanups to pacify checkpatch.pl.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 100 +++++++++++--------------
 1 file changed, 45 insertions(+), 55 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index c72588382421..e1e354ea62ef 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -635,63 +635,53 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
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
2.35.1

