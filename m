From: Internet Protocol version Six <inet6@mail.be>
Subject: Re: --reject-with admin-prohib not working
Date: Sat, 26 Jul 2003 04:28:37 +0200 (GMT+02:00)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1303417476.1059186517500.JavaMail.Administrator@pumbaa>
References: <1052431003.1059171322687.JavaMail.Administrator@pumbaa>
Reply-To: Internet Protocol version Six <inet6@mail.be>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_318_1279742592.1059185354937"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1052431003.1059171322687.JavaMail.Administrator@pumbaa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

------=_Part_318_1279742592.1059185354937
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I seem to have found the missing patch to iptables that is not in PoM
I've attached it, it is for iptables-1.2.8

> ----------------------------------------
> From: Internet Protocol version Six <inet6@mail.be>
> Sent: Sat Jul 26 00:15:22 GMT+02:00 2003
> To: <netfilter-devel@lists.netfilter.org>
> Subject: --reject-with admin-prohib not working
> 
> 
> Hello all,
> 
> like the subject says, it is not working for me, I applied the PoM patch to the kernel, compiled the kernel, even recompiled iptables and it still gives me "iptables v1.2.8: unknown reject type `admin-prohib'"
> 
> Is there some patch that needs to be applied to iptables itself? Because I can't find one

-----------------------------------------------------
Mail.be, WebMail and Virtual Office
http://www.mail.be

------=_Part_318_1279742592.1059185354937
Content-Type: text/plain; name=iptables-1.2.8-admin-prohib.patch
Content-Transfer-Encoding: 7bit
Content-Description: File Attachment: iptables-1.2.8-admin-prohib.patch
Content-Disposition: attachment; filename=iptables-1.2.8-admin-prohib.patch

diff -urN iptables-1.2.8/INCOMPATIBILITIES iptables-1.2.8+admin-prohib/INCOMPATIBILITIES
--- iptables-1.2.8/INCOMPATIBILITIES    Thu Jan  1 01:00:00 1970
+++ iptables-1.2.8+admin-prohib/INCOMPATIBILITIES       Sat Jul 26 04:02:28 2003
@@ -0,0 +1,6 @@
+INCOMPATIBILITIES:
+
+- The REJECT target has an '--reject-with admin-prohib' option which used
+  with kernels that do not support it, will result in a plain DROP instead
+  of REJECT.  Use with caution.
+  Kernels that do support it:
diff -urN iptables-1.2.8/extensions/libipt_REJECT.c iptables-1.2.8+admin-prohib/extensions/libipt_REJECT.c
--- iptables-1.2.8/extensions/libipt_REJECT.c   Wed May 29 15:08:16 2002
+++ iptables-1.2.8+admin-prohib/extensions/libipt_REJECT.c      Sat Jul 26 03:43:46 2003
@@ -9,6 +9,16 @@
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
+#include <linux/version.h>
+
+/* If we are compiling against a kernel that does not support
+ * IPT_ICMP_ADMIN_PROHIBITED, we are emulating it.
+ * The result will be a plain DROP of the packet instead of
+ * reject. -- Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ */
+#ifndef IPT_ICMP_ADMIN_PROHIBITED
+#define IPT_ICMP_ADMIN_PROHIBITED IPT_TCP_RESET + 1
+#endif

 struct reject_names {
        const char *name;
@@ -35,7 +45,9 @@
        {"icmp-host-prohibited", "host-prohib",
         IPT_ICMP_HOST_PROHIBITED, "ICMP host prohibited"},
        {"tcp-reset", "tcp-reset",
-        IPT_TCP_RESET, "TCP RST packet"}
+        IPT_TCP_RESET, "TCP RST packet"},
+       {"icmp-admin-prohibited", "admin-prohib",
+        IPT_ICMP_ADMIN_PROHIBITED, "ICMP administratively prohibited (*)"}
 };

 static void
@@ -64,6 +76,8 @@
 "                                a reply packet according to type:\n");

        print_reject_types();
+
+       printf("(*) See man page or read the INCOMPATIBILITES file for compatibility issues.\n");
 }

 static struct option opts[] = {
diff -urN iptables-1.2.8/iptables.8 iptables-1.2.8+admin-prohib/iptables.8
--- iptables-1.2.8/iptables.8   Mon Mar  3 23:23:22 2003
+++ iptables-1.2.8+admin-prohib/iptables.8      Sat Jul 26 03:47:31 2003
@@ -852,8 +852,9 @@
 .BR icmp-host-unreachable ,
 .BR icmp-port-unreachable ,
 .BR icmp-proto-unreachable ,
-.BR "icmp-net-prohibited or"
-.BR icmp-host-prohibited ,
+.BR icmp-net-prohibited ,
+.BR "icmp-host-prohibited or"
+.BR "icmp-admin-prohibited (*)"
 which return the appropriate ICMP error message (\fBport-unreachable\fP is
 the default).  The option
 .B tcp-reset
@@ -862,6 +863,8 @@
 .I ident
 (113/tcp) probes which frequently occur when sending mail to broken mail
 hosts (which won't accept your mail otherwise).
+.TP
+(*) Using icmp-admin-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
 .SS SNAT
 This target is only valid in the
 .B nat

------=_Part_318_1279742592.1059185354937--
