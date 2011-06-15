From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] netfilter/ip_tables: fix compile with debug
Date: Wed, 15 Jun 2011 22:23:01 +0200
Message-ID: <1308169381-10067-1-git-send-email-sebastian@breakpoint.cc>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:34685 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab1FOUXg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:23:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 net/ipv4/netfilter/ip_tables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 7049150..96b16e8 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -571,7 +571,7 @@ check_entry(const struct ipt_entry *e, const char *name)
 	const struct xt_entry_target *t;
 
 	if (!ip_checkentry(&e->ip)) {
-		duprintf("ip check failed %p %s.\n", e, par->match->name);
+		duprintf("ip check failed %p %s.\n", e, name);
 		return -EINVAL;
 	}
 
-- 
1.7.4.4

