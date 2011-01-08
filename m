From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Possible bug with ip6tables hl module.
Date: Sat, 8 Jan 2011 02:38:40 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101080236500.2125@obet.zrqbmnf.qr>
References: <201101080038.34932.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Steven Jan Springl <steven@springl.ukfsn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37352 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab1AHBil (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jan 2011 20:38:41 -0500
In-Reply-To: <201101080038.34932.steven@springl.ukfsn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-01-08 01:38, Steven Jan Springl wrote:

>ip6tables -A INPUT -m hl --hl-gt 100 -m length --length 100 -j ACCEPT
>It fails with the following message:
>ip6tables v1.4.10: Can't specify HL option twice

I queued this patch (to be merged when everybody got
out of vacation, hehe):


origin git://dev.medozas.de/iptables master
parent 1dc27393b7ba401e6228a5ee2472a6eb72836c43 (v1.4.10-23-g1dc2739)
commit 1e128bd804b676ee91beca48312de9b251845d09
Author: Jan Engelhardt
Date:   Sat Jan 8 02:25:28 2011 +0100

ip[6]tables: only call match's parse function when option char is in range

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
# Created with git-export-patch
