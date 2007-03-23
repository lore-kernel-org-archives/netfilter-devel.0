From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/12]: Remove changelogs and CVS IDs
Date: Fri, 23 Mar 2007 15:05:00 +0100 (MET)
Message-ID: <20070323140434.22987.50111.sendpatchset@localhost.localdomain>
References: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Remove changelogs and CVS IDs

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7d6eb2567f5694088bda13109f45b6b16ef1e21d
tree d91c09da8ceaad7571568c8969c3c4b38e7587c3
parent 3231f075945001667eafaf325abab8c992b3d1e4
author Patrick McHardy <kaber@trash.net> Thu, 22 Mar 2007 23:00:33 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 23 Mar 2007 11:00:20 +0100

 net/ipv4/netfilter/ip_queue.c                  |   12 ------------
 net/ipv4/netfilter/ip_tables.c                 |    6 ------
 net/ipv4/netfilter/ipt_ECN.c                   |    2 --
 net/ipv4/netfilter/ipt_REJECT.c                |    2 --
 net/ipv4/netfilter/ipt_SAME.c                  |   15 ---------------
 net/ipv4/netfilter/ipt_ULOG.c                  |   16 ----------------
 net/ipv4/netfilter/ipt_ecn.c                   |    2 --
 net/ipv4/netfilter/ipt_ttl.c                   |    2 --
 net/ipv4/netfilter/iptable_mangle.c            |    2 --
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 --------
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    5 -----
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |    4 ----
 net/ipv6/netfilter/ip6_queue.c                 |   12 ------------
 net/ipv6/netfilter/ip6_tables.c                |    9 ---------
 net/ipv6/netfilter/ip6table_mangle.c           |    2 --
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   11 -----------
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    7 -------
 net/netfilter/core.c                           |    4 ----
 net/netfilter/nf_conntrack_core.c              |   18 ------------------
 net/netfilter/nf_conntrack_ftp.c               |    6 ------
 net/netfilter/nf_conntrack_netlink.c           |    5 -----
 net/netfilter/nf_conntrack_proto_generic.c     |    5 -----
 net/netfilter/nf_conntrack_proto_sctp.c        |    9 ---------
 net/netfilter/nf_conntrack_proto_tcp.c         |   18 ------------------
 net/netfilter/nf_conntrack_proto_udp.c         |    5 -----
 net/netfilter/nf_conntrack_standalone.c        |   11 -----------
 net/netfilter/nfnetlink_log.c                  |    5 -----
 net/netfilter/xt_DSCP.c                        |    2 --
 net/netfilter/xt_connbytes.c                   |    9 ---------
 net/netfilter/xt_dscp.c                        |    2 --
 net/netfilter/xt_helper.c                      |    3 ---
 net/netfilter/xt_limit.c                       |    7 -------
 net/netfilter/xt_realm.c                       |    2 --
 33 files changed, 0 insertions(+), 228 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 17f7c98..cd8fec0 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -8,18 +8,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 2000-03-27: Simplified code (thanks to Andi Kleen for clues).
- * 2000-05-20: Fixed notifier problems (following Miguel Freitas' report).
- * 2000-06-19: Fixed so nfmark is copied to metadata (reported by Sebastian
- *             Zander).
- * 2000-08-01: Added Nick Williams' MAC support.
- * 2002-06-25: Code cleanup.
- * 2005-01-10: Added /proc counter for dropped packets; fixed so
- *             packets aren't delivered to user space if they're going
- *             to be dropped.
- * 2005-05-26: local_bh_{disable,enable} around nf_reinject (Harald Welte)
- *
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 39ab8ae..e3f83bf 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -7,12 +7,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 19 Jan 2002 Harald Welte <laforge@gnumonks.org>
- * 	- increase module usage count as soon as we have rules inside
- * 	  a table
- * 08 Oct 2005 Harald Welte <lafore@netfilter.org>
- * 	- Generalize into "x_tables" layer and "{ip,ip6,arp}_tables"
  */
 #include <linux/cache.h>
 #include <linux/capability.h>
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 97c0e53..918ca92 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -5,8 +5,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * ipt_ECN.c,v 1.5 2002/08/18 19:36:51 laforge Exp
 */
 
 #include <linux/in.h>
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 1399e7c..9041e07 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -1,7 +1,5 @@
 /*
  * This is a module which is used for rejecting packets.
- * Added support for customized reject packets (Jozsef Kadlecsik).
- * Added support for ICMP type-3-code-13 (Maciej Soltysiak). [RFC 1812]
  */
 
 /* (C) 1999-2001 Paul `Rusty' Russell
diff --git a/net/ipv4/netfilter/ipt_SAME.c b/net/ipv4/netfilter/ipt_SAME.c
index fe76ffc..511e5ff 100644
--- a/net/ipv4/netfilter/ipt_SAME.c
+++ b/net/ipv4/netfilter/ipt_SAME.c
@@ -7,21 +7,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 010320 Martin Josefsson <gandalf@wlug.westbo.se>
- * 	* copied ipt_BALANCE.c to ipt_SAME.c and changed a few things.
- * 010728 Martin Josefsson <gandalf@wlug.westbo.se>
- * 	* added --nodst to not include destination-ip in new source
- * 	  calculations.
- *	* added some more sanity-checks.
- * 010729 Martin Josefsson <gandalf@wlug.westbo.se>
- * 	* fixed a buggy if-statement in same_check(), should have
- * 	  used ntohl() but didn't.
- * 	* added support for multiple ranges. IPT_SAME_MAX_RANGE is
- * 	  defined in linux/include/linux/netfilter_ipv4/ipt_SAME.h
- * 	  and is currently set to 10.
- * 	* added support for 1-address range, nice to have now that
- * 	  we have multiple ranges.
  */
 #include <linux/types.h>
 #include <linux/ip.h>
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 3e5566b..e530935 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -2,20 +2,6 @@
  * netfilter module for userspace packet logging daemons
  *
  * (C) 2000-2004 by Harald Welte <laforge@netfilter.org>
- *
- * 2000/09/22 ulog-cprange feature added
- * 2001/01/04 in-kernel queue as proposed by Sebastian Zander
- * 						<zander@fokus.gmd.de>
- * 2001/01/30 per-rule nlgroup conflicts with global queue.
- *            nlgroup now global (sysctl)
- * 2001/04/19 ulog-queue reworked, now fixed buffer size specified at
- * 	      module loadtime -HW
- * 2002/07/07 remove broken nflog_rcv() function -HW
- * 2002/08/29 fix shifted/unshifted nlgroup bug -HW
- * 2002/10/30 fix uninitialized mac_len field - <Anders K. Pedersen>
- * 2004/10/25 fix erroneous calculation of 'len' parameter to NLMSG_PUT
- *	      resulting in bogus 'error during NLMSG_PUT' messages.
- *
  * (C) 1999-2001 Paul `Rusty' Russell
  * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
  *
@@ -42,8 +28,6 @@
  * flushtimeout:
  *   Specify, after how many hundredths of a second the queue should be
  *   flushed even if it is not full yet.
- *
- * ipt_ULOG.c,v 1.22 2002/10/30 09:07:31 laforge Exp
  */
 
 #include <linux/module.h>
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index 3b4ca0c..2621812 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -1,7 +1,5 @@
 /* IP tables module for matching the value of the IPv4 and TCP ECN bits
  *
- * ipt_ecn.c,v 1.3 2002/05/29 15:09:00 laforge Exp
- *
  * (C) 2002 by Harald Welte <laforge@gnumonks.org>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/ipv4/netfilter/ipt_ttl.c b/net/ipv4/netfilter/ipt_ttl.c
index 9615c04..ab02d9e 100644
--- a/net/ipv4/netfilter/ipt_ttl.c
+++ b/net/ipv4/netfilter/ipt_ttl.c
@@ -1,7 +1,5 @@
 /* IP tables module for matching the value of the TTL
  *
- * ipt_ttl.c,v 1.5 2000/11/13 11:16:08 laforge Exp
- *
  * (C) 2000,2001 by Harald Welte <laforge@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 26e60fb..9278802 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -7,8 +7,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * Extended to all five netfilter hooks by Brad Chapman & Harald Welte
  */
 #include <linux/module.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index d52ca0c..0654eaa 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -4,14 +4,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- move L3 protocol dependent part to this file.
- * 23 Mar 2004: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- add get_features() to support various size of conntrack
- *	  structures.
- *
- * Derived from net/ipv4/netfilter/ip_conntrack_standalone.c
  */
 
 #include <linux/types.h>
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index e090e92..f4fc657 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -4,11 +4,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- enable working with Layer 3 protocol independent connection tracking.
- *
- * Derived from net/ipv4/netfilter/ip_conntrack_proto_icmp.c
  */
 
 #include <linux/types.h>
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index 0cc0d97..6e88505 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -38,10 +38,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  *
  * Author: James Morris <jmorris@intercode.com.au>
- *
- * Updates:
- * 2000-08-06: Convert to new helper API (Harald Welte).
- *
  */
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 275e625..2f1ae42 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -11,18 +11,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 2001-11-06: First try. Working with ip_queue.c for IPv4 and trying
- *             to adapt it to IPv6
- *             HEAVILY based in ipqueue.c by James Morris. It's just
- *             a little modified version of it, so he's nearly the
- *             real coder of this.
- *             Few changes needed, mainly the hard_routing code and
- *             the netlink socket protocol (we're NETLINK_IP6_FW).
- * 2002-06-25: Code cleanup. [JM: ported cleanup over from ip_queue.c]
- * 2005-02-04: Added /proc counter for dropped packets; fixed so
- *             packets aren't delivered to user space if they're going
- *             to be dropped.
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index b97aedc..9aa6240 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -7,15 +7,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 19 Jan 2002 Harald Welte <laforge@gnumonks.org>
- * 	- increase module usage count as soon as we have rules inside
- * 	  a table
- * 06 Jun 2002 Andras Kis-Szabo <kisza@sch.bme.hu>
- *      - new extension header parser code
- * 15 Oct 2005 Harald Welte <laforge@netfilter.org>
- * 	- Unification of {ip,ip6}_tables into x_tables
- * 	- Removed tcp and udp code, since it's not ipv6 specific
  */
 
 #include <linux/capability.h>
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 85b1c27..a9f10e3 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -7,8 +7,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * Extended to all five netfilter hooks by Brad Chapman & Harald Welte
  */
 #include <linux/module.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index fe7f46c..6d2a082 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -7,17 +7,6 @@
  *
  * Author:
  *	Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *
- * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- support Layer 3 protocol independent connection tracking.
- *	  Based on the original ip_conntrack code which	had the following
- *	  copyright information:
- *		(C) 1999-2001 Paul `Rusty' Russell
- *		(C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * 23 Mar 2004: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- add get_features() to support various size of conntrack
- *	  structures.
  */
 
 #include <linux/types.h>
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 075da4f..0be790d 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -7,13 +7,6 @@
  *
  * Author:
  *	Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *
- * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- ICMPv6 tracking support. Derived from the original ip_conntrack code
- *	  net/ipv4/netfilter/ip_conntrack_proto_icmp.c which had the following
- *	  copyright information:
- *		(C) 1999-2001 Paul `Rusty' Russell
- *		(C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
  */
 
 #include <linux/types.h>
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index c3ebdbd..d802b34 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -5,10 +5,6 @@
  * way.
  *
  * Rusty Russell (C)2000 -- This code is GPL.
- *
- * February 2000: Modified by James Morris to have 1 queue per protocol.
- * 15-Mar-2000:   Added NF_REPEAT --RR.
- * 08-May-2003:	  Internal logging interface added by Jozsef Kadlecsik.
  */
 #include <linux/kernel.h>
 #include <linux/netfilter.h>
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 2b0cc7a..a74b205 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -9,24 +9,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 23 Apr 2001: Harald Welte <laforge@gnumonks.org>
- *	- new API and handling of conntrack/nat helpers
- *	- now capable of multiple expectations for one master
- * 16 Jul 2002: Harald Welte <laforge@gnumonks.org>
- *	- add usage/reference counts to ip_conntrack_expect
- *	- export ip_conntrack[_expect]_{find_get,put} functions
- * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- generalize L3 protocol denendent part.
- * 23 Mar 2004: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- add support various size of conntrack structures.
- * 26 Jan 2006: Harald Welte <laforge@netfilter.org>
- * 	- restructure nf_conn (introduce nf_conn_help)
- * 	- redesign 'features' how they were originally intended
- * 26 Feb 2006: Pablo Neira Ayuso <pablo@eurodev.net>
- * 	- add support for L3 protocol module load on demand.
- *
- * Derived from net/ipv4/netfilter/ip_conntrack_core.c
  */
 
 #include <linux/types.h>
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 3089dfc..a186799 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -7,12 +7,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- enable working with Layer 3 protocol independent connection tracking.
- *	- track EPRT and EPSV commands with IPv6 address.
- *
- * Derived from net/ipv4/netfilter/ip_conntrack_ftp.c
  */
 
 #include <linux/module.h>
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e526730..aa1a97e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -6,9 +6,6 @@
  * (C) 2003 by Patrick Mchardy <kaber@trash.net>
  * (C) 2005-2006 by Pablo Neira Ayuso <pablo@eurodev.net>
  *
- * I've reworked this stuff to use attributes instead of conntrack
- * structures. 5.44 am. I need more tea. --pablo 05/07/11.
- *
  * Initial connection tracking via netlink development funded and
  * generally made possible by Network Robots, Inc. (www.networkrobots.com)
  *
@@ -16,8 +13,6 @@
  *
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
- *
- * Derived from ip_conntrack_netlink.c: Port by Pablo Neira Ayuso (05/11/14)
  */
 
 #include <linux/init.h>
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 7c06993..6faf1be 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -4,11 +4,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- enable working with L3 protocol independent connection tracking.
- *
- * Derived from net/ipv4/netfilter/ip_conntrack_proto_generic.c
  */
 
 #include <linux/types.h>
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 3c80558..0d3254b 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -7,15 +7,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 17 Oct 2004: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- enable working with L3 protocol independent connection tracking.
- *
- * Derived from net/ipv4/ip_conntrack_sctp.c
- */
-
-/*
- * Added support for proc manipulation of timeouts.
  */
 
 #include <linux/types.h>
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 8439768..ccdd5d2 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -4,24 +4,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>:
- *	- Real stateful connection tracking
- *	- Modified state transitions table
- *	- Window scaling support added
- *	- SACK support added
- *
- * Willy Tarreau:
- *	- State table bugfixes
- *	- More robust state changes
- *	- Tuning timer parameters
- *
- * 27 Oct 2004: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- genelized Layer 3 protocol part.
- *
- * Derived from net/ipv4/netfilter/ip_conntrack_proto_tcp.c
- *
- * version 2.2
  */
 
 #include <linux/types.h>
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index a5e5726..3620ecc 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -4,11 +4,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- enable working with Layer 3 protocol independent connection tracking.
- *
- * Derived from net/ipv4/netfilter/ip_conntrack_proto_udp.c
  */
 
 #include <linux/types.h>
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index b858636..45baeb0 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1,20 +1,9 @@
-/* This file contains all the functions required for the standalone
-   nf_conntrack module.
-
-   These are not required by the compatibility layer.
-*/
-
 /* (C) 1999-2001 Paul `Rusty' Russell
  * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 16 Dec 2003: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
- *	- generalize L3 protocol dependent part.
- *
- * Derived from net/ipv4/netfilter/ip_conntrack_standalone.c
  */
 
 #include <linux/types.h>
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b174aad..8ae83cb 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -10,11 +10,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- * 2006-01-26 Harald Welte <laforge@netfilter.org>
- * 	- Add optional local and global sequence number to detect lost
- * 	  events from userspace
- *
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index a97704a..9f2f220 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -8,8 +8,6 @@
  * published by the Free Software Foundation.
  *
  * See RFC2474 for a description of the DSCP field within the IP Header.
- *
- * xt_DSCP.c,v 1.8 2002/08/06 18:41:57 laforge Exp
 */
 
 #include <linux/module.h>
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index fec9316..804afe5 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -1,14 +1,5 @@
 /* Kernel module to match connection tracking byte counter.
  * GPL (C) 2002 Martin Devera (devik@cdi.cz).
- *
- * 2004-07-20 Harald Welte <laforge@netfilter.org>
- * 	- reimplemented to use per-connection accounting counters
- * 	- add functionality to match number of packets
- * 	- add functionality to match average packet size
- * 	- add support to match directions seperately
- * 2005-10-16 Harald Welte <laforge@netfilter.org>
- * 	- Port to x_tables
- *
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 000e9c2..56b247e 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -1,7 +1,5 @@
 /* IP tables module for matching the value of the IPv4/IPv6 DSCP field
  *
- * xt_dscp.c,v 1.3 2002/08/05 19:00:21 laforge Exp
- *
  * (C) 2002 by Harald Welte <laforge@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index bc70b26..c139b2f 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -5,9 +5,6 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
- *
- *   19 Mar 2002 Harald Welte <laforge@gnumonks.org>:
- *   		 - Port to newnat infrastructure
  */
 
 #include <linux/module.h>
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 6fd8347..571a72a 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -1,10 +1,3 @@
-/* Kernel module to control the rate
- *
- * 2 September 1999: Changed from the target RATE to the match
- *                   `limit', removed logging.  Did I mention that
- *                   Alexey is a fucking genius?
- *                   Rusty Russell (rusty@rustcorp.com.au).  */
-
 /* (C) 1999 Jérôme de Vivie <devivie@info.enserb.u-bordeaux.fr>
  * (C) 1999 Hervé Eychenne <eychenne@info.enserb.u-bordeaux.fr>
  *
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index 97ffc2f..c2017f8 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -1,7 +1,5 @@
 /* IP tables module for matching the routing realm
  *
- * $Id: ipt_realm.c,v 1.3 2004/03/05 13:25:40 laforge Exp $
- *
  * (C) 2003 by Sampsa Ranta <sampsa@netsonic.fi>
  *
  * This program is free software; you can redistribute it and/or modify
