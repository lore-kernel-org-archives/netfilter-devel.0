From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 11/32] netfilter: remove duplicated include
Date: Fri, 19 Jan 2018 20:10:20 +0100
Message-ID: <20180119191041.25804-12-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45142 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756186AbeASTLD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 14:11:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7C34B2EFEC5
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C8ABDA38E
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:00 +0100 (CET)
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_flow_table_ipv6.c | 1 -
 net/netfilter/nf_queue.c                | 2 --
 2 files changed, 3 deletions(-)

diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index 0c3b9d32f64f..fff21602875a 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -5,7 +5,6 @@
 #include <linux/rhashtable.h>
 #include <linux/ipv6.h>
 #include <linux/netdevice.h>
-#include <linux/ipv6.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
 #include <net/neighbour.h>
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 7f55af5f3d1a..d67a96a25a68 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -15,8 +15,6 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/seq_file.h>
 #include <linux/rcupdate.h>
-#include <linux/netfilter_ipv4.h>
-#include <linux/netfilter_ipv6.h>
 #include <net/protocol.h>
 #include <net/netfilter/nf_queue.h>
 #include <net/dst.h>
-- 
2.11.0

