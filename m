From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next] netfilter: add ifdef around ctnetlink_proto_size
Date: Wed, 15 Nov 2017 18:28:21 +0100
Message-ID: <20171115172821.8451-1-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        arnd@arndb.de
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50022 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756639AbdKOR2b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2017 12:28:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E23B3066B7
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2017 18:28:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 606B9DA804
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2017 18:28:30 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

This function is no longer marked 'inline', so we now get a warning
when it is unused:

net/netfilter/nf_conntrack_netlink.c:536:15: error: 'ctnetlink_proto_size' defined but not used [-Werror=unused-function]

We could mark it inline again, mark it __maybe_unused, or add an #ifdef
around the definition. I'm picking the third approach here since that
seems to be what the rest of the file has.

Fixes: 5caaed151a68 ("netfilter: conntrack: don't cache nlattr_tuple_size result in nla_size")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@David: please place this fix into your net-next tree, it is calming
        down a compilation warning. Thanks!

 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 71a43ed19a0f..96277706b379 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -533,6 +533,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	return -1;
 }
 
+#if defined(CONFIG_NETFILTER_NETLINK_GLUE_CT) || defined(CONFIG_NF_CONNTRACK_EVENTS)
 static size_t ctnetlink_proto_size(const struct nf_conn *ct)
 {
 	const struct nf_conntrack_l3proto *l3proto;
@@ -552,6 +553,7 @@ static size_t ctnetlink_proto_size(const struct nf_conn *ct)
 
 	return len + len4;
 }
+#endif
 
 static inline size_t ctnetlink_acct_size(const struct nf_conn *ct)
 {
-- 
2.11.0

