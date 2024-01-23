Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31D5634F6
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2024 15:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706024581; cv=none; b=nVp+l2K45def4hEkGmdiefsseC6Bk33FeodsT9y5ZmTIgteFo3paaY58ONE1KVguZWViPy/YLYE8CQuWByQx7unX1Ljh2J+8C/IVxt0V+CUNDTVvGpOde475Ixu35Xz0fm8caw4jKLwlAriYUJmmsyeRM2x9C391onD356qlyPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706024581; c=relaxed/simple;
	bh=EUvNczybtAhdsBGCZoJ97taG5qzCKYl8rLYbnHZu9s0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KVcZVsW7tOgEsoMe4zdOBsDE4yJt+2X0uOSV90YoC96TOfyOPSJJ0qGhPm61mareIJuE8UBfRViJUw91/3Cby+I2DMJF1E8wOquDlSRtBxcabskObuRz3fX5Kq+E/vBRdin+9ez4oM0nXtx+SHQy8jK340kHl2JjfMa5IMNn5E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rSIvR-0001NM-2j; Tue, 23 Jan 2024 16:42:57 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: arptables: allow arptables-nft only builds
Date: Tue, 23 Jan 2024 16:42:48 +0100
Message-ID: <20240123154252.12834-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
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

