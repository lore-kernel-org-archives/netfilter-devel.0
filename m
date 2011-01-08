From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/13] ip[6]tables: only call match's parse function when option char is in range
Date: Sat,  8 Jan 2011 16:20:08 +0100
Message-ID: <1294500015-10691-8-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32896 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab1AHPUX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:23 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Normally, extensions use a "default:" case in switch(c) to just return
if they do not handle c. Apparently, libip6t_hl does that too late and
checks for hl-specific parsing state before it has established that c
refers to one of its own options.

Also affected: libipt_ttl, libxt_ipvs, libxt_policy, libxt_statistic.

One way to fix this is to move the flags checks into case '2', '3',
'4'. Doing this replication feels bad, so as an alternative, let's
just free extensions from having to deal with other extension's
options passing thru.

References: http://marc.info/?l=netfilter-devel&m=129444759532377&w=2
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |    3 +++
 iptables.c  |    3 +++
 xshared.h   |    4 ++++
 xtables.c   |    4 ++--
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index b8449f6..4ca4bfe 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1714,6 +1714,9 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					if (matchp->completed ||
 					    matchp->match->parse == NULL)
 						continue;
+					if (c < matchp->match->option_offset ||
+					    c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
+						continue;
 					if (matchp->match->parse(c - matchp->match->option_offset,
 						     argv, invert,
 						     &matchp->match->mflags,
diff --git a/iptables.c b/iptables.c
index e0efbf1..bcacd49 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1746,6 +1746,9 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					if (matchp->completed ||
 					    matchp->match->parse == NULL)
 						continue;
+					if (c < matchp->match->option_offset ||
+					    c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
+						continue;
 					if (matchp->match->parse(c - matchp->match->option_offset,
 						     argv, invert,
 						     &matchp->match->mflags,
diff --git a/xshared.h b/xshared.h
index c53b618..e5b2a02 100644
--- a/xshared.h
+++ b/xshared.h
@@ -4,6 +4,10 @@
 struct xtables_rule_match;
 struct xtables_target;
 
+enum {
+	XT_OPTION_OFFSET_SCALE = 256,
+};
+
 extern void print_extension_helps(const struct xtables_target *,
 	const struct xtables_rule_match *);
 
diff --git a/xtables.c b/xtables.c
index b630901..5b7526c 100644
--- a/xtables.c
+++ b/xtables.c
@@ -49,7 +49,7 @@
 #	define IP6T_SO_GET_REVISION_TARGET	69
 #endif
 #include <getopt.h>
-
+#include "xshared.h"
 
 #define NPROTO	255
 
@@ -111,7 +111,7 @@ struct option *xtables_merge_options(struct option *orig_opts,
 	mp = merge + num_oold;
 
 	/* Second, the new options */
-	xt_params->option_offset += 256;
+	xt_params->option_offset += XT_OPTION_OFFSET_SCALE;
 	*option_offset = xt_params->option_offset;
 	memcpy(mp, newopts, sizeof(*mp) * num_new);
 
-- 
1.7.1

