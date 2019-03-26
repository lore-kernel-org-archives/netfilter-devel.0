Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 394E4C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 12:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00EED2075E
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 12:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbfCZMOz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 08:14:55 -0400
Received: from mail.us.es ([193.147.175.20]:41754 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfCZMOz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 08:14:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 48CFD190F63
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2019 13:14:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 336C4DA54D
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2019 13:14:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 28914DA87E; Tue, 26 Mar 2019 13:14:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C01E6DA864
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2019 13:14:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 26 Mar 2019 13:14:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9933D4265A5F
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Mar 2019 13:14:49 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: skip binary transfer for named sets
Date:   Tue, 26 Mar 2019 13:14:45 +0100
Message-Id: <20190326121445.22801-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

May be empty, content might be yet unknown, we can do any transfer in
this case.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1327
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Will try to scratch time to make a test for this, otherwise anyone sending
patches to extend to coverage for this, it would be great.

 src/evaluate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 54afc3340186..94377da99335 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1606,6 +1606,9 @@ static int __binop_transfer(struct eval_ctx *ctx,
 		}
 		break;
 	case EXPR_SET_REF:
+		if (!((*right)->set->flags & NFT_SET_ANONYMOUS))
+			return 0;
+
 		return __binop_transfer(ctx, left, &(*right)->set->init);
 	default:
 		return 0;
-- 
2.11.0

