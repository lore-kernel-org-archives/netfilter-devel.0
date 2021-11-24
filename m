Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA99BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344384AbhKXW2J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344009AbhKXW2A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:28:00 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90184C06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Amt29jxp87u6n/DjPlkhLKoZyc5pkmCe89FsGOlwNpQ=; b=oJOJLygX2H5+pPwH7fTD9gQny2
        2+cVkiWY92KZfXjVa72JNUJe0nr2spPyybyReGs7+mhlut0oXXwQ5zUaxgCfeSGOJ1lAAs22b+/TM
        Ljn4agkXiMlQ9vUPyS+GLbPVXqsvyR1o3ACYthSZPw8tSZ2phoBx2Z7HjZSrIGcQJc0a8NbLAmFr4
        DCL8yiSW9UtdhvL0/lNGPmZ0vspMuD0CjBIsYnbHtCE+mZBfcFGfEMfjidOHO+A05bE089BvFTc48
        C24MvShUaTWCftyhuyWutrp8pXvH4+OjRyFi09wIXg/ut0dyfbU/R37GRSJlJnv+fZTRvbb7TZX3s
        PSM/bA3Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h6-00563U-DT
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:48 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 02/32] db: add missing `break` to switch case
Date:   Wed, 24 Nov 2021 22:23:57 +0000
Message-Id: <20211124222444.2597311-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124222444.2597311-1-jeremy@azazel.net>
References: <20211124222444.2597311-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When formatting DB queries, if we get a input key of type `RAW`, we log
a message indicating that `RAW` is unsupported, then fall through to the
default case, which logs another message that the key type is unknown.
Add the missing `break` statement to prevent the fall-through.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/db.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/util/db.c b/util/db.c
index c9aec418e9ed..f0711146867f 100644
--- a/util/db.c
+++ b/util/db.c
@@ -388,6 +388,7 @@ static void __format_query_db(struct ulogd_pluginstance *upi, char *start)
 		case ULOGD_RET_RAW:
 			ulogd_log(ULOGD_NOTICE,
 				"Unsupported RAW type is unsupported in SQL output");
+			break;
 		default:
 			ulogd_log(ULOGD_NOTICE,
 				"unknown type %d for %s\n",
-- 
2.33.0

