Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159E3C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Mar 2022 10:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350397AbiCYKwM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 06:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350224AbiCYKwL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 06:52:11 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8D6CC527
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2022 03:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=T+8wLPt3Wh2iu+yBXGUIBnhUPXF2LOqghD0WWugEqak=; b=LIpAuoK2NIH13Vlno/cvWB2ICh
        t/jkl7CEeKaL12H8MEdIVavYoxJQMHIV04MPam4CS5sXL02M1xpOm71Nh4vdRuitdT1rZcHjXEdE5
        VeL379I78PiKZ3+DkkiUATA2C0sLuyhkXwvJ1R/u1c1iOfH2u6WyAMi3MdpzM12cJSRXG1NZF3zV9
        0b2u1ltKi6fpPw3CUL8leVjD0TjkIDExmNfDWzoowavRO11bYf5asOhiq7kQwCbWsZnFPE0YUN9ch
        /Rrdaaa1fLctEJrHwg/OVp3rhoCYjllNnzt45Gq17hIT1UDjFWGwnFsY0Yzs7tkhVzIlGFqdgMAC4
        KN++xQZQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXhWe-00080J-6G; Fri, 25 Mar 2022 11:50:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 1/8] hash: Flush tables when destroying
Date:   Fri, 25 Mar 2022 11:49:56 +0100
Message-Id: <20220325105003.26621-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220325105003.26621-1-phil@nwl.cc>
References: <20220325105003.26621-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is cosmetics only, but stops valgrind from complaining about
definitely lost memory.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/hash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/hash.c b/src/hash.c
index fe6a047fcebe0..a0f240c21fa82 100644
--- a/src/hash.c
+++ b/src/hash.c
@@ -55,6 +55,7 @@ hashtable_create(int hashsize, int limit,
 
 void hashtable_destroy(struct hashtable *h)
 {
+	hashtable_flush(h);
 	free(h);
 }
 
-- 
2.34.1

