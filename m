Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1704CCA48A
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245336AbiFHQ2P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245324AbiFHQ2O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:28:14 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D021FE4E8
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DeyZwfnzHGyMnErROqde0Yo93T6RM+HVQru+J2nRYK4=; b=PjdogZyFjXxmCmQS31DQZsqwr5
        fTfkvgHCF7A3rwJIMoe0/jVqemqeRz2FVxgp8UN3ShKMKbeLuJfYrAFiXLyS+N0gy4wSaFdsR5G7r
        t5Zo93ZgZpoOogusmqpAPoNNo7gCWw7B0Fs0cIMYsZLMM9xnGIruwwm1Cx3btG8E+CSxDSroOt8u3
        u0kbjUmJlcseK97kOFbbaI/A1N4gd1ckUvXeerZzUWutHXtDdGgtSHDYVloZLJ1UugjuPkRiXtpnZ
        /FTlMkqIr12fqfaZI6n7QNi6o5SSZUiaMhsXkA4ULHmyXCFDYIql4uMf6lhd+q7qHUUqV2VmHra85
        xBGe3DYA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nyyXR-00085X-VT
        for netfilter-devel@vger.kernel.org; Wed, 08 Jun 2022 18:28:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/9] tests: shell: Extend iptables-xml test a bit
Date:   Wed,  8 Jun 2022 18:27:06 +0200
Message-Id: <20220608162712.31202-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220608162712.31202-1-phil@nwl.cc>
References: <20220608162712.31202-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Call with --combine as well, even though output doesn't differ. Also
there's no need to skip for xtables-nft-multi, it provides the same
functionality.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../tests/shell/testcases/ipt-save/0006iptables-xml_0  | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/iptables/tests/shell/testcases/ipt-save/0006iptables-xml_0 b/iptables/tests/shell/testcases/ipt-save/0006iptables-xml_0
index 50c0cae888341..bcfaad36f1249 100755
--- a/iptables/tests/shell/testcases/ipt-save/0006iptables-xml_0
+++ b/iptables/tests/shell/testcases/ipt-save/0006iptables-xml_0
@@ -1,13 +1,5 @@
 #!/bin/bash
 
-case "$(basename $XT_MULTI)" in
-	xtables-legacy-multi)
-		;;
-	*)
-		echo "skip $XT_MULTI"
-		exit 0
-		;;
-esac
-
 dump=$(dirname $0)/dumps/fedora27-iptables
 diff -u -Z <(cat ${dump}.xml) <($XT_MULTI iptables-xml <$dump)
+diff -u -Z <(cat ${dump}.xml) <($XT_MULTI iptables-xml -c <$dump)
-- 
2.34.1

