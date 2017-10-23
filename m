From: Tejaswi Tanikella <tejaswit@codeaurora.org>
Subject: [PATCH] netfilter: ipv4: Fix use-after-free in send_reset
Date: Mon, 23 Oct 2017 11:46:03 +0530
Message-ID: <20171023061559.GA25493@tejaswit-linux.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60696 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdJWGQK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2017 02:16:10 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

niph is not updated after pskb_expand_head changes the skb head.
It still points to the freed data, which is then used to update
tot_len and checksum. This could cause use-after-free poison crash.

Update niph, if ip_route_me_harder does not fail.

Signed-off-by: Tejaswi Tanikella <tejaswit@codeaurora.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index eeacbda..b2e0f90 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -131,6 +131,8 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 
 	if (ip_route_me_harder(net, nskb, RTN_UNSPEC))
 		goto free_nskb;
+	else
+		niph = ip_hdr(nskb);
 
 	/* "Never happens" */
 	if (nskb->len > dst_mtu(skb_dst(nskb)))
-- 
1.9.1

