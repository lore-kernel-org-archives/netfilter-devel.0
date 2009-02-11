From: jengelh@medozas.de
Subject: [PATCH 6/8] src: remove unused ipt_tryload macro
Date: Wed, 11 Feb 2009 16:03:34 +0100
Message-ID: <1234364616-19974-7-git-send-email-jengelh@medozas.de>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48695 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbZBKPDk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:03:40 -0500
In-Reply-To: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/ip6tables.h |    2 --
 include/iptables.h  |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/ip6tables.h b/include/ip6tables.h
index 52e290c..b8478d4 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -11,8 +11,6 @@
 #define IP6T_SO_GET_REVISION_TARGET	69
 #endif /* IP6T_SO_GET_REVISION_MATCH   Old kernel source */
 
-#define ip6t_tryload		xt_tryload
-
 extern int line;
 
 /* Your shared library should call one of these. */
diff --git a/include/iptables.h b/include/iptables.h
index 74b244e..963905a 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -11,8 +11,6 @@
 #define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
 #endif /* IPT_SO_GET_REVISION_MATCH   Old kernel source */
 
-#define ipt_tryload		xt_tryload
-
 extern int line;
 
 /* Your shared library should call one of these. */
-- 
1.6.1.2

