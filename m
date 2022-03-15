Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568D4C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 13:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348643AbiCON1r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 09:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348655AbiCON1q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 09:27:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CE249CAF
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 06:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pPgZa8GZM9YFbhF2zh1C/W1kONbIM/hOBV4pUnFVXp0=; b=fqK76w01ZQlCq1nypBDvOWpGH3
        Kbj5bP/Cm8dTl1ekkJjbGVfNXFvmXgEJYl4z3TO8MaGNbl5xV9T/l2q2vcljnUIdgxhv/BXA2u6ix
        ZLLaRHS1BikPb1tHB+7PdIv8qaqCMWxa7VCOryWJSoHpcLA9fQpG1LdDtnwmE0PLRkzTyxXC+rd9X
        o6h3douPP8UFnox4qAGsrFs11GETxYvhMrB3SEdnCU7yZ9p/EyLMZsqcLtfWgkZX3XhUDp6Avl+nJ
        f04pgr/9ZjPVzVLOhmMQNZfuCUq4II5YnDTQpPK/f+USq7nXp0Vzp+2mNzgLq37VtQNWsWzXaIMt4
        kyYMBuCQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nU7C4-0000rn-B4; Tue, 15 Mar 2022 14:26:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Etienne <champetier.etienne@gmail.com>
Subject: [iptables PATCH 1/5] libxtables: Fix for warning in xtables_ipmask_to_numeric
Date:   Tue, 15 Mar 2022 14:26:15 +0100
Message-Id: <20220315132619.20256-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315132619.20256-1-phil@nwl.cc>
References: <20220315132619.20256-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Gcc complains:

| xtables.c: In function 'xtables_ipmask_to_numeric':
| xtables.c:1491:34: warning: '__builtin___sprintf_chk' may write a terminating nul past the end of the destination [-Wformat-overflow=]
|  1491 |                 sprintf(buf, "/%s", xtables_ipaddr_to_numeric(mask));
|       |                                  ^

Indeed, xtables_ipaddr_to_numeric() returns a pointer to a 20 byte
buffer and xtables_ipmask_to_numeric() writes its content into a buffer
of same size at offset 1. Yet length of returned string is deterministic
as it is an IPv4 address. So shrink it to the minimum of 16 bytes which
eliminates the warning as well.

Fixes: a96166c24eaac ("libxtables: add xtables_ip[6]mask_to_cidr")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 094cbd87ec1ed..5f47f627df440 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1418,7 +1418,7 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 
 const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
 {
-	static char buf[20];
+	static char buf[16];
 	const unsigned char *bytep = (const void *)&addrp->s_addr;
 
 	sprintf(buf, "%u.%u.%u.%u", bytep[0], bytep[1], bytep[2], bytep[3]);
-- 
2.34.1

