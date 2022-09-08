Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6AB4C54EE9
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Sep 2022 15:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiIHPNF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 11:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiIHPND (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 11:13:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7155BF3BDC
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2022 08:13:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oWJDA-0005Zq-N8; Thu, 08 Sep 2022 17:13:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 3/3] extensions: libxt_pkttype: support otherhost
Date:   Thu,  8 Sep 2022 17:12:42 +0200
Message-Id: <20220908151242.26838-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220908151242.26838-1-fw@strlen.de>
References: <20220908151242.26838-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Makes no sense for iptables/ip6tables but it does make sense for ebtables.
Classic ebtables uses libebt_pkttype which isn't compatible, but
iptables-nft can use the libxt_pkttype version when printing native
'meta pkttype'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_pkttype.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index bf6f5b960662..a76310b053b4 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -30,8 +30,8 @@ static const struct pkttypes supported_types[] = {
 	{"unicast", PACKET_HOST, 1, "to us"},
 	{"broadcast", PACKET_BROADCAST, 1, "to all"},
 	{"multicast", PACKET_MULTICAST, 1, "to group"},
-/*
 	{"otherhost", PACKET_OTHERHOST, 1, "to someone else"},
+/*
 	{"outgoing", PACKET_OUTGOING, 1, "outgoing of any type"},
 */
 	/* aliases */
-- 
2.35.1

