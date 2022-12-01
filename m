Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81496C43217
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 16:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiLAQjw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 11:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbiLAQjm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 11:39:42 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5B8ABA26
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 08:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8MiXdSTh59U3zi4GOCGTAWexm9qF2BA3zPouhoKHGxk=; b=bCBbeRm25IOVOJNhHQBkKW5CV3
        ANpycBN/Tpj/TMhBORykYYlBYCJaLBy/wUWdPP4fE4+/Jp9Hkeo0bFoyccTJ4jYftWS7Q1gxf9aUu
        A6Zewg9fp3zSeBlAJ1g4tqDGUiYU1nD7vI4hIAXyhzL+QbxJyh71CdnK0LHsUbdg78naIkznCy49o
        qYCAP+hPFDpy0ao4F9BjpW3NICWe8mviXckdzD41EDTOgOjJ/7/HakpgFYEksXbREDcqon2prCqpZ
        YhEhRECWoQQ/TR5PxkaOnWrHxw2d7e4yyCNdiPzxO+My/2JfKQLeJVihH/T6VI305TfibLb/G+1n8
        sjwpS2sQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0maq-0002Xf-Pw; Thu, 01 Dec 2022 17:39:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 7/7] ebtables: Fix MAC address match translation
Date:   Thu,  1 Dec 2022 17:39:16 +0100
Message-Id: <20221201163916.30808-8-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221201163916.30808-1-phil@nwl.cc>
References: <20221201163916.30808-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a mask was present, ebtables-translate would emit illegal syntax.

Fixes: 5e2b473a64bc7 ("xtables-compat: extend generic tests for masks and wildcards")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/generic.txlate | 2 +-
 iptables/nft-bridge.c     | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/generic.txlate b/extensions/generic.txlate
index d7ddf6a39762e..c24ed1568884b 100644
--- a/extensions/generic.txlate
+++ b/extensions/generic.txlate
@@ -65,7 +65,7 @@ ebtables-translate -A FORWARD ! -i iname --logical-in ilogname -o out+ --logical
 nft 'add rule bridge filter FORWARD iifname != "iname" meta ibrname "ilogname" oifname "out*" meta obrname "lout*" ether daddr 01:02:03:04:de:af counter'
 
 ebtables-translate -I INPUT -p ip -d 1:2:3:4:5:6/ff:ff:ff:ff:00:00
-nft 'insert rule bridge filter INPUT ether type 0x800 ether daddr 01:02:03:04:00:00 and ff:ff:ff:ff:00:00 == 01:02:03:04:00:00 counter'
+nft 'insert rule bridge filter INPUT ether type 0x800 ether daddr and ff:ff:ff:ff:00:00 == 01:02:03:04:00:00 counter'
 
 ebtables-translate -I INPUT -p Length
 nft 'insert rule bridge filter INPUT ether type < 0x0600 counter'
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 15dfc585c14ab..8ab21bb54772b 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -861,17 +861,17 @@ static void nft_bridge_xlate_mac(struct xt_xlate *xl, const char *type, bool inv
 
 	xt_xlate_add(xl, "ether %s %s", type, invert ? "!= " : "");
 
-	xlate_mac(xl, mac);
-
 	if (memcmp(mask, one_msk, ETH_ALEN)) {
 		int i;
-		xt_xlate_add(xl, " and ");
+		xt_xlate_add(xl, "and");
 
 		xlate_mac(xl, mask);
 
 		xt_xlate_add(xl, " == %02x", mac[0] & mask[0]);
 		for (i=1; i < ETH_ALEN; i++)
 			xt_xlate_add(xl, ":%02x", mac[i] & mask[i]);
+	} else {
+		xlate_mac(xl, mac);
 	}
 }
 
-- 
2.38.0

