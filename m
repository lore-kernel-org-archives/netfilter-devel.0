Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5863FC4361B
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Dec 2020 10:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 178CE230FA
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Dec 2020 10:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgLFKOS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 6 Dec 2020 05:14:18 -0500
Received: from mx1.riseup.net ([198.252.153.129]:57666 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLFKOS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Dec 2020 05:14:18 -0500
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4Cpj2V1WhgzFmZm;
        Sun,  6 Dec 2020 02:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1607249618; bh=MPJxsd/wly6TycTKdsClWvcITRPYIiTnUNRr5TKeEpk=;
        h=From:To:Cc:Subject:Date:From;
        b=d/gN7lbecInXBrOa5T+RbMaAM4YbB/8OF2gbL6eIk9iV7mtoABo50QEr1FinMZ/Ti
         TXcoPxU5Fd+B1qL7cFBYllhpFkju2OwzMsaBSc2x/mHvEOvKrtQrT4t5nfiCGVxzrF
         DaWet+nNGO1KlxK6fbuiRcjo/yDVLZIsOHR45QfA=
X-Riseup-User-ID: 8009B309F2A3EDC4C77FB4ECE89CB9885DF2B57CB88A6BE75E13E65DAB6093CB
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4Cpj2T2XbHz8tKR;
        Sun,  6 Dec 2020 02:13:35 -0800 (PST)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 1/2] monitor: add assignment check for json_echo
Date:   Sun,  6 Dec 2020 11:12:33 +0100
Message-Id: <20201206101233.641-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When --echo and --json is specified and native syntax is read, only the
last instruction is printed. This happens because the reference to the
json_echo is reassigned each time netlink_echo_callback is executed for
an instruction to be echoed.

Add an assignment check for json_echo to avoid reassigning it.

Fixes: cb7e02f4 (src: enable json echo output when reading native
syntax)
Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 src/monitor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/monitor.c b/src/monitor.c
index a733a9f0..2b5325ea 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -939,8 +939,8 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
 	if (nft_output_json(&nft->output)) {
 		if (nft->json_root)
 			return json_events_cb(nlh, &echo_monh);
-
-		json_alloc_echo(nft);
+		if (!nft->json_echo)
+			json_alloc_echo(nft);
 		echo_monh.format = NFTNL_OUTPUT_JSON;
 	}
 
-- 
2.28.0

