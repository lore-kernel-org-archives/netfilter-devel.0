Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555B6C35670
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 367162071C
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgBXADz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 19:03:55 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46012 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbgBXADy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 19:03:54 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j61Dz-0004le-Bv; Mon, 24 Feb 2020 01:03:51 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     nevola@gmail.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/6] netlink: handle concatenations on set elements mappings
Date:   Mon, 24 Feb 2020 01:03:21 +0100
Message-Id: <20200224000324.9333-4-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224000324.9333-1-fw@strlen.de>
References: <20200224000324.9333-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We can already handle concatenated keys, this extends concat
coverage to the data type as well, i.e. this can be dissected:

type ipv4_addr : ipv4_addr . inet_service

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index e41289631380..0c6b8c58238b 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -169,6 +169,9 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 				nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_CHAIN,
 						   nld.chain, strlen(nld.chain));
 			break;
+		case EXPR_CONCAT:
+			assert(nld.len > 0);
+			/* fallthrough */
 		case EXPR_VALUE:
 			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_DATA,
 					   nld.value, nld.len);
@@ -1005,6 +1008,10 @@ key_end:
 					  NFT_REG_VERDICT : NFT_REG_1);
 		datatype_set(data, set->data->dtype);
 		data->byteorder = set->data->byteorder;
+
+		if (set->data->dtype->subtypes)
+			data = netlink_parse_concat_elem(set->data->dtype, data);
+
 		if (data->byteorder == BYTEORDER_HOST_ENDIAN)
 			mpz_switch_byteorder(data->value, data->len / BITS_PER_BYTE);
 
-- 
2.24.1

