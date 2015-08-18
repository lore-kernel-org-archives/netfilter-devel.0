From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd 2/8] conntrackd: NTA_MAX is also an invalid attribute
Date: Tue, 18 Aug 2015 19:28:33 +0200
Message-ID: <1439918919-6937-3-git-send-email-pablo@netfilter.org>
References: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Cc: pwouters@redhat.com, fweimer@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37587 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbbHRRWc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 13:22:32 -0400
In-Reply-To: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Otherwise this can result in an off-by-one array access.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/parse.c b/src/parse.c
index 878e354..3ac4092 100644
--- a/src/parse.c
+++ b/src/parse.c
@@ -297,7 +297,7 @@ int msg2ct(struct nf_conntrack *ct, struct nethdr *net, size_t remain)
 			return -1;
 		if (attr->nta_len < NTA_LENGTH(0))
 			return -1;
-		if (attr->nta_attr > NTA_MAX)
+		if (attr->nta_attr >= NTA_MAX)
 			return -1;
 		if (h[attr->nta_attr].size &&
 		    attr->nta_len != h[attr->nta_attr].size)
-- 
1.7.10.4

