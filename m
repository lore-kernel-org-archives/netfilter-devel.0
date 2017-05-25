From: Bertrand Bonnefoy-Claudet <bertrandbc@gmail.com>
Subject: [PATCH] Fix typo in documentation of nft
Date: Thu, 25 May 2017 12:26:26 +0200
Message-ID: <20170525102626.11835-1-bertrandbc@gmail.com>
Cc: Bertrand Bonnefoy-Claudet <bertrandbc@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36737 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753747AbdEYK0b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2017 06:26:31 -0400
Received: by mail-wm0-f65.google.com with SMTP id k15so50692051wmh.3
        for <netfilter-devel@vger.kernel.org>; Thu, 25 May 2017 03:26:30 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Bertrand Bonnefoy-Claudet <bertrandbc@gmail.com>
---
 doc/nft.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 5680cdf..f613f69 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -566,7 +566,7 @@ filter input iif $int_ifs accept
 				<term><option>create</option></term>
 				<listitem>
 					<para>
-						Simlar to the <command>add</command> command, but returns an error if the
+						Similar to the <command>add</command> command, but returns an error if the
 						chain already exists.
 					</para>
 				</listitem>
-- 
2.13.0

