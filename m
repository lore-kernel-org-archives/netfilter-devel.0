Return-Path: <SRS0=kxmZ=T6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765FFC28CC4
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 10:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5129C257A0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 May 2019 10:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfE3Kzm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 May 2019 06:55:42 -0400
Received: from mail.us.es ([193.147.175.20]:35372 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbfE3Kzl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 May 2019 06:55:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E7CD1C1DF2
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 12:55:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8E01DA70D
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2019 12:55:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CE49FDA708; Thu, 30 May 2019 12:55:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D811EDA70C;
        Thu, 30 May 2019 12:55:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 May 2019 12:55:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A923E4265A5B;
        Thu, 30 May 2019 12:55:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft,v2 7/7] erec: remove double \n on error when internal_netlink is used
Date:   Thu, 30 May 2019 12:55:29 +0200
Message-Id: <20190530105529.12657-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530105529.12657-1-pablo@netfilter.org>
References: <20190530105529.12657-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove double empty line linebreak when printing internal errors.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/erec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/erec.c b/src/erec.c
index 617c04ade178..cf543a980bc0 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -161,7 +161,6 @@ void erec_print(struct output_ctx *octx, const struct error_record *erec,
 			loc = &erec->locations[l];
 			netlink_dump_expr(loc->nle, f, debug_mask);
 		}
-		fprintf(f, "\n\n");
 		return;
 	}
 
-- 
2.11.0

