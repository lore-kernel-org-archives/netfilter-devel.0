From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/19]: nfnetlink: kill nlattr_bad_size
Date: Fri, 28 Sep 2007 18:30:50 +0200 (MEST)
Message-ID: <20070928163049.8394.21886.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55947 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313AbXI1Qav (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:30:51 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink: kill nlattr_bad_size

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3dd95b7cdecd16519f2e76e2439953d6b50330c3
tree 230be6308f1a823db8f53ae3f1cc3b35731fc97c
parent e15d4b6820d941fdec349fba9b5800c366f1e4c1
author Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:15 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:15 +0200

 include/linux/netfilter/nfnetlink.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 3ee136a..0d8424f 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -73,19 +73,6 @@ struct nfnetlink_subsystem
 extern int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n);
 extern int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n);
 
-#define nlattr_bad_size(tb, max, cta_min)				\
-({	int __i, __res = 0;						\
- 	for (__i=1; __i <= max; __i++) {					\
- 		if (!cta_min[__i])					\
- 			continue;					\
- 		if (tb[__i] && nla_len(tb[__i]) < cta_min[__i]){	\
- 			__res = 1;					\
- 			break;						\
- 		}							\
- 	}								\
- 	__res;								\
-})
-
 extern int nfnetlink_has_listeners(unsigned int group);
 extern int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group, 
 			  int echo);
