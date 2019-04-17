Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE900C282DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 978A42173C
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732535AbfDQOqi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:46:38 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36051 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732372AbfDQOqi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 10:46:38 -0400
Received: by mail-qt1-f193.google.com with SMTP id s15so27657024qtn.3
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2019 07:46:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ym6GGBLBuOYicIt5ZeMZSQ4AyWzKqet1uh74H5Umi1Y=;
        b=JamRbjQbVrPAv/tkJN3sFOe0UTQZDkgmjXiCjuOq8+u2YAYCK1oAcFtMOfF2ZLu+++
         6GcZwYKKcb8qwz7c80G9w8fNTN+OsJV1qWOAY+4KNzHNGpQ1i9V3I6yTz45HVqAL/ec9
         65hdy9GuoQxwxGWCMUrpMH5KFKtE/p65NwRNgmUipGqhrG4RMvN5pYd0S5tSb61Phzdp
         dNdEkZz98O5mHoU+a65+/FF4xONQ9wX+pMtu/1Mf8+aCYGSa1iOvPdTkYWfgGBn/WQL0
         kFLycH4r9xqAEK+TfRV6ryE2wxvqOZFYZ2P26/2g+NBIK5UAdBAMVRCAyHwWJ/zKdngF
         KMwQ==
X-Gm-Message-State: APjAAAU5XtsUzOSgLqsH44CeC9N/WQsh5Ikn+NVF4iJ9oBHDfU2bZQiZ
        m6Ql6tbnNe6CKadHz/2yLO/DwnTgWIQ=
X-Google-Smtp-Source: APXvYqwuIhaMqD2Ar+g5bZXXYwnDNOSoGDv1GZB19vuXedDXSf/KzOgxorpMU7htSJz6jdfs24hxPg==
X-Received: by 2002:ac8:65c3:: with SMTP id t3mr70919713qto.12.1555512397561;
        Wed, 17 Apr 2019 07:46:37 -0700 (PDT)
Received: from localhost ([177.183.215.200])
        by smtp.gmail.com with ESMTPSA id h187sm32501582qkf.97.2019.04.17.07.46.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 07:46:37 -0700 (PDT)
From:   Flavio Leitner <fbl@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next v3 3/4] netfilter: nf_nat: register NAT helpers.
Date:   Wed, 17 Apr 2019 11:46:16 -0300
Message-Id: <20190417144617.14922-4-fbl@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190417144617.14922-1-fbl@redhat.com>
References: <20190417144617.14922-1-fbl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Register amanda, ftp, irc, sip and tftp NAT helpers.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
---
 net/netfilter/nf_nat_amanda.c | 9 ++++++++-
 net/netfilter/nf_nat_ftp.c    | 9 ++++++++-
 net/netfilter/nf_nat_irc.c    | 9 ++++++++-
 net/netfilter/nf_nat_sip.c    | 9 +++++++--
 net/netfilter/nf_nat_tftp.c   | 9 ++++++++-
 5 files changed, 39 insertions(+), 6 deletions(-)

v3
  - grouped all NAT helpers changes into a single patch.

v2
  - defined NAT_HELPER_NAME for consistency.
  - C99 static change.
  - renamed the variables to be nat_helper.*

diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index 6b729a897c5f..4e59416ea709 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -19,10 +19,15 @@
 #include <net/netfilter/nf_nat_helper.h>
 #include <linux/netfilter/nf_conntrack_amanda.h>
 
+#define NAT_HELPER_NAME "amanda"
+
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_NF_NAT_HELPER("amanda");
+MODULE_ALIAS_NF_NAT_HELPER(NAT_HELPER_NAME);
+
+static struct nf_conntrack_nat_helper nat_helper_amanda =
+	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
 
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
@@ -74,6 +79,7 @@ static unsigned int help(struct sk_buff *skb,
 
 static void __exit nf_nat_amanda_fini(void)
 {
+	nf_nat_helper_unregister(&nat_helper_amanda);
 	RCU_INIT_POINTER(nf_nat_amanda_hook, NULL);
 	synchronize_rcu();
 }
@@ -81,6 +87,7 @@ static void __exit nf_nat_amanda_fini(void)
 static int __init nf_nat_amanda_init(void)
 {
 	BUG_ON(nf_nat_amanda_hook != NULL);
+	nf_nat_helper_register(&nat_helper_amanda);
 	RCU_INIT_POINTER(nf_nat_amanda_hook, help);
 	return 0;
 }
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index 0e93b1f19432..0ea6b1bc52de 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -21,13 +21,18 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <linux/netfilter/nf_conntrack_ftp.h>
 
+#define NAT_HELPER_NAME "ftp"
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp NAT helper");
-MODULE_ALIAS_NF_NAT_HELPER("ftp");
+MODULE_ALIAS_NF_NAT_HELPER(NAT_HELPER_NAME);
 
 /* FIXME: Time out? --RR */
 
+static struct nf_conntrack_nat_helper nat_helper_ftp =
+	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
+
 static int nf_nat_ftp_fmt_cmd(struct nf_conn *ct, enum nf_ct_ftp_type type,
 			      char *buffer, size_t buflen,
 			      union nf_inet_addr *addr, u16 port)
@@ -124,6 +129,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 
 static void __exit nf_nat_ftp_fini(void)
 {
+	nf_nat_helper_unregister(&nat_helper_ftp);
 	RCU_INIT_POINTER(nf_nat_ftp_hook, NULL);
 	synchronize_rcu();
 }
@@ -131,6 +137,7 @@ static void __exit nf_nat_ftp_fini(void)
 static int __init nf_nat_ftp_init(void)
 {
 	BUG_ON(nf_nat_ftp_hook != NULL);
+	nf_nat_helper_register(&nat_helper_ftp);
 	RCU_INIT_POINTER(nf_nat_ftp_hook, nf_nat_ftp);
 	return 0;
 }
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 6c06e997395f..d87cbe5e03ec 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -23,10 +23,15 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <linux/netfilter/nf_conntrack_irc.h>
 
+#define NAT_HELPER_NAME "irc"
+
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_NF_NAT_HELPER("irc");
+MODULE_ALIAS_NF_NAT_HELPER(NAT_HELPER_NAME);
+
+static struct nf_conntrack_nat_helper nat_helper_irc =
+	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
 
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
@@ -96,6 +101,7 @@ static unsigned int help(struct sk_buff *skb,
 
 static void __exit nf_nat_irc_fini(void)
 {
+	nf_nat_helper_unregister(&nat_helper_irc);
 	RCU_INIT_POINTER(nf_nat_irc_hook, NULL);
 	synchronize_rcu();
 }
@@ -103,6 +109,7 @@ static void __exit nf_nat_irc_fini(void)
 static int __init nf_nat_irc_init(void)
 {
 	BUG_ON(nf_nat_irc_hook != NULL);
+	nf_nat_helper_register(&nat_helper_irc);
 	RCU_INIT_POINTER(nf_nat_irc_hook, help);
 	return 0;
 }
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index f1f007d9484c..464387b3600f 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -24,11 +24,15 @@
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <linux/netfilter/nf_conntrack_sip.h>
 
+#define NAT_HELPER_NAME "sip"
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
 MODULE_DESCRIPTION("SIP NAT helper");
-MODULE_ALIAS_NF_NAT_HELPER("sip");
+MODULE_ALIAS_NF_NAT_HELPER(NAT_HELPER_NAME);
 
+static struct nf_conntrack_nat_helper nat_helper_sip =
+	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
 
 static unsigned int mangle_packet(struct sk_buff *skb, unsigned int protoff,
 				  unsigned int dataoff,
@@ -656,8 +660,8 @@ static struct nf_ct_helper_expectfn sip_nat = {
 
 static void __exit nf_nat_sip_fini(void)
 {
+	nf_nat_helper_unregister(&nat_helper_sip);
 	RCU_INIT_POINTER(nf_nat_sip_hooks, NULL);
-
 	nf_ct_helper_expectfn_unregister(&sip_nat);
 	synchronize_rcu();
 }
@@ -675,6 +679,7 @@ static const struct nf_nat_sip_hooks sip_hooks = {
 static int __init nf_nat_sip_init(void)
 {
 	BUG_ON(nf_nat_sip_hooks != NULL);
+	nf_nat_helper_register(&nat_helper_sip);
 	RCU_INIT_POINTER(nf_nat_sip_hooks, &sip_hooks);
 	nf_ct_helper_expectfn_register(&sip_nat);
 	return 0;
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index dd3a835c111d..e633b3863e33 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -13,10 +13,15 @@
 #include <net/netfilter/nf_nat_helper.h>
 #include <linux/netfilter/nf_conntrack_tftp.h>
 
+#define NAT_HELPER_NAME "tftp"
+
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
 MODULE_DESCRIPTION("TFTP NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_NF_NAT_HELPER("tftp");
+MODULE_ALIAS_NF_NAT_HELPER(NAT_HELPER_NAME);
+
+static struct nf_conntrack_nat_helper nat_helper_tftp =
+	NF_CT_NAT_HELPER_INIT(NAT_HELPER_NAME);
 
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
@@ -37,6 +42,7 @@ static unsigned int help(struct sk_buff *skb,
 
 static void __exit nf_nat_tftp_fini(void)
 {
+	nf_nat_helper_unregister(&nat_helper_tftp);
 	RCU_INIT_POINTER(nf_nat_tftp_hook, NULL);
 	synchronize_rcu();
 }
@@ -44,6 +50,7 @@ static void __exit nf_nat_tftp_fini(void)
 static int __init nf_nat_tftp_init(void)
 {
 	BUG_ON(nf_nat_tftp_hook != NULL);
+	nf_nat_helper_register(&nat_helper_tftp);
 	RCU_INIT_POINTER(nf_nat_tftp_hook, help);
 	return 0;
 }
-- 
2.20.1

