From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH] netfilter: nf_tables: Attach process info to NFT_MSG_NEWGEN notifications
Date: Wed, 19 Jul 2017 16:32:23 +0200
Message-ID: <20170719143223.3618-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:48573 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753174AbdGSOcf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2017 10:32:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is helpful for 'nft monitor' to track which process caused a given
change to the ruleset.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c            | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 683f6f88fcace..6f0a950e21c39 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1221,6 +1221,8 @@ enum nft_objref_attributes {
 enum nft_gen_attributes {
 	NFTA_GEN_UNSPEC,
 	NFTA_GEN_ID,
+	NFTA_GEN_PROC_PID,
+	NFTA_GEN_PROC_NAME,
 	__NFTA_GEN_MAX
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7843efa33c598..f880ec9f9abef 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4662,6 +4662,7 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
+	char buf[TASK_COMM_LEN];
 	int event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, NFT_MSG_NEWGEN);
 
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg), 0);
@@ -4673,7 +4674,9 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 	nfmsg->version		= NFNETLINK_V0;
 	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
 
-	if (nla_put_be32(skb, NFTA_GEN_ID, htonl(net->nft.base_seq)))
+	if (nla_put_be32(skb, NFTA_GEN_ID, htonl(net->nft.base_seq)) ||
+	    nla_put_be32(skb, NFTA_GEN_PROC_PID, htonl(task_pid_nr(current))) ||
+	    nla_put_string(skb, NFTA_GEN_PROC_NAME, get_task_comm(buf, current)))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
-- 
2.13.1

