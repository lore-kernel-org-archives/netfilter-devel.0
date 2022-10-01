Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD86AC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Oct 2022 11:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiJALvZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Oct 2022 07:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJALvY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Oct 2022 07:51:24 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C8B3912D
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Oct 2022 04:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FTqJtUkaY4Mgggx52QNDA40fDub06qx8kf09CEJ3OFk=; b=m2hKPFnhLVRuR/FGlxrdVVQdTv
        HxNIVVkTIMFCETB2gNqMZDiaTIm5oXci+MNKYz6Ef9Emv7Y4F68nc+Xy8+5gVUmS5W57oJ6fJGIRq
        gI8/RToNVIip4YsVMnPMuvYYj8FXHugOmWw8xqD9BGl/vmCpQsyXaZVn4lveJpMM1dZF1OIvicV4u
        BtvZua1eCoNmCVQxDJ3DT7FkuuFIBqpHK6xWENB2xJYoeYPC54RJs6s6cacmdk+IyTFWyrUNeTCh5
        xQxOUuajy/CYr+qFwyrjGziy6FAgkKgEYjw+73kToS4KfPDjSySgtYNtXWPAu/J3lEqq/rYi6AzLX
        K0U9Y5NA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oeb1c-0007bE-3d
        for netfilter-devel@vger.kernel.org; Sat, 01 Oct 2022 13:51:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] extensions: among: Remove pointless fall through
Date:   Sat,  1 Oct 2022 13:51:10 +0200
Message-Id: <20221001115111.23923-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This seems to be a leftover from an earlier version of the switch().
This fall through is never effective as the next case's code will never
apply. So just break instead.

Fixes: 26753888720d8 ("nft: bridge: Rudimental among extension support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_among.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/extensions/libebt_among.c b/extensions/libebt_among.c
index 7eb898f984bba..c607a775539d3 100644
--- a/extensions/libebt_among.c
+++ b/extensions/libebt_among.c
@@ -152,10 +152,9 @@ static int bramong_parse(int c, char **argv, int invert,
 			xtables_error(PARAMETER_PROBLEM,
 				      "File should only contain one line");
 		optarg[flen-1] = '\0';
-		/* fall through */
+		break;
 	case AMONG_DST:
-		if (c == AMONG_DST)
-			dst = true;
+		dst = true;
 		/* fall through */
 	case AMONG_SRC:
 		break;
-- 
2.34.1

