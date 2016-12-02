From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 11/11] netfilter: nf_tables: allow to filter stateful object dumps by type
Date: Fri,  2 Dec 2016 19:08:41 +0100
Message-ID: <1480702121-1782-12-git-send-email-pablo@netfilter.org>
References: <1480702121-1782-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47734 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752998AbcLBSJ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2016 13:09:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EF51DD2E49
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:09:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DDFA2DA38C
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:09:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C26A9DA392
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:59 +0100 (CET)
In-Reply-To: <1480702121-1782-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the netlink code to filter out dump of stateful objects,
through the NFTA_OBJ_TYPE netlink attribute.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Fix broken filtering by replacing "continue;" by "goto cont;" in
    nf_tables_dump_obj() loop.

 net/netfilter/nf_tables_api.c | 50 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b1142e16d092..94fdf99a7a67 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4173,12 +4173,18 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
+struct nft_obj_filter {
+	char		table[NFT_OBJ_MAXNAMELEN];
+	u32		type;
+};
+
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	const struct nft_af_info *afi;
 	const struct nft_table *table;
 	unsigned int idx = 0, s_idx = cb->args[0];
+	struct nft_obj_filter *filter = cb->data;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nft_object *obj;
@@ -4203,6 +4209,13 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				if (idx > s_idx)
 					memset(&cb->args[1], 0,
 					       sizeof(cb->args) - sizeof(cb->args[0]));
+				if (filter->table[0] &&
+				    strcmp(filter->table, table->name))
+					goto cont;
+				if (filter->type != NFT_OBJECT_UNSPEC &&
+				    obj->type->type != filter->type)
+					goto cont;
+
 				if (nf_tables_fill_obj_info(skb, net, NETLINK_CB(cb->skb).portid,
 							    cb->nlh->nlmsg_seq,
 							    NFT_MSG_NEWOBJ,
@@ -4223,6 +4236,31 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int nf_tables_dump_obj_done(struct netlink_callback *cb)
+{
+	kfree(cb->data);
+
+	return 0;
+}
+
+static struct nft_obj_filter *
+nft_obj_filter_alloc(const struct nlattr * const nla[])
+{
+	struct nft_obj_filter *filter;
+
+	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
+	if (!filter)
+		return ERR_PTR(-ENOMEM);
+
+	if (nla[NFTA_OBJ_TABLE])
+		nla_strlcpy(filter->table, nla[NFTA_OBJ_TABLE],
+			    NFT_TABLE_MAXNAMELEN);
+	if (nla[NFTA_OBJ_TYPE])
+		filter->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
+
+	return filter;
+}
+
 static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 			    struct sk_buff *skb, const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[])
@@ -4241,7 +4279,19 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nf_tables_dump_obj,
+			.done = nf_tables_dump_obj_done,
 		};
+
+		if (nla[NFTA_OBJ_TABLE] ||
+		    nla[NFTA_OBJ_TYPE]) {
+			struct nft_obj_filter *filter;
+
+			filter = nft_obj_filter_alloc(nla);
+			if (IS_ERR(filter))
+				return -ENOMEM;
+
+			c.data = filter;
+		}
 		return netlink_dump_start(nlsk, skb, nlh, &c);
 	}
 
-- 
2.1.4

