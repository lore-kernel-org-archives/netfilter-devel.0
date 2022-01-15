Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94AF0C43217
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jan 2022 18:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbiAOS1x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 13:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiAOS1v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 13:27:51 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E148C06161C
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2022 10:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ohTsWIVSzo6iuPgFqx9J+sB+Xq9yLmPRDlmrYXM/Ekw=; b=eQS78D9dlpLAHFZWEfj4bmrI3V
        JbGA4dccKugMjhB7o4QFnYANP19ULtycq9EsI/9Y7WDeKu9rfgPg9X1GXfDIT0tlCef3Eo/C0thnj
        6yU1D6a+uzFMgKHeB4ob1ZFtgEneAQt99EUeBeL7obeW7702GVtZO1ClTS1/IQP6M7+sWSsGrSRlT
        HoHoHZM2cSZtklZ7NPFkC+bj3gTwxPfmvyEJeZanh8vKGsVxVcHvsLW3EnNQmta2Y34kReEHEcSbT
        ZuqoxWa2CSOmL3iIEPgz9z3+urIveEZOpwugWlnB3Z5yzpZcHbuVhQJXFpppLyj7Wt6hRYgkTbxFe
        rtDQoPEA==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n8nmH-008OQb-4u; Sat, 15 Jan 2022 18:27:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v2 1/5] tests: py: fix inet/ip.t bridge payload
Date:   Sat, 15 Jan 2022 18:27:05 +0000
Message-Id: <20220115182709.1999424-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220115182709.1999424-1-jeremy@azazel.net>
References: <20220115182709.1999424-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Correct the statement used to load the protocol in the bridge payload
of one of the ip tests.

A previous commit was supposed, in part, to do this, but the update got
lost.

Fixes: 4b8e51ea5fc8 ("tests: py: fix inet/ip.t payloads")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/inet/ip.t.payload.bridge | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/py/inet/ip.t.payload.bridge b/tests/py/inet/ip.t.payload.bridge
index a422ed76c2de..57dbc9eb42e7 100644
--- a/tests/py/inet/ip.t.payload.bridge
+++ b/tests/py/inet/ip.t.payload.bridge
@@ -3,7 +3,7 @@ __set%d test-bridge 3
 __set%d test-bridge 0
 	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
-- 
2.34.1

