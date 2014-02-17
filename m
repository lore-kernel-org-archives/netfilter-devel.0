From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] ct: direction should be integer, not bitmask
Date: Mon, 17 Feb 2014 22:05:07 +0100
Message-ID: <1392671107-6457-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50536 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154AbaBQVI7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:08:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

should always generate cmp op (its enum 0, 1 in kernel).

Note: 'original,reply' will no longer work after this patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ct.c b/src/ct.c
index f893df9..79d4666 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -61,7 +61,7 @@ static const struct datatype ct_dir_type = {
 	.desc		= "conntrack direction",
 	.byteorder	= BYTEORDER_INVALID,
 	.size		= BITS_PER_BYTE,
-	.basetype	= &bitmask_type,
+	.basetype	= &integer_type,
 	.sym_tbl	= &ct_dir_tbl,
 };
 
-- 
1.8.1.5

