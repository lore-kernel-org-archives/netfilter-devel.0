From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 05/24] Drop -W from CFLAGS and some tiny code cleanups
Date: Tue, 4 Mar 2008 16:54:52 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041653370.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53739 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440AbYCDPyy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:54:54 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


-W turns on some of the deeply-nitpicky (IMO) warnings like
signed-vs-unsigned, so I judged it was better to remove it,
and be good developers instead.

===
commit 5d60776717f011fbd019a268a3193040aa9ddd4c
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Mar 3 12:30:41 2008 +0100

    Drop -W from CFLAGS and some tiny code cleanups
    
    - change "unsigned" to explicit "unsigned int"
    - remove some casts
---
 configure.ac                   |    2 +-
 extensions/dscp_helper.c       |    2 +-
 extensions/libip6t_dst.c       |    2 +-
 extensions/libip6t_hbh.c       |    2 +-
 extensions/libip6t_rt.c        |    2 +-
 extensions/libipt_SAME.c       |    6 +++---
 extensions/libxt_TCPOPTSTRIP.c |    2 +-
 extensions/libxt_quota.c       |    2 +-
 iptables-xml.c                 |   14 +++++++-------
 xtables.c                      |    2 +-
 10 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/configure.ac b/configure.ac
index a435ae4..004a517 100644
--- a/configure.ac
+++ b/configure.ac
@@ -37,7 +37,7 @@ AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" == "yes"])
 AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" == "yes"])
 
 regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
-	-D_REENTRANT -W -Wall -Waggregate-return -Wmissing-declarations \
+	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe -DIPTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
 	-DIPT_LIB_DIR=\\\"\${iptdir}\\\" -DIP6T_LIB_DIR=\\\"\${iptdir}\\\"";
diff --git a/extensions/dscp_helper.c b/extensions/dscp_helper.c
index 9e9a163..217df09 100644
--- a/extensions/dscp_helper.c
+++ b/extensions/dscp_helper.c
@@ -49,7 +49,7 @@ static const struct ds_class
 static unsigned int
 class_to_dscp(const char *name)
 {
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) {
 		if (!strncasecmp(name, ds_classes[i].name,
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 9e4d870..5b06033 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -168,7 +168,7 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_options(unsigned optsnr, u_int16_t *optsp)
+print_options(unsigned int optsnr, u_int16_t *optsp)
 {
 	unsigned int i;
 
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 1052575..ad12547 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -162,7 +162,7 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_options(unsigned optsnr, u_int16_t *optsp)
+print_options(unsigned int optsnr, u_int16_t *optsp)
 {
 	unsigned int i;
 
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index a9ced6a..e2ae09f 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -255,7 +255,7 @@ print_nums(const char *name, u_int32_t min, u_int32_t max,
 }
 
 static void
-print_addresses(unsigned addrnr, struct in6_addr *addrp)
+print_addresses(unsigned int addrnr, struct in6_addr *addrp)
 {
 	unsigned int i;
 
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index e03ae80..d1e6903 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -90,7 +90,7 @@ static int SAME_parse(int c, char **argv, int invert, unsigned int *flags,
 {
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)(*target)->data;
-	unsigned count;
+	unsigned int count;
 
 	switch (c) {
 	case '1':
@@ -146,7 +146,7 @@ static void SAME_check(unsigned int flags)
 static void SAME_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
-	unsigned count;
+	unsigned int count;
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)target->data;
 	int random = 0;
@@ -180,7 +180,7 @@ static void SAME_print(const void *ip, const struct xt_entry_target *target,
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void SAME_save(const void *ip, const struct xt_entry_target *target)
 {
-	unsigned count;
+	unsigned int count;
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)target->data;
 	int random = 0;
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index df107f4..bd66435 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -22,7 +22,7 @@ enum {
 
 struct tcp_optionmap {
 	const char *name, *desc;
-	const unsigned option;
+	const unsigned int option;
 };
 
 static const struct option tcpoptstrip_tg_opts[] = {
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 57050f2..b4fb78b 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -43,7 +43,7 @@ quota_save(const void *ip, const struct xt_entry_match *match)
 static int
 parse_quota(const char *s, u_int64_t * quota)
 {
-	*quota = strtoull(s, (char **) NULL, 10);
+	*quota = strtoull(s, NULL, 10);
 
 #ifdef DEBUG_XT_QUOTA
 	printf("Quota: %llu\n", *quota);
diff --git a/iptables-xml.c b/iptables-xml.c
index 087b7c7..404d020 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -85,10 +85,10 @@ parse_counters(char *string, struct ipt_counters *ctr)
 
 /* global new argv and argc */
 static char *newargv[255];
-static unsigned newargc = 0;
+static unsigned int newargc = 0;
 
 static char *oldargv[255];
-static unsigned oldargc = 0;
+static unsigned int oldargc = 0;
 
 /* arg meta data, were they quoted, frinstance */
 static int newargvattr[255];
@@ -129,7 +129,7 @@ add_argv(char *what, int quoted)
 static void
 free_argv(void)
 {
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < newargc; i++) {
 		free(newargv[i]);
@@ -149,7 +149,7 @@ free_argv(void)
 static void
 save_argv(void)
 {
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < oldargc; i++)
 		free(oldargv[i]);
@@ -545,8 +545,8 @@ compareRules(void)
 	   is the case when processing the ACTUAL output of actual iptables-save 
 	   rather than a file merely in a compatable format */
 
-	unsigned old = 0;
-	unsigned new = 0;
+	unsigned int old = 0;
+	unsigned int new = 0;
 
 	int compare = 0;
 
@@ -748,7 +748,7 @@ main(int argc, char *argv[])
 
 			ret = 1;
 		} else if (curTable[0]) {
-			unsigned a;
+			unsigned int a;
 			char *ptr = buffer;
 			char *pcnt = NULL;
 			char *bcnt = NULL;
diff --git a/xtables.c b/xtables.c
index af4d3dc..dba9081 100644
--- a/xtables.c
+++ b/xtables.c
@@ -257,7 +257,7 @@ int service_to_port(const char *name, const char *proto)
 
 u_int16_t parse_port(const char *port, const char *proto)
 {
-	unsigned portnum;
+	unsigned int portnum;
 
 	if ((string_to_number(port, 0, 65535, &portnum)) != -1 ||
 	    (portnum = service_to_port(port, proto)) != (unsigned)-1)
