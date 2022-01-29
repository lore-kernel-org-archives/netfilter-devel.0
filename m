Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6D0C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Jan 2022 16:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352804AbiA2Qr0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Jan 2022 11:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiA2QrZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jan 2022 11:47:25 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810DFC061714
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jan 2022 08:47:25 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nDqsm-0003Z2-0T; Sat, 29 Jan 2022 17:47:24 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [PATCH nf 1/2] netfilter: conntrack: move synack init code to helper
Date:   Sat, 29 Jan 2022 17:47:00 +0100
Message-Id: <20220129164701.175221-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It seems more readable to use a common helper in the followup fix rather
than copypaste or goto.

No functional change intended.  The function is only called for syn-ack
or syn in repy direction in case of simultaneous open.

Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 47 ++++++++++++++++----------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index af5115e127cf..88c89e97d8a2 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -446,6 +446,32 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 	}
 }
 
+static void tcp_init_sender(struct ip_ct_tcp_state *sender,
+			    struct ip_ct_tcp_state *receiver,
+			    const struct sk_buff *skb,
+			    unsigned int dataoff,
+			    const struct tcphdr *tcph,
+			    u32 end, u32 win)
+{
+	/* SYN-ACK in reply to a SYN
+	 * or SYN from reply direction in simultaneous open.
+	 */
+	sender->td_end =
+	sender->td_maxend = end;
+	sender->td_maxwin = (win == 0 ? 1 : win);
+
+	tcp_options(skb, dataoff, tcph, sender);
+	/* RFC 1323:
+	 * Both sides must send the Window Scale option
+	 * to enable window scaling in either direction.
+	 */
+	if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
+	      receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE)) {
+		sender->td_scale = 0;
+		receiver->td_scale = 0;
+	}
+}
+
 static bool tcp_in_window(struct nf_conn *ct,
 			  enum ip_conntrack_dir dir,
 			  unsigned int index,
@@ -499,24 +525,9 @@ static bool tcp_in_window(struct nf_conn *ct,
 		 * Initialize sender data.
 		 */
 		if (tcph->syn) {
-			/*
-			 * SYN-ACK in reply to a SYN
-			 * or SYN from reply direction in simultaneous open.
-			 */
-			sender->td_end =
-			sender->td_maxend = end;
-			sender->td_maxwin = (win == 0 ? 1 : win);
-
-			tcp_options(skb, dataoff, tcph, sender);
-			/*
-			 * RFC 1323:
-			 * Both sides must send the Window Scale option
-			 * to enable window scaling in either direction.
-			 */
-			if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE
-			      && receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE))
-				sender->td_scale =
-				receiver->td_scale = 0;
+			tcp_init_sender(sender, receiver,
+					skb, dataoff, tcph,
+					end, win);
 			if (!tcph->ack)
 				/* Simultaneous open */
 				return true;
-- 
2.34.1

