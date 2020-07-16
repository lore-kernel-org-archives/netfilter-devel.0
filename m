Return-Path: <SRS0=+/pN=A3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB8AC433E2
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 08:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 394E620760
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jul 2020 08:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGPIRA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 04:17:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55606 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725867AbgGPIRA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 04:17:00 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 14212C23DDC0A6FE4BA0;
        Thu, 16 Jul 2020 16:16:58 +0800 (CST)
Received: from huawei.com (10.179.179.12) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 16 Jul 2020
 16:16:48 +0800
From:   guodeqing <geffrey.guo@huawei.com>
To:     <wensong@linux-vs.org>
CC:     <horms@verge.net.au>, <ja@ssi.bg>, <pablo@netfilter.org>,
        <kadlec@netfilter.org>, <fw@strlen.de>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <lvs-devel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <geffrey.guo@huawei.com>
Subject: [PATCH,v2] ipvs: fix the connection sync failed in some cases
Date:   Thu, 16 Jul 2020 16:12:08 +0800
Message-ID: <1594887128-7453-1-git-send-email-geffrey.guo@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.179.179.12]
X-CFilter-Loop: Reflected
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The sync_thread_backup only checks sk_receive_queue is empty or not,
there is a situation which cannot sync the connection entries when
sk_receive_queue is empty and sk_rmem_alloc is larger than sk_rcvbuf,
the sync packets are dropped in __udp_enqueue_schedule_skb, this is
because the packets in reader_queue is not read, so the rmem is
not reclaimed.

Here I add the check of whether the reader_queue of the udp sock is
empty or not to solve this problem.

Fixes: 2276f58ac589 ("udp: use a separate rx queue for packet reception")
Reported-by: zhouxudong <zhouxudong8@huawei.com>
Signed-off-by: guodeqing <geffrey.guo@huawei.com>
---
 net/netfilter/ipvs/ip_vs_sync.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 605e0f6..2b8abbf 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1717,6 +1717,8 @@ static int sync_thread_backup(void *data)
 {
 	struct ip_vs_sync_thread_data *tinfo = data;
 	struct netns_ipvs *ipvs = tinfo->ipvs;
+	struct sock *sk = tinfo->sock->sk;
+	struct udp_sock *up = udp_sk(sk);
 	int len;
 
 	pr_info("sync thread started: state = BACKUP, mcast_ifn = %s, "
@@ -1724,12 +1726,14 @@ static int sync_thread_backup(void *data)
 		ipvs->bcfg.mcast_ifn, ipvs->bcfg.syncid, tinfo->id);
 
 	while (!kthread_should_stop()) {
-		wait_event_interruptible(*sk_sleep(tinfo->sock->sk),
-			 !skb_queue_empty(&tinfo->sock->sk->sk_receive_queue)
-			 || kthread_should_stop());
+		wait_event_interruptible(*sk_sleep(sk),
+					 !skb_queue_empty_lockless(&sk->sk_receive_queue) ||
+					 !skb_queue_empty_lockless(&up->reader_queue) ||
+					 kthread_should_stop());
 
 		/* do we have data now? */
-		while (!skb_queue_empty(&(tinfo->sock->sk->sk_receive_queue))) {
+		while (!skb_queue_empty_lockless(&sk->sk_receive_queue) ||
+		       !skb_queue_empty_lockless(&up->reader_queue)) {
 			len = ip_vs_receive(tinfo->sock, tinfo->buf,
 					ipvs->bcfg.sync_maxlen);
 			if (len <= 0) {
-- 
2.7.4

