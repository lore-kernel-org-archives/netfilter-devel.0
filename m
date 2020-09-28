Return-Path: <SRS0=suW2=DF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F50C2D0A8
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 16:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D4A20717
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 16:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgI1QuP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Sep 2020 12:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgI1QuP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Sep 2020 12:50:15 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DB3C061755
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2020 09:50:15 -0700 (PDT)
Received: from localhost ([::1]:39122 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kMwLs-0000XW-Ci; Mon, 28 Sep 2020 18:50:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Eric Garver <e@erig.me>,
        netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Fix for broken address mask match detection
Date:   Mon, 28 Sep 2020 19:05:47 +0200
Message-Id: <20200928170547.13857-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Trying to decide whether a bitwise expression is needed to match parts
of a source or destination address only, add_addr() checks if all bytes
in 'mask' are 0xff or not. The check is apparently broken though as each
byte in 'mask' is cast to a signed char before comparing against 0xff,
therefore the bitwise is always added:

| # ./bad/iptables-nft -A foo -s 10.0.0.1 -j ACCEPT
| # ./good/iptables-nft -A foo -s 10.0.0.2 -j ACCEPT
| # nft --debug=netlink list chain ip filter foo
| ip filter foo 5
|   [ payload load 4b @ network header + 12 => reg 1 ]
|   [ bitwise reg 1 = (reg=1 & 0xffffffff ) ^ 0x00000000 ]
|   [ cmp eq reg 1 0x0100000a ]
|   [ counter pkts 0 bytes 0 ]
|   [ immediate reg 0 accept ]
|
| ip filter foo 6 5
|   [ payload load 4b @ network header + 12 => reg 1 ]
|   [ cmp eq reg 1 0x0200000a ]
|   [ counter pkts 0 bytes 0 ]
|   [ immediate reg 0 accept ]
|
| table ip filter {
| 	chain foo {
| 		ip saddr 10.0.0.1 counter packets 0 bytes 0 accept
| 		ip saddr 10.0.0.2 counter packets 0 bytes 0 accept
| 	}
| }

Fix the cast, safe an extra op and gain 100% performance in ideal cases.

Fixes: 56859380eb328 ("xtables-compat: avoid unneeded bitwise ops")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index c5a8f3fcc051d..7741d23befc5a 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -165,7 +165,7 @@ void add_outiface(struct nftnl_rule *r, char *iface, uint32_t op)
 void add_addr(struct nftnl_rule *r, int offset,
 	      void *data, void *mask, size_t len, uint32_t op)
 {
-	const char *m = mask;
+	const unsigned char *m = mask;
 	int i;
 
 	add_payload(r, offset, len, NFT_PAYLOAD_NETWORK_HEADER);
-- 
2.28.0

