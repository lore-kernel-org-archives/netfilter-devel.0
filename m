Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1EDC83F3D
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 20:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237179AbjHaUO0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 16:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjHaUO0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 16:14:26 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C238E5B;
        Thu, 31 Aug 2023 13:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TTslTaZ5HzoC+zUIw5ARo7h1D/26reV8B9qJm0rhXqk=; b=l2uGHOZ+ge0xZ1ermRQ8mTiF9Q
        hcjJALpMarK2SiTvacYAvmbFsCKqMOr/nBtGSjAvmVvrvJ3gBeZDYhHZD1yiz0TK8W6psc8+CbDWV
        ff8EvrP05UXZ0uPXJUxBzBhjBdgm0p1IAPrfOxGL+vmRynNbwrwZz27hzmbBCjwGNxKI=;
Received: from p4ff13705.dip0.t-ipconnect.de ([79.241.55.5] helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1qbo3Z-00EqrU-IC; Thu, 31 Aug 2023 22:14:21 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC] netfilter: nf_tables: ignore -EOPNOTSUPP on flowtable device offload setup
Date:   Thu, 31 Aug 2023 22:14:20 +0200
Message-ID: <20230831201420.63178-1-nbd@nbd.name>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On many embedded devices, it is common to configure flowtable offloading for
a mix of different devices, some of which have hardware offload support and
some of which don't.
The current code limits the ability of user space to properly set up such a
configuration by only allowing adding devices with hardware offload support to
a offload-enabled flowtable.
Given that offload-enabled flowtables also imply fallback to pure software
offloading, this limitation makes little sense.
Fix it by not bailing out when the offload setup returns -EOPNOTSUPP

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 41b826dff6f5..dfa2ea98088b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8103,7 +8103,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 		err = flowtable->data.type->setup(&flowtable->data,
 						  hook->ops.dev,
 						  FLOW_BLOCK_BIND);
-		if (err < 0)
+		if (err < 0 && err != -EOPNOTSUPP)
 			goto err_unregister_net_hooks;
 
 		err = nf_register_net_hook(net, &hook->ops);
-- 
2.41.0

