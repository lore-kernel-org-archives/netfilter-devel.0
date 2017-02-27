From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 2/2] object: fix crash when object ops is null
Date: Mon, 27 Feb 2017 15:56:10 +0100
Message-ID: <20170227145610.12066-3-fw@strlen.de>
References: <20170227145610.12066-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55970 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751522AbdB0P2D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 10:28:03 -0500
In-Reply-To: <20170227145610.12066-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

when debugging nft with invalid object type (during development),
this will crash here with null deref.  Print (unknown) instead
if obj->ops is null.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/object.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/object.c b/src/object.c
index 62fa48afa2a1..773eff6a5a18 100644
--- a/src/object.c
+++ b/src/object.c
@@ -396,10 +396,11 @@ static int nftnl_obj_snprintf_dflt(char *buf, size_t size,
 				   const struct nftnl_obj *obj,
 				   uint32_t type, uint32_t flags)
 {
+	const char *name = obj->ops ? obj->ops->name : "(unknown)";
 	int ret, len = size, offset = 0;
 
 	ret = snprintf(buf, size, "table %s name %s use %u [ %s ",
-		       obj->table, obj->name, obj->use, obj->ops->name);
+		       obj->table, obj->name, obj->use, name);
 	SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
 
 	if (obj->ops) {
-- 
2.10.2

