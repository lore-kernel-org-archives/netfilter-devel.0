Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F65DC55178
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 512B420720
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:17:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="s3x5PIbN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416213AbgJYNRS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 09:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894311AbgJYNRR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 09:17:17 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4194CC0613CE
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 06:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ddIkmwyIxuGA7rz9Dd+Wulfk5a4Zw05Tm7rJdZmVM6I=; b=s3x5PIbNcIQ2XqBbPgvNoYWNhH
        iI/FtJdg7xu8b+nrMK1yRnuit/WJ089Whb+gXlaQzE1xcRMdZPd8ZoK3OdR67NLeA+DFpxy19ZXHu
        apK7wLoZyRQOX5uYi820aWyACMl2uYGMleJDlmqh49g57pUB3jwCP2xyfckcRtl+vlXdZu/4EDZI+
        7XXsBzNIZFHH4KOS4mwFc8H3IqKr+uYQGE2n2uPSxEXk2IwPoO+g323GH6A+/dtkZY388yCCzSaPa
        iVFWxG37gLykpgh5drcO86F3OY8YWsnTCCxu3beff4Z8wRHet3VxOl0AF6CbegmbwAWjHAYti4vlz
        zae23JfA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWfsX-0001SE-5I; Sun, 25 Oct 2020 13:16:09 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 13/13] pknock: xt_pknock: remove DEBUG definition and disable debug output.
Date:   Sun, 25 Oct 2020 13:15:59 +0000
Message-Id: <20201025131559.920038-15-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201025131559.920038-1-jeremy@azazel.net>
References: <20201025131559.920038-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The DEBUG definition in xt_pknock.h causes a compiler warning if one
adds a DEBUG define to xt_pknock.c to enable pr_debug.  Since it only
controls some debugging output in libxt_pknock.c, it would make sense to
move the definition there, but let's just disable the debugging instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/libxt_pknock.c | 4 ++--
 extensions/pknock/xt_pknock.h    | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/extensions/pknock/libxt_pknock.c b/extensions/pknock/libxt_pknock.c
index 4852e9f25a9e..1cd829333a1d 100644
--- a/extensions/pknock/libxt_pknock.c
+++ b/extensions/pknock/libxt_pknock.c
@@ -123,7 +123,7 @@ __pknock_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->ports_count = parse_ports(optarg, info->port, proto);
 		info->option |= XT_PKNOCK_KNOCKPORT;
 		*flags |= XT_PKNOCK_KNOCKPORT;
-#if DEBUG
+#ifdef DEBUG
 		printf("ports_count: %d\n", info->ports_count);
 #endif
 		break;
@@ -162,7 +162,7 @@ __pknock_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->rule_name_len = strlen(info->rule_name);
 		info->option |= XT_PKNOCK_NAME;
 		*flags |= XT_PKNOCK_NAME;
-#if DEBUG
+#ifdef DEBUG
 		printf("info->rule_name: %s\n", info->rule_name);
 #endif
 		break;
diff --git a/extensions/pknock/xt_pknock.h b/extensions/pknock/xt_pknock.h
index d44905b44e0d..fb201df49e82 100644
--- a/extensions/pknock/xt_pknock.h
+++ b/extensions/pknock/xt_pknock.h
@@ -29,8 +29,6 @@ enum {
 	XT_PKNOCK_MAX_PASSWD_LEN = 31,
 };
 
-#define DEBUG 1
-
 struct xt_pknock_mtinfo {
 	char rule_name[XT_PKNOCK_MAX_BUF_LEN+1];
 	uint32_t			rule_name_len;
-- 
2.28.0

