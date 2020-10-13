Return-Path: <SRS0=fGlf=DU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2FDC433E7
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 11:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D94B214D8
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 11:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgJMLjF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Oct 2020 07:39:05 -0400
Received: from correo.us.es ([193.147.175.20]:33186 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbgJMLjF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 07:39:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3899F20A527
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2020 13:39:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A37CDA72F
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2020 13:39:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1FC08DA704; Tue, 13 Oct 2020 13:39:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA7D2DA73F
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2020 13:39:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Oct 2020 13:39:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id D717342EFB8E
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2020 13:39:01 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: ingress inet support
Date:   Tue, 13 Oct 2020 13:38:57 +0200
Message-Id: <20201013113857.12117-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for inet ingress chains.

 table inet filter {
        chain ingress {
                type filter hook ingress device "veth0" priority filter; policy accept;
        }
	chain input {
		type filter hook input priority filter; policy accept;
	}
	chain forward {
		type filter hook forward priority filter; policy accept;
	}
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h                      |  1 +
 src/evaluate.c                                 |  8 ++++++--
 src/rule.c                                     |  2 ++
 .../shell/testcases/chains/0043chain_ingress_0 | 18 ++++++++++++++++++
 .../chains/dumps/0043chain_ingress.nft         | 11 +++++++++++
 5 files changed, 38 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/chains/0043chain_ingress_0
 create mode 100644 tests/shell/testcases/chains/dumps/0043chain_ingress.nft

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 18075f958c8d..feb6287c5979 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -48,6 +48,7 @@ enum nf_inet_hooks {
 	NF_INET_FORWARD,
 	NF_INET_LOCAL_OUT,
 	NF_INET_POST_ROUTING,
+	NF_INET_INGRESS,
 	NF_INET_NUMHOOKS
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 5f17d7501ac0..abbf83aef576 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3965,10 +3965,12 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 		return NF_INET_NUMHOOKS;
 
 	switch (family) {
+	case NFPROTO_INET:
+		if (!strcmp(hook, "ingress"))
+			return NF_INET_INGRESS;
 	case NFPROTO_IPV4:
 	case NFPROTO_BRIDGE:
 	case NFPROTO_IPV6:
-	case NFPROTO_INET:
 		/* These families have overlapping values for each hook */
 		if (!strcmp(hook, "prerouting"))
 			return NF_INET_PRE_ROUTING;
@@ -4042,7 +4044,9 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 						   expr_name(chain->policy));
 		}
 
-		if (chain->handle.family == NFPROTO_NETDEV) {
+		if (chain->handle.family == NFPROTO_NETDEV ||
+		    (chain->handle.family == NFPROTO_INET &&
+		     chain->hook.num == NF_INET_INGRESS)) {
 			if (!chain->dev_expr)
 				return __stmt_binary_error(ctx, &chain->loc, NULL,
 							   "Missing `device' in this chain definition");
diff --git a/src/rule.c b/src/rule.c
index d75b36c4eb0d..4719fd6158f2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1019,6 +1019,8 @@ const char *hooknum2str(unsigned int family, unsigned int hooknum)
 			return "postrouting";
 		case NF_INET_LOCAL_OUT:
 			return "output";
+		case NF_INET_INGRESS:
+			return "ingress";
 		default:
 			break;
 		};
diff --git a/tests/shell/testcases/chains/0043chain_ingress_0 b/tests/shell/testcases/chains/0043chain_ingress_0
new file mode 100755
index 000000000000..79cd5208f2dc
--- /dev/null
+++ b/tests/shell/testcases/chains/0043chain_ingress_0
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table inet filter {
+	chain ingress {
+		type filter hook ingress device \"lo\" priority filter; policy accept;
+	}
+	chain input {
+		type filter hook input priority filter; policy accept;
+	}
+	chain forward {
+		type filter hook forward priority filter; policy accept;
+	}
+}"
+
+$NFT -f - <<< "$RULESET" && exit 1
+exit 0
diff --git a/tests/shell/testcases/chains/dumps/0043chain_ingress.nft b/tests/shell/testcases/chains/dumps/0043chain_ingress.nft
new file mode 100644
index 000000000000..74670423fc84
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0043chain_ingress.nft
@@ -0,0 +1,11 @@
+table inet filter {
+	chain ingress {
+		type filter hook ingress device \"lo\" priority filter; policy accept;
+	}
+	chain input {
+		type filter hook input priority filter; policy accept;
+	}
+	chain forward {
+		type filter hook forward priority filter; policy accept;
+	}
+}
-- 
2.20.1

