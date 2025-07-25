Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4302EF676;
	Fri, 25 Jul 2025 17:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463046; cv=none; b=INENa3+YxWTDpRBwaIWBUFxXYcCU+vIHcmdcy5Bg7W/E2YvfFVbQwB+/FIdxfrEGREsRGSmRyPO8PDbv1OzgLd+7EzGblX6dK22vKS5e4TFt2obh3tKDEHH4XPSvsWioGiGp3MihlY1gz+HGklQEV0xB1O0YZcAMUJJu9fJ3jN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463046; c=relaxed/simple;
	bh=qQBE30ovpbXerXqDZYHgjpV/FCZcqXi4RtuGgpIkDGs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lSIxIPo8lmLZeIXVOrLNSDbptQt8n2gX6ydkqiEhIsvrIBiF6TIwlCG+D9Li51Sj+cvTKJi5qm/FMblnXAku/xboXm1+IS1Ds3qeBzVaSsO5a/FUxrtlONTysqUpVXrlBdcTC177AoC6rg/CiOOcR/kDdZD3mTRGzApCpLXiO2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BYZFiTs1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VWqvD6Gi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BYZFiTs1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VWqvD6Gi"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6695D60275; Fri, 25 Jul 2025 19:04:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463043;
	bh=B7BCYX04pEfIr2dxpJqzPr6koJXusGlxsnN1sxWwrXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYZFiTs1lhuLnSwv3Y84D2yjNgB/6ELyOqDz5sQByJ+/jUknp/OmL4ln9+rtaiDtG
	 Q3w74u5nI4inTUZrwpOt0BXZWjkkjEC+KVo9w466RTYprmJg1R6Ai0yKU+gij7sHb4
	 DAJ9QCuQby0MWpX6oUi86DySt4r3ulozJKHBwVl4qEr3BikQbFGS4/ZzrJXMN8uBnV
	 5cEyt9Wqg+qRJjNdrM9+ullWzfDHInIr8u2pSy2R9zkZSIKl/Y8DIkpoYAOg2754co
	 361Odte5lYgrM5i6DKjhZBmO2PJ1t9gXMD/CHRMCr+FP4qeVVajbCzqqExpMgfWOtk
	 l44fuBL7NeFxA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6974360275;
	Fri, 25 Jul 2025 19:03:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463038;
	bh=B7BCYX04pEfIr2dxpJqzPr6koJXusGlxsnN1sxWwrXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWqvD6Gixt+WjtcQRaAkLAUUG/RaF/JhZ8SNnHaJvilmD+nBjXDbXj87ByjwEDlJF
	 ssepK7Z3DmKh0GhksWkv4L4QmxUEFWz9DdHrPvYJ5tKkKQK3ze97/IRCQajEjC9tkn
	 PqqGzY2oNVRlgeN1XXuRzRXTfrvzKDr4POkV/GKiEKgn0heHAYVIAOCLtXYlqzuUO4
	 fRFSfrT241oF1IvuGZGrZaP8CMtqqQGqJEZR7vB2CxVuY0h5S69OvaC1oHZfxZ8i4X
	 EdBVRhEiKWT9DGzsbBilOv2ANENmemawKSqQPnEa/wRQ5KfN1HViTpBTIkg3bpcRvG
	 X2o8s6U+i0GLQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 06/19] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Date: Fri, 25 Jul 2025 19:03:27 +0200
Message-Id: <20250725170340.21327-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The seqcount xt_recseq is used to synchronize the replacement of
xt_table::private in xt_replace_table() against all readers such as
ipt_do_table()

To ensure that there is only one writer, the writing side disables
bottom halves. The sequence counter can be acquired recursively. Only the
first invocation modifies the sequence counter (signaling that a writer
is in progress) while the following (recursive) writer does not modify
the counter.
The lack of a proper locking mechanism for the sequence counter can lead
to live lock on PREEMPT_RT if the high prior reader preempts the
writer. Additionally if the per-CPU lock on PREEMPT_RT is removed from
local_bh_disable() then there is no synchronisation for the per-CPU
sequence counter.

The affected code is "just" the legacy netfilter code which is replaced
by "netfilter tables". That code can be disabled without sacrificing
functionality because everything is provided by the newer
implementation. This will only requires the usage of the "-nft" tools
instead of the "-legacy" ones.
The long term plan is to remove the legacy code so lets accelerate the
progress.

Relax dependencies on iptables legacy, replace select with depends on,
this should cause no harm to existing kernel configs and users can still
toggle IP{6}_NF_IPTABLES_LEGACY in any case.
Make EBTABLES_LEGACY, IPTABLES_LEGACY and ARPTABLES depend on
NETFILTER_XTABLES_LEGACY. Hide xt_recseq and its users,
xt_register_table() and xt_percpu_counter_alloc() behind
NETFILTER_XTABLES_LEGACY. Let NETFILTER_XTABLES_LEGACY depend on
!PREEMPT_RT.

This will break selftest expecing the legacy options enabled and will be
addressed in a following patch.

Co-developed-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/Kconfig | 10 +++++-----
 net/ipv4/netfilter/Kconfig   | 24 ++++++++++++------------
 net/ipv6/netfilter/Kconfig   | 19 +++++++++----------
 net/netfilter/Kconfig        | 10 ++++++++++
 net/netfilter/x_tables.c     | 16 +++++++++++-----
 5 files changed, 47 insertions(+), 32 deletions(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index f16bbbbb9481..60f28e4fb5c0 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -42,8 +42,8 @@ config NF_CONNTRACK_BRIDGE
 # old sockopt interface and eval loop
 config BRIDGE_NF_EBTABLES_LEGACY
 	tristate "Legacy EBTABLES support"
-	depends on BRIDGE && NETFILTER_XTABLES
-	default n
+	depends on BRIDGE && NETFILTER_XTABLES_LEGACY
+	default	n
 	help
 	 Legacy ebtables packet/frame classifier.
 	 This is not needed if you are using ebtables over nftables
@@ -65,7 +65,7 @@ if BRIDGE_NF_EBTABLES
 #
 config BRIDGE_EBT_BROUTE
 	tristate "ebt: broute table support"
-	select BRIDGE_NF_EBTABLES_LEGACY
+	depends on BRIDGE_NF_EBTABLES_LEGACY
 	help
 	  The ebtables broute table is used to define rules that decide between
 	  bridging and routing frames, giving Linux the functionality of a
@@ -76,7 +76,7 @@ config BRIDGE_EBT_BROUTE
 
 config BRIDGE_EBT_T_FILTER
 	tristate "ebt: filter table support"
-	select BRIDGE_NF_EBTABLES_LEGACY
+	depends on BRIDGE_NF_EBTABLES_LEGACY
 	help
 	  The ebtables filter table is used to define frame filtering rules at
 	  local input, forwarding and local output. See the man page for
@@ -86,7 +86,7 @@ config BRIDGE_EBT_T_FILTER
 
 config BRIDGE_EBT_T_NAT
 	tristate "ebt: nat table support"
-	select BRIDGE_NF_EBTABLES_LEGACY
+	depends on BRIDGE_NF_EBTABLES_LEGACY
 	help
 	  The ebtables nat table is used to define rules that alter the MAC
 	  source address (MAC SNAT) or the MAC destination address (MAC DNAT).
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index ef8009281da5..2c438b140e88 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -13,8 +13,8 @@ config NF_DEFRAG_IPV4
 # old sockopt interface and eval loop
 config IP_NF_IPTABLES_LEGACY
 	tristate "Legacy IP tables support"
-	default	n
-	select NETFILTER_XTABLES
+	depends on NETFILTER_XTABLES_LEGACY
+	default	m if NETFILTER_XTABLES_LEGACY
 	help
 	  iptables is a legacy packet classifier.
 	  This is not needed if you are using iptables over nftables
@@ -182,8 +182,8 @@ config IP_NF_MATCH_TTL
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
-	default m if NETFILTER_ADVANCED=n
-	select IP_NF_IPTABLES_LEGACY
+	default m if NETFILTER_ADVANCED=n || IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  Packet filtering defines a table `filter', which has a series of
 	  rules for simple packet filtering at local input, forwarding and
@@ -220,10 +220,10 @@ config IP_NF_TARGET_SYNPROXY
 config IP_NF_NAT
 	tristate "iptables NAT support"
 	depends on NF_CONNTRACK
+	depends on IP_NF_IPTABLES_LEGACY
 	default m if NETFILTER_ADVANCED=n
 	select NF_NAT
 	select NETFILTER_XT_NAT
-	select IP_NF_IPTABLES_LEGACY
 	help
 	  This enables the `nat' table in iptables. This allows masquerading,
 	  port forwarding and other forms of full Network Address Port
@@ -263,8 +263,8 @@ endif # IP_NF_NAT
 # mangle + specific targets
 config IP_NF_MANGLE
 	tristate "Packet mangling"
-	default m if NETFILTER_ADVANCED=n
-	select IP_NF_IPTABLES_LEGACY
+	default m if NETFILTER_ADVANCED=n || IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -299,7 +299,7 @@ config IP_NF_TARGET_TTL
 # raw + specific targets
 config IP_NF_RAW
 	tristate  'raw table support (required for NOTRACK/TRACE)'
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to iptables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -313,7 +313,7 @@ config IP_NF_SECURITY
 	tristate "Security table"
 	depends on SECURITY
 	depends on NETFILTER_ADVANCED
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
@@ -325,8 +325,8 @@ endif # IP_NF_IPTABLES
 # ARP tables
 config IP_NF_ARPTABLES
 	tristate "Legacy ARPTABLES support"
-	depends on NETFILTER_XTABLES
-	default n
+	depends on NETFILTER_XTABLES_LEGACY
+	default	n
 	help
 	  arptables is a legacy packet classifier.
 	  This is not needed if you are using arptables over nftables
@@ -342,7 +342,7 @@ config IP_NF_ARPFILTER
 	tristate "arptables-legacy packet filtering support"
 	select IP_NF_ARPTABLES
 	select NETFILTER_FAMILY_ARP
-	depends on NETFILTER_XTABLES
+	depends on NETFILTER_XTABLES_LEGACY
 	help
 	  ARP packet filtering defines a table `filter', which has a series of
 	  rules for simple ARP packet filtering at local input and
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index e087a8e97ba7..276860f65baa 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -9,9 +9,8 @@ menu "IPv6: Netfilter Configuration"
 # old sockopt interface and eval loop
 config IP6_NF_IPTABLES_LEGACY
 	tristate "Legacy IP6 tables support"
-	depends on INET && IPV6
-	select NETFILTER_XTABLES
-	default n
+	depends on INET && IPV6 && NETFILTER_XTABLES_LEGACY
+	default	m if NETFILTER_XTABLES_LEGACY
 	help
 	  ip6tables is a legacy packet classifier.
 	  This is not needed if you are using iptables over nftables
@@ -196,8 +195,8 @@ config IP6_NF_TARGET_HL
 
 config IP6_NF_FILTER
 	tristate "Packet filtering"
-	default m if NETFILTER_ADVANCED=n
-	select IP6_NF_IPTABLES_LEGACY
+	default m if NETFILTER_ADVANCED=n || IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	tristate
 	help
 	  Packet filtering defines a table `filter', which has a series of
@@ -233,8 +232,8 @@ config IP6_NF_TARGET_SYNPROXY
 
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
-	default m if NETFILTER_ADVANCED=n
-	select IP6_NF_IPTABLES_LEGACY
+	default m if NETFILTER_ADVANCED=n || IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -244,7 +243,7 @@ config IP6_NF_MANGLE
 
 config IP6_NF_RAW
 	tristate  'raw table support (required for TRACE)'
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to ip6tables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -258,7 +257,7 @@ config IP6_NF_SECURITY
 	tristate "Security table"
 	depends on SECURITY
 	depends on NETFILTER_ADVANCED
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
@@ -269,8 +268,8 @@ config IP6_NF_NAT
 	tristate "ip6tables NAT support"
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
+	depends on IP6_NF_IPTABLES_LEGACY
 	select NF_NAT
-	select IP6_NF_IPTABLES_LEGACY
 	select NETFILTER_XT_NAT
 	help
 	  This enables the `nat' table in ip6tables. This allows masquerading,
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ba60b48d7567..6cdc994fdc8a 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -758,6 +758,16 @@ config NETFILTER_XTABLES_COMPAT
 
 	   If unsure, say N.
 
+config NETFILTER_XTABLES_LEGACY
+	bool "Netfilter legacy tables support"
+	depends on !PREEMPT_RT
+	help
+	  Say Y here if you still require support for legacy tables. This is
+	  required by the legacy tools (iptables-legacy) and is not needed if
+	  you use iptables over nftables (iptables-nft).
+	  Legacy support is not limited to IP, it also includes EBTABLES and
+	  ARPTABLES.
+
 comment "Xtables combined modules"
 
 config NETFILTER_XT_MARK
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 709840612f0d..90b7630421c4 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1317,12 +1317,13 @@ void xt_compat_unlock(u_int8_t af)
 EXPORT_SYMBOL_GPL(xt_compat_unlock);
 #endif
 
-DEFINE_PER_CPU(seqcount_t, xt_recseq);
-EXPORT_PER_CPU_SYMBOL_GPL(xt_recseq);
-
 struct static_key xt_tee_enabled __read_mostly;
 EXPORT_SYMBOL_GPL(xt_tee_enabled);
 
+#ifdef CONFIG_NETFILTER_XTABLES_LEGACY
+DEFINE_PER_CPU(seqcount_t, xt_recseq);
+EXPORT_PER_CPU_SYMBOL_GPL(xt_recseq);
+
 static int xt_jumpstack_alloc(struct xt_table_info *i)
 {
 	unsigned int size;
@@ -1514,6 +1515,7 @@ void *xt_unregister_table(struct xt_table *table)
 	return private;
 }
 EXPORT_SYMBOL_GPL(xt_unregister_table);
+#endif
 
 #ifdef CONFIG_PROC_FS
 static void *xt_table_seq_start(struct seq_file *seq, loff_t *pos)
@@ -1897,6 +1899,7 @@ void xt_proto_fini(struct net *net, u_int8_t af)
 }
 EXPORT_SYMBOL_GPL(xt_proto_fini);
 
+#ifdef CONFIG_NETFILTER_XTABLES_LEGACY
 /**
  * xt_percpu_counter_alloc - allocate x_tables rule counter
  *
@@ -1951,6 +1954,7 @@ void xt_percpu_counter_free(struct xt_counters *counters)
 		free_percpu((void __percpu *)pcnt);
 }
 EXPORT_SYMBOL_GPL(xt_percpu_counter_free);
+#endif
 
 static int __net_init xt_net_init(struct net *net)
 {
@@ -1983,8 +1987,10 @@ static int __init xt_init(void)
 	unsigned int i;
 	int rv;
 
-	for_each_possible_cpu(i) {
-		seqcount_init(&per_cpu(xt_recseq, i));
+	if (IS_ENABLED(CONFIG_NETFILTER_XTABLES_LEGACY)) {
+		for_each_possible_cpu(i) {
+			seqcount_init(&per_cpu(xt_recseq, i));
+		}
 	}
 
 	xt = kcalloc(NFPROTO_NUMPROTO, sizeof(struct xt_af), GFP_KERNEL);
-- 
2.30.2

