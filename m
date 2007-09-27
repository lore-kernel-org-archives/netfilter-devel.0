From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/09]: nfnetlink: kill nlattr_bad_size
Date: Thu, 27 Sep 2007 15:46:13 +0200 (MEST)
Message-ID: <20070927134612.10198.23312.sendpatchset@localhost.localdomain>
References: <20070927134559.10198.64673.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58758 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbXI0NqO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2007 09:46:14 -0400
In-Reply-To: <20070927134559.10198.64673.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nfnetlink: kill nlattr_bad_size

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c62824a27e1cfc24fdec38395f9bfb83f94ceb55
tree d321b0b3eef9c8653290bb8e7b799ade6d2bd8a6
parent 6aa7455c85e5169b26fabad4f330303325a3b79e
author Patrick McHardy <kaber@trash.net> Thu, 27 Sep 2007 15:05:52 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 27 Sep 2007 15:05:52 +0200

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
