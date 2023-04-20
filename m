Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCF1C77B7F
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Apr 2023 17:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjDTRHG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Apr 2023 13:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjDTRHF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2023 13:07:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2F4211C;
        Thu, 20 Apr 2023 10:07:03 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 2/2] netfilter: conntrack: fix wrong ct->timeout value
Date:   Thu, 20 Apr 2023 19:06:57 +0200
Message-Id: <20230420170657.45373-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230420170657.45373-1-pablo@netfilter.org>
References: <20230420170657.45373-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@kernel.org>

(struct nf_conn)->timeout is an interval before the conntrack
confirmed.  After confirmed, it becomes a timestamp.

It is observed that timeout of an unconfirmed conntrack:
- Set by calling ctnetlink_change_timeout(). As a result,
  `nfct_time_stamp` was wrongly added to `ct->timeout` twice.
- Get by calling ctnetlink_dump_timeout(). As a result,
  `nfct_time_stamp` was wrongly subtracted.

Call Trace:
 <TASK>
 dump_stack_lvl
 ctnetlink_dump_timeout
 __ctnetlink_glue_build
 ctnetlink_glue_build
 __nfqnl_enqueue_packet
 nf_queue
 nf_hook_slow
 ip_mc_output
 ? __pfx_ip_finish_output
 ip_send_skb
 ? __pfx_dst_output
 udp_send_skb
 udp_sendmsg
 ? __pfx_ip_generic_getfrag
 sock_sendmsg

Separate the 2 cases in:
- Setting `ct->timeout` in __nf_ct_set_timeout().
- Getting `ct->timeout` in ctnetlink_dump_timeout().

Pablo appends:

Update ctnetlink to set up the timeout _after_ the IPS_CONFIRMED flag is
set on, otherwise conntrack creation via ctnetlink breaks.

Note that the problem described in this patch occurs since the
introduction of the nfnetlink_queue conntrack support, select a
sufficiently old Fixes: tag for -stable kernel to pick up this fix.

Fixes: a4b4766c3ceb ("netfilter: nfnetlink_queue: rename related to nfqueue attaching conntrack info")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_core.h |  6 +++++-
 net/netfilter/nf_conntrack_netlink.c      | 13 +++++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 71d1269fe4d4..3384859a8921 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -89,7 +89,11 @@ static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
 {
 	if (timeout > INT_MAX)
 		timeout = INT_MAX;
-	WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
+
+	if (nf_ct_is_confirmed(ct))
+		WRITE_ONCE(ct->timeout, nfct_time_stamp + (u32)timeout);
+	else
+		ct->timeout = (u32)timeout;
 }
 
 int __nf_ct_change_timeout(struct nf_conn *ct, u64 cta_timeout);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d3ee18854698..6f3b23a6653c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -176,7 +176,12 @@ static int ctnetlink_dump_status(struct sk_buff *skb, const struct nf_conn *ct)
 static int ctnetlink_dump_timeout(struct sk_buff *skb, const struct nf_conn *ct,
 				  bool skip_zero)
 {
-	long timeout = nf_ct_expires(ct) / HZ;
+	long timeout;
+
+	if (nf_ct_is_confirmed(ct))
+		timeout = nf_ct_expires(ct) / HZ;
+	else
+		timeout = ct->timeout / HZ;
 
 	if (skip_zero && timeout == 0)
 		return 0;
@@ -2253,9 +2258,6 @@ ctnetlink_create_conntrack(struct net *net,
 	if (!cda[CTA_TIMEOUT])
 		goto err1;
 
-	timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
-	__nf_ct_set_timeout(ct, timeout);
-
 	rcu_read_lock();
  	if (cda[CTA_HELP]) {
 		char *helpname = NULL;
@@ -2319,6 +2321,9 @@ ctnetlink_create_conntrack(struct net *net,
 	/* we must add conntrack extensions before confirmation. */
 	ct->status |= IPS_CONFIRMED;
 
+	timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
+	__nf_ct_set_timeout(ct, timeout);
+
 	if (cda[CTA_STATUS]) {
 		err = ctnetlink_change_status(ct, cda);
 		if (err < 0)
-- 
2.30.2

