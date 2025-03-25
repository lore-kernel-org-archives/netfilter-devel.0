Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7F425EF90
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 16:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742921933; cv=none; b=rfaTzN0vCNZn+z7wxPmUhIUQQaX+uVJBQebojgxiTsgnpONPPvjvRrp4wwrDkRYc5z9RM/fa5WQQlqZxdNSLlpdkVEA5yoW17LefJ5Z9q3/P33jrcxeueiCmEgIrdbjbHnrYh7s0A+3v11EH7Sgg6Q0v54APNV/AGww0C1AIM/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742921933; c=relaxed/simple;
	bh=IiK4CXXX9i1tO4xSDZjLcOqcYuWamSnfGXNiKs89wok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8c4ONcHOsveb/YukECKBec+RQTxqcLts27tHB0r5hUQprgciCP29LNCs9mt7HxsofcdjrOMGlskfW46v1jNjKN5hDo+xZrB4Bg39W0gITwhQwjBQ5QG9pQqx2xi9/S4p569co1cpWG2fl+kenkMXpYquqDMKZM+HbFuSiJfN9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=p7xvDQXd; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Mpe04Thy; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="p7xvDQXd";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Mpe04Thy"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742921923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/QYRCSX3cmtWVsxGWKs9v5nQnvd8l6caTP0VXpZeadQ=;
	b=p7xvDQXddsT09+uRqAzpg9h4S94cT9xgTKKkN0WOvgLgroX3CUX3P5MWZBBpv7r31Bc4uj
	69rCViThaOoJbYzPzDVuNyrwdgHZBPZF78eFHjpUyy1PBQdIhH/RyRCa4xTJ+SKD2SfIPb
	nxaRy1snTdPCBNQ/mGruwUymnP/v6iniCV5r6L2ibkAR2pYMtxdDZ/ramWoFkfKoVBexpq
	g0NqwTIZ0VePo0rHX8dDY+cq5tv13sKYyX3qePzBOwbKYkIwDxXZlEv5f/FCOFweDUf95F
	WoxDabmzGdjqv6k62ov7WeAOlQl7Z/me3MsdRlZku1btbXxmMAxEfeUdMYGpzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742921923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/QYRCSX3cmtWVsxGWKs9v5nQnvd8l6caTP0VXpZeadQ=;
	b=Mpe04ThyaAnzL45QkeR1VCL/+K/z07Sdw4jt7vYajLVQefH0VGOK6KiOO5+WzqgccdROnv
	EOkogYp/nqkNXIAQ==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [net-next v3 3/3] netfilter: Introduce NETFILTER_LEGACY to group all legacy code.
Date: Tue, 25 Mar 2025 17:58:32 +0100
Message-ID: <20250325165832.3110004-4-bigeasy@linutronix.de>
In-Reply-To: <20250325165832.3110004-1-bigeasy@linutronix.de>
References: <20250325165832.3110004-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

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

Make EBTABLES_LEGACY, IPTABLES_LEGACY and ARPTABLES depend on
NETFILTER_LEGACY. Hide xt_recseq and its users, xt_register_table() and
xt_percpu_counter_alloc() behind NETFILTER_LEGACY. Let NETFILTER_LEGACY
depend on !PREEMPT_RT.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/Kconfig                  | 10 ++++++++++
 net/bridge/netfilter/Kconfig |  2 +-
 net/ipv4/netfilter/Kconfig   |  5 +++--
 net/ipv6/netfilter/Kconfig   |  2 +-
 net/netfilter/x_tables.c     | 16 +++++++++++-----
 5 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index c3fca69a7c834..e5d5bcafa0e18 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -211,6 +211,16 @@ menuconfig NETFILTER
=20
 if NETFILTER
=20
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
index a6770845d3aba..0080127421882 100644
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
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index a215f01d16a32..dcf015e0d4266 100644
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
index 9ab8ef510dcfa..303942174b5d5 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -9,7 +9,7 @@ menu "IPv6: Netfilter Configuration"
 # old sockopt interface and eval loop
 config IP6_NF_IPTABLES_LEGACY
 	tristate "Legacy IP6 tables support"
-	depends on INET && IPV6
+	depends on INET && IPV6 && NETFILTER_LEGACY
 	select NETFILTER_XTABLES
 	select IP6_NF_IPTABLES
 	default n
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 709840612f0df..24788bd3cbcb6 100644
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
=20
 #ifdef CONFIG_PROC_FS
 static void *xt_table_seq_start(struct seq_file *seq, loff_t *pos)
@@ -1897,6 +1899,7 @@ void xt_proto_fini(struct net *net, u_int8_t af)
 }
 EXPORT_SYMBOL_GPL(xt_proto_fini);
=20
+#ifdef CONFIG_NETFILTER_LEGACY
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
+	if (IS_ENABLED(CONFIG_NETFILTER_LEGACY)) {
+		for_each_possible_cpu(i) {
+			seqcount_init(&per_cpu(xt_recseq, i));
+		}
 	}
=20
 	xt =3D kcalloc(NFPROTO_NUMPROTO, sizeof(struct xt_af), GFP_KERNEL);
--=20
2.49.0

