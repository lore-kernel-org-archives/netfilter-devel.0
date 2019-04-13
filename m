Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBA7C10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6F2020870
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfDMXRg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 19:17:36 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39131 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727167AbfDMXRg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 19:17:36 -0400
Received: by mail-qt1-f196.google.com with SMTP id t28so15344936qte.6
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 16:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7mA+5BJOLfNmgJPuQEwHEEHp7pw0wpbgIJ+UzEsTweU=;
        b=RhclJH8MSpwhdl7gXFdbhGrz7Seb/H+hvQRLFIFVbggpZHne/tp44nzw54PLHl3ZVn
         QIDhyJLtQ3AmcklPUZ7WOxEbZM8o3DJZKq8FbmuhEB9NI0/HAxmepy4O5zo+p5lRigUA
         UmVDiilFCJ9oWTC/BEaQMS2pR8DlaYRHXYzvel1f58aKtSMHENFhVg8BfcQvd+SZXMdY
         lIAh/vaV7tUelZPPNOCrH0JKAP/WGQ6fZpf5PGp9S2Ie8UdYHrxZ2dpjvYf3tthJ40iO
         bHzOTm/p158U4ezBRAFVE9Zdp9Nio/X/2WcowG2JplxmhHi6M9sQnYP0x1ncF07wIbhc
         fOYw==
X-Gm-Message-State: APjAAAXur60F5SN5oaE0FFOVXUoWWm3mHTivWiHg5WUM4ixobc936pP3
        JPVFhoKhAB3ARKuelC4zswPEiA==
X-Google-Smtp-Source: APXvYqxdfu0OvVSLrHNqD1DMxJgybXeoDOhd6PNzk3cJKnMHI8aecE7RKiZwD3rvPSTTyfv2rAvg3Q==
X-Received: by 2002:ac8:17f4:: with SMTP id r49mr51660017qtk.213.1555197455240;
        Sat, 13 Apr 2019 16:17:35 -0700 (PDT)
Received: from localhost ([177.183.215.126])
        by smtp.gmail.com with ESMTPSA id h29sm29246259qtk.32.2019.04.13.16.17.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 13 Apr 2019 16:17:34 -0700 (PDT)
From:   Flavio Leitner <fbl@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next v2 3/8] netfilter: nf_nat: register amanda NAT helper.
Date:   Sat, 13 Apr 2019 20:17:11 -0300
Message-Id: <20190413231716.28711-4-fbl@redhat.com>
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
 net/netfilter/nf_nat_amanda.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

V2
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
-- 
2.20.1

