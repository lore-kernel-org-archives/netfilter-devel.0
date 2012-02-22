From: Tony Zelenoff <antonz@parallels.com>
Subject: [PATCH 1/3] net/netfilter: whitespace removed
Date: Wed, 22 Feb 2012 10:47:59 +0400
Message-ID: <1329893281-508699-2-git-send-email-antonz@parallels.com>
References: <1329893281-508699-1-git-send-email-antonz@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <antonz@parallels.com>, <pablo@netfilter.org>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:54946 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab2BVHAx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Feb 2012 02:00:53 -0500
In-Reply-To: <1329893281-508699-1-git-send-email-antonz@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tony Zelenoff <antonz@parallels.com>
---
 net/netfilter/nf_conntrack_ecache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 14af632..aa15977 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -70,7 +70,7 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct)
 			else
 				e->missed &= ~missed;
 			spin_unlock_bh(&ct->lock);
-		} 
+		}
 	}
 
 out_unlock:
-- 
1.7.1

