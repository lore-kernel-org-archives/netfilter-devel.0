From: pablo@netfilter.org
Subject: [PATCH 1/3] netfilter: xt_LOG: don't use xchg() for simple assignment
Date: Tue,  3 Apr 2012 11:50:56 +0200
Message-ID: <1333446658-2335-2-git-send-email-pablo@netfilter.org>
References: <1333446658-2335-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55616 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab2DCJvj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Apr 2012 05:51:39 -0400
In-Reply-To: <1333446658-2335-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Beulich <JBeulich@suse.com>

At least on ia64 the (bogus) use of xchg() here results in the compiler
warning about an unused expression result. As only an assignment is
intended here, convert it to such.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/xt_log.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/netfilter/xt_log.h b/include/net/netfilter/xt_log.h
index 7e1544e..9d9756c 100644
--- a/include/net/netfilter/xt_log.h
+++ b/include/net/netfilter/xt_log.h
@@ -47,7 +47,7 @@ static void sb_close(struct sbuff *m)
 	if (likely(m != &emergency))
 		kfree(m);
 	else {
-		xchg(&emergency_ptr, m);
+		emergency_ptr = m;
 		local_bh_enable();
 	}
 }
-- 
1.7.2.5

