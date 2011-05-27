From: pablo@netfilter.org
Subject: [PATCH 3/5] netfilter: ipset: fix ip_set_flush return code
Date: Fri, 27 May 2011 13:44:55 +0200
Message-ID: <1306496697-12196-4-git-send-email-pablo@netfilter.org>
References: <1306496697-12196-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57203 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab1E0Lp1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 May 2011 07:45:27 -0400
In-Reply-To: <1306496697-12196-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

ip_set_flush returned -EPROTO instead of -IPSET_ERR_PROTOCOL, fixed

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 72d1ac6..8041bef 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -815,7 +815,7 @@ ip_set_flush(struct sock *ctnl, struct sk_buff *skb,
 	ip_set_id_t i;
 
 	if (unlikely(protocol_failed(attr)))
-		return -EPROTO;
+		return -IPSET_ERR_PROTOCOL;
 
 	if (!attr[IPSET_ATTR_SETNAME]) {
 		for (i = 0; i < ip_set_max; i++)
-- 
1.7.2.5

