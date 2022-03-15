Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30C9C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 13:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbiCON1j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 09:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348639AbiCON1h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 09:27:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B2342ED0
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 06:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qJURK09tikeCOhVB4/kLq2uqK7PzuUsqF3UN0ombla4=; b=FgPmlMcd/gH+dvAQKU9RO/9S5c
        F/O99qbUIar9DaiyBP5QoFDCm5u6mn3wogKVRapCgM/mOM7uN2cQXzpnVTfalcuUutOD4IZsLPlUD
        xb4i8HIpfxcoC6ov1xNddQMHsT2FzgmQnRoI7IhNIHDLN50YyYvgNFmLDEGUDjQeG8rA0z6hksywT
        1A5nI6KlSA8ZiUmcuj7Aedwk7bi21XdM9BV8YPUDx6LhUOdA1eKKEhJabNOABA6Is1shNXEIX1dEz
        Ocjr7BBDR0dsYN3YOSKXdIqcJlgWktDJBguSr61bLjrHcgWqpQw2WAtrQYrP6DTxZaZRnqBDA9zeM
        DwDW7oDQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nU7Bt-0000qy-Mb; Tue, 15 Mar 2022 14:26:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Etienne <champetier.etienne@gmail.com>
Subject: [iptables PATCH 5/5] tests: shell: Fix 0004-return-codes_0 for static builds
Date:   Tue, 15 Mar 2022 14:26:19 +0100
Message-Id: <20220315132619.20256-6-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315132619.20256-1-phil@nwl.cc>
References: <20220315132619.20256-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In static builds, xtables_find_match() returns a slightly different
error message if not found - make grep accept both.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/tests/shell/testcases/iptables/0004-return-codes_0 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/tests/shell/testcases/iptables/0004-return-codes_0 b/iptables/tests/shell/testcases/iptables/0004-return-codes_0
index dcd9dfd3c0806..33c5f1f35d17f 100755
--- a/iptables/tests/shell/testcases/iptables/0004-return-codes_0
+++ b/iptables/tests/shell/testcases/iptables/0004-return-codes_0
@@ -39,7 +39,7 @@ E2BIG_D=": Index of deletion too big."
 E2BIG_R=": Index of replacement too big."
 EBADRULE=": Bad rule (does a matching rule exist in that chain?)."
 #ENOTGT=" v[0-9\.]* [^ ]*: Couldn't load target \`foobar':No such file or directory"
-ENOMTH=" v[0-9\.]* [^ ]*: Couldn't load match \`foobar':No such file or directory"
+ENOMTH=" v[0-9\.]* [^ ]*: Couldn't \(load\|find\) match \`foobar'\(:No such file or directory\|\)"
 ENOTBL=": can't initialize iptables table \`foobar': Table does not exist"
 
 # test chain creation
-- 
2.34.1

