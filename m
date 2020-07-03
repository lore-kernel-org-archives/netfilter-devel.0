Return-Path: <SRS0=cAfZ=AO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0354CC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 12:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD8E920782
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 12:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgGCMpN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 08:45:13 -0400
Received: from correo.us.es ([193.147.175.20]:47318 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbgGCMpN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 08:45:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2C6B2118442
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2020 14:45:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C5EADA722
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2020 14:45:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 11A9DDA792; Fri,  3 Jul 2020 14:45:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A433CDA722
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2020 14:45:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 03 Jul 2020 14:45:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 90EFD42EF4E2
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2020 14:45:08 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: Allow for empty set variable definition
Date:   Fri,  3 Jul 2020 14:45:05 +0200
Message-Id: <20200703124505.26729-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow for empty set definition in variables if they are merged to
non-empty set definition:

 define BASE_ALLOWED_INCOMING_TCP_PORTS = {22, 80, 443}
 define EXTRA_ALLOWED_INCOMING_TCP_PORTS = {}

 table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        tcp dport {$BASE_ALLOWED_INCOMING_TCP_PORTS, $EXTRA_ALLOWED_INCOMING_TCP_PORTS} ct state new counter accept
    }
 }

However, disallow this:

 define EXTRA_ALLOWED_INCOMING_TCP_PORTS = {}

 table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        tcp dport {$EXTRA_ALLOWED_INCOMING_TCP_PORTS} ct state new counter accept
    }
 }

 # nft -f x.nft
 /tmp/x.nft:6:18-52: Error: Set is empty
        tcp dport {$EXTRA_ALLOWED_INCOMING_TCP_PORTS} ct state new counter accept
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c                                  |  3 +++
 src/parser_bison.y                              |  1 +
 tests/shell/testcases/sets/0049set_define_0     | 16 ++++++++++++++++
 tests/shell/testcases/sets/0050set_define_1     | 17 +++++++++++++++++
 .../shell/testcases/sets/dumps/0049set_define_0 |  6 ++++++
 5 files changed, 43 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0049set_define_0
 create mode 100755 tests/shell/testcases/sets/0050set_define_1
 create mode 100644 tests/shell/testcases/sets/dumps/0049set_define_0

diff --git a/src/evaluate.c b/src/evaluate.c
index 827ee48a48ed..2bfe55524fac 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1897,6 +1897,9 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 				return -1;
 			break;
 		case EXPR_SET:
+			if (right->size == 0)
+				return expr_error(ctx->msgs, right, "Set is empty");
+
 			right = rel->right =
 				implicit_set_declaration(ctx, "__set%d",
 							 expr_get(left), NULL,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 8a04d3b409a5..1676aa33e431 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3845,6 +3845,7 @@ set_rhs_expr		:	concat_rhs_expr
 
 initializer_expr	:	rhs_expr
 			|	list_rhs_expr
+			|	'{' '}'		{ $$ = compound_expr_alloc(&@$, EXPR_SET); }
 			;
 
 counter_config		:	PACKETS		NUM	BYTES	NUM
diff --git a/tests/shell/testcases/sets/0049set_define_0 b/tests/shell/testcases/sets/0049set_define_0
new file mode 100755
index 000000000000..1d512f7b5a54
--- /dev/null
+++ b/tests/shell/testcases/sets/0049set_define_0
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="define BASE_ALLOWED_INCOMING_TCP_PORTS = {22, 80, 443}
+define EXTRA_ALLOWED_INCOMING_TCP_PORTS = {}
+
+table inet filter {
+	chain input {
+		type filter hook input priority 0; policy drop;
+		tcp dport {\$BASE_ALLOWED_INCOMING_TCP_PORTS, \$EXTRA_ALLOWED_INCOMING_TCP_PORTS} ct state new counter accept
+	}
+}
+"
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/sets/0050set_define_1 b/tests/shell/testcases/sets/0050set_define_1
new file mode 100755
index 000000000000..c12de177c7ec
--- /dev/null
+++ b/tests/shell/testcases/sets/0050set_define_1
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+set -e
+
+EXPECTED="define BASE_ALLOWED_INCOMING_TCP_PORTS = {}
+
+table inet filter {
+	chain input {
+		type filter hook input priority 0; policy drop;
+		tcp dport {\$BASE_ALLOWED_INCOMING_TCP_PORTS} ct state new counter accept
+	}
+}
+"
+
+$NFT -f - <<< "$EXPECTED" &> /dev/null || exit 0
+echo "E: Accepted empty set" 1>&2
+exit 1
diff --git a/tests/shell/testcases/sets/dumps/0049set_define_0 b/tests/shell/testcases/sets/dumps/0049set_define_0
new file mode 100644
index 000000000000..998b387a8151
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0049set_define_0
@@ -0,0 +1,6 @@
+table inet filter {
+	chain input {
+		type filter hook input priority filter; policy drop;
+		tcp dport { 22, 80, 443 } ct state new counter packets 0 bytes 0 accept
+	}
+}
-- 
2.20.1

