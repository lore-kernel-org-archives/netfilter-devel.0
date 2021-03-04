Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE608C433E6
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 01:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B03CF651AA
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 01:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhCDBct (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbhCDBcm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 20:32:42 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0107C061761
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Mar 2021 17:32:01 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id A069C891B0;
        Thu,  4 Mar 2021 14:31:57 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1614821517;
        bh=ieQ7b5wNrnu8y/4bsKz/gQmkGPRgNlEIbpHLpIANBM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=aVPp4jxLHH0vaiF7XPWZbqQEtzjmuRigNoem0dowtF55/9CW1aDT9bnLKvZhy4+OA
         jSCvKiFiEgx7cR4darBN5GgdvikCRGvlqxfASftqeVXs2AeSCIJPTNPf01KC92C1Cx
         ip91EsP8EkqU1VxOesJDyNCb6GYolH8plOybqHj2fAuj/A8+rsi9Yl3tVy+fWtbpll
         3mKQY+f331Qq1VHAe+q0chOb/NO5D2LGIsyEuyPvjYWzMhMJgE/un95f0NCJWm1D4B
         eKlqMJKkTszkmbf1gq6HDo30dbvNLJhHtCrnEpfu9YHRg5UfJ7Cq87Ss+5Gqaf0N9b
         ze6g3H/URzrxA==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6040388d0003>; Thu, 04 Mar 2021 14:31:57 +1300
Received: from markto-dl.ws.atlnz.lc (markto-dl.ws.atlnz.lc [10.33.23.25])
        by smtp (Postfix) with ESMTP id 67F1913EF39;
        Thu,  4 Mar 2021 14:32:08 +1300 (NZDT)
Received: by markto-dl.ws.atlnz.lc (Postfix, from userid 1155)
        id 483F1341002; Thu,  4 Mar 2021 14:31:57 +1300 (NZDT)
From:   Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Subject: [PATCH 3/3] netfilter: x_tables: Use correct memory barriers.
Date:   Thu,  4 Mar 2021 14:31:16 +1300
Message-Id: <20210304013116.8420-4-mark.tomlinson@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304013116.8420-1-mark.tomlinson@alliedtelesis.co.nz>
References: <20210304013116.8420-1-mark.tomlinson@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7uXNjH+ c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=dESyimp9J3IA:10 a=Ma0BngSExibuLm0IY5UA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When a new table value was assigned, it was followed by a write memory
barrier. This ensured that all writes before this point would complete
before any writes after this point. However, to determine whether the
rules are unused, the sequence counter is read. To ensure that all
writes have been done before these reads, a full memory barrier is
needed, not just a write memory barrier. The same argument applies when
incrementing the counter, before the rules are read.

Changing to using smp_mb() instead of smp_wmb() fixes the kernel panic
reported in cc00bcaa5899, while still maintaining the same speed of
replacing tables.

Fixes: 7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")
Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
---
 include/linux/netfilter/x_tables.h | 2 +-
 net/netfilter/x_tables.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter=
/x_tables.h
index 5deb099d156d..8ec48466410a 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -376,7 +376,7 @@ static inline unsigned int xt_write_recseq_begin(void=
)
 	 * since addend is most likely 1
 	 */
 	__this_cpu_add(xt_recseq.sequence, addend);
-	smp_wmb();
+	smp_mb();
=20
 	return addend;
 }
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index af22dbe85e2c..a2b50596b87e 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1387,7 +1387,7 @@ xt_replace_table(struct xt_table *table,
 	table->private =3D newinfo;
=20
 	/* make sure all cpus see new ->private value */
-	smp_wmb();
+	smp_mb();
=20
 	/*
 	 * Even though table entries have now been swapped, other CPU's
--=20
2.30.1

