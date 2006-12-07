From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [ANNOUNCE] Release of iptables-1.3.7
Date: Thu, 07 Dec 2006 21:35:06 +0900 (JST)
Message-ID: <200612071235.kB7CZ8XW010126@toshiba.co.jp>
References: <45769244.3060508@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: azez@ufomechanic.net, kaber@trash.net, netfilter-devel@lists.netfilter.org
In-Reply-To: <45769244.3060508@netfilter.org>
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

DO_MULTI=1 causes build error because iptables-xml.c has same symbols
in ip[6]tables.c.

BTW, why we need to combine iptables-xml with other commands ? It doesn't
use any feature in ip[6]tables then binary size wouldn't be smaller
so much. Or anyone has plan to implement XML style output to
matches/targets ?

Anyway I'll apply this patch if no objection.

Regards,

-- Yasuyuki Kozakai

>From 52ed971f819cb0e7f32c95a75e3f5d052906519d Mon Sep 17 00:00:00 2001
From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date: Thu, 7 Dec 2006 21:06:03 +0900
Subject: fix error on compilation if DO_MULTI=1

---
 iptables-multi.c |    3 +++
 iptables-xml.c   |    8 +++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/iptables-multi.c b/iptables-multi.c
index 0563099..9e576ad 100644
--- a/iptables-multi.c
+++ b/iptables-multi.c
@@ -6,6 +6,7 @@
 int iptables_main(int argc, char **argv);
 int iptables_save_main(int argc, char **argv);
 int iptables_restore_main(int argc, char **argv);
+int iptables_xml_main(int argc, char **argv);
 
 int main(int argc, char **argv) {
   char *progname;
@@ -24,6 +25,8 @@ int main(int argc, char **argv) {
     
     if (!strcmp(progname, "iptables-restore"))
       return iptables_restore_main(argc, argv);
+    if (!strcmp(progname, "iptables-xml"))
+      return iptables_restore_main(argc, argv);
     
     fprintf(stderr, "iptables multi-purpose version: unknown applet name %s\n", progname);
     exit(1);
diff --git a/iptables-xml.c b/iptables-xml.c
index 34437e0..3a9a511 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -26,8 +26,9 @@
 /* no need to link with iptables.o */
 const char *program_name;
 const char *program_version;
-int line = 0;
 
+#ifndef IPTABLES_MULTI
+int line = 0;
 void
 exit_error(enum exittype status, char *msg, ...)
 {
@@ -41,6 +42,7 @@ exit_error(enum exittype status, char *m
 	/* On error paths, make sure that we don't leak memory */
 	exit(status);
 }
+#endif
 
 static void print_usage(const char *name, const char *version)
 	    __attribute__ ((noreturn));
@@ -66,7 +68,7 @@ print_usage(const char *name, const char
 	exit(1);
 }
 
-int
+static int
 parse_counters(char *string, struct ipt_counters *ctr)
 {
 	if (string != NULL)
@@ -605,7 +607,7 @@ do_rule(char *pcnt, char *bcnt, int argc
 
 #ifdef IPTABLES_MULTI
 int
-iptables_restore_main(int argc, char *argv[])
+iptables_xml_main(int argc, char *argv[])
 #else
 int
 main(int argc, char *argv[])
-- 
1.4.4
