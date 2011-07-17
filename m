From: Peter Volkov <pva@gentoo.org>
Subject: [patch] Fix warnings, respect LDFLAGS
Date: Mon, 18 Jul 2011 00:38:18 +0400
Message-ID: <1310935098.26913.7.camel@tablet>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-X04clrcChoZzU0xscgIm"
Cc: Bart De Schuymer <bdschuym@pandora.be>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:56782 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab1GQUjF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Jul 2011 16:39:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-X04clrcChoZzU0xscgIm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi, patches in attachment fix some warnings, and make ebtables respect
LDFLAGS. Comments on each patch are included inside patches. Please,
review and apply.

--
Peter.

--=-X04clrcChoZzU0xscgIm
Content-Disposition: attachment; filename="0001-Fix-warning-for-strict-aliasing-rules.patch"
Content-Type: text/x-patch; name="0001-Fix-warning-for-strict-aliasing-rules.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From aff038e2b57b672a05833cf1af19a4b2e5c88c25 Mon Sep 17 00:00:00 2001
From: Peter Volkov <pva@gentoo.org>
Date: Thu, 14 Jul 2011 13:30:17 +0400
Subject: [PATCH 1/3] Fix warning for strict-aliasing rules

gcc-4.5 produces following warnings when -O2 optimisation are enabled:
extensions/ebt_among.c: In function 'create_wormhash':
extensions/ebt_among.c:250:4: warning: dereferencing type-punned pointer will break strict-aliasing rules
extensions/ebt_among.c:261:3: warning: dereferencing type-punned pointer will break strict-aliasing rules
---
 extensions/ebt_among.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/ebt_among.c b/extensions/ebt_among.c
index b98f65b..2759b06 100644
--- a/extensions/ebt_among.c
+++ b/extensions/ebt_among.c
@@ -247,7 +247,7 @@ static struct ebt_mac_wormhash *create_wormhash(const char *arg)
 				ebt_print_error("IP parse error: %.20s", anchor);
 				return NULL;
 			}
-			if (*(uint32_t*)ip == 0) {
+			if (ip[0] == 0 && ip[1] == 0 && ip[2] == 0 && ip[3] == 0) {
 				ebt_print_error("Illegal IP 0.0.0.0");
 				return NULL;
 			}
@@ -258,7 +258,7 @@ static struct ebt_mac_wormhash *create_wormhash(const char *arg)
 
 		/* we have collected MAC and IP, so we add an entry */
 		memcpy(((char *) workcopy->pool[nmacs].cmp) + 2, mac, 6);
-		workcopy->pool[nmacs].ip = *(const uint32_t *) ip;
+		memcpy(&(workcopy->pool[nmacs].ip), ip, 4);
 		nmacs++;
 
 		/* re-allocate memory if needed */
-- 
1.7.3.4


--=-X04clrcChoZzU0xscgIm
Content-Disposition: attachment; filename="0002-Avoid-uninitialized-variables.patch"
Content-Type: text/x-patch; name="0002-Avoid-uninitialized-variables.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 781183dbe41ca1146d60d2be41000af95f71f328 Mon Sep 17 00:00:00 2001
From: Peter Volkov <pva@gentoo.org>
Date: Sun, 17 Jul 2011 15:49:30 +0400
Subject: [PATCH 2/3] Avoid uninitialized variables

Patch fixes following warnings:
communication.c: In function 'ebt_deliver_counters':
communication.c:290:24: warning: 'entries' may be used uninitialized in this function
communication.c: In function 'ebt_get_table':
communication.c:703:22: warning: 'u_e' may be used uninitialized in this function
ebtables.c: In function 'do_command':
ebtables.c:535:6: warning: 'chcounter' may be used uninitialized in this function
extensions/ebt_among.c: In function 'parse':
extensions/ebt_among.c:314:7: warning: 'flen' may be used uninitialized in this function
extensions/ebt_among.c:315:6: warning: 'fd' may be used uninitialized in this function
---
 communication.c        |    4 ++--
 ebtables.c             |    2 +-
 extensions/ebt_among.c |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/communication.c b/communication.c
index 3311358..29d0f2c 100644
--- a/communication.c
+++ b/communication.c
@@ -293,7 +293,7 @@ void ebt_deliver_counters(struct ebt_u_replace *u_repl)
 	socklen_t optlen;
 	struct ebt_replace repl;
 	struct ebt_cntchanges *cc = u_repl->cc->next, *cc2;
-	struct ebt_u_entries *entries;
+	struct ebt_u_entries *entries = NULL;
 	struct ebt_u_entry *next = NULL;
 	int i, chainnr = 0;
 
@@ -708,7 +708,7 @@ int ebt_get_table(struct ebt_u_replace *u_repl, int init)
 {
 	int i, j, k, hook;
 	struct ebt_replace repl;
-	struct ebt_u_entry *u_e;
+	struct ebt_u_entry *u_e = NULL;
 	struct ebt_cntchanges *new_cc, *cc;
 
 	strcpy(repl.name, u_repl->name);
diff --git a/ebtables.c b/ebtables.c
index d5d24b0..62f1ba8 100644
--- a/ebtables.c
+++ b/ebtables.c
@@ -541,7 +541,7 @@ int do_command(int argc, char *argv[], int exec_style,
 	char *buffer;
 	int c, i;
 	int zerochain = -1; /* Needed for the -Z option (we can have -Z <this> -L <that>) */
-	int chcounter; /* Needed for -C */
+	int chcounter = 0; /* Needed for -C */
 	int policy = 0;
 	int rule_nr = 0;
 	int rule_nr_end = 0;
diff --git a/extensions/ebt_among.c b/extensions/ebt_among.c
index 2759b06..fe33e61 100644
--- a/extensions/ebt_among.c
+++ b/extensions/ebt_among.c
@@ -313,8 +313,8 @@ static int parse(int c, char **argv, int argc,
 	struct ebt_mac_wormhash *wh;
 	struct ebt_entry_match *h;
 	int new_size;
-	long flen;
-	int fd;
+	long flen = 0L;
+	int fd = 0;
 
 	switch (c) {
 	case AMONG_DST_F:
-- 
1.7.3.4


--=-X04clrcChoZzU0xscgIm
Content-Disposition: attachment; filename="0003-Respect-LDFLAGS-in-extensions.patch"
Content-Type: text/x-patch; name="0003-Respect-LDFLAGS-in-extensions.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 74193e3e4a5f8740091ffef96b08624aa93fc1d9 Mon Sep 17 00:00:00 2001
From: Peter Volkov <pva@gentoo.org>
Date: Sun, 17 Jul 2011 15:55:42 +0400
Subject: [PATCH 3/3] Respect LDFLAGS in extensions

Following warning is fixes with this patch:

For, non-static build:
 * QA Notice: Files built without respecting LDFLAGS have been detected
 *  Please include the following list of files in your report:
 * /lib64/ebtables/libebt_arpreply.so
 * /lib64/ebtables/libebt_among.so
 * /lib64/ebtables/libebt_redirect.so
 * /lib64/ebtables/libebt_limit.so
 * /lib64/ebtables/libebt_nat.so
 * /lib64/ebtables/libebt_standard.so
 * /lib64/ebtables/libebt_pkttype.so
 * /lib64/ebtables/libebt_mark_m.so
 * /lib64/ebtables/libebt_log.so
 * /lib64/ebtables/libebt_mark.so
 * /lib64/ebtables/libebt_ip.so
 * /lib64/ebtables/libebt_802_3.so
 * /lib64/ebtables/libebt_stp.so
 * /lib64/ebtables/libebt_ip6.so
 * /lib64/ebtables/libebt_nflog.so
 * /lib64/ebtables/libebt_ulog.so
 * /lib64/ebtables/libebt_vlan.so
 * /lib64/ebtables/libebt_arp.so

For static build:
 * QA Notice: Files built without respecting LDFLAGS have been detected
 *  Please include the following list of files in your report:
 * /sbin/ebtable
---
 Makefile            |    2 +-
 extensions/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 0d3f25f..26200ac 100644
--- a/Makefile
+++ b/Makefile
@@ -136,7 +136,7 @@ static: extensions/ebt_*.c extensions/ebtable_*.c ebtables.c communication.c ebt
 	printf "extern void %s();\n" _t_$${arg}_init >> include/ebtables_u.h ; \
 	done ; \
 	printf "\n\tpseudomain(argc, argv);\n\treturn 0;\n}\n" >> ebtables-standalone.c ;\
-	$(CC) $(CFLAGS) $(PROGSPECS) -o $@ $^ -I$(KERNEL_INCLUDES) -Iinclude ; \
+	$(CC) $(CFLAGS) $(LDFLAGS) $(PROGSPECS) -o $@ $^ -I$(KERNEL_INCLUDES) -Iinclude ; \
 	for arg in $(EXT_FUNC) \
 	; do \
 	sed "s/ .*_init/ _init/" extensions/ebt_$${arg}.c > extensions/ebt_$${arg}.c_ ; \
diff --git a/extensions/Makefile b/extensions/Makefile
index 2070ee8..b3548e8 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -11,7 +11,7 @@ EXT_LIBSI+=$(foreach T,$(EXT_FUNC), -lebt_$(T))
 EXT_LIBSI+=$(foreach T,$(EXT_TABLES), -lebtable_$(T))
 
 extensions/ebt_%.so: extensions/ebt_%.o
-	$(CC) -shared -o $@ -lc $< -nostartfiles
+	$(CC) $(LDFLAGS) -shared -o $@ -lc $< -nostartfiles
 
 extensions/libebt_%.so: extensions/ebt_%.so
 	mv $< $@
-- 
1.7.3.4


--=-X04clrcChoZzU0xscgIm--

