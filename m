From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] libxtables: flush before fork
Date: Thu, 12 Feb 2009 07:19:13 +0100
Message-ID: <1234419553-4147-4-git-send-email-jengelh@medozas.de>
References: <1234419553-4147-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60882 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZBLGTP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:19:15 -0500
In-Reply-To: <1234419553-4147-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
1.6.1.2

