Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D1BC433B4
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Apr 2021 09:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACC4C61468
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Apr 2021 09:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhD3Jgv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Apr 2021 05:36:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:50264 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229543AbhD3Jgu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Apr 2021 05:36:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619775362; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=rY3ucUB+Ef5QRCb1XaU5iLuu5nDwql3erR5hYkg6s04=;
        b=g6oOYwzr1roesFaaVWB+OXGLle7gkHKRfRCXLXWgoMVHpzdK1UTOCxWj1UmAeLBiZHCrVp
        RM9kywNhMn/62cKf8IgiL3njZ67M54qyaYjnGFavDbZR1YGP6ZzX8jXsgjN1PEYVG7bAH0
        OKyu8ov1fNsN/oPCLSxBiGtUAn1CGNw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0F64AAE56
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Apr 2021 09:36:02 +0000 (UTC)
Date:   Fri, 30 Apr 2021 11:36:01 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] Avoid potentially erroneos RST drop.
Message-ID: <20210430093601.zibczc4cjnwx3qwn@Fryzen495>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In ignore state, we let SYN goes in original, the server might respond
with RST/ACK, and that RST packet is erroneously dropped because of the
flag IP_CT_TCP_FLAG_MAXACK_SET being already set. So we reset the flag
in this case.

Unfortunately that might not be enough, an out of order ACK in origin
might reset it back, and we might end up again dropping a valid RST when
the server responds with RST SEQ=0.

The patch disables also the RST check when we are not in established
state and we receive an RST with SEQ=0 that is most likely a response to
a SYN we had let it go through.

Signed-off-by: Ali Abdallah <aabdallah@suse.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 318b8f723349..e958fde8cf9b 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -949,6 +949,10 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 
 			ct->proto.tcp.last_flags =
 			ct->proto.tcp.last_wscale = 0;
+			/* Reset the max ack flag so in case the server replies
+			 * with RST/ACK it will not be marked as an invalid rst.
+			 */
+			ct->proto.tcp.seen[dir].flags &= ~IP_CT_TCP_FLAG_MAXACK_SET;
 			tcp_options(skb, dataoff, th, &seen);
 			if (seen.flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
 				ct->proto.tcp.last_flags |=
@@ -1030,6 +1034,13 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		if (ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_MAXACK_SET) {
 			u32 seq = ntohl(th->seq);
 
+			/* If we are not in established state, and an RST is
+			 * observed with SEQ=0, this is most likely an answer
+			 * to a SYN we had let go through above.
+			 */
+			if (seq == 0 && !nf_conntrack_tcp_established(ct))
+				break;
+
 			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack)) {
 				/* Invalid RST  */
 				spin_unlock_bh(&ct->lock);
-- 
2.26.2
