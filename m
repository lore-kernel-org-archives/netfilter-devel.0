Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B50CDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 16:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbjJSQlm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjJSQll (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 12:41:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57C311F
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 09:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vL0a8hG2Ow4aIgJzeO/61peFLwtlJp4oBqCGfaiE73s=; b=Q4eKG890liXid4LtmKpfdmSMNj
        bfV7+SQehNmUs68YUwBM49ZpygSZzkMUyLnb8FNrju22/enBcdoCpPEGLPC2DH2KtxqL9BgRX9Rcr
        w3wceOGnO/PMiMQQ1WkWiPgkuTCeercUOVN+mvgNk9umSTKlNdyn6kllEiR7G0eDAWvHIK/pdlsBq
        wHBmui6U21JymIBDqCBPYtll0aWEm5Z7P1RiSZDbO2noC5WAmV0ViErFt4pr8VFXkcRKo8L8huGLr
        wsT66Gn6yx+zmnQrwB8ien0hwRU+XuxVcl/yoq/KwW6aYiCfZ5PgwzH0yyi3+XFBi1UMeu6fDeaJ9
        VjdO90bw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qtW5a-0004YI-7N; Thu, 19 Oct 2023 18:41:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2] parser_bison: Fix for broken compatibility with older dumps
Date:   Thu, 19 Oct 2023 18:41:34 +0200
Message-ID: <20231019164134.23478-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit e6d1d0d611958 ("src: add set element multi-statement
support") changed the order of expressions and other state attached to set
elements are expected in input. This broke parsing of ruleset dumps
created by nft commands prior to that commit.

Restore compatibility by also accepting the old ordering.

Fixes: e6d1d0d611958 ("src: add set element multi-statement support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Fix author email address to match SoB.
---
 src/parser_bison.y                            |  6 ++++
 tests/shell/testcases/sets/elem_opts_compat_0 | 29 +++++++++++++++++++
 2 files changed, 35 insertions(+)
 create mode 100755 tests/shell/testcases/sets/elem_opts_compat_0

diff --git a/src/parser_bison.y b/src/parser_bison.y
index c517dc38b37d6..f0652ba651c68 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4523,6 +4523,12 @@ meter_key_expr_alloc	:	concat_expr
 
 set_elem_expr		:	set_elem_expr_alloc
 			|	set_elem_expr_alloc		set_elem_expr_options
+			|	set_elem_expr_alloc		set_elem_expr_options	set_elem_stmt_list
+			{
+				$$ = $1;
+				list_splice_tail($3, &$$->stmt_list);
+				xfree($3);
+			}
 			;
 
 set_elem_key_expr	:	set_lhs_expr		{ $$ = $1; }
diff --git a/tests/shell/testcases/sets/elem_opts_compat_0 b/tests/shell/testcases/sets/elem_opts_compat_0
new file mode 100755
index 0000000000000..e0129536fcb7a
--- /dev/null
+++ b/tests/shell/testcases/sets/elem_opts_compat_0
@@ -0,0 +1,29 @@
+#!/bin/sh
+
+# ordering of element options and expressions has changed, make sure parser
+# accepts both ways
+
+set -e
+
+$NFT -f - <<EOF
+table t {
+	set s {
+		type inet_service
+		counter;
+		timeout 30s;
+	}
+}
+EOF
+
+check() {
+	out=$($NFT list ruleset)
+	secs=$(sed -n 's/.*expires \([0-9]\+\)s.*/\1/p' <<< "$out")
+	[[ $secs -lt 11 ]]
+	grep -q 'counter packets 10 bytes 20' <<< "$out"
+}
+
+$NFT add element t s '{ 23 counter packets 10 bytes 20 expires 10s }'
+check
+$NFT flush set t s
+$NFT add element t s '{ 42 expires 10s counter packets 10 bytes 20 }'
+check
-- 
2.41.0

