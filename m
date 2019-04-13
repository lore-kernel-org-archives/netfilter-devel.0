Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309E4C10F14
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 071E420870
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfDMXRk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 19:17:40 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46127 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbfDMXRj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 19:17:39 -0400
Received: by mail-qk1-f194.google.com with SMTP id s81so7820125qke.13
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 16:17:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4YqoQA1UkymIHs2QggQQy8mZKppILjPtX7G37rkzWK4=;
        b=O76klyOVyH3y5nvGCTEEJ3hm/nngdD6aNNXg4Y6z7J4AGvX2sITdlAZg6Xvqslqk3j
         O5j/sAen+wX8KAe2kC7Fb77EtH6Ew7gKBc1ZMz6h0MltoWu+uGJUTZbZfsq4vc1CRpYX
         GcGZbCFhoqkgXBswSIh2z9HgO7sPIhweV/LDKfcmUwjuQ7kgXyn+RoiVZZcni/KdzBwv
         iXerLB07P76AgwQ3ncSquLAYi1ePoFGrZpAK3tr9CVyjRyMmv+qsRlPOh2oB0gEZ0oeD
         6kcR9cppMhbQW5M/FFBL3Nk6qvj6YP6rdfUDr3m6yySIGgyCLevLk8XB2jf6Tw/5Z7d4
         atbg==
X-Gm-Message-State: APjAAAX0OfVdSNoAV0QQ8gO1L0vNWpzkP1U8Y9K5+cJE+mUoAca1xQ04
        U9OzXgaz2Bp3waVBq57Z3LfQzA==
X-Google-Smtp-Source: APXvYqxCUVTjj3MyqQQ+CsbrfurrUr5+cM+YgM2LfjgSV4sjewVmd4GgES1y5rxSz3tqpd5c7GzKAA==
X-Received: by 2002:a05:620a:1646:: with SMTP id c6mr52799759qko.69.1555197458214;
        Sat, 13 Apr 2019 16:17:38 -0700 (PDT)
Received: from localhost ([177.183.215.126])
        by smtp.gmail.com with ESMTPSA id t69sm25084650qke.38.2019.04.13.16.17.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 13 Apr 2019 16:17:37 -0700 (PDT)
From:   Flavio Leitner <fbl@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next v2 4/8] netfilter: nf_nat: register ftp NAT helper.
Date:   Sat, 13 Apr 2019 20:17:12 -0300
Message-Id: <20190413231716.28711-5-fbl@redhat.com>
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
 net/netfilter/nf_nat_ftp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

V2
  - defined NAT_HELPER_NAME for consistency.
  - C99 static change.
  - renamed the variables to be nat_helper.*

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
-- 
2.20.1

