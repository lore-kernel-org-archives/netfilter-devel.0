Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBEC7C282DD
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C77BB2173C
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 14:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732359AbfDQOqd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:46:33 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36779 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731996AbfDQOqc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 10:46:32 -0400
Received: by mail-qk1-f195.google.com with SMTP id s83so1159175qke.3
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2019 07:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KYkRd+0YFujbO64YZ2ZUdK4IYAU0E6bqD1JRTSkjXVA=;
        b=OVt3X9hHW6pq+5/I6VV7gmkb7Cj9EnaNb/fQXNeY/nPK/cN6H/Qh2VkPurSjHygCUn
         xWuhXE0k3k/zop6hWKlvphvupKDMI/jalbCi2AzaYAFysk+BsrDsePfPQuUYb3bzuE03
         SscD0/RKsE+jZzLP+vG56EitJFMEBZ6TSh6D70ON1v8sPfclSQLxvXGL4qW2fIl6IAjP
         Cng4BUw9oE84aprjaXT7ir9ffXFMyskES4jcaYDzkdJxeZRYPH56YO9Jqf6xm4HuD9kL
         yoncrrit3dG0/z64RxCWspJfgx+B5BNlmmq8ZUYBdz04WwvJKc1ERh4eDhcfMrYW/5j5
         PVCA==
X-Gm-Message-State: APjAAAXQdVYot1DaLGSNkSlck+hXN5DhG5FTlbqEtqAbnEPw8nBsdJQh
        LhoSgbfLjOHOQStah4F1pfAnKPvYOzA=
X-Google-Smtp-Source: APXvYqwcRGmJhGi9gZbh3ON0dpwKGFI2hp4dG4m+ygpjlGdAK67REUxVKHjR9RvArQB5KaeIwbGQAw==
X-Received: by 2002:ae9:e107:: with SMTP id g7mr3294831qkm.272.1555512391720;
        Wed, 17 Apr 2019 07:46:31 -0700 (PDT)
Received: from localhost ([177.183.215.200])
        by smtp.gmail.com with ESMTPSA id x191sm31486808qka.78.2019.04.17.07.46.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 07:46:31 -0700 (PDT)
From:   Flavio Leitner <fbl@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next v3 1/4] netfilter: use macros to create module aliases.
Date:   Wed, 17 Apr 2019 11:46:14 -0300
Message-Id: <20190417144617.14922-2-fbl@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190417144617.14922-1-fbl@redhat.com>
References: <20190417144617.14922-1-fbl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Each NAT helper creates a module alias which follows a pattern.
Use macros for consistency.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
---
 include/net/netfilter/nf_conntrack_helper.h | 4 ++++
 net/ipv4/netfilter/nf_nat_h323.c            | 2 +-
 net/ipv4/netfilter/nf_nat_pptp.c            | 2 +-
 net/netfilter/nf_nat_amanda.c               | 2 +-
 net/netfilter/nf_nat_ftp.c                  | 2 +-
 net/netfilter/nf_nat_irc.c                  | 2 +-
 net/netfilter/nf_nat_sip.c                  | 2 +-
 net/netfilter/nf_nat_tftp.c                 | 2 +-
 8 files changed, 11 insertions(+), 7 deletions(-)

v3
  - no changes.
v2
  - renamed the defines as suggested by Pablo.

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index ec52a8dc32fd..28bd4569aa64 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -15,6 +15,10 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 
+#define NF_NAT_HELPER_NAME(name)	"ip_nat_" name
+#define MODULE_ALIAS_NF_NAT_HELPER(name) \
+	MODULE_ALIAS(NF_NAT_HELPER_NAME(name))
+
 struct module;
 
 enum nf_ct_helper_flags {
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 4e6b53ab6c33..7875c98072eb 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -631,4 +631,4 @@ module_exit(fini);
 MODULE_AUTHOR("Jing Min Zhao <zhaojingmin@users.sourceforge.net>");
 MODULE_DESCRIPTION("H.323 NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip_nat_h323");
+MODULE_ALIAS_NF_NAT_HELPER("h323");
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 68b4d450391b..e17b4ee7604c 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -37,7 +37,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Netfilter NAT helper module for PPTP");
-MODULE_ALIAS("ip_nat_pptp");
+MODULE_ALIAS_NF_NAT_HELPER("pptp");
 
 static void pptp_nat_expected(struct nf_conn *ct,
 			      struct nf_conntrack_expect *exp)
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index e4d61a7a5258..6b729a897c5f 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -22,7 +22,7 @@
 MODULE_AUTHOR("Brian J. Murrell <netfilter@interlinx.bc.ca>");
 MODULE_DESCRIPTION("Amanda NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip_nat_amanda");
+MODULE_ALIAS_NF_NAT_HELPER("amanda");
 
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index 5063cbf1689c..0e93b1f19432 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -24,7 +24,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp NAT helper");
-MODULE_ALIAS("ip_nat_ftp");
+MODULE_ALIAS_NF_NAT_HELPER("ftp");
 
 /* FIXME: Time out? --RR */
 
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 3aa35a43100d..6c06e997395f 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -26,7 +26,7 @@
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("IRC (DCC) NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip_nat_irc");
+MODULE_ALIAS_NF_NAT_HELPER("irc");
 
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index aa1be643d7a0..f1f007d9484c 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -27,7 +27,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Hentschel <chentschel@arnet.com.ar>");
 MODULE_DESCRIPTION("SIP NAT helper");
-MODULE_ALIAS("ip_nat_sip");
+MODULE_ALIAS_NF_NAT_HELPER("sip");
 
 
 static unsigned int mangle_packet(struct sk_buff *skb, unsigned int protoff,
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index 7f67e1d5310d..dd3a835c111d 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -16,7 +16,7 @@
 MODULE_AUTHOR("Magnus Boden <mb@ozaba.mine.nu>");
 MODULE_DESCRIPTION("TFTP NAT helper");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("ip_nat_tftp");
+MODULE_ALIAS_NF_NAT_HELPER("tftp");
 
 static unsigned int help(struct sk_buff *skb,
 			 enum ip_conntrack_info ctinfo,
-- 
2.20.1

