Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3ABC10F14
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE09020870
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfDMXRe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 19:17:34 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35432 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfDMXRd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 19:17:33 -0400
Received: by mail-qk1-f195.google.com with SMTP id a71so7850359qkg.2
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 16:17:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xOi7aeJt1FF2sBDrr0SMDMT8iqYknCeoUA39/fvflOA=;
        b=Sf6oPFzNy1bwnXBpeFAs4MbeFdQehzKkM7lRkf8rXJiUuiMvgNjnZhuI1APPmvh847
         gpIp2svHCvGhiNGBtITuX/IgloS7OrIkDmS5Y4Ki9Q3sQ7v0EWqNTSk+n55xoY835J0C
         DzExaxxGhIzWbMrDtPY02PeonMWEZzJOWhWOY+lUv9G/AG09Rnh7Zone1l9JLUXcLVDB
         +bUja1pS0mxAHhZw2KD9IBWp5lsKahYLtsfsmrbmQiUdBg7SK9lalYe/W3al7m+HNyuM
         0D+Mgn3YCI1hQAtuThFhNFsbMGmBRBlulUq5uGPmrwXQ8tODOq459SBTjYWCF5L0wd24
         8YMA==
X-Gm-Message-State: APjAAAXHzKZ64e2PNTmqe+olK8AegXMJrlQOzB//dwn0mZ2bJXSf3vtk
        F0Mr7pSQMw/Oi0H3E6wkW6/RzCLTQOk=
X-Google-Smtp-Source: APXvYqyDRlOicLlZAbdiylPUUhVmbLnLt4ZQIZ7IGU8KorwN5odiuSBffEXAEpRP6XqnGWkV8VJ1PA==
X-Received: by 2002:ae9:d881:: with SMTP id u123mr50007832qkf.294.1555197452245;
        Sat, 13 Apr 2019 16:17:32 -0700 (PDT)
Received: from localhost ([177.183.215.126])
        by smtp.gmail.com with ESMTPSA id m73sm24706919qke.95.2019.04.13.16.17.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 13 Apr 2019 16:17:31 -0700 (PDT)
From:   Flavio Leitner <fbl@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next v2 2/8] netfilter: add API to manage NAT helpers.
Date:   Sat, 13 Apr 2019 20:17:10 -0300
Message-Id: <20190413231716.28711-3-fbl@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413231716.28711-1-fbl@redhat.com>
References: <20190413231716.28711-1-fbl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The API allows a conntrack helper to indicate its corresponding
NAT helper which then can be loaded and reference counted.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
---
 include/net/netfilter/nf_conntrack_helper.h | 22 ++++-
 net/netfilter/nf_conntrack_amanda.c         |  8 +-
 net/netfilter/nf_conntrack_ftp.c            | 13 +--
 net/netfilter/nf_conntrack_helper.c         | 97 +++++++++++++++++++++
 net/netfilter/nf_conntrack_irc.c            |  6 +-
 net/netfilter/nf_conntrack_sane.c           | 12 +--
 net/netfilter/nf_conntrack_sip.c            | 28 +++---
 net/netfilter/nf_conntrack_tftp.c           | 18 ++--
 8 files changed, 169 insertions(+), 35 deletions(-)

 V2
   - renamed functions names as suggested by Pablo
   - renamed structs and other variables accordingly.
   - replaced the spinlock with mutex as suggested
     by Pablo.
   - used structure in C99 as static in the NAT helper
     module as suggested by Pablo.
   - defined a HELPER_NAME for consistency on each NAT
     helper module.

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 28bd4569aa64..44b5a00a9c64 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -15,7 +15,8 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
-#define NF_NAT_HELPER_NAME(name)	"ip_nat_" name
+#define NF_NAT_HELPER_PREFIX		"ip_nat_"
+#define NF_NAT_HELPER_NAME(name)	NF_NAT_HELPER_PREFIX name
 #define MODULE_ALIAS_NF_NAT_HELPER(name) \
 	MODULE_ALIAS(NF_NAT_HELPER_NAME(name))
 
@@ -58,6 +59,8 @@ struct nf_conntrack_helper {
 	unsigned int queue_num;
 	/* length of userspace private data stored in nf_conn_help->data */
 	u16 data_len;
+	/* name of NAT helper module */
+	char nat_mod_name[NF_CT_HELPER_NAME_LEN];
 };
 
 /* Must be kept in sync with the classes defined by helpers */
@@ -157,4 +160,21 @@ nf_ct_helper_expectfn_find_by_symbol(const void *symbol);
 extern struct hlist_head *nf_ct_helper_hash;
 extern unsigned int nf_ct_helper_hsize;
 
+struct nf_conntrack_nat_helper {
+	struct list_head list;
+	char mod_name[NF_CT_HELPER_NAME_LEN];	/* module name */
+	struct module *module;			/* pointer to self */
+};
+
+#define NF_CT_NAT_HELPER_INIT(name) \
+	{ \
+	.mod_name = NF_NAT_HELPER_NAME(name), \
+	.module = THIS_MODULE \
+	}
+
+void nf_nat_helper_register(struct nf_conntrack_nat_helper *nat);
+void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat);
+int nf_nat_helper_try_module_get(const char *name, u16 l3num,
+				 u8 protonum);
+void nf_nat_helper_put(struct nf_conntrack_helper *helper);
 #endif /*_NF_CONNTRACK_HELPER_H*/
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index f2681ec5b5f6..dbec6fca0d9e 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -28,11 +28,13 @@
 static unsigned int master_timeout __read_mostly = 300;
 static char *ts_algo = "kmp";
 
+#define HELPER_NAME "amanda"
+
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda connection tracking module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_amanda");
-MODULE_ALIAS_NFCT_HELPER("amanda");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 module_param(master_timeout, uint, 0600);
 MODULE_PARM_DESC(master_timeout, "timeout for the master connection");
@@ -179,13 +181,14 @@ static const struct nf_conntrack_expect_policy amanda_exp_policy = {
 
 static struct nf_conntrack_helper amanda_helper[2] __read_mostly = {
 	{
-		.name			= "amanda",
+		.name			= HELPER_NAME,
 		.me			= THIS_MODULE,
 		.help			= amanda_help,
 		.tuple.src.l3num	= AF_INET,
 		.tuple.src.u.udp.port	= cpu_to_be16(10080),
 		.tuple.dst.protonum	= IPPROTO_UDP,
 		.expect_policy		= &amanda_exp_policy,
+		.nat_mod_name		= NF_NAT_HELPER_NAME(HELPER_NAME),
 	},
 	{
 		.name			= "amanda",
@@ -195,6 +198,7 @@ static struct nf_conntrack_helper amanda_helper[2] __read_mostly = {
 		.tuple.src.u.udp.port	= cpu_to_be16(10080),
 		.tuple.dst.protonum	= IPPROTO_UDP,
 		.expect_policy		= &amanda_exp_policy,
+		.nat_mod_name		= NF_NAT_HELPER_NAME(HELPER_NAME),
 	},
 };
 
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index a11c304fb771..a76f45fedb7a 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -29,11 +29,13 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_ftp.h>
 
+#define HELPER_NAME "ftp"
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp connection tracking helper");
 MODULE_ALIAS("ip_conntrack_ftp");
-MODULE_ALIAS_NFCT_HELPER("ftp");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 /* This is slow, but it's simple. --RR */
 static char *ftp_buffer;
@@ -588,12 +590,13 @@ static int __init nf_conntrack_ftp_init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 FTP connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&ftp[2 * i], AF_INET, IPPROTO_TCP, "ftp",
-				  FTP_PORT, ports[i], ports[i], &ftp_exp_policy,
-				  0, help, nf_ct_ftp_from_nlattr, THIS_MODULE);
-		nf_ct_helper_init(&ftp[2 * i + 1], AF_INET6, IPPROTO_TCP, "ftp",
+		nf_ct_helper_init(&ftp[2 * i], AF_INET, IPPROTO_TCP, HELPER_NAME,
 				  FTP_PORT, ports[i], ports[i], &ftp_exp_policy,
 				  0, help, nf_ct_ftp_from_nlattr, THIS_MODULE);
+		nf_ct_helper_init(&ftp[2 * i + 1], AF_INET6, IPPROTO_TCP,
+				  HELPER_NAME, FTP_PORT, ports[i], ports[i],
+				  &ftp_exp_policy, 0, help, nf_ct_ftp_from_nlattr,
+				  THIS_MODULE);
 	}
 
 	ret = nf_conntrack_helpers_register(ftp, ports_c * 2);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 274baf1dab87..8401bdba3b48 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -42,6 +42,9 @@ module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool, 0644);
 MODULE_PARM_DESC(nf_conntrack_helper,
 		 "Enable automatic conntrack helper assignment (default 0)");
 
+static DEFINE_MUTEX(nf_ct_nat_helpers_mutex);
+static struct list_head nf_ct_nat_helpers __read_mostly;
+
 /* Stupid hash, but collision free for the default registrations of the
  * helpers currently in the kernel. */
 static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
@@ -130,6 +133,75 @@ void nf_conntrack_helper_put(struct nf_conntrack_helper *helper)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_put);
 
+static struct nf_conntrack_nat_helper *
+nf_conntrack_nat_helper_find(const char *mod_name)
+{
+	struct nf_conntrack_nat_helper *cur;
+	bool found = false;
+
+	list_for_each_entry_rcu(cur, &nf_ct_nat_helpers, list) {
+		if (!strcmp(cur->mod_name, mod_name)) {
+			found = true;
+			break;
+		}
+	}
+	return found ? cur : NULL;
+}
+
+int
+nf_nat_helper_try_module_get(const char *name, u16 l3num, u8 protonum)
+{
+	struct nf_conntrack_helper *h;
+	struct nf_conntrack_nat_helper *nat;
+	char mod_name[NF_CT_HELPER_NAME_LEN];
+	int ret = 0;
+
+	rcu_read_lock();
+	h = __nf_conntrack_helper_find(name, l3num, protonum);
+	if (h == NULL) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	if (!strlen(h->nat_mod_name)) {
+		rcu_read_unlock();
+		return -EOPNOTSUPP;
+	}
+
+	nat = nf_conntrack_nat_helper_find(h->nat_mod_name);
+	if (nat == NULL) {
+		snprintf(mod_name, sizeof(mod_name), "%s", h->nat_mod_name);
+		rcu_read_unlock();
+		ret = request_module(mod_name);
+		if (ret != 0)
+			return ret;
+
+		rcu_read_lock();
+		nat = nf_conntrack_nat_helper_find(mod_name);
+		if (nat == NULL) {
+			rcu_read_unlock();
+			return -EINVAL;
+		}
+	}
+
+	if (!try_module_get(nat->module))
+		ret = -EINVAL;
+
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_nat_helper_try_module_get);
+
+void nf_nat_helper_put(struct nf_conntrack_helper *helper)
+{
+	struct nf_conntrack_nat_helper *nat;
+
+	nat = nf_conntrack_nat_helper_find(helper->nat_mod_name);
+	BUG_ON(nat == NULL);
+	module_put(nat->module);
+}
+EXPORT_SYMBOL_GPL(nf_nat_helper_put);
+
 struct nf_conn_help *
 nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
 {
@@ -430,6 +502,10 @@ void nf_ct_helper_init(struct nf_conntrack_helper *helper,
 	helper->help = help;
 	helper->from_nlattr = from_nlattr;
 	helper->me = module;
+	helper->nat_mod_name[0] = '\0';
+	if (name)
+		snprintf(helper->nat_mod_name, sizeof(helper->nat_mod_name),
+			 NF_NAT_HELPER_PREFIX"%s", name);
 
 	if (spec_port == default_port)
 		snprintf(helper->name, sizeof(helper->name), "%s", name);
@@ -466,6 +542,26 @@ void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *helper,
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helpers_unregister);
 
+void nf_nat_helper_register(struct nf_conntrack_nat_helper *nat)
+{
+	BUG_ON(nat->module == NULL);
+
+	mutex_lock(&nf_ct_nat_helpers_mutex);
+	list_add_rcu(&nat->list, &nf_ct_nat_helpers);
+	mutex_unlock(&nf_ct_nat_helpers_mutex);
+}
+EXPORT_SYMBOL_GPL(nf_nat_helper_register);
+
+void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
+{
+	BUG_ON(nat->module == NULL);
+
+	mutex_lock(&nf_ct_nat_helpers_mutex);
+	list_del_rcu(&nat->list);
+	mutex_unlock(&nf_ct_nat_helpers_mutex);
+}
+EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
+
 static const struct nf_ct_ext_type helper_extend = {
 	.len	= sizeof(struct nf_conn_help),
 	.align	= __alignof__(struct nf_conn_help),
@@ -493,6 +589,7 @@ int nf_conntrack_helper_init(void)
 		goto out_extend;
 	}
 
+	INIT_LIST_HEAD(&nf_ct_nat_helpers);
 	return 0;
 out_extend:
 	kvfree(nf_ct_helper_hash);
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 4099f4d79bae..79e5014b3b0d 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -42,11 +42,13 @@ unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
 				struct nf_conntrack_expect *exp) __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_irc_hook);
 
+#define HELPER_NAME "irc"
+
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_irc");
-MODULE_ALIAS_NFCT_HELPER("irc");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 module_param_array(ports, ushort, &ports_c, 0400);
 MODULE_PARM_DESC(ports, "port numbers of IRC servers");
@@ -259,7 +261,7 @@ static int __init nf_conntrack_irc_init(void)
 		ports[ports_c++] = IRC_PORT;
 
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&irc[i], AF_INET, IPPROTO_TCP, "irc",
+		nf_ct_helper_init(&irc[i], AF_INET, IPPROTO_TCP, HELPER_NAME,
 				  IRC_PORT, ports[i], i, &irc_exp_policy,
 				  0, help, NULL, THIS_MODULE);
 	}
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 5072ff96ab33..83306648dd0f 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -30,10 +30,12 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <linux/netfilter/nf_conntrack_sane.h>
 
+#define HELPER_NAME "sane"
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Schmidt <mschmidt@redhat.com>");
 MODULE_DESCRIPTION("SANE connection tracking helper");
-MODULE_ALIAS_NFCT_HELPER("sane");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 static char *sane_buffer;
 
@@ -195,12 +197,12 @@ static int __init nf_conntrack_sane_init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&sane[2 * i], AF_INET, IPPROTO_TCP, "sane",
-				  SANE_PORT, ports[i], ports[i],
+		nf_ct_helper_init(&sane[2 * i], AF_INET, IPPROTO_TCP,
+				  HELPER_NAME, SANE_PORT, ports[i], ports[i],
 				  &sane_exp_policy, 0, help, NULL,
 				  THIS_MODULE);
-		nf_ct_helper_init(&sane[2 * i + 1], AF_INET6, IPPROTO_TCP, "sane",
-				  SANE_PORT, ports[i], ports[i],
+		nf_ct_helper_init(&sane[2 * i + 1], AF_INET6, IPPROTO_TCP,
+				  HELPER_NAME, SANE_PORT, ports[i], ports[i],
 				  &sane_exp_policy, 0, help, NULL,
 				  THIS_MODULE);
 	}
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 39fcc1ed18f3..05f7324f245e 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -30,11 +30,13 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <linux/netfilter/nf_conntrack_sip.h>
 
+#define HELPER_NAME "sip"
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
 MODULE_DESCRIPTION("SIP connection tracking helper");
 MODULE_ALIAS("ip_conntrack_sip");
-MODULE_ALIAS_NFCT_HELPER("sip");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 #define MAX_PORTS	8
 static unsigned short ports[MAX_PORTS];
@@ -1669,21 +1671,21 @@ static int __init nf_conntrack_sip_init(void)
 		ports[ports_c++] = SIP_PORT;
 
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&sip[4 * i], AF_INET, IPPROTO_UDP, "sip",
-				  SIP_PORT, ports[i], i, sip_exp_policy,
-				  SIP_EXPECT_MAX, sip_help_udp,
+		nf_ct_helper_init(&sip[4 * i], AF_INET, IPPROTO_UDP,
+				  HELPER_NAME, SIP_PORT, ports[i], i,
+				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_udp,
 				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 1], AF_INET, IPPROTO_TCP, "sip",
-				  SIP_PORT, ports[i], i, sip_exp_policy,
-				  SIP_EXPECT_MAX, sip_help_tcp,
+		nf_ct_helper_init(&sip[4 * i + 1], AF_INET, IPPROTO_TCP,
+				  HELPER_NAME, SIP_PORT, ports[i], i,
+				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_tcp,
 				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 2], AF_INET6, IPPROTO_UDP, "sip",
-				  SIP_PORT, ports[i], i, sip_exp_policy,
-				  SIP_EXPECT_MAX, sip_help_udp,
+		nf_ct_helper_init(&sip[4 * i + 2], AF_INET6, IPPROTO_UDP,
+				  HELPER_NAME, SIP_PORT, ports[i], i,
+				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_udp,
 				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 3], AF_INET6, IPPROTO_TCP, "sip",
-				  SIP_PORT, ports[i], i, sip_exp_policy,
-				  SIP_EXPECT_MAX, sip_help_tcp,
+		nf_ct_helper_init(&sip[4 * i + 3], AF_INET6, IPPROTO_TCP,
+				  HELPER_NAME, SIP_PORT, ports[i], i,
+				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_tcp,
 				  NULL, THIS_MODULE);
 	}
 
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 548b673b3625..6977cb91ae9a 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -20,11 +20,13 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_tftp.h>
 
+#define HELPER_NAME "tftp"
+
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
 MODULE_DESCRIPTION("TFTP connection tracking helper");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_tftp");
-MODULE_ALIAS_NFCT_HELPER("tftp");
+MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
 #define MAX_PORTS 8
 static unsigned short ports[MAX_PORTS];
@@ -119,12 +121,14 @@ static int __init nf_conntrack_tftp_init(void)
 		ports[ports_c++] = TFTP_PORT;
 
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&tftp[2 * i], AF_INET, IPPROTO_UDP, "tftp",
-				  TFTP_PORT, ports[i], i, &tftp_exp_policy,
-				  0, tftp_help, NULL, THIS_MODULE);
-		nf_ct_helper_init(&tftp[2 * i + 1], AF_INET6, IPPROTO_UDP, "tftp",
-				  TFTP_PORT, ports[i], i, &tftp_exp_policy,
-				  0, tftp_help, NULL, THIS_MODULE);
+		nf_ct_helper_init(&tftp[2 * i], AF_INET, IPPROTO_UDP,
+				  HELPER_NAME, TFTP_PORT, ports[i], i,
+				  &tftp_exp_policy, 0, tftp_help, NULL,
+				  THIS_MODULE);
+		nf_ct_helper_init(&tftp[2 * i + 1], AF_INET6, IPPROTO_UDP,
+				  HELPER_NAME, TFTP_PORT, ports[i], i,
+				  &tftp_exp_policy, 0, tftp_help, NULL,
+				  THIS_MODULE);
 	}
 
 	ret = nf_conntrack_helpers_register(tftp, ports_c * 2);
-- 
2.20.1

