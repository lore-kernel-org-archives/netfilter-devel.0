Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799892E2650
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Jun 2025 14:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751033852; cv=none; b=lJ14+DJJSgIz5hJi2FzViXSQ8/PyqTUS0l2dwEowGcYD7vvqzCbh+7wCQVW2VpyK6ddGxlg0cSbf2ZCzEty9yXXJW6G/7iCign2QyNhnPn7Sy7zXUofbVADWJZW2+mebUUszlRNnvJpD5ubtdxlTc6fRdFFb9rKP/blNUooBYEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751033852; c=relaxed/simple;
	bh=pWd90Km9d/P2z3MBddPIk8mdVJmloqzmZ8xhu3cAXGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0X9wL2FxSTOI/mUrgw7lNEY5jLfLg8zKh10gB+TZY+nEdYBKkxqJIBxFV4UrKfzJG8RcFvBIdbIWtvHXNHILTSwaT5un1BG95BqHblTf1/pAbES1AuTF/CCnFBRmI1r+o9adyxzqi6FSwkFh76u1RtG4xHNqdV/ZGl7mj0sR7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4C22E608B7; Fri, 27 Jun 2025 16:17:20 +0200 (CEST)
Date: Fri, 27 Jun 2025 16:17:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Message-ID: <aF6n762WP1U-sLph@strlen.de>
References: <20250404152815.LilZda0r@linutronix.de>
 <Z_5335rrIYsyVq6E@calendula>
 <20250613125052.SdD-4SPS@linutronix.de>
 <aExEJSKtc4sq1MHf@strlen.de>
 <20250627105818._VVB4weS@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2R1kzpayuodCk+KK"
Content-Disposition: inline
In-Reply-To: <20250627105818._VVB4weS@linutronix.de>


--2R1kzpayuodCk+KK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> > A small subset of this patch has been upstreamed
> > c38eb2973c18 ("netfilter: xtables: support arpt_mark and ipv6 optstrip for iptables-nft only builds").
> > 
> > My plan was to zap some of the backwards-compat kconfig
> > knobs that we have and update various selftest config files,
> > then rebase this and retry.
> 
> Anything that I can help with?

So some of the problems with CI pipelines are caused by 'config'
settings having something like:

IP_NF_TARGET_TTL=m

... but if you look at net/ipv4/netfilter/Kconfig this is:
config IP_NF_TARGET_TTL
        tristate '"TTL" target support'
        depends on NETFILTER_ADVANCED && IP_NF_MANGLE
        select NETFILTER_XT_TARGET_HL
        help
        This is a backwards-compatible option for the user's convenience
        (e.g. when running oldconfig). It selects
        CONFIG_NETFILTER_XT_TARGET_HL.

... and that doesn't do anything anymore due to IP_NF_MANGLE dependency
(thats a legacy thing, so it will be off).

So my plan was to zap those old backwards hints first and update
the configs to make sure none of the old symbols remain.

OTOH one could just add the correct config settings.

I need to re-test but the attached updated patch should not omit any
of the required features even with legacy=n at least for the net ci.

I suspect that it would make sense to split the config tweaks into
a distinct patch, however.

If you have cycles please feel free to work on it, I can most likey
not get back to it until 2nd week of July.

--2R1kzpayuodCk+KK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-netfilter-Exclude-LEGACY-TABLES-on-PREEMPT_RT.patch"

From be2d4190d7935d3cecec04e76f93fb01f745c32e Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 4 Apr 2025 17:28:15 +0200
Subject: [PATCH 1/1] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.

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

Regarding selftests, prepare for non-default IP_TABLES_LEGACY.

Enable relevant iptables config options explicitly, this is needed
to avoid breakage when symbols related to iptables-legacy
will depend on NETFILTER_LEGACY resp. IP_TABLES_LEGACY.

This also means that the classic tables (Kernel modules) will
not be enabled by default, so enable them too.

Co-developed-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/Kconfig                  | 10 ++++----
 net/ipv4/netfilter/Kconfig                    | 24 +++++++++----------
 net/ipv6/netfilter/Kconfig                    | 19 +++++++--------
 net/netfilter/Kconfig                         | 10 ++++++++
 net/netfilter/x_tables.c                      | 16 +++++++++----
 tools/testing/selftests/bpf/config            |  1 +
 tools/testing/selftests/hid/config.common     |  1 +
 tools/testing/selftests/net/config            | 11 +++++++++
 tools/testing/selftests/net/mptcp/config      |  2 ++
 tools/testing/selftests/net/netfilter/config  |  5 ++++
 .../selftests/wireguard/qemu/kernel.config    |  4 ++++
 11 files changed, 71 insertions(+), 32 deletions(-)

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
index 2560416218d0..fe114607234e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -762,6 +762,16 @@ config NETFILTER_XTABLES_COMPAT
 
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
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index f74e1ea0ad3b..521836776733 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -97,6 +97,7 @@ CONFIG_NF_TABLES_NETDEV=y
 CONFIG_NF_TABLES_IPV4=y
 CONFIG_NF_TABLES_IPV6=y
 CONFIG_NETFILTER_INGRESS=y
+CONFIG_NETFILTER_XTABLES_LEGACY=y
 CONFIG_NF_FLOW_TABLE=y
 CONFIG_NF_FLOW_TABLE_INET=y
 CONFIG_NETFILTER_NETLINK=y
diff --git a/tools/testing/selftests/hid/config.common b/tools/testing/selftests/hid/config.common
index b1f40857307d..38c51158adf8 100644
--- a/tools/testing/selftests/hid/config.common
+++ b/tools/testing/selftests/hid/config.common
@@ -135,6 +135,7 @@ CONFIG_NET_EMATCH=y
 CONFIG_NETFILTER_NETLINK_LOG=y
 CONFIG_NETFILTER_NETLINK_QUEUE=y
 CONFIG_NETFILTER_XTABLES=y
+CONFIG_NETFILTER_XTABLES_LEGACY=y
 CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
 CONFIG_NETFILTER_XT_MATCH_BPF=y
 CONFIG_NETFILTER_XT_MATCH_COMMENT=y
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 3cfef5153823..c24417d0047b 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -30,16 +30,25 @@ CONFIG_NET_FOU=y
 CONFIG_NET_FOU_IP_TUNNELS=y
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
+CONFIG_NETFILTER_XTABLES_LEGACY=y
 CONFIG_NF_CONNTRACK=m
 CONFIG_IPV6_MROUTE=y
 CONFIG_IPV6_SIT=y
 CONFIG_NF_NAT=m
 CONFIG_IP6_NF_IPTABLES=m
+CONFIG_IP6_NF_IPTABLES_LEGACY=m
 CONFIG_IP_NF_IPTABLES=m
+CONFIG_IP_NF_IPTABLES_LEGACY=m
+CONFIG_IP6_NF_MANGLE=m
+CONFIG_IP6_NF_FILTER=m
 CONFIG_IP6_NF_NAT=m
 CONFIG_IP6_NF_RAW=m
+CONFIG_IP_NF_MANGLE=m
+CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_NAT=m
 CONFIG_IP_NF_RAW=m
+CONFIG_IP_NF_TARGET_REJECT=m
+CONFIG_IP6_NF_TARGET_REJECT=m
 CONFIG_IP_NF_TARGET_TTL=m
 CONFIG_IPV6_GRE=m
 CONFIG_IPV6_SEG6_LWTUNNEL=y
@@ -57,6 +66,8 @@ CONFIG_NF_TABLES_IPV6=y
 CONFIG_NF_TABLES_IPV4=y
 CONFIG_NFT_NAT=m
 CONFIG_NETFILTER_XT_MATCH_LENGTH=m
+CONFIG_NETFILTER_XT_TARGET_HL=m
+CONFIG_NETFILTER_XT_NAT=m
 CONFIG_NET_ACT_CSUM=m
 CONFIG_NET_ACT_CT=m
 CONFIG_NET_ACT_GACT=m
diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
index 4f80014cae49..968d440c03fe 100644
--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -13,6 +13,7 @@ CONFIG_NETFILTER_NETLINK=m
 CONFIG_NF_TABLES=m
 CONFIG_NFT_COMPAT=m
 CONFIG_NETFILTER_XTABLES=m
+CONFIG_NETFILTER_XTABLES_LEGACY=y
 CONFIG_NETFILTER_XT_MATCH_BPF=m
 CONFIG_NETFILTER_XT_MATCH_LENGTH=m
 CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
@@ -25,6 +26,7 @@ CONFIG_IP_MULTIPLE_TABLES=y
 CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_MANGLE=m
 CONFIG_IP_NF_TARGET_REJECT=m
+CONFIG_IP6_NF_TARGET_REJECT=m
 CONFIG_IPV6_MULTIPLE_TABLES=y
 CONFIG_IP6_NF_FILTER=m
 CONFIG_NET_ACT_CSUM=m
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 363646f4fefe..c981d2a38ed6 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -1,6 +1,8 @@
 CONFIG_AUDIT=y
 CONFIG_BPF_SYSCALL=y
 CONFIG_BRIDGE=m
+CONFIG_NETFILTER_XTABLES_LEGACY=y
+CONFIG_BRIDGE_NF_EBTABLES_LEGACY=m
 CONFIG_BRIDGE_EBT_BROUTE=m
 CONFIG_BRIDGE_EBT_IP=m
 CONFIG_BRIDGE_EBT_REDIRECT=m
@@ -14,7 +16,10 @@ CONFIG_INET_ESP=m
 CONFIG_IP_NF_MATCH_RPFILTER=m
 CONFIG_IP6_NF_MATCH_RPFILTER=m
 CONFIG_IP_NF_IPTABLES=m
+CONFIG_IP_NF_IPTABLES_LEGACY=m
 CONFIG_IP6_NF_IPTABLES=m
+CONFIG_IP6_NF_IPTABLES_LEGACY=m
+CONFIG_IP_NF_NAT=m
 CONFIG_IP_NF_FILTER=m
 CONFIG_IP6_NF_FILTER=m
 CONFIG_IP_NF_RAW=m
diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index f314d3789f17..0a5381717e9f 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -16,9 +16,13 @@ CONFIG_NETFILTER_ADVANCED=y
 CONFIG_NF_CONNTRACK=y
 CONFIG_NF_NAT=y
 CONFIG_NETFILTER_XTABLES=y
+CONFIG_NETFILTER_XTABLES_LEGACY=y
 CONFIG_NETFILTER_XT_NAT=y
 CONFIG_NETFILTER_XT_MATCH_LENGTH=y
 CONFIG_NETFILTER_XT_MARK=y
+CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
+CONFIG_IP_NF_TARGET_REJECT=m
+CONFIG_IP6_NF_TARGET_REJECT=m
 CONFIG_IP_NF_IPTABLES=y
 CONFIG_IP_NF_FILTER=y
 CONFIG_IP_NF_MANGLE=y
-- 
2.49.0


--2R1kzpayuodCk+KK--
