From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/2 libnfntl] expr: cmp: Use cmp2str() instead of directly access to array
Date: Mon, 15 Aug 2016 12:51:03 +0200
Message-ID: <20160815105103.22319-2-carlosfg@riseup.net>
References: <20160815103256.GB5883@salvia>
 <20160815105103.22319-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:49609 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbcHOKv2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 06:51:28 -0400
In-Reply-To: <20160815105103.22319-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Uses cmp2str() which checks array bounds.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 src/expr/cmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index f3dd62c..5d51958 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -267,7 +267,7 @@ static int nftnl_expr_cmp_snprintf_default(char *buf, size_t size,
 	int len = size, offset = 0, ret;
 
 	ret = snprintf(buf, len, "%s reg %u ",
-		       expr_cmp_str[cmp->op], cmp->sreg);
+		       cmp2str(cmp->op), cmp->sreg);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	ret = nftnl_data_reg_snprintf(buf+offset, len, &cmp->data,
-- 
2.8.3

