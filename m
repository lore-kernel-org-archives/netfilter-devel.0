From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 2.4 released
Date: Thu, 23 Oct 2008 18:31:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810231723570.28839@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0810201254190.23040@blackhole.kfki.hu>
 <alpine.LNX.1.10.0810230418300.20661@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0810231657350.28810@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:55295 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbYJWQbO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:31:14 -0400
In-Reply-To: <Pine.LNX.4.64.0810231657350.28810@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 23 Oct 2008, Jozsef Kadlecsik wrote:

> On Thu, 23 Oct 2008, Krzysztof Oledzki wrote:
> 
> > More problems. :| Restoring my sets+iptables configuration and running "ipset
> > -F" oopses the kernel, please look at the attached oops.
> 
> This is a serious issue in 2.4.x, I'll look into it.

Type of a structure elem when flushing (memsetting to zero) was specified 
as uint32_t instead of uint16_t :-(.

Please give a try to the patch below, on top of ipset 2.4.1.

I fixed the bug above and modified all places which might lead to a 
similar bug in the future if a type changes. The missing <linux/timer.h> 
header files are also added.

Index: ipset_nethash.c
===================================================================
--- ipset_nethash.c	(revision 7568)
+++ ipset_nethash.c	(working copy)
@@ -21,7 +21,6 @@
 #include <arpa/inet.h>
 
 #include <linux/netfilter_ipv4/ip_set_nethash.h>
-#include <linux/netfilter_ipv4/ip_set_hashes.h>
 
 #include "ipset.h"
 
Index: kernel/include/linux/netfilter_ipv4/ip_set_macipmap.h
===================================================================
--- kernel/include/linux/netfilter_ipv4/ip_set_macipmap.h	(revision 7568)
+++ kernel/include/linux/netfilter_ipv4/ip_set_macipmap.h	(working copy)
@@ -2,6 +2,7 @@
 #define __IP_SET_MACIPMAP_H
 
 #include <linux/netfilter_ipv4/ip_set.h>
+#include <linux/netfilter_ipv4/ip_set_bitmaps.h>
 
 #define SETTYPE_NAME "macipmap"
 
Index: kernel/include/linux/netfilter_ipv4/ip_set_ipportnethash.h
===================================================================
--- kernel/include/linux/netfilter_ipv4/ip_set_ipportnethash.h	(revision 7568)
+++ kernel/include/linux/netfilter_ipv4/ip_set_ipportnethash.h	(working copy)
@@ -2,6 +2,7 @@
 #define __IP_SET_IPPORTNETHASH_H
 
 #include <linux/netfilter_ipv4/ip_set.h>
+#include <linux/netfilter_ipv4/ip_set_hashes.h>
 
 #define SETTYPE_NAME "ipportnethash"
 
@@ -20,7 +21,7 @@
 	ip_set_ip_t last_ip;		/* host byte order, included in range */
 	uint8_t cidr[30];		/* CIDR sizes */
 	uint16_t nets[30];		/* nr of nets by CIDR sizes */
-	uint32_t initval[0];		/* initvals for jhash_1word */
+	initval_t initval[0];		/* initvals for jhash_1word */
 };
 
 struct ip_set_req_ipportnethash_create {
Index: kernel/include/linux/netfilter_ipv4/ip_set_nethash.h
===================================================================
--- kernel/include/linux/netfilter_ipv4/ip_set_nethash.h	(revision 7568)
+++ kernel/include/linux/netfilter_ipv4/ip_set_nethash.h	(working copy)
@@ -2,6 +2,7 @@
 #define __IP_SET_NETHASH_H
 
 #include <linux/netfilter_ipv4/ip_set.h>
+#include <linux/netfilter_ipv4/ip_set_hashes.h>
 
 #define SETTYPE_NAME "nethash"
 
@@ -13,7 +14,7 @@
 	uint16_t resize;		/* resize factor in percent */
 	uint8_t cidr[30];		/* CIDR sizes */
 	uint16_t nets[30];		/* nr of nets by CIDR sizes */
-	uint32_t initval[0];		/* initvals for jhash_1word */
+	initval_t initval[0];		/* initvals for jhash_1word */
 };
 
 struct ip_set_req_nethash_create {
Index: kernel/include/linux/netfilter_ipv4/ip_set_bitmaps.h
===================================================================
--- kernel/include/linux/netfilter_ipv4/ip_set_bitmaps.h	(revision 7568)
+++ kernel/include/linux/netfilter_ipv4/ip_set_bitmaps.h	(working copy)
@@ -3,6 +3,7 @@
 
 /* Macros to generate functions */
 
+#ifdef __KERNEL__
 #define BITMAP_CREATE(type)						\
 static int								\
 type##_create(struct ip_set *set, const void *data, size_t size)	\
@@ -115,5 +116,6 @@
 	.list_members		= &type##_list_members,			\
 	.me			= THIS_MODULE,				\
 };
+#endif /* __KERNEL */
 
 #endif /* __IP_SET_BITMAPS_H */
Index: kernel/include/linux/netfilter_ipv4/ip_set_ipmap.h
===================================================================
--- kernel/include/linux/netfilter_ipv4/ip_set_ipmap.h	(revision 7568)
+++ kernel/include/linux/netfilter_ipv4/ip_set_ipmap.h	(working copy)
@@ -2,6 +2,7 @@
 #define __IP_SET_IPMAP_H
 
 #include <linux/netfilter_ipv4/ip_set.h>
+#include <linux/netfilter_ipv4/ip_set_bitmaps.h>
 
 #define SETTYPE_NAME "ipmap"
 
Index: kernel/include/linux/netfilter_ipv4/ip_set_ipportiphash.h
===================================================================
--- kernel/include/linux/netfilter_ipv4/ip_set_ipportiphash.h	(revision 7568)
+++ kernel/include/linux/netfilter_ipv4/ip_set_ipportiphash.h	(working copy)
@@ -2,6 +2,7 @@
 #define __IP_SET_IPPORTIPHASH_H
 
 #include <linux/netfilter_ipv4/ip_set.h>
+#include <linux/netfilter_ipv4/ip_set_hashes.h>
 
 #define SETTYPE_NAME "ipportiphash"
 
@@ -18,7 +19,7 @@
 	uint16_t resize;		/* resize factor in percent */
 	ip_set_ip_t first_ip;		/* host byte order, included in range */
 	ip_set_ip_t last_ip;		/* host byte order, included in range */
-	uint32_t initval[0];		/* initvals for jhash_1word */
+	initval_t initval[0];		/* initvals for jhash_1word */
 };
 
 struct ip_set_req_ipportiphash_create {
Index: kernel/include/linux/netfilter_ipv4/ip_set_hashes.h
===================================================================
--- kernel/include/linux/netfilter_ipv4/ip_set_hashes.h	(revision 7568)
+++ kernel/include/linux/netfilter_ipv4/ip_set_hashes.h	(working copy)
@@ -1,6 +1,8 @@
 #ifndef __IP_SET_HASHES_H
 #define __IP_SET_HASHES_H
 
+#define initval_t uint32_t
+
 /* Macros to generate functions */
 
 #ifdef __KERNEL__
@@ -30,11 +32,11 @@
 		      set->name, map->hashsize, hashsize);		\
 		      							\
 	tmp = kmalloc(sizeof(struct ip_set_##type)			\
-		      + map->probes * sizeof(uint32_t), GFP_ATOMIC);	\
+		      + map->probes * sizeof(initval_t), GFP_ATOMIC);	\
 	if (!tmp) {							\
 		DP("out of memory for %d bytes",			\
 		   sizeof(struct ip_set_##type)				\
-		   + map->probes * sizeof(uint32_t));			\
+		   + map->probes * sizeof(initval_t));			\
 		return -ENOMEM;						\
 	}								\
 	tmp->members = harray_malloc(hashsize, sizeof(dtype), GFP_ATOMIC);\
@@ -47,7 +49,7 @@
 	tmp->elements = 0;						\
 	tmp->probes = map->probes;					\
 	tmp->resize = map->resize;					\
-	memcpy(tmp->initval, map->initval, map->probes * sizeof(uint32_t));\
+	memcpy(tmp->initval, map->initval, map->probes * sizeof(initval_t));\
 	__##type##_retry(tmp, map);					\
 									\
 	write_lock_bh(&set->lock);					\
@@ -103,15 +105,15 @@
 	}								\
 									\
 	map = kmalloc(sizeof(struct ip_set_##type)			\
-		      + req->probes * sizeof(uint32_t), GFP_KERNEL);	\
+		      + req->probes * sizeof(initval_t), GFP_KERNEL);	\
 	if (!map) {							\
 		DP("out of memory for %d bytes",			\
 		   sizeof(struct ip_set_##type)				\
-		   + req->probes * sizeof(uint32_t));			\
+		   + req->probes * sizeof(initval_t));			\
 		return -ENOMEM;						\
 	}								\
 	for (i = 0; i < req->probes; i++)				\
-		get_random_bytes(((uint32_t *) map->initval)+i, 4);	\
+		get_random_bytes(((initval_t *) map->initval)+i, 4);	\
 	map->elements = 0;						\
 	map->hashsize = req->hashsize;					\
 	map->probes = req->probes;					\
@@ -158,8 +160,8 @@
 {									\
 	struct ip_set_##type *map = set->data;				\
 	harray_flush(map->members, map->hashsize, sizeof(dtype));	\
-	memset(map->cidr, 0, 30 * sizeof(uint8_t));			\
-	memset(map->nets, 0, 30 * sizeof(uint32_t));			\
+	memset(map->cidr, 0, sizeof(map->cidr));			\
+	memset(map->nets, 0, sizeof(map->nets));			\
 	map->elements = 0;						\
 }
 
Index: kernel/include/linux/netfilter_ipv4/ip_set_iphash.h
===================================================================
--- kernel/include/linux/netfilter_ipv4/ip_set_iphash.h	(revision 7568)
+++ kernel/include/linux/netfilter_ipv4/ip_set_iphash.h	(working copy)
@@ -2,6 +2,7 @@
 #define __IP_SET_IPHASH_H
 
 #include <linux/netfilter_ipv4/ip_set.h>
+#include <linux/netfilter_ipv4/ip_set_hashes.h>
 
 #define SETTYPE_NAME "iphash"
 
@@ -12,7 +13,7 @@
 	uint16_t probes;		/* max number of probes  */
 	uint16_t resize;		/* resize factor in percent */
 	ip_set_ip_t netmask;		/* netmask */
-	uint32_t initval[0];		/* initvals for jhash_1word */
+	initval_t initval[0];		/* initvals for jhash_1word */
 };
 
 struct ip_set_req_iphash_create {
Index: kernel/include/linux/netfilter_ipv4/ip_set_ipporthash.h
===================================================================
--- kernel/include/linux/netfilter_ipv4/ip_set_ipporthash.h	(revision 7568)
+++ kernel/include/linux/netfilter_ipv4/ip_set_ipporthash.h	(working copy)
@@ -2,6 +2,7 @@
 #define __IP_SET_IPPORTHASH_H
 
 #include <linux/netfilter_ipv4/ip_set.h>
+#include <linux/netfilter_ipv4/ip_set_hashes.h>
 
 #define SETTYPE_NAME "ipporthash"
 
@@ -13,7 +14,7 @@
 	uint16_t resize;		/* resize factor in percent */
 	ip_set_ip_t first_ip;		/* host byte order, included in range */
 	ip_set_ip_t last_ip;		/* host byte order, included in range */
-	uint32_t initval[0];		/* initvals for jhash_1word */
+	initval_t initval[0];		/* initvals for jhash_1word */
 };
 
 struct ip_set_req_ipporthash_create {
Index: kernel/include/linux/netfilter_ipv4/ip_set_portmap.h
===================================================================
--- kernel/include/linux/netfilter_ipv4/ip_set_portmap.h	(revision 7568)
+++ kernel/include/linux/netfilter_ipv4/ip_set_portmap.h	(working copy)
@@ -2,6 +2,7 @@
 #define __IP_SET_PORTMAP_H
 
 #include <linux/netfilter_ipv4/ip_set.h>
+#include <linux/netfilter_ipv4/ip_set_bitmaps.h>
 
 #define SETTYPE_NAME	"portmap"
 
Index: kernel/ipt_SET.c
===================================================================
--- kernel/ipt_SET.c	(revision 7567)
+++ kernel/ipt_SET.c	(working copy)
@@ -10,17 +10,11 @@
 
 /* ipt_SET.c - netfilter target to manipulate IP sets */
 
-#include <linux/types.h>
-#include <linux/ip.h>
-#include <linux/timer.h>
 #include <linux/module.h>
-#include <linux/netfilter.h>
-#include <linux/netdevice.h>
-#include <linux/if.h>
-#include <linux/inetdevice.h>
+#include <linux/ip.h>
+#include <linux/skbuff.h>
 #include <linux/version.h>
-#include <net/protocol.h>
-#include <net/checksum.h>
+
 #include <linux/netfilter_ipv4.h>
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,16)
 #include <linux/netfilter_ipv4/ip_tables.h>
Index: kernel/ip_set_ipmap.c
===================================================================
--- kernel/ip_set_ipmap.c	(revision 7568)
+++ kernel/ip_set_ipmap.c	(working copy)
@@ -17,8 +17,6 @@
 #include <asm/bitops.h>
 #include <linux/spinlock.h>
 
-#include <linux/netfilter_ipv4/ip_set.h>
-#include <linux/netfilter_ipv4/ip_set_bitmaps.h>
 #include <linux/netfilter_ipv4/ip_set_ipmap.h>
 
 static inline ip_set_ip_t
Index: kernel/ip_set_ipportiphash.c
===================================================================
--- kernel/ip_set_ipportiphash.c	(revision 7569)
+++ kernel/ip_set_ipportiphash.c	(working copy)
@@ -22,8 +22,6 @@
 
 #include <net/ip.h>
 
-#include <linux/netfilter_ipv4/ip_set.h>
-#include <linux/netfilter_ipv4/ip_set_hashes.h>
 #include <linux/netfilter_ipv4/ip_set_ipportiphash.h>
 #include <linux/netfilter_ipv4/ip_set_getport.h>
 
Index: kernel/ip_set_iphash.c
===================================================================
--- kernel/ip_set_iphash.c	(revision 7568)
+++ kernel/ip_set_iphash.c	(working copy)
@@ -20,8 +20,6 @@
 
 #include <net/ip.h>
 
-#include <linux/netfilter_ipv4/ip_set.h>
-#include <linux/netfilter_ipv4/ip_set_hashes.h>
 #include <linux/netfilter_ipv4/ip_set_iphash.h>
 
 static int limit = MAX_RANGE;
Index: kernel/ip_set_ipporthash.c
===================================================================
--- kernel/ip_set_ipporthash.c	(revision 7569)
+++ kernel/ip_set_ipporthash.c	(working copy)
@@ -22,8 +22,6 @@
 
 #include <net/ip.h>
 
-#include <linux/netfilter_ipv4/ip_set.h>
-#include <linux/netfilter_ipv4/ip_set_hashes.h>
 #include <linux/netfilter_ipv4/ip_set_ipporthash.h>
 #include <linux/netfilter_ipv4/ip_set_getport.h>
 
Index: kernel/ip_set_portmap.c
===================================================================
--- kernel/ip_set_portmap.c	(revision 7568)
+++ kernel/ip_set_portmap.c	(working copy)
@@ -19,8 +19,6 @@
 
 #include <net/ip.h>
 
-#include <linux/netfilter_ipv4/ip_set.h>
-#include <linux/netfilter_ipv4/ip_set_bitmaps.h>
 #include <linux/netfilter_ipv4/ip_set_portmap.h>
 #include <linux/netfilter_ipv4/ip_set_getport.h>
 
Index: kernel/ip_set_iptreemap.c
===================================================================
--- kernel/ip_set_iptreemap.c	(revision 7568)
+++ kernel/ip_set_iptreemap.c	(working copy)
@@ -21,6 +21,7 @@
 #include <asm/uaccess.h>
 #include <asm/bitops.h>
 #include <linux/spinlock.h>
+#include <linux/timer.h>
 
 #include <linux/netfilter_ipv4/ip_set.h>
 #include <linux/netfilter_ipv4/ip_set_bitmaps.h>
Index: kernel/ip_set_macipmap.c
===================================================================
--- kernel/ip_set_macipmap.c	(revision 7568)
+++ kernel/ip_set_macipmap.c	(working copy)
@@ -19,8 +19,6 @@
 #include <linux/spinlock.h>
 #include <linux/if_ether.h>
 
-#include <linux/netfilter_ipv4/ip_set.h>
-#include <linux/netfilter_ipv4/ip_set_bitmaps.h>
 #include <linux/netfilter_ipv4/ip_set_macipmap.h>
 
 static int
Index: kernel/ip_set_iptree.c
===================================================================
--- kernel/ip_set_iptree.c	(revision 7568)
+++ kernel/ip_set_iptree.c	(working copy)
@@ -17,6 +17,7 @@
 #include <asm/uaccess.h>
 #include <asm/bitops.h>
 #include <linux/spinlock.h>
+#include <linux/timer.h>
 
 #include <linux/netfilter_ipv4/ip_set.h>
 #include <linux/netfilter_ipv4/ip_set_bitmaps.h>
Index: kernel/ip_set_ipportnethash.c
===================================================================
--- kernel/ip_set_ipportnethash.c	(revision 7569)
+++ kernel/ip_set_ipportnethash.c	(working copy)
@@ -22,8 +22,6 @@
 
 #include <net/ip.h>
 
-#include <linux/netfilter_ipv4/ip_set.h>
-#include <linux/netfilter_ipv4/ip_set_hashes.h>
 #include <linux/netfilter_ipv4/ip_set_ipportnethash.h>
 #include <linux/netfilter_ipv4/ip_set_getport.h>
 
@@ -223,8 +221,8 @@
 {
 	tmp->first_ip = map->first_ip;
 	tmp->last_ip = map->last_ip;
-	memcpy(tmp->cidr, map->cidr, 30 * sizeof(uint8_t));
-	memcpy(tmp->nets, map->nets, 30 * sizeof(uint16_t));
+	memcpy(tmp->cidr, map->cidr, sizeof(tmp->cidr));
+	memcpy(tmp->nets, map->nets, sizeof(tmp->nets));
 }
 
 HASH_RETRY2(ipportnethash, struct ipportip)
@@ -273,8 +271,8 @@
 	}
 	map->first_ip = req->from;
 	map->last_ip = req->to;
-	memset(map->cidr, 0, 30 * sizeof(uint8_t));
-	memset(map->nets, 0, 30 * sizeof(uint16_t));
+	memset(map->cidr, 0, sizeof(map->cidr));
+	memset(map->nets, 0, sizeof(map->nets));
 	return 0;
 }
 
Index: kernel/ip_set_nethash.c
===================================================================
--- kernel/ip_set_nethash.c	(revision 7568)
+++ kernel/ip_set_nethash.c	(working copy)
@@ -20,8 +20,6 @@
 
 #include <net/ip.h>
 
-#include <linux/netfilter_ipv4/ip_set.h>
-#include <linux/netfilter_ipv4/ip_set_hashes.h>
 #include <linux/netfilter_ipv4/ip_set_nethash.h>
 
 static int limit = MAX_RANGE;
@@ -153,8 +151,8 @@
 static inline void
 __nethash_retry(struct ip_set_nethash *tmp, struct ip_set_nethash *map)
 {
-	memcpy(tmp->cidr, map->cidr, 30 * sizeof(uint8_t));
-	memcpy(tmp->nets, map->nets, 30 * sizeof(uint16_t));
+	memcpy(tmp->cidr, map->cidr, sizeof(tmp->cidr));
+	memcpy(tmp->nets, map->nets, sizeof(tmp->nets));
 }
 
 HASH_RETRY(nethash, ip_set_ip_t)
@@ -190,8 +188,8 @@
 __nethash_create(const struct ip_set_req_nethash_create *req,
 		 struct ip_set_nethash *map)
 {
-	memset(map->cidr, 0, 30 * sizeof(uint8_t));
-	memset(map->nets, 0, 30 * sizeof(uint16_t));
+	memset(map->cidr, 0, sizeof(map->cidr));
+	memset(map->nets, 0, sizeof(map->nets));
 	
 	return 0;
 }
Index: ipset_iphash.c
===================================================================
--- ipset_iphash.c	(revision 7568)
+++ ipset_iphash.c	(working copy)
@@ -21,6 +21,7 @@
 #include <arpa/inet.h>
 
 #include <linux/netfilter_ipv4/ip_set_iphash.h>
+
 #include "ipset.h"
 
 #define BUFLEN 30;
Index: tests/ipporthash.t
===================================================================
--- tests/ipporthash.t	(revision 7569)
+++ tests/ipporthash.t	(working copy)
@@ -26,7 +26,9 @@
 1 ipset -A test 2.0.0.0,5
 # Range: Try to add value after upper boundary
 1 ipset -A test 2.1.0.1,128
-# Range: Delete test test
+# Range: Flush test set
+0 ipset -F test
+# Range: Delete test set
 0 ipset -X test
 # Network: Try to create a set from an invalid network
 2 ipset -N test ipporthash --network 2.0.0.0/15
@@ -52,6 +54,8 @@
 1 ipset -A test 1.255.255.255,5
 # Network: Try to add value after upper boundary
 1 ipset -A test 2.1.0.0,128
+# Network: Flush test set
+0 ipset -F test
 # Network: Delete test set
 0 ipset -X test
 # eof
Index: tests/portmap.t
===================================================================
--- tests/portmap.t	(revision 7567)
+++ tests/portmap.t	(working copy)
@@ -18,7 +18,9 @@
 1 ipset -A test 0
 # Range: Try to add value after upper boundary
 1 ipset -A test 1025
-# Range: Delete test test
+# Range: Flush test set
+0 ipset -F test
+# Range: Delete test set
 0 ipset -X test
 # Full: Create a full set of ports
 0 ipset -N test portmap --from 0 --to 65535
@@ -32,6 +34,8 @@
 0 ipset -T test 65535
 # Full: Test value not added to the set
 1 ipset -T test 1
+# Full: Flush test set
+0 ipset -F test
 # Full: Delete test set
 0 ipset -X test
 # eof
Index: tests/ipmap.t
===================================================================
--- tests/ipmap.t	(revision 7567)
+++ tests/ipmap.t	(working copy)
@@ -20,7 +20,9 @@
 1 ipset -A test 2.0.0.0
 # Range: Try to add value after upper boundary
 1 ipset -A test 2.1.0.1
-# Range: Delete test test
+# Range: Flush test set
+0 ipset -F test
+# Range: Delete test set
 0 ipset -X test
 # Network: Try to create a set from an invalid network
 2 ipset -N test ipmap --network 2.0.0.0/15
@@ -44,7 +46,9 @@
 1 ipset -A test 1.255.255.255
 # Network: Try to add value after upper boundary
 1 ipset -A test 2.1.0.0
-# Network: Delete test test
+# Network: Flush test set
+0 ipset -F test
+# Network: Delete test set
 0 ipset -X test
 # Subnets: Create a set to store networks
 0 ipset -N test ipmap --network 10.0.0.0/8 --netmask 24
@@ -66,7 +70,9 @@
 1 ipset -A test 9.255.255.255
 # Subnets: Try to add value after upper boundary
 1 ipset -A test 11.0.0.0
-# Subnets: Delete test test
+# Subnets: FLush test set
+0 ipset -F test
+# Subnets: Delete test set
 0 ipset -X test
 # Full: Create full IPv4 space with /16 networks
 0 ipset -N test ipmap --network 0.0.0.0/0 --netmask 16
Index: tests/iptreemap.t
===================================================================
--- tests/iptreemap.t	(revision 7568)
+++ tests/iptreemap.t	(working copy)
@@ -46,6 +46,8 @@
 0 ipset -T test 192.168.68.67
 # Test element after upper bound of deleted network
 0 ipset -T test 192.168.68.72
+# Flush test set
+0 ipset -F test
 # Delete test set
 0 ipset -X test
 # eof
Index: tests/macipmap.t
===================================================================
--- tests/macipmap.t	(revision 7568)
+++ tests/macipmap.t	(working copy)
@@ -26,7 +26,9 @@
 1 ipset -T test 2.0.0.2,00:11:22:33:44:56
 # Range: Test value with valid MAC
 0 ipset -T test 2.0.0.2,00:11:22:33:44:55
-# Range: Delete test test
+# Range: Flush test set
+0 ipset -F test
+# Range: Delete test set
 0 ipset -X test
 # Network: Try to create a set from an invalid network
 2 ipset -N test macipmap --network 2.0.0.0/15
@@ -50,6 +52,8 @@
 1 ipset -A test 1.255.255.255
 # Network: Try to add value after upper boundary
 1 ipset -A test 2.1.0.0
+# Network: Flush test set
+0 ipset -F test
 # Network: Delete test set
 0 ipset -X test
 # eof
Index: tests/setlist.t
===================================================================
--- tests/setlist.t	(revision 7568)
+++ tests/setlist.t	(working copy)
@@ -26,6 +26,8 @@
 1 ipset -D test foo,after,bar
 # Setlist: Delete bar,after,foo
 0 ipset -D test bar,after,foo
-# Setlist: Delete test test
+# Setlist: Flush test set
+0 ipset -F test
+# Setlist: Delete test set
 0 ipset -X test
 # eof
Index: tests/iptree.t
===================================================================
--- tests/iptree.t	(revision 7568)
+++ tests/iptree.t	(working copy)
@@ -12,7 +12,9 @@
 1 ipset -T test 2.0.0.2
 # Static: Test value not added to the set
 1 ipset -T test 192.168.68.70
-# Static: Delete test test
+# Static: Flush test set
+0 ipset -F test
+# Static: Delete test set
 0 ipset -X test
 # Timeout: Create a set with a timeout parameter
 0 ipset -N test iptree --timeout 5
@@ -46,6 +48,8 @@
 0 sleep 4
 # Timeout: Test entry added with 3s timeout
 1 ipset -T test 2.0.0.2
+# Timeout: Flush test set
+0 ipset -F test
 # Timeout: Delete test set
 0 ipset -X test
 # eof
Index: tests/ipportnethash.t
===================================================================
--- tests/ipportnethash.t	(revision 7569)
+++ tests/ipportnethash.t	(working copy)
@@ -28,7 +28,9 @@
 1 ipset -A test 2.0.0.0,5,1.1.1.1/24
 # Range: Try to add value after upper boundary
 1 ipset -A test 2.1.0.1,128,2.2.2.2/12
-# Range: Delete test test
+# Range: Flush test set
+0 ipset -F test
+# Range: Delete test set
 0 ipset -X test
 # Network: Try to create a set from an invalid network
 2 ipset -N test ipportnethash --network 2.0.0.0/15
@@ -54,6 +56,8 @@
 1 ipset -A test 1.255.255.255,5,1.1.1.1/24
 # Network: Try to add value after upper boundary
 1 ipset -A test 2.1.0.0,128,2.2.2.2/12
+# Network: Flush test set
+0 ipset -F test
 # Network: Delete test set
 0 ipset -X test
 # eof
Index: tests/nethash.t
===================================================================
--- tests/nethash.t	(revision 7569)
+++ tests/nethash.t	(working copy)
@@ -16,6 +16,8 @@
 1 ipset -T test 2.0.1.0
 # Try to add IP address
 2 ipset -A test 2.0.0.1
+# Flush test set
+0 ipset -F test
 # Delete test set
 0 ipset -X test
 # eof
Index: tests/ipportiphash.t
===================================================================
--- tests/ipportiphash.t	(revision 7569)
+++ tests/ipportiphash.t	(working copy)
@@ -28,7 +28,9 @@
 1 ipset -A test 2.0.0.0,5,1.1.1.1
 # Range: Try to add value after upper boundary
 1 ipset -A test 2.1.0.1,128,2.2.2.2
-# Range: Delete test test
+# Range: Flush test set
+0 ipset -F test
+# Range: Delete test set
 0 ipset -X test
 # Network: Try to create a set from an invalid network
 2 ipset -N test ipportiphash --network 2.0.0.0/15
@@ -54,6 +56,8 @@
 1 ipset -A test 1.255.255.255,5,1.1.1.1
 # Network: Try to add value after upper boundary
 1 ipset -A test 2.1.0.0,128,2.2.2.2
+# Network: Flush test set
+0 ipset -F test
 # Network: Delete test set
 0 ipset -X test
 # eof
Index: tests/iphash.t
===================================================================
--- tests/iphash.t	(revision 7569)
+++ tests/iphash.t	(working copy)
@@ -14,12 +14,16 @@
 0 ipset -T test 192.168.68.69
 # IP: Test value not added to the set
 1 ipset -T test 2.0.0.2
+# IP: Flush test set
+0 ipset -F test
 # IP: Delete test set
 0 ipset -X test
 # IP: Restore values so that rehashing is triggered
 0 ipset -R < iphash.t.restore
 # IP: Check that all values are restored
 0 (egrep -v '#|-N' iphash.t.restore | sort > .foo.1) && (ipset -S test | egrep -v '#|-N' | sort > .foo.2) && cmp .foo.1 .foo.2 && rm .foo.*
+# IP: Flush test set
+0 ipset -F test
 # IP: Delete test set
 0 ipset -X test
 # Network: Create a set 
@@ -34,6 +38,8 @@
 0 ipset -T test 192.168.68.95
 # Network: Test value not added to the set
 1 ipset -T test 2.0.1.0
+# Network: Flush test set
+0 ipset -F test
 # Network: Delete test set
 0 ipset -X test
 # eof

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
