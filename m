Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862F1C04FF3
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 May 2021 20:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 574E76140F
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 May 2021 20:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhEXVAu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 May 2021 17:00:50 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:37427 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbhEXVAu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 May 2021 17:00:50 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 2BA27806B6;
        Tue, 25 May 2021 08:59:20 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1621889960;
        bh=Lzr0rvT0QiR/MSanCIoDpGseeQuHYrnQA7phMXYVWqM=;
        h=From:To:Cc:Subject:Date;
        b=MccHvznwkl96bw44qw2IizQrc7HfQwfhshFuknp3YYaCiz81wngB1uuc/4CrFVUcT
         oAyjpib1xfW/tNiui1GWSKCK1F2E5svN8DUDtpIUFlOsSKZ/QysPehX0SxgLqT0CkK
         ZBtZo33Hxd12TF3GabEfDBUeLwnaXa6BpRAkGuE0tDEJnUnCu62GP8Z1mQMMfLV5zh
         w3MPVZTRQ9KkfMnxvPwgUdsisMTa8jNtoQ+KmksAdt4ziuEUM63I7Q4slEQOn21PFy
         l/h+OUbehAmUC2JcRvIVwj9Z04RH3ngiMKGnWhSr0MZk2SOWiUPcuRsoOt74+uXS+z
         FvdB9FCr26gFA==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60ac13a80000>; Tue, 25 May 2021 08:59:20 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id 09FD313EE13;
        Tue, 25 May 2021 08:59:20 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id 0436E242926; Tue, 25 May 2021 08:59:19 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Subject: [ulogd2 PATCH] ulogd: printpkt: print pkt mark like kernel
Date:   Tue, 25 May 2021 08:59:13 +1200
Message-Id: <20210524205913.18411-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=WOcBoUkR c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=5FLXtPjwQuUA:10 a=cpdOJPDBj458GZFaqJAA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Print the pkt mark in hex with a preceding '0x', like the kernel prints
pkts logged by netfilter.

Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
---
 util/printpkt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/printpkt.c b/util/printpkt.c
index 2aacddb..b9b47b2 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -474,7 +474,7 @@ int printpkt_print(struct ulogd_key *res, char *buf)
 		buf_cur +=3D sprintf(buf_cur, "GID=3D%u ",
 				   ikey_get_u32(&res[KEY_OOB_GID]));
 	if (pp_is_valid(res, KEY_OOB_MARK))
-		buf_cur +=3D sprintf(buf_cur, "MARK=3D%x ",
+		buf_cur +=3D sprintf(buf_cur, "MARK=3D0x%x ",
 				   ikey_get_u32(&res[KEY_OOB_MARK]));
=20
 	strcat(buf_cur, "\n");
--=20
2.31.1

