Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B65AC43334
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245496AbiFHQ1a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245492AbiFHQ13 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:27:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762DC4C7B5
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gLCuitXM5U0UsjT6aqh4FTxejPxgOzkRnoMtylxwL5M=; b=Aj93W74e11vf25sioSDjLqJDZ2
        NruEIIQanSDrmh1O+8WVTXEk4RkIwW/Y9tZ9tbJXmjzFLIL+SVOiNoxEz+Ojv+JNbZTBl1gxiqRfw
        x1f8HQHT4VXkRJac4c7/x3aaHu7luXTtrOHjbXIr3aZo/QepcpmMD7GA/AA365qIV8HJ0ip0io7wj
        X0uBYzu6QRRkjFy9xZa8cRsDKRvrA7cSMZNuxJgCIIa9giFPURZIu0Vg6yNsU6se3ojcgKWKHSf5l
        XahNAeOiksrv0WME7X8bZmWs/YAzp4fhnBKI/60cY2Bx17Vl0gLP2Hkt/3vo4ZbIymryEBKK0dAYy
        0on6LaQg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nyyWk-00084u-S7
        for netfilter-devel@vger.kernel.org; Wed, 08 Jun 2022 18:27:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 6/9] ebtables-restore: Deny --init-table
Date:   Wed,  8 Jun 2022 18:27:09 +0200
Message-Id: <20220608162712.31202-7-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220608162712.31202-1-phil@nwl.cc>
References: <20220608162712.31202-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allowing this segfaults the program. The deny is in line with legacy
ebtables, so no point in implementing support for that.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 3d15063e80e91..b986fd9e84799 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -1077,6 +1077,9 @@ print_zero:
 			flags |= LIST_MAC2;
 			break;
 		case 11: /* init-table */
+			if (restore)
+				xtables_error(PARAMETER_PROBLEM,
+					      "--init-table is not supported in daemon mode");
 			nft_cmd_table_flush(h, *table, false);
 			return 1;
 		case 13 :
-- 
2.34.1

