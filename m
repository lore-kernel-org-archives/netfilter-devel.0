Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9666C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiJFA2h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiJFA23 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:28:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E739582D13
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RmV1Ibk4MkJ7Qkkw2qC+nVeDABlK/En6oJyoS7YRE7c=; b=S8CrPqXrqiaeucX9DEU61ylsA1
        qb+Yuv5ZavtaNtu4rM0KaXerwnBO4YVF2yJh+NCB10YjeoAsmIZqydtloqoL1A2iabp81r9SmJBLy
        LsCTP0/LCObOhlMbwL1r1ZLXg5cFTrldtUgItecYgDwp0uIc1bxklhzeE3ACW1YjCRhEGZTPXZSxH
        JihXNmtuE3nEkzdEMo8esL8tvaLSZyTS9+2M+bpn+5ghWj5aKEJnrxgRH0pbvMxToRLuxln+rJ7UA
        CcRbxiigEHNjslNvjYJ1jSNTjhOQJmwQ0fMEXinJSyNRL43ANhHvWQMxKsAwCVckjzd3LG68a2AwK
        1kAmqFJQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogEkK-0001wa-K0; Thu, 06 Oct 2022 02:28:16 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 02/12] tests: iptables-test: Cover for obligatory -j CONTINUE in ebtables
Date:   Thu,  6 Oct 2022 02:27:52 +0200
Message-Id: <20221006002802.4917-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221006002802.4917-1-phil@nwl.cc>
References: <20221006002802.4917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unlike iptables, ebtables includes the default rule target in output.
Instead of adding it to every rule in ebtables tests, add special casing
to the testscript checking if the expected rule output contains a target
already and adding the default one if not.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables-test.py | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/iptables-test.py b/iptables-test.py
index 89220f29fe552..ac4f37c614452 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -323,6 +323,9 @@ STDERR_IS_TTY = sys.stderr.isatty()
             else:
                 rule_save = chain + " " + item[1]
 
+            if iptables == EBTABLES and rule_save.find('-j') < 0:
+                rule_save += " -j CONTINUE"
+
             res = item[2].rstrip()
             if res != "OK":
                 rule = chain + " -t " + table + " " + item[0]
-- 
2.34.1

