From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 2/18]: Remove CONFIG_IP_NF_NAT_LOCAL config option
Date: Mon, 20 Dec 2004 08:14:08 +0100
Message-ID: <41C67BC0.7080502@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060203040304070402050602"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------060203040304070402050602
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Remove CONFIG_IP_NF_NAT_LOCAL, required for forth patch
(Apply PRE_ROUTING manips in LOCAL_OUT for locally
generated icmp errors).


--------------060203040304070402050602
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 22:01:14+01:00 kaber@coreworks.de 
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_standalone.c
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +4 -23
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_rule.c
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +0 -11
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +0 -8
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/Config.in
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_nat.h
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +0 -5
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/sparc64/defconfig
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/s390/defconfig
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/defconfig
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/prpmc750_defconfig
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/pplus_defconfig
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/pmac_defconfig
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/pal4_defconfig
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/ibmchrp_defconfig
#   2004/12/05 22:01:13+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/common_defconfig
#   2004/12/05 22:01:12+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/briq_defconfig
#   2004/12/05 22:01:12+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/ppc/configs/apus_defconfig
#   2004/12/05 22:01:12+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/mips64/defconfig
#   2004/12/05 22:01:12+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/mips64/defconfig-ip27
#   2004/12/05 22:01:12+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/mips/defconfig-mtx-1
#   2004/12/05 22:01:12+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# arch/mips/defconfig-bosporus
#   2004/12/05 22:01:12+01:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# Documentation/Configure.help
#   2004/12/05 22:01:12+01:00 kaber@coreworks.de +0 -13
#   [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/Documentation/Configure.help b/Documentation/Configure.help
--- a/Documentation/Configure.help	2004-12-20 06:59:20 +01:00
+++ b/Documentation/Configure.help	2004-12-20 06:59:20 +01:00
@@ -3040,19 +3040,6 @@
   If you want to compile it as a module, say M here and read
   <file:Documentation/modules.txt>.  If unsure, say `N'.
 
-Local NAT support
-CONFIG_IP_NF_NAT_LOCAL
-  This option enables support for NAT of locally originated connections. 
-  Enable this if you need to use destination NAT on connections
-  originating from local processes on the nat box itself.
-
-  Please note that you will need a recent version (>= 1.2.6a)
-  of the iptables userspace program in order to use this feature.
-  See <http://www.iptables.org/> for download instructions.
-
-  If unsure, say 'N'.
-
-
 Full NAT (Network Address Translation)
 CONFIG_IP_NF_NAT
   The Full NAT option allows masquerading, port forwarding and other
diff -Nru a/arch/mips/defconfig-bosporus b/arch/mips/defconfig-bosporus
--- a/arch/mips/defconfig-bosporus	2004-12-20 06:59:20 +01:00
+++ b/arch/mips/defconfig-bosporus	2004-12-20 06:59:20 +01:00
@@ -341,7 +341,6 @@
 CONFIG_IP_NF_NAT_NEEDED=y
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
-CONFIG_IP_NF_NAT_LOCAL=y
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_MANGLE=m
 # CONFIG_IP_NF_TARGET_TOS is not set
diff -Nru a/arch/mips/defconfig-mtx-1 b/arch/mips/defconfig-mtx-1
--- a/arch/mips/defconfig-mtx-1	2004-12-20 06:59:20 +01:00
+++ b/arch/mips/defconfig-mtx-1	2004-12-20 06:59:20 +01:00
@@ -335,7 +335,6 @@
 CONFIG_IP_NF_NAT_NEEDED=y
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/mips64/defconfig b/arch/mips64/defconfig
--- a/arch/mips64/defconfig	2004-12-20 06:59:20 +01:00
+++ b/arch/mips64/defconfig	2004-12-20 06:59:20 +01:00
@@ -265,7 +265,6 @@
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_NAT_AMANDA=m
-CONFIG_IP_NF_NAT_LOCAL=y
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/mips64/defconfig-ip27 b/arch/mips64/defconfig-ip27
--- a/arch/mips64/defconfig-ip27	2004-12-20 06:59:20 +01:00
+++ b/arch/mips64/defconfig-ip27	2004-12-20 06:59:20 +01:00
@@ -265,7 +265,6 @@
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_NAT_AMANDA=m
-CONFIG_IP_NF_NAT_LOCAL=y
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/apus_defconfig b/arch/ppc/configs/apus_defconfig
--- a/arch/ppc/configs/apus_defconfig	2004-12-20 06:59:20 +01:00
+++ b/arch/ppc/configs/apus_defconfig	2004-12-20 06:59:20 +01:00
@@ -199,7 +199,6 @@
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_NAT_AMANDA=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/briq_defconfig b/arch/ppc/configs/briq_defconfig
--- a/arch/ppc/configs/briq_defconfig	2004-12-20 06:59:20 +01:00
+++ b/arch/ppc/configs/briq_defconfig	2004-12-20 06:59:20 +01:00
@@ -175,7 +175,6 @@
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_NAT_AMANDA=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/common_defconfig b/arch/ppc/configs/common_defconfig
--- a/arch/ppc/configs/common_defconfig	2004-12-20 06:59:20 +01:00
+++ b/arch/ppc/configs/common_defconfig	2004-12-20 06:59:20 +01:00
@@ -180,7 +180,6 @@
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_NAT_AMANDA=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/ibmchrp_defconfig b/arch/ppc/configs/ibmchrp_defconfig
--- a/arch/ppc/configs/ibmchrp_defconfig	2004-12-20 06:59:20 +01:00
+++ b/arch/ppc/configs/ibmchrp_defconfig	2004-12-20 06:59:20 +01:00
@@ -173,7 +173,6 @@
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_NAT_AMANDA=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/pal4_defconfig b/arch/ppc/configs/pal4_defconfig
--- a/arch/ppc/configs/pal4_defconfig	2004-12-20 06:59:20 +01:00
+++ b/arch/ppc/configs/pal4_defconfig	2004-12-20 06:59:20 +01:00
@@ -172,7 +172,6 @@
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_NAT_AMANDA=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/pmac_defconfig b/arch/ppc/configs/pmac_defconfig
--- a/arch/ppc/configs/pmac_defconfig	2004-12-20 06:59:20 +01:00
+++ b/arch/ppc/configs/pmac_defconfig	2004-12-20 06:59:20 +01:00
@@ -183,7 +183,6 @@
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_NAT_AMANDA=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/pplus_defconfig b/arch/ppc/configs/pplus_defconfig
--- a/arch/ppc/configs/pplus_defconfig	2004-12-20 06:59:20 +01:00
+++ b/arch/ppc/configs/pplus_defconfig	2004-12-20 06:59:20 +01:00
@@ -175,7 +175,6 @@
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_NAT_AMANDA=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/ppc/configs/prpmc750_defconfig b/arch/ppc/configs/prpmc750_defconfig
--- a/arch/ppc/configs/prpmc750_defconfig	2004-12-20 06:59:20 +01:00
+++ b/arch/ppc/configs/prpmc750_defconfig	2004-12-20 06:59:20 +01:00
@@ -183,7 +183,6 @@
 CONFIG_IP_NF_NAT_NEEDED=y
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_NAT_FTP=m
 # CONFIG_IP_NF_MANGLE is not set
diff -Nru a/arch/ppc/defconfig b/arch/ppc/defconfig
--- a/arch/ppc/defconfig	2004-12-20 06:59:20 +01:00
+++ b/arch/ppc/defconfig	2004-12-20 06:59:20 +01:00
@@ -180,7 +180,6 @@
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_NAT_AMANDA=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/s390/defconfig b/arch/s390/defconfig
--- a/arch/s390/defconfig	2004-12-20 06:59:20 +01:00
+++ b/arch/s390/defconfig	2004-12-20 06:59:20 +01:00
@@ -199,7 +199,6 @@
 CONFIG_IP_NF_NAT_NEEDED=y
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
-CONFIG_IP_NF_NAT_LOCAL=y
 # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/arch/sparc64/defconfig b/arch/sparc64/defconfig
--- a/arch/sparc64/defconfig	2004-12-20 06:59:20 +01:00
+++ b/arch/sparc64/defconfig	2004-12-20 06:59:20 +01:00
@@ -253,7 +253,6 @@
 CONFIG_IP_NF_TARGET_MASQUERADE=m
 CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_NAT_AMANDA=m
-# CONFIG_IP_NF_NAT_LOCAL is not set
 CONFIG_IP_NF_NAT_SNMP_BASIC=m
 CONFIG_IP_NF_NAT_IRC=m
 CONFIG_IP_NF_NAT_FTP=m
diff -Nru a/include/linux/netfilter_ipv4/ip_nat.h b/include/linux/netfilter_ipv4/ip_nat.h
--- a/include/linux/netfilter_ipv4/ip_nat.h	2004-12-20 06:59:20 +01:00
+++ b/include/linux/netfilter_ipv4/ip_nat.h	2004-12-20 06:59:20 +01:00
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
 
 /* 2.3.19 (I hope) will define this in linux/netfilter_ipv4.h. */
 #ifndef SO_ORIGINAL_DST
diff -Nru a/net/ipv4/netfilter/Config.in b/net/ipv4/netfilter/Config.in
--- a/net/ipv4/netfilter/Config.in	2004-12-20 06:59:20 +01:00
+++ b/net/ipv4/netfilter/Config.in	2004-12-20 06:59:20 +01:00
@@ -66,7 +66,6 @@
           define_tristate CONFIG_IP_NF_NAT_AMANDA $CONFIG_IP_NF_NAT
         fi
       fi
-      bool '    NAT of local connections (READ HELP)' CONFIG_IP_NF_NAT_LOCAL
       if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
         dep_tristate '    Basic SNMP-ALG support (EXPERIMENTAL)' CONFIG_IP_NF_NAT_SNMP_BASIC $CONFIG_IP_NF_NAT
       fi
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-12-20 06:59:20 +01:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-12-20 06:59:20 +01:00
@@ -198,7 +198,6 @@
 		return NULL;
 }
 
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 /* If it's really a local destination manip, it may need to do a
    source manip too. */
 static int
@@ -217,7 +216,6 @@
 	ip_rt_put(rt);
 	return 1;
 }
-#endif
 
 /* Simple way to iterate through all. */
 static inline int fake_cmp(const struct ip_nat_hash *i,
@@ -317,7 +315,6 @@
 			 * do_extra_mangle last time. */
 			*other_ipp = saved_ip;
 
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 			if (hooknum == NF_IP_LOCAL_OUT
 			    && *var_ipp != orig_dstip
 			    && !do_extra_mangle(*var_ipp, other_ipp)) {
@@ -328,7 +325,6 @@
 				 * anyway. */
 				continue;
 			}
-#endif
 
 			/* Count how many others map onto this. */
 			score = count_maps(tuple->src.ip, tuple->dst.ip,
@@ -372,13 +368,11 @@
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
@@ -501,10 +495,8 @@
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
--- a/net/ipv4/netfilter/ip_nat_rule.c	2004-12-20 06:59:20 +01:00
+++ b/net/ipv4/netfilter/ip_nat_rule.c	2004-12-20 06:59:20 +01:00
@@ -138,12 +138,8 @@
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
 		     || hooknum == NF_IP_LOCAL_OUT);
-#else
-	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING);
-#endif
 
 	ct = ip_conntrack_get(*pskb, &ctinfo);
 
@@ -221,13 +217,6 @@
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
--- a/net/ipv4/netfilter/ip_nat_standalone.c	2004-12-20 06:59:20 +01:00
+++ b/net/ipv4/netfilter/ip_nat_standalone.c	2004-12-20 06:59:20 +01:00
@@ -114,16 +114,7 @@
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
@@ -132,15 +123,14 @@
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
+					                       in, out,
+					                       ct, info);
 			}
 
 			if (ret != NF_ACCEPT) {
@@ -197,7 +187,6 @@
 	return ip_nat_fn(hooknum, pskb, in, out, okfn);
 }
 
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 static unsigned int
 ip_nat_local_fn(unsigned int hooknum,
 		struct sk_buff **pskb,
@@ -223,7 +212,6 @@
 		return ip_route_me_harder(pskb) == 0 ? ret : NF_DROP;
 	return ret;
 }
-#endif
 
 /* We must be after connection tracking and before packet filtering. */
 
@@ -233,15 +221,12 @@
 /* After packet filtering, change source */
 static struct nf_hook_ops ip_nat_out_ops
 = { { NULL, NULL }, ip_nat_out, PF_INET, NF_IP_POST_ROUTING, NF_IP_PRI_NAT_SRC};
-
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 /* Before packet filtering, change destination */
 static struct nf_hook_ops ip_nat_local_out_ops
 = { { NULL, NULL }, ip_nat_local_fn, PF_INET, NF_IP_LOCAL_OUT, NF_IP_PRI_NAT_DST };
 /* After packet filtering, change source for reply packets of LOCAL_OUT DNAT */
 static struct nf_hook_ops ip_nat_local_in_ops
 = { { NULL, NULL }, ip_nat_fn, PF_INET, NF_IP_LOCAL_IN, NF_IP_PRI_NAT_SRC };
-#endif
 
 /* Protocol registration. */
 int ip_nat_protocol_register(struct ip_nat_protocol *proto)
@@ -306,7 +291,6 @@
 		printk("ip_nat_init: can't register out hook.\n");
 		goto cleanup_inops;
 	}
-#ifdef CONFIG_IP_NF_NAT_LOCAL
 	ret = nf_register_hook(&ip_nat_local_out_ops);
 	if (ret < 0) {
 		printk("ip_nat_init: can't register local out hook.\n");
@@ -317,16 +301,13 @@
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

--------------060203040304070402050602--
