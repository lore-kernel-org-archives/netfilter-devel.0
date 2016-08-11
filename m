From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 4/7] expr/limit: Drop unreachable code in limit_to_type()
Date: Fri, 12 Aug 2016 01:33:36 +0200
Message-ID: <1470958419-32602-5-git-send-email-phil@nwl.cc>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:36961 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbcHKXd6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:33:58 -0400
In-Reply-To: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The function returns from inside the switch() in any case, so the final
return statement is never reached.

Fixes: 7769cbd9dfe69 ("expr: limit: add per-byte limiting support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/limit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/expr/limit.c b/src/expr/limit.c
index 4bd096e8e921c..cdff81d620caa 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -259,7 +259,6 @@ static const char *limit_to_type(enum nft_limit_type type)
 	case NFT_LIMIT_PKT_BYTES:
 		return "bytes";
 	}
-	return "unknown";
 }
 
 static int nftnl_expr_limit_snprintf_default(char *buf, size_t len,
-- 
2.8.2

