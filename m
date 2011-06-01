From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 09/12] netfilter: ipset: Fix return code for destroy when sets are in use
Date: Wed,  1 Jun 2011 23:35:48 +0200
Message-ID: <1306964151-4686-10-git-send-email-kadlec@blackhole.kfki.hu>
References: <1306964151-4686-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1306964151-4686-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1306964151-4686-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1306964151-4686-4-git-send-email-kadlec@blackhole.kfki.hu>
 <1306964151-4686-5-git-send-email-kadlec@blackhole.kfki.hu>
 <1306964151-4686-6-git-send-email-kadlec@blackhole.kfki.hu>
 <1306964151-4686-7-git-send-email-kadlec@blackhole.kfki.hu>
 <1306964151-4686-8-git-send-email-kadlec@blackhole.kfki.hu>
 <1306964151-4686-9-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:40748 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759793Ab1FAVfx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:35:53 -0400
In-Reply-To: <1306964151-4686-9-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index c68f139..3cfe27a 100644
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
1.7.0.4

