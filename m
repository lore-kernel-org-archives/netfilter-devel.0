From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/5]: Remove CONFIG_IP_NF_NAT_LOCAL config option
Date: Sat, 27 Nov 2004 13:48:20 +0100
Message-ID: <41A87794.1000907@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060506000309060700010208"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------060506000309060700010208
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Remove CONFIG_IP_NF_NAT_LOCAL config option, necessary for
the fourth patch.



--------------060506000309060700010208
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/27 12:20:20+01:00 kaber@coreworks.de 
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_standalone.c
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +4 -22
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_rule.c
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -11
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -8
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/Kconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -14
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_nat.h
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -5
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/sparc64/defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc64/defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc64/configs/pSeries_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc64/configs/iSeries_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc64/configs/g5_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/pplus_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/pmac_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/pcore_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/menf1_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/k2_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/ibmchrp_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/common_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/apus_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/adir_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/parisc/configs/n4000_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/parisc/configs/c3000_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/parisc/configs/a500_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/mips/defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/mips/configs/rm200_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/mips/configs/ip22_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/m68k/configs/sun3x_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/m68k/configs/sun3_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/m68k/configs/q40_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/m68k/configs/mvme16x_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/m68k/configs/mvme147_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/m68k/configs/mac_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/m68k/configs/hp300_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/m68k/configs/bvme6000_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/m68k/configs/atari_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/m68k/configs/apollo_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/m68k/configs/amiga_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/i386/defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/arm/configs/ixp4xx_defconfig
#   2004/11/27 12:20:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/arm/configs/ebsa110_defconfig
#   2004/11/27 12:20:12+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/alpha/defconfig
#   2004/11/27 12:20:12+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/arch/alpha/defconfig b/arch/alpha/defconfig
--- a/arch/alpha/defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/alpha/defconfig	2004-11-27 13:37:43 +01:00
@@ -411,7 +411,6 @@
 # CONFIG_IP_NF_TARGET_REDIRECT is not set
 # CONFIG_IP_NF_TARGET_NETMAP is not set
 # CONFIG_IP_NF_TARGET_SAME is not set
-# CONFIG_IP_NF_NAT_LOCAL is not set
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/arm/configs/ebsa110_defconfig b/arch/arm/configs/ebsa110_defconfig
--- a/arch/arm/configs/ebsa110_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/arm/configs/ebsa110_defconfig	2004-11-27 13:37:43 +01:00
@@ -239,7 +239,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=y
 CONFIG_IP_NF_TARGET_NETMAP=y
 CONFIG_IP_NF_TARGET_SAME=y
-# CONFIG_IP_NF_NAT_LOCAL is not set
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_NAT_IRC=y
 CONFIG_IP_NF_NAT_FTP=y
diff -Nru a/arch/arm/configs/ixp4xx_defconfig b/arch/arm/configs/ixp4xx_defconfig
--- a/arch/arm/configs/ixp4xx_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/arm/configs/ixp4xx_defconfig	2004-11-27 13:37:43 +01:00
@@ -399,7 +399,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 # CONFIG_IP_NF_TARGET_NETMAP is not set
 # CONFIG_IP_NF_TARGET_SAME is not set
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/i386/defconfig b/arch/i386/defconfig
--- a/arch/i386/defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/i386/defconfig	2004-11-27 13:37:43 +01:00
@@ -534,7 +534,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=y
 CONFIG_IP_NF_TARGET_NETMAP=y
 CONFIG_IP_NF_TARGET_SAME=y
-# CONFIG_IP_NF_NAT_LOCAL is not set
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_MANGLE=y
 CONFIG_IP_NF_TARGET_TOS=y
diff -Nru a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
--- a/arch/m68k/configs/amiga_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/m68k/configs/amiga_defconfig	2004-11-27 13:37:43 +01:00
@@ -356,7 +356,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
--- a/arch/m68k/configs/apollo_defconfig	2004-11-27 13:37:44 +01:00
+++ b/arch/m68k/configs/apollo_defconfig	2004-11-27 13:37:44 +01:00
@@ -281,7 +281,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
--- a/arch/m68k/configs/atari_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/m68k/configs/atari_defconfig	2004-11-27 13:37:43 +01:00
@@ -311,7 +311,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
--- a/arch/m68k/configs/bvme6000_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/m68k/configs/bvme6000_defconfig	2004-11-27 13:37:43 +01:00
@@ -281,7 +281,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
--- a/arch/m68k/configs/hp300_defconfig	2004-11-27 13:37:44 +01:00
+++ b/arch/m68k/configs/hp300_defconfig	2004-11-27 13:37:44 +01:00
@@ -282,7 +282,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
--- a/arch/m68k/configs/mac_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/m68k/configs/mac_defconfig	2004-11-27 13:37:43 +01:00
@@ -318,7 +318,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
--- a/arch/m68k/configs/mvme147_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/m68k/configs/mvme147_defconfig	2004-11-27 13:37:43 +01:00
@@ -282,7 +282,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
--- a/arch/m68k/configs/mvme16x_defconfig	2004-11-27 13:37:44 +01:00
+++ b/arch/m68k/configs/mvme16x_defconfig	2004-11-27 13:37:44 +01:00
@@ -281,7 +281,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
--- a/arch/m68k/configs/q40_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/m68k/configs/q40_defconfig	2004-11-27 13:37:43 +01:00
@@ -336,7 +336,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
--- a/arch/m68k/configs/sun3_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/m68k/configs/sun3_defconfig	2004-11-27 13:37:43 +01:00
@@ -270,7 +270,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
--- a/arch/m68k/configs/sun3x_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/m68k/configs/sun3x_defconfig	2004-11-27 13:37:43 +01:00
@@ -281,7 +281,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/mips/configs/ip22_defconfig b/arch/mips/configs/ip22_defconfig
--- a/arch/mips/configs/ip22_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/mips/configs/ip22_defconfig	2004-11-27 13:37:43 +01:00
@@ -342,7 +342,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
--- a/arch/mips/configs/rm200_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/mips/configs/rm200_defconfig	2004-11-27 13:37:43 +01:00
@@ -437,7 +437,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/mips/defconfig b/arch/mips/defconfig
--- a/arch/mips/defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/mips/defconfig	2004-11-27 13:37:43 +01:00
@@ -342,7 +342,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/parisc/configs/a500_defconfig b/arch/parisc/configs/a500_defconfig
--- a/arch/parisc/configs/a500_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/parisc/configs/a500_defconfig	2004-11-27 13:37:43 +01:00
@@ -338,7 +338,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/parisc/configs/c3000_defconfig b/arch/parisc/configs/c3000_defconfig
--- a/arch/parisc/configs/c3000_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/parisc/configs/c3000_defconfig	2004-11-27 13:37:43 +01:00
@@ -396,7 +396,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/parisc/configs/n4000_defconfig b/arch/parisc/configs/n4000_defconfig
--- a/arch/parisc/configs/n4000_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/parisc/configs/n4000_defconfig	2004-11-27 13:37:43 +01:00
@@ -331,7 +331,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/adir_defconfig b/arch/ppc/configs/adir_defconfig
--- a/arch/ppc/configs/adir_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/ppc/configs/adir_defconfig	2004-11-27 13:37:43 +01:00
@@ -302,7 +302,6 @@
 CONFIG_IP_NF_NAT_NEEDED=y
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/apus_defconfig b/arch/ppc/configs/apus_defconfig
--- a/arch/ppc/configs/apus_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/ppc/configs/apus_defconfig	2004-11-27 13:37:44 +01:00
@@ -354,7 +354,6 @@
 CONFIG_IP_NF_NAT_NEEDED=y
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/common_defconfig b/arch/ppc/configs/common_defconfig
--- a/arch/ppc/configs/common_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/ppc/configs/common_defconfig	2004-11-27 13:37:43 +01:00
@@ -457,7 +457,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/ibmchrp_defconfig b/arch/ppc/configs/ibmchrp_defconfig
--- a/arch/ppc/configs/ibmchrp_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/ppc/configs/ibmchrp_defconfig	2004-11-27 13:37:43 +01:00
@@ -367,7 +367,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/k2_defconfig b/arch/ppc/configs/k2_defconfig
--- a/arch/ppc/configs/k2_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/ppc/configs/k2_defconfig	2004-11-27 13:37:43 +01:00
@@ -319,7 +319,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 # CONFIG_IP_NF_TARGET_NETMAP is not set
 # CONFIG_IP_NF_TARGET_SAME is not set
-# CONFIG_IP_NF_NAT_LOCAL is not set
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_NAT_FTP=m
 # CONFIG_IP_NF_MANGLE is not set
diff -Nru a/arch/ppc/configs/menf1_defconfig b/arch/ppc/configs/menf1_defconfig
--- a/arch/ppc/configs/menf1_defconfig	2004-11-27 13:37:44 +01:00
+++ b/arch/ppc/configs/menf1_defconfig	2004-11-27 13:37:44 +01:00
@@ -249,7 +249,6 @@
 CONFIG_IP_NF_NAT_NEEDED=y
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/pcore_defconfig b/arch/ppc/configs/pcore_defconfig
--- a/arch/ppc/configs/pcore_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/ppc/configs/pcore_defconfig	2004-11-27 13:37:43 +01:00
@@ -332,7 +332,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 # CONFIG_IP_NF_TARGET_NETMAP is not set
 # CONFIG_IP_NF_TARGET_SAME is not set
-# CONFIG_IP_NF_NAT_LOCAL is not set
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/pmac_defconfig b/arch/ppc/configs/pmac_defconfig
--- a/arch/ppc/configs/pmac_defconfig	2004-11-27 13:37:44 +01:00
+++ b/arch/ppc/configs/pmac_defconfig	2004-11-27 13:37:44 +01:00
@@ -479,7 +479,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/pplus_defconfig b/arch/ppc/configs/pplus_defconfig
--- a/arch/ppc/configs/pplus_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/ppc/configs/pplus_defconfig	2004-11-27 13:37:43 +01:00
@@ -343,7 +343,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 # CONFIG_IP_NF_TARGET_NETMAP is not set
 # CONFIG_IP_NF_TARGET_SAME is not set
-# CONFIG_IP_NF_NAT_LOCAL is not set
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_NAT_FTP=m
 # CONFIG_IP_NF_MANGLE is not set
diff -Nru a/arch/ppc/defconfig b/arch/ppc/defconfig
--- a/arch/ppc/defconfig	2004-11-27 13:37:44 +01:00
+++ b/arch/ppc/defconfig	2004-11-27 13:37:44 +01:00
@@ -464,7 +464,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc64/configs/g5_defconfig b/arch/ppc64/configs/g5_defconfig
--- a/arch/ppc64/configs/g5_defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/ppc64/configs/g5_defconfig	2004-11-27 13:37:43 +01:00
@@ -440,7 +440,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=y
 CONFIG_IP_NF_TARGET_NETMAP=y
 CONFIG_IP_NF_TARGET_SAME=y
-# CONFIG_IP_NF_NAT_LOCAL is not set
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_MANGLE=y
 CONFIG_IP_NF_TARGET_TOS=y
diff -Nru a/arch/ppc64/configs/iSeries_defconfig b/arch/ppc64/configs/iSeries_defconfig
--- a/arch/ppc64/configs/iSeries_defconfig	2004-11-27 13:37:44 +01:00
+++ b/arch/ppc64/configs/iSeries_defconfig	2004-11-27 13:37:44 +01:00
@@ -316,7 +316,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc64/configs/pSeries_defconfig b/arch/ppc64/configs/pSeries_defconfig
--- a/arch/ppc64/configs/pSeries_defconfig	2004-11-27 13:37:44 +01:00
+++ b/arch/ppc64/configs/pSeries_defconfig	2004-11-27 13:37:44 +01:00
@@ -408,7 +408,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc64/defconfig b/arch/ppc64/defconfig
--- a/arch/ppc64/defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/ppc64/defconfig	2004-11-27 13:37:43 +01:00
@@ -374,7 +374,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/sparc64/defconfig b/arch/sparc64/defconfig
--- a/arch/sparc64/defconfig	2004-11-27 13:37:43 +01:00
+++ b/arch/sparc64/defconfig	2004-11-27 13:37:43 +01:00
@@ -601,7 +601,6 @@
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_TARGET_NETMAP=m
 CONFIG_IP_NF_TARGET_SAME=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/include/linux/netfilter_ipv4/ip_nat.h b/include/linux/netfilter_ipv4/ip_nat.h
--- a/include/linux/netfilter_ipv4/ip_nat.h	2004-11-27 13:37:44 +01:00
+++ b/include/linux/netfilter_ipv4/ip_nat.h	2004-11-27 13:37:44 +01:00
@@ -11,13 +11,8 @@
 	IP_NAT_MANIP_DST
 };
 
-#ifndef CONFIG_IP_NF_NAT_LOCAL
-/* SRC manip occurs only on POST_ROUTING */
-#define HOOK2MANIP(hooknum) ((hooknum) != NF_IP_POST_ROUTING)
-#else
 /* SRC manip occurs POST_ROUTING or LOCAL_IN */
 #define HOOK2MANIP(hooknum) ((hooknum) != NF_IP_POST_ROUTING && (hooknum) != NF_IP_LOCAL_IN)
-#endif
 
 #define IP_NAT_RANGE_MAP_IPS 1
 #define IP_NAT_RANGE_PROTO_SPECIFIED 2
diff -Nru a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig	2004-11-27 13:37:44 +01:00
+++ b/net/ipv4/netfilter/Kconfig	2004-11-27 13:37:44 +01:00
@@ -504,20 +504,6 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_NAT_LOCAL
-	bool "NAT of local connections (READ HELP)"
-	depends on IP_NF_NAT
-	help
-	  This option enables support for NAT of locally originated connections. 
-	  Enable this if you need to use destination NAT on connections
-	  originating from local processes on the nat box itself.
-
-	  Please note that you will need a recent version (>= 1.2.6a)
-	  of the iptables userspace program in order to use this feature.
-	  See <http://www.iptables.org/> for download instructions.
-
-	  If unsure, say 'N'.
-
 config IP_NF_NAT_SNMP_BASIC
 	tristate "Basic SNMP-ALG support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && IP_NF_NAT
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-11-27 13:37:43 +01:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-11-27 13:37:43 +01:00
@@ -182,7 +182,6 @@
 	return 0;
 }
 
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 /* If it's really a local destination manip, it may need to do a
    source manip too. */
 static int
@@ -202,7 +201,6 @@
 	ip_rt_put(rt);
 	return 1;
 }
-#endif
 
 /* Simple way to iterate through all. */
 static inline int fake_cmp(const struct ip_conntrack *ct,
@@ -301,7 +299,6 @@
 			 * do_extra_mangle last time. */
 			*other_ipp = saved_ip;
 
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 			if (hooknum == NF_IP_LOCAL_OUT
 			    && *var_ipp != orig_dstip
 			    && !do_extra_mangle(*var_ipp, other_ipp)) {
@@ -312,7 +309,6 @@
 				 * anyway. */
 				continue;
 			}
-#endif
 
 			/* Count how many others map onto this. */
 			score = count_maps(tuple->src.ip, tuple->dst.ip,
@@ -356,13 +352,11 @@
 		else {
 			/* Only do extra mangle when required (breaks
                            socket binding) */
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 			if (tuple->dst.ip != mr->range[0].min_ip
 			    && hooknum == NF_IP_LOCAL_OUT
 			    && !do_extra_mangle(mr->range[0].min_ip,
 						&tuple->src.ip))
 				return NULL;
-#endif
 			tuple->dst.ip = mr->range[0].min_ip;
 		}
 	}
@@ -473,10 +467,8 @@
 static unsigned int opposite_hook[NF_IP_NUMHOOKS]
 = { [NF_IP_PRE_ROUTING] = NF_IP_POST_ROUTING,
     [NF_IP_POST_ROUTING] = NF_IP_PRE_ROUTING,
-#ifdef CONFIG_IP_NF_NAT_LOCAL
     [NF_IP_LOCAL_OUT] = NF_IP_LOCAL_IN,
     [NF_IP_LOCAL_IN] = NF_IP_LOCAL_OUT,
-#endif
 };
 
 unsigned int
diff -Nru a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_rule.c
--- a/net/ipv4/netfilter/ip_nat_rule.c	2004-11-27 13:37:43 +01:00
+++ b/net/ipv4/netfilter/ip_nat_rule.c	2004-11-27 13:37:43 +01:00
@@ -149,12 +149,8 @@
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
 		     || hooknum == NF_IP_LOCAL_OUT);
-#else
-	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING);
-#endif
 
 	ct = ip_conntrack_get(*pskb, &ctinfo);
 
@@ -232,13 +228,6 @@
 		return 0;
 	}
 	
-#ifndef CONFIG_IP_NF_NAT_LOCAL
-	if (hook_mask & (1 << NF_IP_LOCAL_OUT)) {
-		DEBUGP("DNAT: CONFIG_IP_NF_NAT_LOCAL not enabled\n");
-		return 0;
-	}
-#endif
-
 	return 1;
 }
 
diff -Nru a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
--- a/net/ipv4/netfilter/ip_nat_standalone.c	2004-11-27 13:37:43 +01:00
+++ b/net/ipv4/netfilter/ip_nat_standalone.c	2004-11-27 13:37:43 +01:00
@@ -128,16 +128,7 @@
 		WRITE_LOCK(&ip_nat_lock);
 		/* Seen it before?  This can happen for loopback, retrans,
 		   or local packets.. */
-		if (!(info->initialized & (1 << maniptype))
-#ifndef CONFIG_IP_NF_NAT_LOCAL
-		    /* If this session has already been confirmed we must not
-		     * touch it again even if there is no mapping set up.
-		     * Can only happen on local->local traffic with
-		     * CONFIG_IP_NF_NAT_LOCAL disabled.
-		     */
-		    && !(ct->status & IPS_CONFIRMED)
-#endif
-		    ) {
+		if (!(info->initialized & (1 << maniptype))) {
 			unsigned int ret;
 
 			if (ct->master
@@ -146,15 +137,14 @@
 				ret = call_expect(master_ct(ct), pskb, 
 						  hooknum, ct, info);
 			} else {
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 				/* LOCAL_IN hook doesn't have a chain!  */
 				if (hooknum == NF_IP_LOCAL_IN)
 					ret = alloc_null_binding(ct, info,
 								 hooknum);
 				else
-#endif
-				ret = ip_nat_rule_find(pskb, hooknum, in, out,
-						       ct, info);
+					ret = ip_nat_rule_find(pskb, hooknum,
+					                       in, out, ct,
+					                       info);
 			}
 
 			if (ret != NF_ACCEPT) {
@@ -234,7 +224,6 @@
 	return ip_nat_fn(hooknum, pskb, in, out, okfn);
 }
 
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 static unsigned int
 ip_nat_local_fn(unsigned int hooknum,
 		struct sk_buff **pskb,
@@ -260,7 +249,6 @@
 		return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
 	return ret;
 }
-#endif
 
 /* We must be after connection tracking and before packet filtering. */
 
@@ -282,7 +270,6 @@
 	.priority	= NF_IP_PRI_NAT_SRC,
 };
 
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 /* Before packet filtering, change destination */
 static struct nf_hook_ops ip_nat_local_out_ops = {
 	.hook		= ip_nat_local_fn,
@@ -300,7 +287,6 @@
 	.hooknum	= NF_IP_LOCAL_IN,
 	.priority	= NF_IP_PRI_NAT_SRC,
 };
-#endif
 
 /* Protocol registration. */
 int ip_nat_protocol_register(struct ip_nat_protocol *proto)
@@ -357,7 +343,6 @@
 		printk("ip_nat_init: can't register out hook.\n");
 		goto cleanup_inops;
 	}
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 	ret = nf_register_hook(&ip_nat_local_out_ops);
 	if (ret < 0) {
 		printk("ip_nat_init: can't register local out hook.\n");
@@ -368,16 +353,13 @@
 		printk("ip_nat_init: can't register local in hook.\n");
 		goto cleanup_localoutops;
 	}
-#endif
 	return ret;
 
  cleanup:
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 	nf_unregister_hook(&ip_nat_local_in_ops);
  cleanup_localoutops:
 	nf_unregister_hook(&ip_nat_local_out_ops);
  cleanup_outops:
-#endif
 	nf_unregister_hook(&ip_nat_out_ops);
  cleanup_inops:
 	nf_unregister_hook(&ip_nat_in_ops);

--------------060506000309060700010208--
