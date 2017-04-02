From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 2/2] iptables: iptables: Constify option struct
Date: Sun,  2 Apr 2017 12:35:08 +0530
Message-ID: <20170402070508.20770-2-arushisinghal19971997@gmail.com>
References: <20170402070508.20770-1-arushisinghal19971997@gmail.com>
Cc: Arushi Singhal <arushisinghal19971997@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34609 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbdDBHFY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Apr 2017 03:05:24 -0400
Received: by mail-pg0-f65.google.com with SMTP id o123so23891941pga.1
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Apr 2017 00:05:24 -0700 (PDT)
In-Reply-To: <20170402070508.20770-1-arushisinghal19971997@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The structs of the type option are not modified anywhere.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 iptables/ip6tables.c    | 2 +-
 iptables/iptables-xml.c | 2 +-
 iptables/xtables-arp.c  | 2 +-
 iptables/xtables-eb.c   | 2 +-
 iptables/xtables.c      | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 579d347..fd1c541 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -78,7 +78,7 @@ static const char optflags[]
 
 static const char unsupported_rev[] = " [unsupported revision]";
 
-static struct option original_opts[] = {
+static const struct option original_opts[] = {
 	{.name = "append",        .has_arg = 1, .val = 'A'},
 	{.name = "delete",        .has_arg = 1, .val = 'D'},
 	{.name = "check" ,        .has_arg = 1, .val = 'C'},
diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 740a563..abe7bbe 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -38,7 +38,7 @@ static int verbose = 0;
 /* Whether to combine actions of sequential rules with identical conditions */
 static int combine = 0;
 /* Keeping track of external matches and targets.  */
-static struct option options[] = {
+static const struct option options[] = {
 	{"verbose", 0, NULL, 'v'},
 	{"combine", 0, NULL, 'c'},
 	{"help", 0, NULL, 'h'},
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 6aa000a..85feb48 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -107,7 +107,7 @@ static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 static const char optflags[NUMBER_OF_OPT]
 = { 'n', 's', 'd', 2, 3, 7, 8, 4, 5, 6, 'j', 'v', 'i', 'o', '0', 'c'};
 
-static struct option original_opts[] = {
+static const struct option original_opts[] = {
 	{ "append", 1, 0, 'A' },
 	{ "delete", 1, 0,  'D' },
 	{ "insert", 1, 0,  'I' },
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index c8b5d4f..60ec935 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -247,7 +247,7 @@ static int get_current_chain(const char *chain)
 
 /* Default command line options. Do not mess around with the already
  * assigned numbers unless you know what you are doing */
-static struct option ebt_original_options[] =
+static const struct option ebt_original_options[] =
 {
 	{ "append"         , required_argument, 0, 'A' },
 	{ "insert"         , required_argument, 0, 'I' },
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 286866f..636aa87 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -59,7 +59,7 @@ static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 static const char optflags[]
 = { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c', 'f'};
 
-static struct option original_opts[] = {
+static const struct option original_opts[] = {
 	{.name = "append",	  .has_arg = 1, .val = 'A'},
 	{.name = "delete",	  .has_arg = 1, .val = 'D'},
 	{.name = "check",	  .has_arg = 1, .val = 'C'},
-- 
2.11.0

