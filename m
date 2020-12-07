Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82E6C0018C
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 13:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6997F23442
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 13:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgLGNn4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgLGNnz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Dec 2020 08:43:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82359C0613D1;
        Mon,  7 Dec 2020 05:43:15 -0800 (PST)
Received: from localhost ([::1]:60640 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kmGnJ-0000vd-Cb; Mon, 07 Dec 2020 14:43:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v2] xfrm: interface: Don't hide plain packets from netfilter
Date:   Mon,  7 Dec 2020 14:43:09 +0100
Message-Id: <20201207134309.16762-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With an IPsec tunnel without dedicated interface, netfilter sees locally
generated packets twice as they exit the physical interface: Once as "the
inner packet" with IPsec context attached and once as the encrypted
(ESP) packet.

With xfrm_interface, the inner packet did not traverse NF_INET_LOCAL_OUT
hook anymore, making it impossible to match on both inner header values
and associated IPsec data from that hook.

Fix this by looping packets transmitted from xfrm_interface through
NF_INET_LOCAL_OUT before passing them on to dst_output(), which makes
behaviour consistent again from netfilter's point of view.

Fixes: f203b76d78092 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Extend recipients list, no code changes.
---
 net/xfrm/xfrm_interface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index aa4cdcf69d471..24af61c95b4d4 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -317,7 +317,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	skb_dst_set(skb, dst);
 	skb->dev = tdev;
 
-	err = dst_output(xi->net, skb->sk, skb);
+	err = NF_HOOK(skb_dst(skb)->ops->family, NF_INET_LOCAL_OUT, xi->net,
+		      skb->sk, skb, NULL, skb_dst(skb)->dev, dst_output);
 	if (net_xmit_eval(err) == 0) {
 		struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
 
-- 
2.28.0

