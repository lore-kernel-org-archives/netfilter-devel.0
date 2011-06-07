From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 12/15] netfilter: ipset: Fix return code for destroy when sets are in use
Date: Tue,  7 Jun 2011 18:56:17 +0200
Message-ID: <1307465780-28980-13-git-send-email-kadlec@blackhole.kfki.hu>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-4-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-5-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-6-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-7-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-8-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-9-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-10-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-11-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-12-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:52141 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab1FGQ4W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:56:22 -0400
In-Reply-To: <1307465780-28980-12-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
1.7.0.4

