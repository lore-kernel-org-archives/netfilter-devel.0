Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215A6C05027
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 16:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjBQQSB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Feb 2023 11:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjBQQRx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2023 11:17:53 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA9EB465
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2023 08:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RTfLwdbK7rB2a6R9Xkzk/wFqGaL1QjoYMKWZyM3bruo=; b=gom2PrQHDFjnsSaLA0CFvsAPCR
        XKwy+ZHr+c26HYfC2ZniVCIHsmdH7hwPoZSD6nBHWeAij60e3x2RLRToQc+ho80sVSrQwzOpj6zxl
        mVWiFjWu2Bp83lWhbKUpKWb+/1qNMlGG8LbddF5SVc8yrdTSOLyb1kjeeZx8Bz8l0fB0zFZmMbbXy
        lLk4iyE9uC3YI2KgjoDl3sx8ykpETWbwGZtNMbyV4AfwXZwmfLjmgN5QAIpOoa1bZicqu23CACJc/
        N63cr1J1HM9e4FAh75h3jPSQsEaLfLYvhBvfcoaoAfdRImba4r8j1RlHK3ViiuOTn2k+SiWOTkeAt
        mkVyzDoA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pT3QP-0003Vw-Bu
        for netfilter-devel@vger.kernel.org; Fri, 17 Feb 2023 17:17:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 6/6] xtables-translate: Support insert with index
Date:   Fri, 17 Feb 2023 17:17:15 +0100
Message-Id: <20230217161715.26120-6-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230217161715.26120-1-phil@nwl.cc>
References: <20230217161715.26120-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Translation is pretty simple due to nft's 'insert rule ... index'
support. Testing the translation is sadly not: index 1 vanishes (as it
should), higher indexes are rejected in replay mode since no rules
previously exist.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_ip.txlate  | 2 +-
 iptables/xtables-translate.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/extensions/libebt_ip.txlate b/extensions/libebt_ip.txlate
index 28996832225cb..44ce927614b57 100644
--- a/extensions/libebt_ip.txlate
+++ b/extensions/libebt_ip.txlate
@@ -4,7 +4,7 @@ nft 'add rule bridge filter FORWARD ip saddr != 192.168.0.0/24 counter accept'
 ebtables-translate -I FORWARD -p ip --ip-dst 10.0.0.1
 nft 'insert rule bridge filter FORWARD ip daddr 10.0.0.1 counter'
 
-ebtables-translate -I OUTPUT 3 -p ip -o eth0 --ip-tos 0xff
+ebtables-translate -I OUTPUT -p ip -o eth0 --ip-tos 0xff
 nft 'insert rule bridge filter OUTPUT oifname "eth0" ether type ip @nh,8,8 0xff counter'
 
 ebtables-translate -A FORWARD -p ip --ip-proto tcp --ip-dport 22
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 22b2fbc869eed..88e0a6b639494 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -173,6 +173,8 @@ static int nft_rule_xlate_add(struct nft_handle *h,
 	       tick,
 	       append ? "add" : "insert",
 	       family2str[h->family], p->table, p->chain);
+	if (!append && p->rulenum > 1)
+		printf("index %d ", p->rulenum);
 
 	printf("%s%s\n", xt_xlate_rule_get(xl), tick);
 
-- 
2.38.0

