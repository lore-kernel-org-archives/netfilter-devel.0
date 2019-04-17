Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54698C10F13
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 00:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AD032073F
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 00:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbfDQAQ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 20:16:58 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60506 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728367AbfDQAQ5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 20:16:57 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hGYFz-0007GY-2E; Wed, 17 Apr 2019 02:16:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        Michal Soltys <soltys@ziu.info>
Subject: [PATCH nf] netfilter: never get/set skb->tstamp
Date:   Wed, 17 Apr 2019 02:17:23 +0200
Message-Id: <20190417001723.17912-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <9cf8e521-8aa6-c022-e491-d3e6cfe0aca6@ziu.info>
References: <9cf8e521-8aa6-c022-e491-d3e6cfe0aca6@ziu.info>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

setting net.netfilter.nf_conntrack_timestamp=1 breaks xmit with fq
scheduler.  skb->tstamp might be "refreshed" using ktime_get_real(),
but fq expects CLOCK_MONOTONIC.

This patch removes all places in netfilter that check/set skb->tstamp:

1. To fix the bogus "start" time seen with conntrack timestamping for
   outgoing packets, never use skb->tstamp and always use current time.
2. In nfqueue and nflog, only use skb->tstamp for incoming packets,
   as determined by current hook (prerouting, input, forward).
3. xt_time has to use system clock as well rather than skb->tstamp.
   We could still use skb->tstamp for prerouting/input/foward, but
   I see no advantage to make this conditional.

Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
Cc: Eric Dumazet <edumazet@google.com>
Reported-by: Michal Soltys <soltys@ziu.info>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c |  7 ++-----
 net/netfilter/nfnetlink_log.c     |  2 +-
 net/netfilter/nfnetlink_queue.c   |  2 +-
 net/netfilter/xt_time.c           | 23 ++++++++++++++---------
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3c48d44d6fff..2a714527cde1 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1017,12 +1017,9 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 
 	/* set conntrack timestamp, if enabled. */
 	tstamp = nf_conn_tstamp_find(ct);
-	if (tstamp) {
-		if (skb->tstamp == 0)
-			__net_timestamp(skb);
+	if (tstamp)
+		tstamp->start = ktime_get_real_ns();
 
-		tstamp->start = ktime_to_ns(skb->tstamp);
-	}
 	/* Since the lookup is lockless, hash insertion must be done after
 	 * starting the timer and setting the CONFIRMED bit. The RCU barriers
 	 * guarantee that no other CPU can find the conntrack before the above
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b1f9c5303f02..7d69a02bf016 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -540,7 +540,7 @@ __build_packet_message(struct nfnl_log_net *log,
 			goto nla_put_failure;
 	}
 
-	if (skb->tstamp) {
+	if (hooknum <= NF_INET_FORWARD && skb->tstamp) {
 		struct nfulnl_msg_packet_timestamp ts;
 		struct timespec64 kts = ktime_to_timespec64(skb->tstamp);
 		ts.sec = cpu_to_be64(kts.tv_sec);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 0dcc3592d053..e057b2961d31 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -582,7 +582,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	if (nfqnl_put_bridge(entry, skb) < 0)
 		goto nla_put_failure;
 
-	if (entskb->tstamp) {
+	if (entry->state.hook <= NF_INET_FORWARD && entskb->tstamp) {
 		struct nfqnl_msg_packet_timestamp ts;
 		struct timespec64 kts = ktime_to_timespec64(entskb->tstamp);
 
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index c13bcd0ab491..8dbb4d48f2ed 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -163,19 +163,24 @@ time_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	s64 stamp;
 
 	/*
-	 * We cannot use get_seconds() instead of __net_timestamp() here.
+	 * We need real time here, but we can neither use skb->tstamp
+	 * nor __net_timestamp().
+	 *
+	 * skb->tstamp and skb->skb_mstamp_ns overlap, however, they
+	 * use different clock types (real vs monotonic).
+	 *
 	 * Suppose you have two rules:
-	 * 	1. match before 13:00
-	 * 	2. match after 13:00
+	 *	1. match before 13:00
+	 *	2. match after 13:00
+	 *
 	 * If you match against processing time (get_seconds) it
 	 * may happen that the same packet matches both rules if
-	 * it arrived at the right moment before 13:00.
+	 * it arrived at the right moment before 13:00, so it would be
+	 * better to check skb->tstamp and set it via __net_timestamp()
+	 * if needed.  This however breaks outgoing packets tx timestamp,
+	 * and causes them to get delayed forever by fq packet scheduler.
 	 */
-	if (skb->tstamp == 0)
-		__net_timestamp((struct sk_buff *)skb);
-
-	stamp = ktime_to_ns(skb->tstamp);
-	stamp = div_s64(stamp, NSEC_PER_SEC);
+	stamp = get_seconds();
 
 	if (info->flags & XT_TIME_LOCAL_TZ)
 		/* Adjust for local timezone */
-- 
2.21.0

