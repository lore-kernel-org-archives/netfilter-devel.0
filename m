From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd 1/8] conntrackd: fix sanitization of expection attribute in the wire format
Date: Tue, 18 Aug 2015 19:28:32 +0200
Message-ID: <1439918919-6937-2-git-send-email-pablo@netfilter.org>
References: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Cc: pwouters@redhat.com, fweimer@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37584 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbbHRRWa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 13:22:30 -0400
In-Reply-To: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The maximum number of attribute is NTA_EXP_MAX for expectation sync messages.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parse.c b/src/parse.c
index f3ec6ac..878e354 100644
--- a/src/parse.c
+++ b/src/parse.c
@@ -510,7 +510,7 @@ int msg2exp(struct nf_expect *exp, struct nethdr *net, size_t remain)
 		ATTR_NETWORK2HOST(attr);
 		if (attr->nta_len > len)
 			goto err;
-		if (attr->nta_attr > NTA_MAX)
+		if (attr->nta_attr >= NTA_EXP_MAX)
 			goto err;
 		if (attr->nta_len < NTA_LENGTH(0))
 			goto err;
-- 
1.7.10.4

