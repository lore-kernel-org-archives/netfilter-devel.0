Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A248C10F14
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 214A420870
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfDMXRq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 19:17:46 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34913 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbfDMXRo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 19:17:44 -0400
Received: by mail-qt1-f194.google.com with SMTP id h39so15373795qte.2
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 16:17:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cVVlrMtEq71l+ytxp0UxxU7cwoyJxf2POBEVZ+nsxP8=;
        b=DBdZF5+rdK3Sn1M2ehS4dX5IoeJm7Y4+7vJ3sS+t0SK5suf139ofdF+VD/pTnzeiUl
         GDjriPEfaA813Tg+NXyHXzA1Xfw8h5nxpKAikdFSn3esTM+X0ISMPcnvFDblyygFWaYu
         pK/gZ0gwID+5+zcvWatZwEpw+54Qt5ugDQX1P32mqnzJ/hHrcjNzh93BJBCAn45VMKao
         jcPsMfR2yEgOmEfeWTk1D6pwFfuXBc5Nv3cd8TZ3EzVr4gVR8wGYJjT2idNqy7hKGT1c
         l9e6L6lq8I70jAMdrW/fE+FUXDiNAz3hZp51/46cXsI1u8P7ysa4nHsCoZTLIN2NeaUU
         U54Q==
X-Gm-Message-State: APjAAAU560L076iDbJ4cUEsDt1mbBxw7BggtI9ZwBDEWLws5E+j2UWL/
        mYXWMBtWfM/FjmAG0Rg1o2MBcQ==
X-Google-Smtp-Source: APXvYqzLe2nPXb4RKFmDL1OYBPtGAFyJUKSnoFo/QXjG4ZG0ZqzD5oeODicQkLoo5aHUmcsAfretJg==
X-Received: by 2002:ac8:538c:: with SMTP id x12mr51650438qtp.238.1555197464062;
        Sat, 13 Apr 2019 16:17:44 -0700 (PDT)
Received: from localhost ([177.183.215.126])
        by smtp.gmail.com with ESMTPSA id h187sm26689398qkf.97.2019.04.13.16.17.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 13 Apr 2019 16:17:43 -0700 (PDT)
From:   Flavio Leitner <fbl@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Joe Stringer <joe@ovn.org>, Pravin B Shelar <pshelar@ovn.org>,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next v2 6/8] netfilter: nf_nat: register sip NAT helper.
Date:   Sat, 13 Apr 2019 20:17:14 -0300
Message-Id: <20190413231716.28711-7-fbl@redhat.com>
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
 net/netfilter/nf_nat_sip.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

V2
  - defined NAT_HELPER_NAME for consistency.
  - C99 static change.
  - renamed the variables to be nat_helper.*

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
-- 
2.20.1

