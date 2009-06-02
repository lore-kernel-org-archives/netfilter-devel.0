From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/9] netfilter: ctnetlink: rename tuple() by nf_ct_tuple()
	macro definition
Date: Tue, 02 Jun 2009 20:18:49 +0200
Message-ID: <20090602181849.18573.18757.stgit@Decadence>
References: <20090602181336.18573.85368.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51853 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbZFBScN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:32:13 -0400
In-Reply-To: <20090602181336.18573.85368.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch move the internal tuple() macro definition to the
header file as nf_ct_tuple().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 include/net/netfilter/nf_conntrack.h |    2 ++
 net/netfilter/nf_conntrack_netlink.c |   13 ++++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 6c3f964..b909241 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -144,6 +144,8 @@ static inline u_int8_t nf_ct_protonum(const struct nf_conn *ct)
 	return ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum;
 }
 
+#define nf_ct_tuple(ct, dir) (&(ct)->tuplehash[dir].tuple)
+
 /* get master conntrack via master expectation */
 #define master_ct(conntr) (conntr->master)
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2d7d69f..3553f39 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -346,8 +346,6 @@ nla_put_failure:
 	return -1;
 }
 
-#define tuple(ct, dir) (&(ct)->tuplehash[dir].tuple)
-
 static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 		    int event, const struct nf_conn *ct)
@@ -369,14 +367,14 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
-	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
+	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
 	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
-	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0)
+	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_REPLY)) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
@@ -509,7 +507,8 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	if (!item->report && !nfnetlink_has_listeners(group))
 		return NOTIFY_DONE;
 
-	skb = ctnetlink_alloc_skb(tuple(ct, IP_CT_DIR_ORIGINAL), GFP_ATOMIC);
+	skb = ctnetlink_alloc_skb(nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL),
+				  GFP_ATOMIC);
 	if (!skb)
 		goto errout;
 
@@ -528,14 +527,14 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	nest_parms = nla_nest_start(skb, CTA_TUPLE_ORIG | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
-	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
+	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL)) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
 	nest_parms = nla_nest_start(skb, CTA_TUPLE_REPLY | NLA_F_NESTED);
 	if (!nest_parms)
 		goto nla_put_failure;
-	if (ctnetlink_dump_tuples(skb, tuple(ct, IP_CT_DIR_REPLY)) < 0)
+	if (ctnetlink_dump_tuples(skb, nf_ct_tuple(ct, IP_CT_DIR_REPLY)) < 0)
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 

