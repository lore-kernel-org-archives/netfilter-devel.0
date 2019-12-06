Return-Path: <SRS0=ut36=Z4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72DA6C43603
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 21:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CA04217BA
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Dec 2019 21:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfLFVuF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Dec 2019 16:50:05 -0500
Received: from correo.us.es ([193.147.175.20]:50342 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbfLFVuF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Dec 2019 16:50:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B274D1C0222
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2019 22:50:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A657CDA707
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2019 22:50:02 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9C099DA705; Fri,  6 Dec 2019 22:50:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 920CFDA707
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2019 22:50:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 06 Dec 2019 22:50:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7011442EE38E
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2019 22:50:00 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables_offload: return EOPNOTSUPP if rule specifies no actions
Date:   Fri,  6 Dec 2019 22:49:58 +0100
Message-Id: <20191206214958.28399-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the rule only specifies the matching side, return EOPNOTSUPP.
Otherwise, the front-end relies on the drivers to reject this rule.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index d7a35da008ef..22fb18906ccf 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -44,6 +44,9 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 		expr = nft_expr_next(expr);
 	}
 
+	if (num_actions == 0)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	flow = nft_flow_rule_alloc(num_actions);
 	if (!flow)
 		return ERR_PTR(-ENOMEM);
-- 
2.11.0

