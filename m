From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: export sanitized nf_nat.h to
 INSTALL_HDR_PATH
Date: Tue, 11 Oct 2011 03:40:26 +0200
Message-ID: <20111011014026.GA30418@1984>
References: <1317491489-23812-1-git-send-email-basile@opensource.dyc.edu>
 <4E8753C6.1020304@opensource.dyc.edu>
 <alpine.LNX.2.01.1110021451540.12367@frira.zrqbmnf.qr>
 <4E88609E.2030404@opensource.dyc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Cc: Jan Engelhardt <jengelh@medozas.de>, davem@davemloft.net,
	kaber@trash.net, blueness@gentoo.org, gurligebis@gentoo.org,
	base-system@gentoo.org, kernel@gentoo.org, toolchain@gentoo.org,
	mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, arnd@arndb.de,
	eparis@redhat.com, netfilter-devel@vger.kernel.org
To: "Anthony G. Basile" <basile@opensource.dyc.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38758 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab1JKBkq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Oct 2011 21:40:46 -0400
Content-Disposition: inline
In-Reply-To: <4E88609E.2030404@opensource.dyc.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 02, 2011 at 09:01:18AM -0400, Anthony G. Basile wrote:
> On 10/02/2011 08:53 AM, Jan Engelhardt wrote:
> > On Saturday 2011-10-01 19:54, Anthony G. Basile wrote:
> > 
> >> As an appendix to this patch, let me add a couple of points:
> >>
> >> 1) In the union,
> >>
> >>> +union nf_conntrack_man_proto {
> >>> +	__be16 all;
> >>> +	__be16 port;
> >>> +	__be16 icmp_idnt;
> >>> +	__be16 gre_key;
> >>> +};
> >>
> >> I named the one member icmp_idnt to avoid a name collision with "#define
> >> icmp_id ..." in <netinet/ip_icmp.h>.  This causes problems in both
> >> iptables and miniupnpd.
> > 
> > Wow that's a horrible thing to do of ip_icmp.h. Such #defines should die 
> > because their scope is way too broad.
> 
> I know.  I hate it too, and it was not easy to catch.  But how else do
> we get around it?  We could do an undef, but that's just as ugly.

I found some time to take over this patch. I have compiled tested it,
it's based on yours.

I'll review it tomorrow in the morning again before pushing into into
the temporary nf-next tree (until we can move again to kernel.org):

http://1984.lsi.us.es/git/?p=net-next/.git;a=shortlog;h=refs/heads/nf-next

P.S: Yes, we're back to the ugly definition of nf_conntrack_man_proto,
I think it's the nicest solution given the problem that you spotted
with icmp_id and it keeps the patch small.

--Kj7319i9nmIyA2yE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-export-NAT-definitions-through-linux-netfi.patch"

>From 2ca5b853f1dd81c605ddc8a55e06bdad85636597 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 1 Oct 2011 13:51:29 -0400
Subject: [PATCH] netfilter: export NAT definitions through linux/netfilter_ipv4/nf_nat.h

This patch exports several definitions that used to live under
include/net/netfilter/nf_nat.h. These definitions, although not
exported, have been used by iptables and other userspace
applications like miniupnpd since long time. Basically, these
userspace tools included some internal definition of the required
structures and they assume no changes in the binary representation
(which is OK indeed).

To resolve this situation, this patch makes public the required
structure and install them in INSTALL_HDR_PATH.

See: https://bugs.gentoo.org/376873, for more information.

This patch is heavily based on the initial patch sent by:

Anthony G. Basile <blueness@gentoo.org>

Which was entitled:

netfilter: export sanitized nf_nat.h to INSTALL_HDR_PATH

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv4/Kbuild        |    1 +
 include/linux/netfilter_ipv4/nf_nat.h      |   58 ++++++++++++++++++++++++++++
 include/net/netfilter/nf_conntrack_tuple.h |   27 +------------
 include/net/netfilter/nf_nat.h             |   26 +------------
 4 files changed, 61 insertions(+), 51 deletions(-)
 create mode 100644 include/linux/netfilter_ipv4/nf_nat.h

diff --git a/include/linux/netfilter_ipv4/Kbuild b/include/linux/netfilter_ipv4/Kbuild
index f9930c8..c3b4548 100644
--- a/include/linux/netfilter_ipv4/Kbuild
+++ b/include/linux/netfilter_ipv4/Kbuild
@@ -12,3 +12,4 @@ header-y += ipt_ah.h
 header-y += ipt_ecn.h
 header-y += ipt_realm.h
 header-y += ipt_ttl.h
+header-y += nf_nat.h
diff --git a/include/linux/netfilter_ipv4/nf_nat.h b/include/linux/netfilter_ipv4/nf_nat.h
new file mode 100644
index 0000000..7a861d0
--- /dev/null
+++ b/include/linux/netfilter_ipv4/nf_nat.h
@@ -0,0 +1,58 @@
+#ifndef _LINUX_NF_NAT_H
+#define _LINUX_NF_NAT_H
+
+#include <linux/types.h>
+
+#define IP_NAT_RANGE_MAP_IPS 1
+#define IP_NAT_RANGE_PROTO_SPECIFIED 2
+#define IP_NAT_RANGE_PROTO_RANDOM 4
+#define IP_NAT_RANGE_PERSISTENT 8
+
+/* The protocol-specific manipulable parts of the tuple. */
+union nf_conntrack_man_proto {
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
+	} dccp;
+	struct {
+		__be16 port;
+	} sctp;
+	struct {
+		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
+	} gre;
+};
+
+/* Single range specification. */
+struct nf_nat_range {
+	/* Set to OR of flags above. */
+	unsigned int flags;
+
+	/* Inclusive: network order. */
+	__be32 min_ip, max_ip;
+
+	/* Inclusive: network order */
+	union nf_conntrack_man_proto min, max;
+};
+
+/* For backwards compat: don't use in modern code. */
+struct nf_nat_multi_range_compat {
+	unsigned int rangesize; /* Must be 1. */
+
+	/* hangs off end. */
+	struct nf_nat_range range[1];
+};
+
+#define nf_nat_multi_range nf_nat_multi_range_compat
+
+#endif
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 7ca6bdd..2f8fb77 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -12,6 +12,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <linux/netfilter_ipv4/nf_nat.h>
 #include <linux/list_nulls.h>
 
 /* A `tuple' is a structure containing the information to uniquely
@@ -24,32 +25,6 @@
 
 #define NF_CT_TUPLE_L3SIZE	ARRAY_SIZE(((union nf_inet_addr *)NULL)->all)
 
-/* The protocol-specific manipulable parts of the tuple: always in
-   network order! */
-union nf_conntrack_man_proto {
-	/* Add other protocols here. */
-	__be16 all;
-
-	struct {
-		__be16 port;
-	} tcp;
-	struct {
-		__be16 port;
-	} udp;
-	struct {
-		__be16 id;
-	} icmp;
-	struct {
-		__be16 port;
-	} dccp;
-	struct {
-		__be16 port;
-	} sctp;
-	struct {
-		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
-	} gre;
-};
-
 /* The manipulable part of the tuple. */
 struct nf_conntrack_man {
 	union nf_inet_addr u3;
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 0346b00..b8872df 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -1,6 +1,7 @@
 #ifndef _NF_NAT_H
 #define _NF_NAT_H
 #include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv4/nf_nat.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
 #define NF_NAT_MAPPING_TYPE_MAX_NAMELEN 16
@@ -14,11 +15,6 @@ enum nf_nat_manip_type {
 #define HOOK2MANIP(hooknum) ((hooknum) != NF_INET_POST_ROUTING && \
 			     (hooknum) != NF_INET_LOCAL_IN)
 
-#define IP_NAT_RANGE_MAP_IPS 1
-#define IP_NAT_RANGE_PROTO_SPECIFIED 2
-#define IP_NAT_RANGE_PROTO_RANDOM 4
-#define IP_NAT_RANGE_PERSISTENT 8
-
 /* NAT sequence number modifications */
 struct nf_nat_seq {
 	/* position of the last TCP sequence number modification (if any) */
@@ -28,26 +24,6 @@ struct nf_nat_seq {
 	int16_t offset_before, offset_after;
 };
 
-/* Single range specification. */
-struct nf_nat_range {
-	/* Set to OR of flags above. */
-	unsigned int flags;
-
-	/* Inclusive: network order. */
-	__be32 min_ip, max_ip;
-
-	/* Inclusive: network order */
-	union nf_conntrack_man_proto min, max;
-};
-
-/* For backwards compat: don't use in modern code. */
-struct nf_nat_multi_range_compat {
-	unsigned int rangesize; /* Must be 1. */
-
-	/* hangs off end. */
-	struct nf_nat_range range[1];
-};
-
 #include <linux/list.h>
 #include <linux/netfilter/nf_conntrack_pptp.h>
 #include <net/netfilter/nf_conntrack_extend.h>
-- 
1.7.2.5


--Kj7319i9nmIyA2yE--
