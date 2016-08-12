From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/4, V2, libnftnl] tests: Fix segfaults due outbound access
Date: Fri, 12 Aug 2016 22:17:19 +0200
Message-ID: <20160812201722.10134-1-carlosfg@riseup.net>
References: <20160811233222.GB5108@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:50265 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbcHLURv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 16:17:51 -0400
In-Reply-To: <20160811233222.GB5108@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changes random values for macros because the conversion to string of these
values are performed by accessing to an array of strings.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 tests/nft-expr_cmp-test.c | 2 +-
 tests/nft-expr_nat-test.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/nft-expr_cmp-test.c b/tests/nft-expr_cmp-test.c
index ec00bb9..4271940 100644
--- a/tests/nft-expr_cmp-test.c
+++ b/tests/nft-expr_cmp-test.c
@@ -64,7 +64,7 @@ int main(int argc, char *argv[])
 
 	nftnl_expr_set(ex, NFTNL_EXPR_CMP_DATA, &data_len, sizeof(data_len));
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_CMP_SREG, 0x12345678);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_CMP_OP, 0x78123456);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_CMP_OP, NFT_CMP_LT);
 
 	nftnl_rule_add_expr(a, ex);
 
diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
index fd3a488..9c15a0a 100644
--- a/tests/nft-expr_nat-test.c
+++ b/tests/nft-expr_nat-test.c
@@ -71,8 +71,8 @@ int main(int argc, char *argv[])
 	if (ex == NULL)
 		print_err("OOM");
 
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_TYPE, 0x1234568);
-	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_FAMILY, 0x3456721);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_TYPE, NFT_NAT_SNAT);
+	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_FAMILY, NFPROTO_INET);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_ADDR_MIN, 0x1452638);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_ADDR_MAX, 0x5134682);
 	nftnl_expr_set_u32(ex, NFTNL_EXPR_NAT_REG_PROTO_MIN, 0x6124385);
-- 
2.8.3

