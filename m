From: Jan Engelhardt <jengelh@medozas.de>
Subject: src: remove unused include files
Date: Sun, 7 Dec 2008 13:46:06 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812071345540.17915@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41489 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbYLGMqJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Dec 2008 07:46:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 9723759334ed6703a8c37d134345ea246854ac86
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Dec 7 13:22:45 2008 +0100

src: remove unused include files

No .c files include any of these - in fact they seem to be remnants
missed during commit b1f568309a09e61f892dee3c23279cecff0b0ff4 -
so remove them.
---
 include/linux/netfilter_ipv4/ipt_DSCP.h      |   18 --------
 include/linux/netfilter_ipv4/ipt_FTOS.h      |   16 -------
 include/linux/netfilter_ipv4/ipt_connlimit.h |   12 -----
 include/linux/netfilter_ipv4/ipt_dscp.h      |   21 ---------
 include/linux/netfilter_ipv4/ipt_dstlimit.h  |   39 ------------------
 include/linux/netfilter_ipv4/ipt_rpc.h       |   35 ----------------
 6 files changed, 0 insertions(+), 141 deletions(-)
 delete mode 100644 include/linux/netfilter_ipv4/ipt_DSCP.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_FTOS.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_connlimit.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_dscp.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_dstlimit.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_rpc.h

diff --git a/include/linux/netfilter_ipv4/ipt_DSCP.h b/include/linux/netfilter_ipv4/ipt_DSCP.h
deleted file mode 100644
index 3491e52..0000000
--- a/include/linux/netfilter_ipv4/ipt_DSCP.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* iptables module for setting the IPv4 DSCP field
- *
- * (C) 2002 Harald Welte <laforge@gnumonks.org>
- * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
- * This software is distributed under GNU GPL v2, 1991
- * 
- * See RFC2474 for a description of the DSCP field within the IP Header.
- *
- * ipt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
-*/
-#ifndef _IPT_DSCP_TARGET_H
-#define _IPT_DSCP_TARGET_H
-#include <linux/netfilter_ipv4/ipt_dscp.h>
-#include <linux/netfilter/xt_DSCP.h>
-
-#define ipt_DSCP_info xt_DSCP_info
-
-#endif /* _IPT_DSCP_TARGET_H */
diff --git a/include/linux/netfilter_ipv4/ipt_FTOS.h b/include/linux/netfilter_ipv4/ipt_FTOS.h
deleted file mode 100644
index 3b04559..0000000
--- a/include/linux/netfilter_ipv4/ipt_FTOS.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* Set TOS field in header to any value
- *
- * (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
- *
- * This software is distributed under GNU GPL v2, 1991
- * 
- * ipt_FTOS.h borrowed heavily from ipt_TOS.h  11/09/2000
-*/
-#ifndef _IPT_FTOS_H
-#define _IPT_FTOS_H
-
-struct ipt_FTOS_info {
-	u_int8_t ftos;
-};
-
-#endif /*_IPT_FTOS_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_connlimit.h b/include/linux/netfilter_ipv4/ipt_connlimit.h
deleted file mode 100644
index d99193b..0000000
--- a/include/linux/netfilter_ipv4/ipt_connlimit.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _IPT_CONNLIMIT_H
-#define _IPT_CONNLIMIT_H
-
-struct ipt_connlimit_data;
-
-struct ipt_connlimit_info {
-	int limit;
-	int inverse;
-	u_int32_t mask;
-	struct ipt_connlimit_data *data;
-};
-#endif /* _IPT_CONNLIMIT_H */
diff --git a/include/linux/netfilter_ipv4/ipt_dscp.h b/include/linux/netfilter_ipv4/ipt_dscp.h
deleted file mode 100644
index 4b82ca9..0000000
--- a/include/linux/netfilter_ipv4/ipt_dscp.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* iptables module for matching the IPv4 DSCP field
- *
- * (C) 2002 Harald Welte <laforge@gnumonks.org>
- * This software is distributed under GNU GPL v2, 1991
- * 
- * See RFC2474 for a description of the DSCP field within the IP Header.
- *
- * ipt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
-*/
-#ifndef _IPT_DSCP_H
-#define _IPT_DSCP_H
-
-#include <linux/netfilter/xt_dscp.h>
-
-#define IPT_DSCP_MASK	XT_DSCP_MASK
-#define IPT_DSCP_SHIFT	XT_DSCP_SHIFT
-#define IPT_DSCP_MAX	XT_DSCP_MAX
-
-#define ipt_dscp_info	xt_dscp_info
-
-#endif /* _IPT_DSCP_H */
diff --git a/include/linux/netfilter_ipv4/ipt_dstlimit.h b/include/linux/netfilter_ipv4/ipt_dstlimit.h
deleted file mode 100644
index 1a88f6b..0000000
--- a/include/linux/netfilter_ipv4/ipt_dstlimit.h
+++ /dev/null
@@ -1,39 +0,0 @@
-#ifndef _IPT_DSTLIMIT_H
-#define _IPT_DSTLIMIT_H
-
-/* timings are in milliseconds. */
-#define IPT_DSTLIMIT_SCALE 10000
-/* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
-   seconds, or one every 59 hours. */
-
-/* details of this structure hidden by the implementation */
-struct ipt_dstlimit_htable;
-
-#define IPT_DSTLIMIT_HASH_DIP	0x0001
-#define IPT_DSTLIMIT_HASH_DPT	0x0002
-#define IPT_DSTLIMIT_HASH_SIP	0x0004
-
-struct dstlimit_cfg {
-	u_int32_t mode;	  /* bitmask of IPT_DSTLIMIT_HASH_* */
-	u_int32_t avg;    /* Average secs between packets * scale */
-	u_int32_t burst;  /* Period multiplier for upper limit. */
-
-	/* user specified */
-	u_int32_t size;		/* how many buckets */
-	u_int32_t max;		/* max number of entries */
-	u_int32_t gc_interval;	/* gc interval */
-	u_int32_t expire;	/* when do entries expire? */
-};
-
-struct ipt_dstlimit_info {
-	char name [IFNAMSIZ];		/* name */
-	struct dstlimit_cfg cfg;
-	struct ipt_dstlimit_htable *hinfo;
-
-	/* Used internally by the kernel */
-	union {
-		void *ptr;
-		struct ipt_dstlimit_info *master;
-	} u;
-};
-#endif /*_IPT_DSTLIMIT_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_rpc.h b/include/linux/netfilter_ipv4/ipt_rpc.h
deleted file mode 100644
index c204b7f..0000000
--- a/include/linux/netfilter_ipv4/ipt_rpc.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/* RPC extension for IP netfilter matching, Version 2.2
- * (C) 2000 by Marcelo Barbosa Lima <marcelo.lima@dcc.unicamp.br>
- *	- original rpc tracking module
- *	- "recent" connection handling for kernel 2.3+ netfilter
- *
- * (C) 2001 by Rusty Russell <rusty@rustcorp.com.au>
- *	- upgraded conntrack modules to oldnat api - kernel 2.4.0+
- *
- * (C) 2002 by Ian (Larry) Latter <Ian.Latter@mq.edu.au>
- *	- upgraded conntrack modules to newnat api - kernel 2.4.20+
- *	- extended matching to support filtering on procedures
- *
- * ipt_rpc.h.c,v 2.2 2003/01/12 18:30:00
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- **
- */
-
-#ifndef _IPT_RPC_H
-#define _IPT_RPC_H
-
-struct ipt_rpc_data;
-
-struct ipt_rpc_info {
-	int inverse;
-	int strict;
-	const char c_procs[1408];
-	int i_procs;
-	struct ipt_rpc_data *data;
-};
-
-#endif /* _IPT_RPC_H */

