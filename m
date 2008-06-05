From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Thu, 05 Jun 2008 16:21:00 +0200
Message-ID: <4847F64C.2040902@trash.net>
References: <483AB493.6010503@trash.net> <x6skw443x5@gzp>	<483BB9DE.6050003@trash.net> <x6y75w3q2j@gzp>	<483C088E.4020405@trash.net> <x67idfq6d8@gzp> <483CFF21.40608@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080005060007040708070308"
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: "Gabor Z. Papp" <gzp@papp.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <483CFF21.40608@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080005060007040708070308
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Gabor Z. Papp wrote:
>> * Patrick McHardy <kaber@trash.net>:
>>
>> | Your types.h doesn't seem to include the endian annotated
>> | types at all. Does this patch work?
>>
>> Yes. Next problem:
>>
>>   CC       libxt_conntrack.oo
>> In file included from libxt_conntrack.c:21:
>> ../include/linux/netfilter/xt_conntrack.h:38: error: expected 
>> specifier-qualifier-list before '__be32'
>> ../include/linux/netfilter/xt_conntrack.h:45: error: expected 
>> specifier-qualifier-list before '__be32'
>> libxt_conntrack.c: In function 'conntrack_parse': 
>> libxt_conntrack.c:321: error: 'struct <anonymous>' has no member named 
>> 'protonum'
> 
> Yes, I also noticed a bunch of other problems with old
> kernel headers. I'll resync the headers and fix it up,
> but it might take until tommorrow since I'm not sure
> whether I'll get near an internet connection again today.


Took me a bit longer. I've resynced all headers and added
a recent linux/types.h. Does this patch (on top of 1.4.1-rc2)
fix compilation?


--------------080005060007040708070308
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit e0bba47e550420e371c97425cc6d39909a6e059b
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jun 5 16:18:41 2008 +0200

    Resync header files with kernel
    
    Resync headers and add types.h file for endian annotated types, which
    are not available with old headers.

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index b64a513..4196a51 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -38,8 +38,8 @@ enum nf_inet_hooks {
 
 union nf_inet_addr {
 	__u32		all[4];
-	__u32		ip;
-	__u32		ip6[4];
+	__be32		ip;
+	__be32		ip6[4];
 	struct in_addr	in;
 	struct in6_addr	in6;
 };
diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 3b452a6..b887a99 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -125,6 +125,18 @@ enum ip_conntrack_events
 	/* Counter highest bit has been set */
 	IPCT_COUNTER_FILLING_BIT = 11,
 	IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),
+
+	/* Mark is set */
+	IPCT_MARK_BIT = 12,
+	IPCT_MARK = (1 << IPCT_MARK_BIT),
+
+	/* NAT sequence adjustment */
+	IPCT_NATSEQADJ_BIT = 13,
+	IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),
+
+	/* Secmark is set */
+	IPCT_SECMARK_BIT = 14,
+	IPCT_SECMARK = (1 << IPCT_SECMARK_BIT),
 };
 
 enum ip_conntrack_expect_events {
@@ -132,4 +144,5 @@ enum ip_conntrack_expect_events {
 	IPEXP_NEW = (1 << IPEXP_NEW_BIT),
 };
 
+
 #endif /* _NF_CONNTRACK_COMMON_H */
diff --git a/include/linux/netfilter/xt_RATEEST.h b/include/linux/netfilter/xt_RATEEST.h
index ed9665f..f79e313 100644
--- a/include/linux/netfilter/xt_RATEEST.h
+++ b/include/linux/netfilter/xt_RATEEST.h
@@ -3,8 +3,10 @@
 
 struct xt_rateest_target_info {
 	char			name[IFNAMSIZ];
-	signed char		interval;
-	unsigned char		ewma_log;
+	int8_t			interval;
+	u_int8_t		ewma_log;
+
+	/* Used internally by the kernel */
 	struct xt_rateest	*est __attribute__((aligned(8)));
 };
 
diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index 9e35ccd..f3fd83e 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -74,8 +74,8 @@ struct xt_conntrack_mtinfo1 {
 	union nf_inet_addr repldst_addr, repldst_mask;
 	u_int32_t expires_min, expires_max;
 	u_int16_t l4proto;
-	u_int16_t origsrc_port, origdst_port;
-	u_int16_t replsrc_port, repldst_port;
+	__be16 origsrc_port, origdst_port;
+	__be16 replsrc_port, repldst_port;
 	u_int16_t match_flags, invert_flags;
 	u_int8_t state_mask, status_mask;
 };
diff --git a/include/linux/netfilter/xt_limit.h b/include/linux/netfilter/xt_limit.h
index c0aa6d9..b3ce653 100644
--- a/include/linux/netfilter/xt_limit.h
+++ b/include/linux/netfilter/xt_limit.h
@@ -12,10 +12,10 @@ struct xt_rateinfo {
 
 	/* Used internally by the kernel */
 	unsigned long prev;
-	/* Ugly, ugly fucker. */
-	struct xt_rateinfo *master;
-
 	u_int32_t credit;
 	u_int32_t credit_cap, cost;
+
+	/* Ugly, ugly fucker. */
+	struct xt_rateinfo *master;
 };
 #endif /*_XT_RATE_H*/
diff --git a/include/linux/netfilter/xt_physdev.h b/include/linux/netfilter/xt_physdev.h
index 25a7a18..9d33619 100644
--- a/include/linux/netfilter/xt_physdev.h
+++ b/include/linux/netfilter/xt_physdev.h
@@ -1,9 +1,6 @@
 #ifndef _XT_PHYSDEV_H
 #define _XT_PHYSDEV_H
 
-#ifdef __KERNEL__
-#include <linux/if.h>
-#endif
 
 #define XT_PHYSDEV_OP_IN		0x01
 #define XT_PHYSDEV_OP_OUT		0x02
diff --git a/include/linux/netfilter/xt_policy.h b/include/linux/netfilter/xt_policy.h
new file mode 100644
index 0000000..303e380
--- /dev/null
+++ b/include/linux/netfilter/xt_policy.h
@@ -0,0 +1,62 @@
+#ifndef _XT_POLICY_H
+#define _XT_POLICY_H
+
+#define XT_POLICY_MAX_ELEM	4
+
+enum xt_policy_flags
+{
+	XT_POLICY_MATCH_IN	= 0x1,
+	XT_POLICY_MATCH_OUT	= 0x2,
+	XT_POLICY_MATCH_NONE	= 0x4,
+	XT_POLICY_MATCH_STRICT	= 0x8,
+};
+
+enum xt_policy_modes
+{
+	XT_POLICY_MODE_TRANSPORT,
+	XT_POLICY_MODE_TUNNEL
+};
+
+struct xt_policy_spec
+{
+	u_int8_t	saddr:1,
+			daddr:1,
+			proto:1,
+			mode:1,
+			spi:1,
+			reqid:1;
+};
+
+union xt_policy_addr
+{
+	struct in_addr	a4;
+	struct in6_addr	a6;
+};
+
+struct xt_policy_elem
+{
+	union {
+		struct {
+			union xt_policy_addr saddr;
+			union xt_policy_addr smask;
+			union xt_policy_addr daddr;
+			union xt_policy_addr dmask;
+		};
+	};
+	__be32			spi;
+	u_int32_t		reqid;
+	u_int8_t		proto;
+	u_int8_t		mode;
+
+	struct xt_policy_spec	match;
+	struct xt_policy_spec	invert;
+};
+
+struct xt_policy_info
+{
+	struct xt_policy_elem pol[XT_POLICY_MAX_ELEM];
+	u_int16_t flags;
+	u_int16_t len;
+};
+
+#endif /* _XT_POLICY_H */
diff --git a/include/linux/netfilter/xt_rateest.h b/include/linux/netfilter/xt_rateest.h
index e4e0653..2010cb7 100644
--- a/include/linux/netfilter/xt_rateest.h
+++ b/include/linux/netfilter/xt_rateest.h
@@ -2,12 +2,12 @@
 #define _XT_RATEEST_MATCH_H
 
 enum xt_rateest_match_flags {
-	XT_RATEEST_MATCH_INVERT	= 0x01,
-	XT_RATEEST_MATCH_ABS	= 0x02,
-	XT_RATEEST_MATCH_REL	= 0x04,
-	XT_RATEEST_MATCH_DELTA	= 0x08,
-	XT_RATEEST_MATCH_BPS	= 0x10,
-	XT_RATEEST_MATCH_PPS	= 0x20,
+	XT_RATEEST_MATCH_INVERT	= 1<<0,
+	XT_RATEEST_MATCH_ABS	= 1<<1,
+	XT_RATEEST_MATCH_REL	= 1<<2,
+	XT_RATEEST_MATCH_DELTA	= 1<<3,
+	XT_RATEEST_MATCH_BPS	= 1<<4,
+	XT_RATEEST_MATCH_PPS	= 1<<5,
 };
 
 enum xt_rateest_match_mode {
@@ -26,6 +26,8 @@ struct xt_rateest_match_info {
 	u_int32_t		pps1;
 	u_int32_t		bps2;
 	u_int32_t		pps2;
+
+	/* Used internally by the kernel */
 	struct xt_rateest	*est1 __attribute__((aligned(8)));
 	struct xt_rateest	*est2 __attribute__((aligned(8)));
 };
diff --git a/include/linux/netfilter/xt_realm.h b/include/linux/netfilter/xt_realm.h
new file mode 100644
index 0000000..220e872
--- /dev/null
+++ b/include/linux/netfilter/xt_realm.h
@@ -0,0 +1,10 @@
+#ifndef _XT_REALM_H
+#define _XT_REALM_H
+
+struct xt_realm_info {
+	u_int32_t id;
+	u_int32_t mask;
+	u_int8_t invert;
+};
+
+#endif /* _XT_REALM_H */
diff --git a/include/linux/netfilter/xt_statistic.h b/include/linux/netfilter/xt_statistic.h
index c344e99..3d38bc9 100644
--- a/include/linux/netfilter/xt_statistic.h
+++ b/include/linux/netfilter/xt_statistic.h
@@ -23,6 +23,7 @@ struct xt_statistic_info {
 		struct {
 			u_int32_t	every;
 			u_int32_t	packet;
+			/* Used internally by the kernel */
 			u_int32_t	count;
 		} nth;
 	} u;
diff --git a/include/linux/netfilter/xt_string.h b/include/linux/netfilter/xt_string.h
index 3b3419f..bb21dd1 100644
--- a/include/linux/netfilter/xt_string.h
+++ b/include/linux/netfilter/xt_string.h
@@ -12,6 +12,8 @@ struct xt_string_info
 	char 	  pattern[XT_STRING_MAX_PATTERN_SIZE];
 	u_int8_t  patlen;
 	u_int8_t  invert;
+
+	/* Used internally by the kernel */
 	struct ts_config __attribute__((aligned(8))) *config;
 };
 
diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
new file mode 100644
index 0000000..da7e16c
--- /dev/null
+++ b/include/linux/netfilter_ipv4.h
@@ -0,0 +1,74 @@
+#ifndef __LINUX_IP_NETFILTER_H
+#define __LINUX_IP_NETFILTER_H
+
+/* IPv4-specific defines for netfilter. 
+ * (C)1998 Rusty Russell -- This code is GPL.
+ */
+
+#include <linux/netfilter.h>
+
+/* only for userspace compatibility */
+/* IP Cache bits. */
+/* Src IP address. */
+#define NFC_IP_SRC		0x0001
+/* Dest IP address. */
+#define NFC_IP_DST		0x0002
+/* Input device. */
+#define NFC_IP_IF_IN		0x0004
+/* Output device. */
+#define NFC_IP_IF_OUT		0x0008
+/* TOS. */
+#define NFC_IP_TOS		0x0010
+/* Protocol. */
+#define NFC_IP_PROTO		0x0020
+/* IP options. */
+#define NFC_IP_OPTIONS		0x0040
+/* Frag & flags. */
+#define NFC_IP_FRAG		0x0080
+
+/* Per-protocol information: only matters if proto match. */
+/* TCP flags. */
+#define NFC_IP_TCPFLAGS		0x0100
+/* Source port. */
+#define NFC_IP_SRC_PT		0x0200
+/* Dest port. */
+#define NFC_IP_DST_PT		0x0400
+/* Something else about the proto */
+#define NFC_IP_PROTO_UNKNOWN	0x2000
+
+/* IP Hooks */
+/* After promisc drops, checksum checks. */
+#define NF_IP_PRE_ROUTING	0
+/* If the packet is destined for this box. */
+#define NF_IP_LOCAL_IN		1
+/* If the packet is destined for another interface. */
+#define NF_IP_FORWARD		2
+/* Packets coming from a local process. */
+#define NF_IP_LOCAL_OUT		3
+/* Packets about to hit the wire. */
+#define NF_IP_POST_ROUTING	4
+#define NF_IP_NUMHOOKS		5
+
+enum nf_ip_hook_priorities {
+	NF_IP_PRI_FIRST = INT_MIN,
+	NF_IP_PRI_CONNTRACK_DEFRAG = -400,
+	NF_IP_PRI_RAW = -300,
+	NF_IP_PRI_SELINUX_FIRST = -225,
+	NF_IP_PRI_CONNTRACK = -200,
+	NF_IP_PRI_MANGLE = -150,
+	NF_IP_PRI_NAT_DST = -100,
+	NF_IP_PRI_FILTER = 0,
+	NF_IP_PRI_NAT_SRC = 100,
+	NF_IP_PRI_SELINUX_LAST = 225,
+	NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX,
+	NF_IP_PRI_LAST = INT_MAX,
+};
+
+/* Arguments for setsockopt SOL_IP: */
+/* 2.0 firewalling went from 64 through 71 (and +256, +512, etc). */
+/* 2.2 firewalling (+ masq) went from 64 through 76 */
+/* 2.4 firewalling went 64 through 67. */
+#define SO_ORIGINAL_DST 80
+
+
+#endif /*__LINUX_IP_NETFILTER_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h b/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
index daf50be..e5a3687 100644
--- a/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
+++ b/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
@@ -27,6 +27,7 @@ struct ipt_clusterip_tgt_info {
 	u_int32_t hash_mode;
 	u_int32_t hash_initval;
 
+	/* Used internally by the kernel */
 	struct clusterip_config *config;
 };
 
diff --git a/include/linux/netfilter_ipv4/ipt_ECN.h b/include/linux/netfilter_ipv4/ipt_ECN.h
index a711cd1..94e0d98 100644
--- a/include/linux/netfilter_ipv4/ipt_ECN.h
+++ b/include/linux/netfilter_ipv4/ipt_ECN.h
@@ -4,7 +4,7 @@
  *
  * This software is distributed under GNU GPL v2, 1991
  * 
- * Id: ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
+ * ipt_ECN.h,v 1.3 2002/05/29 12:17:40 laforge Exp
 */
 #ifndef _IPT_ECN_TARGET_H
 #define _IPT_ECN_TARGET_H
diff --git a/include/linux/netfilter_ipv4/ipt_TTL.h b/include/linux/netfilter_ipv4/ipt_TTL.h
index f669b8c..ee6611e 100644
--- a/include/linux/netfilter_ipv4/ipt_TTL.h
+++ b/include/linux/netfilter_ipv4/ipt_TTL.h
@@ -1,5 +1,5 @@
 /* TTL modification module for IP tables
- * (C) 2000 by Harald Welte <laforge@gnumonks.org> */
+ * (C) 2000 by Harald Welte <laforge@netfilter.org> */
 
 #ifndef _IPT_TTL_H
 #define _IPT_TTL_H
@@ -16,4 +16,6 @@ struct ipt_TTL_info {
 	u_int8_t	mode;
 	u_int8_t	ttl;
 };
+
+
 #endif
diff --git a/include/linux/netfilter_ipv4/ipt_ecn.h b/include/linux/netfilter_ipv4/ipt_ecn.h
index 326c0c0..1f0d9a4 100644
--- a/include/linux/netfilter_ipv4/ipt_ecn.h
+++ b/include/linux/netfilter_ipv4/ipt_ecn.h
@@ -4,7 +4,7 @@
  *
  * This software is distributed under GNU GPL v2, 1991
  * 
- * Id: ipt_ecn.h,v 1.4 2002/08/05 19:39:00 laforge Exp
+ * ipt_ecn.h,v 1.4 2002/08/05 19:39:00 laforge Exp
 */
 #ifndef _IPT_ECN_H
 #define _IPT_ECN_H
diff --git a/include/linux/netfilter_ipv4/ipt_policy.h b/include/linux/netfilter_ipv4/ipt_policy.h
index 74ca65c..1037fb2 100644
--- a/include/linux/netfilter_ipv4/ipt_policy.h
+++ b/include/linux/netfilter_ipv4/ipt_policy.h
@@ -1,62 +1,23 @@
 #ifndef _IPT_POLICY_H
 #define _IPT_POLICY_H
 
-#define IPT_POLICY_MAX_ELEM	4
+#include <linux/netfilter/xt_policy.h>
 
-#ifndef __KERNEL__
-#include <netinet/in.h>
-#endif
+#define IPT_POLICY_MAX_ELEM		XT_POLICY_MAX_ELEM
 
-enum ipt_policy_flags
-{
-	IPT_POLICY_MATCH_IN	= 0x1,
-	IPT_POLICY_MATCH_OUT	= 0x2,
-	IPT_POLICY_MATCH_NONE	= 0x4,
-	IPT_POLICY_MATCH_STRICT	= 0x8,
-};
+/* ipt_policy_flags */
+#define IPT_POLICY_MATCH_IN		XT_POLICY_MATCH_IN
+#define IPT_POLICY_MATCH_OUT		XT_POLICY_MATCH_OUT
+#define IPT_POLICY_MATCH_NONE		XT_POLICY_MATCH_NONE
+#define IPT_POLICY_MATCH_STRICT		XT_POLICY_MATCH_STRICT
 
-enum ipt_policy_modes
-{
-	IPT_POLICY_MODE_TRANSPORT,
-	IPT_POLICY_MODE_TUNNEL
-};
+/* ipt_policy_modes */
+#define IPT_POLICY_MODE_TRANSPORT	XT_POLICY_MODE_TRANSPORT
+#define IPT_POLICY_MODE_TUNNEL		XT_POLICY_MODE_TUNNEL
 
-struct ipt_policy_spec
-{
-	u_int8_t	saddr:1,
-			daddr:1,
-			proto:1,
-			mode:1,
-			spi:1,
-			reqid:1;
-};
-
-union ipt_policy_addr
-{
-	struct in_addr	a4;
-	struct in6_addr	a6;
-};
-
-struct ipt_policy_elem
-{
-	union ipt_policy_addr	saddr;
-	union ipt_policy_addr	smask;
-	union ipt_policy_addr	daddr;
-	union ipt_policy_addr	dmask;
-	u_int32_t		spi;
-	u_int32_t		reqid;
-	u_int8_t		proto;
-	u_int8_t		mode;
-
-	struct ipt_policy_spec	match;
-	struct ipt_policy_spec	invert;
-};
-
-struct ipt_policy_info
-{
-	struct ipt_policy_elem pol[IPT_POLICY_MAX_ELEM];
-	u_int16_t flags;
-	u_int16_t len;
-};
+#define ipt_policy_spec			xt_policy_spec
+#define ipt_policy_addr			xt_policy_addr
+#define ipt_policy_elem			xt_policy_elem
+#define ipt_policy_info			xt_policy_info
 
 #endif /* _IPT_POLICY_H */
diff --git a/include/linux/netfilter_ipv4/ipt_realm.h b/include/linux/netfilter_ipv4/ipt_realm.h
index 2357731..b3996ea 100644
--- a/include/linux/netfilter_ipv4/ipt_realm.h
+++ b/include/linux/netfilter_ipv4/ipt_realm.h
@@ -1,9 +1,7 @@
 #ifndef _IPT_REALM_H
 #define _IPT_REALM_H
 
-struct ipt_realm_info {
-	u_int32_t id;
-	u_int32_t mask;
-	u_int8_t invert;
-};
-#endif /*_IPT_REALM_H*/
+#include <linux/netfilter/xt_realm.h>
+#define ipt_realm_info xt_realm_info
+
+#endif /* _IPT_REALM_H */
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
new file mode 100644
index 0000000..70465c3
--- /dev/null
+++ b/include/linux/netfilter_ipv6.h
@@ -0,0 +1,82 @@
+#ifndef __LINUX_IP6_NETFILTER_H
+#define __LINUX_IP6_NETFILTER_H
+
+/* IPv6-specific defines for netfilter. 
+ * (C)1998 Rusty Russell -- This code is GPL.
+ * (C)1999 David Jeffery
+ *   this header was blatantly ripped from netfilter_ipv4.h 
+ *   it's amazing what adding a bunch of 6s can do =8^)
+ */
+
+#include <linux/netfilter.h>
+
+/* only for userspace compatibility */
+/* IP Cache bits. */
+/* Src IP address. */
+#define NFC_IP6_SRC              0x0001
+/* Dest IP address. */
+#define NFC_IP6_DST              0x0002
+/* Input device. */
+#define NFC_IP6_IF_IN            0x0004
+/* Output device. */
+#define NFC_IP6_IF_OUT           0x0008
+/* TOS. */
+#define NFC_IP6_TOS              0x0010
+/* Protocol. */
+#define NFC_IP6_PROTO            0x0020
+/* IP options. */
+#define NFC_IP6_OPTIONS          0x0040
+/* Frag & flags. */
+#define NFC_IP6_FRAG             0x0080
+
+
+/* Per-protocol information: only matters if proto match. */
+/* TCP flags. */
+#define NFC_IP6_TCPFLAGS         0x0100
+/* Source port. */
+#define NFC_IP6_SRC_PT           0x0200
+/* Dest port. */
+#define NFC_IP6_DST_PT           0x0400
+/* Something else about the proto */
+#define NFC_IP6_PROTO_UNKNOWN    0x2000
+
+/* IP6 Hooks */
+/* After promisc drops, checksum checks. */
+#define NF_IP6_PRE_ROUTING	0
+/* If the packet is destined for this box. */
+#define NF_IP6_LOCAL_IN		1
+/* If the packet is destined for another interface. */
+#define NF_IP6_FORWARD		2
+/* Packets coming from a local process. */
+#define NF_IP6_LOCAL_OUT		3
+/* Packets about to hit the wire. */
+#define NF_IP6_POST_ROUTING	4
+#define NF_IP6_NUMHOOKS		5
+
+
+enum nf_ip6_hook_priorities {
+	NF_IP6_PRI_FIRST = INT_MIN,
+	NF_IP6_PRI_CONNTRACK_DEFRAG = -400,
+	NF_IP6_PRI_SELINUX_FIRST = -225,
+	NF_IP6_PRI_CONNTRACK = -200,
+	NF_IP6_PRI_MANGLE = -150,
+	NF_IP6_PRI_NAT_DST = -100,
+	NF_IP6_PRI_FILTER = 0,
+	NF_IP6_PRI_NAT_SRC = 100,
+	NF_IP6_PRI_SELINUX_LAST = 225,
+	NF_IP6_PRI_LAST = INT_MAX,
+};
+
+#ifdef CONFIG_NETFILTER
+extern int ip6_route_me_harder(struct sk_buff *skb);
+extern __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
+				    unsigned int dataoff, u_int8_t protocol);
+
+extern int ipv6_netfilter_init(void);
+extern void ipv6_netfilter_fini(void);
+#else /* CONFIG_NETFILTER */
+static __inline__ int ipv6_netfilter_init(void) { return 0; }
+static __inline__ void ipv6_netfilter_fini(void) { return; }
+#endif /* CONFIG_NETFILTER */
+
+#endif /*__LINUX_IP6_NETFILTER_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_policy.h b/include/linux/netfilter_ipv6/ip6t_policy.h
index 671bd81..b1c449d 100644
--- a/include/linux/netfilter_ipv6/ip6t_policy.h
+++ b/include/linux/netfilter_ipv6/ip6t_policy.h
@@ -1,58 +1,23 @@
 #ifndef _IP6T_POLICY_H
 #define _IP6T_POLICY_H
 
-#define IP6T_POLICY_MAX_ELEM	4
+#include <linux/netfilter/xt_policy.h>
 
-enum ip6t_policy_flags
-{
-	IP6T_POLICY_MATCH_IN		= 0x1,
-	IP6T_POLICY_MATCH_OUT		= 0x2,
-	IP6T_POLICY_MATCH_NONE		= 0x4,
-	IP6T_POLICY_MATCH_STRICT	= 0x8,
-};
+#define IP6T_POLICY_MAX_ELEM		XT_POLICY_MAX_ELEM
 
-enum ip6t_policy_modes
-{
-	IP6T_POLICY_MODE_TRANSPORT,
-	IP6T_POLICY_MODE_TUNNEL
-};
+/* ip6t_policy_flags */
+#define IP6T_POLICY_MATCH_IN		XT_POLICY_MATCH_IN
+#define IP6T_POLICY_MATCH_OUT		XT_POLICY_MATCH_OUT
+#define IP6T_POLICY_MATCH_NONE		XT_POLICY_MATCH_NONE
+#define IP6T_POLICY_MATCH_STRICT	XT_POLICY_MATCH_STRICT
 
-struct ip6t_policy_spec
-{
-	u_int8_t	saddr:1,
-			daddr:1,
-			proto:1,
-			mode:1,
-			spi:1,
-			reqid:1;
-};
+/* ip6t_policy_modes */
+#define IP6T_POLICY_MODE_TRANSPORT	XT_POLICY_MODE_TRANSPORT
+#define IP6T_POLICY_MODE_TUNNEL		XT_POLICY_MODE_TUNNEL
 
-union ip6t_policy_addr
-{
-	struct in_addr	a4;
-	struct in6_addr	a6;
-};
-
-struct ip6t_policy_elem
-{
-	union ip6t_policy_addr	saddr;
-	union ip6t_policy_addr	smask;
-	union ip6t_policy_addr	daddr;
-	union ip6t_policy_addr	dmask;
-	u_int32_t		spi;
-	u_int32_t		reqid;
-	u_int8_t		proto;
-	u_int8_t		mode;
-
-	struct ip6t_policy_spec	match;
-	struct ip6t_policy_spec	invert;
-};
-
-struct ip6t_policy_info
-{
-	struct ip6t_policy_elem pol[IP6T_POLICY_MAX_ELEM];
-	u_int16_t flags;
-	u_int16_t len;
-};
+#define ip6t_policy_spec		xt_policy_spec
+#define ip6t_policy_addr		xt_policy_addr
+#define ip6t_policy_elem		xt_policy_elem
+#define ip6t_policy_info		xt_policy_info
 
 #endif /* _IP6T_POLICY_H */
diff --git a/include/linux/types.h b/include/linux/types.h
new file mode 100644
index 0000000..d9e8c4f
--- /dev/null
+++ b/include/linux/types.h
@@ -0,0 +1,172 @@
+#ifndef _LINUX_TYPES_H
+#define _LINUX_TYPES_H
+
+
+#include <linux/posix_types.h>
+#include <asm/types.h>
+
+#ifndef __KERNEL_STRICT_NAMES
+
+typedef __u32 __kernel_dev_t;
+
+typedef __kernel_fd_set		fd_set;
+typedef __kernel_dev_t		dev_t;
+typedef __kernel_ino_t		ino_t;
+typedef __kernel_mode_t		mode_t;
+typedef __kernel_nlink_t	nlink_t;
+typedef __kernel_off_t		off_t;
+typedef __kernel_pid_t		pid_t;
+typedef __kernel_daddr_t	daddr_t;
+typedef __kernel_key_t		key_t;
+typedef __kernel_suseconds_t	suseconds_t;
+typedef __kernel_timer_t	timer_t;
+typedef __kernel_clockid_t	clockid_t;
+typedef __kernel_mqd_t		mqd_t;
+
+typedef __kernel_uid_t		uid_t;
+typedef __kernel_gid_t		gid_t;
+
+#if defined(__GNUC__)
+typedef __kernel_loff_t		loff_t;
+#endif
+
+/*
+ * The following typedefs are also protected by individual ifdefs for
+ * historical reasons:
+ */
+#ifndef _SIZE_T
+#define _SIZE_T
+typedef __kernel_size_t		size_t;
+#endif
+
+#ifndef _SSIZE_T
+#define _SSIZE_T
+typedef __kernel_ssize_t	ssize_t;
+#endif
+
+#ifndef _PTRDIFF_T
+#define _PTRDIFF_T
+typedef __kernel_ptrdiff_t	ptrdiff_t;
+#endif
+
+#ifndef _TIME_T
+#define _TIME_T
+typedef __kernel_time_t		time_t;
+#endif
+
+#ifndef _CLOCK_T
+#define _CLOCK_T
+typedef __kernel_clock_t	clock_t;
+#endif
+
+#ifndef _CADDR_T
+#define _CADDR_T
+typedef __kernel_caddr_t	caddr_t;
+#endif
+
+/* bsd */
+typedef unsigned char		u_char;
+typedef unsigned short		u_short;
+typedef unsigned int		u_int;
+typedef unsigned long		u_long;
+
+/* sysv */
+typedef unsigned char		unchar;
+typedef unsigned short		ushort;
+typedef unsigned int		uint;
+typedef unsigned long		ulong;
+
+#ifndef __BIT_TYPES_DEFINED__
+#define __BIT_TYPES_DEFINED__
+
+typedef		__u8		u_int8_t;
+typedef		__s8		int8_t;
+typedef		__u16		u_int16_t;
+typedef		__s16		int16_t;
+typedef		__u32		u_int32_t;
+typedef		__s32		int32_t;
+
+#endif /* !(__BIT_TYPES_DEFINED__) */
+
+typedef		__u8		uint8_t;
+typedef		__u16		uint16_t;
+typedef		__u32		uint32_t;
+
+#if defined(__GNUC__)
+typedef		__u64		uint64_t;
+typedef		__u64		u_int64_t;
+typedef		__s64		int64_t;
+#endif
+
+/* this is a special 64bit data type that is 8-byte aligned */
+#define aligned_u64 __u64 __attribute__((aligned(8)))
+#define aligned_be64 __be64 __attribute__((aligned(8)))
+#define aligned_le64 __le64 __attribute__((aligned(8)))
+
+/**
+ * The type used for indexing onto a disc or disc partition.
+ *
+ * Linux always considers sectors to be 512 bytes long independently
+ * of the devices real block size.
+ */
+#ifdef CONFIG_LBD
+typedef u64 sector_t;
+#else
+typedef unsigned long sector_t;
+#endif
+
+/*
+ * The type of the inode's block count.
+ */
+#ifdef CONFIG_LSF
+typedef u64 blkcnt_t;
+#else
+typedef unsigned long blkcnt_t;
+#endif
+
+/*
+ * The type of an index into the pagecache.  Use a #define so asm/types.h
+ * can override it.
+ */
+#ifndef pgoff_t
+#define pgoff_t unsigned long
+#endif
+
+#endif /* __KERNEL_STRICT_NAMES */
+
+/*
+ * Below are truly Linux-specific types that should never collide with
+ * any application/library that wants linux/types.h.
+ */
+
+#ifdef __CHECKER__
+#define __bitwise__ __attribute__((bitwise))
+#else
+#define __bitwise__
+#endif
+#ifdef __CHECK_ENDIAN__
+#define __bitwise __bitwise__
+#else
+#define __bitwise
+#endif
+
+typedef __u16 __bitwise __le16;
+typedef __u16 __bitwise __be16;
+typedef __u32 __bitwise __le32;
+typedef __u32 __bitwise __be32;
+#if defined(__GNUC__)
+typedef __u64 __bitwise __le64;
+typedef __u64 __bitwise __be64;
+#endif
+typedef __u16 __bitwise __sum16;
+typedef __u32 __bitwise __wsum;
+
+
+struct ustat {
+	__kernel_daddr_t	f_tfree;
+	__kernel_ino_t		f_tinode;
+	char			f_fname[6];
+	char			f_fpack[6];
+};
+
+#endif /* _LINUX_TYPES_H */

--------------080005060007040708070308--
