From: Jan Engelhardt <jengelh@medozas.de>
Subject: libxtables: flush before fork
Date: Thu, 12 Feb 2009 01:30:28 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902120130070.21248@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34258 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbZBLAa3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 19:30:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


commit 80b192ec65bac9c8c64ac56f0b11ddda3a5dd661
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Feb 12 01:28:35 2009 +0100

libxtables: flush before fork

Reference: http://bugs.debian.org/514869
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/xtables.c b/xtables.c
index 02bfc17..d85e639 100644
--- a/xtables.c
+++ b/xtables.c
@@ -272,6 +272,12 @@ int xtables_insmod(const char *modname, const char *modprobe, bool quiet)
 		modprobe = buf;
 	}
 
+	/*
+	 * Need to flush the buffer, or the child may output it again
+	 * when switching the program thru execv.
+	 */
+	fflush(stdout);
+
 	switch (fork()) {
 	case 0:
 		argv[0] = (char *)modprobe;
-- 
# Created with git-export-patch

