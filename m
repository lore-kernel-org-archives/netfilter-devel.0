From: Jon Jensen <jon@endpoint.com>
Subject: [PATCH] Correct manpage description of -n / --numeric option
Date: Fri, 28 Oct 2016 20:24:23 -0600
Message-ID: <1477707863-19649-1-git-send-email-jon@endpoint.com>
Cc: Jon Jensen <jon@endpoint.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.endcrypt.com ([50.97.100.2]:53878 "EHLO mail.endcrypt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753223AbcJ2C3p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 22:29:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"When used twice" was used twice. :) Make it match the description in
main.c instead.

Signed-off-by: Jon Jensen <jon@endpoint.com>
---
 doc/nft.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index cc1e4a4..473c0c1 100644
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
2.7.4

