Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971EAC282CE
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D9AD206A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 20:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbfDVUsW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 16:48:22 -0400
Received: from mail.us.es ([193.147.175.20]:46740 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730767AbfDVUsO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 16:48:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A64A9443823
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97A70DA702
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 22:48:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8D61EDA70E; Mon, 22 Apr 2019 22:48:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59D08DA702;
        Mon, 22 Apr 2019 22:48:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Apr 2019 22:48:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2FDE24265A32;
        Mon, 22 Apr 2019 22:48:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/10] netfilter: never get/set skb->tstamp
Date:   Mon, 22 Apr 2019 22:48:00 +0200
Message-Id: <20190422204801.26321-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190422204801.26321-1-pablo@netfilter.org>
References: <20190422204801.26321-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index b1f9c5303f02..0b3347570265 100644
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
2.11.0

