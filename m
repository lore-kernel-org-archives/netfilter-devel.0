From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 1/2] Revert "conntrack: fix expectation entry creation"
Date: Fri, 15 Jan 2016 19:47:43 +0000
Message-ID: <1452887264-26064-1-git-send-email-ast@fiberby.dk>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	pfeiffer.szilard@balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:54375 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbcAOTs3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2016 14:48:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

{} is mask-src and mask-dst, [] is tuple-src and tuple-dst
mask-* should be stored in mask, tuple-* should be stored in exptuple.

This reverts commit 3309fdb4413cb32f9b95e05064dc9dbb56550939
since it mixed up {} and [].
---
 src/conntrack.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 3ae4527..324daf4 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2074,8 +2074,6 @@ int main(int argc, char *argv[])
 			break;
 		case '{':
 		case '}':
-			nfct_set_addr_from_opt(c, tmpl.exptuple, &ad, &family);
-			break;
 		case '[':
 		case ']':
 			nfct_set_addr_from_opt(c, tmpl.mask, &ad, &family);
-- 
2.6.4

