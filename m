Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BFBCCA481
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245195AbiFHQ2I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245166AbiFHQ2H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:28:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0B91FE39C
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a3AKzdgk1SkQcfIlNJLj68xOQ+0AcIzzL4oiNBtjgzg=; b=e37M1NGeo5tbCY6T6Fv04i9go/
        rOCk9TOgEjLYsvw4rnbwzO3LviZ0vYiGrGych0Yy2h4R4QlmsQOCSt4UICZ3aFRneVaFMAnSJXNFs
        wc4TetzMNxbxEeraMwBfX0xkrrr+2pwVSR0shStxq26vN+u/BnrJFzHe4h0iE/aQ/g8iFQ3sYhchd
        FZ6WL6Kit4D0lWPUASixii/5y5pGyElYfYxAOP3aGsbH17IaT7Tnd4oG16pypLpjDabVnB5FMzBL9
        yCKabCwAlgq3rXfVHvO7VbWEYzVkwtVAgWnXRw1nKOfpTIssuQW1b7iVJkEmpIOo66l2RGRSgf2zi
        /uxkqiJQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nyyXM-00085T-Eb
        for netfilter-devel@vger.kernel.org; Wed, 08 Jun 2022 18:28:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/9] tests: shell: Extend zero counters test a bit further
Date:   Wed,  8 Jun 2022 18:27:07 +0200
Message-Id: <20220608162712.31202-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220608162712.31202-1-phil@nwl.cc>
References: <20220608162712.31202-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Test zeroing a single rule's counters as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../shell/testcases/iptables/0007-zero-counters_0 | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/iptables/tests/shell/testcases/iptables/0007-zero-counters_0 b/iptables/tests/shell/testcases/iptables/0007-zero-counters_0
index 36da1907e3b22..2179347200854 100755
--- a/iptables/tests/shell/testcases/iptables/0007-zero-counters_0
+++ b/iptables/tests/shell/testcases/iptables/0007-zero-counters_0
@@ -10,6 +10,7 @@ $XT_MULTI iptables-restore -c <<EOF
 [12:345] -A INPUT -i lo -p icmp -m comment --comment "$COUNTR"
 [22:123] -A FOO -m comment --comment one
 [44:123] -A FOO -m comment --comment two
+[66:123] -A FOO -m comment --comment three
 COMMIT
 EOF
 EXPECT="*filter
@@ -20,6 +21,7 @@ EXPECT="*filter
 [0:0] -A INPUT -i lo -p icmp -m comment --comment "$COUNTR"
 [0:0] -A FOO -m comment --comment one
 [0:0] -A FOO -m comment --comment two
+[0:0] -A FOO -m comment --comment three
 COMMIT"
 
 COUNTER=$($XT_MULTI iptables-save -c |grep "comment $COUNTR"| cut -f 1 -d " ")
@@ -28,6 +30,18 @@ if [ $COUNTER != "[12:345]" ]; then
 	RC=1
 fi
 
+$XT_MULTI iptables -Z FOO 2
+COUNTER=$($XT_MULTI iptables-save -c | grep "comment two"| cut -f 1 -d " ")
+if [ $COUNTER != "[0:0]" ]; then
+	echo "Counter $COUNTER is wrong, should have been zeroed"
+	RC=1
+fi
+COUNTER=$($XT_MULTI iptables-save -c | grep "comment three"| cut -f 1 -d " ")
+if [ $COUNTER != "[66:123]" ]; then
+	echo "Counter $COUNTER is wrong, should not have been zeroed"
+	RC=1
+fi
+
 $XT_MULTI iptables -Z FOO
 COUNTER=$($XT_MULTI iptables-save -c |grep "comment $COUNTR"| cut -f 1 -d " ")
 if [ $COUNTER = "[0:0]" ]; then
@@ -60,5 +74,6 @@ fi
 $XT_MULTI iptables -D INPUT -i lo -p icmp -m comment --comment "$COUNTR"
 $XT_MULTI iptables -D FOO -m comment --comment one
 $XT_MULTI iptables -D FOO -m comment --comment two
+$XT_MULTI iptables -D FOO -m comment --comment three
 $XT_MULTI iptables -X FOO
 exit $RC
-- 
2.34.1

