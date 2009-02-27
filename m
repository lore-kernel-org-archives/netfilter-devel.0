From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH] netfilter: Kconfig spelling fixes (trivial)
Date: Thu, 26 Feb 2009 17:35:06 -0800
Message-ID: <20090226173506.045653f5@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:36576 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbZB0BfL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:35:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Stephen Hemminger <sheminger@vyatta.com>

--- a/net/ipv4/netfilter/Kconfig	2009-02-26 17:20:46.000000000 -0800
+++ b/net/ipv4/netfilter/Kconfig	2009-02-26 17:20:27.000000000 -0800
@@ -31,7 +31,7 @@ config NF_CONNTRACK_PROC_COMPAT
 	default y
 	help
 	  This option enables /proc and sysctl compatibility with the old
-	  layer 3 dependant connection tracking. This is needed to keep
+	  layer 3 dependent connection tracking. This is needed to keep
 	  old programs that have not been adapted to the new names working.
 
 	  If unsure, say Y.
@@ -99,7 +99,7 @@ config IP_NF_MATCH_TTL
 	---help---
 	This is a backwards-compat option for the user's convenience
 	(e.g. when running oldconfig). It selects
-	COFNIG_NETFILTER_XT_MATCH_HL.
+	CONFIG_NETFILTER_XT_MATCH_HL.
 
 # `filter', generic and specific targets
 config IP_NF_FILTER
@@ -329,7 +329,7 @@ config IP_NF_TARGET_TTL
 	---help---
 	This is a backwards-compat option for the user's convenience
 	(e.g. when running oldconfig). It selects
-	COFNIG_NETFILTER_XT_TARGET_HL.
+	CONFIG_NETFILTER_XT_TARGET_HL.
 
 # raw + specific targets
 config IP_NF_RAW
