From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] RFC - compile iptables without O2
Date: Wed, 8 Sep 2004 15:34:00 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040908223400.GA16692@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

There is an ancient bug in bugzilla (#13) which says iptables should 
compile without 'O2'.  Not sure why this is important, but the below
patch makes it compile, and the resulting executable works.

Anyone comment on why these '#ifndef __OPTIMIZE' statements were added
in the first place, and whether I'm missing something by simply removing
them?

Phil



--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nooptimize

diff -ru ipt-orig/ip6tables.c ipt-new/ip6tables.c
--- ipt-orig/ip6tables.c	2004-06-14 18:02:16.000000000 -0400
+++ ipt-new/ip6tables.c	2004-09-08 18:14:53.031881136 -0400
@@ -148,14 +148,6 @@
  * magic number of -1 */
 int line = -1;
 
-#ifndef __OPTIMIZE__
-struct ip6t_entry_target *
-ip6t_get_target(struct ip6t_entry *e)
-{
-	return (void *)e + e->target_offset;
-}
-#endif
-
 static struct option *opts = original_opts;
 static unsigned int global_option_offset = 0;
 
diff -ru ipt-orig/iptables.c ipt-new/iptables.c
--- ipt-orig/iptables.c	2004-06-14 18:02:16.000000000 -0400
+++ ipt-new/iptables.c	2004-09-08 18:14:23.430381248 -0400
@@ -147,14 +147,6 @@
  * magic number of -1 */
 int line = -1;
 
-#ifndef __OPTIMIZE__
-struct ipt_entry_target *
-ipt_get_target(struct ipt_entry *e)
-{
-	return (void *)e + e->target_offset;
-}
-#endif
-
 static struct option *opts = original_opts;
 static unsigned int global_option_offset = 0;
 
diff -ru ipt-orig/libiptc/libiptc.c ipt-new/libiptc/libiptc.c
--- ipt-orig/libiptc/libiptc.c	2004-06-14 18:02:18.000000000 -0400
+++ ipt-new/libiptc/libiptc.c	2004-09-08 18:19:36.847734568 -0400
@@ -27,14 +27,6 @@
 #define IPT_LIB_DIR "/usr/local/lib/iptables"
 #endif
 
-#ifndef __OPTIMIZE__
-STRUCT_ENTRY_TARGET *
-GET_TARGET(STRUCT_ENTRY *e)
-{
-	return (void *)e + e->target_offset;
-}
-#endif
-
 static int sockfd = -1;
 static void *iptc_fn = NULL;
 

--FCuugMFkClbJLl1L--
