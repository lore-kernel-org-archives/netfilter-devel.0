From: Jens Hektor <hektor@rz.rwth-aachen.de>
Subject: [PATCH] RFC 1812 recommended reject codes Was:[ANNOUNCE] Current
 netfilter/iptables development
Date: Wed, 08 Jan 2003 08:40:16 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1BD5E0.2030006@rz.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_wL2Cb5Hw6UkVNUKi23ermg)"
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

This is a multi-part message in MIME format.

--Boundary_(ID_wL2Cb5Hw6UkVNUKi23ermg)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Hi,

I am submitting the patches hoping they are in the correct form
and get into the queue for 2.4.21.

Credits to Maciej Soltysiak also who worked on the same problem.

Best regards, Jens Hektor

-- 
Jens Hektor, RWTH Aachen, Rechenzentrum, Seffenter Weg 23, 52074 Aachen
Computing Center, Aachen University, network operation & security
mailto:hektor@RZ.RWTH-Aachen.DE, Tel.: +49 241 80 29206, Raum: 2.35

--Boundary_(ID_wL2Cb5Hw6UkVNUKi23ermg)
Content-type: text/plain; name=ipt_REJECT.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=ipt_REJECT.patch

*** linux-2.4.20/include/linux/netfilter_ipv4/ipt_REJECT.h.orig	2002-11-29 07:32:28.000000000 +0100
--- linux-2.4.20/include/linux/netfilter_ipv4/ipt_REJECT.h	2002-11-29 19:42:47.000000000 +0100
***************
*** 9,15 ****
  	IPT_ICMP_ECHOREPLY,
  	IPT_ICMP_NET_PROHIBITED,
  	IPT_ICMP_HOST_PROHIBITED,
! 	IPT_TCP_RESET
  };
  
  struct ipt_reject_info {
--- 9,16 ----
  	IPT_ICMP_ECHOREPLY,
  	IPT_ICMP_NET_PROHIBITED,
  	IPT_ICMP_HOST_PROHIBITED,
! 	IPT_TCP_RESET,
! 	IPT_ICMP_ADMIN_PROHIBITED
  };
  
  struct ipt_reject_info {
*** linux-2.4.20/net/ipv4/netfilter/ipt_REJECT.c.orig	2002-11-29 07:03:27.000000000 +0100
--- linux-2.4.20/net/ipv4/netfilter/ipt_REJECT.c	2002-11-29 07:07:14.000000000 +0100
***************
*** 308,313 ****
--- 308,316 ----
  	case IPT_ICMP_HOST_PROHIBITED:
      		send_unreach(*pskb, ICMP_HOST_ANO);
      		break;
+ 	case IPT_ICMP_ADMIN_PROHIBITED:
+     		send_unreach(*pskb, ICMP_PKT_FILTERED);
+     		break;
  	case IPT_TCP_RESET:
  		send_reset(*pskb, hooknum == NF_IP_LOCAL_IN);
  	case IPT_ICMP_ECHOREPLY:

--Boundary_(ID_wL2Cb5Hw6UkVNUKi23ermg)
Content-type: text/plain; name=ipt_REJECT.patch.help
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=ipt_REJECT.patch.help

Author: Jens Hektor <hektor@rz.rwth-aachen.de>
Status: Trivial.

Adds the possibility of sending RFC 1812 recommended reject codes
into the kernel code.  (ICMP destination unreachable, code 13, 
see RFC 1812, p 81)

Backward compatibility with older iptables
versions preserved by appending to the enum.

--Boundary_(ID_wL2Cb5Hw6UkVNUKi23ermg)
Content-type: text/plain; name=libipt_REJECT.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libipt_REJECT.patch

*** iptables-1.2.7a/extensions/libipt_REJECT.c.orig	2002-11-29 19:38:01.000000000 +0100
--- iptables-1.2.7a/extensions/libipt_REJECT.c	2002-12-02 06:51:31.000000000 +0100
***************
*** 7,12 ****
--- 7,14 ----
  #include <stdlib.h>
  #include <getopt.h>
  #include <iptables.h>
+ #include <linux/version.h>
+ #include <sys/utsname.h>
  #include <linux/netfilter_ipv4/ip_tables.h>
  #include <linux/netfilter_ipv4/ipt_REJECT.h>
  
***************
*** 35,43 ****
  	{"icmp-host-prohibited", "host-prohib",
  	 IPT_ICMP_HOST_PROHIBITED, "ICMP host prohibited"},
  	{"tcp-reset", "tcp-reset",
! 	 IPT_TCP_RESET, "TCP RST packet"}
  };
  
  static void
  print_reject_types()
  {
--- 37,53 ----
  	{"icmp-host-prohibited", "host-prohib",
  	 IPT_ICMP_HOST_PROHIBITED, "ICMP host prohibited"},
  	{"tcp-reset", "tcp-reset",
! 	 IPT_TCP_RESET, "TCP RST packet"},
! /* #if to fix compiletime compatibility, adjust version to reflect the include of the kernel patch into the main tree */
! #if ((LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,21) && LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))||LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,99))
! 	{"icmp-admin-prohibited", "admin-prohib",
! 	 IPT_ICMP_ADMIN_PROHIBITED, "ICMP administratively prohibited"}
! #endif
  };
  
+ static
+ int icmp_admin_prohib_enabled = 0 ;
+ 
  static void
  print_reject_types()
  {
***************
*** 46,53 ****
  	printf("Valid reject types:\n");
  
  	for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++) {
! 		printf("    %-25s\t%s\n", reject_table[i].name, reject_table[i].desc);
! 		printf("    %-25s\talias\n", reject_table[i].alias);
  	}
  	printf("\n");
  }
--- 56,65 ----
  	printf("Valid reject types:\n");
  
  	for (i = 0; i < sizeof(reject_table)/sizeof(struct reject_names); i++) {
! 		if ((strcmp ( reject_table[i].name, "icmp-admin-prohibited" ) == 0) && icmp_admin_prohib_enabled) {
! 			printf("    %-25s\t%s\n", reject_table[i].name, reject_table[i].desc);
! 			printf("    %-25s\talias\n", reject_table[i].alias);
! 		}
  	}
  	printf("\n");
  }
***************
*** 103,110 ****
  		for (i = 0; i < limit; i++) {
  			if ((strncasecmp(reject_table[i].name, optarg, strlen(optarg)) == 0)
  			    || (strncasecmp(reject_table[i].alias, optarg, strlen(optarg)) == 0)) {
! 				reject->with = reject_table[i].with;
! 				return 1;
  			}
  		}
  		/* This due to be dropped late in 2.4 pre-release cycle --RR */
--- 115,127 ----
  		for (i = 0; i < limit; i++) {
  			if ((strncasecmp(reject_table[i].name, optarg, strlen(optarg)) == 0)
  			    || (strncasecmp(reject_table[i].alias, optarg, strlen(optarg)) == 0)) {
! 				if (reject_table[i].with==IPT_ICMP_ADMIN_PROHIBITED && !icmp_admin_prohib_enabled) {
! 					exit_error(PARAMETER_PROBLEM,
! 						"icmp-admin-prohibited not with this kernel version");
! 				} else {
! 					reject->with = reject_table[i].with;
! 					return 1;
! 				}
  			}
  		}
  		/* This due to be dropped late in 2.4 pre-release cycle --RR */
***************
*** 174,178 ****
--- 191,205 ----
  
  void _init(void)
  {
+ 	struct utsname buf ;
+ 	int a, b, c ;
+ 
+ 	/* This is to fix run-time compatibility with kernels that
+            are not compatible with this version of iptables */
+ 	uname(&buf);
+ 	sscanf (buf.release, "%d.%d.%d", &a, &b, &c);
+ 	if ((a==2 && b==4 && c>=21) || (a==2 && b==5 && c>=99 ))
+ 		icmp_admin_prohib_enabled = 1;
+ 
  	register_target(&reject);
  }

--Boundary_(ID_wL2Cb5Hw6UkVNUKi23ermg)
Content-type: text/plain; name=libipt_REJECT.patch.help
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=libipt_REJECT.patch.help

Author: Jens Hektor <hektor@rz.rwth-aachen.de>
Status: It Works For Me.

This patch adds a new option for --reject-with, namely
"icmp-admin-prohibited" or short "admin-prohib" to enable
RFC 1812 compatible reject codes.

While the actual code to enable this feature is trivial
most of the code in this patch is to preserve backward 
compatibility of a new iptables version running or compiling
on an older kernel.

Assumption in this patch is that 2.4.21 and 2.5.99 support 
this feature already in the kernel.

--Boundary_(ID_wL2Cb5Hw6UkVNUKi23ermg)--
