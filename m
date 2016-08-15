From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/2 libnftnl] expr: cmp: Use cmp2str() instead of directly access to array
Date: Mon, 15 Aug 2016 12:27:37 +0200
Message-ID: <20160815102737.11955-2-carlosfg@riseup.net>
References: <20160815091239.GC3905@salvia>
 <20160815102737.11955-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:40265 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbcHOK1z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Aug 2016 06:27:55 -0400
In-Reply-To: <20160815102737.11955-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 src/expr/cmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 92c7364..b647b01 100644
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

