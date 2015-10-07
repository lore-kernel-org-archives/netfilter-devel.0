From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next] netfilter: nf_conntrack_netlink: fix locks around
 helper module loading
Date: Wed, 7 Oct 2015 13:30:38 +0900
Message-ID: <20151007043038.GE23203@gmail.com>
References: <1443724990-4014-1-git-send-email-pablo@netfilter.org>
 <1443724990-4014-2-git-send-email-pablo@netfilter.org>
 <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34283 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbbJGEan (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Oct 2015 00:30:43 -0400
Received: by padhy16 with SMTP id hy16so8440514pad.1
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2015 21:30:43 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20151007042016.GA23203@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are two paths for calling ctnetlink_change_helper which may
call request_module() which requires nfnl lock, and may also call
__nf_conntrack_helper_find() which needs rcu read lock.

    - nfqnl_cb[NFQNL_MSG_VERDICT].call_rcu / nfqnl_recv_verdict()
    - ctnl_cb[IPCTNL_MSG_CT_NEW].call / ctnetlink_new_conntrack()

These uses different lock mechanism, it seems we need to adjust it.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nf_conntrack_netlink.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index dd13596..9121226 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1497,12 +1497,17 @@ ctnetlink_change_helper(struct nf_conn *ct, const struct nlattr * const cda[])
 	if (helper == NULL) {
 #ifdef CONFIG_MODULES
 		spin_unlock_bh(&nf_conntrack_expect_lock);
-
+		rcu_read_unlock();
+		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
 		if (request_module("nfct-helper-%s", helpname) < 0) {
+			nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+			rcu_read_lock();
 			spin_lock_bh(&nf_conntrack_expect_lock);
 			return -EOPNOTSUPP;
 		}
 
+		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+		rcu_read_lock();
 		spin_lock_bh(&nf_conntrack_expect_lock);
 		helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
 						    nf_ct_protonum(ct));
@@ -1943,9 +1948,11 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 	err = -EEXIST;
 	ct = nf_ct_tuplehash_to_ctrack(h);
 	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
+		rcu_read_lock();
 		spin_lock_bh(&nf_conntrack_expect_lock);
 		err = ctnetlink_change_conntrack(ct, cda);
 		spin_unlock_bh(&nf_conntrack_expect_lock);
+		rcu_read_unlock();
 		if (err == 0) {
 			nf_conntrack_eventmask_report((1 << IPCT_REPLY) |
 						      (1 << IPCT_ASSURED) |
@@ -2287,7 +2294,9 @@ ctnetlink_glue_parse_ct(const struct nlattr *cda[], struct nf_conn *ct)
 			return err;
 	}
 	if (cda[CTA_HELP]) {
+		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
 		err = ctnetlink_change_helper(ct, cda);
+		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
 		if (err < 0)
 			return err;
 	}
-- 
1.7.10.4

