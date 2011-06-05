From: pablo@netfilter.org
Subject: [PATCH 11/20] netfilter: ipset: Fix return code for destroy when sets are in use
Date: Mon,  6 Jun 2011 01:09:01 +0200
Message-ID: <1307315350-17782-11-git-send-email-pablo@netfilter.org>
References: <1307315350-17782-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52218 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479Ab1FEXJl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 19:09:41 -0400
In-Reply-To: <1307315350-17782-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 8e2bced..4e33b19 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -776,7 +776,7 @@ ip_set_destroy(struct sock *ctnl, struct sk_buff *skb,
 	if (!attr[IPSET_ATTR_SETNAME]) {
 		for (i = 0; i < ip_set_max; i++) {
 			if (ip_set_list[i] != NULL && ip_set_list[i]->ref) {
-				ret = IPSET_ERR_BUSY;
+				ret = -IPSET_ERR_BUSY;
 				goto out;
 			}
 		}
-- 
1.7.2.5

