Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDD6C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Dec 2022 14:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiLOOQr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 09:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiLOOQq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 09:16:46 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242AC1D66D
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2022 06:16:44 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1p5p2N-0000XM-1D; Thu, 15 Dec 2022 15:16:39 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, kernel test robot <lkp@intel.com>
Subject: [PATCH nf] netfilter: conntrack: fix ipv6 exthdr error check
Date:   Thu, 15 Dec 2022 15:16:33 +0100
Message-Id: <20221215141633.13253-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <202212151110.zPbmpj0L-lkp@intel.com>
References: <202212151110.zPbmpj0L-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

smatch warnings:
net/netfilter/nf_conntrack_proto.c:167 nf_confirm() warn: unsigned 'protoff' is never less than zero.

We need to check if ipv6_skip_exthdr() returned an error, but protoff is
unsigned.  Use a signed integer for this.

Fixes: a70e483460d5 ("netfilter: conntrack: merge ipv4+ipv6 confirm functions")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 99323fb12d0f..ccef340be575 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -141,6 +141,7 @@ unsigned int nf_confirm(void *priv,
 	struct nf_conn *ct;
 	bool seqadj_needed;
 	__be16 frag_off;
+	int start;
 	u8 pnum;
 
 	ct = nf_ct_get(skb, &ctinfo);
@@ -163,9 +164,11 @@ unsigned int nf_confirm(void *priv,
 		break;
 	case NFPROTO_IPV6:
 		pnum = ipv6_hdr(skb)->nexthdr;
-		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum, &frag_off);
-		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
+		start = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum, &frag_off);
+		if (start < 0 || (frag_off & htons(~0x7)) != 0)
 			return nf_conntrack_confirm(skb);
+
+		protoff = start;
 		break;
 	default:
 		return nf_conntrack_confirm(skb);
-- 
2.37.4

