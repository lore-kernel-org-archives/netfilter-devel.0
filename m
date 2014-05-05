From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 1/7] nf: added per net namespace ipv4 defragmentation users
 counter
Date: Mon, 05 May 2014 16:55:39 +0400
Message-ID: <53678A4B.90705@parallels.com>
References: <20140503233908.GA6297@localhost> <cover.1399292146.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:31898 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219AbaEEM5M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 May 2014 08:57:12 -0400
In-Reply-To: <cover.1399292146.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 include/net/net_namespace.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 5f9eb26..d82e4b2 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -113,6 +113,9 @@ struct net {
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	struct netns_nf_frag	nf_frag;
 #endif
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
+	atomic_t		br_defrag_ipv4_users_count;
+#endif
 	struct sock		*nfnl;
 	struct sock		*nfnl_stash;
 #endif
-- 
1.7.5.4

