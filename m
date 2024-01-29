Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE04A153BD1;
	Mon, 29 Jan 2024 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706542299; cv=none; b=cCdbCQR5w/qAkByX3uNxKitwhfa94kyfktzd5DH7ipvC4bDhHpC8KyAQWRjnf05LPpUn0MOrtAm3+dkJtwxzrVQUXqxnOw9rvvsIdO2gQLwdpbpibr9SXGK5oqNBC19rjVEG1XJp8r07IgTqTLl7QIScMdLtBKY5ZNVcjJGN6cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706542299; c=relaxed/simple;
	bh=kDzMYZJO3VBean8rjfohcBafaM7iNNruiuCbVyC1zvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBTE+1Hi2jX3Ey4LiUhWhi2r23vEQ14xL33Hq6I4bSH4moeFy3N2gYpWZf0dItDTRG73klgcRk+LLhtZoyLpY89xBmb9rnh4RsMUepWhYytTdmV+4//HD4sdtJqXHIjtRt8V57ss8no3k7lfq7UGi/kNBC+gHaxQiqIWV4rpVHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rUTbf-00022O-If; Mon, 29 Jan 2024 16:31:31 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next 7/9] netfilter: arptables: allow xtables-nft only builds
Date: Mon, 29 Jan 2024 15:57:57 +0100
Message-ID: <20240129145807.8773-8-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129145807.8773-1-fw@strlen.de>
References: <20240129145807.8773-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allows to build kernel that supports the arptables mangle target
via nftables' compat infra but without the arptables get/setsockopt
interface or the old arptables filter interpreter.

IOW, setting IP_NF_ARPFILTER=n will break arptables-legacy, but
arptables-nft will continue to work as long as nftables compat
support is enabled.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Phil Sutter <phil@nwl.cc>
---
 net/ipv4/netfilter/Kconfig | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index f71a7e9a7de6..070475392236 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -309,36 +309,34 @@ endif # IP_NF_IPTABLES
 
 # ARP tables
 config IP_NF_ARPTABLES
-	tristate "ARP tables support"
-	select NETFILTER_XTABLES
-	select NETFILTER_FAMILY_ARP
-	depends on NETFILTER_ADVANCED
-	help
-	  arptables is a general, extensible packet identification framework.
-	  The ARP packet filtering and mangling (manipulation)subsystems
-	  use this: say Y or M here if you want to use either of those.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	tristate
 
-if IP_NF_ARPTABLES
+config NFT_COMPAT_ARP
+	tristate
+	depends on NF_TABLES_ARP && NFT_COMPAT
+	default m if NFT_COMPAT=m
+	default y if NFT_COMPAT=y
 
 config IP_NF_ARPFILTER
-	tristate "ARP packet filtering"
+	tristate "arptables-legacy packet filtering support"
+	select IP_NF_ARPTABLES
 	help
 	  ARP packet filtering defines a table `filter', which has a series of
 	  rules for simple ARP packet filtering at local input and
-	  local output.  On a bridge, you can also specify filtering rules
-	  for forwarded ARP packets. See the man page for arptables(8).
+	  local output.  This is only needed for arptables-legacy(8).
+	  Neither arptables-nft nor nftables need this to work.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_ARP_MANGLE
 	tristate "ARP payload mangling"
+	depends on IP_NF_ARPTABLES || NFT_COMPAT_ARP
 	help
 	  Allows altering the ARP packet payload: source and destination
 	  hardware and network addresses.
 
-endif # IP_NF_ARPTABLES
+	  This option is needed by both arptables-legacy and arptables-nft.
+	  It is not used by nftables.
 
 endmenu
 
-- 
2.43.0

