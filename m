From: fgao@ikuai8.com
Subject: [PATCH nft] doc: Fix wrong word in description of option "-n --numberic"
Date: Thu, 29 Sep 2016 20:39:43 +0800
Message-ID: <1475152783-379-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg320.qq.com ([14.17.32.29]:50801 "EHLO smtpbg320.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750877AbcI2Mks (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Sep 2016 08:40:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There is one wrong word in description of option "-n --numberic" in
nft.xml. There are duplicated "used twice", and the former one should
be "used once".

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 doc/nft.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 3b215f8..bc09623 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -113,7 +113,7 @@ vi:ts=4 sw=4
 					<para>
 						Numeric output: Addresses and other information
 						that might need network traffic to resolve to symbolic names
-						are shown numerically (default behaviour). When used twice,
+						are shown numerically (default behaviour). When used once,
 						internet services are translated. When used twice, internet
 						services and UIDs/GIDs are also shown numerically. When used
 						three times, protocol numbers are also shown numerically.
-- 
1.9.1


