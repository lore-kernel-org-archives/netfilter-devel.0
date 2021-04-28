Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41E8C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CD5461419
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239620AbhD1NMe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:12:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:43684 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239634AbhD1NMe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:12:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619615508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=5/MbXzNi2FkuVSY2EkCjEfkH8QIg5/IT2+6hrVIUMPo=;
        b=t8dvUJej7LveffHBKEoMXu0ohJg0wt3ucVme0iD7ahVSa0juw6z2ZdcwfUL2LwY6dsyMMV
        yN+K4Y5OqDzb93pf1yUKnOZRPI3oxfCUbunVHFYdt/9PJpEpHPSF7OOUle4oEYpv4hBWh9
        CqANq0r82zHTziRZI0spAPmbSvz0wWA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AAF82B180
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Apr 2021 13:11:48 +0000 (UTC)
Date:   Wed, 28 Apr 2021 15:11:47 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] Avoid potentially erroneos RST check
Message-ID: <20210428131147.w2ppmrt6hpcjin5i@Fryzen495>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In 'commit b303e7b80ff1 ("Reset the max ACK flag on SYN in ignore state")'
we reset the max ACK number to avoid dropping valid RST that is a
response to a SYN.

Unfortunately that might not be enough, an out of order ACK in origin
might reset it back, and we might end up again dropping valid RST.

This patch disables the RST check when we are not in established state
and  we receive an RST with SEQ=0 that is most likely a response to a
SYN we had let it go through.

Signed-off-by: Ali Abdallah <aabdallah@suse.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 83890a700ef8..fb1c389a97fe 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1048,6 +1048,12 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		if (ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_MAXACK_SET) {
 			u32 seq = ntohl(th->seq);
 
+			/* If we are not in established state, and an RST is
+			 * observed with SEQ=0, this is most likely an answer
+			 * to a SYN we had let go through above.
+			 */
+			if (seq == 0 && !nf_conntrack_tcp_established(ct))
+				break;
+
 			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack) &&
 			    !tn->tcp_be_liberal) {
 				/* Invalid RST  */
-- 
2.26.2
