Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF017C3F2D9
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 14:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9F6A20732
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 14:48:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="tjh6RME0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCEOsH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 09:48:07 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55988 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgCEOsH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 09:48:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=588MaH2mbkcUYmpder6Q/BG9kgHzd9x67fxTFC4Rljo=; b=tjh6RME0fyc4j2vDBM5U8Y/W/s
        qXVWJahk34AAwsjn07cofMDq3xZTzKUcz0sHel+rdB7UECHnyV5M7dglfNzWjXPvoYGVRwGlPEF9a
        JH7j/6KqlvO9Yv7UEgCbj7XCe3I317xupgnaIqvCCgmwN/0J1pYwMmDgjoSYZL+fKN0cztlnu7l6g
        boa8MibMuxcO+aCC+/MZYr1KISe0NY9WYiDy4aW80gVg9r5Hf+RLsup+vIJy1v1KkjOJa8rJmnfmv
        7RH+6TpVGHsGgShcLtw7SXLs3tymkOPAE23lqqHuzWjrT8ZzSIp6+46fBGL58DFE0AMGQk1e/CgNg
        v9O75E2A==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j9rnB-0006kU-J8; Thu, 05 Mar 2020 14:48:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 2/4] main: include '--reversedns' in help.
Date:   Thu,  5 Mar 2020 14:48:03 +0000
Message-Id: <20200305144805.143783-3-jeremy@azazel.net>
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

The long option for '-N' was omitted from the help.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/main.c b/src/main.c
index 3e37d600e38b..d00c7ec2b687 100644
--- a/src/main.c
+++ b/src/main.c
@@ -153,7 +153,7 @@ static void show_help(const char *name)
 "  -s, --stateless			Omit stateful information of ruleset.\n"
 "  -t, --terse				Omit contents of sets.\n"
 "  -u, --guid				Print UID/GID as defined in /etc/passwd and /etc/group.\n"
-"  -N					Translate IP addresses to names.\n"
+"  -N, --reversedns			Translate IP addresses to names.\n"
 "  -S, --service				Translate ports to service names as described in /etc/services.\n"
 "  -p, --numeric-protocol		Print layer 4 protocols numerically.\n"
 "  -y, --numeric-priority		Print chain priority numerically.\n"
-- 
2.25.1

