Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4576EC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Dec 2021 16:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbhLJQMp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 11:12:45 -0500
Received: from str75-3-78-193-33-39.fbxo.proxad.net ([78.193.33.39]:43784 "EHLO
        mail.qult.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S238157AbhLJQMp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 11:12:45 -0500
X-Greylist: delayed 2260 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Dec 2021 11:12:44 EST
Received: from zenon.in.qult.net ([192.168.64.1])
        by mail.qult.net with esmtp (Exim 4.90_1)
        (envelope-from <ignacy.gawedzki@green-communications.fr>)
        id 1mvhrt-0004uU-Nl
        for netfilter-devel@vger.kernel.org; Fri, 10 Dec 2021 16:31:29 +0100
Received: from ig by zenon.in.qult.net with local (Exim 4.94.2)
        (envelope-from <ignacy.gawedzki@green-communications.fr>)
        id 1mvhrr-00G8Ch-Bg
        for netfilter-devel@vger.kernel.org; Fri, 10 Dec 2021 16:31:27 +0100
Date:   Fri, 10 Dec 2021 16:31:27 +0100
From:   Ignacy =?utf-8?B?R2F3xJlkemtp?= 
        <ignacy.gawedzki@green-communications.fr>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH v3] netfilter: fix regression in looped (broad|multi)cast's
 MAC handling
Message-ID: <20211210153127.i7kqadosjgw6qiqp@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In commit 5648b5e1169f ("netfilter: nfnetlink_queue: fix OOB when mac
header was cleared"), the test for non-empty MAC header introduced in
commit 2c38de4c1f8da7 ("netfilter: fix looped (broad|multi)cast's MAC
handling") has been replaced with a test for a set MAC header.

This breaks the case when the MAC header has been reset (using
skb_reset_mac_header), as is the case with looped-back multicast
packets.  As a result, the packets ending up in NFQUEUE get a bogus
hwaddr interpreted from the first bytes of the IP header.

This patch adds a test for a non-empty MAC header in addition to the
test for a set MAC header.  The same two tests are also implemented in
nfnetlink_log.c, where the initial code of commit 2c38de4c1f8da7
("netfilter: fix looped (broad|multi)cast's MAC handling") has not been
touched, but where supposedly the same situation may happen.

Fixes: 5648b5e1169f ("netfilter: nfnetlink_queue: fix OOB when mac
header was cleared")

Signed-off-by: Ignacy Gawêdzki <ignacy.gawedzki@green-communications.fr>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
changelog:
 v3: reword commit message again
 v2: reword commit message

 net/netfilter/nfnetlink_log.c   | 3 ++-
 net/netfilter/nfnetlink_queue.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 691ef4cffdd9..7f83f9697fc1 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -556,7 +556,8 @@ __build_packet_message(struct nfnl_log_net *log,
 		goto nla_put_failure;
 
 	if (indev && skb->dev &&
-	    skb->mac_header != skb->network_header) {
+	    skb_mac_header_was_set(skb) &&
+	    skb_mac_header_len(skb) != 0) {
 		struct nfulnl_msg_packet_hw phw;
 		int len;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 4acc4b8e9fe5..959527708e38 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -560,7 +560,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		goto nla_put_failure;
 
 	if (indev && entskb->dev &&
-	    skb_mac_header_was_set(entskb)) {
+	    skb_mac_header_was_set(entskb) &&
+	    skb_mac_header_len(entskb) != 0) {
 		struct nfqnl_msg_packet_hw phw;
 		int len;
 
-- 
2.32.0
