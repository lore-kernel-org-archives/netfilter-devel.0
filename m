Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A20C10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F44520870
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfDMXRm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 19:17:42 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41475 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727255AbfDMXRm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 19:17:42 -0400
Received: by mail-qk1-f196.google.com with SMTP id o129so7815292qke.8
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 16:17:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=htlvsUl58UfZNWzgkPeIauIOJmmQeGQkqXTt/EdnjjE=;
        b=RNl+rjpmskoSTSImLBR5iunRyCd7bR4PhbKswho8rT3qciY8HtdKAb18xGdycH2Ooc
         wqfsecTyRkTyRnuf6wY7V/acDpN/rObrNsRFSGS7BlDJ7KThCwiMDNszUHlOU7vO3mKA
         tPZ9TZug/TfPlEvdiYQlwGZlGp7qxL7ENEsqw42i0aLNrL4EI9a05dEKT2Z4ZiLZ1Lna
         4IuwEGP8YF6HA1ojyr2M1v/z6CUWD9H5szhD2hGqGALOUy/tYZw/jd6Pqoe66e6sODRl
         DrES4A6G9y3Yjm89qQVXrmoPqc2hxqiL5fJN/shqn1gK86wOEwaGFwNAuwNN8txJjxTa
         DVPw==
X-Gm-Message-State: APjAAAXL0td3OeHqnnocUaLPp6/lOzs370aGNmWsTA2qqC1EurTL6ETD
        RxOpbBlqF2am0QgHNU5ageUfcA==
X-Google-Smtp-Source: APXvYqzpAXr0KeTyldyKJC+0VaDhf8Jh/Cpe3Vxg9V5njSlEgIl0CE3ir/LWLRCbrHEJfJOGpUelAw==
X-Received: by 2002:a05:620a:11:: with SMTP id j17mr51585630qki.111.1555197461178;
        Sat, 13 Apr 2019 16:17:41 -0700 (PDT)
Received: from localhost ([177.183.215.126])
        by smtp.gmail.com with ESMTPSA id m41sm29828364qtb.58.2019.04.13.16.17.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 13 Apr 2019 16:17:40 -0700 (PDT)
From:   Flavio Leitner <fbl@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next v2 5/8] netfilter: nf_nat: register irc NAT helper.
Date:   Sat, 13 Apr 2019 20:17:13 -0300
Message-Id: <20190413231716.28711-6-fbl@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190413231716.28711-1-fbl@redhat.com>
References: <20190413231716.28711-1-fbl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Flavio Leitner <fbl@redhat.com>
---
 net/netfilter/nf_nat_irc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

V2
  - defined NAT_HELPER_NAME for consistency.
  - C99 static change.
  - renamed the variables to be nat_helper.*

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
-- 
2.20.1

