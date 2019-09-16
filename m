Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E62C49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 07:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E7222067B
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 07:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfIPHdl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 03:33:41 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34286 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPHdl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 03:33:41 -0400
Received: from sf.home (unknown [85.255.236.110])
        (using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: slyfox)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 547E034B21E;
        Mon, 16 Sep 2019 07:33:40 +0000 (UTC)
Received: by sf.home (Postfix, from userid 1000)
        id 6671324CB5A47; Mon, 16 Sep 2019 08:33:33 +0100 (BST)
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Sergei Trofimovich <slyfox@gentoo.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] nftables: don't crash in 'list ruleset' if policy is not set
Date:   Mon, 16 Sep 2019 08:33:20 +0100
Message-Id: <20190916073320.2799091-1-slyfox@gentoo.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Minimal reproducer:

```
  $ cat nft.ruleset
    # filters
    table inet filter {
        chain prerouting {
            type filter hook prerouting priority -50
        }
    }

    # dump new state
    list ruleset

  $ nft -c -f ./nft.ruleset
    table inet filter {
    chain prerouting {
    Segmentation fault (core dumped)
```

The crash happens in `chain_print_declaration()`:

```
    if (chain->flags & CHAIN_F_BASECHAIN) {
        mpz_export_data(&policy, chain->policy->value,
                        BYTEORDER_HOST_ENDIAN, sizeof(int));
```

Here `chain->policy` is `NULL` (as textual rule does not mention it).

The change is not to print the policy if it's not set
(similar to `chain_evaluate()` handling).

CC: Florian Westphal <fw@strlen.de>
CC: Pablo Neira Ayuso <pablo@netfilter.org>
CC: netfilter-devel@vger.kernel.org
Bug: https://bugzilla.netfilter.org/show_bug.cgi?id=1365
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 src/rule.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 5bb1c1d3..0cc1fa59 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1107,17 +1107,21 @@ static void chain_print_declaration(const struct chain *chain,
 		nft_print(octx, " # handle %" PRIu64, chain->handle.handle.id);
 	nft_print(octx, "\n");
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		mpz_export_data(&policy, chain->policy->value,
-				BYTEORDER_HOST_ENDIAN, sizeof(int));
 		nft_print(octx, "\t\ttype %s hook %s", chain->type,
 			  hooknum2str(chain->handle.family, chain->hooknum));
 		if (chain->dev != NULL)
 			nft_print(octx, " device \"%s\"", chain->dev);
-		nft_print(octx, " priority %s; policy %s;\n",
+		nft_print(octx, " priority %s;",
 			  prio2str(octx, priobuf, sizeof(priobuf),
 				   chain->handle.family, chain->hooknum,
-				   chain->priority.expr),
-			  chain_policy2str(policy));
+				   chain->priority.expr));
+		if (chain->policy) {
+			mpz_export_data(&policy, chain->policy->value,
+					BYTEORDER_HOST_ENDIAN, sizeof(int));
+			nft_print(octx, " policy %s;",
+				  chain_policy2str(policy));
+		}
+		nft_print(octx, "\n");
 	}
 }
 
-- 
2.23.0

