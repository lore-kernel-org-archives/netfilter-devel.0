Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E520C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbiKWQoF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239137AbiKWQoE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:44:04 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40522B24B
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bxMthyCTYh1HhEfaqaJ7ErvVwBiuQZvO4lzCcKHTj8c=; b=A6lGPnH1VhM15NFUedWX2P6YGs
        cr6r9132IuEOGDeCAJ7LpN+rhWhsGPc8+rB+5RvVkDbdPjKgKv6bXL9+4t4GdS5hcFZW/vACXeGW7
        zxZqJyz9v58WaaL3GjBFrMew9CQKMPMnsLTL3893bY+hH2sDwHg8tyh+zpgZAi/3hjeytnGjTKoKa
        qniGadcy2RISeZC165Y0RvM+LJgJ4PlTCf4aqM7x+9JhKrcz5z6VohkV9Dw6dqSg5isqptO8orGvu
        8qUhX9UTc9K2BIuQ7sw01CWijOlBQxCjbGPmwLFCv7z3qiIQupNk6P5iWkxrvvbVun0FUDQg31sng
        QHXLaDbA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsqs-0003wm-Qz
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:43:58 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 07/13] extensions: TCPMSS: Use xlate callback for IPv6, too
Date:   Wed, 23 Nov 2022 17:43:44 +0100
Message-Id: <20221123164350.10502-8-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Data structures are identical and the translation is layer3-agnostic.

Fixes: bebce197adb42 ("iptables: iptables-compat translation for TCPMSS")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_TCPMSS.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index 0d9b200ebc72f..251a5532a838b 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -131,6 +131,7 @@ static struct xtables_target tcpmss_tg_reg[] = {
 		.x6_parse      = TCPMSS_parse,
 		.x6_fcheck     = TCPMSS_check,
 		.x6_options    = TCPMSS6_opts,
+		.xlate         = TCPMSS_xlate,
 	},
 };
 
-- 
2.38.0

