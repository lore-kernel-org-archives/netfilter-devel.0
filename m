From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 3/7] nf: increment and decrement functions for ipv4 defragmentation
 users counter
Date: Mon, 05 May 2014 16:56:03 +0400
Message-ID: <53678A63.5050100@parallels.com>
References: <20140503233908.GA6297@localhost> <cover.1399292146.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:22978 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932214AbaEEM5h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 08:57:37 -0400
In-Reply-To: <cover.1399292146.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 include/net/netfilter/ipv4/nf_defrag_ipv4.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_defrag_ipv4.h b/include/net/netfilter/ipv4/nf_defrag_ipv4.h
index f01ef20..2a433ba 100644
--- a/include/net/netfilter/ipv4/nf_defrag_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_defrag_ipv4.h
@@ -3,4 +3,17 @@
 
 void nf_defrag_ipv4_enable(void);
 
+static inline void inc_br_defrag_ipv4_users_count(struct net *net)
+{
+	if (atomic_inc_return(&net->br_defrag_ipv4_users_count) == 1)
+		pr_info("net %p: bridge ipv4 defragmentation is enabled\n",
+			net);
+}
+
+static inline void dec_br_defrag_ipv4_users_count(struct net *net)
+{
+	if (atomic_dec_and_test(&net->br_defrag_ipv4_users_count))
+		pr_info("net %p: bridge ipv4 defragmentation is disabled\n",
+			net);
+}
 #endif /* _NF_DEFRAG_IPV4_H */
-- 
1.7.5.4

