Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8993EC63703
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLHAQV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 19:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHAQV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 19:16:21 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42B37E409
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 16:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5OCWdkiMl/AVlIh884jcnj+oUwdhmzxkpVaqMHMX4TY=; b=DQGnrmdaJxWcLzqNK9D4+Ic280
        hmPJwHsys+QLfgTnrrbMy/+PhlnVecCaN5WICg7F12UuUQryuavWr3zVop5ABgm8fM6E5CvGk373X
        OK9njoH3G5WjVWcyuynYTjVuQg1sOzsmYD1rsgqQllSNpKA0XtsC7jHP+hoXpriKyk8bfm3OnOKjO
        7rCocXDkwV2ZRb3AjMvv9JVsadJlj7PnP0+PEsRDpO7y5u2gMf8d7PIJMWDVG12jMmLpuT/xSngwT
        aE4kzY2Fj4PwUWlUlMvJbNWLPP7/+KwMBZO7T1pmvrvCD8aGfivLiPBQXNWi0HnQ7YqhONdBOOg8K
        yDZoqEIA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p34aD-0005WD-Vv; Thu, 08 Dec 2022 01:16:14 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ipset PATCH] Makefile: Create LZMA-compressed dist-files
Date:   Thu,  8 Dec 2022 01:16:05 +0100
Message-Id: <20221208001605.24217-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use a more modern alternative to gzip.

Suggested-by: Jan Engelhardt <jengelh@inai.de>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index e94f4db9710d4..543afb0104154 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,7 +4,7 @@ AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADER([config.h])
-AM_INIT_AUTOMAKE([foreign subdir-objects tar-pax])
+AM_INIT_AUTOMAKE([foreign subdir-objects tar-pax no-dist-gzip dist-xz])
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 AC_PROG_LN_S
-- 
2.38.0

