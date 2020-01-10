Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2846C3F68F
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD54A20721
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 12:34:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Mbsu0oUB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgAJMei (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 07:34:38 -0500
Received: from kadath.azazel.net ([81.187.231.250]:39666 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbgAJMei (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 07:34:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1rO403jDQKn/yeHW4oXwlhEekHQARNB4rI9wGEU1nrs=; b=Mbsu0oUBgVvZTzOcCocKtPmc2n
        QDUbrZoSSIlt1+9obVlZTyTiayYV39VV5oSvP6CK6RHE5FwLycp8puGfd6ySyBKrJhgMfgpOGyl6s
        6C4hCIre4u/S6BtEt81uyWiy92CAk65JbYAviMvTjaA+kU+gYqpS6jFI5mjO35I1Lu8cJOcPohy1U
        LxpMk85IhcRouwBRdARub2F1aLxusuc39WV9EB62YoJeXRWVpfY3I7G5bbpCGcYvaVOwLkoviBtWB
        b09qAP+s6h8AE7rNCcqnFCcst6h1r6c6pSWH+F2jNv7e3NhmguiuvV1yqtu7cYTmohvz65VtQyeGD
        jiuQ3lFw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iptUq-0003du-PH
        for netfilter-devel@vger.kernel.org; Fri, 10 Jan 2020 12:34:36 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl 1/2] gitignore: add tag and Emacs back-up files.
Date:   Fri, 10 Jan 2020 12:34:35 +0000
Message-Id: <20200110123436.106488-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110123436.106488-1-jeremy@azazel.net>
References: <20200110123436.106488-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .gitignore | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/.gitignore b/.gitignore
index 1650e5853cd0..e62f850fddf6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -29,3 +29,12 @@ examples/*
 tests/*
 !tests/*.c
 !tests/Makefile.am
+
+# Tag files for Vim and Emacs.
+TAGS
+tags
+
+# Emacs back-up files
+*~
+\#*\#
+.\#*
-- 
2.24.1

