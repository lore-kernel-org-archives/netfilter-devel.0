From: Jens Hektor <hektor@rz.rwth-aachen.de>
Subject: Re: --reject-with admin-prohib - Suggested Solution
Date: Wed, 04 Dec 2002 06:43:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DED9601.6070603@rz.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

working on the same problem as Maciej Soltysiak I personally
derived the same changes for the kernel as Maciej. I think
the kernel patches are safe (the new enum type field was
appended and should not brake any compatibility issue in the
kernel).

For the iptables application I derived a patch a bit more
voluminous taking care of backwards compatibility:

-----------------------------------------

--- iptables-1.2.7a/extensions/libipt_REJECT.c.orig     2002-11-29 19:38:01.000000000 +0100
+++ iptables-1.2.7a/extensions/libipt_REJECT.c  2002-12-02 06:51:31.000000000 +0100
@@ -7,6 +7,8 @@
  #include <stdlib.h>
  #include <getopt.h>
  #include <iptables.h>
+#include <linux/version.h>
+#include <sys/utsname.h>
  #include <linux/netfilter_ipv4/ip_tables.h>
  #include <linux/netfilter_ipv4/ipt_REJECT.h>

@@ -35,9 +37,17 @@
         {"icmp-host-prohibited", "host-prohib",
          IPT_ICMP_HOST_PROHIBITED, "ICMP host prohibited"},
         {"tcp-reset", "tcp-reset",
-        IPT_TCP_RESET, "TCP RST packet"}
+        IPT_TCP_RESET, "TCP RST packet"},
+/* #if to fix compiletime compatibility, adjust version to reflect the include of the kernel patch into the main tree */
+#if ((LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,20) && LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))||LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,99))
+       {"icmp-admin-prohibited", "admin-prohib",
+        IPT_ICMP_ADMIN_PROHIBITED, "ICMP administratively prohibited"}
+#endif
  };

+static
+int icmp_admin_prohib_enabled = 0 ;
+
  static void
  print_reject_types()
  {
@@ -46,8 +56,10 @@
         printf("Valid reject types:\n");

         for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++) {
-               printf("    %-25s\t%s\n", reject_table[i].name, reject_table[i].desc);
-               printf("    %-25s\talias\n", reject_table[i].alias);
+               if ((strcmp ( reject_table[i].name, "icmp-admin-prohibited" ) == 0) && icmp_admin_prohib_enabled) {
+                       printf("    %-25s\t%s\n", reject_table[i].name, reject_table[i].desc);
+                       printf("    %-25s\talias\n", reject_table[i].alias);
+               }
         }
         printf("\n");
  }
@@ -103,8 +115,13 @@
                 for (i = 0; i < limit; i++) {
                         if ((strncasecmp(reject_table[i].name, optarg, strlen(optarg)) == 0)
                             || (strncasecmp(reject_table[i].alias, optarg, strlen(optarg)) == 0)) {
-                               reject->with = reject_table[i].with;
-                               return 1;
+                               if (reject_table[i].with==IPT_ICMP_ADMIN_PROHIBITED && !icmp_admin_prohib_enabled) {
+                                       exit_error(PARAMETER_PROBLEM,
+                                               "icmp-admin-prohibited not with this kernel version");
+                               } else {
+                                       reject->with = reject_table[i].with;
+                                       return 1;
+                               }
                         }
                 }
                 /* This due to be dropped late in 2.4 pre-release cycle --RR */
@@ -174,5 +191,15 @@

  void _init(void)
  {
+       struct utsname buf ;
+       int a, b, c ;
+
+       /* This is to fix run-time compatibility with kernels that
+           are not compatible with this version of iptables */
+       uname(&buf);
+       sscanf (buf.release, "%d.%d.%d", &a, &b, &c);
+       if ((a==2 && b==4 && c>=20) || (a==2 && b==5 && c>=99 ))
+               icmp_admin_prohib_enabled = 1;
+
         register_target(&reject);
  }

-----------------------------------------

This patch only adds the new reject type to the iptables code
depending on the kernel compiled on, thereby introducing
the same problematic compiletime dependancy as Maciej's patch,
but avoiding the ugly #define IPT_ICMP_ADMIN_PROHIBITED

Have compiled it on an admin-prohibited enabled kernel there
could be someone having running it on an older kernel.

So the rest of my patch tries to fix that but clearly this
is more ugly code (runtime checking the kernel version, even
a runtime error if someone tries to set admin-prohibited
on an older kernel). My patch reflects 2.4.20 and 2.5.99 as
admin-prohibited enabled kernel versions.

Personally I would prefer a version without checks and a
clear advice like "this version of iptables requires kernel
2.4.X/2.5.Y or better", like Jozsef Kadlecsik suggested.

Best regards,

Jens Hektor
