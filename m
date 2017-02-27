From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 1/2] object: don't set NFTNL_OBJ_TYPE unless obj->ops is non-null
Date: Mon, 27 Feb 2017 15:56:09 +0100
Message-ID: <20170227145610.12066-2-fw@strlen.de>
References: <20170227145610.12066-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56168 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751422AbdB0P62 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 10:58:28 -0500
In-Reply-To: <20170227145610.12066-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If nft sets an invalid type, nftnl_obj_ops_lookup will return NULL.
In this case we must not set NFTNL_OBJ_TYPE flag, else we later get
crash in nftnl_obj_nlmsg_build_payload as it dereferences obj->ops.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/object.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/object.c b/src/object.c
index 9594d2f99071..62fa48afa2a1 100644
--- a/src/object.c
+++ b/src/object.c
@@ -83,6 +83,8 @@ void nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 		break;
 	case NFTNL_OBJ_TYPE:
 		obj->ops = nftnl_obj_ops_lookup(*((uint32_t *)data));
+		if (!obj->ops)
+			return;
 		break;
 	case NFTNL_OBJ_FAMILY:
 		obj->family = *((uint32_t *)data);
@@ -250,7 +252,8 @@ int nftnl_obj_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_obj *obj)
 		uint32_t type = ntohl(mnl_attr_get_u32(tb[NFTA_OBJ_TYPE]));
 
 		obj->ops = nftnl_obj_ops_lookup(type);
-		obj->flags |= (1 << NFTNL_OBJ_TYPE);
+		if (obj->ops)
+			obj->flags |= (1 << NFTNL_OBJ_TYPE);
 	}
 	if (tb[NFTA_OBJ_DATA]) {
 		if (obj->ops) {
-- 
2.10.2

