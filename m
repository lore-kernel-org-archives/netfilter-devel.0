Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE1BC61D9C
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343905AbjKVMyv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343883AbjKVMyr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:47 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03055D60
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LOI67zIJViVUJPhdzYd4IViCPYV+IYYcwb3DOUO76Ns=; b=dW64jzb8kjgBKvJ1t56M+YBBwY
        X7g8l3QXxEDifeBU9ybu6ocb2W6ql4sHteyl4a3+Rp6IxUOvk/txCMcVlq3F4SEGNiSUkfxoEWKhq
        gWTarRKh/iOsoAEw6oXRlaSd9WQVLQfnE+skL49B6fVMpjPzwJtrh6vIfoKY0kBd9BEHpvyaQ195B
        qKrxv9ocj4FINpjcPfxM/udkx6Ce3c7UEPahGBqCg5wK2pfB98I4I652LoA/qZvutGb+Ae0quBKmj
        ZnoFunpCa+KR7ia1d0xmKgXOYqEZrwkR0L8/9LmY9mZd+KY6FTlcpmgynMQv5TgkkMpyCVR1iKOO4
        9DFxeB/w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkV-0005SL-8T
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:35 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 03/12] xshared: struct xt_cmd_parse::xlate is unused
Date:   Wed, 22 Nov 2023 14:02:13 +0100
Message-ID: <20231122130222.29453-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>
References: <20231122130222.29453-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Drop the boolean, it was meant to disable some existence checks in
do_parse() prior to the caching rework. Now that do_parse() runs before
any caching is done, the checks in question don't exist anymore so drop
this relict.

Fixes: a7f1e208cdf9c ("nft: split parsing from netlink commands")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.h           | 1 -
 iptables/xtables-translate.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/iptables/xshared.h b/iptables/xshared.h
index 5586385456a4d..c77556a1987dc 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -284,7 +284,6 @@ struct xt_cmd_parse {
 	bool				restore;
 	int				line;
 	int				verbose;
-	bool				xlate;
 	struct xt_cmd_parse_ops		*ops;
 };
 
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index ea9dce204dfc9..ad44311230323 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -259,7 +259,6 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 		.table		= *table,
 		.restore	= restore,
 		.line		= line,
-		.xlate		= true,
 		.ops		= &h->ops->cmd_parse,
 	};
 	struct iptables_command_state cs = {
-- 
2.41.0

