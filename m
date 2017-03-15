From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nft_ct: do cleanup work when NFTA_CT_DIRECTION is invalid
Date: Wed, 15 Mar 2017 22:22:08 +0800
Message-ID: <1489587728-28318-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:38327 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdCOOXM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 10:23:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

We should jump to invoke __nft_ct_set_destroy() instead of just
return error.

Fixes: edee4f1e9245 ("netfilter: nft_ct: add zone id set support")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nft_ct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 91585b5..0264258 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -544,7 +544,8 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 		case IP_CT_DIR_REPLY:
 			break;
 		default:
-			return -EINVAL;
+			err = -EINVAL;
+			goto err1;
 		}
 	}
 
-- 
2.5.5


