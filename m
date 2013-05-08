From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [nfacct PATCH] Improve 'flush' man page entry
Date: Wed, 08 May 2013 11:53:04 +0200
Message-ID: <4625919.UJoQ6sWfvM@storm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:45046 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3EHJxI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 May 2013 05:53:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 nfacct.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/nfacct.8 b/nfacct.8
index 554bc3b..0c3249c 100644
--- a/nfacct.8
+++ b/nfacct.8
@@ -31,7 +31,7 @@ Delete accounting object.
 Get existing accounting object.
 .TP
 .BI "flush "
-Flush the entire table.
+Delete all unused accounting objects.
 .TP
 .BI "version "
 Displays the version information.
-- 
1.7.11.2

