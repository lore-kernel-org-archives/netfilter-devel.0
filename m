Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B83C43332
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3727220775
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 21:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584565680;
	bh=+3PT5ixSSczOWYJFYGUU1q4HgAMEEfKeUtxBoxFqb20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CD4CAkKaR6X/uD8seFMdd+ks4xeX38C39OMRFHRAmZSJ0F/ECNG1zr1knQu2Nmrrd
	 FbfJYCRhdkO4EpJHn9lM968Qfhv25fpC+fUciKXwpQ+hynUsX3BFcq8BJkIaNF5QFb
	 E8aSy5M75ggpaJwsfaWqBaDH9NPZC14xiPLi3X3g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgCRVH6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 17:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbgCRUyJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D27292098B;
        Wed, 18 Mar 2020 20:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564848;
        bh=+3PT5ixSSczOWYJFYGUU1q4HgAMEEfKeUtxBoxFqb20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UknWaNHzdJBWeiPr8MQFiRXhbaHfEIerLhru2B1ZJvKAt5zNC9v13B7nqbJ5SiGvq
         OUWCnMVudzpiOrOi9bP9r1B1gNG1u/VXq8Vhqq37+wGXmgj3DBeFEf/sCO+8OfyIMU
         dGfFtMBAQpmY2M4UFLLeats0u5ZAHQVSKZwV73BY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 26/73] netfilter: nf_tables: dump NFTA_CHAIN_FLAGS attribute
Date:   Wed, 18 Mar 2020 16:52:50 -0400
Message-Id: <20200318205337.16279-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d78008de6103c708171baff9650a7862645d23b0 ]

Missing NFTA_CHAIN_FLAGS netlink attribute when dumping basechain
definitions.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 23544842b6923..bd76ef77c03f5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1309,6 +1309,11 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 					      lockdep_commit_lock_is_held(net));
 		if (nft_dump_stats(skb, stats))
 			goto nla_put_failure;
+
+		if ((chain->flags & NFT_CHAIN_HW_OFFLOAD) &&
+		    nla_put_be32(skb, NFTA_CHAIN_FLAGS,
+				 htonl(NFT_CHAIN_HW_OFFLOAD)))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_be32(skb, NFTA_CHAIN_USE, htonl(chain->use)))
-- 
2.20.1

