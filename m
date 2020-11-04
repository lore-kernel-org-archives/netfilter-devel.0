Return-Path: <SRS0=dzjG=EK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3D8C2D0A3
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Nov 2020 14:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 242A621734
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Nov 2020 14:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgKDOMJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Nov 2020 09:12:09 -0500
Received: from correo.us.es ([193.147.175.20]:35816 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730052AbgKDOMF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Nov 2020 09:12:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 57432B60F5
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 15:12:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48107DA793
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 15:12:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3D57BDA78D; Wed,  4 Nov 2020 15:12:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C37F3DA78E;
        Wed,  4 Nov 2020 15:12:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Nov 2020 15:12:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 81BC042EF9E0;
        Wed,  4 Nov 2020 15:12:00 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 7/8] netfilter: nftables: Add __printf() attribute
Date:   Wed,  4 Nov 2020 15:11:48 +0100
Message-Id: <20201104141149.30082-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201104141149.30082-1-pablo@netfilter.org>
References: <20201104141149.30082-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

nft_request_module calls vsnprintf() using parameters passed to it.
Make the function with __printf() attribute so the compiler can check
the format and arguments.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 65cb8e3c13d9..522a9d28754b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -581,7 +581,8 @@ struct nft_module_request {
 };
 
 #ifdef CONFIG_MODULES
-static int nft_request_module(struct net *net, const char *fmt, ...)
+static __printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
+					     ...)
 {
 	char module_name[MODULE_NAME_LEN];
 	struct nft_module_request *req;
-- 
2.20.1

