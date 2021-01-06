Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC498C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Jan 2021 13:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EA022311E
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Jan 2021 13:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbhAFNbZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 08:31:25 -0500
Received: from correo.us.es ([193.147.175.20]:56470 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbhAFNbZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 08:31:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B5048FC5E8
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Jan 2021 14:30:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A642BDA73D
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Jan 2021 14:30:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9982DDA704; Wed,  6 Jan 2021 14:30:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64BAADA73D
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Jan 2021 14:30:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Jan 2021 14:30:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 3F62A426CC85
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Jan 2021 14:30:03 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] main: fix typo in cli definition
Date:   Wed,  6 Jan 2021 14:30:35 +0100
Message-Id: <20210106133035.14816-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210106133035.14816-1-pablo@netfilter.org>
References: <20210106133035.14816-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

9420423900a2 ("cli: add libedit support") updated HAVE_LIBREADLINE to
HAVE_READLINE by mistake.

Fixes: 9420423900a2 ("cli: add libedit support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/main.c b/src/main.c
index 0a1c47758d1a..80cf1acf0f7f 100644
--- a/src/main.c
+++ b/src/main.c
@@ -227,7 +227,7 @@ static void show_version(void)
 {
 	const char *cli, *minigmp, *json, *xt;
 
-#if defined(HAVE_READLINE)
+#if defined(HAVE_LIBREADLINE)
 	cli = "readline";
 #elif defined(HAVE_LIBEDIT)
 	cli = "editline";
-- 
2.20.1

