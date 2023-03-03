Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 925E7C6FA8E
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Mar 2023 01:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCCBsl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 20:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCCBsk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 20:48:40 -0500
Received: from mail-pl1-x663.google.com (mail-pl1-x663.google.com [IPv6:2607:f8b0:4864:20::663])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A00314988
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Mar 2023 17:48:39 -0800 (PST)
Received: by mail-pl1-x663.google.com with SMTP id i3so1213271plg.6
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Mar 2023 17:48:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677808119;
        h=user-agent:content-disposition:message-id:subject:cc:to:from:date
         :dkim-signature:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xBqIpZGfwpK5x5K6royzNmSK+n6fll7I/dc50PXG14I=;
        b=aVjF0MU6uAUJ/msxoTwSk39DvAekYPmGni4aYeQ+/UbBxVvbKPiM1/h0FkESMf3zbY
         F6eXvWLz15DXR7H29fb7mI7xiO7gZkzuIf26jMxPKTiEfywxz7n/m51Haexny43bzlnr
         aSiAmcjOJGAYH/9qQJXDWzrsaqI3/LKCrQzXdt9nRDVvPW0xqFNbf1F6MC9oP1Ir9zwS
         q2PPuSbftteLS3wMOerlu+HXSmvu8nmgb9KI2uIFco83MuKbhHx3fmmMgFmkaGhpDStD
         1R0+/UJWu1gIeEajTn5ewJXR9pdyj0XxkK8FenobInu6IHgYrTTNQLIwrmbj3WYQNKr8
         hNTA==
X-Gm-Message-State: AO0yUKWfsASaKH2S5a9PViaC+wkpk7p4A5DGTVR+Tug3upOXM1Z9QKWg
        CY1YeGPzf5GO78ehtBF3qs0p+y4A02IlbYHqztJTiJzY9pfY
X-Google-Smtp-Source: AK7set+66g58v7EghJKpmy2j77Y9OZVrWNRKtthZ10RIprWz9RnW7QngavPlXmyk3YPl59hxt4OxnPdq91l4
X-Received: by 2002:a17:90b:4a88:b0:22b:f0d4:9e1e with SMTP id lp8-20020a17090b4a8800b0022bf0d49e1emr13902789pjb.8.1677808118579;
        Thu, 02 Mar 2023 17:48:38 -0800 (PST)
Received: from smtp.aristanetworks.com (mx.aristanetworks.com. [162.210.129.12])
        by smtp-relay.gmail.com with ESMTPS id oa9-20020a17090b1bc900b0023407ca5f21sm250390pjb.11.2023.03.02.17.48.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Mar 2023 17:48:38 -0800 (PST)
X-Relaying-Domain: arista.com
Received: from visor (unknown [172.22.75.75])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id E0AEF400F80;
        Thu,  2 Mar 2023 17:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1677808117;
        bh=xBqIpZGfwpK5x5K6royzNmSK+n6fll7I/dc50PXG14I=;
        h=Date:From:To:Cc:Subject:From;
        b=QNPkr8f7HCg/xNAcwabmJnd1hg2UumB3XdsyYiYx99YzE2zJeyMLs3Xeo4FVAHbHw
         MQ7ysmdh4AQA//D+UJFu83799YEnem9TKsJg8x7VI18KVOMyYFC0dh75gAXLHxRtVW
         uUKpOJSQKXcG2k3aaXBnYZ3ZAqTWxmamhG2dcCm5GHl9QclJ5x3caCCT1o8FRlvcQ3
         kFPbY+9I3mLktZdbwatD/Mlju7lhaMwQyP8Up5dd9R98PbtVbrumrZ8K+O9mvePRVb
         X7eysBJxmjVFQfHVrqfO8PeesgF/JOAVNm+FRHj/TzW26ssPM4fcq/zd+Z6E6w70wa
         +97+QTqL0mi3g==
Date:   Thu, 2 Mar 2023 17:48:31 -0800
From:   Ivan Delalande <colona@arista.com>
To:     pablo@netfilter.org, fw@strlen.de
Cc:     kadlec@netfilter.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v2] netfilter: ctnetlink: revert to dumping mark regardless
 of event type
Message-ID: <20230303014831.GA374206@visor>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.13.2 (2019-12-18)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It seems that change was unintentional, we have userspace code that
needs the mark while listening for events like REPLY, DESTROY, etc.
Also include 0-marks in requested dumps, as they were before that fix.

Cc: <stable@vger.kernel.org>
Fixes: 1feeae071507 ("netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark")
Signed-off-by: Ivan Delalande <colona@arista.com>
---
 net/netfilter/nf_conntrack_netlink.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c11dff91d52d..bfc3aaa2c872 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -328,11 +328,12 @@ ctnetlink_dump_timestamp(struct sk_buff *skb, const struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
+static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct,
+			       bool dump)
 {
 	u32 mark = READ_ONCE(ct->mark);
 
-	if (!mark)
+	if (!mark && !dump)
 		return 0;
 
 	if (nla_put_be32(skb, CTA_MARK, htonl(mark)))
@@ -343,7 +344,7 @@ static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct)
 	return -1;
 }
 #else
-#define ctnetlink_dump_mark(a, b) (0)
+#define ctnetlink_dump_mark(a, b, c) (0)
 #endif
 
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
@@ -548,7 +549,7 @@ static int ctnetlink_dump_extinfo(struct sk_buff *skb,
 static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 {
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_mark(skb, ct, true) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
@@ -831,8 +832,7 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
 	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (events & (1 << IPCT_MARK) &&
-	    ctnetlink_dump_mark(skb, ct) < 0)
+	if (ctnetlink_dump_mark(skb, ct, events & (1 << IPCT_MARK)))
 		goto nla_put_failure;
 #endif
 	nlmsg_end(skb, nlh);
@@ -2735,7 +2735,7 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 		goto nla_put_failure;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (ctnetlink_dump_mark(skb, ct) < 0)
+	if (ctnetlink_dump_mark(skb, ct, true) < 0)
 		goto nla_put_failure;
 #endif
 	if (ctnetlink_dump_labels(skb, ct) < 0)
-- 
Arista Networks
