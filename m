Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17866C4321E
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 14:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiK2OXv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 09:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiK2OXu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 09:23:50 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D0D10C9
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 06:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kiH+EaMf8IIl2NetFdFtiC0ltNNS93a/Y9qol4JUnRY=; b=I26FOyV6hO3rEn9t6axli1A4Zz
        wE7DY2qEUD3sezcZXaReHo34bk+Y4mdzZi5QZ/sllcldM2DDlsUqMIzewEvNjVc8EVNMEgCx/uK9b
        e7+8sIfCa+hczfS1LU+dzGhGUy7QUai4IlV2r4P14GxEK92qbrHAVVnhpj9VtyZ9Dmz+wNrBNQP5D
        RVvYn8prmz8Uy8X1yln1XRKjGuu5C3KDZ64fbrKVOrKCB6clsQnIA1GfiBnSSJP4IC/wxQAOk550o
        dMcepbawGIgEbFMOQiNR5OnN3eMfZ1JUJtqVjopvxjvFG3t9HrmIBxdY1zBQgODWEc3EIGmdQhLOL
        dVxlPwSQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p01WU-0006Yw-3i; Tue, 29 Nov 2022 15:23:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fwestpha@redhat.com>
Subject: [iptables PATCH] tests: shell: Test selective ebtables flushing
Date:   Tue, 29 Nov 2022 15:23:38 +0100
Message-Id: <20221129142338.2394-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Found this on disk, maybe there was a problem with this and among match
at some point? Anyway, it is relevant again since it fails recently.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../shell/testcases/ebtables/0006-flush_0     | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/ebtables/0006-flush_0

diff --git a/iptables/tests/shell/testcases/ebtables/0006-flush_0 b/iptables/tests/shell/testcases/ebtables/0006-flush_0
new file mode 100755
index 0000000000000..5d714529c4409
--- /dev/null
+++ b/iptables/tests/shell/testcases/ebtables/0006-flush_0
@@ -0,0 +1,47 @@
+#!/bin/bash
+
+set -e
+
+# there is no legacy backend to test
+[[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
+
+RULESET='*filter
+:INPUT ACCEPT
+:FORWARD ACCEPT
+:OUTPUT ACCEPT
+-A FORWARD --among-dst fe:ed:ba:be:13:37=10.0.0.1 -j ACCEPT
+-A OUTPUT --among-src c0:ff:ee:90:0:0=192.168.0.1 -j DROP
+*nat
+:PREROUTING ACCEPT
+:OUTPUT ACCEPT
+:POSTROUTING ACCEPT
+-A OUTPUT --among-src c0:ff:ee:90:90:90=192.168.0.1 -j DROP'
+
+$XT_MULTI ebtables-restore <<<$RULESET
+diff -u <(echo -e "$RULESET") <($XT_MULTI ebtables-save | grep -v '^#')
+
+RULESET='*filter
+:INPUT ACCEPT
+:FORWARD ACCEPT
+:OUTPUT ACCEPT
+-A FORWARD --among-dst fe:ed:ba:be:13:37=10.0.0.1 -j ACCEPT
+-A OUTPUT --among-src c0:ff:ee:90:0:0=192.168.0.1 -j DROP
+*nat
+:PREROUTING ACCEPT
+:OUTPUT ACCEPT
+:POSTROUTING ACCEPT'
+
+$XT_MULTI ebtables -t nat -F
+diff -u <(echo -e "$RULESET") <($XT_MULTI ebtables-save | grep -v '^#')
+
+RULESET='*filter
+:INPUT ACCEPT
+:FORWARD ACCEPT
+:OUTPUT ACCEPT
+*nat
+:PREROUTING ACCEPT
+:OUTPUT ACCEPT
+:POSTROUTING ACCEPT'
+
+$XT_MULTI ebtables -t filter -F
+diff -u <(echo -e "$RULESET") <($XT_MULTI ebtables-save | grep -v '^#')
-- 
2.38.0

