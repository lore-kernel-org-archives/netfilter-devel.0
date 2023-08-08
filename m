Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66489C001B0
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Aug 2023 17:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbjHHRtC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbjHHRsc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 13:48:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA1AB0A16;
        Tue,  8 Aug 2023 09:21:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qTM2b-0000M0-Dy; Tue, 08 Aug 2023 14:42:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH next-next 5/5] netfilter: nfnetlink_log: always add a timestamp
Date:   Tue,  8 Aug 2023 14:41:48 +0200
Message-ID: <20230808124159.19046-6-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230808124159.19046-1-fw@strlen.de>
References: <20230808124159.19046-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Compared to all the other work we're already doing to deliver
an skb to userspace this is very cheap - at worse an extra
call to ktime_get_real() - and very useful.

(and indeed it may even be cheaper if we're running from other hooks)

(background: Android occasionally logs packets which
caused wake from sleep/suspend and we'd like to have
timestamps reliably associated with these events)

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index e57eb168ee13..53c9e76473ba 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -470,7 +470,6 @@ __build_packet_message(struct nfnl_log_net *log,
 	sk_buff_data_t old_tail = inst->skb->tail;
 	struct sock *sk;
 	const unsigned char *hwhdrp;
-	ktime_t tstamp;
 
 	nlh = nfnl_msg_put(inst->skb, 0, 0,
 			   nfnl_msg_type(NFNL_SUBSYS_ULOG, NFULNL_MSG_PACKET),
@@ -599,10 +598,9 @@ __build_packet_message(struct nfnl_log_net *log,
 			goto nla_put_failure;
 	}
 
-	tstamp = skb_tstamp_cond(skb, false);
-	if (hooknum <= NF_INET_FORWARD && tstamp) {
+	if (hooknum <= NF_INET_FORWARD) {
+		struct timespec64 kts = ktime_to_timespec64(skb_tstamp_cond(skb, true));
 		struct nfulnl_msg_packet_timestamp ts;
-		struct timespec64 kts = ktime_to_timespec64(tstamp);
 		ts.sec = cpu_to_be64(kts.tv_sec);
 		ts.usec = cpu_to_be64(kts.tv_nsec / NSEC_PER_USEC);
 
-- 
2.41.0

