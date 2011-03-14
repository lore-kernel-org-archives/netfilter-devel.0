From: Simon Horman <horms@verge.net.au>
Subject: [PATCH 19/24] IPVS: ip_vs_todrop() becomes a noop when CONFIG_SYSCTL is undefined
Date: Mon, 14 Mar 2011 18:06:31 +0900
Message-ID: <1300093596-3824-20-git-send-email-horms@verge.net.au>
References: <1300093596-3824-1-git-send-email-horms@verge.net.au>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Julian Anastasov <ja@ssi.bg>,
	Hans Schillstrom <hans@schillstrom.com>,
	Simon Horman <horms@verge.net.au>
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, lvs-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:56665 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab1CNJGy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:06:54 -0400
In-Reply-To: <1300093596-3824-1-git-send-email-horms@verge.net.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Simon Horman <horms@verge.net.au>
---
 include/net/ip_vs.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 687ef18..77ebece 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1253,6 +1253,7 @@ extern int ip_vs_icmp_xmit_v6
  int offset);
 #endif
 
+#ifdef CONFIG_SYSCTL
 /*
  *	This is a simple mechanism to ignore packets when
  *	we are loaded. Just set ip_vs_drop_rate to 'n' and
@@ -1268,6 +1269,9 @@ static inline int ip_vs_todrop(struct netns_ipvs *ipvs)
 	ipvs->drop_counter = ipvs->drop_rate;
 	return 1;
 }
+#else
+static inline int ip_vs_todrop(struct netns_ipvs *ipvs) { return 0; }
+#endif
 
 /*
  *      ip_vs_fwd_tag returns the forwarding tag of the connection
-- 
1.7.2.3

