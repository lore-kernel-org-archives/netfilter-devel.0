Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F89C7EE37
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 22:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240135AbjFFW7H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240148AbjFFW7D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 18:59:03 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 362BE1739;
        Tue,  6 Jun 2023 15:58:59 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net 3/5] netfilter: conntrack: fix NULL pointer dereference in nf_confirm_cthelper
Date:   Wed,  7 Jun 2023 00:58:49 +0200
Message-Id: <20230606225851.67394-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230606225851.67394-1-pablo@netfilter.org>
References: <20230606225851.67394-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Tijs Van Buggenhout <tijs.van.buggenhout@axsguard.com>

An nf_conntrack_helper from nf_conn_help may become NULL after DNAT.

Observed when TCP port 1720 (Q931_PORT), associated with h323 conntrack
helper, is DNAT'ed to another destination port (e.g. 1730), while
nfqueue is being used for final acceptance (e.g. snort).

This happenned after transition from kernel 4.14 to 5.10.161.

Workarounds:
 * keep the same port (1720) in DNAT
 * disable nfqueue
 * disable/unload h323 NAT helper

$ linux-5.10/scripts/decode_stacktrace.sh vmlinux < /tmp/kernel.log
BUG: kernel NULL pointer dereference, address: 0000000000000084
[..]
RIP: 0010:nf_conntrack_update (net/netfilter/nf_conntrack_core.c:2080 net/netfilter/nf_conntrack_core.c:2134) nf_conntrack
[..]
nfqnl_reinject (net/netfilter/nfnetlink_queue.c:237) nfnetlink_queue
nfqnl_recv_verdict (net/netfilter/nfnetlink_queue.c:1230) nfnetlink_queue
nfnetlink_rcv_msg (net/netfilter/nfnetlink.c:241) nfnetlink
[..]

Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Signed-off-by: Tijs Van Buggenhout <tijs.van.buggenhout@axsguard.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c4ccfec6cb98..d119f1d4c2fc 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2260,6 +2260,9 @@ static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
 		return 0;
 
 	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return 0;
+
 	if (!(helper->flags & NF_CT_HELPER_F_USERSPACE))
 		return 0;
 
-- 
2.30.2

