Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F53BC352A1
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiLGRpA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLGRor (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 12:44:47 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0D556549
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 09:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hOowBiZnq9cWjSnged+eeIs3MLMLp6B/sQth6aZceFE=; b=i2UHJeSKj0vcL89DIpFKor0j5C
        Ju6XUEfUPyGDYeBwBjnec9vXtpSgmCdHrXAPJKU+uP1mM47kTM83EF+qWJriPQc6qs43tzDArYwbf
        2e8ac8qF17N2LgxbsA/E5n1CDqGL8elpzL58Mx630Fe8xGmwLVXuK7W3pnE7OROh6KhS6RaHkdxoW
        wlsqoBCkVKUgdWc+OspLLefnCDW9RFExlWVnTCiYf/+7y/KOeNPSUqp5NogPAGlpyN5mHHNSZcy1V
        gRfzSMuscdgG0v5qj+Lzn5De6+ZLJsuDoughkBjKByxNf+i6a78f8zrPdeYqZUzO2NBXhoLF0Ijct
        cDJyza5g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p2yTM-0000fN-OI
        for netfilter-devel@vger.kernel.org; Wed, 07 Dec 2022 18:44:44 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 03/11] Makefile: Generate ip6tables man pages on the fly
Date:   Wed,  7 Dec 2022 18:44:22 +0100
Message-Id: <20221207174430.4335-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221207174430.4335-1-phil@nwl.cc>
References: <20221207174430.4335-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to drag them around, creating them is simple.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/Makefile.am         | 3 +++
 iptables/ip6tables-apply.8   | 1 -
 iptables/ip6tables-restore.8 | 1 -
 iptables/ip6tables-save.8    | 1 -
 iptables/ip6tables.8         | 1 -
 5 files changed, 3 insertions(+), 4 deletions(-)
 delete mode 100644 iptables/ip6tables-apply.8
 delete mode 100644 iptables/ip6tables-restore.8
 delete mode 100644 iptables/ip6tables-save.8
 delete mode 100644 iptables/ip6tables.8

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 23f8352d30610..acd3ce0c438e1 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -105,6 +105,9 @@ iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../e
 iptables-translate.8 ip6tables-translate.8 iptables-restore-translate.8 ip6tables-restore-translate.8:
 	${AM_VERBOSE_GEN} echo '.so man8/xtables-translate.8' >$@
 
+ip6tables.8 ip6tables-apply.8 ip6tables-restore.8 ip6tables-save.8:
+	${AM_VERBOSE_GEN} sed 's|^ip6|.so man8/ip|' <<<$@ >$@
+
 pkgconfig_DATA = xtables.pc
 
 # Using if..fi avoids an ugly "error (ignored)" message :)
diff --git a/iptables/ip6tables-apply.8 b/iptables/ip6tables-apply.8
deleted file mode 100644
index 994b487a43598..0000000000000
--- a/iptables/ip6tables-apply.8
+++ /dev/null
@@ -1 +0,0 @@
-.so man8/iptables-apply.8
diff --git a/iptables/ip6tables-restore.8 b/iptables/ip6tables-restore.8
deleted file mode 100644
index cf4ea3e7926c4..0000000000000
--- a/iptables/ip6tables-restore.8
+++ /dev/null
@@ -1 +0,0 @@
-.so man8/iptables-restore.8
diff --git a/iptables/ip6tables-save.8 b/iptables/ip6tables-save.8
deleted file mode 100644
index 182f55c12f962..0000000000000
--- a/iptables/ip6tables-save.8
+++ /dev/null
@@ -1 +0,0 @@
-.so man8/iptables-save.8
diff --git a/iptables/ip6tables.8 b/iptables/ip6tables.8
deleted file mode 100644
index 0dee41adb3965..0000000000000
--- a/iptables/ip6tables.8
+++ /dev/null
@@ -1 +0,0 @@
-.so man8/iptables.8
-- 
2.38.0

