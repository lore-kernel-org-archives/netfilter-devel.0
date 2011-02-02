From: kaber@trash.net
Subject: [PATCH 21/26] IPVS: Remove ip_vs_sync_cleanup from section __exit
Date: Thu,  3 Feb 2011 00:11:59 +0100
Message-ID: <1296688324-7830-22-git-send-email-kaber@trash.net>
References: <1296688324-7830-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44725 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab1BBXMf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:12:35 -0500
In-Reply-To: <1296688324-7830-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Simon Horman <horms@verge.net.au>

ip_vs_sync_cleanup() may be called from ip_vs_init() on error
and thus needs to be accesible from section __init

Reporte-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
Tested-by: Hans Schillstrom <hans@schillstrom.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/ipvs/ip_vs_sync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index d5a6e64..2a2a836 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1686,7 +1686,7 @@ int __init ip_vs_sync_init(void)
 	return register_pernet_subsys(&ipvs_sync_ops);
 }
 
-void __exit ip_vs_sync_cleanup(void)
+void ip_vs_sync_cleanup(void)
 {
 	unregister_pernet_subsys(&ipvs_sync_ops);
 }
-- 
1.7.2.3

