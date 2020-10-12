Return-Path: <SRS0=LXG+=DT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE9EC2D0A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 01:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15D9C2078E
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 01:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbgJLBig (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Oct 2020 21:38:36 -0400
Received: from correo.us.es ([193.147.175.20]:41714 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbgJLBic (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Oct 2020 21:38:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 39939E781D
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 03:38:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B5E1DA722
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 03:38:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 202A1DA78D; Mon, 12 Oct 2020 03:38:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E080DA722;
        Mon, 12 Oct 2020 03:38:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Oct 2020 03:38:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 028F241FF201;
        Mon, 12 Oct 2020 03:38:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 3/6] netfilter: add nf_ingress_hook() helper function
Date:   Mon, 12 Oct 2020 03:38:16 +0200
Message-Id: <20201012013819.23128-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201012013819.23128-1-pablo@netfilter.org>
References: <20201012013819.23128-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add helper function to check if this is an ingress hook.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index b9ec8ecf7e30..c82f779a587e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -311,6 +311,11 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
 	return NULL;
 }
 
+static inline bool nf_ingress_hook(const struct nf_hook_ops *reg, int pf)
+{
+	return pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS;
+}
+
 static void nf_static_key_inc(const struct nf_hook_ops *reg, int pf)
 {
 #ifdef CONFIG_JUMP_LABEL
@@ -359,7 +364,7 @@ static int __nf_register_net_hook(struct net *net, int pf,
 
 	hooks_validate(new_hooks);
 #ifdef CONFIG_NETFILTER_INGRESS
-	if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
+	if (nf_ingress_hook(reg, pf))
 		net_inc_ingress_queue();
 #endif
 	nf_static_key_inc(reg, pf);
@@ -416,7 +421,7 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 
 	if (nf_remove_net_hook(p, reg)) {
 #ifdef CONFIG_NETFILTER_INGRESS
-		if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
+		if (nf_ingress_hook(reg, pf))
 			net_dec_ingress_queue();
 #endif
 		nf_static_key_dec(reg, pf);
-- 
2.20.1

