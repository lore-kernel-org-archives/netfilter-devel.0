From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH] linealize: generate unary expression with the appropiate operation
Date: Mon, 18 Aug 2014 23:00:12 +0200
Message-ID: <1408395612-9791-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:64142 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaHRVAK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:00:10 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so5634826wev.27
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2014 14:00:09 -0700 (PDT)
Received: from localhost.localdomain (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id fr2sm41447679wib.7.2014.08.18.14.00.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Aug 2014 14:00:08 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we add a unary expression which the operation is ntoh, we use hton.
This looks like a typo.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/netlink_linearize.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0e1d87c..3e48e9b 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -442,7 +442,7 @@ static enum nft_byteorder_ops netlink_gen_unary_op(enum ops op)
 	case OP_HTON:
 		return NFT_BYTEORDER_HTON;
 	case OP_NTOH:
-		return NFT_BYTEORDER_HTON;
+		return NFT_BYTEORDER_NTOH;
 	default:
 		BUG("invalid unary operation %u\n", op);
 	}
-- 
1.7.10.4

