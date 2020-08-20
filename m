Return-Path: <SRS0=xTVu=B6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C4AC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 12:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0F6A207BB
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 12:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgHTMNf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Aug 2020 08:13:35 -0400
Received: from correo.us.es ([193.147.175.20]:54394 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728115AbgHTMNX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Aug 2020 08:13:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C5471BFA80
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 14:13:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E974DA73D
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 14:13:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 844A8DA78B; Thu, 20 Aug 2020 14:13:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4545ADA73D
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 14:13:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Aug 2020 14:13:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 317BF42EE38E
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 14:13:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: nf_tables: add NFTA_SET_USERDATA if not null
Date:   Thu, 20 Aug 2020 14:12:54 +0200
Message-Id: <20200820121255.25047-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel sends an empty NFTA_SET_USERDATA attribute with no value if
userspace adds a set no NFTA_SET_USERDATA attribute.

Fixes: e6d8ecac9e68 ("netfilter: nf_tables: Add new attributes into nft_set to store user data.")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fd814e514f94..71e501c5ad21 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3770,7 +3770,8 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			goto nla_put_failure;
 	}
 
-	if (nla_put(skb, NFTA_SET_USERDATA, set->udlen, set->udata))
+	if (set->udata &&
+	    nla_put(skb, NFTA_SET_USERDATA, set->udlen, set->udata))
 		goto nla_put_failure;
 
 	nest = nla_nest_start_noflag(skb, NFTA_SET_DESC);
-- 
2.20.1

