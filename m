From: Jay Elliott <jelliott@arista.com>
Subject: [PATCH v2] netfilter: conntrack: clamp timeouts to INT_MAX
Date: Sat, 11 Nov 2017 02:08:40 -0800
Message-ID: <1510394920-25302-1-git-send-email-jelliott@arista.com>
Cc: Jay Elliott <jelliott@arista.com>, fw@strlen.de,
        netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:47715 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751138AbdKKKJA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Nov 2017 05:09:00 -0500
Received: by mail-pg0-f67.google.com with SMTP id o7so9237234pgc.4
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Nov 2017 02:09:00 -0800 (PST)
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

The upshot of this is that userspace software which is used to being able
to create conntracking timeouts >= (1<<31) can accidentally create a
negative timeout which will expire immediately.  To protect against this,
incoming timeouts are clamped to INT_MAX after they are added to the
nfct_time_stamp.

Fixes: 58e207e4983d ("netfilter: evict stale entries when user reads /proc/net/nf_conntrack")
Signed-off-by: Jay Elliott <jelliott@arista.com>
---
 net/netfilter/nf_conntrack_core.c    |  6 +++++-
 net/netfilter/nf_conntrack_netlink.c | 15 ++++++++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0113039..8f55da3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -734,6 +734,7 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
 	struct net *net;
 	unsigned int sequence;
 	int ret = NF_DROP;
+	u_int64_t timeout64;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	net = nf_ct_net(ct);
@@ -796,7 +797,10 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
 	/* Timer relative to confirmation time, not original
 	   setting time, otherwise we'd get timer wrap in
 	   weird delay cases. */
-	ct->timeout += nfct_time_stamp;
+	timeout64 = (u_int64_t)ct->timeout + nfct_time_stamp;
+	if (timeout64 > INT_MAX)
+		timeout64 = INT_MAX;
+	ct->timeout = timeout64;
 	atomic_inc(&ct->ct_general.use);
 	ct->status |= IPS_CONFIRMED;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index de4053d..3db8e03 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1560,9 +1560,12 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 static int ctnetlink_change_timeout(struct nf_conn *ct,
 				    const struct nlattr * const cda[])
 {
-	u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
+	u_int64_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
+	u_int64_t timeout_absolute = timeout * HZ + (u_int64_t)nfct_time_stamp;
 
-	ct->timeout = nfct_time_stamp + timeout * HZ;
+	if (timeout_absolute > INT_MAX)
+		timeout_absolute = INT_MAX;
+	ct->timeout = timeout_absolute;
 
 	if (test_bit(IPS_DYING_BIT, &ct->status))
 		return -ETIME;
@@ -1762,6 +1765,8 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
 	int err = -EINVAL;
 	struct nf_conntrack_helper *helper;
 	struct nf_conn_tstamp *tstamp;
+	u_int64_t timeout_absolute;
+	u_int64_t timeout_nla;
 
 	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
 	if (IS_ERR(ct))
@@ -1770,7 +1775,11 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
 	if (!cda[CTA_TIMEOUT])
 		goto err1;
 
-	ct->timeout = nfct_time_stamp + ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
+	timeout_nla = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
+	timeout_absolute = (u_int64_t)nfct_time_stamp + timeout_nla * HZ;
+	if (timeout_absolute > INT_MAX)
+		timeout_absolute = INT_MAX;
+	ct->timeout = timeout_absolute;
 
 	rcu_read_lock();
  	if (cda[CTA_HELP]) {
-- 
1.8.1.4

