From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [RFC] Additional TCP Flags in the tcp module.
Date: Wed, 7 May 2003 12:27:55 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0305071216370.14343@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
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

I was wondering if it would be of any use to add ECE and CWR flags
to libipt_tcp.c for matching.

It would be a trivial patch and extension, but would it be useful, could
it be harmful?

Regards,
Maciej

Like so:
Index: libipt_tcp.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libipt_tcp.c,v
retrieving revision 1.15
diff -u -r1.15 libipt_tcp.c
--- libipt_tcp.c	30 Mar 2003 18:29:56 -0000	1.15
+++ libipt_tcp.c	7 May 2003 10:26:59 -0000
@@ -14,7 +14,8 @@
 	printf(
 "TCP v%s options:\n"
 " --tcp-flags [!] mask comp	match when TCP flags & mask == comp\n"
-"				(Flags: SYN ACK FIN RST URG PSH ALL NONE)\n"
+"				(Flags: SYN ACK FIN RST URG PSH ECE CWR\n"
+"					ALL NONE)\n"
 "[!] --syn			match when only SYN flag set\n"
 "				(equivalent to --tcp-flags SYN,RST,ACK SYN)\n"
 " --source-port [!] port[:port]\n"
@@ -97,7 +98,9 @@
     { "PSH", 0x08 },
     { "ACK", 0x10 },
     { "URG", 0x20 },
-    { "ALL", 0x3F },
+    { "ECE", 0x40 },
+    { "CWR", 0x80 },
+    { "ALL", 0xFF },
     { "NONE", 0 },
 };

Index: libip6t_tcp.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libip6t_tcp.c,v
retrieving revision 1.11
diff -u -r1.11 libip6t_tcp.c
--- libip6t_tcp.c	30 Mar 2003 18:29:56 -0000	1.11
+++ libip6t_tcp.c	7 May 2003 10:26:59 -0000
@@ -14,7 +14,8 @@
 	printf(
 "TCP v%s options:\n"
 " --tcp-flags [!] mask comp	match when TCP flags & mask == comp\n"
-"				(Flags: SYN ACK FIN RST URG PSH ALL NONE)\n"
+"				(Flags: SYN ACK FIN RST URG PSH ECE CWR\n"
+"					ALL NONE)\n"
 "[!] --syn			match when only SYN flag set\n"
 "				(equivalent to --tcp-flags SYN,RST,ACK SYN)\n"
 " --source-port [!] port[:port]\n"
@@ -97,7 +98,9 @@
     { "PSH", 0x08 },
     { "ACK", 0x10 },
     { "URG", 0x20 },
-    { "ALL", 0x3F },
+    { "ECE", 0x40 },
+    { "CWR", 0x80 },
+    { "ALL", 0xFF },
     { "NONE", 0 },
 };
