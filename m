Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 143A9C4332D
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 20:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C708564F4D
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Mar 2021 20:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhCRT7t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Mar 2021 15:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbhCRT7Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 15:59:24 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C3CC06174A
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Mar 2021 12:59:23 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 95A00891AC
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Mar 2021 08:59:19 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1616097559;
        bh=94go4m7RgBmX+uhM/bUM9hCCjhlZ2xuRTRiB/tgOdvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=K8L/PHS43ydJjd/cMRg4GTbb8C/pYxdEwQWO0kAVEJFCGxCuUEP5lHCEwgIMf9+qn
         8e8kMsNZtpYZjwNxdm54Tk2SIISxlz7VrmmUuDbasY2F+jVbffg9jHjwV4BE+///rX
         8vBViPg8IGsfAf0LdrcOOAncDOXRp/d+gCdDvSwpJjyhPXM8JGroZisYYeHC2zQM+2
         IuETR/fuhsEIjfsZDCeqkWknVjGYPD2xXhnQdvBXTSkzF1emILpK1zvdDKlw3RIb7G
         7j7rMdq7z+b3LLGNHxg6SeYAUAyYNLqAPz+yUeO/dFg9fE4lkxrYvz7ZSGaf0+0zEi
         ZtYVXoW15SHOA==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6053b1170000>; Fri, 19 Mar 2021 08:59:19 +1300
Received: from luukp-dl.ws.atlnz.lc (luukp-dl.ws.atlnz.lc [10.33.25.16])
        by smtp (Postfix) with ESMTP id 03A9213EF08;
        Fri, 19 Mar 2021 08:59:34 +1300 (NZDT)
Received: by luukp-dl.ws.atlnz.lc (Postfix, from userid 1137)
        id 7A6084C046C; Fri, 19 Mar 2021 08:59:19 +1300 (NZDT)
From:   Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
To:     netfilter-devel@vger.kernel.org
Cc:     Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
Subject: [PATCH libnetfilter_conntrack] conntrack: Don't use ICMP attrs in decision to build repl tuple
Date:   Fri, 19 Mar 2021 08:59:19 +1300
Message-Id: <20210318195919.29620-1-luuk.paulussen@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210318130138.GC22603@breakpoint.cc>
References: <20210318130138.GC22603@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=GfppYjfL c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=dESyimp9J3IA:10 a=kkZtijosPqtj5OvUxF4A:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

conntrack-tools doesn't set the REPL attributes by default for updates,
so for ICMP flows, the update won't be sent as building the repl tuple
will fail.

Signed-off-by: Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
---
 src/conntrack/build_mnl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/src/conntrack/build_mnl.c b/src/conntrack/build_mnl.c
index d9ad268..0067a1c 100644
--- a/src/conntrack/build_mnl.c
+++ b/src/conntrack/build_mnl.c
@@ -496,10 +496,7 @@ nfct_nlmsg_build(struct nlmsghdr *nlh, const struct =
nf_conntrack *ct)
 	    test_bit(ATTR_REPL_PORT_DST, ct->head.set) ||
 	    test_bit(ATTR_REPL_L3PROTO, ct->head.set) ||
 	    test_bit(ATTR_REPL_L4PROTO, ct->head.set) ||
-	    test_bit(ATTR_REPL_ZONE, ct->head.set) ||
-	    test_bit(ATTR_ICMP_TYPE, ct->head.set) ||
-	    test_bit(ATTR_ICMP_CODE, ct->head.set) ||
-	    test_bit(ATTR_ICMP_ID, ct->head.set)) {
+	    test_bit(ATTR_REPL_ZONE, ct->head.set)) {
 		const struct __nfct_tuple *t =3D &ct->repl;
 		struct nlattr *nest;
=20
--=20
2.31.0

