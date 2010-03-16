From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/10] netfilter: xtables: add comment markers to Xtables Kconfig
Date: Tue, 16 Mar 2010 02:32:07 +0100
Message-ID: <1268703135-2622-4-git-send-email-jengelh@medozas.de>
References: <1268703135-2622-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49800 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937351Ab0CPBc1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:32:27 -0400
In-Reply-To: <1268703135-2622-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/Kconfig |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 18d77b5..abf4ce6 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -316,6 +316,8 @@ if NETFILTER_XTABLES
 
 # alphabetically ordered list of targets
 
+comment "Xtables targets"
+
 config NETFILTER_XT_TARGET_CLASSIFY
 	tristate '"CLASSIFY" target support'
 	depends on NETFILTER_ADVANCED
@@ -552,6 +554,10 @@ config NETFILTER_XT_TARGET_TCPOPTSTRIP
 	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
 	  TCP options from TCP packets.
 
+# alphabetically ordered list of matches
+
+comment "Xtables matches"
+
 config NETFILTER_XT_MATCH_CLUSTER
 	tristate '"cluster" match support'
 	depends on NF_CONNTRACK
-- 
1.7.0.2

