Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE43C54E94
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Jan 2023 01:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjAZBfm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236496AbjAZBfh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Jan 2023 20:35:37 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0334ED19
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Jan 2023 17:35:29 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pKrAk-0002oj-Bo; Thu, 26 Jan 2023 02:35:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] Revert "netfilter: conntrack: fix bug in for_each_sctp_chunk"
Date:   Thu, 26 Jan 2023 02:35:21 +0100
Message-Id: <20230126013521.21836-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is no bug.  If sch->length == 0, this would result in an infinite
loop, but first caller, do_basic_checks(), errors out in this case.

After this change, packets with bogus zero-length chunks are no longer
detected as invalid, so revert & add comment wrt. 0 length check.

Fixes: 98ee00774525 ("netfilter: conntrack: fix bug in for_each_sctp_chunk")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 It might be a good idea to merge do_basic_checks and sctp_error
 to avoid future patches adding for_each_sctp_chunk() earlier in the
 pipeline.

 net/netfilter/nf_conntrack_proto_sctp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 945dd40e7077..2f4459478750 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -142,10 +142,11 @@ static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 }
 #endif
 
+/* do_basic_checks ensures sch->length > 0, do not use before */
 #define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
 for ((offset) = (dataoff) + sizeof(struct sctphdr), (count) = 0;	\
-	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch))) &&	\
-	(sch)->length;	\
+	(offset) < (skb)->len &&					\
+	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch)));	\
 	(offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)
 
 /* Some validity checks to make sure the chunks are fine */
-- 
2.39.1

