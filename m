Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1546FC432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E10A922519
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbfKTNTD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:19:03 -0500
Received: from correo.us.es ([193.147.175.20]:49282 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbfKTNTD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 08:19:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7F887130E37
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 712BCFB362
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 66C63CA0F3; Wed, 20 Nov 2019 14:18:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70DC29D628
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Nov 2019 14:18:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4DB6842EE38F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:57 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/7] netfilter: nft_objref: validate map object type
Date:   Wed, 20 Nov 2019 14:18:49 +0100
Message-Id: <20191120131854.308740-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191120131854.308740-1-pablo@netfilter.org>
References: <20191120131854.308740-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow to specify the NFTA_OBJREF_TYPE netlink attribute to validate the
object type in this reference.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_objref.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 984f5b1810be..006c2ebd898a 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -125,6 +125,7 @@ static int nft_objref_map_init(const struct nft_ctx *ctx,
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 	u8 genmask = nft_genmask_next(ctx->net);
+	u32 objtype = NFT_OBJECT_UNSPEC;
 	struct nft_set *set;
 	int err;
 
@@ -148,6 +149,13 @@ static int nft_objref_map_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	if (tb[NFTA_OBJREF_TYPE])
+		objtype = ntohl(nla_get_be32(tb[NFTA_OBJREF_TYPE]));
+
+	if (objtype != NFT_OBJECT_UNSPEC &&
+	    set->objtype != objtype)
+		return -EOPNOTSUPP;
+
 	priv->set = set;
 	return 0;
 }
-- 
2.11.0

