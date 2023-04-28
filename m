Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE90C77B61
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Apr 2023 13:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346028AbjD1NA3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Apr 2023 09:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjD1NA2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2023 09:00:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D7A269F
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2023 06:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iuzHJjMf/pdGxEUkShfveYUzlybi5izCMyEecH14kac=; b=I4z6wUZuuUSkWiwBk1Sp5DxU7n
        HZ6iHbeP8QGifw4c0QAAb4Pqsd8zmEdqxLIA7Hv+gZZCu+fenwKDSLdT63JDCSSZqQkCXhvV0Ro45
        lGUuN81M+4bo/4gOkNcJ1yd49eopPTpbemURVI8Q4iVk8oRoX3Wu4c7B6nwux/FXoOLmGgmd3J5zW
        XicD2mgo5x27AX5zPpryK3MtEk+FKVTeONU8FIWACn+3hzSgYkQFHTYJ0S/m55uAxbZjZ++mOswDq
        0vfzpVCuVhUlciMaJlDic/8WgYxUISWQHWTq6uxLvyjYYNCpO1k5zN3iTfvAHJhDcEbSHYr1300mE
        rfIP3MhQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1psNi5-0001zo-Sj
        for netfilter-devel@vger.kernel.org; Fri, 28 Apr 2023 15:00:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] arptables: Fix parsing of inverted 'arp operation' match
Date:   Fri, 28 Apr 2023 15:05:29 +0200
Message-Id: <20230428130531.14195-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The wrong bit was set in 'invflags', probably due to copy'n'paste from
the previous case.

Fixes: 84909d171585d ("xtables: bootstrap ARP compatibility layer for nftables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 8963573a72e9e..a8e49f442c6d7 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -244,7 +244,7 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		fw->arp.arhln = ar_hln;
 		fw->arp.arhln_mask = 0xff;
 		if (inv)
-			fw->arp.invflags |= IPT_INV_ARPOP;
+			fw->arp.invflags |= IPT_INV_ARPHLN;
 		break;
 	case offsetof(struct arphdr, ar_pln):
 		get_cmp_data(e, &ar_pln, sizeof(ar_pln), &inv);
-- 
2.40.0

