Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE698C4332B
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 01:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99E8465146
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 01:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbhCHBZN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Mar 2021 20:25:13 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:45548 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbhCHBYk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Mar 2021 20:24:40 -0500
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id E0864891B0;
        Mon,  8 Mar 2021 14:24:34 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1615166674;
        bh=vZT52xbfVfFNHbppq3XxQvqLpy688PuIoObPORnqI5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Xd+qdLDARhZ+PIdweC93dg4dUlAJW8MfbBwqfLEBe1aOJZaMy7hn99L1HbG23ZGiQ
         2qgdajDIlrp6P4sOuUOocvJaCuQt/O0g4MuKqNE+lKJTWujrigkJUP2Mb3beg/X8T5
         uDby+SI4EXnakWMTPnC4P4b3WmGMijFzUs71lop9W8t8uyIavM76EbsmZm9m5uRzO4
         Hh+6s29HGzK7eIBH06tms1M8aV7QIQaqFyP8b57JcjnMuXfvz1DbFRnHiBxOYX3pIU
         YsVwdBbtKoKlUtGMRBVzPRqER5sGlXCGMs++vcH70703t+s/QFjvoIJ1w+NuzpODlX
         gyKnkHOdCqYJA==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60457cd20003>; Mon, 08 Mar 2021 14:24:34 +1300
Received: from markto-dl.ws.atlnz.lc (markto-dl.ws.atlnz.lc [10.33.23.25])
        by smtp (Postfix) with ESMTP id 957F413EFA5;
        Mon,  8 Mar 2021 14:24:46 +1300 (NZDT)
Received: by markto-dl.ws.atlnz.lc (Postfix, from userid 1155)
        id 9FA84340F85; Mon,  8 Mar 2021 14:24:34 +1300 (NZDT)
From:   Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     subashab@codeaurora.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Subject: [PATCH v2 3/3] netfilter: x_tables: Use correct memory barriers.
Date:   Mon,  8 Mar 2021 14:24:13 +1300
Message-Id: <20210308012413.14383-4-mark.tomlinson@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308012413.14383-1-mark.tomlinson@alliedtelesis.co.nz>
References: <20210308012413.14383-1-mark.tomlinson@alliedtelesis.co.nz>
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
reported in cc00bcaa5899 (which is still present), while still
maintaining the same speed of replacing tables.

The smb_mb() barriers potentially slow the packet path, however testing
has shown no measurable change in performance on a 4-core MIPS64
platform.

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

