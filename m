From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 3/3] Sync TODO list
Date: Thu, 11 Sep 2008 22:48:05 +0200
Message-ID: <1221166085-23435-4-git-send-email-eric@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:47381 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752254AbYIKUsK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:48:10 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch synchronizes the TODO list.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 TODO |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/TODO b/TODO
index 3a2fe72..40fdd46 100644
--- a/TODO
+++ b/TODO
@@ -1,11 +1,7 @@
-- autoconf/automake detection of libnetfilter_{log,conntrack}, mysql, pgsql, sqlite3, pcap
-- conditional compilation of NFLOG, CTNL, PGSQL, MYSQL, SQLITE3, PCAP plugins
 - add support for capabilities to run as non-root
-- IPv6 support (core and extensions)
 - support for static linking
 - issues with ulogd_BASE and partially copied packets (--ulog-cprange)
-- problem wrt. ulogd_BASE and fragments
-- cleanup keys after we've propagatet through the whole stack (RETF_VALID, FREE)
+- problem with ulogd_BASE and fragments
 - port SQLITE3 plugin
 - convert db layer and pgsql + mysql plugin to a 'parameter bind' scheme for efficiency
 - autoconf detection of SCTP / DCCP support
-- 
1.5.4.3

