Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDF128DEE5
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2025 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751298274; cv=none; b=hAkLakvVx3bLYTqCkqN5sWrM41fKjM9goqHFtInLiuuxmPG2lp7DdeTbzOF/y8wYZjVeM4uXkgaPrZehBOTj3RxQU0t/ZQFYZuImHIOTAwj0+blO9uWcylAE7p4i7mjKFxRKEf0k7bzbgzUSkHnMV0nFMXVMgiIpwlzVixggpA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751298274; c=relaxed/simple;
	bh=mCunjzAxiXWC3g4i3wR/b8EEzcn/1T9KvuFmdowQCqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COKYvRGvhiSRHu5Mv+S1TjoJDrvj620pwCxAkMHRbykzVgcUPF9UPZDVKgocIjcqDhopbJMqEOBWVABAOHm1EQ91ru2AUOKAEv32B+voY5E2nxXorhnPSu3iMZMl049rAYs6ScOPa+RqSGpG5B7bASkNE4Rq3ikUnSf6dOLuqJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=DVY8OiO8; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=t5KhAwf8; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="DVY8OiO8";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="t5KhAwf8"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1751298271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EjM5nahdlbXlbpFuw/TapH4NUe3G+70mT2oDFDhiybE=;
	b=DVY8OiO8YPKYPyOm475V02M0lrph+Tk1X0P8LFhmU+EOnflNmaRCbnz2CPwCbOZae+ceev
	7FUdOm/J1DyqL4meNWuDE3i10xrbf7apFyKXarIe7+KeuaPCa2wH2ut9yLdTSUJIHVTisO
	FJJ8xmVT+QVqiTZsb9XiEGbUDFBTN1TInB1TeJtFpTKhsUl8ea8h19UOE3eGzojauLG0WF
	EFFYblxXPGrWN27w3d6NO9psWr6JwE3WHMId4iV/VclfaftoamvqeQ3X6TKDDnKUNppWRH
	aeax8AGSc+EMGwnWgboYxi/dQZydYgrSbzdyicaEjQtbq2U44x5uE9nZTcvfGQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1751298271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EjM5nahdlbXlbpFuw/TapH4NUe3G+70mT2oDFDhiybE=;
	b=t5KhAwf8agNJ4E4KzLY+8dNW2BAF1zV8nC9ji5OycrowFofrqmQR/LtVS3DyBq/Vc/JZCN
	lm+tFbPxKIhTSsCw==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v5 1/3] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Date: Mon, 30 Jun 2025 17:44:23 +0200
Message-ID: <20250630154425.3830665-2-bigeasy@linutronix.de>
In-Reply-To: <20250630154425.3830665-1-bigeasy@linutronix.de>
References: <20250630154425.3830665-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
index f16bbbbb94817..60f28e4fb5c0a 100644
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
=20
 config BRIDGE_EBT_T_FILTER
 	tristate "ebt: filter table support"
-	select BRIDGE_NF_EBTABLES_LEGACY
+	depends on BRIDGE_NF_EBTABLES_LEGACY
 	help
 	  The ebtables filter table is used to define frame filtering rules at
 	  local input, forwarding and local output. See the man page for
@@ -86,7 +86,7 @@ config BRIDGE_EBT_T_FILTER
=20
 config BRIDGE_EBT_T_NAT
 	tristate "ebt: nat table support"
-	select BRIDGE_NF_EBTABLES_LEGACY
+	depends on BRIDGE_NF_EBTABLES_LEGACY
 	help
 	  The ebtables nat table is used to define rules that alter the MAC
 	  source address (MAC SNAT) or the MAC destination address (MAC DNAT).
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index ef8009281da5c..2c438b140e88f 100644
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
-	default m if NETFILTER_ADVANCED=3Dn
-	select IP_NF_IPTABLES_LEGACY
+	default m if NETFILTER_ADVANCED=3Dn || IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  Packet filtering defines a table `filter', which has a series of
 	  rules for simple packet filtering at local input, forwarding and
@@ -220,10 +220,10 @@ config IP_NF_TARGET_SYNPROXY
 config IP_NF_NAT
 	tristate "iptables NAT support"
 	depends on NF_CONNTRACK
+	depends on IP_NF_IPTABLES_LEGACY
 	default m if NETFILTER_ADVANCED=3Dn
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
-	default m if NETFILTER_ADVANCED=3Dn
-	select IP_NF_IPTABLES_LEGACY
+	default m if NETFILTER_ADVANCED=3Dn || IP_NF_IPTABLES_LEGACY
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
index e087a8e97ba78..276860f65baae 100644
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
=20
 config IP6_NF_FILTER
 	tristate "Packet filtering"
-	default m if NETFILTER_ADVANCED=3Dn
-	select IP6_NF_IPTABLES_LEGACY
+	default m if NETFILTER_ADVANCED=3Dn || IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	tristate
 	help
 	  Packet filtering defines a table `filter', which has a series of
@@ -233,8 +232,8 @@ config IP6_NF_TARGET_SYNPROXY
=20
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
-	default m if NETFILTER_ADVANCED=3Dn
-	select IP6_NF_IPTABLES_LEGACY
+	default m if NETFILTER_ADVANCED=3Dn || IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -244,7 +243,7 @@ config IP6_NF_MANGLE
=20
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
index 2560416218d07..fe114607234ee 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -762,6 +762,16 @@ config NETFILTER_XTABLES_COMPAT
=20
 	   If unsure, say N.
=20
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
=20
 config NETFILTER_XT_MARK
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 709840612f0df..90b7630421c44 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1317,12 +1317,13 @@ void xt_compat_unlock(u_int8_t af)
 EXPORT_SYMBOL_GPL(xt_compat_unlock);
 #endif
=20
-DEFINE_PER_CPU(seqcount_t, xt_recseq);
-EXPORT_PER_CPU_SYMBOL_GPL(xt_recseq);
-
 struct static_key xt_tee_enabled __read_mostly;
 EXPORT_SYMBOL_GPL(xt_tee_enabled);
=20
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
=20
 #ifdef CONFIG_PROC_FS
 static void *xt_table_seq_start(struct seq_file *seq, loff_t *pos)
@@ -1897,6 +1899,7 @@ void xt_proto_fini(struct net *net, u_int8_t af)
 }
 EXPORT_SYMBOL_GPL(xt_proto_fini);
=20
+#ifdef CONFIG_NETFILTER_XTABLES_LEGACY
 /**
  * xt_percpu_counter_alloc - allocate x_tables rule counter
  *
@@ -1951,6 +1954,7 @@ void xt_percpu_counter_free(struct xt_counters *count=
ers)
 		free_percpu((void __percpu *)pcnt);
 }
 EXPORT_SYMBOL_GPL(xt_percpu_counter_free);
+#endif
=20
 static int __net_init xt_net_init(struct net *net)
 {
@@ -1983,8 +1987,10 @@ static int __init xt_init(void)
 	unsigned int i;
 	int rv;
=20
-	for_each_possible_cpu(i) {
-		seqcount_init(&per_cpu(xt_recseq, i));
+	if (IS_ENABLED(CONFIG_NETFILTER_XTABLES_LEGACY)) {
+		for_each_possible_cpu(i) {
+			seqcount_init(&per_cpu(xt_recseq, i));
+		}
 	}
=20
 	xt =3D kcalloc(NFPROTO_NUMPROTO, sizeof(struct xt_af), GFP_KERNEL);
--=20
2.50.0

