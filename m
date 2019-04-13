Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF3CC10F14
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD1A720870
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfDMXRs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 19:17:48 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37566 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbfDMXRr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 19:17:47 -0400
Received: by mail-qt1-f196.google.com with SMTP id z16so15365794qtn.4
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 16:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=irbwC3lTivW5B2mREALIDAkZHTP4aRfG1KgtR00sTg4=;
        b=TdGVzxcnmWXfHR7YJnfCU1PgZjQzjfHc37yYjnrema0tnrVS/fDzqDWbF2WD1I+SD2
         6zPnr4rq96gtvVaguIr+pflXuKbO0Ql2n4hw5OEmpRipod7/1HggYm/hPqXD5wKNyh1P
         WH+U/1ML7BH4VpPGQ8gtdZVDm4gtp7HD8nhzSeSAouiAUaVK1fd2gQMoe0CX3SP1cG3k
         vEFvfygQpODZlDsBqVU1lg9AT7bOgQxcL6NR3b4r+htMA60/VSyz9jHbcwAyUGcJ/AIo
         Tca3ot1qAdN3reUrPRGk3Zm5bkHiQLR4yXof6kSvdPb850Y0rDkPUykjyh3S6/K+mR/D
         dPEg==
X-Gm-Message-State: APjAAAULjT6l6iw1I+DgfUraSHdoKhkAus5OLU3N5vZIO7AgbhTHjE4B
        T7XSE+HjvdnUhncl+L9lQ1qU0lDjiVA=
X-Google-Smtp-Source: APXvYqy1kiGUq86FAxFGq5uoclmikTJxuueQowyM/sNyrbt7jUWwgpJI8HLUXv+fvZHUWfzmUtuvcw==
X-Received: by 2002:ac8:26e7:: with SMTP id 36mr54189752qtp.37.1555197466951;
        Sat, 13 Apr 2019 16:17:46 -0700 (PDT)
Received: from localhost ([177.183.215.126])
        by smtp.gmail.com with ESMTPSA id d34sm32905749qta.18.2019.04.13.16.17.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 13 Apr 2019 16:17:46 -0700 (PDT)
From:   Flavio Leitner <fbl@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next v2 7/8] netfilter: nf_nat: register tftp NAT helper.
Date:   Sat, 13 Apr 2019 20:17:15 -0300
Message-Id: <20190413231716.28711-8-fbl@redhat.com>
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
 net/netfilter/nf_nat_tftp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

V2
  - defined NAT_HELPER_NAME for consistency.
  - C99 static change.
  - renamed the variables to be nat_helper.*

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

