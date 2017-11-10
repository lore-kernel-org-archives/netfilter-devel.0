From: Jay Elliott <jelliott@arista.com>
Subject: [PATCH] netfilter: conntrack: use 64-bit conntracking timestamps
Date: Fri, 10 Nov 2017 15:21:21 -0800
Message-ID: <1510356081-35555-1-git-send-email-jelliott@arista.com>
Cc: Jay Elliott <jelliott@arista.com>, fw@strlen.de,
        netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:55267 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdKJXVY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Nov 2017 18:21:24 -0500
Received: by mail-pg0-f65.google.com with SMTP id c123so454433pga.11
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Nov 2017 15:21:24 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As of commit 58e207e4983d ("netfilter: evict stale entries when user reads
/proc/net/nf_conntrack"), timeouts are evaluated by casting the difference
between a timeout value and the nfct_time_stamp to a signed integer and
comparing that to zero.

This means that any timeout greater than or equal to (1<<31) will be
considered negative, and the conntracking code will think it has
immediately expired.  Prior to 58e207e4983d, they would have been treated
as very large positive timeouts.

Using 64-bit will allow the full range of a 32-bit unsigned integer to be
used as a positive value without changing any of the logic used to
evaluate timeouts.  The timeout value input from userspace over the
netlink is still 32-bit.

Fixes: 58e207e4983d ("netfilter: evict stale entries when user reads /proc/net/nf_conntrack")
Signed-off-by: Jay Elliott <jelliott@arista.com>
---
 include/net/netfilter/nf_conntrack.h | 10 +++++-----
 net/netfilter/nf_conntrack_netlink.c |  6 ++++--
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 792c3f6..62bfc33 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -71,8 +71,8 @@ struct nf_conn {
 	/* Have we seen traffic both ways yet? (bitset) */
 	unsigned long status;
 
-	/* jiffies32 when this ct is considered dead */
-	u32 timeout;
+	/* jiffies64 when this ct is considered dead */
+	u64 timeout;
 
 	possible_net_t ct_net;
 
@@ -261,19 +261,19 @@ static inline bool nf_is_loopback_packet(const struct sk_buff *skb)
 	return skb->dev && skb->skb_iif && skb->dev->flags & IFF_LOOPBACK;
 }
 
-#define nfct_time_stamp ((u32)(jiffies))
+#define nfct_time_stamp (get_jiffies_64())
 
 /* jiffies until ct expires, 0 if already expired */
 static inline unsigned long nf_ct_expires(const struct nf_conn *ct)
 {
-	s32 timeout = ct->timeout - nfct_time_stamp;
+	s64 timeout = ct->timeout - nfct_time_stamp;
 
 	return timeout > 0 ? timeout : 0;
 }
 
 static inline bool nf_ct_is_expired(const struct nf_conn *ct)
 {
-	return (__s32)(ct->timeout - nfct_time_stamp) <= 0;
+	return (__s64)(ct->timeout - nfct_time_stamp) <= 0;
 }
 
 /* use after obtaining a reference count */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index de4053d..82e3ef6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1562,7 +1562,7 @@ static int ctnetlink_change_timeout(struct nf_conn *ct,
 {
 	u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
 
-	ct->timeout = nfct_time_stamp + timeout * HZ;
+	ct->timeout = nfct_time_stamp + (u_int64_t)timeout * HZ;
 
 	if (test_bit(IPS_DYING_BIT, &ct->status))
 		return -ETIME;
@@ -1762,6 +1762,7 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
 	int err = -EINVAL;
 	struct nf_conntrack_helper *helper;
 	struct nf_conn_tstamp *tstamp;
+	u64 timeout_nla;
 
 	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
 	if (IS_ERR(ct))
@@ -1770,7 +1771,8 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
 	if (!cda[CTA_TIMEOUT])
 		goto err1;
 
-	ct->timeout = nfct_time_stamp + ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
+	timeout_nla = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
+	ct->timeout = nfct_time_stamp + timeout_nla * HZ;
 
 	rcu_read_lock();
  	if (cda[CTA_HELP]) {
-- 
1.8.1.4

