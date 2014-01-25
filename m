From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netfilter: nf_tables: fix oops when deleting a chain with
 references
Date: Sat, 25 Jan 2014 08:04:07 +0000
Message-ID: <20140125080407.GA15949@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45397 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaAYIEL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jan 2014 03:04:11 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 780f57420cdac84eabec388868678ede19f7d682
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Jan 24 13:23:52 2014 +0000

    netfilter: nf_tables: fix oops when deleting a chain with references

    THe following commands trigger an oops:

    # nft -i
    nft> add table filter
    nft> add chain filter input { type filter hook input priority 0; }
    nft> add chain filter test 
    nft> add rule filter input jump test
    nft> delete chain filter test
    
    We need to check the chain use counter before allowing destruction since
    we might have references from sets or jump rules.
    
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=69341
    Reported-by: Matthew Ife <deleriux1@gmail.com>
    Tested-by: Matthew Ife <deleriux1@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 117bbaa..9ce3053 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1045,7 +1045,7 @@ static int nf_tables_delchain(struct sock *nlsk, struct sk_buff *skb,
 	if (IS_ERR(chain))
 		return PTR_ERR(chain);
 
-	if (!list_empty(&chain->rules))
+	if (!list_empty(&chain->rules) || chain->use > 0)
 		return -EBUSY;
 
 	list_del(&chain->list);
