Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDCBC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239092AbiKWQpN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239110AbiKWQpL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:45:11 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3525C285B
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=c3XIb962xjAo/rwMUQTOM8G33P8LTpfhat6Z2toE/bA=; b=eFNYDsyDnbXKB8paxUk6E0biwc
        P3fErtgFXyhdOPKtv6Ctt7vs7Zdz8L4pCKIvqbs+WsqS5MiB2xkw4awGqNJvM5SsnKfKIP6KbM9MH
        U8e5kwEcLbfMTwQ02ITQrFQwgfSMjxSizOzNCRdV0sjTCSllEdP2Cy5PCEbTY3532Uk2UnwIMbrSn
        ZPeM6+v3+nFPQTIctP1GuqI0Tg5mtQRPqFKeeIFMRLYcTT9O54Ee1j4iqFjh3xI7D2zJ5a0z2Hfnb
        8/i6mDES7ElIzS8uEJDNpUgzz0kYW1fbJTmIgzcx9Gg5Kx7TXnkkljnPd4SYSaAVXYC9XeqMT/8lQ
        hcJ5vvoA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxss0-00040H-2y
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:45:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 05/13] extensions: CONNMARK: Fix xlate callback
Date:   Wed, 23 Nov 2022 17:43:42 +0100
Message-Id: <20221123164350.10502-6-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bail out if nfmask != ctmask with XT_CONNMARK_SAVE and
XT_CONNMARK_RESTORE. Looks like this needs a similar implementation to
the one for XT_CONNMARK_SET.

Fix shift mark translation: xt_connmark_shift_ops does not contain
useful strings for nftables. Also add needed braces around the term
being shifted.

Fixes: db7b4e0de960c ("extensions: libxt_CONNMARK: Support bit-shifting for --restore,set and save-mark")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_CONNMARK.c      | 15 ++++++++++-----
 extensions/libxt_CONNMARK.txlate |  3 +++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 21e1091386294..a6568c99b6c4d 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -595,11 +595,11 @@ static int connmark_tg_xlate_v2(struct xt_xlate *xl,
 {
 	const struct xt_connmark_tginfo2 *info =
 		(const void *)params->target->data;
-	const char *shift_op = xt_connmark_shift_ops[info->shift_dir];
+	const char *braces = info->shift_bits ? "( " : "";
 
 	switch (info->mode) {
 	case XT_CONNMARK_SET:
-		xt_xlate_add(xl, "ct mark set ");
+		xt_xlate_add(xl, "ct mark set %s", braces);
 		if (info->ctmask == 0xFFFFFFFFU)
 			xt_xlate_add(xl, "0x%x ", info->ctmark);
 		else if (info->ctmark == 0)
@@ -615,26 +615,31 @@ static int connmark_tg_xlate_v2(struct xt_xlate *xl,
 				     info->ctmark, ~info->ctmask);
 		break;
 	case XT_CONNMARK_SAVE:
-		xt_xlate_add(xl, "ct mark set mark");
+		xt_xlate_add(xl, "ct mark set %smark", braces);
 		if (!(info->nfmask == UINT32_MAX &&
 		    info->ctmask == UINT32_MAX)) {
 			if (info->nfmask == info->ctmask)
 				xt_xlate_add(xl, " and 0x%x", info->nfmask);
+			else
+				return 0;
 		}
 		break;
 	case XT_CONNMARK_RESTORE:
-		xt_xlate_add(xl, "meta mark set ct mark");
+		xt_xlate_add(xl, "meta mark set %sct mark", braces);
 		if (!(info->nfmask == UINT32_MAX &&
 		    info->ctmask == UINT32_MAX)) {
 			if (info->nfmask == info->ctmask)
 				xt_xlate_add(xl, " and 0x%x", info->nfmask);
+			else
+				return 0;
 		}
 		break;
 	}
 
 	if (info->mode <= XT_CONNMARK_RESTORE &&
 	    info->shift_bits != 0) {
-		xt_xlate_add(xl, " %s %u", shift_op, info->shift_bits);
+		xt_xlate_add(xl, " ) %s %u",
+			     info->shift_dir ? ">>" : "<<", info->shift_bits);
 	}
 
 	return 1;
diff --git a/extensions/libxt_CONNMARK.txlate b/extensions/libxt_CONNMARK.txlate
index ce40ae5ea65e0..99627c2b05d45 100644
--- a/extensions/libxt_CONNMARK.txlate
+++ b/extensions/libxt_CONNMARK.txlate
@@ -18,3 +18,6 @@ nft add rule ip mangle PREROUTING counter ct mark set mark
 
 iptables-translate -t mangle -A PREROUTING -j CONNMARK --restore-mark
 nft add rule ip mangle PREROUTING counter meta mark set ct mark
+
+iptables-translate -t mangle -A PREROUTING  -j CONNMARK --set-mark 0x23/0x42 --right-shift-mark 5
+nft add rule ip mangle PREROUTING counter ct mark set ( ct mark xor 0x23 and 0xffffff9c ) >> 5
-- 
2.38.0

