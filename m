From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] iptables: Constify option struct
Date: Wed, 27 Sep 2017 17:14:52 +0530
Message-ID: <1506512692-7872-1-git-send-email-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34225 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdI0LrJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 07:47:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The struct of type option is only used to initialise a field inside
the xtables_globals struct and is not modified anywhere.
Done using following coccinelle semantic patch

@r1 disable optional_qualifier@
identifier s,i;
position p;
@@

static struct option i@p[] ={...};

@ok1@
identifier r1.i;
expression e;
position p;
@@
e = i@p

@bad@
position p != {r1.p,ok1.p};
identifier r1.i;
@@
e@i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
static
+const
struct option i[] = { ... };

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 iptables/ip6tables.c  | 2 +-
 iptables/iptables.c   | 2 +-
 iptables/xtables-eb.c | 2 +-
 iptables/xtables.c    | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 49bd006..0f6fa31 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -78,7 +78,7 @@ static const char optflags[]
 
 static const char unsupported_rev[] = " [unsupported revision]";
 
-static struct option original_opts[] = {
+static const struct option original_opts[] = {
 	{.name = "append",        .has_arg = 1, .val = 'A'},
 	{.name = "delete",        .has_arg = 1, .val = 'D'},
 	{.name = "check" ,        .has_arg = 1, .val = 'C'},
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 69d19fe..e930fe2 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -75,7 +75,7 @@ static const char optflags[]
 
 static const char unsupported_rev[] = " [unsupported revision]";
 
-static struct option original_opts[] = {
+static const struct option original_opts[] = {
 	{.name = "append",        .has_arg = 1, .val = 'A'},
 	{.name = "delete",        .has_arg = 1, .val = 'D'},
 	{.name = "check",         .has_arg = 1, .val = 'C'},
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
index ac11325..aebe7d7 100644
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
1.9.1

