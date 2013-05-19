From: Michael Roth <mail@mroth.net>
Subject: [PATCH] doc: mention SNAT in INPUT chain since kernel 2.6.36
Date: Sun, 19 May 2013 13:22:16 +0200
Message-ID: <1368962536-28853-1-git-send-email-mail@mroth.net>
Cc: Michael Roth <mroth@nessie.de>, Michael Roth <mail@mroth.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from monster.nessie.de ([84.200.20.120]:37766 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab3ESLkV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 May 2013 07:40:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Michael Roth <mroth@nessie.de>

SNAT in the INPUT chain was added Jun 2010 to the kernel
(commit c68cd6cc21eb329c47ff020ff7412bf58176984e).

Signed-off-by: Michael Roth <mail@mroth.net>
---
 extensions/libipt_SNAT.man |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/extensions/libipt_SNAT.man b/extensions/libipt_SNAT.man
index 626b592..093b09c 100644
--- a/extensions/libipt_SNAT.man
+++ b/extensions/libipt_SNAT.man
@@ -2,7 +2,10 @@ This target is only valid in the
 .B nat
 table, in the
 .B POSTROUTING
-chain.  It specifies that the source address of the packet should be
+and
+.B INPUT
+chains, and user-defined chains which are only called from those
+chains.  It specifies that the source address of the packet should be
 modified (and all future packets in this connection will also be
 mangled), and rules should cease being examined.  It takes one type
 of option:
@@ -35,3 +38,9 @@ is used then port mapping will be randomized (kernel >= 2.6.21).
 Gives a client the same source-/destination-address for each connection.
 This supersedes the SAME target. Support for persistent mappings is available
 from 2.6.29-rc2.
+.PP
+Kernels prior to 2.6.36-rc1 don't have the ability to
+.B SNAT
+in the
+.B INPUT
+chain.
-- 
1.7.10.4

