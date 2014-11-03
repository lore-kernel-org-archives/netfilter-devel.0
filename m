From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] netfilter: nft_reject_bridge: fix missing declaration of
 csum_ipv6_magic
Date: Sun, 02 Nov 2014 22:11:08 -0500
Message-ID: <5456F24C.7040604@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbaKCDLa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Nov 2014 22:11:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit 523b929d544 (netfilter: nft_reject_bridge: don't use IP stack
to reject traffic) adds a use of csum_ipv6_magic but doesn't include
net/ip6_checksum.h. On architectures that don't define _HAVE_ARCH_IPV6_CSUM,
like ppc and s390x, we don't get the prototype declared and the build
fails.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 net/bridge/netfilter/nft_reject_bridge.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -18,6 +18,7 @@
 #include <net/netfilter/ipv6/nf_reject.h>
 #include <linux/ip.h>
 #include <net/ip.h>
+#include <net/ip6_checksum.h>
 #include <linux/netfilter_bridge.h>
 #include "../br_private.h"
 

-- 
Jeff Mahoney
SUSE Labs
