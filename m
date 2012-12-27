From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [libnetfilter_conntrack PATCH] Fix logic typo in cmp_secctx
Date: Thu, 27 Dec 2012 15:12:30 +0100
Message-ID: <4631253.eD7KB7KPU6@storm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:52277 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2L0OMg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:12:36 -0500
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by re04.intra2net.com (Postfix) with ESMTP id 924103012A
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Dec 2012 15:12:35 +0100 (CET)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id 2A73D2AC57
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Dec 2012 15:12:35 +0100 (CET)
Received: from storm.localnet (storm.m.i2n [172.16.1.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id 83B242AC54
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Dec 2012 15:12:30 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

cppcheck reported:
[src/conntrack/compare.c:364] -> [src/conntrack/compare.c:364]: (style) Same expression on both sides of '||'.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 src/conntrack/compare.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
index b18f7fc..e282a24 100644
--- a/src/conntrack/compare.c
+++ b/src/conntrack/compare.c
@@ -361,7 +361,7 @@ cmp_secctx(const struct nf_conntrack *ct1,
 	   const struct nf_conntrack *ct2,
 	   unsigned int flags)
 {
-	if (ct1->secctx == NULL || ct1->secctx == NULL)
+	if (ct1->secctx == NULL || ct2->secctx == NULL)
 		return ct1->secctx == ct2->secctx;
 	return strcmp(ct1->secctx, ct2->secctx) == 0;
 }
-- 
1.7.11.7

