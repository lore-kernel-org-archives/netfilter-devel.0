Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCDCC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D343860FC0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhJ3QrI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhJ3QrG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:47:06 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753DCC061764
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oE0/xAUXUuNf1rPDQv9lkhHluFN/a3gRjJvvF+caPks=; b=ugbxTlr9pqa7LvxCDhwrJhAgcY
        GWTbyCd2MQA4gJEmvoNKImHBfj7JZdVKbvX7Vg1gK/dLRLT+lUJQ7DRWxqbAIkOd0k0uI++PfmxAh
        a2pyH/NnWWBtc9Nfr2BXk6pcemm4w8+qNtpok19vz0R/2kQlLWTpVuW6ZrrR/UPDUd7j3X/Tf6pOz
        SUntIMGId3+QTPVw20zaiV2NIK370JLIxa0QVF/irKBX6JUsuz8ROtMRBTvGn6hHmlaTFceh6BRWN
        YPt3pqxfg7WC7L3HqATxSDf7YVq6ZWRChBcvbjb808mnj3177zrFhU5fE/C2UlYJDgFqkNaUVwIBd
        77ULzZ8g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT8-00AFgT-4V
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 02/26] ulog: remove empty log-line
Date:   Sat, 30 Oct 2021 17:44:08 +0100
Message-Id: <20211030164432.1140896-3-jeremy@azazel.net>
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
 src/ulogd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 9cd64e8e19b2..a31b35592a87 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -965,7 +965,6 @@ static int create_stack(const char *option)
 		load_all_plugins();
 
 	if (!buf) {
-		ulogd_log(ULOGD_ERROR, "");
 		ret = -ENOMEM;
 		goto out_buf;
 	}
-- 
2.33.0

