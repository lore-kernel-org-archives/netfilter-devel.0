Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57B2C4167B
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Nov 2023 03:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjKHDbj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 22:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjKHDbi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 22:31:38 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C82F10F6
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 19:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=x2Mf7EBrpEFp2xcoy9Gj2KASy8A+5dy0caypd7Mr0YQ=; b=aTTj9/xtPKsjS20r+DoRlLKPSE
        4UB18z54s8VYshDGYaNcdxN4YrxScOW6pmbDiXxWN6Uu+yp5RH54xjT8w1YIFwHPbVGJ4iZOG7xHc
        mrmNGad7IaEKo3MZr7LNvVROr5ppEea0MwIC8t7AhYApNwOuNPE+QtIMBQkXfKNtu3ZvKvprvVFf7
        aYD2OYvSfVrrob9exVUenaPACIMEcaaxFe/pto3UPfGj7DIZUNrhgg2/hKUjw4WGMTbiA9pjdfEFT
        kSxmfkUw12jGXyKsA67oRGtwIQGY3v5kydd8UkF0ozWVWc9hLaF1bbYLwUH5j7UEvXfBMyaMkUpv7
        YCdvAy8w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r0ZHy-0002NE-Ou; Wed, 08 Nov 2023 04:31:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] arptables: Fix formatting of numeric --h-type output
Date:   Wed,  8 Nov 2023 04:31:28 +0100
Message-ID: <20231108033130.18747-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Arptables expects numeric arguments to --h-type option in hexadecimal
form, even if no '0x'-prefix is present. In contrast, it prints such
values in decimal. This is not just inconsistent, but makes it
impossible to save and later restore a ruleset without fixing up the
values in between.

Assuming that the parser side can't be changed for compatibility
reasons, fix the output side instead.

This is a day 1 bug and present in legacy arptables as well, so treat
this as a "feature" of arptables-nft and omit a Fixes: tag.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libarpt_standard.t | 4 +++-
 iptables/nft-arp.c            | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/extensions/libarpt_standard.t b/extensions/libarpt_standard.t
index 007fa2b8335e8..a2b0a36a4a6bf 100644
--- a/extensions/libarpt_standard.t
+++ b/extensions/libarpt_standard.t
@@ -13,4 +13,6 @@
 --source-mac Unicast;--src-mac 00:00:00:00:00:00/01:00:00:00:00:00;OK
 ! --src-mac Multicast;! --src-mac 01:00:00:00:00:00/01:00:00:00:00:00;OK
 --src-mac=01:02:03:04:05:06 --dst-mac=07:08:09:0A:0B:0C --h-length=6 --opcode=Request --h-type=Ethernet --proto-type=ipv4;--src-mac 01:02:03:04:05:06 --dst-mac 07:08:09:0a:0b:0c --opcode 1 --proto-type 0x800;OK
---src-mac ! 01:02:03:04:05:06 --dst-mac ! 07:08:09:0A:0B:0C --h-length ! 6 --opcode ! Request --h-type ! Ethernet --proto-type ! ipv4;! --src-mac 01:02:03:04:05:06 ! --dst-mac 07:08:09:0a:0b:0c ! --h-length 6 ! --opcode 1 ! --h-type 1 ! --proto-type 0x800;OK
+--src-mac ! 01:02:03:04:05:06 --dst-mac ! 07:08:09:0A:0B:0C --h-length ! 6 --opcode ! Request --h-type ! Ethernet --proto-type ! ipv4;! --src-mac 01:02:03:04:05:06 ! --dst-mac 07:08:09:0a:0b:0c ! --h-length 6 ! --opcode 1 ! --h-type 0x1 ! --proto-type 0x800;OK
+--h-type 10;--h-type 0x10;OK
+--h-type 0x10;=;OK
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 8521cc4f15c1d..83aec5003004e 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -323,9 +323,9 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 		if (tmp == 1 && !(format & FMT_NUMERIC))
 			printf("--h-type %s", "Ethernet");
 		else
-			printf("--h-type %u", tmp);
+			printf("--h-type 0x%x", tmp);
 		if (fw->arp.arhrd_mask != 65535)
-			printf("/%d", ntohs(fw->arp.arhrd_mask));
+			printf("/0x%x", ntohs(fw->arp.arhrd_mask));
 		sep = " ";
 	}
 
-- 
2.41.0

