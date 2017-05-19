From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next 1/2] netfilter: resolve warnings about missing prototypes
Date: Fri, 19 May 2017 09:29:41 -0700
Message-ID: <20170519162942.30004-1-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
To: pablo@netfilter.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33409 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdESQ3u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 12:29:50 -0400
Received: by mail-pf0-f182.google.com with SMTP id e193so42233675pfh.0
        for <netfilter-devel@vger.kernel.org>; Fri, 19 May 2017 09:29:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Missing include file causes:

net/netfilter/nf_dup_netdev.c:26:6: warning: no previous prototype for ‘nf_fwd_netdev_egress’ [-Wmissing-prototypes]
net/netfilter/nf_dup_netdev.c:40:6: warning: no previous prototype for ‘nf_dup_netdev_egress’ [-Wmissing-prototypes]

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 net/netfilter/nf_dup_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index c9d7f95768ab..f4a566e67213 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,6 +13,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_dup_netdev.h>
 
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev)
 {
-- 
2.11.0

