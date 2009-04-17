From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: nfnetlink: return ENOMEM if we fail to create
	netlink socket
Date: Fri, 17 Apr 2009 11:05:48 +0200
Message-ID: <20090417090548.11291.94506.stgit@Decadence>
References: <20090417090010.11291.31173.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48610 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbZDQJF6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:05:58 -0400
In-Reply-To: <20090417090010.11291.31173.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With this patch, nfnetlink returns -ENOMEM instead of -EPERM if we
fail to create the nfnetlink netlink socket during the module
loading. This is exactly what rtnetlink does in this case.

Ideally, it would be better if we propagate the error that has
happened in netlink_kernel_create(), however, this function still
does not implement this yet.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/netfilter/nfnetlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 2785d66..b8ab37a 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -203,7 +203,7 @@ static int __init nfnetlink_init(void)
 				     nfnetlink_rcv, NULL, THIS_MODULE);
 	if (!nfnl) {
 		printk(KERN_ERR "cannot initialize nfnetlink!\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	return 0;

