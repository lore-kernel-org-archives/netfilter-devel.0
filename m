From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [PATCH] cvs compile error.
Date: Mon, 5 May 2003 21:51:42 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0305052144430.31233@dns.toxicfilms.tv>
References: <E19CliW-0004pJ-00@kashyyyk.netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@netfilter.org>
In-Reply-To: <E19CliW-0004pJ-00@kashyyyk.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

it seems as:
ipt_get_target(struct ipt_entry *e)

is defined in <kernel_source>/include/linux/netfilter_ipv4/ip_tables.h
and in iptables.c

The same goes for libiptc/libiptc.c

iptables.c:153: redefinition of `ipt_get_target'
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:294: `ipt_get_target' previously defined here
make: *** [iptables.o] Error 1

Regards,
Maciej

Is this below okay?
It compiles with it, and seems to work just fine.

diff -u -r1.28 ip6tables.c
--- ip6tables.c	5 May 2003 19:33:40 -0000	1.28
+++ ip6tables.c	5 May 2003 19:49:14 -0000
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

Index: iptables.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/iptables.c,v
retrieving revision 1.58
diff -u -r1.58 iptables.c
--- iptables.c	5 May 2003 19:33:40 -0000	1.58
+++ iptables.c	5 May 2003 19:49:14 -0000
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

Index: libiptc/libiptc.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/libiptc/libiptc.c,v
retrieving revision 1.37
diff -u -r1.37 libiptc.c
--- libiptc/libiptc.c	2 May 2003 15:30:11 -0000	1.37
+++ libiptc/libiptc.c	5 May 2003 19:49:15 -0000
@@ -15,14 +15,6 @@
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
