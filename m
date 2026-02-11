Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11951352FBF
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 18:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770836230; cv=none; b=eJRBj1pqCeT7JBmjlL8qMDjp2wgLWkbGiIg8sbXvEl85WhWbpLH+nehI7/UdQS704+/v0Bst7U6VBD8HrLUp+XNKg45tK/IDJuyzmz82qRylru+L5E/9LrltzzpZlQR0SYQb+44uio0dl/dwIaBf/EzL4fqV4hRMADyjctBvnHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770836230; c=relaxed/simple;
	bh=1/r+aJxLMr4ObkcVf6S3RqCobL7EEf9fpwWUWzKeY5U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QQiQzWJ/EtmeHBFb/2I9EzjYgoip3z/WbNX9yYTEMPehDeRU57qUPfI+i4AP2EE/UpUBc30sg2x6FyICys9V/pcghNBpzPoNm47oAn0zdSdCWfnAJnTxPEcWiWFRxld08FygWL5QKXQmMq/Z9H/fKvoU/0HB24Gd+VVJScrQ57w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WcPRar1m; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WcPRar1m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZUMfQ659OAL8ErJmi+pc//4/mBzFJnht6AHuBBorQ1I=; b=WcPRar1mP2QPh3UQmO3Ck4AnD8
	gdjOGsKH2vTMCGz3ovBlYdQUpBqDyzEeNuAPUK23PhraxWTTnVcAG1CUCsiiAMgce1nCD1KUTR7uO
	KnwEjzhrhfkiSAhmJ8WC/jop/H7tVhBqWYxXaXW/syrH/KGl7sC8l0gZBhfZPJajbT9zPe75YS5s2
	0S6SU6ol1uECN5Lid2etYqK+aggHd1D/SqdqS0QFqd+KFPZSLghGDV72IoLh17vCL5ysHKadOW685
	VF4DdNWuXsCRE62skAL8y8CLi6Xbe7dFZczoboapks07iQt6Zy20LdDBvFMXZB9pcLCu2Ddybr4Wq
	b7HH+GUQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vqFOb-000000006ux-06NG;
	Wed, 11 Feb 2026 19:57:05 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Alyssa Ross <hi@alyssa.is>,
	Florian Westphal <fw@strlen.de>
Subject: [nf PATCH] include: uapi: netfilter_bridge.h: Cover for musl libc
Date: Wed, 11 Feb 2026 19:56:59 +0100
Message-ID: <20260211185659.26759-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Musl defines its own struct ethhdr and thus defines __UAPI_DEF_ETHHDR to
zero. To avoid struct redefinition errors, user space is therefore
supposed to include netinet/if_ether.h before (or instead of)
linux/if_ether.h. To relieve them from this burden, include the libc
header here if not building for kernel space.

Reported-by: Alyssa Ross <hi@alyssa.is>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter_bridge.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter_bridge.h b/include/uapi/linux/netfilter_bridge.h
index 1610fdbab98d..d4440e56da60 100644
--- a/include/uapi/linux/netfilter_bridge.h
+++ b/include/uapi/linux/netfilter_bridge.h
@@ -5,16 +5,17 @@
 /* bridge-specific defines for netfilter. 
  */
 
+#ifndef __KERNEL__
+#include <limits.h>		/* for INT_MIN, INT_MAX */
+#include <netinet/if_ether.h>	/* for __UAPI_DEF_ETHHDR if defined */
+#endif
+
 #include <linux/in.h>
 #include <linux/netfilter.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/if_pppox.h>
 
-#ifndef __KERNEL__
-#include <limits.h> /* for INT_MIN, INT_MAX */
-#endif
-
 /* Bridge Hooks */
 /* After promisc drops, checksum checks. */
 #define NF_BR_PRE_ROUTING	0
-- 
2.51.0

