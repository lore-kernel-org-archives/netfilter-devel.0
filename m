Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE24C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Mar 2022 10:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350224AbiCYKwR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 06:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350532AbiCYKwQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 06:52:16 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED1CCFB91
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2022 03:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QgaaJIfsLUVd5JLllxsv1x0G0MW0vLVtt8H/1MJOZHo=; b=GvYKJXdLBXe/nd/dd9S0IFz7Kc
        DApSFFMMpaY27ZuXeR2nqSEFP8RUU/Pkl8d34MXLslDBI3WJmRJSPnW33BZhEcxUQT6RAbEQygz5e
        wmx1OOzxlnHv1XEune8y/kdAhJQxPW8QP5thY6JJWNp5Gk2DMFAb6g3qZtFfqAq7LGo7qMoGttJGm
        IcLLFVyfMQnaHenxxhFLvvBZUJfkaT1uVVtYgXD4eYDkGGI9Bdq/zS7Uj0g3a7THOQnbRDW0rmXE1
        tXhPtlKt2fv8RTcfQss0vXssy9kx/CW0rRDZ7k7Ia4opAoWDFqrhdVizDD0W1HdlCLTZU/FXY23vo
        jeD1xw9g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXhWj-00080q-FW; Fri, 25 Mar 2022 11:50:41 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 8/8] connntrack: Fix for memleak when parsing -j arg
Date:   Fri, 25 Mar 2022 11:50:03 +0100
Message-Id: <20220325105003.26621-9-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220325105003.26621-1-phil@nwl.cc>
References: <20220325105003.26621-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Have to free the strings allocated by split_address_and_port().

Fixes: 29b390a212214 ("conntrack: Support IPv6 NAT")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/conntrack.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/conntrack.c b/src/conntrack.c
index 679a1d27e250a..894bf3f6bf440 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -3113,6 +3113,8 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 					nfct_set_nat_details(c, tmpl->ct, &ad,
 							     port_str, family);
 				}
+				free(port_str);
+				free(nat_address);
 			}
 			break;
 		case 'w':
-- 
2.34.1

