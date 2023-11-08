Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A6CC4167D
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Nov 2023 03:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjKHDbj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 22:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjKHDbh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 22:31:37 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B578018C
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 19:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uOwwDaKzg91uaRFHP+BxNKiZtTI881mmTFUDqY/29xE=; b=P2vMXmcPnMjc2zVzzuiXGL95MA
        jzlgNEZZa2Yi+27SVWejUk4X9MncQ1OR/8dNzPbPP01jBMkRfVS//Of4DTptDuFNXzrGPKXN91keG
        1TWXi7/Zeh1r2fxZjYPqQVh+fayA4oO6/3VrWr6LW/OxoeSMjpMgo4C+oIjW7lZPilqwpV31edAMc
        j4WLHelLY/qVqDMhpPHsQOxXzsMBTjBQg5ae1Vg0m1Di470PGaJbap1aXNJ9I1mVsjymjQ2H40Fes
        LvWyZ/zT0XRUAhleIEky5VfMnu5Ve0pAr8xZOmAqb6BkyrlDm1kM1Fn31/LY85RfogvlDJTNbFrnG
        64fsDp+A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r0ZHy-0002N2-4G; Wed, 08 Nov 2023 04:31:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] arptables: Fix --proto-type mask formatting
Date:   Wed,  8 Nov 2023 04:31:29 +0100
Message-ID: <20231108033130.18747-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231108033130.18747-1-phil@nwl.cc>
References: <20231108033130.18747-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Arptables accepts numeric --proto-type values and masks in any numeral
system identified by (absence of) prefix. Yet it prints the mask value
in hex without '0x'-prefix, breaking save and restore the same way
numeric --h-type output did.

In theory, this could be fixed either by adding the missing prefix or
printing the mask in decimal (like most other builtin matches do), but
since the value is printed in hex with prefix already, align mask output
with that.

Also a day 1 bug and consistent with legacy, so no Fixes: tag here as
well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libarpt_standard.t | 4 ++++
 iptables/nft-arp.c            | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/extensions/libarpt_standard.t b/extensions/libarpt_standard.t
index a2b0a36a4a6bf..b9a3560660372 100644
--- a/extensions/libarpt_standard.t
+++ b/extensions/libarpt_standard.t
@@ -16,3 +16,7 @@
 --src-mac ! 01:02:03:04:05:06 --dst-mac ! 07:08:09:0A:0B:0C --h-length ! 6 --opcode ! Request --h-type ! Ethernet --proto-type ! ipv4;! --src-mac 01:02:03:04:05:06 ! --dst-mac 07:08:09:0a:0b:0c ! --h-length 6 ! --opcode 1 ! --h-type 0x1 ! --proto-type 0x800;OK
 --h-type 10;--h-type 0x10;OK
 --h-type 0x10;=;OK
+--proto-type 10;--proto-type 0xa;OK
+--proto-type 10/10;--proto-type 0xa/0xa;OK
+--proto-type 0x10;=;OK
+--proto-type 0x10/0x10;=;OK
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 83aec5003004e..38b2ab3993128 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -339,7 +339,7 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 		else
 			printf("--proto-type 0x%x", tmp);
 		if (fw->arp.arpro_mask != 65535)
-			printf("/%x", ntohs(fw->arp.arpro_mask));
+			printf("/0x%x", ntohs(fw->arp.arpro_mask));
 		sep = " ";
 	}
 }
-- 
2.41.0

