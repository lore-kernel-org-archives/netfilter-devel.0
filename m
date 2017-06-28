From: Ismo Puustinen <ismo.puustinen@intel.com>
Subject: [PATCH] man: add include statement documentation.
Date: Wed, 28 Jun 2017 11:16:57 +0300
Message-ID: <20170628081657.25371-1-ismo.puustinen@intel.com>
Cc: Ismo Puustinen <ismo.puustinen@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:23584 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751469AbdF1IRC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 04:17:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add to man page information about using the wildcard include statements.

Signed-off-by: Ismo Puustinen <ismo.puustinen@intel.com>
---
 doc/nft.xml | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 970acb5..9c9192c 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -229,8 +229,13 @@ vi:ts=4 sw=4
 				-h/--help option.
 			</para>
 			<para>
-				If the <literal>filename</literal> parameter is a directory, then all files in
-				the directory are loaded in alphabetical order.
+				Include statements support the usual shell wildcard symbols
+				(<literal>*,?,[]</literal>). Having no matches for an include statement is not
+				an error, if wildcard symbols are used in the include statement. This allows having
+				potentially empty include directories for statements like
+				<literal>include "/etc/firewall/rules/*"</literal>. The wildcard matches are
+				loaded in alphabetical order. Files beginning with dot (<literal>.</literal>) are
+				not matched by include statements.
 			</para>
 		</refsect2>
 		<refsect2>
-- 
2.9.4

