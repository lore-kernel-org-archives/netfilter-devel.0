Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E27215043;
	Thu,  7 Aug 2025 11:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754566213; cv=none; b=O0T1aGsjZnRobt+FDKXMI+AxnbXT8r7NhZPx/9GqUgpYfKH5lvdFzE8U+XM0eKhae8y7sQvlkCNku2nrkBxXzvCzs/1n7kr4VXgxxc4f2WGmeft1pni2D30oZtHyONw9BYCnCKt67Zo+SqWFZWN3PjAXArDP/kY+P7fu913XYXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754566213; c=relaxed/simple;
	bh=MuK7vrGfKQoudLiXllNFBYCMTUvIRV+FvSLkITFm6eM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=un73zSZ+htA8MRFraDp7PM/WAhqY/SXuxysa+r1iSFtPeSIv/4OYd1Fw8fg5YfdGH/fhbQcoJ34fJ50qZlJ9ed4ORdVuSZTrxy0w7ml3AMdqYSMYny6mlucVRPtNZTMfefVylG4BLhAni1tRcw7EDZcSjXfDfJgc42iDyoIT6eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=R9dCuLRo; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oy6d48mU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="R9dCuLRo";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oy6d48mU"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6E94E6082C; Thu,  7 Aug 2025 13:29:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566199;
	bh=uJD+bwDd7Uak9k7OjUF6j6YUaLGUVgo/SJfOJSW2ONc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9dCuLRotMZc+blHyf3Ueycmvmo+16kRFfsme0ltvTZNN80vbw6Ow6Kc/BICimXjV
	 jPilYJJVxpl7wy9cNfi1Jn+KTRorGMnCcvrxm4z8lyhIj71WPekAtO/u541O4MJfRF
	 auVDirYvou28alF/jOBccejqlLZ59BKgyIyClxsifQyMzpoAlammFLk+8nWX7/naDH
	 bfQqF0yslW9ctRthxVDXbicfjNPJyjmg8CH8au0pSo/XpT7sLdi1PF5nadAY9eTlHR
	 7OnUN3+DaTj9j6kHX1GEZOq1V3mT1hA+z18lX3gUJcvWBEXECer+Dy2xr+ZObmHpPR
	 HzZ26Jb65hXWw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1AD1660A53;
	Thu,  7 Aug 2025 13:29:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566195;
	bh=uJD+bwDd7Uak9k7OjUF6j6YUaLGUVgo/SJfOJSW2ONc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oy6d48mUghXOjIZvEhSmg4uPDjNyH1a8W95Q+QXBjeC3SE5368/1IAuy+sUa8RLFb
	 mTwkC3D3uZjoK7rkAiwvX6LdlHfldhi5nQN4fzjmTAAORoN0hNxYTLBMmKCp2XX9wp
	 jQVXkaNmhVSGRncgNPk0Xkbs2oGzpTQXVzOXcFAxQ3Qd/D8cp4BDqJuz7gXdrnZpLL
	 MNA6Zxhzljz8hdh5KB79oaLRGeDwwzUz6MYs/v3+TZzYJ8hkRbsYW4ZOgJjNp/FFng
	 lcnZoio9EHsPsoVEtWG//aWG/fUcIiZI1cU813UxSNtCOqkOvlzEWx1ceJgSu9RTCb
	 MfrxxinXd3JJw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 2/7] netfilter: add back NETFILTER_XTABLES dependencies
Date: Thu,  7 Aug 2025 13:29:43 +0200
Message-Id: <20250807112948.1400523-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250807112948.1400523-1-pablo@netfilter.org>
References: <20250807112948.1400523-1-pablo@netfilter.org>
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
Acked-by: Florian Westphal <fw@strlen.de>
Tested-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

