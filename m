Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54131C6FA8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbjH2Nny (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 09:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236578AbjH2Nnr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 09:43:47 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06485CD1
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 06:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SW6DSsy7N8dnABuVHoWPk9JbIAyAcWwdrupW8HXoUm0=; b=P+McHraMdxrv/LG96Z+qTsWFGz
        Mrtq5tuOFo4ONf0y9/VDci5YRz0eGxIBi/Diavfh9tH1O0pW4UTB7ZQDDBU6vEAtHZ8vg8r+KN9nk
        uoDBna8AxySLf5L+/1RD0OSPEBSpJMQgjJu6NY/9Lmi60esYu2BboQlfyYcsR+x9+CP710saeKzcK
        2YFkrpfWhFblq2N7DlMpgZIHVHC78cDGMbF/l53I7NnYfQ9QCOf/dc8LD5ZtZ/fHlXV5te2hZv1fT
        /VqhyLY45pRYi+Zlv2UDYeDXMeRxTRmIKCWAXhjB1OxPpS92FuDXk5J3biOWfJkOYLdQThFxIYF1t
        VSv0DBrQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qayzH-0000TE-3b
        for netfilter-devel@vger.kernel.org; Tue, 29 Aug 2023 15:42:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/4] tests: monitor: Fix time format in ct timeout test
Date:   Tue, 29 Aug 2023 15:48:10 +0200
Message-ID: <20230829134812.31863-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829134812.31863-1-phil@nwl.cc>
References: <20230829134812.31863-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The old "plain" numbers are still accepted (and assumed to be in
seconds), but output will use units which is unexpected due to 'O -'.
Adjust input instead of adding this subtly different output line.

Fixes: 5c25c5a35cbd2 ("parser: allow ct timeouts to use time_spec values")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/testcases/object.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/monitor/testcases/object.t b/tests/monitor/testcases/object.t
index 2afe33c812571..53a9f8c59836b 100644
--- a/tests/monitor/testcases/object.t
+++ b/tests/monitor/testcases/object.t
@@ -37,7 +37,7 @@ I delete ct helper ip t cth
 O -
 J {"delete": {"ct helper": {"family": "ip", "name": "cth", "table": "t", "handle": 0, "type": "sip", "protocol": "tcp", "l3proto": "ip"}}}
 
-I add ct timeout ip t ctt { protocol udp; l3proto ip; policy = { unreplied : 15, replied : 12 }; }
+I add ct timeout ip t ctt { protocol udp; l3proto ip; policy = { unreplied : 15s, replied : 12s }; }
 O -
 J {"add": {"ct timeout": {"family": "ip", "name": "ctt", "table": "t", "handle": 0, "protocol": "udp", "l3proto": "ip", "policy": {"unreplied": 15, "replied": 12}}}}
 
-- 
2.41.0

