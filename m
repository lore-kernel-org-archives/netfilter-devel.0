From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: iptables-xml broken with IPTABLES_MULTI
Date: Thu, 7 Dec 2006 13:38:47 +0100
Message-ID: <20061207123847.GA30414@innominate.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Content-Transfer-Encoding: 7bit
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
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

as of iptables-1.3.7 a new "iptables-xml" command is added automatically
to the IPTABLES_MULTI executable. It however breaks during build.
The attached patch seems to fix it.

Best regards,
	Lutz
--=20
Dr.-Ing. Lutz J=E4nicke
CTO
Innominate Security Technologies AG  /protecting industrial networks/
tel: +49.30.6392-3308
fax: +49.30.6392-3307
Albert-Einstein-Str. 14
D-12489 Berlin, Germany
www.innominate.com

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-multi.diff"

Index: ip6tables-restore.c
===================================================================
RCS file: /cvs/mguard/iptables/ip6tables-restore.c,v
retrieving revision 1.5
diff -u -r1.5 ip6tables-restore.c
--- ip6tables-restore.c	9 Oct 2006 08:21:24 -0000	1.5
+++ ip6tables-restore.c	7 Dec 2006 12:27:38 -0000
@@ -74,7 +74,7 @@
 	return handle;
 }
 
-int parse_counters(char *string, struct ip6t_counters *ctr)
+static int parse_counters(char *string, struct ip6t_counters *ctr)
 {
 	return (sscanf(string, "[%llu:%llu]", (unsigned long long *)&ctr->pcnt, (unsigned long long *)&ctr->bcnt) == 2);
 }
Index: iptables-multi.c
===================================================================
RCS file: /cvs/mguard/iptables/iptables-multi.c,v
retrieving revision 1.5
diff -u -r1.5 iptables-multi.c
--- iptables-multi.c	18 Oct 2006 17:44:45 -0000	1.5
+++ iptables-multi.c	7 Dec 2006 12:27:38 -0000
@@ -12,6 +12,7 @@
 int iptables_main(int argc, char **argv);
 int iptables_save_main(int argc, char **argv);
 int iptables_restore_main(int argc, char **argv);
+int iptables_xml_main(int argc, char **argv);
 
 int innominate_log_api = 0;
 
@@ -72,6 +73,9 @@
     if (!strcmp(progname, "iptables-restore"))
       return iptables_restore_main(argc, argv);
     
+    if (!strcmp(progname, "iptables-xml"))
+      return iptables_xml_main(argc, argv);
+    
     fprintf(stderr, "iptables multi-purpose version: unknown applet name %s\n", progname);
     exit(1);
   }
Index: iptables-restore.c
===================================================================
RCS file: /cvs/mguard/iptables/iptables-restore.c,v
retrieving revision 1.5
diff -u -r1.5 iptables-restore.c
--- iptables-restore.c	9 Oct 2006 08:21:24 -0000	1.5
+++ iptables-restore.c	7 Dec 2006 12:27:38 -0000
@@ -71,7 +71,7 @@
 	return handle;
 }
 
-int parse_counters(char *string, struct ipt_counters *ctr)
+static int parse_counters(char *string, struct ipt_counters *ctr)
 {
 	return (sscanf(string, "[%llu:%llu]", (unsigned long long *)&ctr->pcnt, (unsigned long long *)&ctr->bcnt) == 2);
 }
Index: iptables-xml.c
===================================================================
RCS file: /cvs/mguard/iptables/iptables-xml.c,v
retrieving revision 1.1
diff -u -r1.1 iptables-xml.c
--- iptables-xml.c	7 Dec 2006 12:08:48 -0000	1.1
+++ iptables-xml.c	7 Dec 2006 12:27:38 -0000
@@ -26,9 +26,9 @@
 /* no need to link with iptables.o */
 const char *program_name;
 const char *program_version;
-int line = 0;
 
-void
+#ifndef IPTABLES_MULTI
+int line = 0;
 exit_error(enum exittype status, char *msg, ...)
 {
 	va_list args;
@@ -41,6 +41,7 @@
 	/* On error paths, make sure that we don't leak memory */
 	exit(status);
 }
+#endif
 
 static void print_usage(const char *name, const char *version)
 	    __attribute__ ((noreturn));
@@ -66,7 +67,7 @@
 	exit(1);
 }
 
-int
+static int
 parse_counters(char *string, struct ipt_counters *ctr)
 {
 	if (string != NULL)
@@ -605,7 +606,7 @@
 
 #ifdef IPTABLES_MULTI
 int
-iptables_restore_main(int argc, char *argv[])
+iptables_xml_main(int argc, char *argv[])
 #else
 int
 main(int argc, char *argv[])

--oyUTqETQ0mS9luUI--
