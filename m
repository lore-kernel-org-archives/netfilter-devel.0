From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: increase IPSTATS_MIB_CSUMERRORS stat
Date: Sat, 17 Feb 2018 04:18:15 +0900
Message-ID: <20180216191815.26633-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:42995 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753368AbeBPTSW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 14:18:22 -0500
Received: by mail-pl0-f68.google.com with SMTP id 31so2172269ple.9
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Feb 2018 11:18:22 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In the ip_rcv, IPSTATS_MIB_CSUMERRORS is increased when
checksum error is occurred.
bridge netfilter routine should increase IPSTATS_MIB_CSUMERRORS.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/bridge/br_netfilter_hooks.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 27f1d4f..9b16eaf 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -214,7 +214,7 @@ static int br_validate_ipv4(struct net *net, struct sk_buff *skb)
 
 	iph = ip_hdr(skb);
 	if (unlikely(ip_fast_csum((u8 *)iph, iph->ihl)))
-		goto inhdr_error;
+		goto csum_error;
 
 	len = ntohs(iph->tot_len);
 	if (skb->len < len) {
@@ -236,6 +236,8 @@ static int br_validate_ipv4(struct net *net, struct sk_buff *skb)
 	 */
 	return 0;
 
+csum_error:
+	__IP_INC_STATS(net, IPSTATS_MIB_CSUMERRORS);
 inhdr_error:
 	__IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
 drop:
-- 
2.9.3

