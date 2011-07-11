From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 3/3] netfilter: ipset: Fix compiler warnings "'hash_ip4_data_next' declared inline after being called"
Date: Mon, 11 Jul 2011 11:52:55 +0200
Message-ID: <1310377975-993-4-git-send-email-kadlec@blackhole.kfki.hu>
References: <1310377975-993-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1310377975-993-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1310377975-993-3-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Chris Friesen <chris.friesen@genband.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:49710 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab1GKJw5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:52:57 -0400
In-Reply-To: <1310377975-993-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Chris Friesen <chris.friesen@genband.com>

Some gcc versions warn about prototypes without "inline" when the declaration
includes the "inline" keyword. The fix generates a false error message
"marked inline, but without a definition" with sparse below 0.4.2.

Signed-off-by: Chris Friesen <chris.friesen@genband.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set_ahash.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_ahash.h b/include/linux/netfilter/ipset/ip_set_ahash.h
index 1e7f759..b89fb79 100644
--- a/include/linux/netfilter/ipset/ip_set_ahash.h
+++ b/include/linux/netfilter/ipset/ip_set_ahash.h
@@ -392,7 +392,7 @@ retry:
 	return 0;
 }
 
-static void
+static inline void
 type_pf_data_next(struct ip_set_hash *h, const struct type_pf_elem *d);
 
 /* Add an element to a hash and update the internal counters when succeeded,
-- 
1.7.0.4

