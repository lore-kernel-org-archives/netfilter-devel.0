Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B945C25DB17
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 16:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742921932; cv=none; b=kVbYSDQsYPumXYtkbhO1BJ6WlymqSR+HRbUb9rJtr8HxvfDzuiQdQ122ZjAF93pc/jGhtoQ/IJGcILy73Vg79u+DRnzyZLvfYU6bNmrJ9xwYGBc9ATAQAxtpdEeDGxZdYaUNnn4KW3MWpnGTUTh8VinwBI01beTD23ysuFdlXgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742921932; c=relaxed/simple;
	bh=uhjn6SDWDyjbRPsyhrNbquhNXBOuMDOySBn4+Y0bdq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khljG5ZBRGjZsObpqjSqPSksH4I4TtejOtCN4tUxCvcioJjb7E+vZoVwLl1S8hDnl1qTpZuTgBVJkiBufPFuBU7/01VMk+6myveWsOYF0p4400V6rM3gGx46izipONyMbG6N1K+dIUW3cimOX08wFSqHQSgP8DzQe28+vrMOe0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=NRI0VLd4; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=OnEKLIp/; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="NRI0VLd4";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="OnEKLIp/"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742921923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tS9pd5Di1/42NlDo6sa//h2hcK6mJlb0MQpBNhpSJ7A=;
	b=NRI0VLd4jH9jskPuzrckn2PlJbeaho++aPGC3EYEK/I/fzOWkVhQxn4fmi+mAaO83N6Mbc
	A1LiEU3ah0CtPtrOdkKljHDAJw64jH5Lkplh1gk9ktjyrNL+tmRXXhnj3MhYTVr2lE3yf3
	3SQVC7UeaKgSm8pYx1N9EAh/mhxAoSt/U8BeGWhIc9srIt+qYsMQLhKpFhlmAWXL0vp9G2
	vI76YP5Q484WVB2dcsAPcyqVOl1KbNX1TUjx9qpgNizu1W6Al5DYj/DaeiusgMJGTpUab2
	tYbsGiEgufyw0xLnlhFiiKrqfvXKUvVoEg9yBlcJG2V0gdKcH0tOcrdnC2DwXA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742921923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tS9pd5Di1/42NlDo6sa//h2hcK6mJlb0MQpBNhpSJ7A=;
	b=OnEKLIp/8qoEF/az4c4nLJbvdtb5ihA00bIa4JHvUsO54s4+0Mpyylc6vO1aoxmRoTpSzj
	xzuze6BM28amehBA==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [net-next v3 1/3] netfilter: replace select by depends on for IP{6}_NF_IPTABLES_LEGACY
Date: Tue, 25 Mar 2025 17:58:30 +0100
Message-ID: <20250325165832.3110004-2-bigeasy@linutronix.de>
In-Reply-To: <20250325165832.3110004-1-bigeasy@linutronix.de>
References: <20250325165832.3110004-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Pablo Neira Ayuso <pablo@netfilter.org>

Relax dependencies on iptables legacy, replace select by depends on,
this should cause no harm to existing kernel configs and users can still
toggle IP{6}_NF_IPTABLES_LEGACY in any case.

[fw: Replace depends on BRIDGE_NF_EBTABLES_LEGACY with select]

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/bridge/netfilter/Kconfig |  6 +++---
 net/ipv4/netfilter/Kconfig   | 10 +++++-----
 net/ipv6/netfilter/Kconfig   | 10 +++++-----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index f16bbbbb94817..a6770845d3aba 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
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
index ef8009281da5c..a215f01d16a32 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -183,7 +183,7 @@ config IP_NF_MATCH_TTL
 config IP_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=3Dn
-	select IP_NF_IPTABLES_LEGACY
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
@@ -264,7 +264,7 @@ endif # IP_NF_NAT
 config IP_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=3Dn
-	select IP_NF_IPTABLES_LEGACY
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
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index e087a8e97ba78..490200b7c2094 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -197,7 +197,7 @@ config IP6_NF_TARGET_HL
 config IP6_NF_FILTER
 	tristate "Packet filtering"
 	default m if NETFILTER_ADVANCED=3Dn
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	tristate
 	help
 	  Packet filtering defines a table `filter', which has a series of
@@ -234,7 +234,7 @@ config IP6_NF_TARGET_SYNPROXY
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
 	default m if NETFILTER_ADVANCED=3Dn
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -244,7 +244,7 @@ config IP6_NF_MANGLE
=20
 config IP6_NF_RAW
 	tristate  'raw table support (required for TRACE)'
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `raw' table to ip6tables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -258,7 +258,7 @@ config IP6_NF_SECURITY
 	tristate "Security table"
 	depends on SECURITY
 	depends on NETFILTER_ADVANCED
-	select IP6_NF_IPTABLES_LEGACY
+	depends on IP6_NF_IPTABLES_LEGACY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
@@ -269,8 +269,8 @@ config IP6_NF_NAT
 	tristate "ip6tables NAT support"
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
+	depends on IP6_NF_IPTABLES_LEGACY
 	select NF_NAT
-	select IP6_NF_IPTABLES_LEGACY
 	select NETFILTER_XT_NAT
 	help
 	  This enables the `nat' table in ip6tables. This allows masquerading,
--=20
2.49.0

