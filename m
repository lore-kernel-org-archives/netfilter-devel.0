From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 4/4] meta: fix crash when parsing unresolvable mark values
Date: Fri, 10 Jan 2014 09:31:34 +0000
Message-ID: <1389346294-7242-5-git-send-email-kaber@trash.net>
References: <1389346294-7242-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57694 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaAJJc2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:32:28 -0500
In-Reply-To: <1389346294-7242-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

*res has undefined contents, set to NULL before invoking the parse function
to make sure the test for != NULL doesn't falsely return true.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/datatype.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/datatype.c b/src/datatype.c
index 9910a1b..86ea80e 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -643,6 +643,7 @@ static struct error_record *mark_type_parse(const struct expr *sym,
 		}
 	}
 
+	*res = NULL;
 	erec = sym->dtype->basetype->parse(sym, res);
 	if (erec != NULL)
 		return erec;
-- 
1.8.4.2

