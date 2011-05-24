From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 3/3] netfilter: ipset: fix ip_set_flush return code
Date: Tue, 24 May 2011 10:20:19 +0200
Message-ID: <1306225219-1498-4-git-send-email-kadlec@blackhole.kfki.hu>
References: <1306225219-1498-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1306225219-1498-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1306225219-1498-3-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:58657 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab1EXIUV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 04:20:21 -0400
In-Reply-To: <1306225219-1498-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip_set_flush returned -EPROTO instead of -IPSET_ERR_PROTOCOL, fixed

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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
1.7.0.4

