From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH 1/2] iptables: Remove explicit static variables initalization.
Date: Thu, 30 Mar 2017 00:57:02 +0530
Message-ID: <58dc0a89.549c620a.6eb0a.5c33@mx.google.com>
References: <cover.1490815157.git.rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel <outreachy-kernel@googlegroups.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35656 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754027AbdC2T1H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 15:27:07 -0400
Received: by mail-pg0-f68.google.com with SMTP id g2so4114945pge.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:27:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1490815157.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Static variables are initialized to zero by default, so remove explicit
initalization. This patch fixes the checkpatch issue.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 iptables/ip6tables-restore.c |  2 +-
 iptables/ip6tables-save.c    |  2 +-
 iptables/iptables-restore.c  |  2 +-
 iptables/iptables-save.c     |  2 +-
 iptables/iptables-xml.c      | 10 +++++-----
 iptables/xtables-arp.c       |  2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 8a47f09..30a4ade 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -26,7 +26,7 @@
 #define DEBUGP(x, args...)
 #endif
 
-static int counters = 0, verbose = 0, noflush = 0, wait = 0;
+static int counters, verbose, noflush, wait;
 
 static struct timeval wait_interval = {
 	.tv_sec	= 1,
diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index 053413a..c2495d2 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -18,7 +18,7 @@
 #include "ip6tables.h"
 #include "ip6tables-multi.h"
 
-static int show_counters = 0;
+static int show_counters;
 
 static const struct option options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 7bb06d8..15db358 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -23,7 +23,7 @@
 #define DEBUGP(x, args...)
 #endif
 
-static int counters = 0, verbose = 0, noflush = 0, wait = 0;
+static int counters, verbose, noflush, wait;
 
 static struct timeval wait_interval = {
 	.tv_sec	= 1,
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index e8ae9c6..fbc6059 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -17,7 +17,7 @@
 #include "iptables.h"
 #include "iptables-multi.h"
 
-static int show_counters = 0;
+static int show_counters;
 
 static const struct option options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 740a563..2e093b5 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -34,9 +34,9 @@ struct xtables_globals iptables_xml_globals = {
 static void print_usage(const char *name, const char *version)
 	    __attribute__ ((noreturn));
 
-static int verbose = 0;
+static int verbose;
 /* Whether to combine actions of sequential rules with identical conditions */
-static int combine = 0;
+static int combine;
 /* Keeping track of external matches and targets.  */
 static struct option options[] = {
 	{"verbose", 0, NULL, 'v'},
@@ -73,10 +73,10 @@ parse_counters(char *string, struct xt_counters *ctr)
 
 /* global new argv and argc */
 static char *newargv[255];
-static unsigned int newargc = 0;
+static unsigned int newargc;
 
 static char *oldargv[255];
-static unsigned int oldargc = 0;
+static unsigned int oldargc;
 
 /* arg meta data, were they quoted, frinstance */
 static int newargvattr[255];
@@ -96,7 +96,7 @@ struct chain {
 
 #define maxChains 10240		/* max chains per table */
 static struct chain chains[maxChains];
-static int nextChain = 0;
+static int nextChain;
 
 /* funCtion adding one argument to newargv, updating newargc 
  * returns true if argument added, false otherwise */
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 6aa000a..4a968f4 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -150,7 +150,7 @@ static struct option original_opts[] = {
 int RUNTIME_NF_ARP_NUMHOOKS = 3;
 
 static struct option *opts = original_opts;
-static unsigned int global_option_offset = 0;
+static unsigned int global_option_offset;
 
 extern void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 struct xtables_globals arptables_globals = {
-- 
2.9.3

