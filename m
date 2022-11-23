Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22452C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239087AbiKWQpF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239170AbiKWQpA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:45:00 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092BD90386
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wijOBQMwMhiz/NiD6q5oMMRq92gL2hDTRhFWHCjxaDo=; b=NF7PyqjWX5+gKSdyUUwGh4CjDv
        h0tdxkCg6y4svfn6Z2J5M4ahFa9aINbJD4ZYddHJqfDQJ2njoaKhd+yjrlbAIwA/zNMSpDJLBGvVj
        2Fb/lT10vNCxG0zkfzaM1ozDUjz+BUUVEg+A05NHwKmUgLfpiAV0h5p0dF6xMtWt6rNeDpEhcDVzY
        gEPu0BCt8M3CluobdFGvIETHL2iKSdCUWhtif//zvSyDAuB4i3CEbw8PqWgIcXeQ/4Nfcg104VSs4
        OxNp/+DlsN4b13EA/wEJnAz+AvmJiCQIqVrXoI6nedecPl+q9++IdixZIr3YEXIL8OmDoTehKeVeY
        75mB9OPQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsrp-0003zF-EW
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:44:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 04/13] extensions: libipt_ttl: Sanitize xlate callback
Date:   Wed, 23 Nov 2022 17:43:41 +0100
Message-Id: <20221123164350.10502-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Catch unexpected values in info->mode, also fix indenting.

Fixes: 1b320a1a1dc1f ("extensions: libipt_ttl: Add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_ttl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 6bdd219618091..86ba554ef92a8 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -106,7 +106,7 @@ static int ttl_xlate(struct xt_xlate *xl,
 	const struct ipt_ttl_info *info =
 		(struct ipt_ttl_info *) params->match->data;
 
-		switch (info->mode) {
+	switch (info->mode) {
 		case IPT_TTL_EQ:
 			xt_xlate_add(xl, "ip ttl");
 			break;
@@ -121,7 +121,7 @@ static int ttl_xlate(struct xt_xlate *xl,
 			break;
 		default:
 			/* Should not happen. */
-			break;
+			return 0;
 	}
 
 	xt_xlate_add(xl, " %u", info->ttl);
-- 
2.38.0

