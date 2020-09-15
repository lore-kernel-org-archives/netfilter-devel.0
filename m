Return-Path: <SRS0=y7Ah=CY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F91DC433E2
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Sep 2020 02:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8000520678
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Sep 2020 02:14:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="hOXdmUk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgIOCOy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Sep 2020 22:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOCOu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Sep 2020 22:14:50 -0400
X-Greylist: delayed 356 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Sep 2020 19:14:49 PDT
Received: from forward105j.mail.yandex.net (forward105j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5DDC06174A
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Sep 2020 19:14:49 -0700 (PDT)
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward105j.mail.yandex.net (Yandex) with ESMTP id 811EEB20C4A
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Sep 2020 05:08:43 +0300 (MSK)
Received: from mxback6q.mail.yandex.net (mxback6q.mail.yandex.net [IPv6:2a02:6b8:c0e:42:0:640:9de5:975f])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id 77CDA61E0005
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Sep 2020 05:08:43 +0300 (MSK)
Received: from vla3-b0c95643f530.qloud-c.yandex.net (vla3-b0c95643f530.qloud-c.yandex.net [2a02:6b8:c15:341d:0:640:b0c9:5643])
        by mxback6q.mail.yandex.net (mxback/Yandex) with ESMTP id 8rm7QJl11a-8h2mPhwF;
        Tue, 15 Sep 2020 05:08:43 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1600135723;
        bh=trinj5Ci42LOmAJI7eMtKVPL9Ote7lla+hamvDNXUCg=;
        h=Subject:To:From:Message-Id:Cc:Date;
        b=hOXdmUk2BSvZUisRZ33u3grq4DUuDwBc/BqRZcqTvAH4wQfFQKIRxkGEPmeczv2Bl
         WyNB20Ga9gdU/wKx+dkMgH72nVyZ9m9vnAJoiDtGfOoIAFHa8eObehiGu8O5/AsDty
         YTi44rXxUY9QKR07gup89Mb+Ps5RbVziK2RURatI=
Authentication-Results: mxback6q.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla3-b0c95643f530.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id CExPGOtIGs-8gm0SYMJ;
        Tue, 15 Sep 2020 05:08:42 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   igo95862 <igo95862@yandex.ru>
To:     netfilter-devel@vger.kernel.org
Cc:     igo95862 <igo95862@yandex.ru>
Subject: [PATCH libmnl] doxygen: Fixed link to the git source tree on the website.
Date:   Mon, 14 Sep 2020 19:08:26 -0700
Message-Id: <20200915020826.67909-1-igo95862@yandex.ru>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Old link no longer worked.
Also upgraded it to https.
---
 src/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/socket.c b/src/socket.c
index d7c67a8..dbfb06c 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -59,7 +59,7 @@
  *
  * \section scm Git Tree
  * The current development version of libmnl can be accessed at:
- * http://git.netfilter.org/cgi-bin/gitweb.cgi?p=libmnl.git;a=summary
+ * https://git.netfilter.org/libmnl/
  *
  * \section using Using libmnl
  * You can access several example files under examples/ in the libmnl source
-- 
2.28.0

