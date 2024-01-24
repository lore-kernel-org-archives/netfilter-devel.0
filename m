Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8871802E
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2024 09:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706089848; cv=none; b=qKSIkwFrlTtj3oF+QhH4iaXTIdZRGVU5NmW9yibvbggbaq43YrcJY4AdIHTE8D6pbR3wpAH5On0m3NdUupZrZ8T7uxBX+iw6PAcw6HaODc92Lia0QwTshCz2xzXkW9r1MRbw1O5xM8LAh0LWBcHWP4QeoWcZDdrAFoCFXvjWfSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706089848; c=relaxed/simple;
	bh=y2imNTJYPikQUQ6c5YpHCYGACofyh6QJ+HnQP4QPMgc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FwlrEbhwY9XCgtpRbXeEbjdgrnjSWiD8yxEL3ficUQfX+zpSnaQXNqMpvMD+03FqSWsVCgURm1wuffKJPtpTcmf/f+v4jlw3dUebAPO3oyRIruY7AYC0VY0A/nSGmozD+xXBaXgvqI2ocyDNeeYWMF38pFyV50qEE8nlZmTxIkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rSZu2-0007fW-8q; Wed, 24 Jan 2024 10:50:38 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/2] netfilter: xtables: add _LEGACY kconfig symbol
Date: Wed, 24 Jan 2024 10:21:11 +0100
Message-ID: <20240124092116.7396-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows to build a kernel that only supports ip(6)tables-nft
(iptables-over-nftables api).

The symbols are hidden: When any of the "old" builtin tables
are enabled the "old" iptables interface will be supported.

To disable the old set/getsockopt interface the existing options
for the builtin tables need to be turned off:

CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_FILTER is not set
CONFIG_IP_NF_NAT is not set
CONFIG_IP_NF_MANGLE is not set
CONFIG_IP_NF_RAW is not set
CONFIG_IP_NF_SECURITY is not set

Same for CONFIG_IP6_NF_ versions.

In the future the _LEGACY symbol will become visible and the select
statements will be turned into 'depends on'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/Kconfig  | 15 ++++++++++++---
 net/ipv4/netfilter/Makefile |  2 +-
 net/ipv6/netfilter/Kconfig  | 20 ++++++++++++++------
 net/ipv6/netfilter/Makefile |  2 +-
 net/netfilter/Kconfig       | 12 ++++++------
 5 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 070475392236..783523087281 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -10,6 +10,10 @@ config NF_DEFRAG_IPV4
 	tristate
 	default n
 
+# old sockopt interface and eval loop
+config IP_NF_IPTABLES_LEGACY
+	tristate
+
 config NF_SOCKET_IPV4
 	tristate "IPv4 socket lookup support"
 	help
@@ -152,7 +156,7 @@ config IP_NF_MATCH_ECN
 config IP_NF_MATCH_RPFILTER
 	tristate '"rpfilter" reverse path filter match support'
 	depends on NETFILTER_ADVANCED
-	depends on IP_NF_MANGLE || IP_NF_RAW
+	depends on IP_NF_MANGLE || IP_NF_RAW || NFT_COMPAT
 	help
 	  This option allows you to match packets whose replies would
 	  go out via the interface the packet came in.
@@ -173,6 +177,7 @@ config IP_NF_MATCH_TTL
 config IP_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=n
+	select IP_NF_IPTABLES_LEGACY
 	help
 	  Packet filtering defines a table `filter', which has a series of
 	  rules for simple packet filtering at local input, forwarding and
@@ -182,7 +187,7 @@ config IP_NF_FILTER
 
 config IP_NF_TARGET_REJECT
 	tristate "REJECT target support"
-	depends on IP_NF_FILTER
+	depends on IP_NF_FILTER || NFT_COMPAT
 	select NF_REJECT_IPV4
 	default m if NETFILTER_ADVANCED=n
 	help
@@ -212,6 +217,7 @@ config IP_NF_NAT
 	default m if NETFILTER_ADVANCED=n
 	select NF_NAT
 	select NETFILTER_XT_NAT
+	select IP6_NF_IPTABLES_LEGACY
 	help
 	  This enables the `nat' table in iptables. This allows masquerading,
 	  port forwarding and other forms of full Network Address Port
@@ -252,6 +258,7 @@ endif # IP_NF_NAT
 config IP_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=n
+	select IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -261,7 +268,7 @@ config IP_NF_MANGLE
 
 config IP_NF_TARGET_ECN
 	tristate "ECN target support"
-	depends on IP_NF_MANGLE
+	depends on IP_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `ECN' target, which can be used in the iptables mangle
@@ -286,6 +293,7 @@ config IP_NF_TARGET_TTL
 # raw + specific targets
 config IP_NF_RAW
 	tristate  'raw table support (required for NOTRACK/TRACE)'
+	select IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to iptables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -299,6 +307,7 @@ config IP_NF_SECURITY
 	tristate "Security table"
 	depends on SECURITY
 	depends on NETFILTER_ADVANCED
+	select IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 5a26f9de1ab9..85502d4dfbb4 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -25,7 +25,7 @@ obj-$(CONFIG_NFT_FIB_IPV4) += nft_fib_ipv4.o
 obj-$(CONFIG_NFT_DUP_IPV4) += nft_dup_ipv4.o
 
 # generic IP tables
-obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
+obj-$(CONFIG_IP_NF_IPTABLES_LEGACY) += ip_tables.o
 
 # the three instances of ip_tables
 obj-$(CONFIG_IP_NF_FILTER) += iptable_filter.o
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 0ba62f4868f9..f3c8e2d918e1 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -6,6 +6,10 @@
 menu "IPv6: Netfilter Configuration"
 	depends on INET && IPV6 && NETFILTER
 
+# old sockopt interface and eval loop
+config IP6_NF_IPTABLES_LEGACY
+	tristate
+
 config NF_SOCKET_IPV6
 	tristate "IPv6 socket lookup support"
 	help
@@ -147,7 +151,7 @@ config IP6_NF_MATCH_MH
 config IP6_NF_MATCH_RPFILTER
 	tristate '"rpfilter" reverse path filter match support'
 	depends on NETFILTER_ADVANCED
-	depends on IP6_NF_MANGLE || IP6_NF_RAW
+	depends on IP6_NF_MANGLE || IP6_NF_RAW || NFT_COMPAT
 	help
 	  This option allows you to match packets whose replies would
 	  go out via the interface the packet came in.
@@ -186,6 +190,8 @@ config IP6_NF_TARGET_HL
 config IP6_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=n
+	select IP6_NF_IPTABLES_LEGACY
+	tristate
 	help
 	  Packet filtering defines a table `filter', which has a series of
 	  rules for simple packet filtering at local input, forwarding and
@@ -195,7 +201,7 @@ config IP6_NF_FILTER
 
 config IP6_NF_TARGET_REJECT
 	tristate "REJECT target support"
-	depends on IP6_NF_FILTER
+	depends on IP6_NF_FILTER || NFT_COMPAT
 	select NF_REJECT_IPV6
 	default m if NETFILTER_ADVANCED=n
 	help
@@ -221,6 +227,7 @@ config IP6_NF_TARGET_SYNPROXY
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=n
+	select IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -230,6 +237,7 @@ config IP6_NF_MANGLE
 
 config IP6_NF_RAW
 	tristate  'raw table support (required for TRACE)'
+	select IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to ip6tables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -243,6 +251,7 @@ config IP6_NF_SECURITY
 	tristate "Security table"
 	depends on SECURITY
 	depends on NETFILTER_ADVANCED
+	select IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
@@ -254,6 +263,7 @@ config IP6_NF_NAT
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	select NF_NAT
+	select IP6_NF_IPTABLES_LEGACY
 	select NETFILTER_XT_NAT
 	help
 	  This enables the `nat' table in ip6tables. This allows masquerading,
@@ -262,25 +272,23 @@ config IP6_NF_NAT
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-if IP6_NF_NAT
-
 config IP6_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
 	select NETFILTER_XT_TARGET_MASQUERADE
+	depends on IP6_NF_NAT
 	help
 	  This is a backwards-compat option for the user's convenience
 	  (e.g. when running oldconfig). It selects NETFILTER_XT_TARGET_MASQUERADE.
 
 config IP6_NF_TARGET_NPT
 	tristate "NPT (Network Prefix translation) target support"
+	depends on IP6_NF_NAT || NFT_COMPAT
 	help
 	  This option adds the `SNPT' and `DNPT' target, which perform
 	  stateless IPv6-to-IPv6 Network Prefix Translation per RFC 6296.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-endif # IP6_NF_NAT
-
 endif # IP6_NF_IPTABLES
 endmenu
 
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index b8d6dc9aeeb6..66ce6fa5b2f5 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 # Link order matters here.
-obj-$(CONFIG_IP6_NF_IPTABLES) += ip6_tables.o
+obj-$(CONFIG_IP6_NF_IPTABLES_LEGACY) += ip6_tables.o
 obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o
 obj-$(CONFIG_IP6_NF_MANGLE) += ip6table_mangle.o
 obj-$(CONFIG_IP6_NF_RAW) += ip6table_raw.o
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 441d1f134110..df2dc21304ef 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -818,7 +818,7 @@ config NETFILTER_XT_TARGET_AUDIT
 
 config NETFILTER_XT_TARGET_CHECKSUM
 	tristate "CHECKSUM target support"
-	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `CHECKSUM' target, which can be used in the iptables mangle
@@ -869,7 +869,7 @@ config NETFILTER_XT_TARGET_CONNSECMARK
 config NETFILTER_XT_TARGET_CT
 	tristate '"CT" target support'
 	depends on NF_CONNTRACK
-	depends on IP_NF_RAW || IP6_NF_RAW
+	depends on IP_NF_RAW || IP6_NF_RAW || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
 	help
 	  This options adds a `CT' target, which allows to specify initial
@@ -880,7 +880,7 @@ config NETFILTER_XT_TARGET_CT
 
 config NETFILTER_XT_TARGET_DSCP
 	tristate '"DSCP" and "TOS" target support'
-	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `DSCP' target, which allows you to manipulate
@@ -896,7 +896,7 @@ config NETFILTER_XT_TARGET_DSCP
 
 config NETFILTER_XT_TARGET_HL
 	tristate '"HL" hoplimit target support'
-	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
 	help
 	This option adds the "HL" (for IPv6) and "TTL" (for IPv4)
@@ -1080,7 +1080,7 @@ config NETFILTER_XT_TARGET_TPROXY
 	depends on NETFILTER_ADVANCED
 	depends on IPV6 || IPV6=n
 	depends on IP6_NF_IPTABLES || IP6_NF_IPTABLES=n
-	depends on IP_NF_MANGLE
+	depends on IP_NF_MANGLE || NFT_COMPAT
 	select NF_DEFRAG_IPV4
 	select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES != n
 	select NF_TPROXY_IPV4
@@ -1147,7 +1147,7 @@ config NETFILTER_XT_TARGET_TCPMSS
 
 config NETFILTER_XT_TARGET_TCPOPTSTRIP
 	tristate '"TCPOPTSTRIP" target support'
-	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
-- 
2.43.0

