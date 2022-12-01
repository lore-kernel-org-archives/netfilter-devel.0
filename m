Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 775F7C47088
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 16:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiLAQk2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 11:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbiLAQkB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 11:40:01 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7C89B78A
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 08:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PfQrRpa/8M13nBs0aYWzDfdnSx0qky8BdPJwjSIS/xs=; b=lTJPmP2j8ulYn+lmTbfSddFadT
        nCM00nBaX57X2lhP8AFRcq+ZV5tLX1rNiDv/c6LwwWvjavyU59aDkoW5otPydAdnmpdMfB2G3f9yb
        B9DacB2imGnzjKwHPJ9cEhSo29ulflNaByRR9pm0LDH+XmmsJvNNiEpkFtttzoACTkHNGOR3bHo/p
        pFGbRmYRHuBqDM5GKSdiLLtcsP/n6Dw/hSPIkVUQip6yztl7I640HDLD1ADihgMxZ5qiSy7bc64c9
        JiyEdPXmCNPk4AoQAIKFGyG7vDxlOnvGGt6EpIvUbJ6WF/cU7VSl9NTyCG2DFbtgY6F3q6SRHe8Wh
        OQ6p2OOQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0mbC-0002Y7-2i; Thu, 01 Dec 2022 17:39:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 6/7] xtables-translate: Fix for interfaces with asterisk mid-string
Date:   Thu,  1 Dec 2022 17:39:15 +0100
Message-Id: <20221201163916.30808-7-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221201163916.30808-1-phil@nwl.cc>
References: <20221201163916.30808-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For nft, asterisk is special at end of the interface name only. Escaping
it mid-string makes the escape char part of the interface name, so avoid
this.

In the test case, also drop the ticks around interface names in
*-translate command - since there's no shell involved which would eat
them, they become part of the interface name.

Fixes: e179e87a1179e ("xtables-translate: Fix for interface name corner-cases")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/generic.txlate    | 14 +++++++-------
 iptables/xtables-translate.c |  4 +++-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/extensions/generic.txlate b/extensions/generic.txlate
index 7e879fd526bb1..d7ddf6a39762e 100644
--- a/extensions/generic.txlate
+++ b/extensions/generic.txlate
@@ -74,17 +74,17 @@ ebtables-translate -I INPUT -p ! Length
 nft 'insert rule bridge filter INPUT ether type >= 0x0600 counter'
 
 # asterisk is not special in iptables and it is even a valid interface name
-iptables-translate -A FORWARD -i '*' -o 'eth*foo'
-nft 'add rule ip filter FORWARD iifname "\*" oifname "eth\*foo" counter'
+iptables-translate -A FORWARD -i * -o eth*foo
+nft 'add rule ip filter FORWARD iifname "\*" oifname "eth*foo" counter'
 
-# escape all asterisks but translate only the first plus character
-iptables-translate -A FORWARD -i 'eth*foo*+' -o 'eth++'
-nft 'add rule ip filter FORWARD iifname "eth\*foo\**" oifname "eth+*" counter'
+# escape only suffix asterisk and translate only the last plus character
+iptables-translate -A FORWARD -i eth*foo*+ -o eth++
+nft 'add rule ip filter FORWARD iifname "eth*foo**" oifname "eth+*" counter'
 
 # skip for always matching interface names
-iptables-translate -A FORWARD -i '+'
+iptables-translate -A FORWARD -i +
 nft 'add rule ip filter FORWARD counter'
 
 # match against invalid interface name to simulate never matching rule
-iptables-translate -A FORWARD ! -i '+'
+iptables-translate -A FORWARD ! -i +
 nft 'add rule ip filter FORWARD iifname "INVAL/D" counter'
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 6b71fcef74b9c..07d6ee40cf727 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -41,7 +41,9 @@ void xlate_ifname(struct xt_xlate *xl, const char *nftmeta, const char *ifname,
 	for (i = 0, j = 0; i < ifaclen + 1; i++, j++) {
 		switch (ifname[i]) {
 		case '*':
-			iface[j++] = '\\';
+			/* asterisk is non-special mid-string */
+			if (i == ifaclen - 1)
+				iface[j++] = '\\';
 			/* fall through */
 		default:
 			iface[j] = ifname[i];
-- 
2.38.0

