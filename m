From: Eric Leblond <eric@regit.org>
Subject: [PATCH 1/7] Update TODO.
Date: Mon, 18 Feb 2013 09:37:42 +0100
Message-ID: <1361176668-22661-2-git-send-email-eric@regit.org>
References: <1361176668-22661-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:48539 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3BRIia (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:38:30 -0500
In-Reply-To: <1361176668-22661-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Try to sync TODO with real state of the project.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 TODO |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/TODO b/TODO
index 3a2fe72..d9c0fb3 100644
--- a/TODO
+++ b/TODO
@@ -1,11 +1,4 @@
-- autoconf/automake detection of libnetfilter_{log,conntrack}, mysql, pgsql, sqlite3, pcap
-- conditional compilation of NFLOG, CTNL, PGSQL, MYSQL, SQLITE3, PCAP plugins
 - add support for capabilities to run as non-root
-- IPv6 support (core and extensions)
 - support for static linking
 - issues with ulogd_BASE and partially copied packets (--ulog-cprange)
 - problem wrt. ulogd_BASE and fragments
-- cleanup keys after we've propagatet through the whole stack (RETF_VALID, FREE)
-- port SQLITE3 plugin
-- convert db layer and pgsql + mysql plugin to a 'parameter bind' scheme for efficiency
-- autoconf detection of SCTP / DCCP support
-- 
1.7.10.4

