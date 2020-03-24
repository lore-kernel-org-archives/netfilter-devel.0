Return-Path: <SRS0=lJQT=5J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A87C18E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 22:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 729152078A
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Mar 2020 22:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgCXWcb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Mar 2020 18:32:31 -0400
Received: from correo.us.es ([193.147.175.20]:34616 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbgCXWca (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Mar 2020 18:32:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 99452FB370
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 23:31:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B21ADA7B2
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2020 23:31:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 80B36DA3A4; Tue, 24 Mar 2020 23:31:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A1E21DA38F;
        Tue, 24 Mar 2020 23:31:50 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 24 Mar 2020 23:31:50 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7D96B42EF42B;
        Tue, 24 Mar 2020 23:31:50 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/7] netfilter: nft_set_pipapo: Separate partial and complete overlap cases on insertion
Date:   Tue, 24 Mar 2020 23:32:15 +0100
Message-Id: <20200324223220.12119-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200324223220.12119-1-pablo@netfilter.org>
References: <20200324223220.12119-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

...and return -ENOTEMPTY to the front-end on collision, -EEXIST if
an identical element already exists. Together with the previous patch,
element collision will now be returned to the user as -EEXIST.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 4fc0c924ed5d..ef7e8ad2e344 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1098,21 +1098,41 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_field *f;
 	int i, bsize_max, err = 0;
 
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
+		end = (const u8 *)nft_set_ext_key_end(ext)->data;
+	else
+		end = start;
+
 	dup = pipapo_get(net, set, start, genmask);
-	if (PTR_ERR(dup) == -ENOENT) {
-		if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END)) {
-			end = (const u8 *)nft_set_ext_key_end(ext)->data;
-			dup = pipapo_get(net, set, end, nft_genmask_next(net));
-		} else {
-			end = start;
+	if (!IS_ERR(dup)) {
+		/* Check if we already have the same exact entry */
+		const struct nft_data *dup_key, *dup_end;
+
+		dup_key = nft_set_ext_key(&dup->ext);
+		if (nft_set_ext_exists(&dup->ext, NFT_SET_EXT_KEY_END))
+			dup_end = nft_set_ext_key_end(&dup->ext);
+		else
+			dup_end = dup_key;
+
+		if (!memcmp(start, dup_key->data, sizeof(*dup_key->data)) &&
+		    !memcmp(end, dup_end->data, sizeof(*dup_end->data))) {
+			*ext2 = &dup->ext;
+			return -EEXIST;
 		}
+
+		return -ENOTEMPTY;
+	}
+
+	if (PTR_ERR(dup) == -ENOENT) {
+		/* Look for partially overlapping entries */
+		dup = pipapo_get(net, set, end, nft_genmask_next(net));
 	}
 
 	if (PTR_ERR(dup) != -ENOENT) {
 		if (IS_ERR(dup))
 			return PTR_ERR(dup);
 		*ext2 = &dup->ext;
-		return -EEXIST;
+		return -ENOTEMPTY;
 	}
 
 	/* Validate */
-- 
2.11.0

