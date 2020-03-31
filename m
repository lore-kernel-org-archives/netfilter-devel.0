Return-Path: <SRS0=TvDw=5Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6001BC2D0F0
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 12:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4151120848
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 12:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgCaMqB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Mar 2020 08:46:01 -0400
Received: from correo.us.es ([193.147.175.20]:41222 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730469AbgCaMqA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 08:46:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 33D364FFE09
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 14:45:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26AEF12395A
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 14:45:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1C639DA736; Tue, 31 Mar 2020 14:45:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 479E5123958
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 14:45:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 31 Mar 2020 14:45:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3299B4301DE0
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 14:45:57 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] evaluate: improve error reporting in netdev ingress chain
Date:   Tue, 31 Mar 2020 14:45:51 +0200
Message-Id: <20200331124551.403893-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200331124551.403893-1-pablo@netfilter.org>
References: <20200331124551.403893-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft -f /tmp/x.nft
 /tmp/x.nft:3:20-24: Error: The netdev family does not support this hook
                 type filter hook input device eth0 priority 0
                                  ^^^^^

 # nft -f /tmp/x.nft
 /tmp/x.nft:3:3-49: Error: Missing `device' in this chain definition
                 type filter hook ingress device eth0 priority 0
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 759cdaafb0ea..84fe89eed657 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3786,8 +3786,9 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 		chain->hook.num = str2hooknum(chain->handle.family,
 					      chain->hook.name);
 		if (chain->hook.num == NF_INET_NUMHOOKS)
-			return chain_error(ctx, chain, "invalid hook %s",
-					   chain->hook.name);
+			return __stmt_binary_error(ctx, &chain->hook.loc, NULL,
+						   "The %s family does not support this hook",
+						   family2str(chain->handle.family));
 
 		if (!evaluate_priority(ctx, &chain->priority,
 				       chain->handle.family, chain->hook.num))
@@ -3799,6 +3800,12 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 				return chain_error(ctx, chain, "invalid policy expression %s",
 						   expr_name(chain->policy));
 		}
+
+		if (chain->handle.family == NFPROTO_NETDEV) {
+			if (!chain->dev_expr)
+				return __stmt_binary_error(ctx, &chain->loc, NULL,
+							   "Missing `device' in this chain definition");
+		}
 	}
 
 	list_for_each_entry(rule, &chain->rules, list) {
-- 
2.11.0

