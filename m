From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [rfc] renames
Date: Tue, 24 Jul 2007 12:30:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707241225190.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,


there is a small issue with debugging. A lot of modules (be it dynamic 
or NO_SHARED_LIBS=1) use the same function names, which makes it 
impossible for the debugger to select the right symbol to 
print/set a breakpoint at. (It will choose whatever is in scope, or 
random.) The 'solution' I'd come up with is to rename the overlapping 
parts (opts, help, parse, final_check, print, save, _init) to be 
unambiguous among the symbol space. Would such patch be considered?
Just asking so that I don't waste time :)

	Jan
===
Example:

---
 extensions/Makefile           |    7 ++++-
 extensions/libip6t_CONNMARK.c |   46 +++++++++++++++---------------------
 extensions/libxt_udp.c        |   53 +++++++++++++++++++-----------------------
 include/xtables.h             |    8 ++----
 4 files changed, 53 insertions(+), 61 deletions(-)

Index: iptables/extensions/Makefile
===================================================================
--- iptables.orig/extensions/Makefile
+++ iptables/extensions/Makefile
@@ -132,7 +132,12 @@ extensions/initext6.c: extensions/Makefi
 	echo "}" >> $@
 
 extensions/lib%.o: extensions/lib%.c
-	$(CC) $(CFLAGS) -D_INIT=$*_init -c -o $@ $<
+	$(CC) $(CFLAGS) -D_init=$*_init -c -o $@ $<
+
+else
+
+extensions/lib%_sh.o: extensions/lib%.c
+	$(CC) $(CFLAGS) -D_init=$*_init -c -o $@ $<
 
 endif
  
Index: iptables/extensions/libip6t_CONNMARK.c
===================================================================
--- iptables.orig/extensions/libip6t_CONNMARK.c
+++ iptables/extensions/libip6t_CONNMARK.c
@@ -36,8 +36,7 @@ struct markinfo {
 #endif
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void CONNMARK6_help(void)
 {
 	printf(
 "CONNMARK target v%s options:\n"
@@ -48,7 +47,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option CONNMARK6_opts[] = {
 	{ "set-mark", 1, 0, '1' },
 	{ "save-mark", 0, 0, '2' },
 	{ "restore-mark", 0, 0, '3' },
@@ -57,17 +56,15 @@ static const struct option opts[] = {
 };
 
 /* Initialize the target. */
-static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+static void CONNMARK6_init_data(struct xt_entry_target *t,
+                                unsigned int *nfcache)
 {
 }
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      struct xt_entry_target **target)
+static int CONNMARK6_parse(int c, char **argv, int invert, unsigned int *flags,
+                           const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_connmark_target_info *markinfo
 		= (struct ipt_connmark_target_info *)(*target)->data;
@@ -121,7 +118,7 @@ parse(int c, char **argv, int invert, un
 }
 
 static void
-final_check(unsigned int flags)
+CONNMARK6_check(unsigned int flags)
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
@@ -143,10 +140,8 @@ print_mask(const char *text, unsigned lo
 
 
 /* Prints out the target info. */
-static void
-print(const void *ip,
-      const struct xt_entry_target *target,
-      int numeric)
+static void CONNMARK6_print(const void *ip,
+                            const struct xt_entry_target *target, int numeric)
 {
 	const struct ipt_connmark_target_info *markinfo =
 		(const struct ipt_connmark_target_info *)target->data;
@@ -173,8 +168,7 @@ print(const void *ip,
 }
 
 /* Saves the target into in parsable form to stdout. */
-static void
-save(const void *ip, const struct xt_entry_target *target)
+static void CONNMARK6_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct ipt_connmark_target_info *markinfo =
 		(const struct ipt_connmark_target_info *)target->data;
@@ -200,21 +194,21 @@ save(const void *ip, const struct xt_ent
 	}
 }
 
-static struct ip6tables_target connmark_target = {
+static struct ip6tables_target CONNMARK6_reg = {
     .name          = "CONNMARK",
     .version       = IPTABLES_VERSION,
     .size          = IP6T_ALIGN(sizeof(struct ipt_connmark_target_info)),
     .userspacesize = IP6T_ALIGN(sizeof(struct ipt_connmark_target_info)),
-    .help          = &help,
-    .init          = &init,
-    .parse         = &parse,
-    .final_check   = &final_check,
-    .print         = &print,
-    .save          = &save,
-    .extra_opts    = opts
+    .help          = CONNMARK6_help,
+    .init          = CONNMARK6_init_data,
+    .parse         = CONNMARK6_parse,
+    .final_check   = CONNMARK6_check,
+    .print         = CONNMARK6_print,
+    .save          = CONNMARK6_save,
+    .extra_opts    = CONNMARK6_opts,
 };
 
-void _init(void)
+init_static void _init(void)
 {
-	register_target6(&connmark_target);
+	register_target6(&CONNMARK6_reg);
 }
Index: iptables/extensions/libxt_udp.c
===================================================================
--- iptables.orig/extensions/libxt_udp.c
+++ iptables/extensions/libxt_udp.c
@@ -8,8 +8,7 @@
 #include <linux/netfilter/xt_tcpudp.h>
 
 /* Function which prints out usage message. */
-static void
-help(void)
+static void udp_help(void)
 {
 	printf(
 "UDP v%s options:\n"
@@ -22,7 +21,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static const struct option opts[] = {
+static const struct option udp_opts[] = {
 	{ "source-port", 1, 0, '1' },
 	{ "sport", 1, 0, '1' }, /* synonym */
 	{ "destination-port", 1, 0, '2' },
@@ -54,8 +53,7 @@ parse_udp_ports(const char *portstring, 
 }
 
 /* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+static void udp_init(struct xt_entry_match *m, unsigned int *nfcache)
 {
 	struct xt_udp *udpinfo = (struct xt_udp *)m->data;
 
@@ -67,11 +65,9 @@ init(struct xt_entry_match *m, unsigned 
 
 /* Function which parses command options; returns true if it
    ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
+static int udp_parse(int c, char **argv, int invert, unsigned int *flags,
+                     const void *entry, unsigned int *nfcache,
+                     struct xt_entry_match **match)
 {
 	struct xt_udp *udpinfo = (struct xt_udp *)(*match)->data;
 
@@ -107,7 +103,7 @@ parse(int c, char **argv, int invert, un
 
 /* Final check; we don't care. */
 static void
-final_check(unsigned int flags)
+udp_check(unsigned int flags)
 {
 }
 
@@ -155,9 +151,8 @@ print_ports(const char *name, u_int16_t 
 }
 
 /* Prints out the union ipt_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
+static void udp_print(const void *ip, const struct xt_entry_match *match,
+                      int numeric)
 {
 	const struct xt_udp *udp = (struct xt_udp *)match->data;
 
@@ -174,7 +169,7 @@ print(const void *ip,
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
+static void udp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_udp *udpinfo = (struct xt_udp *)match->data;
 
@@ -214,13 +209,13 @@ struct xtables_match udp = { 
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_udp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_udp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= udp_help,
+	.init		= udp_init,
+	.parse		= udp_parse,
+	.final_check	= udp_check,
+	.print		= udp_print,
+	.save		= udp_save,
+	.extra_opts	= udp_opts,
 };
 
 static
@@ -230,13 +225,13 @@ struct xtables_match udp6 = { 
 	.version	= IPTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_udp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_udp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
+	.help		= udp_help,
+	.init		= udp_init,
+	.parse		= udp_parse,
+	.final_check	= udp_check,
+	.print		= udp_print,
+	.save		= udp_save,
+	.extra_opts	= udp_opts,
 };
 
 void
Index: iptables/include/xtables.h
===================================================================
--- iptables.orig/include/xtables.h
+++ iptables/include/xtables.h
@@ -230,13 +230,11 @@ void exit_error(enum exittype, char *, .
 							  format(printf,2,3)));
 extern const char *program_name, *program_version;
 
-#define _init __attribute__((constructor)) my_init
 #ifdef NO_SHARED_LIBS
-# ifdef _INIT
-#  undef _init
-#  define _init _INIT
-# endif
+#	define init_static
   extern void init_extensions(void);
+#else
+#	define init_static static __attribute__((constructor))
 #endif
 
 #define __be32	u_int32_t
