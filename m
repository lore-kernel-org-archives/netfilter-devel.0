From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH][TRIVIAL]  Unused variable in libipt_LOG.c and libip6t_LOG.c
Date: Mon, 11 Aug 2003 09:42:16 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F379D38.4070707@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_ndqPNU6Uzrl7Wvt6vOXpmQ)"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_ndqPNU6Uzrl7Wvt6vOXpmQ)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

  the following two patches remove an unused variable in save() and 
convert all structure initializations to C99.

Stephane Ouellette


--Boundary_(ID_ndqPNU6Uzrl7Wvt6vOXpmQ)
Content-type: text/plain; name=libip6t_LOG.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libip6t_LOG.c.patch

--- netfilter/userspace/extensions/libip6t_LOG.c	Mon Jul 14 16:01:29 2003
+++ netfilter.fixed/userspace/extensions/libip6t_LOG.c	Sun Aug  3 20:02:57 2003
@@ -26,12 +26,12 @@
 }
 
 static struct option opts[] = {
-	{ "log-level", 1, 0, '!' },
-	{ "log-prefix", 1, 0, '#' },
-	{ "log-tcp-sequence", 0, 0, '1' },
-	{ "log-tcp-options", 0, 0, '2' },
-	{ "log-ip-options", 0, 0, '3' },
-	{ 0 }
+	{ .name = "log-level",        .has_arg = 1, .flag = 0, .val = '!' },
+	{ .name = "log-prefix",       .has_arg = 1, .flag = 0, .val = '#' },
+	{ .name = "log-tcp-sequence", .has_arg = 0, .flag = 0, .val = '1' },
+	{ .name = "log-tcp-options",  .has_arg = 0, .flag = 0, .val = '2' },
+	{ .name = "log-ip-options",   .has_arg = 0, .flag = 0, .val = '3' },
+	{ .name = 0 }
 };
 
 /* Initialize the target. */
@@ -52,15 +52,15 @@
 };
 
 static struct ip6t_log_names ip6t_log_names[]
-= { { "alert", LOG_ALERT },
-    { "crit", LOG_CRIT },
-    { "debug", LOG_DEBUG },
-    { "emerg", LOG_EMERG },
-    { "error", LOG_ERR },		/* DEPRECATED */
-    { "info", LOG_INFO },
-    { "notice", LOG_NOTICE },
-    { "panic", LOG_EMERG },		/* DEPRECATED */
-    { "warning", LOG_WARNING }
+= { { .name = "alert",   .level = LOG_ALERT },
+    { .name = "crit",    .level = LOG_CRIT },
+    { .name = "debug",   .level = LOG_DEBUG },
+    { .name = "emerg",   .level = LOG_EMERG },
+    { .name = "error",   .level = LOG_ERR },		/* DEPRECATED */
+    { .name = "info",    .level = LOG_INFO },
+    { .name = "notice",  .level = LOG_NOTICE },
+    { .name = "panic",   .level = LOG_EMERG },		/* DEPRECATED */
+    { .name = "warning", .level = LOG_WARNING }
 };
 
 static u_int8_t
@@ -225,7 +225,6 @@
 {
 	const struct ip6t_log_info *loginfo
 		= (const struct ip6t_log_info *)target->data;
-	unsigned int i = 0;
 
 	if (strcmp(loginfo->prefix, "") != 0)
 		printf("--log-prefix \"%s\" ", loginfo->prefix);
@@ -243,18 +242,18 @@
 
 static
 struct ip6tables_target log
-= { NULL,
-    "LOG",
-    IPTABLES_VERSION,
-    IP6T_ALIGN(sizeof(struct ip6t_log_info)),
-    IP6T_ALIGN(sizeof(struct ip6t_log_info)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+= {
+    .name          = "LOG",
+    .version       = IPTABLES_VERSION,
+    .size          = IP6T_ALIGN(sizeof(struct ip6t_log_info)),
+    .userspacesize = IP6T_ALIGN(sizeof(struct ip6t_log_info)),
+    .help          = &help,
+    .init          = &init,
+    .parse         = &parse,
+    .final_check   = &final_check,
+    .print         = &print,
+    .save          = &save,
+    .extra_opts    = opts
 };
 
 void _init(void)

--Boundary_(ID_ndqPNU6Uzrl7Wvt6vOXpmQ)
Content-type: text/plain; name=libipt_LOG.c.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libipt_LOG.c.patch

--- netfilter/userspace/extensions/libipt_LOG.c	Mon Jul 14 16:01:29 2003
+++ netfilter.fixed/userspace/extensions/libipt_LOG.c	Sun Aug  3 19:54:50 2003
@@ -26,12 +26,12 @@
 }
 
 static struct option opts[] = {
-	{ "log-level", 1, 0, '!' },
-	{ "log-prefix", 1, 0, '#' },
-	{ "log-tcp-sequence", 0, 0, '1' },
-	{ "log-tcp-options", 0, 0, '2' },
-	{ "log-ip-options", 0, 0, '3' },
-	{ 0 }
+	{ .name = "log-level",        .has_arg = 1, .flag = 0, .val = '!' },
+	{ .name = "log-prefix",       .has_arg = 1, .flag = 0, .val = '#' },
+	{ .name = "log-tcp-sequence", .has_arg = 0, .flag = 0, .val = '1' },
+	{ .name = "log-tcp-options",  .has_arg = 0, .flag = 0, .val = '2' },
+	{ .name = "log-ip-options",   .has_arg = 0, .flag = 0, .val = '3' },
+	{ .name = 0 }
 };
 
 /* Initialize the target. */
@@ -52,15 +52,15 @@
 };
 
 static struct ipt_log_names ipt_log_names[]
-= { { "alert", LOG_ALERT },
-    { "crit", LOG_CRIT },
-    { "debug", LOG_DEBUG },
-    { "emerg", LOG_EMERG },
-    { "error", LOG_ERR },		/* DEPRECATED */
-    { "info", LOG_INFO },
-    { "notice", LOG_NOTICE },
-    { "panic", LOG_EMERG },		/* DEPRECATED */
-    { "warning", LOG_WARNING }
+= { { .name = "alert",   .level = LOG_ALERT },
+    { .name = "crit",    .level = LOG_CRIT },
+    { .name = "debug",   .level = LOG_DEBUG },
+    { .name = "emerg",   .level = LOG_EMERG },
+    { .name = "error",   .level = LOG_ERR },		/* DEPRECATED */
+    { .name = "info",    .level = LOG_INFO },
+    { .name = "notice",  .level = LOG_NOTICE },
+    { .name = "panic",   .level = LOG_EMERG },		/* DEPRECATED */
+    { .name = "warning", .level = LOG_WARNING }
 };
 
 static u_int8_t
@@ -225,7 +225,6 @@
 {
 	const struct ipt_log_info *loginfo
 		= (const struct ipt_log_info *)target->data;
-	unsigned int i = 0;
 
 	if (strcmp(loginfo->prefix, "") != 0)
 		printf("--log-prefix \"%s\" ", loginfo->prefix);
@@ -243,18 +242,18 @@
 
 static
 struct iptables_target log
-= { NULL,
-    "LOG",
-    IPTABLES_VERSION,
-    IPT_ALIGN(sizeof(struct ipt_log_info)),
-    IPT_ALIGN(sizeof(struct ipt_log_info)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
+= {
+    .name          = "LOG",
+    .version       = IPTABLES_VERSION,
+    .size          = IPT_ALIGN(sizeof(struct ipt_log_info)),
+    .userspacesize = IPT_ALIGN(sizeof(struct ipt_log_info)),
+    .help          = &help,
+    .init          = &init,
+    .parse         = &parse,
+    .final_check   = &final_check,
+    .print         = &print,
+    .save          = &save,
+    .extra_opts    = opts
 };
 
 void _init(void)

--Boundary_(ID_ndqPNU6Uzrl7Wvt6vOXpmQ)--
