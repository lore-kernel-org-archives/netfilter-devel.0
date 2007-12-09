From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/5] Add support for master tuple event notification and dumping
Date: Sun, 09 Dec 2007 19:13:11 +0100
Message-ID: <475C3037.5070303@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030204030500060702030800"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36632 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750952AbXLISNe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:13:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030204030500060702030800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch adds support for master tuple event notification and dumping.
Conntrackd needs this information to recover related connections
appropriately, see:

http://people.netfilter.org/pablo/conntrack-tools/

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------030204030500060702030800
Content-Type: text/x-patch;
 name="03.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.patch"

[PATCH][CTNETLINK] add support for master tuple event notification and dumping 

This patch adds support for master tuple event notification and dumping.
Conntrackd needs this information to recover related connections appropriately.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2007-12-08 21:42:05.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2007-12-08 21:42:18.000000000 +0100
@@ -254,6 +254,29 @@ nla_put_failure:
 #define ctnetlink_dump_mark(a, b) (0)
 #endif
 
+#define master_tuple(ct) &(ct->master->tuplehash[IP_CT_DIR_ORIGINAL].tuple)
+
+static inline int
+ctnetlink_dump_master(struct sk_buff *skb, const struct nf_conn *ct)
+{
+	struct nlattr *nest_parms;
+
+	if (!(ct->status & IPS_EXPECTED))
+		return 0;
+
+	nest_parms = nla_nest_start(skb, CTA_TUPLE_MASTER | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
+	if (ctnetlink_dump_tuples(skb, master_tuple(ct)) < 0)
+		goto nla_put_failure;
+	nla_nest_end(skb, nest_parms);
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 #ifdef CONFIG_NF_NAT_NEEDED
 static inline int
 dump_nat_seq_adj(struct sk_buff *skb, const struct nf_nat_seq *natseq, int type)
@@ -371,6 +394,7 @@ ctnetlink_fill_info(struct sk_buff *skb,
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
+	    ctnetlink_dump_master(skb, ct) < 0 ||
 	    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
 		goto nla_put_failure;
 
@@ -475,6 +499,10 @@ static int ctnetlink_conntrack_event(str
 		     ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
 			goto nla_put_failure;
 
+		if (events & IPCT_RELATED && 
+		    ctnetlink_dump_master(skb, ct) < 0)
+			goto nla_put_failure;
+
 		if (events & IPCT_NATSEQADJ &&
 		    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
 			goto nla_put_failure;

--------------030204030500060702030800--
