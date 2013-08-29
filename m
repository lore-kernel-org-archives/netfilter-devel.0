From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] netfilter: SYNPROXY core: fix warning in __nf_ct_ext_add_length()
Date: Thu, 29 Aug 2013 10:32:09 +0200
Message-ID: <1377765129-8490-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, mph@one.com,
	jesper.brouer@gmail.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50727 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab3H2IcL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Aug 2013 04:32:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With CONFIG_NETFILTER_DEBUG we get the following warning during SYNPROXY init:

[   80.558906] WARNING: CPU: 1 PID: 4833 at net/netfilter/nf_conntrack_extend.c:80 __nf_ct_ext_add_length+0x217/0x220 [nf_conntrack]()

The reason is that the conntrack template is set to confirmed before adding
the extension and it is invalid to add extensions to already confirmed
conntracks. Fix by adding the extensions before setting the conntrack to
confirmed.

Reported-by: Jesper Dangaard Brouer <jesper.brouer@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_synproxy_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index d23dc79..6fd967c 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -356,12 +356,12 @@ static int __net_init synproxy_net_init(struct net *net)
 		goto err1;
 	}
 
-	__set_bit(IPS_TEMPLATE_BIT, &ct->status);
-	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
 	if (!nfct_seqadj_ext_add(ct))
 		goto err2;
 	if (!nfct_synproxy_ext_add(ct))
 		goto err2;
+	__set_bit(IPS_TEMPLATE_BIT, &ct->status);
+	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
 
 	snet->tmpl = ct;
 
-- 
1.8.1.4

