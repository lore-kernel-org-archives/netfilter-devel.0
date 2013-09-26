From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH RFC 2/3] ctnetlink: account both directions in one step
Date: Thu, 26 Sep 2013 17:31:52 +0200
Message-ID: <20130926154005.080623966@eitzenberger.org>
References: <20130926153150.280914229@eitzenberger.org>
Cc: Krzysztof Piotr Oledzki <ole@ans.pl>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57909 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3IZPkJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:40:09 -0400
Content-Disposition: inline; filename=conntrack-acct-introduce-ctnetlink_dump_acct.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With the intent to dump other accounting data later.

This patch does not change the ABI.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: net-next-ipfix/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-ipfix.orig/net/netfilter/nf_conntrack_netlink.c
+++ net-next-ipfix/net/netfilter/nf_conntrack_netlink.c
@@ -211,13 +211,24 @@ nla_put_failure:
 }
 
 static int
-dump_counters(struct sk_buff *skb, u64 pkts, u64 bytes,
-	      enum ip_conntrack_dir dir)
+dump_counters(struct sk_buff *skb, struct nf_conn_acct *acct,
+	      enum ip_conntrack_dir dir, int type)
 {
-	enum ctattr_type type = dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
+	enum ctattr_type attr = dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
+	struct nf_conn_counter *counter;
 	struct nlattr *nest_count;
+	u64 pkts, bytes;
 
-	nest_count = nla_nest_start(skb, type | NLA_F_NESTED);
+	counter = acct->counter;
+	if (type == IPCTNL_MSG_CT_GET_CTRZERO) {
+		pkts = atomic64_xchg(&counter[dir].packets, 0);
+		bytes = atomic64_xchg(&counter[dir].bytes, 0);
+	} else {
+		pkts = atomic64_read(&counter[dir].packets);
+		bytes = atomic64_read(&counter[dir].bytes);
+	}
+
+	nest_count = nla_nest_start(skb, attr | NLA_F_NESTED);
 	if (!nest_count)
 		goto nla_put_failure;
 
@@ -234,26 +245,19 @@ nla_put_failure:
 }
 
 static int
-ctnetlink_dump_counters(struct sk_buff *skb, const struct nf_conn *ct,
-			enum ip_conntrack_dir dir, int type)
+ctnetlink_dump_acct(struct sk_buff *skb, const struct nf_conn *ct, int type)
 {
-	struct nf_conn_acct *acct;
-	struct nf_conn_counter *counter;
-	u64 pkts, bytes;
+	struct nf_conn_acct *acct = nf_conn_acct_find(ct);
 
-	acct = nf_conn_acct_find(ct);
-	if (!acct)
+	if (acct == NULL)
 		return 0;
 
-	counter = acct->counter;
-	if (type == IPCTNL_MSG_CT_GET_CTRZERO) {
-		pkts = atomic64_xchg(&counter[dir].packets, 0);
-		bytes = atomic64_xchg(&counter[dir].bytes, 0);
-	} else {
-		pkts = atomic64_read(&counter[dir].packets);
-		bytes = atomic64_read(&counter[dir].bytes);
-	}
-	return dump_counters(skb, pkts, bytes, dir);
+	if (dump_counters(skb, acct, IP_CT_DIR_ORIGINAL, type) < 0)
+		return -1;
+	if (dump_counters(skb, acct, IP_CT_DIR_REPLY, type) < 0)
+		return -1;
+
+	return 0;
 }
 
 static int
@@ -490,8 +494,7 @@ ctnetlink_fill_info(struct sk_buff *skb,
 
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
 	    ctnetlink_dump_timeout(skb, ct) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL, type) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY, type) < 0 ||
+	    ctnetlink_dump_acct(skb, ct, type) < 0 ||
 	    ctnetlink_dump_timestamp(skb, ct) < 0 ||
 	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
@@ -675,10 +678,7 @@ ctnetlink_conntrack_event(unsigned int e
 		goto nla_put_failure;
 
 	if (events & (1 << IPCT_DESTROY)) {
-		if (ctnetlink_dump_counters(skb, ct,
-					    IP_CT_DIR_ORIGINAL, type) < 0 ||
-		    ctnetlink_dump_counters(skb, ct,
-					    IP_CT_DIR_REPLY, type) < 0 ||
+		if (ctnetlink_dump_acct(skb, ct, type) < 0 ||
 		    ctnetlink_dump_timestamp(skb, ct) < 0)
 			goto nla_put_failure;
 	} else {

