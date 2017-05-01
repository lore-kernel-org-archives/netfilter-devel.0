From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 18/53] netfilter: nf_tables: remove double return statement
Date: Mon,  1 May 2017 12:46:45 +0200
Message-ID: <1493635640-24325-19-git-send-email-pablo@netfilter.org>
References: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S378863AbdEAKry (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 06:47:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 265931F4B9E
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:47:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1705CDA87A
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:47:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F7C6FF2C1
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:47:42 +0200 (CEST)
In-Reply-To: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Aaron Conole <aconole@bytheb.org>

Signed-off-by: Aaron Conole <aconole@bytheb.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 22e191ad4468..91e9191a43d8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4433,8 +4433,6 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 err:
 	kfree_skb(skb2);
 	return err;
-
-	return 0;
 }
 
 static void nft_obj_destroy(struct nft_object *obj)
-- 
2.1.4

