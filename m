Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53B0CDB46E
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Oct 2023 16:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343934AbjJLQH0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Oct 2023 12:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347317AbjJLQHN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2023 12:07:13 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CE6D9
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Oct 2023 09:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4A+RyOrMKH97qJUzVlWFwY3E+4qBe5Q621iMC5GsZG4=; b=J4xbUA1mNhkCoI7VuQqCJUNrYg
        yCEM/vlQUlLQMU1JAFSPWGEHpOJ+/w00RwUIDAWTds/fAvc+Q79exWfv6wvo1QYesZ0MsH3rdhFyD
        AhX4nrVDGFYb2FZVVGlEANhI1Evm8fCN1vpck/xCmxUETq4op2fOVst9Ppn6aOCHKWg9tN7Kwt8pw
        k9hFd80HerS+UGHRxcJpCoXVC+JapkhAWvIxzYNldsa1gaqrsMpm7z7iiOCLCTEehcpci+KgnPYN0
        ATelogdsU1kth/myo5KpPAFU0XYnrwwkQ+KxC5OvybKnYfE2zCBlUtsxyRnBK0+MNmxZH4L0/kphN
        xBwaJS/Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qqyDL-0006ae-4i
        for netfilter-devel@vger.kernel.org; Thu, 12 Oct 2023 18:07:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] libiptc: Fix for another segfault due to chain index NULL pointer
Date:   Thu, 12 Oct 2023 18:07:03 +0200
Message-ID: <20231012160703.18198-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Chain rename code missed to adjust the num_chains value which is used to
calculate the number of chain index buckets to allocate during an index
rebuild. So with the right number of chains present, the last chain in a
middle bucket being renamed (and ending up in another bucket) triggers
an index rebuild based on false data. The resulting NULL pointer index
bucket then causes a segfault upon reinsertion.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1713
Fixes: 64ff47cde38e4 ("libiptc: fix chain rename bug in libiptc")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testcases/chain/0008rename-segfault2_0    | 32 +++++++++++++++++++
 libiptc/libiptc.c                             |  4 +++
 2 files changed, 36 insertions(+)
 create mode 100755 iptables/tests/shell/testcases/chain/0008rename-segfault2_0

diff --git a/iptables/tests/shell/testcases/chain/0008rename-segfault2_0 b/iptables/tests/shell/testcases/chain/0008rename-segfault2_0
new file mode 100755
index 0000000000000..bc473d2511bbd
--- /dev/null
+++ b/iptables/tests/shell/testcases/chain/0008rename-segfault2_0
@@ -0,0 +1,32 @@
+#!/bin/bash
+#
+# Another funny rename bug in libiptc:
+# If there is a chain index bucket with only a single chain in it and it is not
+# the last one and that chain is renamed, a chain index rebuild is triggered.
+# Since TC_RENAME_CHAIN missed to temporarily decrement num_chains value, an
+# extra index is allocated and remains NULL. The following insert of renamed
+# chain then segfaults.
+
+(
+	echo "*filter"
+	# first bucket
+	for ((i = 0; i < 40; i++)); do
+		echo ":chain-a-$i - [0:0]"
+	done
+	# second bucket
+	for ((i = 0; i < 40; i++)); do
+		echo ":chain-b-$i - [0:0]"
+	done
+	# third bucket, just make sure it exists
+	echo ":chain-c-0 - [0:0]"
+	echo "COMMIT"
+) | $XT_MULTI iptables-restore
+
+# rename all chains of the middle bucket
+(
+	echo "*filter"
+	for ((i = 0; i < 40; i++)); do
+		echo "-E chain-b-$i chain-d-$i"
+	done
+	echo "COMMIT"
+) | $XT_MULTI iptables-restore --noflush
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index e475063367c26..9712a36353b9a 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -2384,12 +2384,16 @@ int TC_RENAME_CHAIN(const IPT_CHAINLABEL oldname,
 		return 0;
 	}
 
+	handle->num_chains--;
+
 	/* This only unlinks "c" from the list, thus no free(c) */
 	iptcc_chain_index_delete_chain(c, handle);
 
 	/* Change the name of the chain */
 	strncpy(c->name, newname, sizeof(IPT_CHAINLABEL) - 1);
 
+	handle->num_chains++;
+
 	/* Insert sorted into to list again */
 	iptc_insert_chain(handle, c);
 
-- 
2.41.0

