Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B259AEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjHBCGJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjHBCGI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:06:08 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2209410E
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aGZe4kM0yMTtv9V8NyiMNDpajLVmgo6bZTSYEkZFwlg=; b=LZ0H5ExU9FtoU8o+OFKdbo3nGO
        Jia/3FFolO9Piy4dAW2XxZ6uB+Tuhhu1/Maip0761jAeFI9JoXCwd30r5juPUAweazrUwti6ykpBB
        Fi+D+6PL3EQflQXfHCqZLPZ0kr7hwrcOxXgsHhXRtxOkuhBFX6BjT3Z4BTT5z+/dLNl8cAUUnd+Ca
        G0IKUv6gXG3r7EFbSuVTJQiapefYVAwaO3/vCvyVthBcjstVWIUvFJpzx9nw3htAZVBD0Tyi4t6t2
        IGmxgVM8V1I4UlipgFz2fp3Uy4kUHzQydPwVi5C3vD2S4FUst9b4jCnyWpwHZR9VzDyJOEvK7/fGT
        if1XEWhg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1FW-0002vU-FY; Wed, 02 Aug 2023 04:06:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Amelia Downs <adowns@vmware.com>
Subject: [iptables PATCH 1/3] extensions: libipt_icmp: Fix confusion between 255/255 and any
Date:   Wed,  2 Aug 2023 04:05:45 +0200
Message-Id: <20230802020547.28886-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Per definition, ICMP type "any" is type 255 and the full range of codes
(0-255). Save callback though ignored the actual code values, printing
"any" for every type 255 match. This at least confuses users as they
can't find their rule added as '--icmp-type 255/255' anymore.

It is not entirely clear what the fixed commit was trying to establish,
but the save output is certainly not correct (especially since print
callback gets things right).

Reported-by: Amelia Downs <adowns@vmware.com>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1600
Fixes: fc9237da4e845 ("Fix '-p icmp -m icmp' issue (Closes: #37)")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_icmp.c | 3 ++-
 extensions/libipt_icmp.t | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index b0318aebc2c57..171b3b3949e54 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -108,7 +108,8 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
 		printf(" !");
 
 	/* special hack for 'any' case */
-	if (icmp->type == 0xFF) {
+	if (icmp->type == 0xFF &&
+	    icmp->code[0] == 0 && icmp->code[1] == 0xFF) {
 		printf(" --icmp-type any");
 	} else {
 		printf(" --icmp-type %u", icmp->type);
diff --git a/extensions/libipt_icmp.t b/extensions/libipt_icmp.t
index f4ba65c27f032..ce4a33f9633b5 100644
--- a/extensions/libipt_icmp.t
+++ b/extensions/libipt_icmp.t
@@ -13,3 +13,5 @@
 # we accept "iptables -I INPUT -p tcp -m tcp", why not this below?
 # ERROR: cannot load: iptables -A INPUT -p icmp -m icmp
 # -p icmp -m icmp;=;OK
+-p icmp -m icmp --icmp-type 255/255;=;OK
+-p icmp -m icmp --icmp-type 255/0:255;-p icmp -m icmp --icmp-type any;OK
-- 
2.40.0

