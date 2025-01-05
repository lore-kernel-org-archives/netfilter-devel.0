Received: from smtp-out.freemail.hu (fmfe38.freemail.hu [46.107.16.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4A81D63D4;
	Sun,  5 Jan 2025 23:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736119966; cv=none; b=C9+mwf1r0TWl09t2nnDgYtVavMP5lRVueywT81xjCV6R6sSjn6M39rWxIcdSvUG4/K/1/++BinRpWN0RaO40+fy+btrJFw36drZyhhbtqS8Og//2p6fZfQ78zSwdfMM9o6LfmYkoCbsb13A0CKuqBZL1DKMLPifLhpz0aH2jHt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736119966; c=relaxed/simple;
	bh=HnI5Sa0T1Vqv2wzWxZbxIOQJYSQBSMcj9rwb2uSHF7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GBeDnRyI7a7G3N/7Ai3V0pSkwm0Rbe6wF550667h1yMr/YVQ777pDeWiKo5oDXPlYx91iUSbMajh5slWBbG84h+FsmPN6aXUX+tCoZKdm98d6Du13XChnVZ3ByrHYjk1fY+CuJbuXQemeaDIjUZM/ObDrbFZALNADyMxTZ9iU7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=erqjyXPr reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="erqjyXPr"
Received: from fizweb.elte.hu (fizweb.elte.hu [157.181.183.248])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRDBG2qkFzYhk;
	Mon, 06 Jan 2025 00:32:38 +0100 (CET)
From: egyszeregy@freemail.hu
To: fw@strlen.de,
	pablo@netfilter.org,
	lorenzo@kernel.org,
	daniel@iogearbox.net,
	leitao@debian.org,
	amiculas@cisco.com,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: =?UTF-8?q?Benjamin=20Sz=C5=91ke?= <egyszeregy@freemail.hu>
Subject: [PATCH v7 2/3] netfilter: x_tables: Merge xt_*.c files which has same name.
Date: Mon,  6 Jan 2025 00:31:56 +0100
Message-ID: <20250105233157.6814-3-egyszeregy@freemail.hu>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250105233157.6814-1-egyszeregy@freemail.hu>
References: <20250105233157.6814-1-egyszeregy@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736119959;
	s=20181004; d=freemail.hu;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	l=65335; bh=tz5DixrbAaYXLCFcv2LtHN6nFo3ldpi6cNJok4qexAk=;
	b=erqjyXPr3SDw963pYJfVJt0RffKpmPKOwXI7o0/xLkbmZfGuZXb5geiR2K7Wozhd
	ztUqpnZ545SeX8X006cm9qtyk2jkpNzzIuv8o9+lbjkU9PL+Y73/dFK176UTiRNXKTd
	lVmI8gYqa0QyJ98qZQj7bxzl+haWX5iR8N7a0U3eBQ+oeda7h5fjrqzXwq7xYk1MTM8
	OO8jHUzbEcC9xUUE+Su3d4pQpm5P7SXUZGN2tFkkMw7POtLXX+FWjo2LBRGd8B6q2fA
	/cBllOuvDHMAggG641vwPMbuZF2zBOO5lpEWrNsEhsnMYiCkrDul8p+5zi8ORWGNzxT
	ZNLoRpOj1A==

From: Benjamin Szőke <egyszeregy@freemail.hu>

Merge xt_*.c source files, which has same upper and
lower case name format. Combining these modules should
provide some decent code size and memory savings.

Merge licenses, codes and adjuste Kconfig and Makefile
for backwards-compatibility.

test-build:
$ mkdir build
$ wget -O ./build/.config https://pastebin.com/raw/teShg1sp
$ make O=./build/ ARCH=x86 -j 16

x86_64-before:
text    data     bss     dec     hex filename
 716     432       0    1148     47c xt_dscp.o
1142     432       0    1574     626 xt_DSCP.o
 593     224       0     817     331 xt_hl.o
 934     224       0    1158     486 xt_HL.o
1099     120       0    1219     4c3 xt_rateest.o
2126     365       4    2495     9bf xt_RATEEST.o
 747     224       0     971     3cb xt_tcpmss.o
2824     352       0    3176     c68 xt_TCPMSS.o
total data: 2373

x86_64-after:
text    data     bss     dec     hex filename
1709     848       0    2557     9fd xt_dscp.o
1352     448       0    1800     708 xt_hl.o
3075     481       4    3560     de8 xt_rateest.o
3423     576       0    3999     f9f xt_tcpmss.o
total data: 2353

Signed-off-by: Benjamin Szőke <egyszeregy@freemail.hu>
---
 net/netfilter/Kconfig      |  84 +++++++++
 net/netfilter/Makefile     |  12 +-
 net/netfilter/xt_DSCP.c    | 161 -----------------
 net/netfilter/xt_HL.c      | 159 -----------------
 net/netfilter/xt_RATEEST.c | 248 --------------------------
 net/netfilter/xt_TCPMSS.c  | 345 ------------------------------------
 net/netfilter/xt_dscp.c    | 156 +++++++++++++++-
 net/netfilter/xt_hl.c      | 160 ++++++++++++++++-
 net/netfilter/xt_rateest.c | 253 ++++++++++++++++++++++++--
 net/netfilter/xt_tcpmss.c  | 353 +++++++++++++++++++++++++++++++++++--
 10 files changed, 971 insertions(+), 960 deletions(-)
 delete mode 100644 net/netfilter/xt_DSCP.c
 delete mode 100644 net/netfilter/xt_HL.c
 delete mode 100644 net/netfilter/xt_RATEEST.c
 delete mode 100644 net/netfilter/xt_TCPMSS.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index df2dc21304ef..34fbdfdbdde9 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -802,6 +802,51 @@ config NETFILTER_XT_SET
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_DSCP
+	tristate '"DSCP" and "TOS" target and match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds the "DSCP" target and "dscp" match.
+
+	  Netfilter dscp matching which allows you to match against the
+	  IPv4/IPv6 header DSCP field (differentiated services codepoint).
+	  The target allows you to manipulate the IPv4/IPv6
+	  header DSCP field (differentiated services codepoint).
+
+config NETFILTER_XT_HL
+	tristate '"HL" hoplimit target and match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds the "HL" target and "hl" match.
+
+	  Netfilter hl matching allows you to match packets based on
+	  the hoplimit in the IPv6 header, or the time-to-live field in
+	  the IPv4 header of the packet.
+	  The target allows you to change the hoplimit/time-to-live
+	  value of the IP header.
+
+config NETFILTER_XT_RATEEST
+	tristate '"RATEEST" target and match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds the "RATEEST" target and "rateest" match.
+
+	  Netfilter rateest matching allows you to match on the rate
+	  estimated by the RATEEST target.
+	  The target allows you to measure rates similar to TC estimators.
+
+config NETFILTER_XT_TCPMSS
+	tristate '"TCPMSS" target and match support'
+	depends on IPV6 || IPV6=n
+	default m if NETFILTER_ADVANCED=n
+	help
+	  This option adds the "TCPMSS" target and "tcpmss" match.
+
+	  Netfilter tcpmss matching allows you to examine the MSS value of
+	  TCP SYN packets, which control the maximum packet size for that connection.
+	  The target allows you to alter the MSS value of TCP SYN packets,
+	  to control the maximum size for that connection.
+
 # alphabetically ordered list of targets
 
 comment "Xtables targets"
@@ -882,6 +927,7 @@ config NETFILTER_XT_TARGET_DSCP
 	tristate '"DSCP" and "TOS" target support'
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_DSCP
 	help
 	  This option adds a `DSCP' target, which allows you to manipulate
 	  the IPv4/IPv6 header DSCP field (differentiated services codepoint).
@@ -892,12 +938,17 @@ config NETFILTER_XT_TARGET_DSCP
 	  the "mangle" table which alter the Type Of Service field of an IPv4
 	  or the Priority field of an IPv6 packet, prior to routing.
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_DSCP (combined dscp/DSCP module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_HL
 	tristate '"HL" hoplimit target support'
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE || NFT_COMPAT
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_HL
 	help
 	This option adds the "HL" (for IPv6) and "TTL" (for IPv4)
 	targets, which enable the user to change the
@@ -909,6 +960,10 @@ config NETFILTER_XT_TARGET_HL
 	since you can easily create immortal packets that loop
 	forever on the network.
 
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects
+	CONFIG_NETFILTER_XT_HL (combined hl/HL module).
+
 config NETFILTER_XT_TARGET_HMARK
 	tristate '"HMARK" target support'
 	depends on IP6_NF_IPTABLES || IP6_NF_IPTABLES=n
@@ -1029,11 +1084,16 @@ config NETFILTER_XT_TARGET_NOTRACK
 config NETFILTER_XT_TARGET_RATEEST
 	tristate '"RATEEST" target support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_RATEEST
 	help
 	  This option adds a `RATEEST' target, which allows to measure
 	  rates similar to TC estimators. The `rateest' match can be
 	  used to match on the measured rates.
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_RATEEST (combined rateest/RATEEST module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_REDIRECT
@@ -1122,6 +1182,7 @@ config NETFILTER_XT_TARGET_TCPMSS
 	tristate '"TCPMSS" target support'
 	depends on IPV6 || IPV6=n
 	default m if NETFILTER_ADVANCED=n
+	select NETFILTER_XT_TCPMSS
 	help
 	  This option adds a `TCPMSS' target, which allows you to alter the
 	  MSS value of TCP SYN packets, to control the maximum size for that
@@ -1143,6 +1204,10 @@ config NETFILTER_XT_TARGET_TCPMSS
 	  iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN \
 	                 -j TCPMSS --clamp-mss-to-pmtu
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_TCPMSS (combined tcpmss/TCPMSS module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_TARGET_TCPOPTSTRIP
@@ -1301,6 +1366,7 @@ config NETFILTER_XT_MATCH_DEVGROUP
 config NETFILTER_XT_MATCH_DSCP
 	tristate '"dscp" and "tos" match support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_DSCP
 	help
 	  This option adds a `DSCP' match, which allows you to match against
 	  the IPv4/IPv6 header DSCP field (differentiated services codepoint).
@@ -1311,6 +1377,10 @@ config NETFILTER_XT_MATCH_DSCP
 	  based on the Type Of Service fields of the IPv4 packet (which share
 	  the same bits as DSCP).
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_DSCP (combined dscp/DSCP module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_ECN
@@ -1359,11 +1429,16 @@ config NETFILTER_XT_MATCH_HELPER
 config NETFILTER_XT_MATCH_HL
 	tristate '"hl" hoplimit/TTL match support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_HL
 	help
 	HL matching allows you to match packets based on the hoplimit
 	in the IPv6 header, or the time-to-live field in the IPv4
 	header of the packet.
 
+	This is a backwards-compat option for the user's convenience
+	(e.g. when running oldconfig). It selects
+	CONFIG_NETFILTER_XT_HL (combined hl/HL module).
+
 config NETFILTER_XT_MATCH_IPCOMP
 	tristate '"ipcomp" match support'
 	depends on NETFILTER_ADVANCED
@@ -1533,6 +1608,10 @@ config NETFILTER_XT_MATCH_RATEEST
 	  This option adds a `rateest' match, which allows to match on the
 	  rate estimated by the RATEEST target.
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_RATEEST (combined rateest/RATEEST module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_REALM
@@ -1625,11 +1704,16 @@ config NETFILTER_XT_MATCH_STRING
 config NETFILTER_XT_MATCH_TCPMSS
 	tristate '"tcpmss" match support'
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_XT_TCPMSS
 	help
 	  This option adds a `tcpmss' match, which allows you to examine the
 	  MSS value of TCP SYN packets, which control the maximum packet size
 	  for that connection.
 
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_TCPMSS (combined tcpmss/TCPMSS module).
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_TIME
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index f0aa4d7ef499..df6bfa46e6ab 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -160,6 +160,10 @@ obj-$(CONFIG_NETFILTER_XT_MARK) += xt_mark.o
 obj-$(CONFIG_NETFILTER_XT_CONNMARK) += xt_connmark.o
 obj-$(CONFIG_NETFILTER_XT_SET) += xt_set.o
 obj-$(CONFIG_NETFILTER_XT_NAT) += xt_nat.o
+obj-$(CONFIG_NETFILTER_XT_DSCP) += xt_dscp.o
+obj-$(CONFIG_NETFILTER_XT_HL) += xt_hl.o
+obj-$(CONFIG_NETFILTER_XT_RATEEST) += xt_rateest.o
+obj-$(CONFIG_NETFILTER_XT_TCPMSS) += xt_tcpmss.o
 
 # targets
 obj-$(CONFIG_NETFILTER_XT_TARGET_AUDIT) += xt_AUDIT.o
@@ -167,20 +171,16 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_CHECKSUM) += xt_CHECKSUM.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_CLASSIFY.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_CT) += xt_CT.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_HL) += xt_HL.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_HMARK) += xt_HMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_LED) += xt_LED.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_LOG) += xt_LOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NETMAP) += xt_NETMAP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_REDIRECT) += xt_REDIRECT.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_MASQUERADE) += xt_MASQUERADE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) += xt_TEE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
@@ -198,12 +198,10 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_CONNTRACK) += xt_conntrack.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_CPU) += xt_cpu.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DCCP) += xt_dccp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_DEVGROUP) += xt_devgroup.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ECN) += xt_ecn.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_ESP) += xt_esp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) += xt_hashlimit.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_HELPER) += xt_helper.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_HL) += xt_hl.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_IPCOMP) += xt_ipcomp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_IPRANGE) += xt_iprange.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_IPVS) += xt_ipvs.o
@@ -220,7 +218,6 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) += xt_physdev.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) += xt_pkttype.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) += xt_rateest.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_RECENT) += xt_recent.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
@@ -228,7 +225,6 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_SOCKET) += xt_socket.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
-obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) += xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
 
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
deleted file mode 100644
index 90f24a6a26c5..000000000000
--- a/net/netfilter/xt_DSCP.c
+++ /dev/null
@@ -1,161 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/* x_tables module for setting the IPv4/IPv6 DSCP field, Version 1.8
- *
- * (C) 2002 by Harald Welte <laforge@netfilter.org>
- * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
- *
- * See RFC2474 for a description of the DSCP field within the IP Header.
-*/
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <net/dsfield.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_dscp.h>
-
-MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: DSCP/TOS field modification");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("ipt_DSCP");
-MODULE_ALIAS("ip6t_DSCP");
-MODULE_ALIAS("ipt_TOS");
-MODULE_ALIAS("ip6t_TOS");
-
-#define XT_DSCP_ECN_MASK	3u
-
-static unsigned int
-dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_DSCP_info *dinfo = par->targinfo;
-	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
-
-	if (dscp != dinfo->dscp) {
-		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
-			return NF_DROP;
-
-		ipv4_change_dsfield(ip_hdr(skb), XT_DSCP_ECN_MASK,
-				    dinfo->dscp << XT_DSCP_SHIFT);
-
-	}
-	return XT_CONTINUE;
-}
-
-static unsigned int
-dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_DSCP_info *dinfo = par->targinfo;
-	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
-
-	if (dscp != dinfo->dscp) {
-		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
-			return NF_DROP;
-
-		ipv6_change_dsfield(ipv6_hdr(skb), XT_DSCP_ECN_MASK,
-				    dinfo->dscp << XT_DSCP_SHIFT);
-	}
-	return XT_CONTINUE;
-}
-
-static int dscp_tg_check(const struct xt_tgchk_param *par)
-{
-	const struct xt_DSCP_info *info = par->targinfo;
-
-	if (info->dscp > XT_DSCP_MAX)
-		return -EDOM;
-	return 0;
-}
-
-static unsigned int
-tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_tos_target_info *info = par->targinfo;
-	struct iphdr *iph = ip_hdr(skb);
-	u_int8_t orig, nv;
-
-	orig = ipv4_get_dsfield(iph);
-	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
-
-	if (orig != nv) {
-		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
-			return NF_DROP;
-		iph = ip_hdr(skb);
-		ipv4_change_dsfield(iph, 0, nv);
-	}
-
-	return XT_CONTINUE;
-}
-
-static unsigned int
-tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_tos_target_info *info = par->targinfo;
-	struct ipv6hdr *iph = ipv6_hdr(skb);
-	u_int8_t orig, nv;
-
-	orig = ipv6_get_dsfield(iph);
-	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
-
-	if (orig != nv) {
-		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
-			return NF_DROP;
-		iph = ipv6_hdr(skb);
-		ipv6_change_dsfield(iph, 0, nv);
-	}
-
-	return XT_CONTINUE;
-}
-
-static struct xt_target dscp_tg_reg[] __read_mostly = {
-	{
-		.name		= "DSCP",
-		.family		= NFPROTO_IPV4,
-		.checkentry	= dscp_tg_check,
-		.target		= dscp_tg,
-		.targetsize	= sizeof(struct xt_DSCP_info),
-		.table		= "mangle",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "DSCP",
-		.family		= NFPROTO_IPV6,
-		.checkentry	= dscp_tg_check,
-		.target		= dscp_tg6,
-		.targetsize	= sizeof(struct xt_DSCP_info),
-		.table		= "mangle",
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "TOS",
-		.revision	= 1,
-		.family		= NFPROTO_IPV4,
-		.table		= "mangle",
-		.target		= tos_tg,
-		.targetsize	= sizeof(struct xt_tos_target_info),
-		.me		= THIS_MODULE,
-	},
-	{
-		.name		= "TOS",
-		.revision	= 1,
-		.family		= NFPROTO_IPV6,
-		.table		= "mangle",
-		.target		= tos_tg6,
-		.targetsize	= sizeof(struct xt_tos_target_info),
-		.me		= THIS_MODULE,
-	},
-};
-
-static int __init dscp_tg_init(void)
-{
-	return xt_register_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
-}
-
-static void __exit dscp_tg_exit(void)
-{
-	xt_unregister_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
-}
-
-module_init(dscp_tg_init);
-module_exit(dscp_tg_exit);
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_HL.c
deleted file mode 100644
index a847d7a7eacd..000000000000
--- a/net/netfilter/xt_HL.c
+++ /dev/null
@@ -1,159 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * TTL modification target for IP tables
- * (C) 2000,2005 by Harald Welte <laforge@netfilter.org>
- *
- * Hop Limit modification target for ip6tables
- * Maciej Soltysiak <solt@dns.toxicfilms.tv>
- */
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <net/checksum.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_ttl.h>
-#include <linux/netfilter_ipv6/ip6t_hl.h>
-
-MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
-MODULE_DESCRIPTION("Xtables: Hoplimit/TTL Limit field modification target");
-MODULE_LICENSE("GPL");
-
-static unsigned int
-ttl_tg(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	struct iphdr *iph;
-	const struct ipt_TTL_info *info = par->targinfo;
-	int new_ttl;
-
-	if (skb_ensure_writable(skb, sizeof(*iph)))
-		return NF_DROP;
-
-	iph = ip_hdr(skb);
-
-	switch (info->mode) {
-	case IPT_TTL_SET:
-		new_ttl = info->ttl;
-		break;
-	case IPT_TTL_INC:
-		new_ttl = iph->ttl + info->ttl;
-		if (new_ttl > 255)
-			new_ttl = 255;
-		break;
-	case IPT_TTL_DEC:
-		new_ttl = iph->ttl - info->ttl;
-		if (new_ttl < 0)
-			new_ttl = 0;
-		break;
-	default:
-		new_ttl = iph->ttl;
-		break;
-	}
-
-	if (new_ttl != iph->ttl) {
-		csum_replace2(&iph->check, htons(iph->ttl << 8),
-					   htons(new_ttl << 8));
-		iph->ttl = new_ttl;
-	}
-
-	return XT_CONTINUE;
-}
-
-static unsigned int
-hl_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	struct ipv6hdr *ip6h;
-	const struct ip6t_HL_info *info = par->targinfo;
-	int new_hl;
-
-	if (skb_ensure_writable(skb, sizeof(*ip6h)))
-		return NF_DROP;
-
-	ip6h = ipv6_hdr(skb);
-
-	switch (info->mode) {
-	case IP6T_HL_SET:
-		new_hl = info->hop_limit;
-		break;
-	case IP6T_HL_INC:
-		new_hl = ip6h->hop_limit + info->hop_limit;
-		if (new_hl > 255)
-			new_hl = 255;
-		break;
-	case IP6T_HL_DEC:
-		new_hl = ip6h->hop_limit - info->hop_limit;
-		if (new_hl < 0)
-			new_hl = 0;
-		break;
-	default:
-		new_hl = ip6h->hop_limit;
-		break;
-	}
-
-	ip6h->hop_limit = new_hl;
-
-	return XT_CONTINUE;
-}
-
-static int ttl_tg_check(const struct xt_tgchk_param *par)
-{
-	const struct ipt_TTL_info *info = par->targinfo;
-
-	if (info->mode > IPT_TTL_MAXMODE)
-		return -EINVAL;
-	if (info->mode != IPT_TTL_SET && info->ttl == 0)
-		return -EINVAL;
-	return 0;
-}
-
-static int hl_tg6_check(const struct xt_tgchk_param *par)
-{
-	const struct ip6t_HL_info *info = par->targinfo;
-
-	if (info->mode > IP6T_HL_MAXMODE)
-		return -EINVAL;
-	if (info->mode != IP6T_HL_SET && info->hop_limit == 0)
-		return -EINVAL;
-	return 0;
-}
-
-static struct xt_target hl_tg_reg[] __read_mostly = {
-	{
-		.name       = "TTL",
-		.revision   = 0,
-		.family     = NFPROTO_IPV4,
-		.target     = ttl_tg,
-		.targetsize = sizeof(struct ipt_TTL_info),
-		.table      = "mangle",
-		.checkentry = ttl_tg_check,
-		.me         = THIS_MODULE,
-	},
-	{
-		.name       = "HL",
-		.revision   = 0,
-		.family     = NFPROTO_IPV6,
-		.target     = hl_tg6,
-		.targetsize = sizeof(struct ip6t_HL_info),
-		.table      = "mangle",
-		.checkentry = hl_tg6_check,
-		.me         = THIS_MODULE,
-	},
-};
-
-static int __init hl_tg_init(void)
-{
-	return xt_register_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
-}
-
-static void __exit hl_tg_exit(void)
-{
-	xt_unregister_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
-}
-
-module_init(hl_tg_init);
-module_exit(hl_tg_exit);
-MODULE_ALIAS("ipt_TTL");
-MODULE_ALIAS("ip6t_HL");
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
deleted file mode 100644
index a86bb0e4bb42..000000000000
--- a/net/netfilter/xt_RATEEST.c
+++ /dev/null
@@ -1,248 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * (C) 2007 Patrick McHardy <kaber@trash.net>
- */
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/gen_stats.h>
-#include <linux/jhash.h>
-#include <linux/rtnetlink.h>
-#include <linux/random.h>
-#include <linux/slab.h>
-#include <net/gen_stats.h>
-#include <net/netlink.h>
-#include <net/netns/generic.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_rateest.h>
-#include <net/netfilter/xt_rateest.h>
-
-#define RATEEST_HSIZE	16
-
-struct xt_rateest_net {
-	struct mutex hash_lock;
-	struct hlist_head hash[RATEEST_HSIZE];
-};
-
-static unsigned int xt_rateest_id;
-
-static unsigned int jhash_rnd __read_mostly;
-
-static unsigned int xt_rateest_hash(const char *name)
-{
-	return jhash(name, sizeof_field(struct xt_rateest, name), jhash_rnd) &
-	       (RATEEST_HSIZE - 1);
-}
-
-static void xt_rateest_hash_insert(struct xt_rateest_net *xn,
-				   struct xt_rateest *est)
-{
-	unsigned int h;
-
-	h = xt_rateest_hash(est->name);
-	hlist_add_head(&est->list, &xn->hash[h]);
-}
-
-static struct xt_rateest *__xt_rateest_lookup(struct xt_rateest_net *xn,
-					      const char *name)
-{
-	struct xt_rateest *est;
-	unsigned int h;
-
-	h = xt_rateest_hash(name);
-	hlist_for_each_entry(est, &xn->hash[h], list) {
-		if (strcmp(est->name, name) == 0) {
-			est->refcnt++;
-			return est;
-		}
-	}
-
-	return NULL;
-}
-
-struct xt_rateest *xt_rateest_lookup(struct net *net, const char *name)
-{
-	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
-	struct xt_rateest *est;
-
-	mutex_lock(&xn->hash_lock);
-	est = __xt_rateest_lookup(xn, name);
-	mutex_unlock(&xn->hash_lock);
-	return est;
-}
-EXPORT_SYMBOL_GPL(xt_rateest_lookup);
-
-void xt_rateest_put(struct net *net, struct xt_rateest *est)
-{
-	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
-
-	mutex_lock(&xn->hash_lock);
-	if (--est->refcnt == 0) {
-		hlist_del(&est->list);
-		gen_kill_estimator(&est->rate_est);
-		/*
-		 * gen_estimator est_timer() might access est->lock or bstats,
-		 * wait a RCU grace period before freeing 'est'
-		 */
-		kfree_rcu(est, rcu);
-	}
-	mutex_unlock(&xn->hash_lock);
-}
-EXPORT_SYMBOL_GPL(xt_rateest_put);
-
-static unsigned int
-xt_rateest_tg(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	const struct xt_rateest_target_info *info = par->targinfo;
-	struct gnet_stats_basic_sync *stats = &info->est->bstats;
-
-	spin_lock_bh(&info->est->lock);
-	u64_stats_add(&stats->bytes, skb->len);
-	u64_stats_inc(&stats->packets);
-	spin_unlock_bh(&info->est->lock);
-
-	return XT_CONTINUE;
-}
-
-static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
-{
-	struct xt_rateest_net *xn = net_generic(par->net, xt_rateest_id);
-	struct xt_rateest_target_info *info = par->targinfo;
-	struct xt_rateest *est;
-	struct {
-		struct nlattr		opt;
-		struct gnet_estimator	est;
-	} cfg;
-	int ret;
-
-	if (strnlen(info->name, sizeof(est->name)) >= sizeof(est->name))
-		return -ENAMETOOLONG;
-
-	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
-
-	mutex_lock(&xn->hash_lock);
-	est = __xt_rateest_lookup(xn, info->name);
-	if (est) {
-		mutex_unlock(&xn->hash_lock);
-		/*
-		 * If estimator parameters are specified, they must match the
-		 * existing estimator.
-		 */
-		if ((!info->interval && !info->ewma_log) ||
-		    (info->interval != est->params.interval ||
-		     info->ewma_log != est->params.ewma_log)) {
-			xt_rateest_put(par->net, est);
-			return -EINVAL;
-		}
-		info->est = est;
-		return 0;
-	}
-
-	ret = -ENOMEM;
-	est = kzalloc(sizeof(*est), GFP_KERNEL);
-	if (!est)
-		goto err1;
-
-	gnet_stats_basic_sync_init(&est->bstats);
-	strscpy(est->name, info->name, sizeof(est->name));
-	spin_lock_init(&est->lock);
-	est->refcnt		= 1;
-	est->params.interval	= info->interval;
-	est->params.ewma_log	= info->ewma_log;
-
-	cfg.opt.nla_len		= nla_attr_size(sizeof(cfg.est));
-	cfg.opt.nla_type	= TCA_STATS_RATE_EST;
-	cfg.est.interval	= info->interval;
-	cfg.est.ewma_log	= info->ewma_log;
-
-	ret = gen_new_estimator(&est->bstats, NULL, &est->rate_est,
-				&est->lock, NULL, &cfg.opt);
-	if (ret < 0)
-		goto err2;
-
-	info->est = est;
-	xt_rateest_hash_insert(xn, est);
-	mutex_unlock(&xn->hash_lock);
-	return 0;
-
-err2:
-	kfree(est);
-err1:
-	mutex_unlock(&xn->hash_lock);
-	return ret;
-}
-
-static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
-{
-	struct xt_rateest_target_info *info = par->targinfo;
-
-	xt_rateest_put(par->net, info->est);
-}
-
-static struct xt_target xt_rateest_tg_reg[] __read_mostly = {
-	{
-		.name       = "RATEEST",
-		.revision   = 0,
-		.family     = NFPROTO_IPV4,
-		.target     = xt_rateest_tg,
-		.checkentry = xt_rateest_tg_checkentry,
-		.destroy    = xt_rateest_tg_destroy,
-		.targetsize = sizeof(struct xt_rateest_target_info),
-		.usersize   = offsetof(struct xt_rateest_target_info, est),
-		.me         = THIS_MODULE,
-	},
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-	{
-		.name       = "RATEEST",
-		.revision   = 0,
-		.family     = NFPROTO_IPV6,
-		.target     = xt_rateest_tg,
-		.checkentry = xt_rateest_tg_checkentry,
-		.destroy    = xt_rateest_tg_destroy,
-		.targetsize = sizeof(struct xt_rateest_target_info),
-		.usersize   = offsetof(struct xt_rateest_target_info, est),
-		.me         = THIS_MODULE,
-	},
-#endif
-};
-
-static __net_init int xt_rateest_net_init(struct net *net)
-{
-	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
-	int i;
-
-	mutex_init(&xn->hash_lock);
-	for (i = 0; i < ARRAY_SIZE(xn->hash); i++)
-		INIT_HLIST_HEAD(&xn->hash[i]);
-	return 0;
-}
-
-static struct pernet_operations xt_rateest_net_ops = {
-	.init = xt_rateest_net_init,
-	.id   = &xt_rateest_id,
-	.size = sizeof(struct xt_rateest_net),
-};
-
-static int __init xt_rateest_tg_init(void)
-{
-	int err = register_pernet_subsys(&xt_rateest_net_ops);
-
-	if (err)
-		return err;
-	return xt_register_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
-}
-
-static void __exit xt_rateest_tg_fini(void)
-{
-	xt_unregister_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
-	unregister_pernet_subsys(&xt_rateest_net_ops);
-}
-
-
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Xtables: packet rate estimator");
-MODULE_ALIAS("ipt_RATEEST");
-MODULE_ALIAS("ip6t_RATEEST");
-module_init(xt_rateest_tg_init);
-module_exit(xt_rateest_tg_fini);
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
deleted file mode 100644
index 3dc1320237c2..000000000000
--- a/net/netfilter/xt_TCPMSS.c
+++ /dev/null
@@ -1,345 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * This is a module which is used for setting the MSS option in TCP packets.
- *
- * Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
- * Copyright (C) 2007 Patrick McHardy <kaber@trash.net>
- */
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/gfp.h>
-#include <linux/ipv6.h>
-#include <linux/tcp.h>
-#include <net/dst.h>
-#include <net/flow.h>
-#include <net/ipv6.h>
-#include <net/route.h>
-#include <net/tcp.h>
-
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter/xt_tcpudp.h>
-#include <linux/netfilter/xt_tcpmss.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("Xtables: TCP Maximum Segment Size (MSS) adjustment");
-MODULE_ALIAS("ipt_TCPMSS");
-MODULE_ALIAS("ip6t_TCPMSS");
-
-static inline unsigned int
-optlen(const u_int8_t *opt, unsigned int offset)
-{
-	/* Beware zero-length options: make finite progress */
-	if (opt[offset] <= TCPOPT_NOP || opt[offset+1] == 0)
-		return 1;
-	else
-		return opt[offset+1];
-}
-
-static u_int32_t tcpmss_reverse_mtu(struct net *net,
-				    const struct sk_buff *skb,
-				    unsigned int family)
-{
-	struct flowi fl;
-	struct rtable *rt = NULL;
-	u_int32_t mtu     = ~0U;
-
-	if (family == PF_INET) {
-		struct flowi4 *fl4 = &fl.u.ip4;
-		memset(fl4, 0, sizeof(*fl4));
-		fl4->daddr = ip_hdr(skb)->saddr;
-	} else {
-		struct flowi6 *fl6 = &fl.u.ip6;
-
-		memset(fl6, 0, sizeof(*fl6));
-		fl6->daddr = ipv6_hdr(skb)->saddr;
-	}
-
-	nf_route(net, (struct dst_entry **)&rt, &fl, false, family);
-	if (rt != NULL) {
-		mtu = dst_mtu(&rt->dst);
-		dst_release(&rt->dst);
-	}
-	return mtu;
-}
-
-static int
-tcpmss_mangle_packet(struct sk_buff *skb,
-		     const struct xt_action_param *par,
-		     unsigned int family,
-		     unsigned int tcphoff,
-		     unsigned int minlen)
-{
-	const struct xt_tcpmss_info *info = par->targinfo;
-	struct tcphdr *tcph;
-	int len, tcp_hdrlen;
-	unsigned int i;
-	__be16 oldval;
-	u16 newmss;
-	u8 *opt;
-
-	/* This is a fragment, no TCP header is available */
-	if (par->fragoff != 0)
-		return 0;
-
-	if (skb_ensure_writable(skb, skb->len))
-		return -1;
-
-	len = skb->len - tcphoff;
-	if (len < (int)sizeof(struct tcphdr))
-		return -1;
-
-	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
-	tcp_hdrlen = tcph->doff * 4;
-
-	if (len < tcp_hdrlen || tcp_hdrlen < sizeof(struct tcphdr))
-		return -1;
-
-	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
-		struct net *net = xt_net(par);
-		unsigned int in_mtu = tcpmss_reverse_mtu(net, skb, family);
-		unsigned int min_mtu = min(dst_mtu(skb_dst(skb)), in_mtu);
-
-		if (min_mtu <= minlen) {
-			net_err_ratelimited("unknown or invalid path-MTU (%u)\n",
-					    min_mtu);
-			return -1;
-		}
-		newmss = min_mtu - minlen;
-	} else
-		newmss = info->mss;
-
-	opt = (u_int8_t *)tcph;
-	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
-		if (opt[i] == TCPOPT_MSS && opt[i+1] == TCPOLEN_MSS) {
-			u_int16_t oldmss;
-
-			oldmss = (opt[i+2] << 8) | opt[i+3];
-
-			/* Never increase MSS, even when setting it, as
-			 * doing so results in problems for hosts that rely
-			 * on MSS being set correctly.
-			 */
-			if (oldmss <= newmss)
-				return 0;
-
-			opt[i+2] = (newmss & 0xff00) >> 8;
-			opt[i+3] = newmss & 0x00ff;
-
-			inet_proto_csum_replace2(&tcph->check, skb,
-						 htons(oldmss), htons(newmss),
-						 false);
-			return 0;
-		}
-	}
-
-	/* There is data after the header so the option can't be added
-	 * without moving it, and doing so may make the SYN packet
-	 * itself too large. Accept the packet unmodified instead.
-	 */
-	if (len > tcp_hdrlen)
-		return 0;
-
-	/* tcph->doff has 4 bits, do not wrap it to 0 */
-	if (tcp_hdrlen >= 15 * 4)
-		return 0;
-
-	/*
-	 * MSS Option not found ?! add it..
-	 */
-	if (skb_tailroom(skb) < TCPOLEN_MSS) {
-		if (pskb_expand_head(skb, 0,
-				     TCPOLEN_MSS - skb_tailroom(skb),
-				     GFP_ATOMIC))
-			return -1;
-		tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
-	}
-
-	skb_put(skb, TCPOLEN_MSS);
-
-	/*
-	 * IPv4: RFC 1122 states "If an MSS option is not received at
-	 * connection setup, TCP MUST assume a default send MSS of 536".
-	 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a minimum
-	 * length IPv6 header of 60, ergo the default MSS value is 1220
-	 * Since no MSS was provided, we must use the default values
-	 */
-	if (xt_family(par) == NFPROTO_IPV4)
-		newmss = min(newmss, (u16)536);
-	else
-		newmss = min(newmss, (u16)1220);
-
-	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
-	memmove(opt + TCPOLEN_MSS, opt, len - sizeof(struct tcphdr));
-
-	inet_proto_csum_replace2(&tcph->check, skb,
-				 htons(len), htons(len + TCPOLEN_MSS), true);
-	opt[0] = TCPOPT_MSS;
-	opt[1] = TCPOLEN_MSS;
-	opt[2] = (newmss & 0xff00) >> 8;
-	opt[3] = newmss & 0x00ff;
-
-	inet_proto_csum_replace4(&tcph->check, skb, 0, *((__be32 *)opt), false);
-
-	oldval = ((__be16 *)tcph)[6];
-	tcph->doff += TCPOLEN_MSS/4;
-	inet_proto_csum_replace2(&tcph->check, skb,
-				 oldval, ((__be16 *)tcph)[6], false);
-	return TCPOLEN_MSS;
-}
-
-static unsigned int
-tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	struct iphdr *iph = ip_hdr(skb);
-	__be16 newlen;
-	int ret;
-
-	ret = tcpmss_mangle_packet(skb, par,
-				   PF_INET,
-				   iph->ihl * 4,
-				   sizeof(*iph) + sizeof(struct tcphdr));
-	if (ret < 0)
-		return NF_DROP;
-	if (ret > 0) {
-		iph = ip_hdr(skb);
-		newlen = htons(ntohs(iph->tot_len) + ret);
-		csum_replace2(&iph->check, iph->tot_len, newlen);
-		iph->tot_len = newlen;
-	}
-	return XT_CONTINUE;
-}
-
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-static unsigned int
-tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
-{
-	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-	u8 nexthdr;
-	__be16 frag_off, oldlen, newlen;
-	int tcphoff;
-	int ret;
-
-	nexthdr = ipv6h->nexthdr;
-	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr, &frag_off);
-	if (tcphoff < 0)
-		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, par,
-				   PF_INET6,
-				   tcphoff,
-				   sizeof(*ipv6h) + sizeof(struct tcphdr));
-	if (ret < 0)
-		return NF_DROP;
-	if (ret > 0) {
-		ipv6h = ipv6_hdr(skb);
-		oldlen = ipv6h->payload_len;
-		newlen = htons(ntohs(oldlen) + ret);
-		if (skb->ip_summed == CHECKSUM_COMPLETE)
-			skb->csum = csum_add(csum_sub(skb->csum, (__force __wsum)oldlen),
-					     (__force __wsum)newlen);
-		ipv6h->payload_len = newlen;
-	}
-	return XT_CONTINUE;
-}
-#endif
-
-/* Must specify -p tcp --syn */
-static inline bool find_syn_match(const struct xt_entry_match *m)
-{
-	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)m->data;
-
-	if (strcmp(m->u.kernel.match->name, "tcp") == 0 &&
-	    tcpinfo->flg_cmp & TCPHDR_SYN &&
-	    !(tcpinfo->invflags & XT_TCP_INV_FLAGS))
-		return true;
-
-	return false;
-}
-
-static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
-{
-	const struct xt_tcpmss_info *info = par->targinfo;
-	const struct ipt_entry *e = par->entryinfo;
-	const struct xt_entry_match *ematch;
-
-	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
-			   (1 << NF_INET_LOCAL_OUT) |
-			   (1 << NF_INET_POST_ROUTING))) != 0) {
-		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return -EINVAL;
-	}
-	if (par->nft_compat)
-		return 0;
-
-	xt_ematch_foreach(ematch, e)
-		if (find_syn_match(ematch))
-			return 0;
-	pr_info_ratelimited("Only works on TCP SYN packets\n");
-	return -EINVAL;
-}
-
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
-{
-	const struct xt_tcpmss_info *info = par->targinfo;
-	const struct ip6t_entry *e = par->entryinfo;
-	const struct xt_entry_match *ematch;
-
-	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
-			   (1 << NF_INET_LOCAL_OUT) |
-			   (1 << NF_INET_POST_ROUTING))) != 0) {
-		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
-		return -EINVAL;
-	}
-	if (par->nft_compat)
-		return 0;
-
-	xt_ematch_foreach(ematch, e)
-		if (find_syn_match(ematch))
-			return 0;
-	pr_info_ratelimited("Only works on TCP SYN packets\n");
-	return -EINVAL;
-}
-#endif
-
-static struct xt_target tcpmss_tg_reg[] __read_mostly = {
-	{
-		.family		= NFPROTO_IPV4,
-		.name		= "TCPMSS",
-		.checkentry	= tcpmss_tg4_check,
-		.target		= tcpmss_tg4,
-		.targetsize	= sizeof(struct xt_tcpmss_info),
-		.proto		= IPPROTO_TCP,
-		.me		= THIS_MODULE,
-	},
-#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
-	{
-		.family		= NFPROTO_IPV6,
-		.name		= "TCPMSS",
-		.checkentry	= tcpmss_tg6_check,
-		.target		= tcpmss_tg6,
-		.targetsize	= sizeof(struct xt_tcpmss_info),
-		.proto		= IPPROTO_TCP,
-		.me		= THIS_MODULE,
-	},
-#endif
-};
-
-static int __init tcpmss_tg_init(void)
-{
-	return xt_register_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
-}
-
-static void __exit tcpmss_tg_exit(void)
-{
-	xt_unregister_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
-}
-
-module_init(tcpmss_tg_init);
-module_exit(tcpmss_tg_exit);
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index fb0169a8f9bb..232ecc82ec28 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -1,7 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* IP tables module for matching the value of the IPv4/IPv6 DSCP field
+/* x_tables module for setting the IPv4/IPv6 DSCP field, Version 1.8
+ * IP tables module for matching and setting the value of the IPv4/IPv6 DSCP field
  *
  * (C) 2002 by Harald Welte <laforge@netfilter.org>
+ * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
+ *
+ * See RFC2474 for a description of the DSCP field within the IP Header.
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
@@ -14,12 +18,19 @@
 #include <linux/netfilter/xt_dscp.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("Xtables: DSCP/TOS field match");
+MODULE_DESCRIPTION("Xtables: DSCP/TOS field match and target modification");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_dscp");
 MODULE_ALIAS("ip6t_dscp");
 MODULE_ALIAS("ipt_tos");
 MODULE_ALIAS("ip6t_tos");
+MODULE_ALIAS("ipt_DSCP");
+MODULE_ALIAS("ip6t_DSCP");
+MODULE_ALIAS("ipt_TOS");
+MODULE_ALIAS("ip6t_TOS");
+MODULE_ALIAS("xt_DSCP");
+
+#define XT_DSCP_ECN_MASK	3u
 
 static bool
 dscp_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -96,15 +107,146 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 	},
 };
 
-static int __init dscp_mt_init(void)
+static unsigned int
+dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_DSCP_info *dinfo = par->targinfo;
+	u8 dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
+
+	if (dscp != dinfo->dscp) {
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+
+		ipv4_change_dsfield(ip_hdr(skb), XT_DSCP_ECN_MASK,
+				    dinfo->dscp << XT_DSCP_SHIFT);
+	}
+	return XT_CONTINUE;
+}
+
+static unsigned int
+dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	return xt_register_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
+	const struct xt_DSCP_info *dinfo = par->targinfo;
+	u8 dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
+
+	if (dscp != dinfo->dscp) {
+		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
+			return NF_DROP;
+
+		ipv6_change_dsfield(ipv6_hdr(skb), XT_DSCP_ECN_MASK,
+				    dinfo->dscp << XT_DSCP_SHIFT);
+	}
+	return XT_CONTINUE;
+}
+
+static int dscp_tg_check(const struct xt_tgchk_param *par)
+{
+	const struct xt_DSCP_info *info = par->targinfo;
+
+	if (info->dscp > XT_DSCP_MAX)
+		return -EDOM;
+	return 0;
+}
+
+static unsigned int
+tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_tos_target_info *info = par->targinfo;
+	struct iphdr *iph = ip_hdr(skb);
+	u8 orig, nv;
+
+	orig = ipv4_get_dsfield(iph);
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
+
+	if (orig != nv) {
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+		iph = ip_hdr(skb);
+		ipv4_change_dsfield(iph, 0, nv);
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_tos_target_info *info = par->targinfo;
+	struct ipv6hdr *iph = ipv6_hdr(skb);
+	u8 orig, nv;
+
+	orig = ipv6_get_dsfield(iph);
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
+
+	if (orig != nv) {
+		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
+			return NF_DROP;
+		iph = ipv6_hdr(skb);
+		ipv6_change_dsfield(iph, 0, nv);
+	}
+
+	return XT_CONTINUE;
+}
+
+static struct xt_target dscp_tg_reg[] __read_mostly = {
+	{
+		.name		= "DSCP",
+		.family		= NFPROTO_IPV4,
+		.checkentry	= dscp_tg_check,
+		.target		= dscp_tg,
+		.targetsize	= sizeof(struct xt_DSCP_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "DSCP",
+		.family		= NFPROTO_IPV6,
+		.checkentry	= dscp_tg_check,
+		.target		= dscp_tg6,
+		.targetsize	= sizeof(struct xt_DSCP_info),
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "TOS",
+		.revision	= 1,
+		.family		= NFPROTO_IPV4,
+		.table		= "mangle",
+		.target		= tos_tg,
+		.targetsize	= sizeof(struct xt_tos_target_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "TOS",
+		.revision	= 1,
+		.family		= NFPROTO_IPV6,
+		.table		= "mangle",
+		.target		= tos_tg6,
+		.targetsize	= sizeof(struct xt_tos_target_info),
+		.me		= THIS_MODULE,
+	},
+};
+
+static int __init dscp_init(void)
+{
+	int ret;
+
+	ret = xt_register_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
+	if (ret < 0)
+		return ret;
+	ret = xt_register_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
+	if (ret < 0) {
+		xt_unregister_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
+		return ret;
+	}
+	return 0;
 }
 
-static void __exit dscp_mt_exit(void)
+static void __exit dscp_exit(void)
 {
 	xt_unregister_matches(dscp_mt_reg, ARRAY_SIZE(dscp_mt_reg));
+	xt_unregister_targets(dscp_tg_reg, ARRAY_SIZE(dscp_tg_reg));
 }
 
-module_init(dscp_mt_init);
-module_exit(dscp_mt_exit);
+module_init(dscp_init);
+module_exit(dscp_exit);
diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
index c1a70f8f0441..5b7aabab3031 100644
--- a/net/netfilter/xt_hl.c
+++ b/net/netfilter/xt_hl.c
@@ -5,22 +5,33 @@
  *
  * Hop Limit matching module
  * (C) 2001-2002 Maciej Soltysiak <solt@dns.toxicfilms.tv>
+ *
+ * TTL modification target for IP tables
+ * (C) 2000,2005 by Harald Welte <laforge@netfilter.org>
+ *
+ * Hop Limit modification target for ip6tables
+ * Maciej Soltysiak <solt@dns.toxicfilms.tv>
  */
-
-#include <linux/ip.h>
-#include <linux/ipv6.h>
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <net/checksum.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ipt_ttl.h>
 #include <linux/netfilter_ipv6/ip6t_hl.h>
 
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
-MODULE_DESCRIPTION("Xtables: Hoplimit/TTL field match");
+MODULE_DESCRIPTION("Xtables: Hoplimit/TTL field match and target modification");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_ttl");
 MODULE_ALIAS("ip6t_hl");
+MODULE_ALIAS("ipt_TTL");
+MODULE_ALIAS("ip6t_HL");
+MODULE_ALIAS("xt_HL");
 
 static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
@@ -79,15 +90,146 @@ static struct xt_match hl_mt_reg[] __read_mostly = {
 	},
 };
 
-static int __init hl_mt_init(void)
+static unsigned int
+ttl_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct iphdr *iph;
+	const struct ipt_TTL_info *info = par->targinfo;
+	int new_ttl;
+
+	if (skb_ensure_writable(skb, sizeof(*iph)))
+		return NF_DROP;
+
+	iph = ip_hdr(skb);
+
+	switch (info->mode) {
+	case IPT_TTL_SET:
+		new_ttl = info->ttl;
+		break;
+	case IPT_TTL_INC:
+		new_ttl = iph->ttl + info->ttl;
+		if (new_ttl > 255)
+			new_ttl = 255;
+		break;
+	case IPT_TTL_DEC:
+		new_ttl = iph->ttl - info->ttl;
+		if (new_ttl < 0)
+			new_ttl = 0;
+		break;
+	default:
+		new_ttl = iph->ttl;
+		break;
+	}
+
+	if (new_ttl != iph->ttl) {
+		csum_replace2(&iph->check, htons(iph->ttl << 8), htons(new_ttl << 8));
+		iph->ttl = new_ttl;
+	}
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+hl_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct ipv6hdr *ip6h;
+	const struct ip6t_HL_info *info = par->targinfo;
+	int new_hl;
+
+	if (skb_ensure_writable(skb, sizeof(*ip6h)))
+		return NF_DROP;
+
+	ip6h = ipv6_hdr(skb);
+
+	switch (info->mode) {
+	case IP6T_HL_SET:
+		new_hl = info->hop_limit;
+		break;
+	case IP6T_HL_INC:
+		new_hl = ip6h->hop_limit + info->hop_limit;
+		if (new_hl > 255)
+			new_hl = 255;
+		break;
+	case IP6T_HL_DEC:
+		new_hl = ip6h->hop_limit - info->hop_limit;
+		if (new_hl < 0)
+			new_hl = 0;
+		break;
+	default:
+		new_hl = ip6h->hop_limit;
+		break;
+	}
+
+	ip6h->hop_limit = new_hl;
+
+	return XT_CONTINUE;
+}
+
+static int ttl_tg_check(const struct xt_tgchk_param *par)
+{
+	const struct ipt_TTL_info *info = par->targinfo;
+
+	if (info->mode > IPT_TTL_MAXMODE)
+		return -EINVAL;
+	if (info->mode != IPT_TTL_SET && info->ttl == 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int hl_tg6_check(const struct xt_tgchk_param *par)
+{
+	const struct ip6t_HL_info *info = par->targinfo;
+
+	if (info->mode > IP6T_HL_MAXMODE)
+		return -EINVAL;
+	if (info->mode != IP6T_HL_SET && info->hop_limit == 0)
+		return -EINVAL;
+	return 0;
+}
+
+static struct xt_target hl_tg_reg[] __read_mostly = {
+	{
+		.name       = "TTL",
+		.revision   = 0,
+		.family     = NFPROTO_IPV4,
+		.target     = ttl_tg,
+		.targetsize = sizeof(struct ipt_TTL_info),
+		.table      = "mangle",
+		.checkentry = ttl_tg_check,
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "HL",
+		.revision   = 0,
+		.family     = NFPROTO_IPV6,
+		.target     = hl_tg6,
+		.targetsize = sizeof(struct ip6t_HL_info),
+		.table      = "mangle",
+		.checkentry = hl_tg6_check,
+		.me         = THIS_MODULE,
+	},
+};
+
+static int __init hl_init(void)
 {
-	return xt_register_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
+	int ret;
+
+	ret = xt_register_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
+	if (ret < 0)
+		return ret;
+	ret = xt_register_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
+	if (ret < 0) {
+		xt_unregister_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
+		return ret;
+	}
+	return 0;
 }
 
-static void __exit hl_mt_exit(void)
+static void __exit hl_exit(void)
 {
 	xt_unregister_matches(hl_mt_reg, ARRAY_SIZE(hl_mt_reg));
+	xt_unregister_targets(hl_tg_reg, ARRAY_SIZE(hl_tg_reg));
 }
 
-module_init(hl_mt_init);
-module_exit(hl_mt_exit);
+module_init(hl_init);
+module_exit(hl_exit);
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 72324bd976af..c0153b5b47a0 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -5,11 +5,28 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/gen_stats.h>
+#include <linux/jhash.h>
+#include <linux/rtnetlink.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <net/gen_stats.h>
+#include <net/netlink.h>
+#include <net/netns/generic.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_rateest.h>
 #include <net/netfilter/xt_rateest.h>
 
+#define RATEEST_HSIZE	16
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("xtables packet rate estimator");
+MODULE_ALIAS("ipt_rateest");
+MODULE_ALIAS("ip6t_rateest");
+MODULE_ALIAS("ipt_RATEEST");
+MODULE_ALIAS("ip6t_RATEEST");
+MODULE_ALIAS("xt_RATEEST");
 
 static bool
 xt_rateest_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -134,20 +151,236 @@ static struct xt_match xt_rateest_mt_reg __read_mostly = {
 	.me         = THIS_MODULE,
 };
 
-static int __init xt_rateest_mt_init(void)
+struct xt_rateest_net {
+	/* To synchronize concurrent synchronous rate estimator operations. */
+	struct mutex hash_lock;
+	struct hlist_head hash[RATEEST_HSIZE];
+};
+
+static unsigned int xt_rateest_id;
+
+static unsigned int jhash_rnd __read_mostly;
+
+static unsigned int xt_rateest_hash(const char *name)
+{
+	return jhash(name, sizeof_field(struct xt_rateest, name), jhash_rnd) &
+	       (RATEEST_HSIZE - 1);
+}
+
+static void xt_rateest_hash_insert(struct xt_rateest_net *xn,
+				   struct xt_rateest *est)
+{
+	unsigned int h;
+
+	h = xt_rateest_hash(est->name);
+	hlist_add_head(&est->list, &xn->hash[h]);
+}
+
+static struct xt_rateest *__xt_rateest_lookup(struct xt_rateest_net *xn,
+					      const char *name)
 {
-	return xt_register_match(&xt_rateest_mt_reg);
+	struct xt_rateest *est;
+	unsigned int h;
+
+	h = xt_rateest_hash(name);
+	hlist_for_each_entry(est, &xn->hash[h], list) {
+		if (strcmp(est->name, name) == 0) {
+			est->refcnt++;
+			return est;
+		}
+	}
+
+	return NULL;
 }
 
-static void __exit xt_rateest_mt_fini(void)
+struct xt_rateest *xt_rateest_lookup(struct net *net, const char *name)
+{
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+	struct xt_rateest *est;
+
+	mutex_lock(&xn->hash_lock);
+	est = __xt_rateest_lookup(xn, name);
+	mutex_unlock(&xn->hash_lock);
+	return est;
+}
+EXPORT_SYMBOL_GPL(xt_rateest_lookup);
+
+void xt_rateest_put(struct net *net, struct xt_rateest *est)
+{
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+
+	mutex_lock(&xn->hash_lock);
+	if (--est->refcnt == 0) {
+		hlist_del(&est->list);
+		gen_kill_estimator(&est->rate_est);
+		/*
+		 * gen_estimator est_timer() might access est->lock or bstats,
+		 * wait a RCU grace period before freeing 'est'
+		 */
+		kfree_rcu(est, rcu);
+	}
+	mutex_unlock(&xn->hash_lock);
+}
+EXPORT_SYMBOL_GPL(xt_rateest_put);
+
+static unsigned int
+xt_rateest_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_rateest_target_info *info = par->targinfo;
+	struct gnet_stats_basic_sync *stats = &info->est->bstats;
+
+	spin_lock_bh(&info->est->lock);
+	u64_stats_add(&stats->bytes, skb->len);
+	u64_stats_inc(&stats->packets);
+	spin_unlock_bh(&info->est->lock);
+
+	return XT_CONTINUE;
+}
+
+static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
+{
+	struct xt_rateest_net *xn = net_generic(par->net, xt_rateest_id);
+	struct xt_rateest_target_info *info = par->targinfo;
+	struct xt_rateest *est;
+	struct {
+		struct nlattr		opt;
+		struct gnet_estimator	est;
+	} cfg;
+	int ret;
+
+	if (strnlen(info->name, sizeof(est->name)) >= sizeof(est->name))
+		return -ENAMETOOLONG;
+
+	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
+
+	mutex_lock(&xn->hash_lock);
+	est = __xt_rateest_lookup(xn, info->name);
+	if (est) {
+		mutex_unlock(&xn->hash_lock);
+		/*
+		 * If estimator parameters are specified, they must match the
+		 * existing estimator.
+		 */
+		if ((!info->interval && !info->ewma_log) ||
+		    (info->interval != est->params.interval ||
+		     info->ewma_log != est->params.ewma_log)) {
+			xt_rateest_put(par->net, est);
+			return -EINVAL;
+		}
+		info->est = est;
+		return 0;
+	}
+
+	ret = -ENOMEM;
+	est = kzalloc(sizeof(*est), GFP_KERNEL);
+	if (!est)
+		goto err1;
+
+	gnet_stats_basic_sync_init(&est->bstats);
+	strscpy(est->name, info->name, sizeof(est->name));
+	spin_lock_init(&est->lock);
+	est->refcnt		= 1;
+	est->params.interval	= info->interval;
+	est->params.ewma_log	= info->ewma_log;
+
+	cfg.opt.nla_len		= nla_attr_size(sizeof(cfg.est));
+	cfg.opt.nla_type	= TCA_STATS_RATE_EST;
+	cfg.est.interval	= info->interval;
+	cfg.est.ewma_log	= info->ewma_log;
+
+	ret = gen_new_estimator(&est->bstats, NULL, &est->rate_est,
+				&est->lock, NULL, &cfg.opt);
+	if (ret < 0)
+		goto err2;
+
+	info->est = est;
+	xt_rateest_hash_insert(xn, est);
+	mutex_unlock(&xn->hash_lock);
+	return 0;
+
+err2:
+	kfree(est);
+err1:
+	mutex_unlock(&xn->hash_lock);
+	return ret;
+}
+
+static void xt_rateest_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	struct xt_rateest_target_info *info = par->targinfo;
+
+	xt_rateest_put(par->net, info->est);
+}
+
+static struct xt_target xt_rateest_tg_reg[] __read_mostly = {
+	{
+		.name       = "RATEEST",
+		.revision   = 0,
+		.family     = NFPROTO_IPV4,
+		.target     = xt_rateest_tg,
+		.checkentry = xt_rateest_tg_checkentry,
+		.destroy    = xt_rateest_tg_destroy,
+		.targetsize = sizeof(struct xt_rateest_target_info),
+		.usersize   = offsetof(struct xt_rateest_target_info, est),
+		.me         = THIS_MODULE,
+	},
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+	{
+		.name       = "RATEEST",
+		.revision   = 0,
+		.family     = NFPROTO_IPV6,
+		.target     = xt_rateest_tg,
+		.checkentry = xt_rateest_tg_checkentry,
+		.destroy    = xt_rateest_tg_destroy,
+		.targetsize = sizeof(struct xt_rateest_target_info),
+		.usersize   = offsetof(struct xt_rateest_target_info, est),
+		.me         = THIS_MODULE,
+	},
+#endif
+};
+
+static __net_init int xt_rateest_net_init(struct net *net)
+{
+	struct xt_rateest_net *xn = net_generic(net, xt_rateest_id);
+	int i;
+
+	mutex_init(&xn->hash_lock);
+	for (i = 0; i < ARRAY_SIZE(xn->hash); i++)
+		INIT_HLIST_HEAD(&xn->hash[i]);
+	return 0;
+}
+
+static struct pernet_operations xt_rateest_net_ops = {
+	.init = xt_rateest_net_init,
+	.id   = &xt_rateest_id,
+	.size = sizeof(struct xt_rateest_net),
+};
+
+static int __init xt_rateest_init(void)
+{
+	int ret = register_pernet_subsys(&xt_rateest_net_ops);
+
+	if (ret)
+		return ret;
+
+	ret = xt_register_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
+	if (ret < 0)
+		return ret;
+	ret = xt_register_match(&xt_rateest_mt_reg);
+	if (ret < 0) {
+		xt_unregister_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
+		unregister_pernet_subsys(&xt_rateest_net_ops);
+		return ret;
+	}
+	return 0;
+}
+
+static void __exit xt_rateest_exit(void)
 {
 	xt_unregister_match(&xt_rateest_mt_reg);
+	xt_unregister_targets(xt_rateest_tg_reg, ARRAY_SIZE(xt_rateest_tg_reg));
+	unregister_pernet_subsys(&xt_rateest_net_ops);
 }
 
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("xtables rate estimator match");
-MODULE_ALIAS("ipt_rateest");
-MODULE_ALIAS("ip6t_rateest");
-module_init(xt_rateest_mt_init);
-module_exit(xt_rateest_mt_fini);
+module_init(xt_rateest_init);
+module_exit(xt_rateest_exit);
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 37704ab01799..b33c13b7bc01 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -1,25 +1,38 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Kernel module to match TCP MSS values. */
-
-/* Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
+/* Kernel module to match TCP MSS values.
+ * This is a module which is used for setting the MSS option in TCP packets.
+ *
+ * Copyright (C) 2000 Marc Boucher <marc@mbsi.ca>
  * Portions (C) 2005 by Harald Welte <laforge@netfilter.org>
+ * Copyright (C) 2007 Patrick McHardy <kaber@trash.net>
  */
-
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/gfp.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <net/dst.h>
+#include <net/flow.h>
+#include <net/ipv6.h>
+#include <net/route.h>
 #include <net/tcp.h>
 
-#include <linux/netfilter/xt_tcpmss.h>
-#include <linux/netfilter/x_tables.h>
-
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tcpudp.h>
+#include <linux/netfilter/xt_tcpmss.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("Xtables: TCP MSS match");
+MODULE_DESCRIPTION("Xtables: TCP Maximum Segment Size (MSS) adjustment and match");
 MODULE_ALIAS("ipt_tcpmss");
 MODULE_ALIAS("ip6t_tcpmss");
+MODULE_ALIAS("ipt_TCPMSS");
+MODULE_ALIAS("ip6t_TCPMSS");
+MODULE_ALIAS("xt_TCPMSS");
 
 static bool
 tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
@@ -93,15 +106,329 @@ static struct xt_match tcpmss_mt_reg[] __read_mostly = {
 	},
 };
 
-static int __init tcpmss_mt_init(void)
+static inline unsigned int
+optlen(const u8 *opt, unsigned int offset)
+{
+	/* Beware zero-length options: make finite progress */
+	if (opt[offset] <= TCPOPT_NOP || opt[offset + 1] == 0)
+		return 1;
+	else
+		return opt[offset + 1];
+}
+
+static u_int32_t tcpmss_reverse_mtu(struct net *net,
+				    const struct sk_buff *skb,
+				    unsigned int family)
+{
+	struct flowi fl;
+	struct rtable *rt = NULL;
+	u32 mtu     = ~0U;
+
+	if (family == PF_INET) {
+		struct flowi4 *fl4 = &fl.u.ip4;
+
+		memset(fl4, 0, sizeof(*fl4));
+		fl4->daddr = ip_hdr(skb)->saddr;
+	} else {
+		struct flowi6 *fl6 = &fl.u.ip6;
+
+		memset(fl6, 0, sizeof(*fl6));
+		fl6->daddr = ipv6_hdr(skb)->saddr;
+	}
+
+	nf_route(net, (struct dst_entry **)&rt, &fl, false, family);
+	if (rt) {
+		mtu = dst_mtu(&rt->dst);
+		dst_release(&rt->dst);
+	}
+	return mtu;
+}
+
+static int
+tcpmss_mangle_packet(struct sk_buff *skb,
+		     const struct xt_action_param *par,
+		     unsigned int family,
+		     unsigned int tcphoff,
+		     unsigned int minlen)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+	struct tcphdr *tcph;
+	int len, tcp_hdrlen;
+	unsigned int i;
+	__be16 oldval;
+	u16 newmss;
+	u8 *opt;
+
+	/* This is a fragment, no TCP header is available */
+	if (par->fragoff != 0)
+		return 0;
+
+	if (skb_ensure_writable(skb, skb->len))
+		return -1;
+
+	len = skb->len - tcphoff;
+	if (len < (int)sizeof(struct tcphdr))
+		return -1;
+
+	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	tcp_hdrlen = tcph->doff * 4;
+
+	if (len < tcp_hdrlen || tcp_hdrlen < sizeof(struct tcphdr))
+		return -1;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
+		struct net *net = xt_net(par);
+		unsigned int in_mtu = tcpmss_reverse_mtu(net, skb, family);
+		unsigned int min_mtu = min(dst_mtu(skb_dst(skb)), in_mtu);
+
+		if (min_mtu <= minlen) {
+			net_err_ratelimited("unknown or invalid path-MTU (%u)\n",
+					    min_mtu);
+			return -1;
+		}
+		newmss = min_mtu - minlen;
+	} else {
+		newmss = info->mss;
+	}
+
+	opt = (u_int8_t *)tcph;
+	for (i = sizeof(struct tcphdr); i <= tcp_hdrlen - TCPOLEN_MSS; i += optlen(opt, i)) {
+		if (opt[i] == TCPOPT_MSS && opt[i + 1] == TCPOLEN_MSS) {
+			u16 oldmss;
+
+			oldmss = (opt[i + 2] << 8) | opt[i + 3];
+
+			/* Never increase MSS, even when setting it, as
+			 * doing so results in problems for hosts that rely
+			 * on MSS being set correctly.
+			 */
+			if (oldmss <= newmss)
+				return 0;
+
+			opt[i + 2] = (newmss & 0xff00) >> 8;
+			opt[i + 3] = newmss & 0x00ff;
+
+			inet_proto_csum_replace2(&tcph->check, skb,
+						 htons(oldmss), htons(newmss),
+						 false);
+			return 0;
+		}
+	}
+
+	/* There is data after the header so the option can't be added
+	 * without moving it, and doing so may make the SYN packet
+	 * itself too large. Accept the packet unmodified instead.
+	 */
+	if (len > tcp_hdrlen)
+		return 0;
+
+	/* tcph->doff has 4 bits, do not wrap it to 0 */
+	if (tcp_hdrlen >= 15 * 4)
+		return 0;
+
+	/*
+	 * MSS Option not found ?! add it..
+	 */
+	if (skb_tailroom(skb) < TCPOLEN_MSS) {
+		if (pskb_expand_head(skb, 0,
+				     TCPOLEN_MSS - skb_tailroom(skb),
+				     GFP_ATOMIC))
+			return -1;
+		tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	}
+
+	skb_put(skb, TCPOLEN_MSS);
+
+	/*
+	 * IPv4: RFC 1122 states "If an MSS option is not received at
+	 * connection setup, TCP MUST assume a default send MSS of 536".
+	 * IPv6: RFC 2460 states IPv6 has a minimum MTU of 1280 and a minimum
+	 * length IPv6 header of 60, ergo the default MSS value is 1220
+	 * Since no MSS was provided, we must use the default values
+	 */
+	if (xt_family(par) == NFPROTO_IPV4)
+		newmss = min(newmss, (u16)536);
+	else
+		newmss = min(newmss, (u16)1220);
+
+	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
+	memmove(opt + TCPOLEN_MSS, opt, len - sizeof(struct tcphdr));
+
+	inet_proto_csum_replace2(&tcph->check, skb,
+				 htons(len), htons(len + TCPOLEN_MSS), true);
+	opt[0] = TCPOPT_MSS;
+	opt[1] = TCPOLEN_MSS;
+	opt[2] = (newmss & 0xff00) >> 8;
+	opt[3] = newmss & 0x00ff;
+
+	inet_proto_csum_replace4(&tcph->check, skb, 0, *((__be32 *)opt), false);
+
+	oldval = ((__be16 *)tcph)[6];
+	tcph->doff += TCPOLEN_MSS / 4;
+	inet_proto_csum_replace2(&tcph->check, skb,
+				 oldval, ((__be16 *)tcph)[6], false);
+	return TCPOLEN_MSS;
+}
+
+static unsigned int
+tcpmss_tg4(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct iphdr *iph = ip_hdr(skb);
+	__be16 newlen;
+	int ret;
+
+	ret = tcpmss_mangle_packet(skb, par,
+				   PF_INET,
+				   iph->ihl * 4,
+				   sizeof(*iph) + sizeof(struct tcphdr));
+	if (ret < 0)
+		return NF_DROP;
+	if (ret > 0) {
+		iph = ip_hdr(skb);
+		newlen = htons(ntohs(iph->tot_len) + ret);
+		csum_replace2(&iph->check, iph->tot_len, newlen);
+		iph->tot_len = newlen;
+	}
+	return XT_CONTINUE;
+}
+
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+static unsigned int
+tcpmss_tg6(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+	u8 nexthdr;
+	__be16 frag_off, oldlen, newlen;
+	int tcphoff;
+	int ret;
+
+	nexthdr = ipv6h->nexthdr;
+	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr, &frag_off);
+	if (tcphoff < 0)
+		return NF_DROP;
+	ret = tcpmss_mangle_packet(skb, par,
+				   PF_INET6,
+				   tcphoff,
+				   sizeof(*ipv6h) + sizeof(struct tcphdr));
+	if (ret < 0)
+		return NF_DROP;
+	if (ret > 0) {
+		ipv6h = ipv6_hdr(skb);
+		oldlen = ipv6h->payload_len;
+		newlen = htons(ntohs(oldlen) + ret);
+		if (skb->ip_summed == CHECKSUM_COMPLETE)
+			skb->csum = csum_add(csum_sub(skb->csum, (__force __wsum)oldlen),
+					     (__force __wsum)newlen);
+		ipv6h->payload_len = newlen;
+	}
+	return XT_CONTINUE;
+}
+#endif
+
+/* Must specify -p tcp --syn */
+static inline bool find_syn_match(const struct xt_entry_match *m)
+{
+	const struct xt_tcp *tcpinfo = (const struct xt_tcp *)m->data;
+
+	if (strcmp(m->u.kernel.match->name, "tcp") == 0 &&
+	    tcpinfo->flg_cmp & TCPHDR_SYN &&
+	    !(tcpinfo->invflags & XT_TCP_INV_FLAGS))
+		return true;
+
+	return false;
+}
+
+static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
+	const struct xt_entry_match *ematch;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
+			   (1 << NF_INET_LOCAL_OUT) |
+			   (1 << NF_INET_POST_ROUTING))) != 0) {
+		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
+		return -EINVAL;
+	}
+	if (par->nft_compat)
+		return 0;
+
+	xt_ematch_foreach(ematch, e)
+		if (find_syn_match(ematch))
+			return 0;
+	pr_info_ratelimited("Only works on TCP SYN packets\n");
+	return -EINVAL;
+}
+
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
+{
+	const struct xt_tcpmss_info *info = par->targinfo;
+	const struct ip6t_entry *e = par->entryinfo;
+	const struct xt_entry_match *ematch;
+
+	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
+			   (1 << NF_INET_LOCAL_OUT) |
+			   (1 << NF_INET_POST_ROUTING))) != 0) {
+		pr_info_ratelimited("path-MTU clamping only supported in FORWARD, OUTPUT and POSTROUTING hooks\n");
+		return -EINVAL;
+	}
+	if (par->nft_compat)
+		return 0;
+
+	xt_ematch_foreach(ematch, e)
+		if (find_syn_match(ematch))
+			return 0;
+	pr_info_ratelimited("Only works on TCP SYN packets\n");
+	return -EINVAL;
+}
+#endif
+
+static struct xt_target tcpmss_tg_reg[] __read_mostly = {
+	{
+		.family		= NFPROTO_IPV4,
+		.name		= "TCPMSS",
+		.checkentry	= tcpmss_tg4_check,
+		.target		= tcpmss_tg4,
+		.targetsize	= sizeof(struct xt_tcpmss_info),
+		.proto		= IPPROTO_TCP,
+		.me		= THIS_MODULE,
+	},
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+	{
+		.family		= NFPROTO_IPV6,
+		.name		= "TCPMSS",
+		.checkentry	= tcpmss_tg6_check,
+		.target		= tcpmss_tg6,
+		.targetsize	= sizeof(struct xt_tcpmss_info),
+		.proto		= IPPROTO_TCP,
+		.me		= THIS_MODULE,
+	},
+#endif
+};
+
+static int __init tcpmss_init(void)
 {
-	return xt_register_matches(tcpmss_mt_reg, ARRAY_SIZE(tcpmss_mt_reg));
+	int ret;
+
+	ret = xt_register_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
+	if (ret < 0)
+		return ret;
+	ret = xt_register_matches(tcpmss_mt_reg, ARRAY_SIZE(tcpmss_mt_reg));
+	if (ret < 0) {
+		xt_unregister_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
+		return ret;
+	}
+	return 0;
 }
 
-static void __exit tcpmss_mt_exit(void)
+static void __exit tcpmss_exit(void)
 {
 	xt_unregister_matches(tcpmss_mt_reg, ARRAY_SIZE(tcpmss_mt_reg));
+	xt_unregister_targets(tcpmss_tg_reg, ARRAY_SIZE(tcpmss_tg_reg));
 }
 
-module_init(tcpmss_mt_init);
-module_exit(tcpmss_mt_exit);
+module_init(tcpmss_init);
+module_exit(tcpmss_exit);
-- 
2.43.5

