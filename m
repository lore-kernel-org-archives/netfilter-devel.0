From: jengelh@medozas.de
Subject: [PATCH 7/8] libxtables: move compat defines to xtables.c
Date: Wed, 11 Feb 2009 16:03:35 +0100
Message-ID: <1234364616-19974-8-git-send-email-jengelh@medozas.de>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48697 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbZBKPDk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:03:40 -0500
In-Reply-To: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

Addendum to commit v1.4.3-rc1-41-g77f48c2 where the macro users
got moved.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/ip6tables.h |    5 -----
 include/iptables.h  |    5 -----
 xtables.c           |    9 +++++++++
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index b8478d4..98f2da5 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -6,11 +6,6 @@
 #include <libiptc/libip6tc.h>
 #include <iptables/internal.h>
 
-#ifndef IP6T_SO_GET_REVISION_MATCH /* Old kernel source. */
-#define IP6T_SO_GET_REVISION_MATCH	68
-#define IP6T_SO_GET_REVISION_TARGET	69
-#endif /* IP6T_SO_GET_REVISION_MATCH   Old kernel source */
-
 extern int line;
 
 /* Your shared library should call one of these. */
diff --git a/include/iptables.h b/include/iptables.h
index 963905a..d309059 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -6,11 +6,6 @@
 #include <libiptc/libiptc.h>
 #include <iptables/internal.h>
 
-#ifndef IPT_SO_GET_REVISION_MATCH /* Old kernel source. */
-#define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
-#define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
-#endif /* IPT_SO_GET_REVISION_MATCH   Old kernel source */
-
 extern int line;
 
 /* Your shared library should call one of these. */
diff --git a/xtables.c b/xtables.c
index c898889..3c89a9d 100644
--- a/xtables.c
+++ b/xtables.c
@@ -39,6 +39,15 @@
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
 #endif
+#ifndef IPT_SO_GET_REVISION_MATCH /* Old kernel source. */
+#	define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
+#	define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
+#endif
+#ifndef IP6T_SO_GET_REVISION_MATCH /* Old kernel source. */
+#	define IP6T_SO_GET_REVISION_MATCH	68
+#	define IP6T_SO_GET_REVISION_TARGET	69
+#endif
+
 
 #define NPROTO	255
 
-- 
1.6.1.2

