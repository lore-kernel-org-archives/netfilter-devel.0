Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F34C43334
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jun 2022 11:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbiFBLxL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jun 2022 07:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbiFBLxH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jun 2022 07:53:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02E42B1D5A
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2022 04:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fovy/EiGNwch0j5VweTGllnbSaDAS01+CkgRbh6XKHc=; b=QAZaX25eotlWAyhM8uDAhsEFH2
        E/22QmfSkZT4sqqPIJmvRt/QtiO+JOSCxC+yXXMElOP/nhuJJoArlZWy130qkN2qQa44KSUHrOTE5
        O72Onteqr43DDmU1HFgTscKMp+0WII1S4g00Lz1MDx57Vx8WQTPpyYGyDJUwx0KnV/kmxrkjZyzFj
        52swKw3m/g0Yix3srJFaGsGo/l6bNFZXAdekdWnrhxg5Ze+O/QdT7YmL+JKc5wz2H7zNSW2YGstqb
        LqGeT1y7UufaU6NAzhEdwIjdKcUeArzKVWlrPFrAK6fapmDI+Q7iwddMCGR9ona40HoKhMQHCMKxV
        EnFd1MmA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nwjNq-0000Bq-10; Thu, 02 Jun 2022 13:52:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests: shell: Check overhead in iptables-save and -restore
Date:   Thu,  2 Jun 2022 13:52:49 +0200
Message-Id: <20220602115249.5908-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some repeated calls have been reduced recently, assert this in a test
evaluating strace output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../shell/testcases/ipt-save/0007-overhead_0  | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/ipt-save/0007-overhead_0

diff --git a/iptables/tests/shell/testcases/ipt-save/0007-overhead_0 b/iptables/tests/shell/testcases/ipt-save/0007-overhead_0
new file mode 100755
index 0000000000000..b86d71f209471
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-save/0007-overhead_0
@@ -0,0 +1,37 @@
+#!/bin/bash
+
+# Test recent performance improvements in iptables-save due to reduced
+# overhead.
+
+strace --version >/dev/null || { echo "skip for missing strace"; exit 0; }
+
+RULESET=$(
+	echo "*filter"
+	for ((i = 0; i < 100; i++)); do
+		echo ":mychain$i -"
+		echo "-A FORWARD -p tcp --dport 22 -j mychain$i"
+	done
+	echo "COMMIT"
+)
+
+RESTORE_STRACE=$(strace $XT_MULTI iptables-restore <<< "$RULESET" 2>&1 >/dev/null)
+SAVE_STRACE=$(strace $XT_MULTI iptables-save 2>&1 >/dev/null)
+
+do_grep() { # (name, threshold, pattern)
+	local cnt=$(grep -c "$3")
+	[[ $cnt -le $2 ]] && return 0
+	echo "ERROR: Too many $3 lookups for $1: $cnt > $2"
+	exit 1
+}
+
+# iptables prefers hard-coded protocol names instead of looking them up first
+
+do_grep "$XT_MULTI iptables-restore" 0 /etc/protocols <<< "$RESTORE_STRACE"
+do_grep "$XT_MULTI iptables-save" 0 /etc/protocols <<< "$SAVE_STRACE"
+
+# iptables-nft-save pointlessly checked whether chain jumps are targets
+
+do_grep "$XT_MULTI iptables-restore" 10 libxt_ <<< "$RESTORE_STRACE"
+do_grep "$XT_MULTI iptables-save" 10 libxt_ <<< "$SAVE_STRACE"
+
+exit 0
-- 
2.34.1

