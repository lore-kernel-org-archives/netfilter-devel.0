Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABFBC3F2C6
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 05:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E258620717
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 05:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583212129;
	bh=ZS3bZpQ+Cbse6gx8MRxnC78v7gZj6LWH6FyPdy0z9+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=EjkicQWU97p+jeI0f3j6DCuM77E0z3OqvyDJE7QjXLVruFSbdBD5zWv5uiYPesEI1
	 6iYR6nSxAqYYq36xkU8abRJ25sNcLqQTwnBzIYm7bol3gZGHTvoHSN/qkeHrOgZWGz
	 Ua4VS72OAnJP+YNCAt2K5w4d/kr2q26KIGhItrf4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgCCFIp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 00:08:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgCCFIp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 00:08:45 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A020F2465A;
        Tue,  3 Mar 2020 05:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583212124;
        bh=ZS3bZpQ+Cbse6gx8MRxnC78v7gZj6LWH6FyPdy0z9+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQ6QkIjUkyTnrynKyLKaHe/NvncPdPep7RjJDNDQ15EUxMo/b01yCLm9DGYgoW/4E
         4OfgyJ/XqsCF1cOz0lztSjFN4BV0AP0P1t20lHBxfDGVE+DMD4yffnNSad9XBHsbQG
         6rZy79Jgj/vvSdrG0Kc3b2zsJeTCbak5XqRLMXR4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH netfilter 2/3] netfilter: add missing attribute validation for payload csum flags
Date:   Mon,  2 Mar 2020 21:08:32 -0800
Message-Id: <20200303050833.4089193-3-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050833.4089193-1-kuba@kernel.org>
References: <20200303050833.4089193-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add missing attribute validation for NFTA_PAYLOAD_CSUM_FLAGS
to the netlink policy.

Fixes: 1814096980bb ("netfilter: nft_payload: layer 4 checksum adjustment for pseudoheader fields")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netfilter/nft_payload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 1993af3a2979..a7de3a58f553 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -129,6 +129,7 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
 	[NFTA_PAYLOAD_LEN]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_CSUM_TYPE]	= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_CSUM_OFFSET]	= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_CSUM_FLAGS]	= { .type = NLA_U32 },
 };
 
 static int nft_payload_init(const struct nft_ctx *ctx,
-- 
2.24.1

