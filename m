Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059F6C47409
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 22:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1AF5206B7
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 22:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="bVhctQv6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgASW5N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 17:57:13 -0500
Received: from kadath.azazel.net ([81.187.231.250]:56592 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728932AbgASW5M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 17:57:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WlEUaKYegEY32IoeaEOTSvwQTk2z6+ByYTHyZMdUJAY=; b=bVhctQv6xKojehQgl1/6Om6xj2
        ICcytQ6o2EXiZtZZ8xC1WdjHNUoQMp1jxIOuuVFQ1vnAKz3eHe8a8R6R+YhmesVEnJ+1ViIiacbW7
        fwRw1K8asN6UGm45do1M8A4B3iP7EOJdsnaae+BzyMf0zVcOFOQ1oy+53lOiMD26AnvUsvlfWG6eh
        Owrop7LJUla//0U6xKVaz4S6se+Exp8de5OQ/MPXhNS5/zMcg+KDAMbjZ3asb47ZDec9ztbo1URAR
        3YEUChb/RcsAakUbHZQ1epa/dJGiCJp6TbnMq/lG2NEX3iRlP/Kz/UfrMEe7YV0rpy/kzlWe/rpYa
        uLoz1YMg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1itJVH-0006wh-Ll
        for netfilter-devel@vger.kernel.org; Sun, 19 Jan 2020 22:57:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 9/9] tests: shell: add bit-shift tests.
Date:   Sun, 19 Jan 2020 22:57:10 +0000
Message-Id: <20200119225710.222976-10-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119225710.222976-1-jeremy@azazel.net>
References: <20200119225710.222976-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a couple of tests for setting the CT mark to a bitwise expression
derived from the packet mark and vice versa.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/shell/testcases/chains/0040mark_shift_0         | 11 +++++++++++
 tests/shell/testcases/chains/0040mark_shift_1         | 11 +++++++++++
 .../shell/testcases/chains/dumps/0040mark_shift_0.nft |  6 ++++++
 .../shell/testcases/chains/dumps/0040mark_shift_1.nft |  6 ++++++
 4 files changed, 34 insertions(+)
 create mode 100755 tests/shell/testcases/chains/0040mark_shift_0
 create mode 100755 tests/shell/testcases/chains/0040mark_shift_1
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_shift_0.nft
 create mode 100644 tests/shell/testcases/chains/dumps/0040mark_shift_1.nft

diff --git a/tests/shell/testcases/chains/0040mark_shift_0 b/tests/shell/testcases/chains/0040mark_shift_0
new file mode 100755
index 000000000000..b40ee2dd5278
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_shift_0
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority mangle; }
+  add rule t c oif lo ct mark set meta mark << 8 | 0x10
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/0040mark_shift_1 b/tests/shell/testcases/chains/0040mark_shift_1
new file mode 100755
index 000000000000..b609f5ef10ad
--- /dev/null
+++ b/tests/shell/testcases/chains/0040mark_shift_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook input priority mangle; }
+  add rule t c iif lo ct mark & 0xff 0x10 meta mark set ct mark >> 8
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/chains/dumps/0040mark_shift_0.nft b/tests/shell/testcases/chains/dumps/0040mark_shift_0.nft
new file mode 100644
index 000000000000..8dacf427c590
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_shift_0.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority mangle; policy accept;
+		oif "lo" ct mark set meta mark << 8 | 0x00000010
+	}
+}
diff --git a/tests/shell/testcases/chains/dumps/0040mark_shift_1.nft b/tests/shell/testcases/chains/dumps/0040mark_shift_1.nft
new file mode 100644
index 000000000000..56ec8dc766ca
--- /dev/null
+++ b/tests/shell/testcases/chains/dumps/0040mark_shift_1.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook input priority mangle; policy accept;
+		iif "lo" ct mark & 0x000000ff == 0x00000010 meta mark set ct mark >> 8
+	}
+}
-- 
2.24.1

