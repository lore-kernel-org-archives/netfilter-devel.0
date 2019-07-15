Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1BAC7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 19:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6CA12081C
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 19:32:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="S8j7jhvO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfGOTcU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 15:32:20 -0400
Received: from mx1.riseup.net ([198.252.153.129]:58648 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729948AbfGOTcU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 15:32:20 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id D404E1A0985
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 12:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563219139; bh=/cfL+CQ2J06PmvQlI75GuiTaR9nYXIYkR2WLgu7SiBw=;
        h=From:To:Cc:Subject:Date:From;
        b=S8j7jhvOY+a9wC99o3r/R3wtD6iJdZ+bG6kk2XdkjuaG4ye/XyFltpjgMmoqJsL+B
         y4nYlMXz7YmuVjY0qKQ7JRrw90B5o0ve+xKT0gCaAAn8NverxcAAtIL8fyPJn5BuHL
         dgIvcLSIXByaAjcLRRTKuvnDINhbIU8ZvC6GBQ1s=
X-Riseup-User-ID: 4266C37C3470FB708AD70B26022E85546B4F4F424A48B723014B255C57117536
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 17D0B120327;
        Mon, 15 Jul 2019 12:32:18 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf v3] netfilter: synproxy: fix rst sequence number mismatch
Date:   Mon, 15 Jul 2019 21:31:49 +0200
Message-Id: <20190715193148.3334-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

14:51:00.024418 IP 192.168.122.1.41462 > netfilter.90: Flags [S], seq
4023580551,
14:51:00.024454 IP netfilter.90 > 192.168.122.1.41462: Flags [S.], seq
727560212, ack 4023580552,
14:51:00.024524 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,

Note: here, synproxy will send a SYN to the real server, as the 3whs was
completed sucessfully. Instead of a syn/ack that we can intercept, we instead
received a reset packet from the real backend, that we forward to the original
client. However, we don't use the correct sequence number, so the reset is not
effective in closing the connection coming from the client.

14:51:00.024550 IP netfilter.90 > 192.168.122.1.41462: Flags [R.], seq
3567407084,
14:51:00.231196 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,
14:51:00.647911 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,
14:51:01.474395 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 net/netfilter/nf_synproxy_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 6676a3842a0c..b0930d4aba22 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -687,7 +687,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 	state = &ct->proto.tcp;
 	switch (state->state) {
 	case TCP_CONNTRACK_CLOSE:
-		if (th->rst && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		if (th->rst && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
 			nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
 						      ntohl(th->seq) + 1);
 			break;
@@ -1111,7 +1111,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 	state = &ct->proto.tcp;
 	switch (state->state) {
 	case TCP_CONNTRACK_CLOSE:
-		if (th->rst && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		if (th->rst && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
 			nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
 						      ntohl(th->seq) + 1);
 			break;
-- 
2.20.1

