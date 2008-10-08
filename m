From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 38/79: netns nf_conntrack: PPTP conntracking in netns
Date: Wed,  8 Oct 2008 12:47:12 +0200 (MEST)
Message-ID: <20081008104712.10423.52504.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45977 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbYJHKrO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:14 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 0e6e75af921d1f4799eeb9f83a31c86ab7cdeb8f
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:10 2008 +0200

    netfilter: netns nf_conntrack: PPTP conntracking in netns
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index e47d5de..373e51e 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -98,6 +98,7 @@ EXPORT_SYMBOL(pptp_msg_name);
 static void pptp_expectfn(struct nf_conn *ct,
 			 struct nf_conntrack_expect *exp)
 {
+	struct net *net = nf_ct_net(ct);
 	typeof(nf_nat_pptp_hook_expectfn) nf_nat_pptp_expectfn;
 	pr_debug("increasing timeouts\n");
 
@@ -121,7 +122,7 @@ static void pptp_expectfn(struct nf_conn *ct,
 		pr_debug("trying to unexpect other dir: ");
 		nf_ct_dump_tuple(&inv_t);
 
-		exp_other = nf_ct_expect_find_get(&init_net, &inv_t);
+		exp_other = nf_ct_expect_find_get(net, &inv_t);
 		if (exp_other) {
 			/* delete other expectation.  */
 			pr_debug("found\n");
@@ -134,7 +135,8 @@ static void pptp_expectfn(struct nf_conn *ct,
 	rcu_read_unlock();
 }
 
-static int destroy_sibling_or_exp(const struct nf_conntrack_tuple *t)
+static int destroy_sibling_or_exp(struct net *net,
+				  const struct nf_conntrack_tuple *t)
 {
 	const struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_expect *exp;
@@ -143,7 +145,7 @@ static int destroy_sibling_or_exp(const struct nf_conntrack_tuple *t)
 	pr_debug("trying to timeout ct or exp for tuple ");
 	nf_ct_dump_tuple(t);
 
-	h = nf_conntrack_find_get(&init_net, t);
+	h = nf_conntrack_find_get(net, t);
 	if (h)  {
 		sibling = nf_ct_tuplehash_to_ctrack(h);
 		pr_debug("setting timeout of conntrack %p to 0\n", sibling);
@@ -154,7 +156,7 @@ static int destroy_sibling_or_exp(const struct nf_conntrack_tuple *t)
 		nf_ct_put(sibling);
 		return 1;
 	} else {
-		exp = nf_ct_expect_find_get(&init_net, t);
+		exp = nf_ct_expect_find_get(net, t);
 		if (exp) {
 			pr_debug("unexpect_related of expect %p\n", exp);
 			nf_ct_unexpect_related(exp);
@@ -168,6 +170,7 @@ static int destroy_sibling_or_exp(const struct nf_conntrack_tuple *t)
 /* timeout GRE data connections */
 static void pptp_destroy_siblings(struct nf_conn *ct)
 {
+	struct net *net = nf_ct_net(ct);
 	const struct nf_conn_help *help = nfct_help(ct);
 	struct nf_conntrack_tuple t;
 
@@ -178,7 +181,7 @@ static void pptp_destroy_siblings(struct nf_conn *ct)
 	t.dst.protonum = IPPROTO_GRE;
 	t.src.u.gre.key = help->help.ct_pptp_info.pns_call_id;
 	t.dst.u.gre.key = help->help.ct_pptp_info.pac_call_id;
-	if (!destroy_sibling_or_exp(&t))
+	if (!destroy_sibling_or_exp(net, &t))
 		pr_debug("failed to timeout original pns->pac ct/exp\n");
 
 	/* try reply (pac->pns) tuple */
@@ -186,7 +189,7 @@ static void pptp_destroy_siblings(struct nf_conn *ct)
 	t.dst.protonum = IPPROTO_GRE;
 	t.src.u.gre.key = help->help.ct_pptp_info.pac_call_id;
 	t.dst.u.gre.key = help->help.ct_pptp_info.pns_call_id;
-	if (!destroy_sibling_or_exp(&t))
+	if (!destroy_sibling_or_exp(net, &t))
 		pr_debug("failed to timeout reply pac->pns ct/exp\n");
 }
 
@@ -594,15 +597,32 @@ static struct nf_conntrack_helper pptp __read_mostly = {
 	.expect_policy		= &pptp_exp_policy,
 };
 
+static void nf_conntrack_pptp_net_exit(struct net *net)
+{
+	nf_ct_gre_keymap_flush(net);
+}
+
+static struct pernet_operations nf_conntrack_pptp_net_ops = {
+	.exit = nf_conntrack_pptp_net_exit,
+};
+
 static int __init nf_conntrack_pptp_init(void)
 {
-	return nf_conntrack_helper_register(&pptp);
+	int rv;
+
+	rv = nf_conntrack_helper_register(&pptp);
+	if (rv < 0)
+		return rv;
+	rv = register_pernet_subsys(&nf_conntrack_pptp_net_ops);
+	if (rv < 0)
+		nf_conntrack_helper_unregister(&pptp);
+	return rv;
 }
 
 static void __exit nf_conntrack_pptp_fini(void)
 {
 	nf_conntrack_helper_unregister(&pptp);
-	nf_ct_gre_keymap_flush(&init_net);
+	unregister_pernet_subsys(&nf_conntrack_pptp_net_ops);
 }
 
 module_init(nf_conntrack_pptp_init);
