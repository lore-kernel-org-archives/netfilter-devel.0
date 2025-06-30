Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F3728ECE5
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2025 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751298274; cv=none; b=FfZ3HEygLSUxWl3dXHtnXes+OZmahhXKCRsT7jBTRPnXz+h2mB6pVrF0niBBr2XxH8SQBeT9mqsNOI+5GbJXLIz2qMGmxs5xFRXAkb110EW4kbiNcinO9Ucok/NvpGQ6YCJQbKeKxQ7DrWEyesOSpct2X+a/N+EEeTGeOP1sKOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751298274; c=relaxed/simple;
	bh=70wURr/Ubdv3tEOwKkgYiPWbu+9xkGyom2Gk25mUqSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqYfBcNRn1UUs0UQWU0vUsso9LOyb70PLuHtAv8qTD64rLjFSPB63i6S5MYelQJTb7t1f1Kp9cHWD1Qwzld7F72VTrFIoQIJgRlG3z4PAdZjxx1yrhtdJwNoMmDMfzeRqOronfn34oWv+rgn1JtEeY+UShlTOFvqSar1GJH1oEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=fhXnKaNn; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=gYZK1SiC; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="fhXnKaNn";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="gYZK1SiC"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1751298271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BqCBucMz1MGabuv7qMZXfGIO4C1Ltbl51CFA3XZH/S0=;
	b=fhXnKaNnORgA2II5eoUOmaE5ZEtnOIqULkxfRmh/5yYVIt5y7j0IKsatk2ABrrUDvTVU2B
	DwLS4Lt2tWmmz2psgWwg37rAcvLjw0HjirE+J8fNBrCYnincXaMMHB0xB/H0S+rrRJtg/M
	XVgqlSGCkGP4IJq4k1doqifUiYaFzE5yZp+C89y1tsw004oxi763nAtXQmmIl4dKH7OTlQ
	lCqlS3Gnt5yAz7nhHX3PUL6RkXbV4BqCq7zfvjaj5dJ2PwYsGjQS3hL5lydRljldFbd7E2
	6H7DRVYbNmF3eLo9wzyG6Z1ZPNT4TiVhLjGAuRea3AejWNsZ1S83UoS1Y4Ulig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1751298271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BqCBucMz1MGabuv7qMZXfGIO4C1Ltbl51CFA3XZH/S0=;
	b=gYZK1SiCFyxlZXZkLoeB6jBJCvrD5a/vMb7iB8uDDBJLrWp1fV9itTNa/WsTOlc+0CzwvH
	bX9htw2Aqach8OCQ==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v5 2/3] selftests: net: Enable legacy netfilter legacy options.
Date: Mon, 30 Jun 2025 17:44:24 +0200
Message-ID: <20250630154425.3830665-3-bigeasy@linutronix.de>
In-Reply-To: <20250630154425.3830665-1-bigeasy@linutronix.de>
References: <20250630154425.3830665-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Florian Westphal <fw@strlen.de>

Some specified options rely on NETFILTER_XTABLES_LEGACY to be enabled.
IP_NF_TARGET_TTL for instance depends on IP_NF_MANGLE which in turn
depends on IP_NF_IPTABLES_LEGACY -> NETFILTER_XTABLES_LEGACY.

Enable relevant iptables config options explicitly, this is needed
to avoid breakage when symbols related to iptables-legacy
will depend on NETFILTER_LEGACY resp. IP_TABLES_LEGACY.

This also means that the classic tables (Kernel modules) will
not be enabled by default, so enable them too.

Signed-off-by: Florian Westphal <fw@strlen.de>
[bigeasy: Split out the config bits from the main patch]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 tools/testing/selftests/bpf/config                   |  1 +
 tools/testing/selftests/hid/config.common            |  1 +
 tools/testing/selftests/net/config                   | 11 +++++++++++
 tools/testing/selftests/net/mptcp/config             |  2 ++
 tools/testing/selftests/net/netfilter/config         |  5 +++++
 tools/testing/selftests/wireguard/qemu/kernel.config |  4 ++++
 6 files changed, 24 insertions(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/b=
pf/config
index f74e1ea0ad3b6..5218367767337 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -97,6 +97,7 @@ CONFIG_NF_TABLES_NETDEV=3Dy
 CONFIG_NF_TABLES_IPV4=3Dy
 CONFIG_NF_TABLES_IPV6=3Dy
 CONFIG_NETFILTER_INGRESS=3Dy
+CONFIG_NETFILTER_XTABLES_LEGACY=3Dy
 CONFIG_NF_FLOW_TABLE=3Dy
 CONFIG_NF_FLOW_TABLE_INET=3Dy
 CONFIG_NETFILTER_NETLINK=3Dy
diff --git a/tools/testing/selftests/hid/config.common b/tools/testing/self=
tests/hid/config.common
index b1f40857307da..38c51158adf89 100644
--- a/tools/testing/selftests/hid/config.common
+++ b/tools/testing/selftests/hid/config.common
@@ -135,6 +135,7 @@ CONFIG_NET_EMATCH=3Dy
 CONFIG_NETFILTER_NETLINK_LOG=3Dy
 CONFIG_NETFILTER_NETLINK_QUEUE=3Dy
 CONFIG_NETFILTER_XTABLES=3Dy
+CONFIG_NETFILTER_XTABLES_LEGACY=3Dy
 CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=3Dy
 CONFIG_NETFILTER_XT_MATCH_BPF=3Dy
 CONFIG_NETFILTER_XT_MATCH_COMMENT=3Dy
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/n=
et/config
index 3cfef51538230..c24417d0047bb 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -30,16 +30,25 @@ CONFIG_NET_FOU=3Dy
 CONFIG_NET_FOU_IP_TUNNELS=3Dy
 CONFIG_NETFILTER=3Dy
 CONFIG_NETFILTER_ADVANCED=3Dy
+CONFIG_NETFILTER_XTABLES_LEGACY=3Dy
 CONFIG_NF_CONNTRACK=3Dm
 CONFIG_IPV6_MROUTE=3Dy
 CONFIG_IPV6_SIT=3Dy
 CONFIG_NF_NAT=3Dm
 CONFIG_IP6_NF_IPTABLES=3Dm
+CONFIG_IP6_NF_IPTABLES_LEGACY=3Dm
 CONFIG_IP_NF_IPTABLES=3Dm
+CONFIG_IP_NF_IPTABLES_LEGACY=3Dm
+CONFIG_IP6_NF_MANGLE=3Dm
+CONFIG_IP6_NF_FILTER=3Dm
 CONFIG_IP6_NF_NAT=3Dm
 CONFIG_IP6_NF_RAW=3Dm
+CONFIG_IP_NF_MANGLE=3Dm
+CONFIG_IP_NF_FILTER=3Dm
 CONFIG_IP_NF_NAT=3Dm
 CONFIG_IP_NF_RAW=3Dm
+CONFIG_IP_NF_TARGET_REJECT=3Dm
+CONFIG_IP6_NF_TARGET_REJECT=3Dm
 CONFIG_IP_NF_TARGET_TTL=3Dm
 CONFIG_IPV6_GRE=3Dm
 CONFIG_IPV6_SEG6_LWTUNNEL=3Dy
@@ -57,6 +66,8 @@ CONFIG_NF_TABLES_IPV6=3Dy
 CONFIG_NF_TABLES_IPV4=3Dy
 CONFIG_NFT_NAT=3Dm
 CONFIG_NETFILTER_XT_MATCH_LENGTH=3Dm
+CONFIG_NETFILTER_XT_TARGET_HL=3Dm
+CONFIG_NETFILTER_XT_NAT=3Dm
 CONFIG_NET_ACT_CSUM=3Dm
 CONFIG_NET_ACT_CT=3Dm
 CONFIG_NET_ACT_GACT=3Dm
diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selft=
ests/net/mptcp/config
index 4f80014cae494..968d440c03fe0 100644
--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -13,6 +13,7 @@ CONFIG_NETFILTER_NETLINK=3Dm
 CONFIG_NF_TABLES=3Dm
 CONFIG_NFT_COMPAT=3Dm
 CONFIG_NETFILTER_XTABLES=3Dm
+CONFIG_NETFILTER_XTABLES_LEGACY=3Dy
 CONFIG_NETFILTER_XT_MATCH_BPF=3Dm
 CONFIG_NETFILTER_XT_MATCH_LENGTH=3Dm
 CONFIG_NETFILTER_XT_MATCH_STATISTIC=3Dm
@@ -25,6 +26,7 @@ CONFIG_IP_MULTIPLE_TABLES=3Dy
 CONFIG_IP_NF_FILTER=3Dm
 CONFIG_IP_NF_MANGLE=3Dm
 CONFIG_IP_NF_TARGET_REJECT=3Dm
+CONFIG_IP6_NF_TARGET_REJECT=3Dm
 CONFIG_IPV6_MULTIPLE_TABLES=3Dy
 CONFIG_IP6_NF_FILTER=3Dm
 CONFIG_NET_ACT_CSUM=3Dm
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/s=
elftests/net/netfilter/config
index 363646f4fefec..c981d2a38ed68 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -1,6 +1,8 @@
 CONFIG_AUDIT=3Dy
 CONFIG_BPF_SYSCALL=3Dy
 CONFIG_BRIDGE=3Dm
+CONFIG_NETFILTER_XTABLES_LEGACY=3Dy
+CONFIG_BRIDGE_NF_EBTABLES_LEGACY=3Dm
 CONFIG_BRIDGE_EBT_BROUTE=3Dm
 CONFIG_BRIDGE_EBT_IP=3Dm
 CONFIG_BRIDGE_EBT_REDIRECT=3Dm
@@ -14,7 +16,10 @@ CONFIG_INET_ESP=3Dm
 CONFIG_IP_NF_MATCH_RPFILTER=3Dm
 CONFIG_IP6_NF_MATCH_RPFILTER=3Dm
 CONFIG_IP_NF_IPTABLES=3Dm
+CONFIG_IP_NF_IPTABLES_LEGACY=3Dm
 CONFIG_IP6_NF_IPTABLES=3Dm
+CONFIG_IP6_NF_IPTABLES_LEGACY=3Dm
+CONFIG_IP_NF_NAT=3Dm
 CONFIG_IP_NF_FILTER=3Dm
 CONFIG_IP6_NF_FILTER=3Dm
 CONFIG_IP_NF_RAW=3Dm
diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/t=
esting/selftests/wireguard/qemu/kernel.config
index f314d3789f175..0a5381717e9f4 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -16,9 +16,13 @@ CONFIG_NETFILTER_ADVANCED=3Dy
 CONFIG_NF_CONNTRACK=3Dy
 CONFIG_NF_NAT=3Dy
 CONFIG_NETFILTER_XTABLES=3Dy
+CONFIG_NETFILTER_XTABLES_LEGACY=3Dy
 CONFIG_NETFILTER_XT_NAT=3Dy
 CONFIG_NETFILTER_XT_MATCH_LENGTH=3Dy
 CONFIG_NETFILTER_XT_MARK=3Dy
+CONFIG_NETFILTER_XT_TARGET_MASQUERADE=3Dm
+CONFIG_IP_NF_TARGET_REJECT=3Dm
+CONFIG_IP6_NF_TARGET_REJECT=3Dm
 CONFIG_IP_NF_IPTABLES=3Dy
 CONFIG_IP_NF_FILTER=3Dy
 CONFIG_IP_NF_MANGLE=3Dy
--=20
2.50.0

