From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/4] iptables: limit chain name length to be consistent with targets
Date: Wed, 15 Sep 2010 20:53:45 +0200
Message-ID: <1284576828-32412-3-git-send-email-jengelh@medozas.de>
References: <1284576828-32412-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46822 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab0IOSxz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:53:55 -0400
In-Reply-To: <1284576828-32412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Creationg of chain names longer than the ones being able to jump to
should be inhibited for consistency.

References: http://marc.info/?l=netfilter-devel&m=128397022618316&w=2
Cc: Stig Thormodsrud <stig@vyatta.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |    6 +++---
 iptables.c  |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 6c5d124..15067da 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1838,10 +1838,10 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 	generic_opt_check(command, options);
 
-	if (chain && strlen(chain) > IP6T_FUNCTION_MAXNAMELEN)
+	if (chain != NULL && strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
-			   "chain name `%s' too long (must be under %i chars)",
-			   chain, IP6T_FUNCTION_MAXNAMELEN);
+			   "chain name `%s' too long (must be under %u chars)",
+			   chain, XT_EXTENSION_MAXNAMELEN);
 
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
diff --git a/iptables.c b/iptables.c
index 19f6d4f..840dd3e 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1876,10 +1876,10 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 	generic_opt_check(command, options);
 
-	if (chain && strlen(chain) > IPT_FUNCTION_MAXNAMELEN)
+	if (chain != NULL && strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
-			   "chain name `%s' too long (must be under %i chars)",
-			   chain, IPT_FUNCTION_MAXNAMELEN);
+			   "chain name `%s' too long (must be under %u chars)",
+			   chain, XT_EXTENSION_MAXNAMELEN);
 
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
-- 
1.7.1

