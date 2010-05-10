From: kaber@trash.net
Subject: [PATCH 30/84] netfilter: remove unused headers in net/ipv4/netfilter/nf_nat_h323.c
Date: Mon, 10 May 2010 22:18:01 +0200
Message-ID: <1273522735-24672-31-git-send-email-kaber@trash.net>
References: <1273522735-24672-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54510 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab0EJUTG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 May 2010 16:19:06 -0400
In-Reply-To: <1273522735-24672-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

Remove unused headers in net/ipv4/netfilter/nf_nat_h323.c

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/ipv4/netfilter/nf_nat_h323.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 7e8e6fc..d4c0618 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/tcp.h>
 #include <net/tcp.h>
 
-- 
1.7.0.4

