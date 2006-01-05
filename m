From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 11/18]: Filter dumped entries based on the layer 3
	protocol number
Date: Thu,  5 Jan 2006 05:06:45 +0100 (MET)
Message-ID: <20060105040609.23512.34371.sendpatchset@localhost.localdomain>
References: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Filter dumped entries based on the layer 3 protocol number

Dump entries of a given Layer 3 protocol number.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d5c7bf63c8ae6153ecdf70add3f5b935d4b088a1
tree 648df16ff36e9395298e7e9bcddfebf2e06b325e
parent 61f61d46374f12a54086fe865242a3f248961d6e
author Pablo Neira Ayuso <pablo@netfilter.org> Thu, 05 Jan 2006 02:58:02 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:58:02 +0100

 net/netfilter/nf_conntrack_netlink.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4f2e509..73ab16b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -400,6 +400,8 @@ static int ctnetlink_done(struct netlink
 	return 0;
 }
 
+#define L3PROTO(ct) ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num
+
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
@@ -407,6 +409,8 @@ ctnetlink_dump_table(struct sk_buff *skb
 	struct nf_conntrack_tuple_hash *h;
 	struct list_head *i;
 	u_int32_t *id = (u_int32_t *) &cb->args[1];
+	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
+	u_int8_t l3proto = nfmsg->nfgen_family;
 
 	DEBUGP("entered %s, last bucket=%lu id=%u\n", __FUNCTION__, 
 			cb->args[0], *id);
@@ -418,6 +422,11 @@ ctnetlink_dump_table(struct sk_buff *skb
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
+			/* Dump entries of a given L3 protocol number.
+			 * If it is not specified, ie. l3proto == 0,
+			 * then dump everything. */
+			if (l3proto && L3PROTO(ct) != l3proto)
+				continue;
 			if (ct->id <= *id)
 				continue;
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
@@ -444,6 +453,8 @@ ctnetlink_dump_table_w(struct sk_buff *s
 	struct nf_conntrack_tuple_hash *h;
 	struct list_head *i;
 	u_int32_t *id = (u_int32_t *) &cb->args[1];
+	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
+	u_int8_t l3proto = nfmsg->nfgen_family;	
 
 	DEBUGP("entered %s, last bucket=%u id=%u\n", __FUNCTION__, 
 			cb->args[0], *id);
@@ -455,6 +466,8 @@ ctnetlink_dump_table_w(struct sk_buff *s
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
+			if (l3proto && L3PROTO(ct) != l3proto)
+				continue;
 			if (ct->id <= *id)
 				continue;
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
@@ -750,9 +763,6 @@ ctnetlink_get_conntrack(struct sock *ctn
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		u32 rlen;
 
-		if (nfmsg->nfgen_family != AF_INET)
-			return -EAFNOSUPPORT;
-
 		if (NFNL_MSG_TYPE(nlh->nlmsg_type) ==
 					IPCTNL_MSG_CT_GET_CTRZERO) {
 #ifdef CONFIG_NF_CT_ACCT
@@ -1251,12 +1261,16 @@ ctnetlink_exp_dump_table(struct sk_buff 
 	struct nf_conntrack_expect *exp = NULL;
 	struct list_head *i;
 	u_int32_t *id = (u_int32_t *) &cb->args[0];
+	struct nfgenmsg *nfmsg = NLMSG_DATA(cb->nlh);
+	u_int8_t l3proto = nfmsg->nfgen_family;
 
 	DEBUGP("entered %s, last id=%llu\n", __FUNCTION__, *id);
 
 	read_lock_bh(&nf_conntrack_lock);
 	list_for_each_prev(i, &nf_conntrack_expect_list) {
 		exp = (struct nf_conntrack_expect *) i;
+		if (l3proto && exp->tuple.src.l3num != l3proto)
+			continue;
 		if (exp->id <= *id)
 			continue;
 		if (ctnetlink_exp_fill_info(skb, NETLINK_CB(cb->skb).pid,
@@ -1298,9 +1312,6 @@ ctnetlink_get_expect(struct sock *ctnl, 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		u32 rlen;
 
-		if (nfmsg->nfgen_family != AF_INET)
-			return -EAFNOSUPPORT;
-
 		if ((*errp = netlink_dump_start(ctnl, skb, nlh,
 		    				ctnetlink_exp_dump_table,
 						ctnetlink_done)) != 0)
