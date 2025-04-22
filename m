Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21EF2D0261;
	Tue, 22 Apr 2025 20:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745353443; cv=none; b=hPxU2RvshZn8wgldoAwuWe6e8UVsRdYunYEQ13LYC0sCz0xVFbWO1Nw4jAp7j73RR0j1EFS1r0W4er8ZX+4AjQXla/j3HNtJ81ZxpidjWjJOKpWsq3HtfjwCaxJJn2W8xQ7EotNBXssVAB0dNSrhqzuZvimLx6gGp+9eysWfGew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745353443; c=relaxed/simple;
	bh=W9B56y/1e2VNF0GDYDVpKNnAod/7cx5D988X6ej4Xx8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IZZO995fm5hMgNDiRL9es8Bvpd1SgsURg6UcGAhLxXVWNyFhBiz1T4Uhs/sp2UA1aIogeZbBKEEf83mMLOkl2pjpy9BCgf+b92KKCmk4tLLbt7avzsQvuTOTwrUSqSAnAqSVFZn7T3vP/utCwhbrDOzWyEbc5lI1eEaMvKQ95LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BLG8Jto6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=s4OCvWte; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BLG8Jto6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="s4OCvWte"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 57747609B7; Tue, 22 Apr 2025 22:24:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353440;
	bh=DF/dbc9yujO6X92LbVBOTQ7n7U8r73XeLkbxpIj51Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLG8Jto6qGIX5siVne6bjuOogMs/bJ5srG96tOfP3twYREdLqfQFuuImVWQgScBdu
	 qLavJYd2pcsXmN0pHoszfTeSxx5ZdWA83scSW0tSdqcHGXLSagEBHsytaAMi+ydQZj
	 pciOV3/dUxbE4h1Cko0C+1/D8Sosd4B24N0oNIk7L7kXGjMKPrWrokLudwjovfkexe
	 FdKMVl2NcrGpgZgHsX4cOReY2U78xRg7XLFVxU5xK76W3ew6X1G/qjKHjIBFsARL61
	 gqOq6tdseQa6A/unAEb1KD4X8Osdp3vs1vEyej/KK75Ufu7QopkgBeiAyb0zWlhiME
	 a9qkA/xqzkdwQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5ACDD609B4;
	Tue, 22 Apr 2025 22:23:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745353431;
	bh=DF/dbc9yujO6X92LbVBOTQ7n7U8r73XeLkbxpIj51Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4OCvWteVNzzzybbGYWSEWhtgabK/jXGVDz5bDRMPUcYb/rqEt3j9sUFeJnKm4ECq
	 +DHB6Ohv9C6nJr19Ftv/gIEtNKAL8jiEzzksa4RWaL70QL2oJ+IX6VBANytioMmTBr
	 gRrpX5buCjT/9PLNpfBYv4UQGBV8nMOkjKOJYwKiccTI2OIKfrpIGc6T1Fipje6Xgw
	 Yqu2fmpTdxKzq7kQ5p3LsXX9QL4V2//MYWvYpwK2+4deoc9hytHCDmMMbNDOCaQh8o
	 SYIF5U9xHbr05gQ31egw18bIbh5RNa1csoKvHW41S8dgMlStrwRT1i6N3RxufVqlyK
	 7/eP5dVJqHm8Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 4/7] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Date: Tue, 22 Apr 2025 22:23:24 +0200
Message-Id: <20250422202327.271536-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250422202327.271536-1-pablo@netfilter.org>
References: <20250422202327.271536-1-pablo@netfilter.org>
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
NETFILTER_LEGACY. Hide xt_recseq and its users, xt_register_table() and
xt_percpu_counter_alloc() behind NETFILTER_LEGACY. Let NETFILTER_LEGACY
depend on !PREEMPT_RT.

Replace CONFIG_IP6_NF_MANGLE->CONFIG_IP6_NF_IPTABLES for TCPOPTSTRIP and
add CONFIG_NFT_COMPAT_ARP to the MARK target for the IPv6 and ARP target
to keep it enabled without the LEGACY code for NFT.

Co-developed-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/Kconfig                    | 10 ++++++++++
 net/bridge/netfilter/Kconfig   |  8 ++++----
 net/ipv4/netfilter/Kconfig     | 15 ++++++++-------
 net/ipv6/netfilter/Kconfig     | 13 +++++++------
 net/netfilter/x_tables.c       | 16 +++++++++++-----
 net/netfilter/xt_TCPOPTSTRIP.c |  4 ++--
 net/netfilter/xt_mark.c        |  2 +-
 7 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index 202cc595e5e6..1a4d18b8501d 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -211,6 +211,16 @@ menuconfig NETFILTER
 
 if NETFILTER
 
+config NETFILTER_LEGACY
+	bool "Netfilter legacy tables support"
+	depends on NETFILTER && !PREEMPT_RT
+	help
+	  Say Y here if you still require support for legacy tables. This is
+	  required by the legacy tools (iptables-legacy) and is not needed if
+	  you use iptables over nftables (iptales-nft).
+	  Legacy support is not limited to IP, it also includes EBTABLES and
+	  ARPTABLES.
+
 config NETFILTER_ADVANCED
 	bool "Advanced netfilter configuration"
 	depends on NETFILTER
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index f16bbbbb9481..008012742188 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -42,7 +42,7 @@ config NF_CONNTRACK_BRIDGE
 # old sockopt interface and eval loop
 config BRIDGE_NF_EBTABLES_LEGACY
 	tristate "Legacy EBTABLES support"
-	depends on BRIDGE && NETFILTER_XTABLES
+	depends on BRIDGE && NETFILTER_XTABLES && NETFILTER_LEGACY
 	default n
 	help
 	 Legacy ebtables packet/frame classifier.
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
index ef8009281da5..dcf015e0d426 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -14,6 +14,7 @@ config NF_DEFRAG_IPV4
 config IP_NF_IPTABLES_LEGACY
 	tristate "Legacy IP tables support"
 	default	n
+	depends on NETFILTER_LEGACY
 	select NETFILTER_XTABLES
 	help
 	  iptables is a legacy packet classifier.
@@ -183,7 +184,7 @@ config IP_NF_MATCH_TTL
 config IP_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=n
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  Packet filtering defines a table `filter', which has a series of
 	  rules for simple packet filtering at local input, forwarding and
@@ -220,10 +221,10 @@ config IP_NF_TARGET_SYNPROXY
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
@@ -264,7 +265,7 @@ endif # IP_NF_NAT
 config IP_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=n
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -299,7 +300,7 @@ config IP_NF_TARGET_TTL
 # raw + specific targets
 config IP_NF_RAW
 	tristate  'raw table support (required for NOTRACK/TRACE)'
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to iptables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -313,7 +314,7 @@ config IP_NF_SECURITY
 	tristate "Security table"
 	depends on SECURITY
 	depends on NETFILTER_ADVANCED
-	select IP_NF_IPTABLES_LEGACY
+	depends on IP_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
@@ -325,7 +326,7 @@ endif # IP_NF_IPTABLES
 # ARP tables
 config IP_NF_ARPTABLES
 	tristate "Legacy ARPTABLES support"
-	depends on NETFILTER_XTABLES
+	depends on NETFILTER_XTABLES && NETFILTER_LEGACY
 	default n
 	help
 	  arptables is a legacy packet classifier.
@@ -342,7 +343,7 @@ config IP_NF_ARPFILTER
 	tristate "arptables-legacy packet filtering support"
 	select IP_NF_ARPTABLES
 	select NETFILTER_FAMILY_ARP
-	depends on NETFILTER_XTABLES
+	depends on NETFILTER_XTABLES && NETFILTER_LEGACY
 	help
 	  ARP packet filtering defines a table `filter', which has a series of
 	  rules for simple ARP packet filtering at local input and
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index e087a8e97ba7..303942174b5d 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -9,8 +9,9 @@ menu "IPv6: Netfilter Configuration"
 # old sockopt interface and eval loop
 config IP6_NF_IPTABLES_LEGACY
 	tristate "Legacy IP6 tables support"
-	depends on INET && IPV6
+	depends on INET && IPV6 && NETFILTER_LEGACY
 	select NETFILTER_XTABLES
+	select IP6_NF_IPTABLES
 	default n
 	help
 	  ip6tables is a legacy packet classifier.
@@ -197,7 +198,7 @@ config IP6_NF_TARGET_HL
 config IP6_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=n
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	tristate
 	help
 	  Packet filtering defines a table `filter', which has a series of
@@ -234,7 +235,7 @@ config IP6_NF_TARGET_SYNPROXY
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=n
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -244,7 +245,7 @@ config IP6_NF_MANGLE
 
 config IP6_NF_RAW
 	tristate  'raw table support (required for TRACE)'
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to ip6tables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -258,7 +259,7 @@ config IP6_NF_SECURITY
 	tristate "Security table"
 	depends on SECURITY
 	depends on NETFILTER_ADVANCED
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
@@ -269,8 +270,8 @@ config IP6_NF_NAT
 	tristate "ip6tables NAT support"
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
+	depends on IP6_NF_IPTABLES_LEGACY
 	select NF_NAT
-	select IP6_NF_IPTABLES_LEGACY
 	select NETFILTER_XT_NAT
 	help
 	  This enables the `nat' table in ip6tables. This allows masquerading,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 709840612f0d..24788bd3cbcb 100644
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
 
+#ifdef CONFIG_NETFILTER_LEGACY
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
 
+#ifdef CONFIG_NETFILTER_LEGACY
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
+	if (IS_ENABLED(CONFIG_NETFILTER_LEGACY)) {
+		for_each_possible_cpu(i) {
+			seqcount_init(&per_cpu(xt_recseq, i));
+		}
 	}
 
 	xt = kcalloc(NFPROTO_NUMPROTO, sizeof(struct xt_af), GFP_KERNEL);
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 30e99464171b..93f064306901 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -91,7 +91,7 @@ tcpoptstrip_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	return tcpoptstrip_mangle_packet(skb, par, ip_hdrlen(skb));
 }
 
-#if IS_ENABLED(CONFIG_IP6_NF_MANGLE)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static unsigned int
 tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -119,7 +119,7 @@ static struct xt_target tcpoptstrip_tg_reg[] __read_mostly = {
 		.targetsize = sizeof(struct xt_tcpoptstrip_target_info),
 		.me         = THIS_MODULE,
 	},
-#if IS_ENABLED(CONFIG_IP6_NF_MANGLE)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	{
 		.name       = "TCPOPTSTRIP",
 		.family     = NFPROTO_IPV6,
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 65b965ca40ea..59b9d04400ca 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -48,7 +48,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 		.targetsize     = sizeof(struct xt_mark_tginfo2),
 		.me             = THIS_MODULE,
 	},
-#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
+#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES) || IS_ENABLED(CONFIG_NFT_COMPAT_ARP)
 	{
 		.name           = "MARK",
 		.revision       = 2,
-- 
2.30.2

