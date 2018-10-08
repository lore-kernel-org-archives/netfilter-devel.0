From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/31] netfilter: remove obsolete need_conntrack stub
Date: Tue,  9 Oct 2018 01:00:59 +0200
Message-ID: <20181008230125.2330-6-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

as of a0ae2562c6c4b27 ("netfilter: conntrack: remove l3proto
abstraction") there are no users anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_common.h | 3 ---
 net/netfilter/nf_conntrack_standalone.c       | 7 -------
 2 files changed, 10 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 03097fa70975..e142b2b5f1ea 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -19,7 +19,4 @@ struct ip_conntrack_stat {
 	unsigned int search_restart;
 };
 
-/* call to create an explicit dependency on nf_conntrack. */
-void need_conntrack(void);
-
 #endif /* _NF_CONNTRACK_COMMON_H */
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 13279f683da9..e3b329ebafd3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -720,10 +720,3 @@ static void __exit nf_conntrack_standalone_fini(void)
 
 module_init(nf_conntrack_standalone_init);
 module_exit(nf_conntrack_standalone_fini);
-
-/* Some modules need us, but don't depend directly on any symbol.
-   They should call this. */
-void need_conntrack(void)
-{
-}
-EXPORT_SYMBOL_GPL(need_conntrack);
-- 
2.11.0
