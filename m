From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 05/**] Remove empty option structs
Date: Tue, 24 Jul 2007 12:22:10 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707241221270.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: kaber@trash.net
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


Save the structs.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libip6t_TRACE.c  |    5 -----
 extensions/libip6t_eui64.c  |    5 -----
 extensions/libipt_MIRROR.c  |    5 -----
 extensions/libipt_TRACE.c   |    5 -----
 extensions/libipt_unclean.c |    5 -----
 extensions/libxt_NOTRACK.c  |    6 ------
 extensions/libxt_standard.c |    6 ------
 ip6tables.c                 |    3 +++
 iptables.c                  |    3 +++
 9 files changed, 6 insertions(+), 37 deletions(-)

Index: iptables/extensions/libip6t_TRACE.c
===================================================================
--- iptables.orig/extensions/libip6t_TRACE.c
+++ iptables/extensions/libip6t_TRACE.c
@@ -16,10 +16,6 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
-	{ 0 }
-};
-
 /* Initialize the target. */
 static void
 init(struct ip6t_entry_target *t, unsigned int *nfcache)
@@ -54,7 +50,6 @@ struct ip6tables_target trace 
 	.final_check = &final_check,
 	.print = NULL, /* print */
 	.save = NULL, /* save */
-	.extra_opts = opts
 };
 
 void _init(void)
Index: iptables/extensions/libip6t_eui64.c
===================================================================
--- iptables.orig/extensions/libip6t_eui64.c
+++ iptables/extensions/libip6t_eui64.c
@@ -22,10 +22,6 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
-	{0}
-};
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -67,7 +63,6 @@ static struct ip6tables_match eui64 = {
 	.final_check	= &final_check,
 	.print		= &print,
 	.save		= &save,
-	.extra_opts	= opts,
 };
 
 void _init(void)
Index: iptables/extensions/libipt_MIRROR.c
===================================================================
--- iptables.orig/extensions/libipt_MIRROR.c
+++ iptables/extensions/libipt_MIRROR.c
@@ -16,10 +16,6 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
-	{ 0 }
-};
-
 /* Initialize the target. */
 static void
 init(struct xt_entry_target *t, unsigned int *nfcache)
@@ -52,7 +48,6 @@ static struct iptables_target mirror = {
 	.final_check 	= &final_check,
 	.print		= NULL,
 	.save		= NULL,
-	.extra_opts	= opts
 };
 
 void _init(void)
Index: iptables/extensions/libipt_TRACE.c
===================================================================
--- iptables.orig/extensions/libipt_TRACE.c
+++ iptables/extensions/libipt_TRACE.c
@@ -16,10 +16,6 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
-	{ 0 }
-};
-
 /* Initialize the target. */
 static void
 init(struct ipt_entry_target *t, unsigned int *nfcache)
@@ -54,7 +50,6 @@ struct iptables_target trace 
 	.final_check = &final_check,
 	.print = NULL, /* print */
 	.save = NULL, /* save */
-	.extra_opts = opts
 };
 
 void _init(void)
Index: iptables/extensions/libipt_unclean.c
===================================================================
--- iptables.orig/extensions/libipt_unclean.c
+++ iptables/extensions/libipt_unclean.c
@@ -13,10 +13,6 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
-	{0}
-};
-
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -44,7 +40,6 @@ struct iptables_match unclean = { 
 	.final_check	= &final_check,
 	.print		= NULL,
 	.save		= NULL,
-	.extra_opts	= opts
 };
 
 void _init(void)
Index: iptables/extensions/libxt_NOTRACK.c
===================================================================
--- iptables.orig/extensions/libxt_NOTRACK.c
+++ iptables/extensions/libxt_NOTRACK.c
@@ -16,10 +16,6 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
-	{ 0 }
-};
-
 /* Initialize the target. */
 static void
 init(struct xt_entry_target *t, unsigned int *nfcache)
@@ -53,7 +49,6 @@ struct xtables_target notrack =
 	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
-	.extra_opts	= opts,
 };
 
 static
@@ -68,7 +63,6 @@ struct xtables_target notrack6 =
 	.init		= &init,
 	.parse		= &parse,
 	.final_check	= &final_check,
-	.extra_opts	= opts,
 };
 
 void _init(void)
Index: iptables/extensions/libxt_standard.c
===================================================================
--- iptables.orig/extensions/libxt_standard.c
+++ iptables/extensions/libxt_standard.c
@@ -16,10 +16,6 @@ help(void)
 "(If target is DROP, ACCEPT, RETURN or nothing)\n", IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
-	{0}
-};
-
 /* Initialize the target. */
 static void
 init(struct xt_entry_target *t, unsigned int *nfcache)
@@ -60,7 +56,6 @@ struct xtables_target standard = { 
 	.final_check	= &final_check,
 	.print		= NULL,
 	.save		= &save,
-	.extra_opts	= opts
 };
 
 static
@@ -76,7 +71,6 @@ struct xtables_target standard6 = { 
 	.final_check	= &final_check,
 	.print		= NULL,
 	.save		= &save,
-	.extra_opts	= opts
 };
 
 void _init(void)
Index: iptables/ip6tables.c
===================================================================
--- iptables.orig/ip6tables.c
+++ iptables/ip6tables.c
@@ -815,6 +815,9 @@ merge_options(struct option *oldopts, co
 	unsigned int num_old, num_new, i;
 	struct option *merge;
 
+	if (newopts == NULL)
+		return oldopts;
+
 	for (num_old = 0; oldopts[num_old].name; num_old++);
 	for (num_new = 0; newopts[num_new].name; num_new++);
 
Index: iptables/iptables.c
===================================================================
--- iptables.orig/iptables.c
+++ iptables/iptables.c
@@ -853,6 +853,9 @@ merge_options(struct option *oldopts, co
 	unsigned int num_old, num_new, i;
 	struct option *merge;
 
+	if (newopts == NULL)
+		return oldopts;
+
 	for (num_old = 0; oldopts[num_old].name; num_old++);
 	for (num_new = 0; newopts[num_new].name; num_new++);
 
