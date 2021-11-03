Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA42C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Nov 2021 18:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3B4660FC4
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Nov 2021 18:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhKCS4l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 14:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhKCS4l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 14:56:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CF3C061714
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Nov 2021 11:54:04 -0700 (PDT)
Received: from localhost ([::1]:51440 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1miLOc-0005nc-QP; Wed, 03 Nov 2021 19:54:02 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 1/2] selftests: nft_nat: Improve port shadow test stability
Date:   Wed,  3 Nov 2021 19:53:42 +0100
Message-Id: <20211103185343.28421-2-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211103185343.28421-1-phil@nwl.cc>
References: <20211103185343.28421-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Setup phase in test_port_shadow() relied upon a race-condition:
Listening nc on port 1405 was started in background before attempting to
create the fake conntrack entry using the same source port. If listening
nc won, fake conntrack entry could not be created causing wrong
behaviour. Reorder nc calls to fix this and introduce a short delay
before testing the setup to wait for listening nc process startup.

Fixes: 465f15a6d1a8f ("selftests: nft_nat: add udp hole punch test case")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index da1c1e4b6c86b..905c033db74dc 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -759,14 +759,16 @@ test_port_shadow()
 	local result=""
 	local logmsg=""
 
+	# make shadow entry, from client (ns2), going to (ns1), port 41404, sport 1405.
+	echo "fake-entry" | ip netns exec "$ns2" nc -w 1 -p 1405 -u "$daddrc" 41404 > /dev/null
+
 	echo ROUTER | ip netns exec "$ns0" nc -w 5 -u -l -p 1405 >/dev/null 2>&1 &
 	nc_r=$!
 
 	echo CLIENT | ip netns exec "$ns2" nc -w 5 -u -l -p 1405 >/dev/null 2>&1 &
 	nc_c=$!
 
-	# make shadow entry, from client (ns2), going to (ns1), port 41404, sport 1405.
-	echo "fake-entry" | ip netns exec "$ns2" nc -w 1 -p 1405 -u "$daddrc" 41404 > /dev/null
+	sleep 0.3
 
 	# ns1 tries to connect to ns0:1405.  With default settings this should connect
 	# to client, it matches the conntrack entry created above.
-- 
2.33.0

