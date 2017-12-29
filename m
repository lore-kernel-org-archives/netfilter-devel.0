From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH libnftnl] tests: change char * pointer to constant (const char *)
Date: Fri, 29 Dec 2017 12:19:39 +0530
Message-ID: <20171229064939.30699-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:44158 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbdL2GuF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Dec 2017 01:50:05 -0500
Received: by mail-pg0-f67.google.com with SMTP id i5so4728697pgq.11
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Dec 2017 22:50:04 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As the parameter for function is pointer to constant, change it to
constant. This fix compilation warning in libnftnl with make check.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 tests/nft-expr_immediate-test.c | 4 ++--
 tests/nft-expr_lookup-test.c    | 2 +-
 tests/nft-expr_objref-test.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/nft-expr_immediate-test.c b/tests/nft-expr_immediate-test.c
index 60a1450..c25eedb 100644
--- a/tests/nft-expr_immediate-test.c
+++ b/tests/nft-expr_immediate-test.c
@@ -71,8 +71,8 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
-	char *chain = "tests_chain01234";
-	char *data = "test_data_01234";
+	const char *chain = "tests_chain01234";
+	const char *data = "test_data_01234";
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.c
index 28c1204..9e6e051 100644
--- a/tests/nft-expr_lookup-test.c
+++ b/tests/nft-expr_lookup-test.c
@@ -59,7 +59,7 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
-	char *lookup_set = "test_set_01243";
+	const char *lookup_set = "test_set_01243";
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
diff --git a/tests/nft-expr_objref-test.c b/tests/nft-expr_objref-test.c
index ae4da9a..08e27ce 100644
--- a/tests/nft-expr_objref-test.c
+++ b/tests/nft-expr_objref-test.c
@@ -46,7 +46,7 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
-	char *name = "test_set_01243";
+	const char *name = "test_set_01243";
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-- 
2.11.0

