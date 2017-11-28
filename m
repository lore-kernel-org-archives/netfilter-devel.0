From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,RFC 3/3] netfilter: ctnetlink: randomize 32-bit ID
Date: Tue, 28 Nov 2017 03:13:09 +0100
Message-ID: <20171128021309.11277-3-pablo@netfilter.org>
References: <20171128021309.11277-1-pablo@netfilter.org>
Cc: richard@nod.at, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59702 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753553AbdK1CNS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Nov 2017 21:13:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 14194E2C4F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 03:13:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05559DA7E9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 03:13:17 +0100 (CET)
In-Reply-To: <20171128021309.11277-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't leak the kernel pointer to userspace by adding a random seed. If
you want a unique conntrack ID, used the new CTA_ID64 attribute.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7aecb8ae5ecc..9a3357eeecdc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -60,6 +60,7 @@
 MODULE_LICENSE("GPL");
 
 static char __initdata version[] = "0.93";
+static u32 nf_ct_seed __read_mostly;
 
 static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
 				const struct nf_conntrack_tuple *tuple,
@@ -444,9 +445,19 @@ static int ctnetlink_dump_ct_seq_adj(struct sk_buff *skb, struct nf_conn *ct)
 	return -1;
 }
 
+static u32 nf_ct_id32(const struct nf_conn *ct)
+{
+	u32 id = (u32)(unsigned long)ct;
+
+	if (!nf_ct_seed)
+		nf_ct_seed = get_random_u32();
+
+	return id + nf_ct_seed;
+}
+
 static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	if (nla_put_be32(skb, CTA_ID, htonl((unsigned long)ct)) ||
+	if (nla_put_be32(skb, CTA_ID, htonl(nf_ct_id32(ct))) ||
 	    nla_put_be64(skb, CTA_ID64, cpu_to_be64(nf_ct_id(ct)), CTA_PAD))
 		goto nla_put_failure;
 	return 0;
@@ -1173,7 +1184,7 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 
 	if (cda[CTA_ID]) {
 		u_int32_t id = ntohl(nla_get_be32(cda[CTA_ID]));
-		if (id != (u32)(unsigned long)ct) {
+		if (id != nf_ct_id32(ct)) {
 			nf_ct_put(ct);
 			return -ENOENT;
 		}
-- 
2.11.0

