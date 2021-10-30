Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BB7C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E14EE60FD9
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhJ3QrK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhJ3QrH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:47:07 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A221BC061203
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XIbHk59mPmB2MkZ2y3h2D1KtzOBqwEYnam2G0Op1BE4=; b=V3d1nPhcwd1ygSPSUbRw3v7hcA
        1iDZpEyV7glOCBo3gtGoL9OqvZFcIWMpqdDS1kls5fdD+oJCZWNoRkfMA/nbQ7wuTIljQA3wI6Jse
        5d3cuMP10P5nubdbFD8OU/wSeJzMHZ9cTseixt1KPraLF528uL+jNh1yubljAopVxcDqAMziNHVEz
        efskFGFrNX8nb3/t3f08FhfdY0kCXuhEmcMPKOaH3Sqww1tKA+VZlNvBSe3Zvr63ftqCa+LToSTUT
        Irowws0c4/OnnQNexo3IMrJ/0nNTOirNYw7UyMnlqNr4k1CFm4SaJlCTYynn/LDob2YgmcXAS8+hF
        d4HaVPVA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT8-00AFgT-Pw
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 07/26] db: add missing `break` to switch-case.
Date:   Sat, 30 Oct 2021 17:44:13 +0100
Message-Id: <20211030164432.1140896-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030164432.1140896-1-jeremy@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
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

