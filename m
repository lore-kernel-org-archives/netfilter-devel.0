From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/4, V2, libnftnl] tests: Fix wrong expression creation
Date: Fri, 12 Aug 2016 22:17:20 +0200
Message-ID: <20160812201722.10134-2-carlosfg@riseup.net>
References: <20160811233222.GB5108@salvia>
 <20160812201722.10134-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:50278 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbcHLURx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 16:17:53 -0400
In-Reply-To: <20160812201722.10134-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 tests/nft-expr_masq-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/nft-expr_masq-test.c b/tests/nft-expr_masq-test.c
index f0302e2..3f9903d 100644
--- a/tests/nft-expr_masq-test.c
+++ b/tests/nft-expr_masq-test.c
@@ -52,7 +52,7 @@ int main(int argc, char *argv[])
 	b = nftnl_rule_alloc();
 	if (a == NULL || b == NULL)
 		print_err("OOM");
-	ex = nftnl_expr_alloc("nat");
+	ex = nftnl_expr_alloc("masq");
 	if (ex == NULL)
 		print_err("OOM");
 
-- 
2.8.3

