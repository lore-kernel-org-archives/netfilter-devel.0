Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AFCCDB483
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 12:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjJRM4a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 08:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjJRM43 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 08:56:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5882C119;
        Wed, 18 Oct 2023 05:56:27 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qt65y-0008Cw-LS; Wed, 18 Oct 2023 14:56:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH net 2/4] selftests: netfilter: Run nft_audit.sh in its own netns
Date:   Wed, 18 Oct 2023 14:55:58 +0200
Message-ID: <20231018125605.27299-3-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018125605.27299-1-fw@strlen.de>
References: <20231018125605.27299-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Don't mess with the host's firewall ruleset. Since audit logging is not
per-netns, add an initial delay of a second so other selftests' netns
cleanups have a chance to finish.

Fixes: e8dbde59ca3f ("selftests: netfilter: Test nf_tables audit logging")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/netfilter/nft_audit.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_audit.sh b/tools/testing/selftests/netfilter/nft_audit.sh
index e94a80859bbd..99ed5bd6e840 100755
--- a/tools/testing/selftests/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/netfilter/nft_audit.sh
@@ -11,6 +11,12 @@ nft --version >/dev/null 2>&1 || {
 	exit $SKIP_RC
 }
 
+# Run everything in a separate network namespace
+[ "${1}" != "run" ] && { unshare -n "${0}" run; exit $?; }
+
+# give other scripts a chance to finish - audit_logread sees all activity
+sleep 1
+
 logfile=$(mktemp)
 rulefile=$(mktemp)
 echo "logging into $logfile"
-- 
2.41.0

