Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6F6C7EE2F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Mar 2023 02:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjCBCWY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Mar 2023 21:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjCBCWX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2023 21:22:23 -0500
Received: from mail-pj1-x1063.google.com (mail-pj1-x1063.google.com [IPv6:2607:f8b0:4864:20::1063])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E9E521E0
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2023 18:22:20 -0800 (PST)
Received: by mail-pj1-x1063.google.com with SMTP id m3-20020a17090ade0300b00229eec90a7fso2556532pjv.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Mar 2023 18:22:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677723740;
        h=user-agent:content-disposition:message-id:subject:cc:to:from:date
         :dkim-signature:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jT18h+iBaJqv2WnL45lMMbQ5G7C2Xr0PFTfs7TBLBqU=;
        b=ebl0GK1ODbXRXTUTNJMTqeE1p0uWuzKD+NJDhhKY1DpECjYT1zuJ5WqNaPTAV2euo6
         X4em3+cs4Ik6yHrmj/WFeLA1giyifH3eU1dZlAYgXSD6TzgCuHHHm/qi56OUG3/NE3sH
         iJDfLZ2N/YffZ+WZdCRqIbeUSXbpggMIYcGgNzWDau+4khkO8idl+ipvRtDhmTkPNtjt
         DCUKMmlf9CuWAsDC1JK3c68TBlKCet3uPYqzh0u07AV/9KzIofek9ZVDLUv4s8KUXAwW
         NWdG2hIne+yPFb19/8caCipra9zmoEOejI2eZ06hsCTxzaDvqtIp6jwS8sPCeumxNsQt
         1Bnw==
X-Gm-Message-State: AO0yUKXPkamkqNHO3upGEtM35HVflESmHRxBPXbOgSs+UlQ1TgBhomh6
        OaOgGCMoyaBSY0JcvIhNxRMcPaYZSGD9oA5u88l8cbiNt4Ng
X-Google-Smtp-Source: AK7set/sfwOSB4928mAFcCLl0ICED0Ru2WlI7bU1wNdvdBH7Z5uW8w+m6l23Rb383I/+2kr5+27Fwu6BDrjG
X-Received: by 2002:a17:903:120e:b0:19c:36c9:2449 with SMTP id l14-20020a170903120e00b0019c36c92449mr9859601plh.17.1677723740112;
        Wed, 01 Mar 2023 18:22:20 -0800 (PST)
Received: from smtp.aristanetworks.com (mx.aristanetworks.com. [162.210.129.12])
        by smtp-relay.gmail.com with ESMTPS id p18-20020a170902ebd200b0019b003630desm575842plg.89.2023.03.01.18.22.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2023 18:22:20 -0800 (PST)
X-Relaying-Domain: arista.com
Received: from visor (unknown [172.20.208.33])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 6C8EF402044;
        Wed,  1 Mar 2023 18:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1677723739;
        bh=jT18h+iBaJqv2WnL45lMMbQ5G7C2Xr0PFTfs7TBLBqU=;
        h=Date:From:To:Cc:Subject:From;
        b=Oas0VxzI7WCw/lRBp/hhvV1PTG+KFpRbY20Q71x7H85CBDXubU4YVgngz8EdpGz80
         t2xEgkgbyI9+8unsLXi4FLRuuvIreG/NRJPOhL7a8UZgdRY1MosCbPm0oSZd3082G4
         CpoNGTdw/tGf6G731hh7ZS1l3vRMfngTR84kWYXZchREwjSqRB2PLT5TmgXnxfi/2H
         NYu87qAiKGePIWn/CUd6qTIdmRbHOaF5ews+b6NWL5suGdFqF1VETEZk673DYQkafQ
         rrnxEK2EoYlD3wmPrHa0RV5C/CKclFp91ZjkuWpSQYGqFHyZXgr1z+8xV5KE9kJ+Kg
         BjK8xpz+OYQCQ==
Date:   Wed, 1 Mar 2023 18:22:18 -0800
From:   Ivan Delalande <colona@arista.com>
To:     pablo@netfilter.org, kadlec@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: ctnetlink: revert to dumping mark regardless of
 event type
Message-ID: <20230302022218.GA195225@visor>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.13.2 (2019-12-18)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I assume that change was unintentional, we have userspace code that
needs the mark while listening for events like REPLY, DESTROY, etc.

Cc: <stable@vger.kernel.org>
Fixes: 1feeae071507 ("netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark")
Signed-off-by: Ivan Delalande <colona@arista.com>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c11dff91d52d..194822f8f1ee 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -831,7 +831,7 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (events & (1 << IPCT_MARK) &&
+	if ((events & (1 << IPCT_MARK) || READ_ONCE(ct->mark)) &&
 	    ctnetlink_dump_mark(skb, ct) < 0)
 		goto nla_put_failure;
 #endif
-- 
Arista Networks
