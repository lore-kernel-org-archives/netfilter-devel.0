From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: ctnetlink: skip dumping expect when nfct_help(ct) is NULL
Date: Sun,  2 Apr 2017 18:01:33 +0800
Message-ID: <1491127293-11235-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:47702 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751024AbdDBKCJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Apr 2017 06:02:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

For IPCTNL_MSG_EXP_GET, if the CTA_EXPECT_MASTER attr is specified, then
the NLM_F_DUMP request will dump the expectations related to this
connection tracking.

But we forget to check whether the conntrack has nf_conn_help or not,
so if nfct_help(ct) is NULL, oops will happen:

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
 IP: ctnetlink_exp_ct_dump_table+0xf9/0x1e0 [nf_conntrack_netlink]
 Call Trace:
  ? ctnetlink_exp_ct_dump_table+0x75/0x1e0 [nf_conntrack_netlink]
  netlink_dump+0x124/0x2a0
  __netlink_dump_start+0x161/0x190
  ctnetlink_dump_exp_ct+0x16c/0x1bc [nf_conntrack_netlink]
  ? ctnetlink_exp_fill_info.constprop.33+0xf0/0xf0 [nf_conntrack_netlink]
  ? ctnetlink_glue_seqadj+0x20/0x20 [nf_conntrack_netlink]
  ctnetlink_get_expect+0x32e/0x370 [nf_conntrack_netlink]
  ? debug_lockdep_rcu_enabled+0x1d/0x20
  nfnetlink_rcv_msg+0x60a/0x6a9 [nfnetlink]
  ? nfnetlink_rcv_msg+0x1b9/0x6a9 [nfnetlink]
  [...]

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f776314..1bb2f27 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2783,6 +2783,12 @@ static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
 		return -ENOENT;
 
 	ct = nf_ct_tuplehash_to_ctrack(h);
+	/* No expectation linked to this connection tracking. */
+	if (!nfct_help(ct)) {
+		nf_ct_put(ct);
+		return 0;
+	}
+
 	c.data = ct;
 
 	err = netlink_dump_start(ctnl, skb, nlh, &c);
-- 
2.5.5


