From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/03: nf_conntrack_h323: fix memory leak in module initialization error path
Date: Tue, 17 Jun 2008 16:03:54 +0200 (MEST)
Message-ID: <20080617140353.1355.56759.sendpatchset@localhost.localdomain>
References: <20080617140351.1355.59710.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65213 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662AbYFQODz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:03:55 -0400
In-Reply-To: <20080617140351.1355.59710.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack_h323: fix memory leak in module initialization error path

Properly free h323_buffer when helper registration fails.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bed6cb858aec9a01eefee7fe4d3bfb7581da4863
tree 8e28d749ebef47da42f00b708b30c4df0e230363
parent 6a5696d1b52e24202682359b54775260fb4cbb54
author Patrick McHardy <kaber@trash.net> Tue, 17 Jun 2008 15:36:38 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 17 Jun 2008 15:36:38 +0200

 net/netfilter/nf_conntrack_h323_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 95da1a2..99e385d 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1799,6 +1799,7 @@ err3:
 err2:
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_q931[0]);
 err1:
+	kfree(h323_buffer);
 	return ret;
 }
 
