From: Philip Craig <philipc@snapgear.com>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Tue, 29 Apr 2008 14:48:27 +1000
Message-ID: <4816A89B.7050300@snapgear.com>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain> <20080130201757.29874.54202.sendpatchset@localhost.localdomain> <481589D2.2050901@snapgear.com> <4815D842.8010303@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080303000305050405040109"
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org,
	Russell King <rmk@arm.linux.org.uk>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:35519 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753542AbYD2Esb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 00:48:31 -0400
In-Reply-To: <4815D842.8010303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080303000305050405040109
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Thanks for tracking this down, I didn't realize we had holes
> in struct nf_conntrack_tuple on ARM. There are two ways to
> fix this, one is two remove the padding, the other one is to
> clear the padding as you did. We could join all the tuple
> structs to avoid padding, but unfortunately that probably
> won't help because the port structs are also padded. Maybe
> attribute(packed) on the individual port structs within the
> union will work, I'm not sure about that.

I prefer to remove the padding so that we don't change how other
architectures work.  The attached patch does this.  I'm not sure
if this has any performance penalties on ARM. 

The attribute(packed) is required on both the port structs
and the unions.


--------------080303000305050405040109
Content-Type: text/x-diff;
 name="conntrack-hash-padding.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="conntrack-hash-padding.patch"

[NETFILTER]: nf_conntrack: padding breaks conntrack hash on ARM

commit 0794935e "[NETFILTER]: nf_conntrack: optimize hash_conntrack()"
relies on struct nf_conntrack_tuple containing no padding, because
NF_CT_TUPLE_U_BLANK() would leave any padding uninitialised.

But on ARM, structures are normally padded to 4 bytes.  So use
__attribute__(packed) to eliminate this padding.

However, we must be careful to keep the userspace ABI unchanged.

Signed-off-by: Philip Craig <philipc@snapgear.com>

--- linux-2.6.25/include/net/netfilter/nf_conntrack_tuple.h	22 Apr 2008 01:36:51 -0000	1.1.1.5
+++ linux-2.6.25/include/net/netfilter/nf_conntrack_tuple.h	29 Apr 2008 04:14:14 -0000
@@ -32,20 +32,20 @@ union nf_conntrack_man_proto
 
 	struct {
 		__be16 port;
-	} tcp;
+	} __attribute__ ((packed)) tcp;
 	struct {
 		__be16 port;
-	} udp;
+	} __attribute__ ((packed)) udp;
 	struct {
 		__be16 id;
-	} icmp;
+	} __attribute__ ((packed)) icmp;
 	struct {
 		__be16 port;
-	} sctp;
+	} __attribute__ ((packed)) sctp;
 	struct {
 		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
-	} gre;
-};
+	} __attribute__ ((packed)) gre;
+} __attribute__ ((packed));
 
 /* The manipulable part of the tuple. */
 struct nf_conntrack_man
@@ -56,7 +56,10 @@ struct nf_conntrack_man
 	u_int16_t l3num;
 };
 
-/* This contains the information to distinguish a connection. */
+/* This contains the information to distinguish a connection.
+ * This must be packed because the contents are used for the conntrack
+ * hash, but NF_CT_TUPLE_U_BLANK() would leave any padding uninitialised.
+ */
 struct nf_conntrack_tuple
 {
 	struct nf_conntrack_man src;
@@ -70,20 +73,20 @@ struct nf_conntrack_tuple
 
 			struct {
 				__be16 port;
-			} tcp;
+			} __attribute__ ((packed)) tcp;
 			struct {
 				__be16 port;
-			} udp;
+			} __attribute__ ((packed)) udp;
 			struct {
 				u_int8_t type, code;
-			} icmp;
+			} __attribute__ ((packed)) icmp;
 			struct {
 				__be16 port;
-			} sctp;
+			} __attribute__ ((packed)) sctp;
 			struct {
 				__be16 key;
-			} gre;
-		} u;
+			} __attribute__ ((packed)) gre;
+		} __attribute__ ((packed)) u;
 
 		/* The protocol. */
 		u_int8_t protonum;
--- linux-2.6.25/include/net/netfilter/nf_nat.h	22 Apr 2008 01:36:51 -0000	1.1.1.4
+++ linux-2.6.25/include/net/netfilter/nf_nat.h	29 Apr 2008 04:14:14 -0000
@@ -42,12 +42,50 @@ struct nf_nat_range
 };
 
 /* For backwards compat: don't use in modern code. */
+
+/* The protocol-specific manipulable parts of the tuple: always in
+   network order! */
+union nf_conntrack_man_proto_compat
+{
+	/* Add other protocols here. */
+	__be16 all;
+
+	struct {
+		__be16 port;
+	} tcp;
+	struct {
+		__be16 port;
+	} udp;
+	struct {
+		__be16 id;
+	} icmp;
+	struct {
+		__be16 port;
+	} sctp;
+	struct {
+		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
+	} gre;
+};
+
+/* Single range specification. */
+struct nf_nat_range_compat
+{
+	/* Set to OR of flags above. */
+	unsigned int flags;
+
+	/* Inclusive: network order. */
+	__be32 min_ip, max_ip;
+
+	/* Inclusive: network order */
+	union nf_conntrack_man_proto_compat min, max;
+};
+
 struct nf_nat_multi_range_compat
 {
 	unsigned int rangesize; /* Must be 1. */
 
 	/* hangs off end. */
-	struct nf_nat_range range[1];
+	struct nf_nat_range_compat range[1];
 };
 
 #ifdef __KERNEL__
--- linux-2.6.25/net/ipv4/netfilter/ipt_MASQUERADE.c	22 Apr 2008 01:38:00 -0000	1.1.1.26
+++ linux-2.6.25/net/ipv4/netfilter/ipt_MASQUERADE.c	29 Apr 2008 04:14:14 -0000
@@ -92,7 +92,8 @@ masquerade_tg(struct sk_buff *skb, const
 	newrange = ((struct nf_nat_range)
 		{ mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
 		  newsrc, newsrc,
-		  mr->range[0].min, mr->range[0].max });
+		  { .all = mr->range[0].min.all },
+		  { .all = mr->range[0].max.all } });
 
 	/* Hand modified range to generic setup. */
 	return nf_nat_setup_info(ct, &newrange, IP_NAT_MANIP_SRC);
--- linux-2.6.25/net/ipv4/netfilter/ipt_NETMAP.c	22 Apr 2008 01:38:00 -0000	1.1.1.14
+++ linux-2.6.25/net/ipv4/netfilter/ipt_NETMAP.c	29 Apr 2008 04:14:14 -0000
@@ -67,7 +67,8 @@ netmap_tg(struct sk_buff *skb, const str
 	newrange = ((struct nf_nat_range)
 		{ mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
 		  new_ip, new_ip,
-		  mr->range[0].min, mr->range[0].max });
+		  { .all = mr->range[0].min.all },
+		  { .all = mr->range[0].max.all } });
 
 	/* Hand modified range to generic setup. */
 	return nf_nat_setup_info(ct, &newrange, HOOK2MANIP(hooknum));
--- linux-2.6.25/net/ipv4/netfilter/ipt_REDIRECT.c	22 Apr 2008 01:38:00 -0000	1.1.1.18
+++ linux-2.6.25/net/ipv4/netfilter/ipt_REDIRECT.c	29 Apr 2008 04:14:14 -0000
@@ -84,7 +84,8 @@ redirect_tg(struct sk_buff *skb, const s
 	newrange = ((struct nf_nat_range)
 		{ mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
 		  newdst, newdst,
-		  mr->range[0].min, mr->range[0].max });
+		  { .all = mr->range[0].min.all },
+		  { .all = mr->range[0].max.all } });
 
 	/* Hand modified range to generic setup. */
 	return nf_nat_setup_info(ct, &newrange, IP_NAT_MANIP_DST);
--- linux-2.6.25/net/ipv4/netfilter/nf_nat_rule.c	22 Apr 2008 01:38:00 -0000	1.1.1.6
+++ linux-2.6.25/net/ipv4/netfilter/nf_nat_rule.c	29 Apr 2008 04:14:14 -0000
@@ -78,6 +78,7 @@ static unsigned int ipt_snat_target(stru
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_nat_multi_range_compat *mr = targinfo;
+	struct nf_nat_range newrange;
 
 	NF_CT_ASSERT(hooknum == NF_INET_POST_ROUTING);
 
@@ -88,7 +89,13 @@ static unsigned int ipt_snat_target(stru
 			    ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
 	NF_CT_ASSERT(out);
 
-	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_SRC);
+	newrange = ((struct nf_nat_range)
+		{ mr->range[0].flags,
+		  mr->range[0].min_ip, mr->range[0].max_ip,
+		  { .all = mr->range[0].min.all },
+		  { .all = mr->range[0].max.all } });
+
+	return nf_nat_setup_info(ct, &newrange, IP_NAT_MANIP_SRC);
 }
 
 /* Before 2.6.11 we did implicit source NAT if required. Warn about change. */
@@ -120,6 +127,7 @@ static unsigned int ipt_dnat_target(stru
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_nat_multi_range_compat *mr = targinfo;
+	struct nf_nat_range newrange;
 
 	NF_CT_ASSERT(hooknum == NF_INET_PRE_ROUTING ||
 		     hooknum == NF_INET_LOCAL_OUT);
@@ -134,7 +142,13 @@ static unsigned int ipt_dnat_target(stru
 		warn_if_extra_mangle(ip_hdr(skb)->daddr,
 				     mr->range[0].min_ip);
 
-	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_DST);
+	newrange = ((struct nf_nat_range)
+		{ mr->range[0].flags,
+		  mr->range[0].min_ip, mr->range[0].max_ip,
+		  { .all = mr->range[0].min.all },
+		  { .all = mr->range[0].max.all } });
+
+	return nf_nat_setup_info(ct, &newrange, IP_NAT_MANIP_DST);
 }
 
 static bool ipt_snat_checkentry(const char *tablename,

--------------080303000305050405040109--
