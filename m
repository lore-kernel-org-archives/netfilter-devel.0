Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FA3155A45;
	Mon, 29 Jan 2024 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706542305; cv=none; b=aiw2df9Da5NxclKbFjTigDICAimsGhDRp8SpnPZV/Esqd0M9aPahJeCOWumtAesoVBTkHnyDeRv8tXMoI2WJ5qND242ZAB9kTkjc+ecCi17X6DVCNd0oSiRy5ymA6ykkdhQYuSxD3CeSo+Z0dn89tYD0HvmaPsRpDztAnm+ZgA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706542305; c=relaxed/simple;
	bh=yCKnN89h3GjeQEzFuBHbviWCTxPpsN9xIg3fXEnNoQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1Pt2psi7x37YAdiM4q0CyHxzouvBUFX9jmfrDYCKTxn3B/hrglvyGHW9jdIrHKJ2deivvCeZkjt5ISDt6eYCd0DiPo3bIFTEP3WFbr+yhc6/nUrp9+z8HQj+JBs+lJjG+QB8hChJExfMZ1ffarTyvRwhifkpLH8e6DrxyWqrJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rUTbl-00023R-6t; Mon, 29 Jan 2024 16:31:37 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 9/9] netfilter: ebtables: allow xtables-nft only builds
Date: Mon, 29 Jan 2024 15:57:59 +0100
Message-ID: <20240129145807.8773-10-fw@strlen.de>
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

Same patch as previous one, but for ebtables.

To build a kernel that only supports ebtables-nft, the builtin tables
need to be disabled, i.e.:

CONFIG_BRIDGE_EBT_BROUTE=n
CONFIG_BRIDGE_EBT_T_FILTER=n
CONFIG_BRIDGE_EBT_T_NAT=n

The ebtables specific extensions can then be used nftables'
NFT_COMPAT interface.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/Kconfig  | 7 +++++++
 net/bridge/netfilter/Makefile | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 7f304a19ac1b..104c0125e32e 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -39,6 +39,10 @@ config NF_CONNTRACK_BRIDGE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+# old sockopt interface and eval loop
+config BRIDGE_NF_EBTABLES_LEGACY
+	tristate
+
 menuconfig BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
 	depends on BRIDGE && NETFILTER && NETFILTER_XTABLES
@@ -55,6 +59,7 @@ if BRIDGE_NF_EBTABLES
 #
 config BRIDGE_EBT_BROUTE
 	tristate "ebt: broute table support"
+	select BRIDGE_NF_EBTABLES_LEGACY
 	help
 	  The ebtables broute table is used to define rules that decide between
 	  bridging and routing frames, giving Linux the functionality of a
@@ -65,6 +70,7 @@ config BRIDGE_EBT_BROUTE
 
 config BRIDGE_EBT_T_FILTER
 	tristate "ebt: filter table support"
+	select BRIDGE_NF_EBTABLES_LEGACY
 	help
 	  The ebtables filter table is used to define frame filtering rules at
 	  local input, forwarding and local output. See the man page for
@@ -74,6 +80,7 @@ config BRIDGE_EBT_T_FILTER
 
 config BRIDGE_EBT_T_NAT
 	tristate "ebt: nat table support"
+	select BRIDGE_NF_EBTABLES_LEGACY
 	help
 	  The ebtables nat table is used to define rules that alter the MAC
 	  source address (MAC SNAT) or the MAC destination address (MAC DNAT).
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 1c9ce49ab651..b9a1303da977 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_NFT_BRIDGE_REJECT)  += nft_reject_bridge.o
 # connection tracking
 obj-$(CONFIG_NF_CONNTRACK_BRIDGE) += nf_conntrack_bridge.o
 
-obj-$(CONFIG_BRIDGE_NF_EBTABLES) += ebtables.o
+obj-$(CONFIG_BRIDGE_NF_EBTABLES_LEGACY) += ebtables.o
 
 # tables
 obj-$(CONFIG_BRIDGE_EBT_BROUTE) += ebtable_broute.o
-- 
2.43.0

