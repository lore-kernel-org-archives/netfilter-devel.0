Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F7E7C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Dec 2022 15:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiLTPjR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 10:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiLTPjO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 10:39:14 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858DF1658A
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2022 07:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jJ0128fXhap1n3HtwclhcfQf7BAiYShz1axigI4BPTQ=; b=l8CI9Rx+slQtvt3Vo0iFnC/lEt
        jsQXw24OS5VRHxFVlbYpf/dbDWIWlHP+EYxyyADyyXNzYNOk3xipwb+95sABr/V7HHKM64paEQuX+
        k/ZHuS1n53dG/GpQUavY0Y5prLLOnHPvWperb11fNRiuftq/BBvVyTQ0gPOIk2nW86DrHN41fbkKO
        mxXQZv6sv9hO7L2e78hd1JiBkUjYi32ENHudQ2X2ZIA4kMjhl3sQOVMQb3K0IRT5TsKDkUZCbAHUO
        HJtiNt8pxZk5y20cqhE9Y+/YXl1w+JEXzheuMpQ+d+DfHNFhAkhoPXwv/MXOaCXF0T0tK0KlddsZB
        U4I6MDdA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p7ehz-0000GA-VN; Tue, 20 Dec 2022 16:39:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 2/4] conntrack: Fix for unused assignment in do_command_ct()
Date:   Tue, 20 Dec 2022 16:38:45 +0100
Message-Id: <20221220153847.24152-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221220153847.24152-1-phil@nwl.cc>
References: <20221220153847.24152-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The variable is overwritten immediately in the next iteration and the
loop can't exit before doing that.

Instead of dropping the assignment, one could add a return code check -
but since event_cb() never fails, that check is pointless as well.

Fixes: e0dac21ed02e3 ("conntrack: use libmnl for conntrack events")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index aa6323dfbd1b1..07fae3dc2ff07 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -3479,7 +3479,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
 					   strerror(errno));
 				break;
 			}
-			res = mnl_cb_run(buf, res, 0, 0, event_cb, cmd);
+			mnl_cb_run(buf, res, 0, 0, event_cb, cmd);
 		}
 		mnl_socket_close(event_sock->mnl);
 		break;
-- 
2.38.0

