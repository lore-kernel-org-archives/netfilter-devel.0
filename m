From: Dragos Foianu <dragos.foianu@gmail.com>
Subject: [PATCH] ipvs: fixed style error in ip_vs_sched
Date: Thu, 11 Jul 2013 22:20:38 +0300
Message-ID: <1373570438-4946-1-git-send-email-dragos.foianu@gmail.com>
Cc: horms@verge.net.au, ja@ssi.bg, pablo@netfilter.org,
	kaber@trash.net, kadlec@blackhole.kfki.hu, davem@davemloft.net,
	netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	Dragos Foianu <dragos.foianu@gmail.com>
To: wensong@linux-vs.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:36608 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3GKTUr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:20:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

found with the help of checkpatch.pl

Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>
---
 net/netfilter/ipvs/ip_vs_sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_sched.c b/net/netfilter/ipvs/ip_vs_sched.c
index 4dbcda6..a67980d 100644
--- a/net/netfilter/ipvs/ip_vs_sched.c
+++ b/net/netfilter/ipvs/ip_vs_sched.c
@@ -99,7 +99,7 @@ static struct ip_vs_scheduler *ip_vs_sched_getbyname(const char *sched_name)
 			 */
 			continue;
 		}
-		if (strcmp(sched_name, sched->name)==0) {
+		if (strcmp(sched_name, sched->name) == 0) {
 			/* HIT */
 			mutex_unlock(&ip_vs_sched_mutex);
 			return sched;
-- 
1.7.10.4

