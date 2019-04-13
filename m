Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF4EC10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77F1F20870
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfDMXRa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 19:17:30 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39123 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfDMXRa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 19:17:30 -0400
Received: by mail-qt1-f193.google.com with SMTP id t28so15344816qte.6
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 16:17:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AQp+2Dq6WkavGLWELtQ7+COUoG/u5/ieM+Q6jRMm4L4=;
        b=Lhm3ZNr5CXk86PGw3mZRcFKRjbYZcL53qa7nEOALsGV0n+v3xkeKtFLIdE4r7uqwiL
         L6WnXe7vOjwhfaOm3NQEAOUmmQPvp7DnCDJTnxwA+zhBOvzfHYrgvnWWS+eDt+ikqQWx
         Vs1u4kMx4nNHOC940BlMmWbxkTHHlyRYX1EFzJGuR3P2LVs7KKZSihZ+8xAfTrpTUYVr
         7EHa9P69E5J0BSYeBcB6FNlztykslwFjf6K0h7Fc36VQLBgI5OAPjEWQZ0rmY8pinmsu
         iL/1uigI+z39wQdoiUDsCpVJW9p2JPIs+0xQ/ZQyqV99IsOBxo/e5KOv5NhTm13cZ9Kj
         RnJg==
X-Gm-Message-State: APjAAAX78Fadap+QNNxwTUzlbUPMkpGWG4xlyYgpEzJ+fuz3T9UxQIte
        RoS6gZf05yiWs0WmO0R7xkBtvQ==
X-Google-Smtp-Source: APXvYqwFaXXVMSdBTAmqRDeruGBbBNpmFwWmW4D6ujF1GAnuvquyrUoBTNRh43RpP3Xr30yg4DGOCw==
X-Received: by 2002:ac8:4295:: with SMTP id o21mr42528090qtl.101.1555197449315;
        Sat, 13 Apr 2019 16:17:29 -0700 (PDT)
Received: from localhost ([177.183.215.126])
        by smtp.gmail.com with ESMTPSA id u3sm19687914qkc.21.2019.04.13.16.17.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 13 Apr 2019 16:17:28 -0700 (PDT)
From:   Flavio Leitner <fbl@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next v2 1/8] netfilter: use macros to create module aliases.
Date:   Sat, 13 Apr 2019 20:17:09 -0300
Message-Id: <20190413231716.28711-2-fbl@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413231716.28711-1-fbl@redhat.com>
References: <20190413231716.28711-1-fbl@redhat.com>
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

V2
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

