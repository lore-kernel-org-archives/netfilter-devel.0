Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88872E3711;
	Wed, 30 Jul 2025 21:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753911944; cv=none; b=VceBGxtfqMXxv+mzneTfVc/PZf6osu7xcIfszF2lt9ZFOoLOBHc6t+GR6GpqeFGUyCYZYtCUdpMLX+dep5TYz99yjcp//YFE0K9EjOvJFhkVxsROyIF/c8zLPFSm0vRJ6p+2HhO97hpYL/cUQUFjB7eczlWpIZ81Qah+R4z7cg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753911944; c=relaxed/simple;
	bh=Y92YzVx0S6qzMTvUYIZsDyuNk7AZBf+dBkZeWeD2ETk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iNFJqNW1PybCpLxF3kUz9UHJnpdqrhjnXQaZhcBUzcaxsIZO4EaUgRH+FMFosVys2Daj5BM4M4AqB7wJgLOcuvLwxHL5SKBqlZnCZghtj7EKrg8erUIkZjG+ZRFm1GYAzMDNguHR00VMtaJGkxh0H9q2A4gq4ZvRYpZEvEazsMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ir5aMzbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ir5aMzbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8A3C4CEE3;
	Wed, 30 Jul 2025 21:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753911944;
	bh=Y92YzVx0S6qzMTvUYIZsDyuNk7AZBf+dBkZeWeD2ETk=;
	h=From:To:Cc:Subject:Date:From;
	b=Ir5aMzbGzMa/CQUN7Ury5S5+qORKlY61LlQcnpDusGKHVBBa8/iJKWiUsKgbrLACu
	 Ka9PuAsMHHuk9lslUGAI6PCkQX4Jz0E6PYIxucFgr3rzUkdc3K4ov3nZvDCPgVxCD1
	 Uc3QemOx2chhNr+8914HYMHm4u5gBIisFJ3s141DIeNU+PoO4/Rt/HcOvAeTNSqOgt
	 NxnZ/R6yjv5DFsb5jZvs3xcQcq31JsP8UldJUIeCyplXZ27q7HcR68QmzUm7qv/AFz
	 XwXa06h/BemjAJpoo59U/sDXDdvaNY5VEns5rco6WyeA9WIn10/J5OnesqXe3kc0ZP
	 GfhIX1EpYhAtA==
From: Arnd Bergmann <arnd@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Simon Horman <horms@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: add back NETFILTER_XTABLES dependencies
Date: Wed, 30 Jul 2025 23:45:32 +0200
Message-Id: <20250730214538.466973-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Some Kconfig symbols were changed to depend on the 'bool' symbol
NETFILTER_XTABLES_LEGACY, which means they can now be set to built-in
when the xtables code itself is in a loadable module:

x86_64-linux-ld: vmlinux.o: in function `arpt_unregister_table_pre_exit':
(.text+0x1831987): undefined reference to `xt_find_table'
x86_64-linux-ld: vmlinux.o: in function `get_info.constprop.0':
arp_tables.c:(.text+0x1831aab): undefined reference to `xt_request_find_table_lock'
x86_64-linux-ld: arp_tables.c:(.text+0x1831bea): undefined reference to `xt_table_unlock'
x86_64-linux-ld: vmlinux.o: in function `do_arpt_get_ctl':
arp_tables.c:(.text+0x183205d): undefined reference to `xt_find_table_lock'
x86_64-linux-ld: arp_tables.c:(.text+0x18320c1): undefined reference to `xt_table_unlock'
x86_64-linux-ld: arp_tables.c:(.text+0x183219a): undefined reference to `xt_recseq'

Change these to depend on both NETFILTER_XTABLES and
NETFILTER_XTABLES_LEGACY.

Fixes: 9fce66583f06 ("netfilter: Exclude LEGACY TABLES on PREEMPT_RT.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/bridge/netfilter/Kconfig | 1 +
 net/ipv4/netfilter/Kconfig   | 3 +++
 net/ipv6/netfilter/Kconfig   | 1 +
 3 files changed, 5 insertions(+)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 60f28e4fb5c0..4fd5a6ea26b4 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -43,6 +43,7 @@ config NF_CONNTRACK_BRIDGE
 config BRIDGE_NF_EBTABLES_LEGACY
 	tristate "Legacy EBTABLES support"
 	depends on BRIDGE && NETFILTER_XTABLES_LEGACY
+	depends on NETFILTER_XTABLES
 	default	n
 	help
 	 Legacy ebtables packet/frame classifier.
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 2c438b140e88..7dc9772fe2d8 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -14,6 +14,7 @@ config NF_DEFRAG_IPV4
 config IP_NF_IPTABLES_LEGACY
 	tristate "Legacy IP tables support"
 	depends on NETFILTER_XTABLES_LEGACY
+	depends on NETFILTER_XTABLES
 	default	m if NETFILTER_XTABLES_LEGACY
 	help
 	  iptables is a legacy packet classifier.
@@ -326,6 +327,7 @@ endif # IP_NF_IPTABLES
 config IP_NF_ARPTABLES
 	tristate "Legacy ARPTABLES support"
 	depends on NETFILTER_XTABLES_LEGACY
+	depends on NETFILTER_XTABLES
 	default	n
 	help
 	  arptables is a legacy packet classifier.
@@ -343,6 +345,7 @@ config IP_NF_ARPFILTER
 	select IP_NF_ARPTABLES
 	select NETFILTER_FAMILY_ARP
 	depends on NETFILTER_XTABLES_LEGACY
+	depends on NETFILTER_XTABLES
 	help
 	  ARP packet filtering defines a table `filter', which has a series of
 	  rules for simple ARP packet filtering at local input and
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 276860f65baa..81daf82ddc2d 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -10,6 +10,7 @@ menu "IPv6: Netfilter Configuration"
 config IP6_NF_IPTABLES_LEGACY
 	tristate "Legacy IP6 tables support"
 	depends on INET && IPV6 && NETFILTER_XTABLES_LEGACY
+	depends on NETFILTER_XTABLES
 	default	m if NETFILTER_XTABLES_LEGACY
 	help
 	  ip6tables is a legacy packet classifier.
-- 
2.39.5

