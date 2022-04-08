Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8719C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 12:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbiDHNAs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 09:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiDHNAr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 09:00:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 209522ED6F
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 05:58:43 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C0C9D643B8;
        Fri,  8 Apr 2022 14:54:52 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf-next RFC 2/2] netfilter: conntrack: skip event delivery for the netns exit path
Date:   Fri,  8 Apr 2022 14:58:37 +0200
Message-Id: <20220408125837.221673-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220408125837.221673-1-pablo@netfilter.org>
References: <20220408125837.221673-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

70e9942f17a6 ("netfilter: nf_conntrack: make event callback registration
per-netns") introduced a per-netns callback for events to workaround a
crash when delivering conntrack events on a stale per-netns nfnetlink
kernel socket.

This patch adds a new flag to the nf_ct_iter_data object to skip event
delivery from the netns cleanup path to address this issue.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
compiled tested only.

@Florian: Maybe this helps to remove the per-netns nf_conntrack_event_cb
callback without having to update nfnetlink to deal with this corner case?

 include/net/netfilter/nf_conntrack.h |  8 +++++++-
 net/netfilter/nf_conntrack_core.c    | 14 +++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 14dd6bbe360c..25687bb80a64 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -199,7 +199,12 @@ void nf_ct_netns_put(struct net *net, u8 nfproto);
 void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls);
 
 int nf_conntrack_hash_check_insert(struct nf_conn *ct);
-bool nf_ct_delete(struct nf_conn *ct, u32 pid, int report);
+
+bool __nf_ct_delete(struct nf_conn *ct, u32 portid, int report, bool skip_event);
+static inline bool nf_ct_delete(struct nf_conn *ct, u32 pid, int report)
+{
+	return __nf_ct_delete(ct, pid, report, false);
+}
 
 bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 		       u_int16_t l3num, struct net *net,
@@ -244,6 +249,7 @@ struct nf_ct_iter_data {
 	void *data;
 	u32 portid;
 	int report;
+	bool skip_event;
 };
 
 /* Iterate over all conntracks: if iter returns true, it's deleted. */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 93c30c16bade..51d248ee28ca 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -687,7 +687,7 @@ static void nf_ct_delete_from_lists(struct nf_conn *ct)
 	local_bh_enable();
 }
 
-bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
+bool __nf_ct_delete(struct nf_conn *ct, u32 portid, int report, bool skip_event)
 {
 	struct nf_conn_tstamp *tstamp;
 	struct net *net;
@@ -704,6 +704,9 @@ bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 			tstamp->stop -= jiffies_to_nsecs(-timeout);
 	}
 
+	if (skip_event)
+		goto out;
+
 	if (nf_conntrack_event_report(IPCT_DESTROY, ct,
 				    portid, report) < 0) {
 		/* destroy event was not delivered. nf_ct_put will
@@ -717,6 +720,8 @@ bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 	net = nf_ct_net(ct);
 	if (nf_conntrack_ecache_dwork_pending(net))
 		nf_conntrack_ecache_work(net, NFCT_ECACHE_DESTROY_SENT);
+
+out:
 	nf_ct_delete_from_lists(ct);
 	nf_ct_put(ct);
 	return true;
@@ -2383,7 +2388,8 @@ static void nf_ct_iterate_cleanup(int (*iter)(struct nf_conn *i, void *data),
 	while ((ct = get_next_corpse(iter, iter_data, &bucket)) != NULL) {
 		/* Time to push up daises... */
 
-		nf_ct_delete(ct, iter_data->portid, iter_data->report);
+		__nf_ct_delete(ct, iter_data->portid, iter_data->report,
+			       iter_data->skip_event);
 		nf_ct_put(ct);
 		cond_resched();
 	}
@@ -2532,7 +2538,9 @@ void nf_conntrack_cleanup_net(struct net *net)
 
 void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 {
-	struct nf_ct_iter_data iter_data = {};
+	struct nf_ct_iter_data iter_data = {
+		.skip_event	= true,
+	};
 	struct net *net;
 	int busy;
 
-- 
2.30.2

