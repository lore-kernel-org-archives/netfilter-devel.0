From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 32/39]: PPTP conntrack: simplify expectation handling
Date: Wed, 20 Sep 2006 10:24:32 +0200 (MEST)
Message-ID: <20060920082524.14636.32416.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: simplify expectation handling

Remove duplicated expectation handling in the NAT helper and simplify
the remains in the conntrack helper.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5bf78ee628377db21c4a025e6c4e4955c581af1d
tree d309ce8083305691668ddc049f1c9d870689e512
parent 3a6a0d83459e3dc898f2b81eda4be07e5b3dc858
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:57 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:38:57 +0200

 include/linux/netfilter_ipv4/ip_conntrack_pptp.h |    2 
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c    |   92 +++++++---------------
 net/ipv4/netfilter/ip_nat_helper_pptp.c          |   58 +-------------
 3 files changed, 35 insertions(+), 117 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_pptp.h b/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
index 620bf06..2644b1f 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
@@ -315,7 +315,7 @@ (*ip_nat_pptp_hook_inbound)(struct sk_bu
 			  struct PptpControlHeader *ctlh,
 			  union pptp_ctrl_union *pptpReq);
 
-extern int
+extern void
 (*ip_nat_pptp_hook_exp_gre)(struct ip_conntrack_expect *exp_orig,
 			    struct ip_conntrack_expect *exp_reply);
 
diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index 5f7af6e..57eac6e 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -80,7 +80,7 @@ (*ip_nat_pptp_hook_inbound)(struct sk_bu
 			  struct PptpControlHeader *ctlh,
 			  union pptp_ctrl_union *pptpReq);
 
-int
+void
 (*ip_nat_pptp_hook_exp_gre)(struct ip_conntrack_expect *expect_orig,
 			    struct ip_conntrack_expect *expect_reply);
 
@@ -219,93 +219,63 @@ static void pptp_destroy_siblings(struct
 
 /* expect GRE connections (PNS->PAC and PAC->PNS direction) */
 static inline int
-exp_gre(struct ip_conntrack *master,
+exp_gre(struct ip_conntrack *ct,
 	__be16 callid,
 	__be16 peer_callid)
 {
-	struct ip_conntrack_tuple inv_tuple;
-	struct ip_conntrack_tuple exp_tuples[] = {
-		/* tuple in original direction, PNS->PAC */
-		{ .src = { .ip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
-			   .u = { .gre = { .key = peer_callid } }
-			 },
-		  .dst = { .ip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip,
-			   .u = { .gre = { .key = callid } },
-			   .protonum = IPPROTO_GRE
-			 },
-		 },
-		/* tuple in reply direction, PAC->PNS */
-		{ .src = { .ip = master->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip,
-			   .u = { .gre = { .key = callid } }
-			 },
-		  .dst = { .ip = master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip,
-			   .u = { .gre = { .key = peer_callid } },
-			   .protonum = IPPROTO_GRE
-			 },
-		 }
-	};
 	struct ip_conntrack_expect *exp_orig, *exp_reply;
 	int ret = 1;
 
-	exp_orig = ip_conntrack_expect_alloc(master);
+	exp_orig = ip_conntrack_expect_alloc(ct);
 	if (exp_orig == NULL)
 		goto out;
 
-	exp_reply = ip_conntrack_expect_alloc(master);
+	exp_reply = ip_conntrack_expect_alloc(ct);
 	if (exp_reply == NULL)
 		goto out_put_orig;
 
-	memcpy(&exp_orig->tuple, &exp_tuples[0], sizeof(exp_orig->tuple));
+	/* original direction, PNS->PAC */
+	exp_orig->tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+	exp_orig->tuple.src.u.gre.key = peer_callid;
+	exp_orig->tuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+	exp_orig->tuple.dst.u.gre.key = callid;
+	exp_orig->tuple.dst.protonum = IPPROTO_GRE;
 
 	exp_orig->mask.src.ip = 0xffffffff;
 	exp_orig->mask.src.u.all = 0;
-	exp_orig->mask.dst.u.all = 0;
 	exp_orig->mask.dst.u.gre.key = htons(0xffff);
 	exp_orig->mask.dst.ip = 0xffffffff;
 	exp_orig->mask.dst.protonum = 0xff;
 
-	exp_orig->master = master;
+	exp_orig->master = ct;
 	exp_orig->expectfn = pptp_expectfn;
 	exp_orig->flags = 0;
 
 	/* both expectations are identical apart from tuple */
 	memcpy(exp_reply, exp_orig, sizeof(*exp_reply));
-	memcpy(&exp_reply->tuple, &exp_tuples[1], sizeof(exp_reply->tuple));
-
-	if (ip_nat_pptp_hook_exp_gre)
-		ret = ip_nat_pptp_hook_exp_gre(exp_orig, exp_reply);
-	else {
 
-		DEBUGP("calling expect_related PNS->PAC");
-		DUMP_TUPLE(&exp_orig->tuple);
+	/* reply direction, PAC->PNS */
+	exp_reply->tuple.src.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
+	exp_reply->tuple.src.u.gre.key = callid;
+	exp_reply->tuple.dst.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
+	exp_reply->tuple.dst.u.gre.key = peer_callid;
+	exp_reply->tuple.dst.protonum = IPPROTO_GRE;
 
-		if (ip_conntrack_expect_related(exp_orig) != 0) {
-			DEBUGP("cannot expect_related()\n");
-			goto out_put_both;
-		}
-
-		DEBUGP("calling expect_related PAC->PNS");
-		DUMP_TUPLE(&exp_reply->tuple);
-
-		if (ip_conntrack_expect_related(exp_reply) != 0) {
-			DEBUGP("cannot expect_related()\n");
-			goto out_unexpect_orig;
-		}
-
-		/* Add GRE keymap entries */
-		if (ip_ct_gre_keymap_add(master, &exp_reply->tuple, 0) != 0) {
-			DEBUGP("cannot keymap_add() exp\n");
-			goto out_unexpect_both;
-		}
-
-		invert_tuplepr(&inv_tuple, &exp_reply->tuple);
-		if (ip_ct_gre_keymap_add(master, &inv_tuple, 1) != 0) {
-			ip_ct_gre_keymap_destroy(master);
-			DEBUGP("cannot keymap_add() exp_inv\n");
-			goto out_unexpect_both;
-		}
-		ret = 0;
+	if (ip_nat_pptp_hook_exp_gre)
+		ip_nat_pptp_hook_exp_gre(exp_orig, exp_reply);
+	if (ip_conntrack_expect_related(exp_orig) != 0)
+		goto out_put_both;
+	if (ip_conntrack_expect_related(exp_reply) != 0)
+		goto out_unexpect_orig;
+
+	/* Add GRE keymap entries */
+	if (ip_ct_gre_keymap_add(ct, &exp_orig->tuple, 0) != 0)
+		goto out_unexpect_both;
+	if (ip_ct_gre_keymap_add(ct, &exp_reply->tuple, 1) != 0) {
+		ip_ct_gre_keymap_destroy(ct);
+		goto out_unexpect_both;
 	}
+	ret = 0;
 
 out_put_both:
 	ip_conntrack_expect_put(exp_reply);
diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
index 0f5e753..84f6bd0 100644
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -211,80 +211,28 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	return NF_ACCEPT;
 }
 
-static int
+static void
 pptp_exp_gre(struct ip_conntrack_expect *expect_orig,
 	     struct ip_conntrack_expect *expect_reply)
 {
-	struct ip_ct_pptp_master *ct_pptp_info =
-				&expect_orig->master->help.ct_pptp_info;
-	struct ip_nat_pptp *nat_pptp_info =
-				&expect_orig->master->nat.help.nat_pptp_info;
-
 	struct ip_conntrack *ct = expect_orig->master;
-
-	struct ip_conntrack_tuple inv_t;
-	struct ip_conntrack_tuple *orig_t, *reply_t;
+	struct ip_ct_pptp_master *ct_pptp_info = &ct->help.ct_pptp_info;
+	struct ip_nat_pptp *nat_pptp_info = &ct->nat.help.nat_pptp_info;
 
 	/* save original PAC call ID in nat_info */
 	nat_pptp_info->pac_call_id = ct_pptp_info->pac_call_id;
 
-	/* alter expectation */
-	orig_t = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-	reply_t = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-
 	/* alter expectation for PNS->PAC direction */
-	invert_tuplepr(&inv_t, &expect_orig->tuple);
 	expect_orig->saved_proto.gre.key = ct_pptp_info->pns_call_id;
 	expect_orig->tuple.src.u.gre.key = nat_pptp_info->pns_call_id;
 	expect_orig->tuple.dst.u.gre.key = ct_pptp_info->pac_call_id;
 	expect_orig->dir = IP_CT_DIR_ORIGINAL;
-	inv_t.src.ip = reply_t->src.ip;
-	inv_t.dst.ip = reply_t->dst.ip;
-	inv_t.src.u.gre.key = nat_pptp_info->pac_call_id;
-	inv_t.dst.u.gre.key = ct_pptp_info->pns_call_id;
-
-	if (!ip_conntrack_expect_related(expect_orig)) {
-		DEBUGP("successfully registered expect\n");
-	} else {
-		DEBUGP("can't expect_related(expect_orig)\n");
-		return 1;
-	}
 
 	/* alter expectation for PAC->PNS direction */
-	invert_tuplepr(&inv_t, &expect_reply->tuple);
 	expect_reply->saved_proto.gre.key = nat_pptp_info->pns_call_id;
 	expect_reply->tuple.src.u.gre.key = nat_pptp_info->pac_call_id;
 	expect_reply->tuple.dst.u.gre.key = ct_pptp_info->pns_call_id;
 	expect_reply->dir = IP_CT_DIR_REPLY;
-	inv_t.src.ip = orig_t->src.ip;
-	inv_t.dst.ip = orig_t->dst.ip;
-	inv_t.src.u.gre.key = nat_pptp_info->pns_call_id;
-	inv_t.dst.u.gre.key = ct_pptp_info->pac_call_id;
-
-	if (!ip_conntrack_expect_related(expect_reply)) {
-		DEBUGP("successfully registered expect\n");
-	} else {
-		DEBUGP("can't expect_related(expect_reply)\n");
-		ip_conntrack_unexpect_related(expect_orig);
-		return 1;
-	}
-
-	if (ip_ct_gre_keymap_add(ct, &expect_reply->tuple, 0) < 0) {
-		DEBUGP("can't register original keymap\n");
-		ip_conntrack_unexpect_related(expect_orig);
-		ip_conntrack_unexpect_related(expect_reply);
-		return 1;
-	}
-
-	if (ip_ct_gre_keymap_add(ct, &inv_t, 1) < 0) {
-		DEBUGP("can't register reply keymap\n");
-		ip_conntrack_unexpect_related(expect_orig);
-		ip_conntrack_unexpect_related(expect_reply);
-		ip_ct_gre_keymap_destroy(ct);
-		return 1;
-	}
-
-	return 0;
 }
 
 /* inbound packets == from PAC to PNS */
