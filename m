Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A048CC6FD1B
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 13:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjCGN63 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 08:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCGN62 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 08:58:28 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF1B74DEC
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 05:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yIEHQCwhlRtk9SsepWZ7Vs3aH5Su7X+C8jVir1DWJ9E=; b=QZ9HeyEoXvcsbHRSX+pjPwHMEG
        /apc2aqcfTJxdmVNl2FhoGDUVnLs6ppOQTqUX6aYCzAEvlxqEoER7t+Qatjmw76CNXcnwKUtEjcLr
        j0fzOrOBj6dZkKiVSZ8kRpEynYMCiAIx2+zmAYXsZ02DF7AMKOVmu+vvRSss6kQxbM0fVKzxHJxDL
        UXL2QEqgOLzLBwN9Rw2FqqXvIlwm7rHBpFS5OUycOf8KZf0DfkR1ldVqzp5vIggfXYcd7ZVXwSOH0
        l6yX+iFIlidnip7B15D8oTTN8/wXdFl777sqrLZM7Z22c0efbC291PPsYGAmTJGzMPSusXqFhO+4L
        5G6hZQIQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pZXpi-00058c-2A; Tue, 07 Mar 2023 14:58:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ipset PATCH 1/4] tests: xlate: Test built binary by default
Date:   Tue,  7 Mar 2023 14:58:09 +0100
Message-Id: <20230307135812.25993-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230307135812.25993-1-phil@nwl.cc>
References: <20230307135812.25993-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Testing the host's iptables-translate by default is unintuitive. Since
the ipset-translate symlink is created upon 'make install', add a local
symlink to the repository pointing at a built binary in src/. Using this
by default is consistent with the regular testsuite.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/xlate/ipset-translate | 1 +
 tests/xlate/runtest.sh      | 8 ++------
 2 files changed, 3 insertions(+), 6 deletions(-)
 create mode 120000 tests/xlate/ipset-translate

diff --git a/tests/xlate/ipset-translate b/tests/xlate/ipset-translate
new file mode 120000
index 0000000000000..91980c18bb040
--- /dev/null
+++ b/tests/xlate/ipset-translate
@@ -0,0 +1 @@
+../../src/ipset
\ No newline at end of file
diff --git a/tests/xlate/runtest.sh b/tests/xlate/runtest.sh
index a2a02c05d7573..6a2f80c0d9e61 100755
--- a/tests/xlate/runtest.sh
+++ b/tests/xlate/runtest.sh
@@ -6,14 +6,10 @@ if [ ! -x "$DIFF" ] ; then
 	exit 1
 fi
 
-IPSET_XLATE=$(which ipset-translate)
-if [ ! -x "$IPSET_XLATE" ] ; then
-	echo "ERROR: ipset-translate is not installed yet"
-	exit 1
-fi
+ipset_xlate=${IPSET_XLATE_BIN:-$(dirname $0)/ipset-translate}
 
 TMP=$(mktemp)
-ipset-translate restore < xlate.t &> $TMP
+$ipset_xlate restore < xlate.t &> $TMP
 if [ $? -ne 0 ]
 then
 	cat $TMP
-- 
2.38.0

