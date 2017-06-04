From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next RFC 2/5] netfilter: make nf_conntrack_helper_register become per-net
Date: Sun,  4 Jun 2017 23:25:06 +0800
Message-ID: <1496589909-56730-3-git-send-email-zlpnobody@163.com>
References: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:51320 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751218AbdFDPZs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Jun 2017 11:25:48 -0400
In-Reply-To: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Now we add "struct net *" parameter to the nf_conntrack_helper_register/
unregister function, and make the kernel built-in ct helpers to use
pernet subsys operation.

Also note, after this patch, we only support ct helper register in
&init_net netns, but the followup patches will restore to support all
netns.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 include/net/netfilter/nf_conntrack_helper.h | 17 ++++++++++------
 net/ipv4/netfilter/nf_nat_snmp_basic.c      | 19 ++++++++++++++++--
 net/netfilter/nf_conntrack_amanda.c         | 23 +++++++++++++++++----
 net/netfilter/nf_conntrack_ftp.c            | 19 ++++++++++++++++--
 net/netfilter/nf_conntrack_h323_main.c      | 31 ++++++++++++++++++-----------
 net/netfilter/nf_conntrack_helper.c         | 26 ++++++++++++++++--------
 net/netfilter/nf_conntrack_irc.c            | 19 ++++++++++++++++--
 net/netfilter/nf_conntrack_netbios_ns.c     | 19 ++++++++++++++++--
 net/netfilter/nf_conntrack_pptp.c           | 19 ++++++++++++++++--
 net/netfilter/nf_conntrack_sane.c           | 19 ++++++++++++++++--
 net/netfilter/nf_conntrack_sip.c            | 19 ++++++++++++++++--
 net/netfilter/nf_conntrack_snmp.c           | 19 ++++++++++++++++--
 net/netfilter/nf_conntrack_tftp.c           | 19 ++++++++++++++++--
 net/netfilter/nfnetlink_cthelper.c          |  6 +++---
 14 files changed, 223 insertions(+), 51 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index c519bb5..991b6d0 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -95,12 +95,17 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 					  struct nf_conn *ct),
 		       struct module *module);
 
-int nf_conntrack_helper_register(struct nf_conntrack_helper *);
-void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
-
-int nf_conntrack_helpers_register(struct nf_conntrack_helper *, unsigned int);
-void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *,
-				     unsigned int);
+int nf_conntrack_helper_register(struct net *net,
+				 struct nf_conntrack_helper *me);
+void nf_conntrack_helper_unregister(struct net *net,
+				    struct nf_conntrack_helper *me);
+
+int nf_conntrack_helpers_register(struct net *net,
+				  struct nf_conntrack_helper *helper,
+				  unsigned int n);
+void nf_conntrack_helpers_unregister(struct net *net,
+				     struct nf_conntrack_helper *helper,
+				     unsigned int n);
 
 struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct,
 					  struct nf_conntrack_helper *helper,
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index d5b1e0b..270b583 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -1259,6 +1259,21 @@ static struct nf_conntrack_helper snmp_trap_helper __read_mostly = {
 	.tuple.dst.protonum	= IPPROTO_UDP,
 };
 
+static int __net_init snmp_trap_net_init(struct net *net)
+{
+	return nf_conntrack_helper_register(net, &snmp_trap_helper);
+}
+
+static void __net_exit snmp_trap_net_exit(struct net *net)
+{
+	nf_conntrack_helper_unregister(net, &snmp_trap_helper);
+}
+
+static struct pernet_operations snmp_trap_net_ops = {
+	.init	= snmp_trap_net_init,
+	.exit	= snmp_trap_net_exit,
+};
+
 /*****************************************************************************
  *
  * Module stuff.
@@ -1270,14 +1285,14 @@ static int __init nf_nat_snmp_basic_init(void)
 	BUG_ON(nf_nat_snmp_hook != NULL);
 	RCU_INIT_POINTER(nf_nat_snmp_hook, help);
 
-	return nf_conntrack_helper_register(&snmp_trap_helper);
+	return register_pernet_subsys(&snmp_trap_net_ops);
 }
 
 static void __exit nf_nat_snmp_basic_fini(void)
 {
 	RCU_INIT_POINTER(nf_nat_snmp_hook, NULL);
 	synchronize_rcu();
-	nf_conntrack_helper_unregister(&snmp_trap_helper);
+	unregister_pernet_subsys(&snmp_trap_net_ops);
 }
 
 module_init(nf_nat_snmp_basic_init);
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 20edd58..b2d38c0 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -193,12 +193,28 @@ static struct nf_conntrack_helper amanda_helper[2] __read_mostly = {
 	},
 };
 
+static int __net_init amanda_net_init(struct net *net)
+{
+	return nf_conntrack_helpers_register(net, amanda_helper,
+					     ARRAY_SIZE(amanda_helper));
+}
+
+static void __net_exit amanda_net_exit(struct net *net)
+{
+	nf_conntrack_helpers_unregister(net, amanda_helper,
+					ARRAY_SIZE(amanda_helper));
+}
+
+static struct pernet_operations amanda_net_ops = {
+	.init	= amanda_net_init,
+	.exit	= amanda_net_exit,
+};
+
 static void __exit nf_conntrack_amanda_fini(void)
 {
 	int i;
 
-	nf_conntrack_helpers_unregister(amanda_helper,
-					ARRAY_SIZE(amanda_helper));
+	unregister_pernet_subsys(&amanda_net_ops);
 	for (i = 0; i < ARRAY_SIZE(search); i++)
 		textsearch_destroy(search[i].ts);
 }
@@ -218,8 +234,7 @@ static int __init nf_conntrack_amanda_init(void)
 			goto err1;
 		}
 	}
-	ret = nf_conntrack_helpers_register(amanda_helper,
-					    ARRAY_SIZE(amanda_helper));
+	ret = register_pernet_subsys(&amanda_net_ops);
 	if (ret < 0)
 		goto err1;
 	return 0;
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index f0e9a75..d4a779c 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -566,10 +566,25 @@ static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 	.timeout	= 5 * 60,
 };
 
+static int __net_init ftp_net_init(struct net *net)
+{
+	return nf_conntrack_helpers_register(net, ftp, ports_c * 2);
+}
+
+static void __net_exit ftp_net_exit(struct net *net)
+{
+	nf_conntrack_helpers_unregister(net, ftp, ports_c * 2);
+}
+
+static struct pernet_operations ftp_net_ops = {
+	.init	= ftp_net_init,
+	.exit	= ftp_net_exit,
+};
+
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_ftp_fini(void)
 {
-	nf_conntrack_helpers_unregister(ftp, ports_c * 2);
+	unregister_pernet_subsys(&ftp_net_ops);
 	kfree(ftp_buffer);
 }
 
@@ -597,7 +612,7 @@ static int __init nf_conntrack_ftp_init(void)
 				  0, help, nf_ct_ftp_from_nlattr, THIS_MODULE);
 	}
 
-	ret = nf_conntrack_helpers_register(ftp, ports_c * 2);
+	ret = register_pernet_subsys(&ftp_net_ops);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		kfree(ftp_buffer);
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index f71f0d2..ec314d9 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1815,44 +1815,51 @@ static struct nf_conntrack_helper nf_conntrack_helper_ras[] __read_mostly = {
 	},
 };
 
-static int __init h323_helper_init(void)
+static int __net_init h323_net_init(struct net *net)
 {
 	int ret;
 
-	ret = nf_conntrack_helper_register(&nf_conntrack_helper_h245);
+	ret = nf_conntrack_helper_register(net, &nf_conntrack_helper_h245);
 	if (ret < 0)
 		return ret;
-	ret = nf_conntrack_helpers_register(nf_conntrack_helper_q931,
+	ret = nf_conntrack_helpers_register(net, nf_conntrack_helper_q931,
 					ARRAY_SIZE(nf_conntrack_helper_q931));
 	if (ret < 0)
 		goto err1;
-	ret = nf_conntrack_helpers_register(nf_conntrack_helper_ras,
+	ret = nf_conntrack_helpers_register(net, nf_conntrack_helper_ras,
 					ARRAY_SIZE(nf_conntrack_helper_ras));
 	if (ret < 0)
 		goto err2;
 
 	return 0;
+
 err2:
-	nf_conntrack_helpers_unregister(nf_conntrack_helper_q931,
+	nf_conntrack_helpers_unregister(net, nf_conntrack_helper_q931,
 					ARRAY_SIZE(nf_conntrack_helper_q931));
 err1:
-	nf_conntrack_helper_unregister(&nf_conntrack_helper_h245);
+	nf_conntrack_helper_unregister(net, &nf_conntrack_helper_h245);
 	return ret;
+
 }
 
-static void __exit h323_helper_exit(void)
+static void __net_exit h323_net_exit(struct net *net)
 {
-	nf_conntrack_helpers_unregister(nf_conntrack_helper_ras,
+	nf_conntrack_helpers_unregister(net, nf_conntrack_helper_ras,
 					ARRAY_SIZE(nf_conntrack_helper_ras));
-	nf_conntrack_helpers_unregister(nf_conntrack_helper_q931,
+	nf_conntrack_helpers_unregister(net, nf_conntrack_helper_q931,
 					ARRAY_SIZE(nf_conntrack_helper_q931));
-	nf_conntrack_helper_unregister(&nf_conntrack_helper_h245);
+	nf_conntrack_helper_unregister(net, &nf_conntrack_helper_h245);
 }
 
+static struct pernet_operations h323_net_ops = {
+	.init	= h323_net_init,
+	.exit	= h323_net_exit,
+};
+
 /****************************************************************************/
 static void __exit nf_conntrack_h323_fini(void)
 {
-	h323_helper_exit();
+	unregister_pernet_subsys(&h323_net_ops);
 	kfree(h323_buffer);
 	pr_debug("nf_ct_h323: fini\n");
 }
@@ -1867,7 +1874,7 @@ static int __init nf_conntrack_h323_init(void)
 	h323_buffer = kmalloc(65536, GFP_KERNEL);
 	if (!h323_buffer)
 		return -ENOMEM;
-	ret = h323_helper_init();
+	ret = register_pernet_subsys(&h323_net_ops);
 	if (ret < 0)
 		goto err1;
 	pr_debug("nf_ct_h323: init success\n");
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 9129bb3..9a52788 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -391,13 +391,17 @@ void nf_ct_helper_log(struct sk_buff *skb, const struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_log);
 
-int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
+int nf_conntrack_helper_register(struct net *net,
+				 struct nf_conntrack_helper *me)
 {
 	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
 	unsigned int h = helper_hash(&me->tuple);
 	struct nf_conntrack_helper *cur;
 	int ret = 0, i;
 
+	if (!net_eq(net, &init_net))
+		return 0;
+
 	BUG_ON(me->expect_policy == NULL);
 	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
 	BUG_ON(strlen(me->name) > NF_CT_HELPER_NAME_LEN - 1);
@@ -437,12 +441,16 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_register);
 
-void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
+void nf_conntrack_helper_unregister(struct net *net,
+				    struct nf_conntrack_helper *me)
 {
 	struct nf_conntrack_expect *exp;
 	const struct hlist_node *next;
 	unsigned int i;
 
+	if (!net_eq(net, &init_net))
+		return 0;
+
 	mutex_lock(&nf_ct_helper_mutex);
 	hlist_del_rcu(&me->hnode);
 	nf_ct_helper_count--;
@@ -500,14 +508,15 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_init);
 
-int nf_conntrack_helpers_register(struct nf_conntrack_helper *helper,
+int nf_conntrack_helpers_register(struct net *net,
+				  struct nf_conntrack_helper *helper,
 				  unsigned int n)
 {
 	unsigned int i;
 	int err = 0;
 
 	for (i = 0; i < n; i++) {
-		err = nf_conntrack_helper_register(&helper[i]);
+		err = nf_conntrack_helper_register(net, &helper[i]);
 		if (err < 0)
 			goto err;
 	}
@@ -515,16 +524,17 @@ int nf_conntrack_helpers_register(struct nf_conntrack_helper *helper,
 	return err;
 err:
 	if (i > 0)
-		nf_conntrack_helpers_unregister(helper, i);
+		nf_conntrack_helpers_unregister(net, helper, i);
 	return err;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helpers_register);
 
-void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *helper,
-				unsigned int n)
+void nf_conntrack_helpers_unregister(struct net *net,
+				     struct nf_conntrack_helper *helper,
+				     unsigned int n)
 {
 	while (n-- > 0)
-		nf_conntrack_helper_unregister(&helper[n]);
+		nf_conntrack_helper_unregister(net, &helper[n]);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helpers_unregister);
 
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 5523acc..ff7bd54 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -232,6 +232,21 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 static struct nf_conntrack_helper irc[MAX_PORTS] __read_mostly;
 static struct nf_conntrack_expect_policy irc_exp_policy;
 
+static int __net_init irc_net_init(struct net *net)
+{
+	return nf_conntrack_helpers_register(net, irc, ports_c);
+}
+
+static void __net_exit irc_net_exit(struct net *net)
+{
+	nf_conntrack_helpers_unregister(net, irc, ports_c);
+}
+
+static struct pernet_operations irc_net_ops = {
+	.init	= irc_net_init,
+	.exit	= irc_net_exit,
+};
+
 static void nf_conntrack_irc_fini(void);
 
 static int __init nf_conntrack_irc_init(void)
@@ -266,7 +281,7 @@ static int __init nf_conntrack_irc_init(void)
 				  0, help, NULL, THIS_MODULE);
 	}
 
-	ret = nf_conntrack_helpers_register(&irc[0], ports_c);
+	ret = register_pernet_subsys(&irc_net_ops);
 	if (ret) {
 		pr_err("failed to register helpers\n");
 		kfree(irc_buffer);
@@ -280,7 +295,7 @@ static int __init nf_conntrack_irc_init(void)
  * it is needed by the init function */
 static void nf_conntrack_irc_fini(void)
 {
-	nf_conntrack_helpers_unregister(irc, ports_c);
+	unregister_pernet_subsys(&irc_net_ops);
 	kfree(irc_buffer);
 }
 
diff --git a/net/netfilter/nf_conntrack_netbios_ns.c b/net/netfilter/nf_conntrack_netbios_ns.c
index 496ce17..91f3bed 100644
--- a/net/netfilter/nf_conntrack_netbios_ns.c
+++ b/net/netfilter/nf_conntrack_netbios_ns.c
@@ -56,17 +56,32 @@ static struct nf_conntrack_helper helper __read_mostly = {
 	.expect_policy		= &exp_policy,
 };
 
+static int __net_init netbios_ns_net_init(struct net *net)
+{
+	return nf_conntrack_helper_register(net, &helper);
+}
+
+static void __net_exit netbios_ns_net_exit(struct net *net)
+{
+	nf_conntrack_helper_unregister(net, &helper);
+}
+
+static struct pernet_operations netbios_ns_net_ops = {
+	.init	= netbios_ns_net_init,
+	.exit	= netbios_ns_net_exit,
+};
+
 static int __init nf_conntrack_netbios_ns_init(void)
 {
 	NF_CT_HELPER_BUILD_BUG_ON(0);
 
 	exp_policy.timeout = timeout;
-	return nf_conntrack_helper_register(&helper);
+	return register_pernet_subsys(&netbios_ns_net_ops);
 }
 
 static void __exit nf_conntrack_netbios_ns_fini(void)
 {
-	nf_conntrack_helper_unregister(&helper);
+	unregister_pernet_subsys(&netbios_ns_net_ops);
 }
 
 module_init(nf_conntrack_netbios_ns_init);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 6959e93..c3ef5f2 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -612,16 +612,31 @@ static struct nf_conntrack_helper pptp __read_mostly = {
 	.expect_policy		= &pptp_exp_policy,
 };
 
+static int __net_init pptp_net_init(struct net *net)
+{
+	return nf_conntrack_helper_register(net, &pptp);
+}
+
+static void __net_exit pptp_net_exit(struct net *net)
+{
+	nf_conntrack_helper_unregister(net, &pptp);
+}
+
+static struct pernet_operations pptp_net_ops = {
+	.init	= pptp_net_init,
+	.exit	= pptp_net_exit,
+};
+
 static int __init nf_conntrack_pptp_init(void)
 {
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_pptp_master));
 
-	return nf_conntrack_helper_register(&pptp);
+	return register_pernet_subsys(&pptp_net_ops);
 }
 
 static void __exit nf_conntrack_pptp_fini(void)
 {
-	nf_conntrack_helper_unregister(&pptp);
+	unregister_pernet_subsys(&pptp_net_ops);
 }
 
 module_init(nf_conntrack_pptp_init);
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index ae457f3..30d8da5 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -173,10 +173,25 @@ static const struct nf_conntrack_expect_policy sane_exp_policy = {
 	.timeout	= 5 * 60,
 };
 
+static int __net_init sane_net_init(struct net *net)
+{
+	return nf_conntrack_helpers_register(net, sane, ports_c * 2);
+}
+
+static void __net_exit sane_net_exit(struct net *net)
+{
+	nf_conntrack_helpers_unregister(net, sane, ports_c * 2);
+}
+
+static struct pernet_operations sane_net_ops = {
+	.init	= sane_net_init,
+	.exit	= sane_net_exit,
+};
+
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_sane_fini(void)
 {
-	nf_conntrack_helpers_unregister(sane, ports_c * 2);
+	unregister_pernet_subsys(&sane_net_ops);
 	kfree(sane_buffer);
 }
 
@@ -206,7 +221,7 @@ static int __init nf_conntrack_sane_init(void)
 				  THIS_MODULE);
 	}
 
-	ret = nf_conntrack_helpers_register(sane, ports_c * 2);
+	ret = register_pernet_subsys(&sane_net_ops);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		kfree(sane_buffer);
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index d38af42..70be381 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1613,9 +1613,24 @@ static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1
 	},
 };
 
+static int __net_init sip_net_init(struct net *net)
+{
+	return nf_conntrack_helpers_register(net, sip, ports_c * 4);
+}
+
+static void __net_exit sip_net_exit(struct net *net)
+{
+	nf_conntrack_helpers_unregister(net, sip, ports_c * 4);
+}
+
+static struct pernet_operations sip_net_ops = {
+	.init	= sip_net_init,
+	.exit	= sip_net_exit,
+};
+
 static void nf_conntrack_sip_fini(void)
 {
-	nf_conntrack_helpers_unregister(sip, ports_c * 4);
+	unregister_pernet_subsys(&sip_net_ops);
 }
 
 static int __init nf_conntrack_sip_init(void)
@@ -1646,7 +1661,7 @@ static int __init nf_conntrack_sip_init(void)
 				  NULL, THIS_MODULE);
 	}
 
-	ret = nf_conntrack_helpers_register(sip, ports_c * 4);
+	ret = register_pernet_subsys(&sip_net_ops);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		return ret;
diff --git a/net/netfilter/nf_conntrack_snmp.c b/net/netfilter/nf_conntrack_snmp.c
index 87b95a2..4a89129 100644
--- a/net/netfilter/nf_conntrack_snmp.c
+++ b/net/netfilter/nf_conntrack_snmp.c
@@ -63,15 +63,30 @@ static struct nf_conntrack_helper helper __read_mostly = {
 	.expect_policy		= &exp_policy,
 };
 
+static int __net_init snmp_net_init(struct net *net)
+{
+	return nf_conntrack_helper_register(net, &helper);
+}
+
+static void __net_exit snmp_net_exit(struct net *net)
+{
+	nf_conntrack_helper_unregister(net, &helper);
+}
+
+static struct pernet_operations snmp_net_ops = {
+	.init	= snmp_net_init,
+	.exit	= snmp_net_exit,
+};
+
 static int __init nf_conntrack_snmp_init(void)
 {
 	exp_policy.timeout = timeout;
-	return nf_conntrack_helper_register(&helper);
+	return register_pernet_subsys(&snmp_net_ops);
 }
 
 static void __exit nf_conntrack_snmp_fini(void)
 {
-	nf_conntrack_helper_unregister(&helper);
+	unregister_pernet_subsys(&snmp_net_ops);
 }
 
 module_init(nf_conntrack_snmp_init);
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 0ec6779..163cfd7 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -104,9 +104,24 @@ static const struct nf_conntrack_expect_policy tftp_exp_policy = {
 	.timeout	= 5 * 60,
 };
 
+static int __net_init tftp_net_init(struct net *net)
+{
+	return nf_conntrack_helpers_register(net, tftp, ports_c * 2);
+}
+
+static void __net_exit tftp_net_exit(struct net *net)
+{
+	nf_conntrack_helpers_unregister(net, tftp, ports_c * 2);
+}
+
+static struct pernet_operations tftp_net_ops = {
+	.init	= tftp_net_init,
+	.exit	= tftp_net_exit,
+};
+
 static void nf_conntrack_tftp_fini(void)
 {
-	nf_conntrack_helpers_unregister(tftp, ports_c * 2);
+	unregister_pernet_subsys(&tftp_net_ops);
 }
 
 static int __init nf_conntrack_tftp_init(void)
@@ -127,7 +142,7 @@ static int __init nf_conntrack_tftp_init(void)
 				  0, tftp_help, NULL, THIS_MODULE);
 	}
 
-	ret = nf_conntrack_helpers_register(tftp, ports_c * 2);
+	ret = register_pernet_subsys(&tftp_net_ops);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
 		return ret;
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index be678a3..90603b1 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -265,7 +265,7 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 		}
 	}
 
-	ret = nf_conntrack_helper_register(helper);
+	ret = nf_conntrack_helper_register(&init_net, helper);
 	if (ret < 0)
 		goto err2;
 
@@ -702,7 +702,7 @@ static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
 
 		if (refcount_dec_if_one(&cur->refcnt)) {
 			found = true;
-			nf_conntrack_helper_unregister(cur);
+			nf_conntrack_helper_unregister(net, cur);
 			kfree(cur->expect_policy);
 
 			list_del(&nlcth->list);
@@ -767,7 +767,7 @@ static void __exit nfnl_cthelper_exit(void)
 	list_for_each_entry_safe(nlcth, n, &nfnl_cthelper_list, list) {
 		cur = &nlcth->helper;
 
-		nf_conntrack_helper_unregister(cur);
+		nf_conntrack_helper_unregister(&init_net, cur);
 		kfree(cur->expect_policy);
 		kfree(nlcth);
 	}
-- 
2.5.5


