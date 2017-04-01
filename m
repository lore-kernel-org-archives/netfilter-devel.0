From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: ctnetlink: remove unnecessary nf_conntrack_expect_lock protection
Date: Sat,  1 Apr 2017 22:14:24 +0800
Message-ID: <1491056064-19687-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:58906 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751541AbdDAOO4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Apr 2017 10:14:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Currently, ctnetlink_change_helper() is always protected by _expect_lock,
this is unnecessary, since the operations are unrelated to _expect_lock.

Also this will cause a deadlock when deleting the helper from a conntrack,
as _expect_lock will be locked again by nf_ct_remove_expectations():

         CPU0
        ----
  lock(nf_conntrack_expect_lock);
  lock(nf_conntrack_expect_lock);

  *** DEADLOCK ***
  May be due to missing lock nesting notation

  2 locks held by lt-conntrack_gr/12853:
  #0:  (&table[i].mutex){+.+.+.}, at: [<ffffffffa05e2009>]
       nfnetlink_rcv_msg+0x399/0x6a9 [nfnetlink]
  #1:  (nf_conntrack_expect_lock){+.....}, at: [<ffffffffa05f2c1f>]
       ctnetlink_new_conntrack+0x17f/0x408 [nf_conntrack_netlink]

  Call Trace:
   dump_stack+0x85/0xc2
   __lock_acquire+0x1608/0x1680
   ? ctnetlink_parse_tuple_proto+0x10f/0x1c0 [nf_conntrack_netlink]
   lock_acquire+0x100/0x1f0
   ? nf_ct_remove_expectations+0x32/0x90 [nf_conntrack]
   _raw_spin_lock_bh+0x3f/0x50
   ? nf_ct_remove_expectations+0x32/0x90 [nf_conntrack]
   nf_ct_remove_expectations+0x32/0x90 [nf_conntrack]
   ctnetlink_change_helper+0xc6/0x190 [nf_conntrack_netlink]
   ctnetlink_new_conntrack+0x1b2/0x408 [nf_conntrack_netlink]
   nfnetlink_rcv_msg+0x60a/0x6a9 [nfnetlink]
   ? nfnetlink_rcv_msg+0x1b9/0x6a9 [nfnetlink]
   ? nfnetlink_bind+0x1a0/0x1a0 [nfnetlink]
   netlink_rcv_skb+0xa4/0xc0
   nfnetlink_rcv+0x87/0x770 [nfnetlink]

So remove these _expect_lock now.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7b83bbf..f776314 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1514,14 +1514,9 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 					    nf_ct_protonum(ct));
 	if (helper == NULL) {
 #ifdef CONFIG_MODULES
-		spin_unlock_bh(&nf_conntrack_expect_lock);
-
-		if (request_module("nfct-helper-%s", helpname) < 0) {
-			spin_lock_bh(&nf_conntrack_expect_lock);
+		if (request_module("nfct-helper-%s", helpname) < 0)
 			return -EOPNOTSUPP;
-		}
 
-		spin_lock_bh(&nf_conntrack_expect_lock);
 		helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
 						    nf_ct_protonum(ct));
 		if (helper)
@@ -1960,9 +1955,7 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
 	err = -EEXIST;
 	ct = nf_ct_tuplehash_to_ctrack(h);
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
-		spin_lock_bh(&nf_conntrack_expect_lock);
 		err = ctnetlink_change_conntrack(ct, cda);
-		spin_unlock_bh(&nf_conntrack_expect_lock);
 		if (err == 0) {
 			nf_conntrack_eventmask_report((1 << IPCT_REPLY) |
 						      (1 << IPCT_ASSURED) |
@@ -2357,11 +2350,7 @@ ctnetlink_glue_parse(const struct nlattr *attr, struct nf_conn *ct)
 	if (ret < 0)
 		return ret;
 
-	spin_lock_bh(&nf_conntrack_expect_lock);
-	ret = ctnetlink_glue_parse_ct((const struct nlattr **)cda, ct);
-	spin_unlock_bh(&nf_conntrack_expect_lock);
-
-	return ret;
+	return ctnetlink_glue_parse_ct((const struct nlattr **)cda, ct);
 }
 
 static int ctnetlink_glue_exp_parse(const struct nlattr * const *cda,
-- 
2.5.5


