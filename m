Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8154CC3F2C6
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 09:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F96F20848
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 09:48:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="jEe94zOa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgCCJss (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 04:48:48 -0500
Received: from kadath.azazel.net ([81.187.231.250]:40816 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728008AbgCCJsr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 04:48:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=N1zk6cahTgFooK8dCxqdymPg6AU8EeWJllvDrVRP0ig=; b=jEe94zOaELg0fLDJ1q9nNe1zCk
        HwujwdBqio3SyTljJTZ3HBMxCWdhTD/f4YD0qQ7Jkv37IxP3ML9eYsvPh8ZmAYFAeBZunMT/VxF9T
        Mp1rlt1DaTVPVW/zffz3ghpXp2V+zTmXlRdZYTS4osJHe3t9o3pFXLZlPjVith6GdqQzePjK7VD+d
        ALJl5CbSLax+P7wGGIEDQ8A3paqYaIR/8Nxclxp2efKq6cptRI7rjmMvNfsbw+vejGXrFaLqbNLrw
        i0FzaybRUl+tvpPQq+SM9UVSdV2Lc6a2LOxe9sPUhAn+SscDLzgNMdKdQYW/SLHVPg8yeRNoGp2PA
        0Hxipevg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j94AP-00081M-C1; Tue, 03 Mar 2020 09:48:45 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 04/18] evaluate: convert the byte-order of payload statement arguments.
Date:   Tue,  3 Mar 2020 09:48:30 +0000
Message-Id: <20200303094844.26694-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303094844.26694-1-jeremy@azazel.net>
References: <20200303094844.26694-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since shift operations require host byte-order, we need to be able to
convert the result of the shift back to network byte-order, in a rule
like:

  nft add rule ip t c tcp dport set tcp dport lshift 1

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index a169e41bd833..9b1a04f26f44 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2225,6 +2225,11 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 			      payload->byteorder, &stmt->payload.val) < 0)
 		return -1;
 
+	if (!expr_is_constant(stmt->payload.val) &&
+	    byteorder_conversion(ctx, &stmt->payload.val,
+				 payload->byteorder) < 0)
+		return -1;
+
 	need_csum = stmt_evaluate_payload_need_csum(payload);
 
 	if (!payload_needs_adjustment(payload)) {
-- 
2.25.1

