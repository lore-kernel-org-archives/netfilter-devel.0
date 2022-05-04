Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6DCC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 May 2022 10:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348143AbiEDKiY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 May 2022 06:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiEDKiW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 May 2022 06:38:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D601402B
        for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2022 03:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Aramjn5QXnczHguP10ffhC6PhtFkjmhk4ynM0W17lLI=; b=JMvOlKK9b+4CadqxEsqPrbzzcg
        TUckKL3W7shDLnGYak3ryT+KJZit8pyas99w2Mkxzw+cUrKp36UatzfdPDoNdg6znFpBUr75EWDH7
        2Ov6Q1wxTUMHZLWRTSYh3fohh2fA36KyJ39mO7Og38In7rCdyaOrytCx+8T+O9LokA4E7NCsPlpLn
        P2+9rS1enkWL/iNt026kWZMG+w6BCa1LYFZIbSpelYVo63kYro8V/MczOwO4cXwmPBXnYnhg0McQg
        O/n/RSkT25qf38eJymlCzmXB9esUdXwcPh1r88LcTUC0X44mlWssi4phRpDb12/hKSat3XEU0jdE9
        2GTC70EA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nmCLG-0008Pq-7Y; Wed, 04 May 2022 12:34:46 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/4] nft: Fix EPERM handling for extensions without rev 0
Date:   Wed,  4 May 2022 12:34:16 +0200
Message-Id: <20220504103416.19712-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220504103416.19712-1-phil@nwl.cc>
References: <20220504103416.19712-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Treating revision 0 as compatible in EPERM case works fine as long as
there is a revision 0 of that extension defined in DSO. Fix the code for
others: Extend the EPERM handling to all revisions and keep the existing
warning for revision 0.

Fixes: 17534cb18ed0a ("Improve error messages for unsupported extensions")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c                                     | 14 ++++++++++----
 .../shell/testcases/iptables/0008-unprivileged_0   |  6 ++++++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 33813ce1b9202..95e6c222682c0 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3510,15 +3510,21 @@ int nft_compatible_revision(const char *name, uint8_t rev, int opt)
 err:
 	mnl_socket_close(nl);
 
-	/* pretend revision 0 is valid -
+	/* ignore EPERM and errors for revision 0 -
 	 * this is required for printing extension help texts as user, also
 	 * helps error messaging on unavailable kernel extension */
-	if (ret < 0 && rev == 0) {
-		if (errno != EPERM)
+	if (ret < 0) {
+		if (errno == EPERM) {
+			fprintf(stderr,
+				"%s: Could not determine whether revision %u is supported, assuming it is.\n",
+				name, rev);
+			return 1;
+		} else if (rev == 0) {
 			fprintf(stderr,
 				"Warning: Extension %s revision 0 not supported, missing kernel module?\n",
 				name);
-		return 1;
+			return 1;
+		}
 	}
 
 	return ret < 0 ? 0 : 1;
diff --git a/iptables/tests/shell/testcases/iptables/0008-unprivileged_0 b/iptables/tests/shell/testcases/iptables/0008-unprivileged_0
index 43e3bc8721dbd..983531fef4720 100755
--- a/iptables/tests/shell/testcases/iptables/0008-unprivileged_0
+++ b/iptables/tests/shell/testcases/iptables/0008-unprivileged_0
@@ -35,6 +35,12 @@ let "rc+=$?"
 grep_or_rc "DNAT target options:" <<< "$out"
 let "rc+=$?"
 
+# TEE has no revision 0
+out=$(run $XT_MULTI iptables -j TEE --help)
+let "rc+=$?"
+grep_or_rc "TEE target options:" <<< "$out"
+let "rc+=$?"
+
 out=$(run $XT_MULTI iptables -p tcp -j DNAT --help)
 let "rc+=$?"
 grep_or_rc "tcp match options:" <<< "$out"
-- 
2.34.1

