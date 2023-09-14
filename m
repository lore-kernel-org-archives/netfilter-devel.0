Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A542CEDE98C
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 07:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbjINHb0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 03:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjINHb0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 03:31:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B381ECF1
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 00:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QMANMDQYyve7RfIn2V7lwwTaqVoFHVuxdGAUYzjWcWA=; b=Jl58nBQR34GDRqQ1QxlcBVHUA/
        2H4+9qkqSS9X2NtT6m2AFfOz2cdAGntIhD7CNniq4mqLFMmWzdI/pCLrB8cx6kbNxJuGfiSkWIp0y
        sWpnb2f0qJVyuHzVH+uj58dPFu1C67BSWG24IisM6hm6+ucopfWxnGIKlkfvazS4/wZTKkFk/C574
        I39w98pITPZS8vQ5tixSX9tEBPtvnf2YmA4WoT0A5wbZNS6v9AXZhTZxKSs8YYg7rquJvPqzJJV8x
        3wwS252D5TtE1SKHlwZtuKMWsWY6Fk0pJw+Usf8wJ9AOLeOAG3OtY4N9CB1ckj4HI1c1QqCuziQ6M
        pDFbEDNQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qggoq-0001Db-0a
        for netfilter-devel@vger.kernel.org; Thu, 14 Sep 2023 09:31:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests: shell: Fix for ineffective 0007-mid-restore-flush_0
Date:   Thu, 14 Sep 2023 09:31:16 +0200
Message-ID: <20230914073116.29450-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The test did not catch non-zero exit status of the spawned coprocess. To
make it happen, Drop the line killing it (it will exit anyway) and pass
its PID to 'wait'.

While being at it, put the sleep into the correct spot (otherwise the
check for chain 'foo' existence fails as it runs too early) and make
said chain existence check effective.

Fixes: 4e3c11a6f5a94 ("nft: Fix for ruleset flush while restoring")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../shell/testcases/nft-only/0007-mid-restore-flush_0  | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/iptables/tests/shell/testcases/nft-only/0007-mid-restore-flush_0 b/iptables/tests/shell/testcases/nft-only/0007-mid-restore-flush_0
index 43880ffbc5851..981f007f205b9 100755
--- a/iptables/tests/shell/testcases/nft-only/0007-mid-restore-flush_0
+++ b/iptables/tests/shell/testcases/nft-only/0007-mid-restore-flush_0
@@ -13,11 +13,11 @@ COMMIT
 :foo [0:0]
 EOF
 
-$XT_MULTI iptables-save | grep -q ':foo'
+sleep 1
+$XT_MULTI iptables-save | grep -q ':foo' || exit 1
 nft flush ruleset
 
 echo "COMMIT" >&"${COPROC[1]}"
-sleep 1
-
-[[ -n $COPROC_PID ]] && kill $COPROC_PID
-wait
+# close the pipe to make iptables-restore exit if it didn't error out yet
+eval "exec ${COPROC[1]}>&-"
+wait $COPROC_PID
-- 
2.41.0

