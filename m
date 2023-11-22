Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209E6C61DA7
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343893AbjKVMyx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343898AbjKVMys (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D328C112
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=z9C8n2tBccSQxSOZdztMYTidRkBuwVWk/ybixwgEwio=; b=YQdWZRBHGgS3okVsrPOHoZLuKO
        4GCuLKYS+f+x69NWN3+ZGTfCaKRdNmZjKtnEVumRCtwVCymsbd3ymXz5h74yGMzuVOR3lDfcDKrY1
        ulQP6FUiuGklyQJb2H/VmNcddFiLu5tA0hLaVH1gOxpTcuLcGnZ1DRgSE5OyE9+VA4ecbBX9HUj2C
        98rbd23iE6iuechSU77aAwypBzc9UI35R4/aPqd5IYP+B2jGzCEDBe3OhdXDA4zJYLpKkvYyqoZFd
        OmfZCH5PQ1qaTezG+r8QkBXCNF+QvqHVGUDGOYUebqB57nO+ulCHiWdXVuZP/yyVtAqKSng3SWWdB
        Ro2c1sjA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkY-0005Sn-7Q
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 11/12] xshared: do_parse: Ignore '-j CONTINUE'
Date:   Wed, 22 Nov 2023 14:02:21 +0100
Message-ID: <20231122130222.29453-12-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>
References: <20231122130222.29453-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While iptables does not support his NOP, arptables man page claims it
does (although legacy arptables rejects it) and ebtables prefers to
print it instead of omitting the '-j' option.

Accept and ignore the target when parsing to at least fix for
arptables-nft and prepare for ebtables-nft using do_parse() as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index c4d7a266fed5e..1b02f35a9de3a 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1634,7 +1634,8 @@ void do_parse(int argc, char *argv[],
 		case 'j':
 			set_option(&cs->options, OPT_JUMP, &args->invflags,
 				   invert);
-			command_jump(cs, optarg);
+			if (strcmp(optarg, "CONTINUE"))
+				command_jump(cs, optarg);
 			break;
 
 		case 'i':
-- 
2.41.0

