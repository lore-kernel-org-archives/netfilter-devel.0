From: Florian Westphal <fw@strlen.de>
Subject: [RFC PATCH 1/5] net: ipv4: export fib_table_lookup
Date: Mon, 12 Sep 2011 21:42:28 +0200
Message-ID: <1315856552-1422-2-git-send-email-fw@strlen.de>
References: <1315856552-1422-1-git-send-email-fw@strlen.de>
Cc: netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58596 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338Ab1ILTot (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 15:44:49 -0400
In-Reply-To: <1315856552-1422-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

modules using fib_lookup() fail to link when
CONFIG_IP_MULTIPLE_TABLES is not set.

The reason is that in this case fib_lookup is a static inline
helper that calls fib_table_lookup.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/fib_trie.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 58c25ea..e13eb24 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1606,6 +1606,7 @@ found:
 	rcu_read_unlock();
 	return ret;
 }
+EXPORT_SYMBOL_GPL(fib_table_lookup);
 
 /*
  * Remove the leaf and return parent.
-- 
1.7.3.4

