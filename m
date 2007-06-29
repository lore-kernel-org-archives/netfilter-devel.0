From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/20]: nf_conntrack_netlink: sync expectation dumping
	with conntrack table dumping
Date: Fri, 29 Jun 2007 02:45:09 +0200 (MEST)
Message-ID: <20070629004407.25566.83914.sendpatchset@localhost.localdomain>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack_netlink: sync expectation dumping with conntrack table dumping

Resync expectation table dumping code with conntrack dumping: don't
rely on the unique ID anymore since that requires to walk the list
backwards, which doesn't work with the upcoming conversion to hlists.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cdc10a2f177526ac7723aac65c46980979aaca87
tree 7c19bfff87bbe181056f56a09ee0c03d72470da1
parent b7e3977052189e3400e250559b29d14431dc9964
author Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:11:04 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 29 Jun 2007 02:11:04 +0200

 net/netfilter/nf_conntrack_netlink.c |   32 +++++++++++++++++++++++++-------
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2064914..3707ffe 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1235,32 +1235,50 @@ nfattr_failure:
 	return NOTIFY_DONE;
 }
 #endif
+static int ctnetlink_exp_done(struct netlink_callback *cb)
+{
+	if (cb->args[0])
+		nf_ct_expect_put((struct nf_conntrack_expect *)cb->args[1]);
+	return 0;
+}
 
 static int
 ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct nf_conntrack_expect *exp = NULL;
+	struct nf_conntrack_expect *exp, *last;
 	struct list_head *i;
-	u_int32_t *id = (u_int32_t *) &cb->args[0];
 	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
 	read_lock_bh(&nf_conntrack_lock);
+	last = (struct nf_conntrack_expect *)cb->args[0];
+restart:
 	list_for_each_prev(i, &nf_ct_expect_list) {
 		exp = (struct nf_conntrack_expect *) i;
 		if (l3proto && exp->tuple.src.l3num != l3proto)
 			continue;
-		if (exp->id <= *id)
-			continue;
+		if (cb->args[0]) {
+			if (exp != last)
+				continue;
+			cb->args[0] = 0;
+		}
 		if (ctnetlink_exp_fill_info(skb, NETLINK_CB(cb->skb).pid,
 					    cb->nlh->nlmsg_seq,
 					    IPCTNL_MSG_EXP_NEW,
-					    1, exp) < 0)
+					    1, exp) < 0) {
+			atomic_inc(&exp->use);
+			cb->args[0] = (unsigned long)exp;
 			goto out;
-		*id = exp->id;
+		}
+	}
+	if (cb->args[0]) {
+		cb->args[0] = 0;
+		goto restart;
 	}
 out:
 	read_unlock_bh(&nf_conntrack_lock);
+	if (last)
+		nf_ct_expect_put(last);
 
 	return skb->len;
 }
@@ -1287,7 +1305,7 @@ ctnetlink_get_expect(struct sock *ctnl, struct sk_buff *skb,
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		return netlink_dump_start(ctnl, skb, nlh,
 					  ctnetlink_exp_dump_table,
-					  ctnetlink_done);
+					  ctnetlink_exp_done);
 	}
 
 	if (cda[CTA_EXPECT_MASTER-1])
