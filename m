From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/7] netlink: BUG when object type is unknown
Date: Mon, 27 Feb 2017 16:02:51 +0100
Message-ID: <20170227150255.12624-4-fw@strlen.de>
References: <20170227150255.12624-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56302 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751039AbdB0Q0Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 11:26:25 -0500
In-Reply-To: <20170227150255.12624-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will only trigger during development when adding new object types to
the parser.

The BUG() gives a clear hint where the serialization code needs to go.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index 1f3398225892..d2ede2a47c5d 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -317,6 +317,9 @@ alloc_nftnl_obj(const struct handle *h, struct obj *obj)
 		nftnl_obj_set_u32(nlo, NFTNL_OBJ_QUOTA_FLAGS,
 				  obj->quota.flags);
 		break;
+	default:
+		BUG("Unknown type %d\n", obj->type);
+		break;
 	}
 	return nlo;
 }
-- 
2.10.2

