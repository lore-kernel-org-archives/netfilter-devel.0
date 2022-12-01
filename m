Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06ED0C47088
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 16:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiLAQkR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 11:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbiLAQj6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 11:39:58 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C02FAA8D4
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 08:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oltnq2cQR4bW61KzjwX1IsyY9cQZ0Aum/Wbu/PjuqNg=; b=gTFqHJ9lXdwpKguZXDCutNB+ZB
        pCayETs/M+mV5HUMJvk8+e/R1m26RQK2eFgKAELDNpwLl3+YkEUhFO3zNDVJ4+7aXGNkL5I9/VKKx
        vaCE4y3VG30xaozXsJO4TwQyvaaZVmzO3PN8TdQGNa+O6Dmn13BW+F7ay6vv98SDH4GM/qBZpykDS
        +hVN/4Ecd4ECZzStadS0EKklZvs3WAWBvWTIOYrbDvCP+kOLIxLLJy2yT1ZUtFIztLofKshRbFIX7
        W9jq5RHquLBsaua2tJOpDoH4N7hyk0xILsGTa3IgtAI/JBKTwKyPRnhASmxiHdQhUnkHRQ1H6yCr6
        WgYRbuLQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0mb6-0002Xw-Oy; Thu, 01 Dec 2022 17:39:40 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 4/7] nft: Fix match generator for '! -i +'
Date:   Thu,  1 Dec 2022 17:39:13 +0100
Message-Id: <20221201163916.30808-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221201163916.30808-1-phil@nwl.cc>
References: <20221201163916.30808-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's actually nonsense since it will never match, but iptables accepts
it and the resulting nftables rule must behave identically. Reuse the
solution implemented into xtables-translate (by commit e179e87a1179e)
and turn the above match into 'iifname INVAL/D'.

The commit this fixes merely ignored the fact that "any interface" match
might be inverted.

Fixes: 0a8635183edd0 ("xtables-compat: ignore '+' interface name")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index e812a9bcae466..bcb6ada34e0fb 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -168,6 +168,9 @@ void add_iniface(struct nft_handle *h, struct nftnl_rule *r,
 	if (iface[iface_len - 1] == '+') {
 		if (iface_len > 1)
 			add_cmp_ptr(r, op, iface, iface_len - 1, reg);
+		else if (op != NFT_CMP_EQ)
+			add_cmp_ptr(r, NFT_CMP_EQ, "INVAL/D",
+				    strlen("INVAL/D") + 1, reg);
 	} else {
 		add_cmp_ptr(r, op, iface, iface_len + 1, reg);
 	}
@@ -185,6 +188,9 @@ void add_outiface(struct nft_handle *h, struct nftnl_rule *r,
 	if (iface[iface_len - 1] == '+') {
 		if (iface_len > 1)
 			add_cmp_ptr(r, op, iface, iface_len - 1, reg);
+		else if (op != NFT_CMP_EQ)
+			add_cmp_ptr(r, NFT_CMP_EQ, "INVAL/D",
+				    strlen("INVAL/D") + 1, reg);
 	} else {
 		add_cmp_ptr(r, op, iface, iface_len + 1, reg);
 	}
-- 
2.38.0

