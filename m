From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH 1/3] nfnetlink: Check callbacks before using those in nfnetlink_rcv_msg
Date: Thu, 28 Jun 2012 15:57:47 +0300
Message-ID: <1340888269-4926-2-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1340888269-4926-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4181 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab2F1M6D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:58:03 -0400
In-Reply-To: <1340888269-4926-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nfnetlink_rcv_msg() might call a NULL callback which will cause NULL pointer
dereference.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 net/netfilter/nfnetlink.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 3e797d1..4acdd76 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -184,9 +184,11 @@ replay:
 					lockdep_is_held(&nfnl_mutex)) != ss ||
 			    nfnetlink_find_client(type, ss) != nc)
 				err = -EAGAIN;
-			else
+			else if (nc->call)
 				err = nc->call(net->nfnl, skb, nlh,
 						   (const struct nlattr **)cda);
+			else
+				err = -EINVAL;
 			nfnl_unlock();
 		}
 		if (err == -EAGAIN)
-- 
1.7.8.6

