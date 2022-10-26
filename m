Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB995C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Oct 2022 13:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbiJZNXb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Oct 2022 09:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiJZNWw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Oct 2022 09:22:52 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4214E58E96;
        Wed, 26 Oct 2022 06:22:51 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 05/10] netfilter: nft_payload: access ipip payload for inner offset
Date:   Wed, 26 Oct 2022 15:22:22 +0200
Message-Id: <20221026132227.3287-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221026132227.3287-1-pablo@netfilter.org>
References: <20221026132227.3287-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ipip is an special case, transport and inner header offset are set to
the same offset to use the upcoming inner expression for matching on
inner tunnel headers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 03a1f271bf4f..84b490d6cc75 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -132,6 +132,9 @@ static int __nft_payload_inner_offset(struct nft_pktinfo *pkt)
 		pkt->inneroff = thoff + offset;
 		}
 		break;
+	case IPPROTO_IPIP:
+		pkt->inneroff = thoff;
+		break;
 	default:
 		return -1;
 	}
-- 
2.30.2

