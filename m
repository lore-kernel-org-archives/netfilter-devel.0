Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07B2133299
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 13:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707227996; cv=none; b=gpkbOGLzdlYdGErihM9jJsm1oyKsFCu4SPIq6xzBCvHjtqNMN8AgNKJs5OJefMTG4l36kkNXf4czl35b5yotPK3KG2JtQo1KaP3W7yoREbEQmYtqQHW2X2/QG6pgUeoEfysvQ5mCBuGq3J2GsNKC3zpgfojZL3uOADBAzlq95K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707227996; c=relaxed/simple;
	bh=/ljjYEnjWP3RG0KzVt0xUdUiWakpnfYdBKje54/ADqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZncI2xbizaL5Q3AtazQEWMOmfm1mfFHAGIccuE1034EEdsb5IFX6g6b4A8gzigeb5nx+o7fmuiEkC9cOgdwU8F4K8ueEH2DJv0XbP+O3Y4jydFg53fMR+HM5f8Q+jmPHQkWZBgj4Gt5A37g496xa/pt3e30WafILesp+7+I6tdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rXLzK-0002la-Aa; Tue, 06 Feb 2024 14:59:50 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	kernel test robot <lkp@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH nf-next] netfilter: xtables: fix up kconfig dependencies
Date: Tue,  6 Feb 2024 14:55:53 +0100
Message-ID: <20240206135556.11088-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Randy Dunlapt reports arptables build failure:
arp_tables.c:(.text+0x20): undefined reference to `xt_find_table'

... because recent change removed a 'select' on the xtables core.
Add a "depends" clause on arptables to resolve this.

Kernel test robot reports another build breakage:
iptable_nat.c:(.text+0x8): undefined reference to `ipt_unregister_table_exit'

... because of a typo, the nat table selected ip6tables.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: a9525c7f6219 ("netfilter: xtables: allow xtables-nft only builds")
Fixes: 4654467dc7e1 ("netfilter: arptables: allow xtables-nft only builds")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 783523087281..8f6e950163a7 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -217,7 +217,7 @@ config IP_NF_NAT
 	default m if NETFILTER_ADVANCED=n
 	select NF_NAT
 	select NETFILTER_XT_NAT
-	select IP6_NF_IPTABLES_LEGACY
+	select IP_NF_IPTABLES_LEGACY
 	help
 	  This enables the `nat' table in iptables. This allows masquerading,
 	  port forwarding and other forms of full Network Address Port
@@ -329,6 +329,7 @@ config NFT_COMPAT_ARP
 config IP_NF_ARPFILTER
 	tristate "arptables-legacy packet filtering support"
 	select IP_NF_ARPTABLES
+	depends on NETFILTER_XTABLES
 	help
 	  ARP packet filtering defines a table `filter', which has a series of
 	  rules for simple ARP packet filtering at local input and
-- 
2.43.0

