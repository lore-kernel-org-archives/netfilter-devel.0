Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDD3C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 12:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 159EE613BF
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 12:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhDTMYw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 08:24:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:38644 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230408AbhDTMYs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 08:24:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618921456; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=WELNGxuTozzSHlbkJcUKIvXdGke1cdkbr9Kx/sYSU44=;
        b=Wr+N/IpHXM5or9rLHp7kj4M5UupnIVkraqyTXkpzHuPY9dqQik53r3j181+25mUQlWx9Bj
        sbyXBBWN1mQmbL/hXJ/GuGV3vfAVkTT0GwBkrXToEKJLNVK2d38oRs9L39DjZE/npbojak
        E4/RwyuWY+ZLX1j5NSn85ququ+nI0rM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6D7C9AF3B
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2021 12:24:16 +0000 (UTC)
Date:   Tue, 20 Apr 2021 14:24:15 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: conntrack: Reset the max ACK flag on SYN in
 ignore state
Message-ID: <20210420122415.v2jtayiw3n4ds7t7@Fryzen495>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In ignore state, we let SYN goes in original, the server might respond
with RST/ACK, and that RST packet is erroneously dropped because of the
flag IP_CT_TCP_FLAG_MAXACK_SET being already set.

Signed-off-by: Ali Abdallah <aabdallah@suse.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ec23330687a5..02fab7a8ec92 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -963,6 +963,10 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 
 			ct->proto.tcp.last_flags =
 			ct->proto.tcp.last_wscale = 0;
+			/* Reset the max ack flag so in case the server replies
+			 * with RST/ACK it will not be marked as an invalid rst.
+			 */
+			ct->proto.tcp.seen[dir].flags &= ~IP_CT_TCP_FLAG_MAXACK_SET;
 			tcp_options(skb, dataoff, th, &seen);
 			if (seen.flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
 				ct->proto.tcp.last_flags |=
-- 
2.26.2

