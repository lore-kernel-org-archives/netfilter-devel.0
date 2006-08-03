From: Amin Azez <azez@ufomechanic.net>
Subject: [PATCH] ipset matches either,both
Date: Thu, 03 Aug 2006 17:10:33 +0100
Message-ID: <eat75p$9o4$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080908030408010606060206"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------080908030408010606060206
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

These patches to ipset allow "either" and "both" to be specified as well
as "src" and "dst".

I considered doing this as a hack in ip_set.c, by calling the match
twice, faking flags of SRC and DST, but it was a hack and wouldn't
easily cover the porthash which consumes two flags.

Instead I've altered the test of all of the set types, to accept BOTH
and EITHER as well.

The encoding of BOTH and EITHER was troublesome as flags is a mix of an
enum and bitmap-set; what I did isn't clean, but it will do, and doesn't
break user-space compatability.

I've tested the behaviour of src dst either and both for iphash.
I'm not sure about ipportmap because the man pages aren't clear how to
write rules for this.

I'm not sure of the effect on this with bindings; I suspect that with
either,both we may want a preferred test order, and the one that matches
first is used to follow bindings.

I guess that
   res = set->type->testip_kernel(set, skb, &ip, flags, i++);

sets ip for use by bindings following, and I haven't fiddled with this,
so src will be set if that matched for either, otherwise "dst" will be
set for "either" or "both"

Comments welcome.

--------------080908030408010606060206
Content-Type: text/x-patch;
 name="ipset-both-either.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipset-both-either.patch"

Index: linux-2.6.17.1/include/linux/netfilter_ipv4/ip_set.h
===================================================================
--- linux-2.6.17.1.orig/include/linux/netfilter_ipv4/ip_set.h
+++ linux-2.6.17.1/include/linux/netfilter_ipv4/ip_set.h
@@ -5,6 +5,7 @@
  *                         Patrick Schaaf <bof@bof.de>
  *                         Martin Josefsson <gandalf@wlug.westbo.se>
  * Copyright (C) 2003-2004 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2006 UFO Mechanic          <azez@ufomechanic.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -79,6 +80,14 @@ typedef uint16_t ip_set_id_t;
 #define IPSET_SRC 		0x01	/* Source match/add */
 #define IPSET_DST		0x02	/* Destination match/add */
 #define IPSET_MATCH_INV		0x04	/* Inverse matching */
+#define IPSET_BOTH		0x08	/* Source and dest match/add */
+#define IPSET_EITHER		0x10	/* Source or dest match, add both*/
+/* Debug helper */
+#define IP_SET_OPERATION(index)	((index & IPSET_EITHER)?"EITHER":\
+				(index & IPSET_BOTH)?"BOTH":\
+				(index & IPSET_SRC)?"SRC":\
+				(index & IPSET_DST)?"DST":"UNKNOWN")
+
 
 /*
  * Set features
Index: linux-2.6.17.1/net/ipv4/netfilter/ip_set_iphash.c
===================================================================
--- linux-2.6.17.1.orig/net/ipv4/netfilter/ip_set_iphash.c
+++ linux-2.6.17.1/net/ipv4/netfilter/ip_set_iphash.c
@@ -1,4 +1,5 @@
 /* Copyright (C) 2003-2004 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2006 UFO Mechanic          <azez@ufomechanic.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -86,11 +87,24 @@ testip_kernel(struct ip_set *set, 
 	      const u_int32_t *flags,
 	      unsigned char index)
 {
-	return __testip(set,
-			ntohl(flags[index] & IPSET_SRC 
-				? skb->nh.iph->saddr 
-				: skb->nh.iph->daddr),
-			hash_ip);
+	int src;
+	int dst;
+
+	src = ( (flags[index] & (IPSET_SRC | IPSET_BOTH | IPSET_EITHER)) && \
+			__testip(set, ntohl(skb->nh.iph->saddr), hash_ip) );
+
+	/* don't need to check dst if we have src matched and want SRC or EITHER */
+	if (src && (flags[index] & (IPSET_SRC | IPSET_EITHER)) )
+		return src;
+
+	dst = ( (flags[index] & (IPSET_DST | IPSET_BOTH | IPSET_EITHER)) && \
+		__testip(set, ntohl(skb->nh.iph->daddr), hash_ip) );
+
+	/* Now work out the answer */
+	if (flags[index] & IPSET_BOTH)
+		return src && dst;
+	else
+		return src || dst;
 }
 
 static inline int
Index: linux-2.6.17.1/net/ipv4/netfilter/ip_set_ipmap.c
===================================================================
--- linux-2.6.17.1.orig/net/ipv4/netfilter/ip_set_ipmap.c
+++ linux-2.6.17.1/net/ipv4/netfilter/ip_set_ipmap.c
@@ -1,6 +1,7 @@
 /* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
  *                         Patrick Schaaf <bof@bof.de>
  * Copyright (C) 2003-2004 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2006 UFO Mechanic          <azez@ufomechanic.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -64,19 +65,29 @@ testip_kernel(struct ip_set *set, 
 	      const u_int32_t *flags,
 	      unsigned char index)
 {
-	int res;
+	int src;
+	int dst;
 	
 	DP("flag: %s src: %u.%u.%u.%u dst: %u.%u.%u.%u",
-	   flags[index] & IPSET_SRC ? "SRC" : "DST",
+	   IP_SET_OPERATION(flags[index]),
 	   NIPQUAD(skb->nh.iph->saddr),
 	   NIPQUAD(skb->nh.iph->daddr));
 
-	res =  __testip(set,
-			ntohl(flags[index] & IPSET_SRC 
-				? skb->nh.iph->saddr 
-				: skb->nh.iph->daddr),
-			hash_ip);
-	return (res < 0 ? 0 : res);
+	src = ( (flags[index] & (IPSET_SRC | IPSET_BOTH | IPSET_EITHER)) && \
+			__testip(set, ntohl(skb->nh.iph->saddr), hash_ip) > 0 );
+
+	/* don't need to check dst if we have src matched and want SRC or EITHER */
+	if (src && (flags[index] & (IPSET_SRC | IPSET_EITHER)) )
+		return src;
+
+	dst = ( (flags[index] & (IPSET_DST | IPSET_BOTH | IPSET_EITHER)) && \
+		__testip(set, ntohl(skb->nh.iph->daddr), hash_ip) > 0 );
+
+	/* Now work out the answer */
+	if (flags[index] & IPSET_BOTH)
+		return src && dst;
+	else
+		return src || dst;
 }
 
 static inline int
Index: linux-2.6.17.1/net/ipv4/netfilter/ip_set_ipporthash.c
===================================================================
--- linux-2.6.17.1.orig/net/ipv4/netfilter/ip_set_ipporthash.c
+++ linux-2.6.17.1/net/ipv4/netfilter/ip_set_ipporthash.c
@@ -1,4 +1,5 @@
 /* Copyright (C) 2003-2004 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2006 UFO Mechanic          <azez@ufomechanic.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -132,18 +133,15 @@ testip(struct ip_set *set, const void *d
 }
 
 static int
-testip_kernel(struct ip_set *set, 
-	      const struct sk_buff *skb,
-	      ip_set_ip_t *hash_ip,
-	      const u_int32_t *flags,
-	      unsigned char index)
+_testip_kernel(struct ip_set *set,
+              const struct sk_buff *skb,
+              ip_set_ip_t *hash_ip,
+              const u_int32_t *flags,
+              unsigned char index,
+	      ip_set_ip_t port)
 {
-	ip_set_ip_t port;
-
-	if (flags[index+1] == 0)
-		return -EINVAL;
-		
-	port = get_port(skb, flags[index+1]);
+	int src = 0;
+	int dst = 0;
 
 	DP("flag: %s src: %u.%u.%u.%u dst: %u.%u.%u.%u",
 	   flags[index] & IPSET_SRC ? "SRC" : "DST",
@@ -152,15 +150,61 @@ testip_kernel(struct ip_set *set, 
 	DP("flag %s port %u",
 	   flags[index+1] & IPSET_SRC ? "SRC" : "DST", 
 	   port);	
+
 	if (port == INVALID_PORT)
 		return 0;	
 
-	return __testip(set,
-			ntohl(flags[index] & IPSET_SRC 
-					? skb->nh.iph->saddr 
-					: skb->nh.iph->daddr),
-			port,
-			hash_ip);
+	src = ( (flags[index] & (IPSET_SRC | IPSET_BOTH | IPSET_EITHER)) && \
+			__testip(set, ntohl(skb->nh.iph->saddr), port, hash_ip) );
+
+	/* don't need to check dst if we have src matched and want SRC or EITHER */
+	if (src && (flags[index] & (IPSET_SRC | IPSET_EITHER)) )
+		return src;
+
+	dst = ( (flags[index] & (IPSET_DST | IPSET_BOTH | IPSET_EITHER)) && \
+		__testip(set, ntohl(skb->nh.iph->daddr), port, hash_ip) );
+
+	/* Now work out the answer */
+	if (flags[index] & IPSET_BOTH)
+		return src && dst;
+	else
+		return src || dst;
+}
+
+static int
+testip_kernel(struct ip_set *set, 
+	      const struct sk_buff *skb,
+	      ip_set_ip_t *hash_ip,
+	      const u_int32_t *flags,
+	      unsigned char index)
+{
+	ip_set_ip_t port;
+	int src = 0;
+	int dst = 0;
+
+	if (flags[index+1] == 0)
+		return -EINVAL;
+
+	/* we may have to try both ports */
+	if ( (flags[index+1] & (IPSET_SRC | IPSET_BOTH | IPSET_EITHER)) ) {
+		port = get_port(skb, flags[index+1]);
+		src = _testip_kernel(set, skb, hash_ip, flags, index, port);
+	}
+
+	/* don't need to check dst if we have src matched and want SRC or EITHER */
+	if (src && (flags[index+1] & (IPSET_SRC | IPSET_EITHER)) )
+		return src;
+
+	if ( (flags[index+1] & (IPSET_DST | IPSET_BOTH | IPSET_EITHER)) ) {
+		port = get_port(skb, flags[index+1]);
+		src = _testip_kernel(set, skb, hash_ip, flags, index, port);
+	}
+
+	/* Now work out the answer */
+	if (flags[index+1] & IPSET_BOTH)
+		return src && dst;
+	else
+		return src || dst;
 }
 
 static inline int
Index: linux-2.6.17.1/net/ipv4/netfilter/ip_set_iptree.c
===================================================================
--- linux-2.6.17.1.orig/net/ipv4/netfilter/ip_set_iptree.c
+++ linux-2.6.17.1/net/ipv4/netfilter/ip_set_iptree.c
@@ -1,4 +1,5 @@
 /* Copyright (C) 2005 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2006 UFO Mechanic          <azez@ufomechanic.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -97,19 +98,29 @@ testip_kernel(struct ip_set *set, 
 	      const u_int32_t *flags,
 	      unsigned char index)
 {
-	int res;
+	int src;
+	int dst;
 	
 	DP("flag: %s src: %u.%u.%u.%u dst: %u.%u.%u.%u",
-	   flags[index] & IPSET_SRC ? "SRC" : "DST",
+	   IP_SET_OPERATION(flags[index]),
 	   NIPQUAD(skb->nh.iph->saddr),
 	   NIPQUAD(skb->nh.iph->daddr));
 
-	res =  __testip(set,
-			ntohl(flags[index] & IPSET_SRC 
-				? skb->nh.iph->saddr 
-				: skb->nh.iph->daddr),
-			hash_ip);
-	return (res < 0 ? 0 : res);
+	src = ( (flags[index] & (IPSET_SRC | IPSET_BOTH | IPSET_EITHER)) && \
+			__testip(set, ntohl(skb->nh.iph->saddr), hash_ip) > 0);
+
+	/* don't need to check dst if we have src matched and want SRC or EITHER */
+	if (src && (flags[index] & (IPSET_SRC | IPSET_EITHER)) )
+		return src;
+
+	dst = ( (flags[index] & (IPSET_DST | IPSET_BOTH | IPSET_EITHER)) && \
+		__testip(set, ntohl(skb->nh.iph->daddr), hash_ip) > 0);
+
+	/* Now work out the answer */
+	if (flags[index] & IPSET_BOTH)
+		return src && dst;
+	else
+		return src || dst;
 }
 
 #define ADDIP_WALK(map, elem, branch, type, cachep, flags) do {	\
Index: linux-2.6.17.1/net/ipv4/netfilter/ip_set_macipmap.c
===================================================================
--- linux-2.6.17.1.orig/net/ipv4/netfilter/ip_set_macipmap.c
+++ linux-2.6.17.1/net/ipv4/netfilter/ip_set_macipmap.c
@@ -2,6 +2,7 @@
  *                         Patrick Schaaf <bof@bof.de>
  *                         Martin Josefsson <gandalf@wlug.westbo.se>
  * Copyright (C) 2003-2004 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2006 UFO Mechanic          <azez@ufomechanic.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -56,26 +57,15 @@ testip(struct ip_set *set, const void *d
 }
 
 static int
-testip_kernel(struct ip_set *set, 
+_testip_kernel(struct ip_set *set, 
 	      const struct sk_buff *skb,
 	      ip_set_ip_t *hash_ip,
-	      const u_int32_t *flags,
-	      unsigned char index)
+	      ip_set_ip_t ip)
 {
 	struct ip_set_macipmap *map =
 	    (struct ip_set_macipmap *) set->data;
 	struct ip_set_macip *table =
 	    (struct ip_set_macip *) map->members;
-	ip_set_ip_t ip;
-	
-	ip = ntohl(flags[index] & IPSET_SRC
-			? skb->nh.iph->saddr
-			: skb->nh.iph->daddr);
-	DP("flag: %s src: %u.%u.%u.%u dst: %u.%u.%u.%u",
-	   flags[index] & IPSET_SRC ? "SRC" : "DST",
-	   NIPQUAD(skb->nh.iph->saddr),
-	   NIPQUAD(skb->nh.iph->daddr));
-
 	if (ip < map->first_ip || ip > map->last_ip)
 		return 0;
 
@@ -96,6 +86,40 @@ testip_kernel(struct ip_set *set, 
 	}
 }
 
+static int
+testip_kernel(struct ip_set *set, 
+	      const struct sk_buff *skb,
+	      ip_set_ip_t *hash_ip,
+	      const u_int32_t *flags,
+	      unsigned char index)
+{
+	
+	DP("flag: %s src: %u.%u.%u.%u dst: %u.%u.%u.%u",
+	   IP_SET_OPERATION(flags[index]),
+	   NIPQUAD(skb->nh.iph->saddr),
+	   NIPQUAD(skb->nh.iph->daddr));
+
+	int src;
+	int dst;
+
+	src = ( (flags[index] & (IPSET_SRC | IPSET_BOTH | IPSET_EITHER)) && \
+			_testip_kernel(set,skb,hash_ip,ntohl(skb->nh.iph->saddr)) );
+
+	/* don't need to check dst if we have src matched and want SRC or EITHER */
+	if (src && (flags[index] & (IPSET_SRC | IPSET_EITHER)) )
+		return src;
+
+	dst = ( (flags[index] & (IPSET_DST | IPSET_BOTH | IPSET_EITHER)) && \
+			_testip_kernel(set,skb,hash_ip,ntohl(skb->nh.iph->daddr)) );
+
+	/* Now work out the answer */
+	if (flags[index] & IPSET_BOTH)
+		return src && dst;
+	else
+		return src || dst;
+
+}
+
 /* returns 0 on success */
 static inline int
 __addip(struct ip_set *set, 
Index: linux-2.6.17.1/net/ipv4/netfilter/ip_set_nethash.c
===================================================================
--- linux-2.6.17.1.orig/net/ipv4/netfilter/ip_set_nethash.c
+++ linux-2.6.17.1/net/ipv4/netfilter/ip_set_nethash.c
@@ -1,4 +1,5 @@
 /* Copyright (C) 2003-2004 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2006 UFO Mechanic          <azez@ufomechanic.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -109,11 +110,24 @@ testip_kernel(struct ip_set *set, 
 	      const u_int32_t *flags,
 	      unsigned char index)
 {
-	return __testip(set,
-			ntohl(flags[index] & IPSET_SRC 
-				? skb->nh.iph->saddr 
-				: skb->nh.iph->daddr),
-			hash_ip);
+	int src;
+	int dst;
+
+	src = ( (flags[index] & (IPSET_SRC | IPSET_BOTH | IPSET_EITHER)) && \
+			__testip(set, ntohl(skb->nh.iph->saddr), hash_ip) );
+
+	/* don't need to check dst if we have src matched and want SRC or EITHER */
+	if (src && (flags[index] & (IPSET_SRC | IPSET_EITHER)) )
+		return src;
+
+	dst = ( (flags[index] & (IPSET_DST | IPSET_BOTH | IPSET_EITHER)) && \
+		__testip(set, ntohl(skb->nh.iph->daddr), hash_ip) );
+
+	/* Now work out the answer */
+	if (flags[index] & IPSET_BOTH)
+		return src && dst;
+	else
+		return src || dst;
 }
 
 static inline int
Index: linux-2.6.17.1/net/ipv4/netfilter/ip_set_portmap.c
===================================================================
--- linux-2.6.17.1.orig/net/ipv4/netfilter/ip_set_portmap.c
+++ linux-2.6.17.1/net/ipv4/netfilter/ip_set_portmap.c
@@ -1,4 +1,5 @@
 /* Copyright (C) 2003-2004 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * Copyright (C) 2006 UFO Mechanic          <azez@ufomechanic.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -99,16 +100,30 @@ testport_kernel(struct ip_set *set, 
 	        const u_int32_t *flags,
 	        unsigned char index)
 {
-	int res;
-	ip_set_ip_t port = get_port(skb, flags[index]);
+	int src=0;
+	int dst=0;
+	ip_set_ip_t port;
+
+	if ( (flags[index] & (IPSET_SRC | IPSET_BOTH | IPSET_EITHER))) {
+		DP("flag %s port %u", IP_SET_OPERATION(flags[index]), port);
+		port = get_port(skb, IPSET_SRC);
+		src = (port != INVALID_PORT) && (__testport(set, port, hash_port) > 0);
+	}
 
-	DP("flag %s port %u", flags[index] & IPSET_SRC ? "SRC" : "DST", port);	
-	if (port == INVALID_PORT)
-		return 0;	
+	if (src && (flags[index] & (IPSET_SRC | IPSET_EITHER)) )
+		return src;
 
-	res =  __testport(set, port, hash_port);
-	
-	return (res < 0 ? 0 : res);
+	if ( (flags[index] & (IPSET_DST | IPSET_BOTH | IPSET_EITHER))) {
+		DP("flag %s port %u", IP_SET_OPERATION(flags[index]), port);
+		port = get_port(skb, IPSET_DST);
+		dst = (port != INVALID_PORT) && (__testport(set, port, hash_port) > 0);
+	}
+
+	/* Now work out the answer */
+	if (flags[index] & IPSET_BOTH)
+		return src && dst;
+	else
+		return src || dst;
 }
 
 static inline int

--------------080908030408010606060206
Content-Type: text/x-patch;
 name="iptables-ipset-both.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-ipset-both.patch"

--- extensions/libipt_set.c.both	2006-08-03 13:52:09.000000000 +0100
+++ extensions/libipt_set.c	2006-08-03 14:16:35.000000000 +0100
@@ -120,7 +125,7 @@
 			break;		
 		printf("%s%s",
 		       i == 0 ? " " : ",",
-		       info->flags[i] & IPSET_SRC ? "src" : "dst");
+		       IP_SET_ACTION(info->flags[i]));
 	}
 	printf(" ");
 }
--- extensions/libipt_set.h.both	2006-08-03 14:11:43.000000000 +0100
+++ extensions/libipt_set.h	2006-08-03 14:15:38.000000000 +0100
@@ -11,6 +11,11 @@
 #define DEBUGP(x, args...) 
 #endif
 
+#define IP_SET_ACTION(action) ((action & IPSET_EITHER)?"either":\
+				  (action & IPSET_BOTH)?"both":\
+				  (action & IPSET_SRC)?"src":\
+				  (action & IPSET_DST)?"dst":"unknown")
+
 static void
 parse_bindings(const char *optarg, struct ipt_set_info *info)
 {
@@ -24,9 +29,13 @@
 			info->flags[i++] |= IPSET_SRC;
 		else if (strncmp(ptr, "dst", 3) == 0)
 			info->flags[i++] |= IPSET_DST;
+		else if (strncmp(ptr, "either", 6) == 0)
+			info->flags[i++] |= IPSET_EITHER;
+		else if (strncmp(ptr, "both", 4) == 0)
+			info->flags[i++] |= IPSET_BOTH;
 		else
 			exit_error(PARAMETER_PROBLEM,
-				   "You must spefify (the comma separated list of) 'src' or 'dst'.");
+				   "You must spefify (the comma separated list of) 'src', 'dst', 'either', or 'both'."); sprintf(stderr,"set as %x\n",info->flags[0]);
 	}
 
 	if (tmp)

--------------080908030408010606060206--
