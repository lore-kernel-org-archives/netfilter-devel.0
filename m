Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA771C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 16:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJEQnV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 12:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiJEQnU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 12:43:20 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B43821E24
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 09:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Yl8+vQ4BzHqgPvBA/RgSqee00Q93n1F+Fn4hCJGvOuU=; b=V1n4VXXlZDAgely3fwjaPh+LQK
        ihV73cPq6RqTs7/ahdSM3z0uPQQ+8WWugNAIaWXiC0b77TpSB/V47Z4fz2JhvtDAOVvtIutacauz1
        o5vCU9yPmo1H9CtieJ02LJaDpIo7DCyhJ+8E6JW5nC3WgLDKv+CejOylokdMT1L4QslzbM2QHSlph
        L+JNGaLG6bVZqwlAFTvjEwbhjOaKkL3Za3v6BsvgjOMU4kO1+31qkperkaD0g5XW7rRfF3oG3IxvP
        HkUXGViqpJSu+PK9dnzBZa3waBkAEW+4tXJYXfW3QJQ1s0cW7AN/igxR/AX1EkvNcUwfcdv6p3lI9
        5E1/9dZA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1og7UL-0005y4-EX
        for netfilter-devel@vger.kernel.org; Wed, 05 Oct 2022 18:43:17 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: libebt_log: Avoid empty log-prefix in output
Date:   Wed,  5 Oct 2022 18:43:08 +0200
Message-Id: <20221005164308.11373-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just like iptables LOG target, omit --log-prefix from output if the
string is empty.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_log.c | 7 ++++---
 extensions/libebt_log.t | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/extensions/libebt_log.c b/extensions/libebt_log.c
index 8858cf0e22c00..47708d79310e0 100644
--- a/extensions/libebt_log.c
+++ b/extensions/libebt_log.c
@@ -161,9 +161,10 @@ static void brlog_print(const void *ip, const struct xt_entry_target *target,
 {
 	struct ebt_log_info *loginfo = (struct ebt_log_info *)target->data;
 
-	printf("--log-level %s --log-prefix \"%s\"",
-		eight_priority[loginfo->loglevel].c_name,
-		loginfo->prefix);
+	printf("--log-level %s", eight_priority[loginfo->loglevel].c_name);
+
+	if (loginfo->prefix[0])
+		printf(" --log-prefix \"%s\"", loginfo->prefix);
 
 	if (loginfo->bitmask & EBT_LOG_IP)
 		printf(" --log-ip");
diff --git a/extensions/libebt_log.t b/extensions/libebt_log.t
index a0df6169112a0..f7116c417b0ab 100644
--- a/extensions/libebt_log.t
+++ b/extensions/libebt_log.t
@@ -1,6 +1,6 @@
 :INPUT,FORWARD,OUTPUT
 --log;=;OK
 --log-level crit;=;OK
---log-level 1;--log-level alert --log-prefix "";OK
---log-level emerg --log-ip --log-arp --log-ip6;--log-level emerg --log-prefix "" --log-ip --log-arp --log-ip6 -j CONTINUE;OK
+--log-level 1;--log-level alert;OK
+--log-level emerg --log-ip --log-arp --log-ip6;=;OK
 --log-level crit --log-ip --log-arp --log-ip6 --log-prefix foo;--log-level crit --log-prefix "foo" --log-ip --log-arp --log-ip6 -j CONTINUE;OK
-- 
2.34.1

