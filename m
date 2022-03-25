Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96F6C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Mar 2022 10:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348363AbiCYKvz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 06:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244186AbiCYKvz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 06:51:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66133AA7F
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2022 03:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4SrNXk04BxZqMzcYmRlFZKyLmvTOMj3lfIhADYzqZP0=; b=UiIIhkTIydnkFLXZyZ3NiXzi8f
        8N11SDepQu9PNlMEjnifehRavxcba+UR9wwcIJsTD+aGOkwjyMRiPq/54TPYWdDXjrd3tt08Eo5JW
        p5ClrdR3lU+zyOwO9cZFnPKV6/azbYUIhok8qHU0tdH7w+agfrVTs6nX8Ce/4RVWXJwo+Iuw1mJ3H
        K8UbiPX/nQ3WO1gDyRNysiBrgOcD47bTQNgPObVS5x637gN/69vmgg2MzT619ET+W32o+T66QYUvI
        UEs0uSySveTJJ7S7KxuoWfH39/VyiPJk8bQDSNKMIk/nW9FStil2gJBTl//6ABPBcH8viQWJgWJxU
        xRR+PdUQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXhWO-0007z3-AH; Fri, 25 Mar 2022 11:50:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 6/8] Don't call exit() from signal handler
Date:   Fri, 25 Mar 2022 11:50:01 +0100
Message-Id: <20220325105003.26621-7-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220325105003.26621-1-phil@nwl.cc>
References: <20220325105003.26621-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Coverity tool complains that exit() is not signal-safe and therefore
should not be called from within a signal handler. Call _exit() instead.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/run.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/run.c b/src/run.c
index f11a5327fe5e6..37a0eb1c6b957 100644
--- a/src/run.c
+++ b/src/run.c
@@ -67,7 +67,7 @@ void killer(int signo)
 	close_log();
 
 	sd_ct_stop();
-	exit(0);
+	_exit(0);
 }
 
 static void child(int foo)
-- 
2.34.1

