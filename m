Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F8DC61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 09:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjBVJVw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 04:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbjBVJVs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 04:21:48 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EC9A28866;
        Wed, 22 Feb 2023 01:21:47 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 6/8] netfilter: xt_length: use skb len to match in length_mt6
Date:   Wed, 22 Feb 2023 10:21:35 +0100
Message-Id: <20230222092137.88637-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230222092137.88637-1-pablo@netfilter.org>
References: <20230222092137.88637-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

For IPv6 Jumbo packets, the ipv6_hdr(skb)->payload_len is always 0,
and its real payload_len ( > 65535) is saved in hbh exthdr. With 0
length for the jumbo packets, it may mismatch.

To fix this, we can just use skb->len instead of parsing exthdrs, as
the hbh exthdr parsing has been done before coming to length_mt6 in
ip6_rcv_core() and br_validate_ipv6() and also the packet has been
trimmed according to the correct IPv6 (ext)hdr length there, and skb
len is trustable in length_mt6().

Note that this patch is especially needed after the IPv6 BIG TCP was
supported in kernel, which is using IPv6 Jumbo packets. Besides, to
match the packets greater than 65535 more properly, a v1 revision of
xt_length may be needed to extend "min, max" to u32 in the future,
and for now the IPv6 Jumbo packets can be matched by:

  # ip6tables -m length ! --length 0:65535

Fixes: 7c4e983c4f3c ("net: allow gso_max_size to exceed 65536")
Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_length.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 1873da3a945a..9fbfad13176f 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -30,8 +30,7 @@ static bool
 length_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_length_info *info = par->matchinfo;
-	const u_int16_t pktlen = ntohs(ipv6_hdr(skb)->payload_len) +
-				 sizeof(struct ipv6hdr);
+	u32 pktlen = skb->len;
 
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
-- 
2.30.2

