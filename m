Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC7F2882DC;
	Fri, 25 Jul 2025 17:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463048; cv=none; b=D/eQpWySvE6DCY4L5HVl90nsdgm201odoJQrE2xIUUQmEwxE4lqTcw/hqDEEVEarsI13bqAmxnDoG/U06PyQhgsD0E5jQ3J0mThyrm+dF2SzJp/yK5cSxE2kB5KhHy7HvR8OHT6z49uo7ZfZdgKtpt2MYomXMAYQPj4TZkLs/Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463048; c=relaxed/simple;
	bh=FZHImwrCAMDpuWr+ZUbUMfeCRAwFvKmWDrwNuAsoapo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XpvSpQO7FpW08odvgwg+B0kxRpOaegXBYMHkdAom8/Tz9nRu7ciHEFvZquJaqt3nCWj1tEPyhp0I+O+xO3jqxrXPvZ2xwL6K9kRZvsD9IYKtSOnBqn+UAPn7vGQQpDqiQV+PqRnJmu5+YMkp5kD8DQr2xf3dSp+uvkU+Nwxb2Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=O3afAxgP; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OY+u09zC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="O3afAxgP";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OY+u09zC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 399E260272; Fri, 25 Jul 2025 19:04:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463045;
	bh=j4FcbgSCoJPnXenfOHrItHFNyob2QHhZpKJ7plnJaeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3afAxgPHsEos4AvJhDbfjawDa1SGwDTPCIb3sB1MHg9Ws4unPCoyIt46Nc4vPCIZ
	 FLBQPQPGCB7FHsMykZFZNJpOAJcsAiUDwY1YORutEEdXrUEsiModgCHfbpyuSIhFVB
	 o6rDGjQbvXgarklBxqUEx67LoSZ01mdzVktAC0Gd7G6ZZB5pwsz41fC7mFOYYtbPdf
	 PFp5r/AHQZxCNud7KV3l33VGHW4ww2oSerf9BX32VPdZvxAKvl5CRBp6CtmfYCdGG6
	 vAljR+IgkCQuCCXqZr38StLd6BOYUF1AueyGHk7USUFcIJjd03ZysDONXsOm49KyaP
	 k0pNks9FDiByQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6306960272;
	Fri, 25 Jul 2025 19:03:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463040;
	bh=j4FcbgSCoJPnXenfOHrItHFNyob2QHhZpKJ7plnJaeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OY+u09zChU7DrAvwFeVdg1TZ62+sX1kW/zrRemO++vo4kgf9Hi118qbFK2AhYxLmb
	 DrME2TqHwAmoU2pihOHCIAFD0PhL7vGx2GOm526bl/vO1sC07wGctcdvrcEW6hevno
	 6A+vf6J/UaOPy2lNVIdhheda7W5ka9cE7ZT8ZG9H8sNrsdnX61XyRkt8DNjKd2A4CX
	 17Bnl4g7h/MwNNg6lWQ02hYxR2ye46U0MpNz6Io3+iCL7lTCy01wuTzJPnWg1KWtYz
	 EDnS84TyhY9ebpkSgwa9FJZw2dBO0/dKZD+Hcbk2hCT+YqMTJQDt8QdfdyJSboAOsH
	 P7Gi5vVDzK/cQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 07/19] selftests: net: Enable legacy netfilter legacy options.
Date: Fri, 25 Jul 2025 19:03:28 +0200
Message-Id: <20250725170340.21327-8-pablo@netfilter.org>
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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/bpf/config                   |  1 +
 tools/testing/selftests/hid/config.common            |  1 +
 tools/testing/selftests/net/config                   | 11 +++++++++++
 tools/testing/selftests/net/mptcp/config             |  2 ++
 tools/testing/selftests/net/netfilter/config         |  5 +++++
 tools/testing/selftests/wireguard/qemu/kernel.config |  4 ++++
 6 files changed, 24 insertions(+)

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
2.30.2

