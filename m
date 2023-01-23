Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693ABC38142
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Jan 2023 12:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjAWMEs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Jan 2023 07:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjAWMEq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2023 07:04:46 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDA823851
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2023 04:04:44 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pJvZ3-0006xu-C5; Mon, 23 Jan 2023 13:04:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH nf-next] netfilter: conntrack: udp: fix seen-reply test
Date:   Mon, 23 Jan 2023 13:04:33 +0100
Message-Id: <20230123120433.98002-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

IPS_SEEN_REPLY_BIT is only useful for test_bit() api.

Fixes: 4883ec512c17 ("netfilter: conntrack: avoid reload of ct->status")
Reported-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 6b9206635b24..0030fbe8885c 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -104,7 +104,7 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 	/* If we've seen traffic both ways, this is some kind of UDP
 	 * stream. Set Assured.
 	 */
-	if (status & IPS_SEEN_REPLY_BIT) {
+	if (status & IPS_SEEN_REPLY) {
 		unsigned long extra = timeouts[UDP_CT_UNREPLIED];
 		bool stream = false;
 
-- 
2.39.1

