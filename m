Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A719C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239135AbiKWQoN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239137AbiKWQoM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:44:12 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B316DFC7
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GS0aX4nQY8lJOJKQYG4K4gNHK+g8bZKO0CDAGZILbcw=; b=Dmu7lKGGusnmWjAOWdIHrQ11pf
        vXYxl02BOZp23jUaDSD9d06yLykAY6z/VZZ1TiZLe8UK0YG/xxrUoXyazn2tRgv08ARs1zTqBs7tv
        xzORRgDqSIFqkdDe4BZV7q5bKZbsTlyRFxZcHHMotQFLEO1klcuagFVl/JdoHzb1uiKeXTYlZ3XbV
        b+lTj+kdK4ZuUvkrNdTeKoLvTkcs8wxv1VF1REWpqtHoz64QC32faZ4Q5YkpMhnlQQXdENABaxHdC
        dS08g8DLtdE1EXUagl1FN6R6Ckle6kd5Dp+tt+KG+iLDZD4lbptx7s0mUC7D5dK/CudA0PCQnq1rY
        UEd0Kpew==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsr3-0003x3-EN
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:44:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 02/13] extensions: libebt_mark: Fix xlate test case
Date:   Wed, 23 Nov 2022 17:43:39 +0100
Message-Id: <20221123164350.10502-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The false suffix effectively disabled this test file, but it also has
problems: Apart from brmark_xlate() printing 'meta mark' instead of just
'mark', target is printed in the wrong position (like with any other
target-possessing extension.

Fixes: e67c08880961f ("ebtables-translate: add initial test cases")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_mark.txlate | 11 +++++++++++
 extensions/libebt_mark.xlate  | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)
 create mode 100644 extensions/libebt_mark.txlate
 delete mode 100644 extensions/libebt_mark.xlate

diff --git a/extensions/libebt_mark.txlate b/extensions/libebt_mark.txlate
new file mode 100644
index 0000000000000..7529302d9a444
--- /dev/null
+++ b/extensions/libebt_mark.txlate
@@ -0,0 +1,11 @@
+ebtables-translate -A INPUT --mark-set 42
+nft add rule bridge filter INPUT meta mark set 0x2a accept counter
+
+ebtables-translate -A INPUT --mark-or 42 --mark-target RETURN
+nft add rule bridge filter INPUT meta mark set meta mark or 0x2a return counter
+
+ebtables-translate -A INPUT --mark-and 42 --mark-target ACCEPT
+nft add rule bridge filter INPUT meta mark set meta mark and 0x2a accept counter
+
+ebtables-translate -A INPUT --mark-xor 42 --mark-target DROP
+nft add rule bridge filter INPUT meta mark set meta mark xor 0x2a drop counter
diff --git a/extensions/libebt_mark.xlate b/extensions/libebt_mark.xlate
deleted file mode 100644
index e0982a1e8ebd7..0000000000000
--- a/extensions/libebt_mark.xlate
+++ /dev/null
@@ -1,11 +0,0 @@
-ebtables-translate -A INPUT --mark-set 42
-nft add rule bridge filter INPUT mark set 0x2a counter
-
-ebtables-translate -A INPUT --mark-or 42 --mark-target RETURN
-nft add rule bridge filter INPUT mark set mark or 0x2a counter return
-
-ebtables-translate -A INPUT --mark-and 42 --mark-target ACCEPT
-nft add rule bridge filter INPUT mark set mark and 0x2a counter accept
-
-ebtables-translate -A INPUT --mark-xor 42 --mark-target DROP
-nft add rule bridge filter INPUT mark set mark xor 0x2a counter drop
-- 
2.38.0

