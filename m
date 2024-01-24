Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B145E1802E
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jan 2024 09:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706089852; cv=none; b=p3smoyrF9eun9cXfQ8xmG+trBJ2hmW9z3r1RZONSuPBr2B7c0FlxaTb8MBPW/ZqGojrSSX+xS/SWcV2Y4RajuM1/sG8m1x/w4dj3cZwtm3CqgifVHtiFgEgpWIQu4BJeOW2BY7FcUjAB79w5AkPFcLNWUABghsulZ4F13WId9ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706089852; c=relaxed/simple;
	bh=B6FSwj7Ilr3CGLudAcyjAGHVZHWtWdhfR0F7syGEll0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkP1fPusXoSKKJGcLIJUvG1ulw45OLZRJbSZQJCBW81AmxsCYiUCFMRSPvZ7OYqe3WO6DBbxFVjZmvaiiY1h9CSgeJka2u3uOzz+nOSCM/F7yWPpD2trunZIk17jHCClAXzgoMQcedSkc+RwpTbJRp/vpX9q8vFjGUQoWZPu2j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rSZu7-0007fh-1B; Wed, 24 Jan 2024 10:50:43 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: ebtables: add _LEGACY kconfig symbol
Date: Wed, 24 Jan 2024 10:21:12 +0100
Message-ID: <20240124092116.7396-2-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240124092116.7396-1-fw@strlen.de>
References: <20240124092116.7396-1-fw@strlen.de>
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

