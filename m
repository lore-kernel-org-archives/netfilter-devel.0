Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909F5C4321E
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:01:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7115460F93
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhJ3QEW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbhJ3QER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:04:17 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C39CC06120A
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1V1KxcEQBgYrEh73YzmfC8Qn8apbMMUgXwuJ2JuCcGM=; b=XF2BNEFNWI+B7pkU8rM+DYiXcX
        faRVES2cl9NAS1D/8RTTe23wBUsEJqlfHbaRRZTDuDzToLilko23AVy+wuko5AlXV0YIaDiTsMmap
        aQN+A5LNnB+fI2/Ef6RAwC32Ccz3ULb4IH1X/QmLISRjXeHBgkC2jj9CXK08lEyZ32S8emMzrYfk7
        ndK8FdN5gjkHdnb7nWoAePQZy+kS1UcBU+QY0XizR+n7EK7lzpo3wPC7UnCjlBqmlefNHsHexR2/0
        I0tSC2aLnYYX6GyRq5nyHocCG7J6oLIfialUgCvXuLV7fzdWwjIalAoBNprp4vALIjmEPeqcCGhuN
        9Xa1fsEg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgqnf-00AFQk-Iz
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:01:43 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 02/13] gitignore: ignore util/.dirstamp
Date:   Sat, 30 Oct 2021 17:01:30 +0100
Message-Id: <20211030160141.1132819-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030160141.1132819-1-jeremy@azazel.net>
References: <20211030160141.1132819-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 3f218218dfc9..fd2189de5748 100644
--- a/.gitignore
+++ b/.gitignore
@@ -27,3 +27,4 @@ TAGS
 /doc/ulogd.*
 !/doc/ulogd.sgml
 ulogd.conf.5
+/util/.dirstamp
-- 
2.33.0

