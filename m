Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 088AEEDE98C
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 07:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbjINH3t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 03:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjINH3t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 03:29:49 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED33F3
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 00:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cTuSDR2FVxNt4YZj2LJJX1lw4Toi7/DmATPvlnX+MC8=; b=bCu42fFmBknFAITaB8yW+l/nXJ
        Jxd3Y1SRHuOcvw8LrSLhmMUbGC8JPlt33XBLQIplO243mkUYzrsRr0122kQUHqWIaDgY+WyJ0wKzp
        HiBTmYwAtFmfr3NPFYi1MUhfjPfnv1Y7szntM0MYH8crgqeRgG/IMIR++d8d9yBy0wrAp6U1lYPcj
        SjNYHPFgx08PTb+FyA4TrWxMt35APutZgilK+W8DDsZlh3qd+7zrEyiR26gEu+5au9sVoaUw82P6A
        SUVcUM3AzUdnJs7IPzY2+LMXee5pUEg0CInuTl0iq3qWaaeK+75vx5d9c6jYF/G1rx44WoMsIYhkx
        mWzmew2Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qggnD-0001Bb-Uv; Thu, 14 Sep 2023 09:29:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Quentin Armitage <quentin@armitage.org.uk>
Subject: [iptables PATCH] extensions: Fix checking of conntrack --ctproto 0
Date:   Thu, 14 Sep 2023 09:29:36 +0200
Message-ID: <20230914072936.29097-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Quentin Armitage <quentin@armitage.org.uk>

There are three issues in the code:
1) the check (sinfo->invflags & XT_INV_PROTO) is using the wrong mask
2) in conntrack_mt_parse it is testing (info->invert_flags &
   XT_INV_PROTO) before the invert bit has been set.
3) the sense of the error message is the wrong way round

1) To get the error, ! -ctstatus XXX has to be specified, since
   XT_INV_PROTO == XT_CONNTRACK_STATUS e.g.
   | iptables -I CHAIN -m conntrack ! --ctstatus ASSURED --ctproto 0 ...

3) Unlike --proto 0 (where 0 means all protocols), in the conntrack
   match --ctproto 0 appears to mean protocol 0, which can never be.
   Therefore --ctproto 0 could never match and ! --ctproto 0 will always
   match. Both of these should be rejected, since the user clearly
   cannot be intending what was specified.

The attached patch resolves the issue, and also produces an error
message if --ctproto 0 is specified (as well as ! --ctproto 0 ), since
--ctproto 0 will never match, and ! --ctproto 0 will always match.

[Phil: - Added Fixes: tag - it's a day 1 bug
       - Copied patch description from Bugzilla
       - Reorganized changes to reduce diff
       - Added test cases]

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=874
Fixes: 5054e85be3068 ("general conntrack match module userspace support files")
Signed-off-by: Quentin Armitage <quentin@armitage.org.uk>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_conntrack.c | 17 ++++++++---------
 extensions/libxt_conntrack.t |  2 ++
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 09548c297695f..ffbc7467bbf2e 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -346,14 +346,13 @@ static void conntrack_parse(struct xt_option_call *cb)
 			sinfo->invflags |= XT_CONNTRACK_STATE;
 		break;
 	case O_CTPROTO:
+		if (cb->val.protocol == 0)
+			xtables_error(PARAMETER_PROBLEM, cb->invert ?
+				      "condition would always match protocol" :
+				      "rule would never match protocol");
 		sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum = cb->val.protocol;
 		if (cb->invert)
 			sinfo->invflags |= XT_CONNTRACK_PROTO;
-		if (sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum == 0
-		    && (sinfo->invflags & XT_INV_PROTO))
-			xtables_error(PARAMETER_PROBLEM,
-				   "rule would never match protocol");
-
 		sinfo->flags |= XT_CONNTRACK_PROTO;
 		break;
 	case O_CTORIGSRC:
@@ -411,11 +410,11 @@ static void conntrack_mt_parse(struct xt_option_call *cb, uint8_t rev)
 			info->invert_flags |= XT_CONNTRACK_STATE;
 		break;
 	case O_CTPROTO:
+		if (cb->val.protocol == 0)
+			xtables_error(PARAMETER_PROBLEM, cb->invert ?
+				      "conntrack: condition would always match protocol" :
+				      "conntrack: rule would never match protocol");
 		info->l4proto = cb->val.protocol;
-		if (info->l4proto == 0 && (info->invert_flags & XT_INV_PROTO))
-			xtables_error(PARAMETER_PROBLEM, "conntrack: rule would "
-			           "never match protocol");
-
 		info->match_flags |= XT_CONNTRACK_PROTO;
 		if (cb->invert)
 			info->invert_flags |= XT_CONNTRACK_PROTO;
diff --git a/extensions/libxt_conntrack.t b/extensions/libxt_conntrack.t
index db53147532afd..2b3c5de9cd3ab 100644
--- a/extensions/libxt_conntrack.t
+++ b/extensions/libxt_conntrack.t
@@ -25,3 +25,5 @@
 -m conntrack --ctstatus EXPECTED;=;OK
 -m conntrack --ctstatus SEEN_REPLY;=;OK
 -m conntrack;;FAIL
+-m conntrack --ctproto 0;;FAIL
+-m conntrack ! --ctproto 0;;FAIL
-- 
2.41.0

