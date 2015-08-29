From: Vijay Subramanian <subramanian.vijay@gmail.com>
Subject: [PATCH nf 1/1] nft: Fix nlmsg_type in GET operation callbacks
Date: Sat, 29 Aug 2015 15:34:55 -0700
Message-ID: <1440887695-15068-1-git-send-email-subramanian.vijay@gmail.com>
Cc: pablo@netfilter.org,
	Vijay Subramanian <subramanian.vijay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36813 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbbH2WfO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Aug 2015 18:35:14 -0400
Received: by qkda128 with SMTP id a128so46014751qkd.3
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2015 15:35:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_tables_gettable(), nf_tables_getchain() and nf_tables_getrule()
send replies with nlmsg_type that correspond to ADD operation
instead of GET. Set the type correctly.

Signed-off-by: Vijay Subramanian <subramanian.vijay@gmail.com>
---
 net/netfilter/nf_tables_api.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cfe6368..b97182a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -571,7 +571,7 @@ static int nf_tables_gettable(struct sock *nlsk, struct sk_buff *skb,
 		return -ENOMEM;
 
 	err = nf_tables_fill_table_info(skb2, net, NETLINK_CB(skb).portid,
-					nlh->nlmsg_seq, NFT_MSG_NEWTABLE, 0,
+					nlh->nlmsg_seq, NFT_MSG_GETTABLE, 0,
 					family, table);
 	if (err < 0)
 		goto err;
@@ -1136,7 +1136,7 @@ static int nf_tables_getchain(struct sock *nlsk, struct sk_buff *skb,
 		return -ENOMEM;
 
 	err = nf_tables_fill_chain_info(skb2, net, NETLINK_CB(skb).portid,
-					nlh->nlmsg_seq, NFT_MSG_NEWCHAIN, 0,
+					nlh->nlmsg_seq, NFT_MSG_GETCHAIN, 0,
 					family, table, chain);
 	if (err < 0)
 		goto err;
@@ -1974,7 +1974,7 @@ static int nf_tables_getrule(struct sock *nlsk, struct sk_buff *skb,
 		return -ENOMEM;
 
 	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
-				       nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
+				       nlh->nlmsg_seq, NFT_MSG_GETRULE, 0,
 				       family, table, chain, rule);
 	if (err < 0)
 		goto err;
-- 
1.7.9.5

