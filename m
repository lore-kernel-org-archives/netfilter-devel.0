Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C33E7C83F1A
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbjH2Nny (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 09:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236555AbjH2Nno (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 09:43:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A63E1BD
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 06:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0HbVWAVbF9GTV/yM8S5rWMWYLJ7ytyMFxf3OR4yaVyc=; b=Ev6a5MahD7edT7hBfDSovfTMQ8
        N9WYZ3yr8pueY3z1YDjUCgyhg4vTFuNGxp5FNe2jXe+aBVIZjx4aFRW+cnxuaTrfdWukaXMoJETDK
        g0hQRtKhcvXp5j7FLzSu1YjDjr1pXyN8Zc0DrqdFO90RQZtoHOjngzPfgTfMNBrzEZ8ivPyg8NmU/
        CIsS7xhobcgVFKXAWwB/oKSxb6cRrDKpkzgGD5gjoJ9aamskNDaXn0vPeTyMOOCDDkkhXoga0SPbz
        XWypBMUMBAD8E3iMBXTOqO3ID9vm/8n41et7LweerQhoSUIAoZHIkG7Fx/JzXj477it6SpQDePCzf
        xwpymjVA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qayzG-0000T5-H6
        for netfilter-devel@vger.kernel.org; Tue, 29 Aug 2023 15:42:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/4] tests: monitor: Fix for wrong ordering in expected JSON output
Date:   Tue, 29 Aug 2023 15:48:12 +0200
Message-ID: <20230829134812.31863-4-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829134812.31863-1-phil@nwl.cc>
References: <20230829134812.31863-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adjust JSON for delete before add for replace after respective kernel
fix, too.

Fixes: ba786ac758fba ("tests: monitor: update insert and replace commands")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/testcases/simple.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/monitor/testcases/simple.t b/tests/monitor/testcases/simple.t
index c1c7bcfc08beb..67be5c85ab85d 100644
--- a/tests/monitor/testcases/simple.t
+++ b/tests/monitor/testcases/simple.t
@@ -20,8 +20,8 @@ J {"insert": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0,
 I replace rule ip t c handle 2 accept comment "foo bar"
 O delete rule ip t c handle 2
 O add rule ip t c handle 5 accept comment "foo bar"
-J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "comment": "foo bar", "expr": [{"accept": null}]}}}
 J {"delete": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"accept": null}]}}}
+J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "comment": "foo bar", "expr": [{"accept": null}]}}}
 
 I add counter ip t cnt
 O add counter ip t cnt { packets 0 bytes 0 }
-- 
2.41.0

