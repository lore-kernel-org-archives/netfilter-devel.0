From: Ismo Puustinen <ismo.puustinen@intel.com>
Subject: [PATCH 2/3] man: add include directory documentation.
Date: Wed,  7 Jun 2017 11:35:58 +0300
Message-ID: <20170607083559.10051-2-ismo.puustinen@intel.com>
References: <20170607083559.10051-1-ismo.puustinen@intel.com>
Cc: Ismo Puustinen <ismo.puustinen@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30058 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751664AbdFGIiQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 04:38:16 -0400
In-Reply-To: <20170607083559.10051-1-ismo.puustinen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Short include directory introduction is added to the man page.

Signed-off-by: Ismo Puustinen <ismo.puustinen@intel.com>
---
 doc/nft.xml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index f613f69..9364133 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -209,6 +209,10 @@ vi:ts=4 sw=4
 				The directories to be searched for include files can be specified using
 				the <option>-I/--includepath</option> option.
 			</para>
+			<para>
+				If the <literal>filename</literal> parameter is a directory, then all files in
+				the directory are loaded in alphabetical order.
+			</para>
 		</refsect2>
 		<refsect2>
 			<title>Symbolic variables</title>
-- 
2.9.4

