Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFB5ECAAA3
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Aug 2022 13:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbiHZNck (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 09:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiHZNcj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 09:32:39 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22ED3DC0B0
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2022 06:32:37 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oRZRr-0002fU-Jr; Fri, 26 Aug 2022 15:32:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 0/4] netfilter: conntrack: ignore overly delayed tcp packets
Date:   Fri, 26 Aug 2022 15:32:23 +0200
Message-Id: <20220826133227.3673-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

v2:
 - rebase on top of nf-next
 - add patch 4, this was not part of v1.

Consider following ruleset:
... ct state new accept
... ct state invalid drop

Normally a tcp receiver will reply with an ack once it receives
a delayed packet. Example:

+0.0001 < P. 1:1461(1460) ack 1 win 257
+.0 > . 1:1(0) ack 1461 win 65535
+0.0001 < P. 1461:2921(1460) ack 1 win 257
[..]
+0.0001 < P. 65701:67161(1460) ack 1 win 257
+.0 > . 1:1(0) ack 67161 win 65535 // all data received

// delayed packet, already acked
+0.0001 < P. 1:1461(1460) ack 1 win 257

// nf_ct_proto_6: SEQ is under the lower bound (already ACKed data retransmitted) IN=.. SEQ=1 ACK=4162510439 WINDOW=257 ACK PSHR
+.0 > . 1:1(0) ack 67161 win 65535

If the delayed packet is not dropped, the receiver can
immediately send another ack, but this doesn't happen if
INVALID packets are dropped by the ruleset (which is a common thing to do).

This changes conntrack to treat such packets as valid, with the caveat
that they will not extend the tcp timeout or cause state changes.

Ideally we could augment state matching so that this decision
is pushed to the ruleset but so far I don't see how this could be done
with the limited space we have in sk_buff (except for yet another skb
extension, but that appears to be too much for such a narrow use case).

Florian Westphal (4):
  netfilter: conntrack: prepare tcp_in_window for ternary return value
  netfilter: conntrack: ignore overly delayed tcp packets
  netfilter: conntrack: remove unneeded indent level
  netfilter: conntrack: reduce timeout when receiving out-of-window fin
    or rst

 net/netfilter/nf_conntrack_proto_tcp.c | 318 ++++++++++++++++---------
 1 file changed, 199 insertions(+), 119 deletions(-)

-- 
2.35.1

