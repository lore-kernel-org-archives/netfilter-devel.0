From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH nf-next 5/6] ipt_CLUSTERIP: create proc entry under proper ipt_CLUSTERIP directory
Date: Wed, 25 Sep 2013 15:38:48 +0800
Message-ID: <1380094729-30674-6-git-send-email-gaofeng@cn.fujitsu.com>
References: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab3IYHhu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:37:50 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8P7bepr004287
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2013 15:37:42 +0800
In-Reply-To: <1380094729-30674-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Create proc entries under the ipt_CLUSTERIP directory of proper
net namespace.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index b7fc9d5..c93dfd2 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -168,7 +168,7 @@ clusterip_config_init(const struct ipt_clusterip_tgt_info *i, __be32 ip,
 			struct net_device *dev)
 {
 	struct clusterip_config *c;
-	struct clusterip_net *cn = net_generic(&init_net, clusterip_net_id);
+	struct clusterip_net *cn = net_generic(dev_net(dev), clusterip_net_id);
 
 	c = kzalloc(sizeof(*c), GFP_ATOMIC);
 	if (!c)
-- 
1.8.3.1

