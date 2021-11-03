Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6369C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Nov 2021 18:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9218C60EB9
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Nov 2021 18:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhKCS4b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 14:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhKCS4b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 14:56:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788CAC061714
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Nov 2021 11:53:54 -0700 (PDT)
Received: from localhost ([::1]:51428 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1miLOS-0005n1-6I; Wed, 03 Nov 2021 19:53:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 2/2] selftests: nft_nat: Simplify port shadow notrack test
Date:   Wed,  3 Nov 2021 19:53:43 +0100
Message-Id: <20211103185343.28421-3-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211103185343.28421-1-phil@nwl.cc>
References: <20211103185343.28421-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The second rule in prerouting chain was probably a leftover: The router
listens on veth0, so not tracking connections via that interface is
sufficient. Likewise, the rule in output chain can be limited to that
interface as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 905c033db74dc..c62e4e26252c1 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -818,11 +818,10 @@ table $family raw {
 	chain prerouting {
 		type filter hook prerouting priority -300; policy accept;
 		meta iif veth0 udp dport 1405 notrack
-		udp dport 1405 notrack
 	}
 	chain output {
 		type filter hook output priority -300; policy accept;
-		udp sport 1405 notrack
+		meta oif veth0 udp sport 1405 notrack
 	}
 }
 EOF
-- 
2.33.0

