Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4357AC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Oct 2022 23:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiJAXj2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Oct 2022 19:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJAXj1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Oct 2022 19:39:27 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1772CE35
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Oct 2022 16:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jufXAelwRvswf1jCGfzuuE0qgFcKLiTXyNB5kWH+yic=; b=geCNbbffCKh8WhPmucY5ZgClDN
        FPBFWPfViw6kZmvlgiqMMgDuShDuJL64TcnAkfpga9NS2oe6oOY7Xnsbsjw80L4pQwNV4DcZzHEa2
        jK/LjIHWlR17/XJEzj5KpbyVg4KGZp/i7yZZP2GL5snVUxSmaDjk1Eraz1c43h0ciX3aMINyN9dkB
        gYVf2E0NE+lzSWPluHMD4KaHz1rRcMgEocLLjfn5UkHuqs+XyzXGuQmREQpXSrc72aRd6O6KkGDoZ
        78adn+PNel/z/rWwSj5qRORpAU0Hty0+2DCKzr8DV0osZjyg2FPI+YPsnZW6ouyTiFAU9/rk1HF1x
        sw6TDGhQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oem4r-0004qQ-Cp
        for netfilter-devel@vger.kernel.org; Sun, 02 Oct 2022 01:39:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] extensions: libip6t_dst: Fix output for empty options
Date:   Sun,  2 Oct 2022 01:39:05 +0200
Message-Id: <20221001233906.5386-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221001233906.5386-1-phil@nwl.cc>
References: <20221001233906.5386-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If no --dst-opts were given, print_options() would print just a
whitespace.

Fixes: 73866357e4a7a ("iptables: do not print trailing whitespaces")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_dst.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index bf0e3e436665d..baa010f56ac22 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -125,15 +125,15 @@ static void
 print_options(unsigned int optsnr, uint16_t *optsp)
 {
 	unsigned int i;
+	char sep = ' ';
 
-	printf(" ");
 	for(i = 0; i < optsnr; i++) {
-		printf("%d", (optsp[i] & 0xFF00) >> 8);
+		printf("%c%d", sep, (optsp[i] & 0xFF00) >> 8);
 
 		if ((optsp[i] & 0x00FF) != 0x00FF)
 			printf(":%d", (optsp[i] & 0x00FF));
 
-		printf("%c", (i != optsnr - 1) ? ',' : ' ');
+		sep = ',';
 	}
 }
 
-- 
2.34.1

