Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13EFC3F2CD
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 14:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9679B20732
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 14:48:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="MrUuh2kH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCEOsH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 09:48:07 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55984 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgCEOsH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 09:48:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SV9al90o40wPbWIVNmqk011x1TUcmeKMIMpkjiwB4Ew=; b=MrUuh2kHaj8w2iBl6DlartyBSx
        xhSXLGDh3p18mWDXXjI/o03rKnSWUwfgKtJVNsviluIBuwcY4avIRnmBW74SR1bwVs87w2lsFoyCC
        Pa069CrdrdEuXZtN87JWeklTZ6tu68aQEvNstrkcwE8ru2yn6G9LJxh8qOslUbucgk22pQ7Oq4q51
        b9TFMZFStol/Sn3Q0PQTtj47rkXF32XnwGCUiMuTVY/m8U1+kJFHV1BOKfCYaukJ0UG/P9qJXqd3m
        TycNL/iCR/54I78Ae7PP9ykNa3z2sGmU7AUDO+jnVSTYRSrNzFTnJSR0ihBw9AJi6eDouMH0SLfqh
        eGOkt4dA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j9rnB-0006kU-Nj; Thu, 05 Mar 2020 14:48:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 3/4] main: interpolate default include path into help format-string.
Date:   Thu,  5 Mar 2020 14:48:04 +0000
Message-Id: <20200305144805.143783-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200305144805.143783-1-jeremy@azazel.net>
References: <20200305144805.143783-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The default include path is a string literal defined as a preprocessor
macro by autoconf.  We can just interpolate it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/main.c b/src/main.c
index d00c7ec2b687..4e9a2ed3bcec 100644
--- a/src/main.c
+++ b/src/main.c
@@ -160,10 +160,10 @@ static void show_help(const char *name)
 "  -T, --numeric-time			Print time values numerically.\n"
 "  -a, --handle				Output rule handle.\n"
 "  -e, --echo				Echo what has been added, inserted or replaced.\n"
-"  -I, --includepath <directory>		Add <directory> to the paths searched for include files. Default is: %s\n"
+"  -I, --includepath <directory>		Add <directory> to the paths searched for include files. Default is: " DEFAULT_INCLUDE_PATH "\n"
 "  -d, --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
 "\n",
-	name, DEFAULT_INCLUDE_PATH);
+	name);
 }
 
 static void show_version(void)
-- 
2.25.1

