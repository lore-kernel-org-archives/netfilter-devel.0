Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A095136358
	for <netfilter-devel@vger.kernel.org>; Fri, 22 May 2026 05:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779426124; cv=none; b=SVREiHIkT0rsG/BQC6sFgxrKQ5PYGC7GBotaku9XRsKf+ys0mQk9mh7vnAeqYatT5aCmaNM8TjekqWvslFbLM5hvIQWxkMrUkFTbm1BlIMsuuqfRog1s4k0FQiVDMasG6x5JYwAdlNIgB4b03yAlj8F6wzBiM3ZtURCB/sxKn/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779426124; c=relaxed/simple;
	bh=1Z7MY8bbafCOUkFvOzonl9/fSF5v9MFrA7Bb9KoGVN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFMr3kZcNXV//J98q87t0TuNlyLMkLXyX9BefRhznLBm1CVEgQ7OgTjTzBMOdO/zL+CyTWLTs/2w43VKhCzcVkweV6FhQn1hsZOtIo+CWxN1O1mncuPcwTl2mOem+gz5XcGzowlUT2WmgANAHm8k/NsXBOM4d45oKoOHac744lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 12CB960345; Fri, 22 May 2026 07:02:00 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/5] netfilter: nf_conntrack: switch to static registration
Date: Fri, 22 May 2026 07:01:32 +0200
Message-ID: <20260522050140.4838-4-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522050140.4838-1-fw@strlen.de>
References: <20260522050140.4838-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

helper autoassign was removed years ago, one instance is enough.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_ftp.c  | 51 +++++++-------------------
 net/netfilter/nf_conntrack_irc.c  | 38 ++++++++-----------
 net/netfilter/nf_conntrack_sane.c | 50 +++++++------------------
 net/netfilter/nf_conntrack_sip.c  | 61 +++++++++++--------------------
 net/netfilter/nf_conntrack_tftp.c | 47 +++++++-----------------
 5 files changed, 77 insertions(+), 170 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index de83bf9e6c61..c9dadfef81ba 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -35,11 +35,6 @@ MODULE_ALIAS("ip_conntrack_ftp");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 static DEFINE_SPINLOCK(nf_ftp_lock);
 
-#define MAX_PORTS 8
-static u_int16_t ports[MAX_PORTS];
-static unsigned int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
-
 static bool loose;
 module_param(loose, bool, 0600);
 
@@ -360,10 +355,8 @@ static void update_nl_seq(struct nf_conn *ct, u32 nl_seq,
 	}
 }
 
-static int help(struct sk_buff *skb,
-		unsigned int protoff,
-		struct nf_conn *ct,
-		enum ip_conntrack_info ctinfo)
+static int ftp_help(struct sk_buff *skb, unsigned int protoff,
+		    struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
 	unsigned int dataoff, datalen;
 	const struct tcphdr *th;
@@ -551,47 +544,31 @@ static int nf_ct_ftp_from_nlattr(struct nlattr *attr, struct nf_conn *ct)
 	return 0;
 }
 
-static struct nf_conntrack_helper ftp[MAX_PORTS * 2] __read_mostly;
-
 static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 	.max_expected	= 1,
 	.timeout	= 5 * 60,
 };
 
+static struct nf_conntrack_helper ftp __read_mostly = {
+	.name			= HELPER_NAME,
+	.me			= THIS_MODULE,
+	.nfproto		= NFPROTO_UNSPEC,
+	.l4proto		= IPPROTO_TCP,
+	.help			= ftp_help,
+	.expect_policy		= &ftp_exp_policy,
+	.from_nlattr		= nf_ct_ftp_from_nlattr,
+};
+
 static void __exit nf_conntrack_ftp_fini(void)
 {
-	nf_conntrack_helpers_unregister(ftp, ports_c * 2);
+	nf_conntrack_helper_unregister(&ftp);
 }
 
 static int __init nf_conntrack_ftp_init(void)
 {
-	int i, ret = 0;
-
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_ftp_master));
 
-	if (ports_c == 0)
-		ports[ports_c++] = FTP_PORT;
-
-	/* FIXME should be configurable whether IPv4 and IPv6 FTP connections
-		 are tracked or not - YK */
-	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&ftp[2 * i], AF_INET, IPPROTO_TCP,
-				  HELPER_NAME, FTP_PORT, ports[i], ports[i],
-				  &ftp_exp_policy, 0, help,
-				  nf_ct_ftp_from_nlattr, THIS_MODULE);
-		nf_ct_helper_init(&ftp[2 * i + 1], AF_INET6, IPPROTO_TCP,
-				  HELPER_NAME, FTP_PORT, ports[i], ports[i],
-				  &ftp_exp_policy, 0, help,
-				  nf_ct_ftp_from_nlattr, THIS_MODULE);
-	}
-
-	ret = nf_conntrack_helpers_register(ftp, ports_c * 2);
-	if (ret < 0) {
-		pr_err("failed to register helpers\n");
-		return ret;
-	}
-
-	return 0;
+	return nf_conntrack_helper_register(&ftp);
 }
 
 module_init(nf_conntrack_ftp_init);
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 522183b9a604..4e07963a5c73 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -21,9 +21,6 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <linux/netfilter/nf_conntrack_irc.h>
 
-#define MAX_PORTS 8
-static unsigned short ports[MAX_PORTS];
-static unsigned int ports_c;
 static unsigned int max_dcc_channels = 8;
 static unsigned int dcc_timeout __read_mostly = 300;
 /* This is slow, but it's simple. --RR */
@@ -42,8 +39,6 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_irc");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
-module_param_array(ports, ushort, &ports_c, 0400);
-MODULE_PARM_DESC(ports, "port numbers of IRC servers");
 module_param(max_dcc_channels, uint, 0400);
 MODULE_PARM_DESC(max_dcc_channels, "max number of expected DCC channels per "
 				   "IRC session");
@@ -99,8 +94,8 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
 	return 0;
 }
 
-static int help(struct sk_buff *skb, unsigned int protoff,
-		struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+static int irc_help(struct sk_buff *skb, unsigned int protoff,
+		    struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
 	unsigned int dataoff;
 	const struct iphdr *iph;
@@ -254,12 +249,20 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	return ret;
 }
 
-static struct nf_conntrack_helper irc[MAX_PORTS] __read_mostly;
-static struct nf_conntrack_expect_policy irc_exp_policy;
+static struct nf_conntrack_expect_policy irc_exp_policy __ro_after_init;
+
+static struct nf_conntrack_helper irc __read_mostly = {
+	.name			= HELPER_NAME,
+	.me			= THIS_MODULE,
+	.help			= irc_help,
+	.nfproto		= NFPROTO_IPV4,
+	.l4proto		= IPPROTO_TCP,
+	.expect_policy		= &irc_exp_policy,
+};
 
 static int __init nf_conntrack_irc_init(void)
 {
-	int i, ret;
+	int ret;
 
 	if (max_dcc_channels < 1) {
 		pr_err("max_dcc_channels must not be zero\n");
@@ -279,19 +282,8 @@ static int __init nf_conntrack_irc_init(void)
 	if (!irc_buffer)
 		return -ENOMEM;
 
-	/* If no port given, default to standard irc port */
-	if (ports_c == 0)
-		ports[ports_c++] = IRC_PORT;
-
-	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&irc[i], AF_INET, IPPROTO_TCP, HELPER_NAME,
-				  IRC_PORT, ports[i], i, &irc_exp_policy,
-				  0, help, NULL, THIS_MODULE);
-	}
-
-	ret = nf_conntrack_helpers_register(&irc[0], ports_c);
+	ret = nf_conntrack_helper_register(&irc);
 	if (ret) {
-		pr_err("failed to register helpers\n");
 		kfree(irc_buffer);
 		return ret;
 	}
@@ -301,7 +293,7 @@ static int __init nf_conntrack_irc_init(void)
 
 static void __exit nf_conntrack_irc_fini(void)
 {
-	nf_conntrack_helpers_unregister(irc, ports_c);
+	nf_conntrack_helper_unregister(&irc);
 	kfree(irc_buffer);
 }
 
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 13dc421fc4f5..db52a045ce5d 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -34,11 +34,6 @@ MODULE_AUTHOR("Michal Schmidt <mschmidt@redhat.com>");
 MODULE_DESCRIPTION("SANE connection tracking helper");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
-#define MAX_PORTS 8
-static u_int16_t ports[MAX_PORTS];
-static unsigned int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
-
 struct sane_request {
 	__be32 RPC_code;
 #define SANE_NET_START      7   /* RPC code */
@@ -55,10 +50,8 @@ struct sane_reply_net_start {
 	/* other fields aren't interesting for conntrack */
 };
 
-static int help(struct sk_buff *skb,
-		unsigned int protoff,
-		struct nf_conn *ct,
-		enum ip_conntrack_info ctinfo)
+static int sane_help(struct sk_buff *skb, unsigned int protoff,
+		     struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
 	unsigned int dataoff, datalen;
 	const struct tcphdr *th;
@@ -166,47 +159,30 @@ static int help(struct sk_buff *skb,
 	return ret;
 }
 
-static struct nf_conntrack_helper sane[MAX_PORTS * 2] __read_mostly;
-
 static const struct nf_conntrack_expect_policy sane_exp_policy = {
 	.max_expected	= 1,
 	.timeout	= 5 * 60,
 };
 
+static struct nf_conntrack_helper sane __read_mostly = {
+	.name			= HELPER_NAME,
+	.me			= THIS_MODULE,
+	.nfproto		= NFPROTO_UNSPEC,
+	.l4proto		= IPPROTO_TCP,
+	.help			= sane_help,
+	.expect_policy		= &sane_exp_policy,
+};
+
 static void __exit nf_conntrack_sane_fini(void)
 {
-	nf_conntrack_helpers_unregister(sane, ports_c * 2);
+	nf_conntrack_helper_unregister(&sane);
 }
 
 static int __init nf_conntrack_sane_init(void)
 {
-	int i, ret = 0;
-
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_sane_master));
 
-	if (ports_c == 0)
-		ports[ports_c++] = SANE_PORT;
-
-	/* FIXME should be configurable whether IPv4 and IPv6 connections
-		 are tracked or not - YK */
-	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&sane[2 * i], AF_INET, IPPROTO_TCP,
-				  HELPER_NAME, SANE_PORT, ports[i], ports[i],
-				  &sane_exp_policy, 0, help, NULL,
-				  THIS_MODULE);
-		nf_ct_helper_init(&sane[2 * i + 1], AF_INET6, IPPROTO_TCP,
-				  HELPER_NAME, SANE_PORT, ports[i], ports[i],
-				  &sane_exp_policy, 0, help, NULL,
-				  THIS_MODULE);
-	}
-
-	ret = nf_conntrack_helpers_register(sane, ports_c * 2);
-	if (ret < 0) {
-		pr_err("failed to register helpers\n");
-		return ret;
-	}
-
-	return 0;
+	return nf_conntrack_helper_register(&sane);
 }
 
 module_init(nf_conntrack_sane_init);
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index e69941f1a101..aca24d8dbfbc 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -35,12 +35,6 @@ MODULE_DESCRIPTION("SIP connection tracking helper");
 MODULE_ALIAS("ip_conntrack_sip");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
-#define MAX_PORTS	8
-static unsigned short ports[MAX_PORTS];
-static unsigned int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
-MODULE_PARM_DESC(ports, "port numbers of SIP servers");
-
 static unsigned int sip_timeout __read_mostly = SIP_TIMEOUT;
 module_param(sip_timeout, uint, 0600);
 MODULE_PARM_DESC(sip_timeout, "timeout for the master SIP session");
@@ -1730,8 +1724,6 @@ static int sip_help_udp(struct sk_buff *skb, unsigned int protoff,
 	return process_sip_msg(skb, ct, protoff, dataoff, &dptr, &datalen);
 }
 
-static struct nf_conntrack_helper sip[MAX_PORTS * 4] __read_mostly;
-
 static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1] = {
 	[SIP_EXPECT_SIGNALLING] = {
 		.name		= "signalling",
@@ -1755,45 +1747,36 @@ static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1
 	},
 };
 
+static struct nf_conntrack_helper sip[] __read_mostly = {
+	{
+		.name			= HELPER_NAME,
+		.me			= THIS_MODULE,
+		.nfproto		= NFPROTO_UNSPEC,
+		.l4proto		= IPPROTO_TCP,
+		.help			= sip_help_tcp,
+		.expect_policy		= sip_exp_policy,
+		.expect_class_max	= SIP_EXPECT_MAX,
+	}, {
+		.name			= HELPER_NAME,
+		.me			= THIS_MODULE,
+		.nfproto		= NFPROTO_UNSPEC,
+		.l4proto		= IPPROTO_UDP,
+		.help			= sip_help_udp,
+		.expect_policy		= sip_exp_policy,
+		.expect_class_max	= SIP_EXPECT_MAX,
+	}
+};
+
 static void __exit nf_conntrack_sip_fini(void)
 {
-	nf_conntrack_helpers_unregister(sip, ports_c * 4);
+	nf_conntrack_helpers_unregister(sip, ARRAY_SIZE(sip));
 }
 
 static int __init nf_conntrack_sip_init(void)
 {
-	int i, ret;
-
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_sip_master));
 
-	if (ports_c == 0)
-		ports[ports_c++] = SIP_PORT;
-
-	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&sip[4 * i], AF_INET, IPPROTO_UDP,
-				  HELPER_NAME, SIP_PORT, ports[i], i,
-				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_udp,
-				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 1], AF_INET, IPPROTO_TCP,
-				  HELPER_NAME, SIP_PORT, ports[i], i,
-				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_tcp,
-				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 2], AF_INET6, IPPROTO_UDP,
-				  HELPER_NAME, SIP_PORT, ports[i], i,
-				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_udp,
-				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 3], AF_INET6, IPPROTO_TCP,
-				  HELPER_NAME, SIP_PORT, ports[i], i,
-				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_tcp,
-				  NULL, THIS_MODULE);
-	}
-
-	ret = nf_conntrack_helpers_register(sip, ports_c * 4);
-	if (ret < 0) {
-		pr_err("failed to register helpers\n");
-		return ret;
-	}
-	return 0;
+	return nf_conntrack_helpers_register(sip, ARRAY_SIZE(sip));
 }
 
 module_init(nf_conntrack_sip_init);
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index a2e6833a0bf7..aaa048c72b6c 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -26,12 +26,6 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ip_conntrack_tftp");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
-#define MAX_PORTS 8
-static unsigned short ports[MAX_PORTS];
-static unsigned int ports_c;
-module_param_array(ports, ushort, &ports_c, 0400);
-MODULE_PARM_DESC(ports, "Port numbers of TFTP servers");
-
 nf_nat_tftp_hook_fn __rcu *nf_nat_tftp_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_tftp_hook);
 
@@ -95,45 +89,30 @@ static int tftp_help(struct sk_buff *skb,
 	return ret;
 }
 
-static struct nf_conntrack_helper tftp[MAX_PORTS * 2] __read_mostly;
-
 static const struct nf_conntrack_expect_policy tftp_exp_policy = {
 	.max_expected	= 1,
 	.timeout	= 5 * 60,
 };
 
-static void __exit nf_conntrack_tftp_fini(void)
-{
-	nf_conntrack_helpers_unregister(tftp, ports_c * 2);
-}
+static struct nf_conntrack_helper tftp __read_mostly = {
+	.name			= HELPER_NAME,
+	.me			= THIS_MODULE,
+	.nfproto		= NFPROTO_UNSPEC,
+	.l4proto		= IPPROTO_UDP,
+	.help			= tftp_help,
+	.expect_policy		= &tftp_exp_policy,
+};
 
 static int __init nf_conntrack_tftp_init(void)
 {
-	int i, ret;
-
 	NF_CT_HELPER_BUILD_BUG_ON(0);
 
-	if (ports_c == 0)
-		ports[ports_c++] = TFTP_PORT;
-
-	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&tftp[2 * i], AF_INET, IPPROTO_UDP,
-				  HELPER_NAME, TFTP_PORT, ports[i], i,
-				  &tftp_exp_policy, 0, tftp_help, NULL,
-				  THIS_MODULE);
-		nf_ct_helper_init(&tftp[2 * i + 1], AF_INET6, IPPROTO_UDP,
-				  HELPER_NAME, TFTP_PORT, ports[i], i,
-				  &tftp_exp_policy, 0, tftp_help, NULL,
-				  THIS_MODULE);
-	}
-
-	ret = nf_conntrack_helpers_register(tftp, ports_c * 2);
-	if (ret < 0) {
-		pr_err("failed to register helpers\n");
-		return ret;
-	}
-	return 0;
+	return nf_conntrack_helper_register(&tftp);
 }
 
+static void __exit nf_conntrack_tftp_fini(void)
+{
+	nf_conntrack_helper_unregister(&tftp);
+}
 module_init(nf_conntrack_tftp_init);
 module_exit(nf_conntrack_tftp_fini);
-- 
2.53.0

