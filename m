From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/5] rule: family field in struct handle is unsigned
Date: Fri, 21 Jun 2013 16:42:16 +0200
Message-ID: <1371825739-3669-2-git-send-email-pablo@netfilter.org>
References: <1371825739-3669-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, eric@regit.org, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41714 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161419Ab3FUOm3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:42:29 -0400
In-Reply-To: <1371825739-3669-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/rule.h b/include/rule.h
index eda6b2c..e0debe3 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -15,7 +15,7 @@
  * @handle:	rule handle (rules only)
  */
 struct handle {
-	int			family;
+	uint32_t		family;
 	const char		*table;
 	const char		*chain;
 	const char		*set;
-- 
1.7.10.4

