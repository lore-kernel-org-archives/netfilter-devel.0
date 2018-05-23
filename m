From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/18] netfilter: nf_tables: remove nft_af_info.
Date: Wed, 23 May 2018 20:42:54 +0200
Message-ID: <20180523184254.22599-19-pablo@netfilter.org>
References: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

The struct nft_af_info was removed.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netns/nftables.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 48134353411d..29c3851b486a 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -4,8 +4,6 @@
 
 #include <linux/list.h>
 
-struct nft_af_info;
-
 struct netns_nftables {
 	struct list_head	tables;
 	struct list_head	commit_list;
-- 
2.11.0
