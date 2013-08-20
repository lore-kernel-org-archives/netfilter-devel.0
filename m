From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/19] netfilter: connlabels: remove unneeded includes
Date: Tue, 20 Aug 2013 12:54:36 +0200
Message-ID: <1376996091-3964-5-git-send-email-pablo@netfilter.org>
References: <1376996091-3964-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1376996091-3964-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

leftovers from the (never merged) v1 patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_labels.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 355d2ef..bb53f12 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -8,12 +8,8 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/ctype.h>
 #include <linux/export.h>
-#include <linux/jhash.h>
-#include <linux/spinlock.h>
 #include <linux/types.h>
-#include <linux/slab.h>
 
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_labels.h>
-- 
1.7.10.4
