From: Kevin Fenzi <kevin@scrye.com>
Subject: [PATCH] Fix trivial error in man page where flush should be rename
Date: Sat, 23 Aug 2014 09:59:52 -0600
Message-ID: <1408809592-22140-1-git-send-email-kevin@scrye.com>
Cc: Kevin Fenzi <kevin@scrye.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 75-148-32-185-Colorado.hfc.comcastbusiness.net ([75.148.32.185]:37179
	"EHLO mail.scrye.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaHWQSX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Aug 2014 12:18:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Trivial fix, but someone filed a bug on it, and it should be fixed. ;) 
https://bugzilla.redhat.com/show_bug.cgi?id=1132917

Signed-off-by: Kevin Fenzi <kevin@scrye.com>
---
 doc/nft.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 41c0840..cec5ef3 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -508,7 +508,7 @@ filter input iif $int_ifs accept
 				</listitem>
 			</varlistentry>
 			<varlistentry>
-				<term><option>flush</option></term>
+				<term><option>rename</option></term>
 				<listitem>
 					<para>
 						Rename the specified chain.
-- 
2.1.0

