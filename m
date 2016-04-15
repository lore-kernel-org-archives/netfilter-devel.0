From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH libnftnl] tests: nat-test: Use different values to test
Date: Fri, 15 Apr 2016 13:42:57 +0530
Message-ID: <20160415081257.GA3489@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36265 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbcDOINe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Apr 2016 04:13:34 -0400
Received: by mail-pf0-f196.google.com with SMTP id p185so5052209pfb.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 01:13:34 -0700 (PDT)
Received: from shivani ([116.202.36.8])
        by smtp.gmail.com with ESMTPSA id o65sm2552318pfb.24.2016.04.15.01.13.32
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 15 Apr 2016 01:13:33 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tests are more effective if different values are set so, use different
values for every expression.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 tests/nft-expr_nat-test.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
index 50b115c..fd3a488 100644
--- a/tests/nft-expr_nat-test.c
+++ b/tests/nft-expr_nat-test.c
@@ -72,12 +72,12 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_TYPE, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_FAMILY, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_ADDR_MIN, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_ADDR_MAX, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_PROTO_MIN, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_PROTO_MAX, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_FLAGS, 0x1234568);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_FAMILY, 0x3456721);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_ADDR_MIN, 0x1452638);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_ADDR_MAX, 0x5134682);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_PROTO_MIN, 0x6124385);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_PROTO_MAX, 0x2153846);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_FLAGS, 0x4213683);
 
 	nftnl_rule_add_expr(a, ex);
 
-- 
1.9.1

