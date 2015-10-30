From: Loganaden Velvindron <logan@elandsys.com>
Subject: [PATCH 1/1 net-next] net: bridge: netfilter: use vzalloc() instead
 of vmalloc() for counterstmp
Date: Fri, 30 Oct 2015 05:33:03 -0700
Message-ID: <20151030123303.GA19481@mx.elandsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.qubic.net ([208.69.177.116]:52365 "EHLO mx.elandsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758415AbbJ3NAB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Oct 2015 09:00:01 -0400
Received: from mx.elandsys.com (IDENT:logan@localhost [127.0.0.1])
	by mx.elandsys.com (8.14.5/8.14.5) with ESMTP id t9UCX3b9002056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2015 05:33:03 -0700 (PDT)
Received: (from logan@localhost)
	by mx.elandsys.com (8.14.5/8.14.5/Submit) id t9UCX3Zj025017
	for netfilter-devel@vger.kernel.org; Fri, 30 Oct 2015 05:33:03 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

counterstmp is not cleared before it is used in get_counters(). it might be 
leaked partially when it is sent to userland later on.

Signed-off-by: Loganaden Velvindron <logan@elandsys.com>
---
 net/bridge/netfilter/ebtables.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index f46ca41..26922e9 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -989,7 +989,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	   the check on the size is done later, when we have the lock */
 	if (repl->num_counters) {
 		unsigned long size = repl->num_counters * sizeof(*counterstmp);
-		counterstmp = vmalloc(size);
+		counterstmp = vzalloc(size);
 		if (!counterstmp)
 			return -ENOMEM;
 	}
@@ -1410,7 +1410,7 @@ static int copy_counters_to_user(struct ebt_table *t,
 		return -EINVAL;
 	}
 
-	counterstmp = vmalloc(nentries * sizeof(*counterstmp));
+	counterstmp = vzalloc(nentries * sizeof(*counterstmp));
 	if (!counterstmp)
 		return -ENOMEM;
 
-- 
2.6.1
