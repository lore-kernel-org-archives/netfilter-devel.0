Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD53C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Dec 2022 15:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiLTPjJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 10:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiLTPjI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 10:39:08 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360EE11474
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2022 07:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2C2lTkbVWkoFkZMvRmmoLROS0eIgcWt+WSbrvru+LEw=; b=oLeaqK0ex8VXpcfkB2Q8TuE3mB
        rMqJJkkmr9L5U3djXmzxKfEdcCD0RaEQ1BoyH2n3qd5gfoSYYcOWW1Gf2vxz0kEUHrj67+ni/IgtO
        GpfiESFlMw8O+Mp6cFUlDaP3kpx1Ad7iJxURmhiDqo4R5/Z3F6aE1sYsN/SoZOy6PQEI1DPbANPs6
        bYeq6VctmHA5WJCDXnDyz2M+1Xh/tDzLPNkc6E3XLJLxFaYA321aWachAmDUFDlbIvOqZx6tQ/0Ur
        LhqazLkOxG+ty8oejEs9kP6CCsQJxQ8pnL95NbbOLnwA3EFgVzjn/Sk9uFQXTTofb1d2km4jtvTUb
        LTRSb4aw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p7ehu-0000Fc-LO; Tue, 20 Dec 2022 16:39:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 3/4] conntrack: Fix for unused assignment in ct_save_snprintf()
Date:   Tue, 20 Dec 2022 16:38:46 +0100
Message-Id: <20221220153847.24152-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221220153847.24152-1-phil@nwl.cc>
References: <20221220153847.24152-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Setting 'ret' without calling BUFFER_SIZE() is pointless.

Fixes: 1c596b9ec8f26 ("conntrack: implement save output format")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/conntrack.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 07fae3dc2ff07..2bd71e17e6be6 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -761,7 +761,6 @@ static int ct_save_snprintf(char *buf, size_t len,
 		BUFFER_SIZE(ret, size, len, offset);
 		break;
 	default:
-		ret = 0;
 		break;
 	}
 
-- 
2.38.0

