Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EF7C05027
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 16:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjBQQSG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Feb 2023 11:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjBQQR4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2023 11:17:56 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF81E5FC57
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2023 08:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MuKXmmMAT8Jfy3zeliCSijCp7pJzhJ6C5OSD6XbGAbA=; b=g5RLzPuw+1x0myGf3T+SlTqNGs
        HsUzcCiqcMpZc0kte5DVgqfAxlgU3GlZieY9XkLQN49MahAtxpu2Un6V1OvViJT2ALNxNNeRtYvo8
        4ystNoqh4FdQOvfKG9LK0kEKfItr/U6u5ouRmFGnEbNNCJmLuuI7ytEICKeNybz7p78AwpK5UsmFW
        8lDxkWg2eyO2Kp3QSzT9bLdSc20Ia2IIveN6XO012sDR7CYsUEa+pjtLTrg7RvwZHN1eKpPKQsvAl
        qw2LU88dsHq+W677sq7AFzzU0hFodkEVqILhk1dlOYAHMX/vGnRmR/f32dP8+kY8zI+dQcaH3MftQ
        v/FlqXxg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pT3Qk-0003WJ-Uh
        for netfilter-devel@vger.kernel.org; Fri, 17 Feb 2023 17:17:51 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/6] extensions: libebt_ip: Do not use 'ip dscp' for translation
Date:   Fri, 17 Feb 2023 17:17:12 +0100
Message-Id: <20230217161715.26120-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230217161715.26120-1-phil@nwl.cc>
References: <20230217161715.26120-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Converting from TOS field match to DSCP one is irreversible, so replay
testing is not possible. Use a raw payload expression to produce
something that translates 1:1 back into an 'ip' match.

Fixes: 03ecffe6c2cc0 ("ebtables-compat: add initial translations")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_ip.c      | 4 ++--
 extensions/libebt_ip.txlate | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index fd87dae7e2c62..8b381aa10b5b7 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -442,10 +442,10 @@ static int brip_xlate(struct xt_xlate *xl,
 	brip_xlate_nh(xl, info, EBT_IP_DEST);
 
 	if (info->bitmask & EBT_IP_TOS) {
-		xt_xlate_add(xl, "ip dscp ");
+		xt_xlate_add(xl, "@nh,8,8 ");
 		if (info->invflags & EBT_IP_TOS)
 			xt_xlate_add(xl, "!= ");
-		xt_xlate_add(xl, "0x%02x ", info->tos & 0x3f); /* remove ECN bits */
+		xt_xlate_add(xl, "0x%02x ", info->tos);
 	}
 	if (info->bitmask & EBT_IP_PROTO) {
 		struct protoent *pe;
diff --git a/extensions/libebt_ip.txlate b/extensions/libebt_ip.txlate
index 75c1db246fb81..562e3157d7b92 100644
--- a/extensions/libebt_ip.txlate
+++ b/extensions/libebt_ip.txlate
@@ -5,7 +5,7 @@ ebtables-translate -I FORWARD -p ip --ip-dst 10.0.0.1
 nft 'insert rule bridge filter FORWARD ip daddr 10.0.0.1 counter'
 
 ebtables-translate -I OUTPUT 3 -p ip -o eth0 --ip-tos 0xff
-nft 'insert rule bridge filter OUTPUT oifname "eth0" ip dscp 0x3f counter'
+nft 'insert rule bridge filter OUTPUT oifname "eth0" @nh,8,8 0xff counter'
 
 ebtables-translate -A FORWARD -p ip --ip-proto tcp --ip-dport 22
 nft 'add rule bridge filter FORWARD tcp dport 22 counter'
-- 
2.38.0

