Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E929C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Oct 2022 15:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiJLPTH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 11:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiJLPSq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 11:18:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A368E312D
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2022 08:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UdaADY8Cl+pPwPG0whcUIkSN19IH+beojIaCT2ovzzY=; b=DlMEiEDgUiTT+0Pbz0SprFIeC2
        OR8mKuPPojzyRYNNvwUQHQ8e9qaAqG9XanIir5unXRQYyxeZhXd2QonOCwWkFIMQg2b8zEK5pFI6O
        +hV0bozgvaUSaSYFyBsB3krtp69ZkcmwDd0FV8w61Ucx1ELXOmNWtMPrC3QWyMH8sZUZXuH1CWmQU
        /YS3ITS+Qm3c8BdFTieODAL2L1GDF0UrqOi3xSu7Ax2qIT0stsSimDhykq5YaatttMdZGxbEikFr+
        wg5bgbmvf9MzJnIEHqZ9PDX5jof+0ePePC174SB8PgyfteCmioQmYFRyu22TNhJm8RRjxrlDdx6Eq
        yD6X6ATw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oidVA-0002p5-Mw; Wed, 12 Oct 2022 17:18:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 03/12] tests: iptables-test: Cover for obligatory -j CONTINUE in ebtables
Date:   Wed, 12 Oct 2022 17:17:53 +0200
Message-Id: <20221012151802.11339-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221012151802.11339-1-phil@nwl.cc>
References: <20221012151802.11339-1-phil@nwl.cc>
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
index d9b3ee4e29464..dc031c2b60450 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -287,6 +287,9 @@ STDERR_IS_TTY = sys.stderr.isatty()
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

