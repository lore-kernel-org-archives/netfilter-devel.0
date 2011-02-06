From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] libxt_cluster: fix inversion in the cluster match
Date: Sun, 06 Feb 2011 21:40:15 +0100
Message-ID: <20110206204015.3401.51728.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43900 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab1BFUkW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:40:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In libxt_cluster.c, we use:

info->flags |= (1 << XT_CLUSTER_F_INV);

but we should use instead:

info->flags |= XT_CLUSTER_F_INV;

since the definition of XT_CLUSTER_F_INV is:

enum xt_cluster_flags {
        XT_CLUSTER_F_INV        = (1 << 0)
};

This fixes the inversion in the cluster match.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_cluster.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
index edc14d3..e1607d0 100644
--- a/extensions/libxt_cluster.c
+++ b/extensions/libxt_cluster.c
@@ -90,7 +90,7 @@ cluster_parse(int c, char **argv, int invert, unsigned int *flags,
 				      "`--cluster-local-node'", optarg);
 		}
 		if (invert)
-			info->flags |= (1 << XT_CLUSTER_F_INV);
+			info->flags |= XT_CLUSTER_F_INV;
 
 		info->node_mask = node_mask = (1 << (num - 1));
 		*flags |= 1 << c;
@@ -115,7 +115,7 @@ cluster_parse(int c, char **argv, int invert, unsigned int *flags,
 				      "`--cluster-local-node'", optarg);
 		}
 		if (invert)
-			info->flags |= (1 << XT_CLUSTER_F_INV);
+			info->flags |= XT_CLUSTER_F_INV;
 
 		info->node_mask = node_mask = num;
 		*flags |= 1 << c;

