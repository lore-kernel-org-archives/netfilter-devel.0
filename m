Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 020BBC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Jan 2022 16:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352808AbiA2Qr3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Jan 2022 11:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbiA2Qr2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jan 2022 11:47:28 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1398C061714
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jan 2022 08:47:28 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nDqsp-0003ZD-7F; Sat, 29 Jan 2022 17:47:27 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [PATCH nf 2/2] netfilter: conntrack: re-init state for retransmitted syn-ack
Date:   Sat, 29 Jan 2022 17:47:01 +0100
Message-Id: <20220129164701.175221-2-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220129164701.175221-1-fw@strlen.de>
References: <20220129164701.175221-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

TCP conntrack assumes that a syn-ack retransmit is identical to the
previous syn-ack.  This isn't correct and causes stuck 3whs in some more
esoteric scenarios.  tcpdump to illustrate the problem:

 client > server: Flags [S] seq 1365731894, win 29200, [mss 1460,sackOK,TS val 2083035583 ecr 0,wscale 7]
 server > client: Flags [S.] seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215367629 ecr 2082921663]

Note the invalid/outdated synack ack number.
Conntrack marks this syn-ack as out-of-window/invalid, but it did
initialize the reply direction parameters based on this packets content.

 client > server: Flags [S] seq 1365731894, win 29200, [mss 1460,sackOK,TS val 2083036623 ecr 0,wscale 7]

... retransmit...

 server > client: Flags [S.], seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215368644 ecr 2082921663]

and another bogus synack. This repeats, then client re-uses for a new
attempt:

client > server: Flags [S], seq 2375731741, win 29200, [mss 1460,sackOK,TS val 2083100223 ecr 0,wscale 7]
server > client: Flags [S.], seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215430754 ecr 2082921663]

... but still gets a invalid syn-ack.

This repeats until:

 server > client: Flags [S.], seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215437785 ecr 2082921663]
 server > client: Flags [R.], seq 145824454, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215443451 ecr 2082921663]
 client > server: Flags [S], seq 2375731741, win 29200, [mss 1460,sackOK,TS val 2083115583 ecr 0,wscale 7]
 server > client: Flags [S.], seq 162602410, ack 2375731742, win 65535, [mss 8952,wscale 5,TS val 3215445754 ecr 2083115583]

This syn-ack has the correct ack number, but conntrack flags it as
invalid: The internal state was created from the first syn-ack seen
so the sequence number of the syn-ack is treated as being outside of
the announced window.

Don't assume that retransmitted syn-ack is identical to previous one.
Treat it like the first syn-ack and reinit state.

Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 88c89e97d8a2..d1582b888c0d 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -571,6 +571,18 @@ static bool tcp_in_window(struct nf_conn *ct,
 		sender->td_maxwin = (win == 0 ? 1 : win);
 
 		tcp_options(skb, dataoff, tcph, sender);
+	} else if (tcph->syn && dir == IP_CT_DIR_REPLY &&
+		   state->state == TCP_CONNTRACK_SYN_SENT) {
+		/* Retransmitted syn-ack, or syn (simultaneous open).
+		 *
+		 * Re-init state for this direction, just like for the first
+		 * syn(-ack) reply, it might differ in seq, ack or tcp options.
+		 */
+		tcp_init_sender(sender, receiver,
+				skb, dataoff, tcph,
+				end, win);
+		if (!tcph->ack)
+			return true;
 	}
 
 	if (!(tcph->ack)) {
-- 
2.34.1

