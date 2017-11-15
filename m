From: Jay Elliott <jelliott@arista.com>
Subject: [PATCH v4] netfilter: conntrack: clamp timeouts to INT_MAX
Date: Wed, 15 Nov 2017 15:01:13 -0800
Message-ID: <1510786873-60834-1-git-send-email-jelliott@arista.com>
Cc: Jay Elliott <jelliott@arista.com>, fw@strlen.de,
        netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:54996 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752929AbdKOXB7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2017 18:01:59 -0500
Received: by mail-pg0-f65.google.com with SMTP id c123so11074250pga.11
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2017 15:01:58 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When the conntracking code multiplies a timeout by HZ, it can overflow
from positive to negative; this causes it to instantly expire.  To
protect against this the multiplication is done in 64-bit so we can
prevent it from exceeding INT_MAX.

Signed-off-by: Jay Elliott <jelliott@arista.com>
---
 net/netfilter/nf_conntrack_netlink.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index de4053d..41db7e3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1560,9 +1560,11 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 static int ctnetlink_change_timeout(struct nf_conn *ct,
 				    const struct nlattr * const cda[])
 {
-	u_int32_t timeout = ntohl(nla_get_be32(cda[CTA_TIMEOUT]));
+	u64 timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
 
-	ct->timeout = nfct_time_stamp + timeout * HZ;
+	if (timeout > INT_MAX)
+		timeout = INT_MAX;
+	ct->timeout = nfct_time_stamp + (u32)timeout;
 
 	if (test_bit(IPS_DYING_BIT, &ct->status))
 		return -ETIME;
@@ -1762,6 +1764,7 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
 	int err = -EINVAL;
 	struct nf_conntrack_helper *helper;
 	struct nf_conn_tstamp *tstamp;
+	u64 timeout;
 
 	ct = nf_conntrack_alloc(net, zone, otuple, rtuple, GFP_ATOMIC);
 	if (IS_ERR(ct))
@@ -1770,7 +1773,10 @@ static int change_seq_adj(struct nf_ct_seqadj *seq,
 	if (!cda[CTA_TIMEOUT])
 		goto err1;
 
-	ct->timeout = nfct_time_stamp + ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
+	timeout = (u64)ntohl(nla_get_be32(cda[CTA_TIMEOUT])) * HZ;
+	if (timeout > INT_MAX)
+		timeout = INT_MAX;
+	ct->timeout = (u32)timeout + nfct_time_stamp;
 
 	rcu_read_lock();
  	if (cda[CTA_HELP]) {
-- 
1.8.1.4

