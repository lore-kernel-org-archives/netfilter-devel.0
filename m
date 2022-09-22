Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B171C54EE9
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Sep 2022 17:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiIVRFV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 13:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbiIVRE6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 13:04:58 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25D1857C2
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2022 10:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=laT59cCdijbr8znRmwL2oycFcOzMTk63b3lDICMIqn4=; b=X7Bxf7LyU9XLPS6v3913klKBQK
        rwY2PgN/MWbEAnYVpAYKooetKvta9goOUm+VGc4UhB0H/+B8nlOtoozESU9hxRHHF/C+5Kd19dQ6/
        GNhjpru/a4mJwbfibDOrS7Oo1LqrfZXRRSrdCz4Hw5k+Foe+OfnQAYwWsoPfSvijp6fbnHxMZfZsM
        THtWTEF1qWMV28C/CBmEJuNlWS25IJGQIr9bd6V8orl+dk/Zv0lKr2FiAQC6Yf/9Bv+g36JT1uw5a
        s9yhFZbggzvF97UmGR2euBrZGJejqb6qsPJbMRYNzi1gVz1xeXZQ48Y0DNc172+id/whncIt3wI/w
        YHKQJDyA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1obPcu-0007zH-Tr; Thu, 22 Sep 2022 19:04:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fwestpha@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH] tests: shell: Test delinearization of native nftables expressions
Date:   Thu, 22 Sep 2022 19:04:32 +0200
Message-Id: <20220922170432.5414-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Even if iptables-nft doesn't generate them anymore, it should continue
to correctly parse them. Make sure this is tested for.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../nft-only/0010-native-delinearize_0        | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0010-native-delinearize_0

diff --git a/iptables/tests/shell/testcases/nft-only/0010-native-delinearize_0 b/iptables/tests/shell/testcases/nft-only/0010-native-delinearize_0
new file mode 100755
index 0000000000000..cca36fd88d6c7
--- /dev/null
+++ b/iptables/tests/shell/testcases/nft-only/0010-native-delinearize_0
@@ -0,0 +1,26 @@
+#!/bin/bash
+
+[[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
+nft -v >/dev/null || exit 0
+
+set -e
+
+nft -f - <<EOF
+table ip filter {
+	chain FORWARD {
+		type filter hook forward priority filter;
+		limit rate 10/day counter
+		udp dport 42 counter
+	}
+}
+EOF
+
+EXPECT="*filter
+:INPUT ACCEPT [0:0]
+:FORWARD ACCEPT [0:0]
+:OUTPUT ACCEPT [0:0]
+-A FORWARD -m limit --limit 10/day
+-A FORWARD -p udp -m udp --dport 42
+COMMIT"
+
+diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables-save | grep -v '^#')
-- 
2.34.1

