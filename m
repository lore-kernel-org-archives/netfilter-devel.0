Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D90C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E2926140C
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbhD1NJ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:09:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:42902 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239604AbhD1NJ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:09:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619615352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=7yVQstr37qnEZRgLtoMYqcdOGiO+b7d1YaJTr50ElwI=;
        b=SwhOWSCv7DDUO4A/+wqai6nwSAjcEcP8/Yje1MM01K9QPctnoJmNKqSqKVln6P4btqTdya
        vkH7mwFHue68xPAut5JWvDE5NfFU3LXKravyxjnr7cRcJbEhWXmmxH/ha/AY/dvGdNvHHx
        RazqZD32S03b2pk6Z5bGKFHiBCHNwkk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7BA40B170
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Apr 2021 13:09:12 +0000 (UTC)
Date:   Wed, 28 Apr 2021 15:09:11 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] Don't drop out of segments RST if tcp_be_liberal is set
Message-ID: <20210428130911.cteglt52r5if7ynp@Fryzen495>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When tcp_be_liberal is set, don't be conservative on out of segments RSTs.

Signed-off-by: Ali Abdallah <aabdallah@suse.de>
---
 Documentation/networking/nf_conntrack-sysctl.rst | 2 +-
 net/netfilter/nf_conntrack_proto_tcp.c           | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 11a9b76786cb..4278fad31a43 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -108,7 +108,7 @@ nf_conntrack_tcp_be_liberal - BOOLEAN
 	- not 0 - enabled
 
 	Be conservative in what you do, be liberal in what you accept from others.
-	If it's non-zero, we mark only out of window RST segments as INVALID.
+	If it's non-zero, we don't mark out of window segments as INVALID.
 
 nf_conntrack_tcp_loose - BOOLEAN
 	- 0 - disabled
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 02fab7a8ec92..83890a700ef8 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1048,7 +1048,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		if (ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_MAXACK_SET) {
 			u32 seq = ntohl(th->seq);
 
-			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack)) {
+			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack) &&
+			    !tn->tcp_be_liberal) {
 				/* Invalid RST  */
 				spin_unlock_bh(&ct->lock);
 				nf_ct_l4proto_log_invalid(skb, ct, "invalid rst");
-- 
2.26.2


