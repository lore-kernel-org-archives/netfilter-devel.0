From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] netfilter: better wording for table-full message
Date: Tue, 23 Aug 2011 15:07:46 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108231507040.24849@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: hawk@diku.dk,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:39711 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1HWNHs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:07:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Like this?

parent ad146381889371c2d1b89b27d9dc70ae257fc1c8 (v3.1-rc2-2-gad14638)
commit 51b33b93d4c2e6c63afb177158f660fd17daf47c
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Aug 23 15:07:00 2011 +0200

netfilter: better wording for table-full message

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/nf_conntrack_core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f7af8b8..eb4be11 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -649,8 +649,9 @@ __nf_conntrack_alloc(struct net *net, u16 zone,
 			atomic_dec(&net->ct.count);
 			if (net_ratelimit())
 				printk(KERN_WARNING
-				       "nf_conntrack: table full, dropping"
-				       " packet.\n");
+				       "nf_conntrack: table full, no new "
+				       "CT created, packet will have "
+				       "classification INVALID.\n");
 			return ERR_PTR(-ENOMEM);
 		}
 	}
-- 
# Created with git-export-patch
