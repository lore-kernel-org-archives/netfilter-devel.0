Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C06C77B60
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Apr 2023 13:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345991AbjD1NAY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Apr 2023 09:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjD1NAX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2023 09:00:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAF1210C
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2023 06:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ulU5ifCbgLk7iFMVbdlUS3O/vOuOPk/+0IeMHGS4m2I=; b=hPyxgIowqGm4hNcXlO0Yp8YpbI
        7TdFRwcj12+94b0zxHuvokVGFbOR1n5GyefQKQ4pV1JIx/JiYK/wHQ57yhkCbEqjkEWLcvtjxdOc/
        H+zewTfPONp6L/6p5UtswYjUILg8gTwQBskjlpSj92N/fRt0c1n8GU4AchMqsByd6hIiFzfGapekc
        W4CrZ4mZPiUgUD40/D8T77606rdi6DJaJyCk2ORvuhEbJldQhgeKOCWF2iXjbsC8whqtzwXDLvn34
        gc5Jgn0UtyCjb1bqoyWFsWueQNsrN/OwTH4zq6SKddRqWiIpLctxh87aof8Us7Em1vNpapDkL+dR8
        yOX5JZCA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1psNi0-0001zk-Fg
        for netfilter-devel@vger.kernel.org; Fri, 28 Apr 2023 15:00:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] arptables: Don't omit standard matches if inverted
Date:   Fri, 28 Apr 2023 15:05:30 +0200
Message-Id: <20230428130531.14195-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230428130531.14195-1-phil@nwl.cc>
References: <20230428130531.14195-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Inverted --h-len and --h-type matches were omitted from output by
accident if they matched on their standard value.

Fixes: 84331e3ed3f8e ("arptables-nft: Don't print default h-len/h-type values")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index a8e49f442c6d7..3236e2f54e21d 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -408,7 +408,8 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 
 after_devdst:
 
-	if (fw->arp.arhln_mask != 255 || fw->arp.arhln != 6) {
+	if (fw->arp.arhln_mask != 255 || fw->arp.arhln != 6 ||
+	    fw->arp.invflags & IPT_INV_ARPHLN) {
 		printf("%s%s", sep, fw->arp.invflags & IPT_INV_ARPHLN
 			? "! " : "");
 		printf("--h-length %d", fw->arp.arhln);
@@ -432,7 +433,8 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 		sep = " ";
 	}
 
-	if (fw->arp.arhrd_mask != 65535 || fw->arp.arhrd != htons(1)) {
+	if (fw->arp.arhrd_mask != 65535 || fw->arp.arhrd != htons(1) ||
+	    fw->arp.invflags & IPT_INV_ARPHRD) {
 		uint16_t tmp = ntohs(fw->arp.arhrd);
 
 		printf("%s%s", sep, fw->arp.invflags & IPT_INV_ARPHRD
-- 
2.40.0

