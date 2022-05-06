Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4818AC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 May 2022 11:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389129AbiEFLrW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 May 2022 07:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379127AbiEFLrV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 May 2022 07:47:21 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBB958E40
        for <netfilter-devel@vger.kernel.org>; Fri,  6 May 2022 04:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MVeGn8L9996nMM545lU0kubnBepYVB6e9n/mjKfpYEY=; b=HBI7GGWYxWI4gSktyMkty69jl4
        YXt53+5gbIoimQutYoApnmn9dG5Q3qXYEvlFsZQMXWBD5HTumUGVQyBqJM1SIrj6k4vN4ZRL9HO7Z
        8ftX2NxI+lDrLF9+/XP6n9Gworp5qqv3lyeg8Fvsv7+haxswhRhinueJCuOu8R042VWz1rLfJwzag
        c+A1URuxzjmXmztf0XfJgWZ4zar6KMj69MfwMbuIgmUH9vUuPDE6kJKePqJZUTHoRWIAaoF6cHg4o
        807Pv/QtqXxaZKTMyLTdopVZId5bJfgIG6LngVaoDjQkzOIuamO6pzSlKFMZ7rijdfT9bV4WLNoRA
        A3xOxsHg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nmwMz-0005sS-H6; Fri, 06 May 2022 13:43:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 4/4] nft: Fix EPERM handling for extensions without rev 0
Date:   Fri,  6 May 2022 13:43:28 +0200
Message-Id: <20220506114328.9739-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220504103416.19712-5-phil@nwl.cc>
References: <20220504103416.19712-5-phil@nwl.cc>
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
Changes since v1:
- Drop useless error message.
---
 iptables/nft.c                                        | 11 +++++++----
 .../shell/testcases/iptables/0008-unprivileged_0      |  6 ++++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4ab59b12d00b1..21dfbd32540e0 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3551,15 +3551,18 @@ int nft_compatible_revision(const char *name, uint8_t rev, int opt)
 err:
 	mnl_socket_close(nl);
 
-	/* pretend revision 0 is valid -
+	/* ignore EPERM and errors for revision 0 -
 	 * this is required for printing extension help texts as user, also
 	 * helps error messaging on unavailable kernel extension */
-	if (ret < 0 && rev == 0) {
-		if (errno != EPERM)
+	if (ret < 0) {
+		if (errno == EPERM)
+			return 1;
+		if (rev == 0) {
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

