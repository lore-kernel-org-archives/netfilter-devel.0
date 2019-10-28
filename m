Return-Path: <SRS0=tJiL=YV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2351CCA9EC0
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 14:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA10421734
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 14:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbfJ1OFN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Oct 2019 10:05:13 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:39898 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbfJ1OFN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Oct 2019 10:05:13 -0400
Received: from localhost ([::1]:52988 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iP5dv-0000uj-Og; Mon, 28 Oct 2019 15:05:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/10] nft-arp: Use xtables_print_mac_and_mask()
Date:   Mon, 28 Oct 2019 15:04:31 +0100
Message-Id: <20191028140431.13882-11-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028140431.13882-1-phil@nwl.cc>
References: <20191028140431.13882-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This libxtables function does exactly what the local implementation did.
The only noteworthy difference is that it assumes MAC/mask lengths, but
the local implementation was passed ETH_ALEN in each invocation, so no
practical difference.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c | 31 ++++---------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 9805bbe0de87b..7068f82c5495a 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -114,29 +114,6 @@ mask_to_dotted(const struct in_addr *mask)
 	return buf;
 }
 
-static void print_mac(const unsigned char *mac, int l)
-{
-	int j;
-
-	for (j = 0; j < l; j++)
-		printf("%02x%s", mac[j],
-			(j==l-1) ? "" : ":");
-}
-
-static void print_mac_and_mask(const unsigned char *mac, const unsigned char *mask, int l)
-{
-	int i;
-
-	print_mac(mac, l);
-	for (i = 0; i < l ; i++)
-		if (mask[i] != 255)
-			break;
-	if (i == l)
-		return;
-	printf("/");
-	print_mac(mask, l);
-}
-
 static bool need_devaddr(struct arpt_devaddr_info *info)
 {
 	int i;
@@ -506,8 +483,8 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 	printf("%s%s", sep, fw->arp.invflags & ARPT_INV_SRCDEVADDR
 		? "! " : "");
 	printf("--src-mac ");
-	print_mac_and_mask((unsigned char *)fw->arp.src_devaddr.addr,
-		(unsigned char *)fw->arp.src_devaddr.mask, ETH_ALEN);
+	xtables_print_mac_and_mask((unsigned char *)fw->arp.src_devaddr.addr,
+				   (unsigned char *)fw->arp.src_devaddr.mask);
 	sep = " ";
 after_devsrc:
 
@@ -532,8 +509,8 @@ after_devsrc:
 	printf("%s%s", sep, fw->arp.invflags & ARPT_INV_TGTDEVADDR
 		? "! " : "");
 	printf("--dst-mac ");
-	print_mac_and_mask((unsigned char *)fw->arp.tgt_devaddr.addr,
-		(unsigned char *)fw->arp.tgt_devaddr.mask, ETH_ALEN);
+	xtables_print_mac_and_mask((unsigned char *)fw->arp.tgt_devaddr.addr,
+				   (unsigned char *)fw->arp.tgt_devaddr.mask);
 	sep = " ";
 
 after_devdst:
-- 
2.23.0

