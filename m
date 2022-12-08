Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04B7C4708D
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiLHAG1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 19:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiLHAG0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 19:06:26 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFB8633F
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 16:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=p5FLej7A+STkaJzmlF4BRj09DYQeBJ9PSIVSUQIxi3o=; b=ByYKQXM8MqnO+p03oKloensF39
        qVGReSzovdYD+MRXXzRsBDybJ1HqFjBZ1B7oycxASJdKSo+R78LukBlHQqtO82xWHXTMgsfTbVWel
        VM414wqR0JV/CdwASztMsb+DUXRHAefpltOdTJzGdWSDiqj24uzrQgAdQyR7vD8aDRdktYR2ap4Sd
        zN/Hxki+SBA1l3Pr3PswBVFsaPyD5trcUQ1j0JNiyVsjO8Pdc8x1jwhkq5tkI6FoPPxI08siQWWQM
        K0C9DWbPEt1zJJP4LhsQCRRcYmDaa8V/0Mk9kcjMXi0Mf4DC5cIC6quZIIMf1LKAC8n2t6qq4mrvt
        h+uMcmmg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p34Qi-0005P7-5A; Thu, 08 Dec 2022 01:06:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [libnftnl PATCH] Makefile: Create LZMA-compressed dist-files
Date:   Thu,  8 Dec 2022 01:06:15 +0100
Message-Id: <20221208000615.13772-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use a more modern alternative to bzip2.

Suggested-by: Jan Engelhardt <jengelh@inai.de>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 394c68dfe0580..66830989c040a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -7,7 +7,7 @@ AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADERS([config.h])
 m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 
-AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2
+AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-xz
 	1.6 subdir-objects])
 
 dnl kernel style compile messages
-- 
2.38.0

