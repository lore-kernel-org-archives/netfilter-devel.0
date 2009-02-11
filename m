From: jengelh@medozas.de
Subject: [PATCH 8/8] src: consolidate duplicate code in iptables/internal.h
Date: Wed, 11 Feb 2009 16:03:36 +0100
Message-ID: <1234364616-19974-9-git-send-email-jengelh@medozas.de>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48696 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782AbZBKPDk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:03:40 -0500
In-Reply-To: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/ip6tables.h            |    2 --
 include/iptables.h             |    2 --
 include/iptables/internal.h.in |    2 ++
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 98f2da5..86587e6 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -6,8 +6,6 @@
 #include <libiptc/libip6tc.h>
 #include <iptables/internal.h>
 
-extern int line;
-
 /* Your shared library should call one of these. */
 extern int do_command6(int argc, char *argv[], char **table,
 		       struct ip6tc_handle **handle);
diff --git a/include/iptables.h b/include/iptables.h
index d309059..f0aa345 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -6,8 +6,6 @@
 #include <libiptc/libiptc.h>
 #include <iptables/internal.h>
 
-extern int line;
-
 /* Your shared library should call one of these. */
 extern int do_command(int argc, char *argv[], char **table,
 		      struct iptc_handle **handle);
diff --git a/include/iptables/internal.h.in b/include/iptables/internal.h.in
index 849e172..8568e58 100644
--- a/include/iptables/internal.h.in
+++ b/include/iptables/internal.h.in
@@ -8,4 +8,6 @@
  */
 extern const char *program_name, *program_version;
 
+extern int line;
+
 #endif /* IPTABLES_INTERNAL_H */
-- 
1.6.1.2

