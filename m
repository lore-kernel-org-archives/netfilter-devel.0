Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED78C64ED6
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Mar 2023 10:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjCAKdH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Mar 2023 05:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCAKdG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2023 05:33:06 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E71D1A5F5
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2023 02:33:04 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: allow to use quota in sets
Date:   Wed,  1 Mar 2023 11:32:58 +0100
Message-Id: <20230301103258.11442-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

src: support for restoring element quota

This patch allows you to restore quota in dynamic sets.

 table ip x {
        set y {
                type ipv4_addr
                size 65535
                flags dynamic,timeout
                counter quota 500 bytes
                timeout 1h
                elements = { 8.8.8.8 counter packets 9 bytes 756 quota 500 bytes used 500 bytes timeout 1h expires 56m57s47ms }
        }

        chain z {
                type filter hook output priority filter; policy accept;
                update @y { ip daddr } counter packets 6 bytes 507
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y                            | 16 ++++++++
 .../shell/testcases/sets/0060set_multistmt_1  | 38 +++++++++++++++++++
 .../sets/dumps/0060set_multistmt_1.nft        | 15 ++++++++
 3 files changed, 69 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0060set_multistmt_1
 create mode 100644 tests/shell/testcases/sets/dumps/0060set_multistmt_1.nft

diff --git a/src/parser_bison.y b/src/parser_bison.y
index b950afce46ec..b1b67623cf66 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4552,6 +4552,22 @@ set_elem_stmt		:	COUNTER	close_scope_counter
 				$$->connlimit.count = $4;
 				$$->connlimit.flags = NFT_CONNLIMIT_F_INV;
 			}
+			|	QUOTA	quota_mode NUM quota_unit quota_used	close_scope_quota
+			{
+				struct error_record *erec;
+				uint64_t rate;
+
+				erec = data_unit_parse(&@$, $4, &rate);
+				xfree($4);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+				$$ = quota_stmt_alloc(&@$);
+				$$->quota.bytes	= $3 * rate;
+				$$->quota.used = $5;
+				$$->quota.flags	= $2;
+			}
 			|	LAST USED	NEVER	close_scope_last
 			{
 				$$ = last_stmt_alloc(&@$);
diff --git a/tests/shell/testcases/sets/0060set_multistmt_1 b/tests/shell/testcases/sets/0060set_multistmt_1
new file mode 100755
index 000000000000..1652668a2fec
--- /dev/null
+++ b/tests/shell/testcases/sets/0060set_multistmt_1
@@ -0,0 +1,38 @@
+#!/bin/bash
+
+RULESET="table x {
+	set y {
+		type ipv4_addr
+		size 65535
+		flags dynamic
+		counter quota 500 bytes
+		elements = { 1.2.3.4 counter packets 9 bytes 756 quota 500 bytes used 500 bytes }
+	}
+	chain y {
+		type filter hook output priority filter; policy accept;
+		update @y { ip daddr }
+	}
+}"
+
+$NFT -f - <<< $RULESET
+# should work
+if [ $? -ne 0 ]
+then
+	exit 1
+fi
+
+# should work
+$NFT add element x y { 1.1.1.1 }
+if [ $? -ne 0 ]
+then
+	exit 1
+fi
+
+# should work
+$NFT add element x y { 2.2.2.2 counter quota 1000 bytes }
+if [ $? -ne 0 ]
+then
+	exit 1
+fi
+
+exit 0
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.nft
new file mode 100644
index 000000000000..ac1bd26b3e58
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.nft
@@ -0,0 +1,15 @@
+table ip x {
+	set y {
+		type ipv4_addr
+		size 65535
+		flags dynamic
+		counter quota 500 bytes
+		elements = { 1.1.1.1 counter packets 0 bytes 0 quota 500 bytes, 1.2.3.4 counter packets 9 bytes 756 quota 500 bytes used 500 bytes,
+			     2.2.2.2 counter packets 0 bytes 0 quota 1000 bytes }
+	}
+
+	chain y {
+		type filter hook output priority filter; policy accept;
+		update @y { ip daddr }
+	}
+}
-- 
2.30.2

