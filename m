Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2986AC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Mar 2022 14:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245251AbiCXOES (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Mar 2022 10:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiCXOER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Mar 2022 10:04:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6582A9974
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2022 07:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YU5D4ZjRVYppSsHMv9VD3tRWDpPnC1dGrlf8FqpD6WI=; b=VW2RYsXe+YAGArRz0/lnbt6f2M
        FBo+8UN/+Q3EMQf/gIBaPfOepO8nwzuCv6lwcKHrvYbsSClSdr0goYkQdj/QD6PV76GvNDZOcodr/
        /JOvIFRItXF8WBFCyhFRyJPTxQqckzqdjJcvgNWtrpabROSo2GGUpLfyUwfPzQ9XpBNaXDnf0ZiyO
        3ZzBI9PmB2k5Au40kL0EQ28QUfMQtoTF8z/bwFHEQDjSk56aKisBWhTC8EBux9r4zMif2jcv80OTs
        SJA0Zb6/M/dT6AcO5+JjaxaCIcX7psGdIeEYjY6rMv929AdsQaGI1QtZquKHdynUuoCVTknfiZMx5
        gVgV/b5w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXO2z-0002xH-Ui; Thu, 24 Mar 2022 15:02:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Lukas Wunner <lukas@wunner.de>, netfilter-devel@vger.kernel.org
Subject: [nf PATCH] netfilter: egress: Report interface as outgoing
Date:   Thu, 24 Mar 2022 15:02:40 +0100
Message-Id: <20220324140240.24177-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise packets in egress chains seem like they are being received by
the interface, not sent out via it.

Fixes: 42df6e1d221dd ("netfilter: Introduce egress hook")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/netfilter_netdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netfilter_netdev.h b/include/linux/netfilter_netdev.h
index e6487a6911360..8676316547cc4 100644
--- a/include/linux/netfilter_netdev.h
+++ b/include/linux/netfilter_netdev.h
@@ -99,7 +99,7 @@ static inline struct sk_buff *nf_hook_egress(struct sk_buff *skb, int *rc,
 		return skb;
 
 	nf_hook_state_init(&state, NF_NETDEV_EGRESS,
-			   NFPROTO_NETDEV, dev, NULL, NULL,
+			   NFPROTO_NETDEV, NULL, dev, NULL,
 			   dev_net(dev), NULL);
 
 	/* nf assumes rcu_read_lock, not just read_lock_bh */
-- 
2.34.1

