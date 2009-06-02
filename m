From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/9] netfilter: ctnetlink: remove nowait parameter from
	*fill_info()
Date: Tue, 02 Jun 2009 20:18:27 +0200
Message-ID: <20090602181827.18573.73129.stgit@Decadence>
References: <20090602181336.18573.85368.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36979 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861AbZFBS1X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:27:23 -0400
In-Reply-To: <20090602181336.18573.85368.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is a cleanup, it removes the `nowait' parameter
from all *fill_info() function since it is always set to one.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nf_conntrack_netlink.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c523f0b..2d7d69f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -350,8 +350,7 @@ nla_put_failure:
 
 static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
-		    int event, int nowait,
-		    const struct nf_conn *ct)
+		    int event, const struct nf_conn *ct)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
@@ -362,7 +361,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	nlh    = NLMSG_PUT(skb, pid, seq, event, sizeof(struct nfgenmsg));
 	nfmsg  = NLMSG_DATA(nlh);
 
-	nlh->nlmsg_flags    = (nowait && pid) ? NLM_F_MULTI : 0;
+	nlh->nlmsg_flags    = pid ? NLM_F_MULTI : 0;
 	nfmsg->nfgen_family = nf_ct_l3num(ct);
 	nfmsg->version      = NFNETLINK_V0;
 	nfmsg->res_id	    = 0;
@@ -637,8 +636,7 @@ restart:
 			}
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
 						cb->nlh->nlmsg_seq,
-						IPCTNL_MSG_CT_NEW,
-						1, ct) < 0) {
+						IPCTNL_MSG_CT_NEW, ct) < 0) {
 				cb->args[1] = (unsigned long)ct;
 				goto out;
 			}
@@ -880,7 +878,7 @@ ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb,
 
 	rcu_read_lock();
 	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq,
-				  IPCTNL_MSG_CT_NEW, 1, ct);
+				  IPCTNL_MSG_CT_NEW, ct);
 	rcu_read_unlock();
 	nf_ct_put(ct);
 	if (err <= 0)
@@ -1503,9 +1501,7 @@ nla_put_failure:
 
 static int
 ctnetlink_exp_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
-		    int event,
-		    int nowait,
-		    const struct nf_conntrack_expect *exp)
+			int event, const struct nf_conntrack_expect *exp)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
@@ -1515,7 +1511,7 @@ ctnetlink_exp_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	nlh    = NLMSG_PUT(skb, pid, seq, event, sizeof(struct nfgenmsg));
 	nfmsg  = NLMSG_DATA(nlh);
 
-	nlh->nlmsg_flags    = (nowait && pid) ? NLM_F_MULTI : 0;
+	nlh->nlmsg_flags    = pid ? NLM_F_MULTI : 0;
 	nfmsg->nfgen_family = exp->tuple.src.l3num;
 	nfmsg->version	    = NFNETLINK_V0;
 	nfmsg->res_id	    = 0;
@@ -1617,10 +1613,11 @@ restart:
 					continue;
 				cb->args[1] = 0;
 			}
-			if (ctnetlink_exp_fill_info(skb, NETLINK_CB(cb->skb).pid,
+			if (ctnetlink_exp_fill_info(skb,
+						    NETLINK_CB(cb->skb).pid,
 						    cb->nlh->nlmsg_seq,
 						    IPCTNL_MSG_EXP_NEW,
-						    1, exp) < 0) {
+						    exp) < 0) {
 				if (!atomic_inc_not_zero(&exp->use))
 					continue;
 				cb->args[1] = (unsigned long)exp;
@@ -1689,8 +1686,7 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 
 	rcu_read_lock();
 	err = ctnetlink_exp_fill_info(skb2, NETLINK_CB(skb).pid,
-				      nlh->nlmsg_seq, IPCTNL_MSG_EXP_NEW,
-				      1, exp);
+				      nlh->nlmsg_seq, IPCTNL_MSG_EXP_NEW, exp);
 	rcu_read_unlock();
 	if (err <= 0)
 		goto free;

