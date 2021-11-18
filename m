Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8FDC43217
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 22:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABB2A61A79
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 22:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhKRW3j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Nov 2021 17:29:39 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58284 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbhKRW3e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 17:29:34 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 54F6A64972;
        Thu, 18 Nov 2021 23:24:25 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 05/11] selftests: nft_nat: Simplify port shadow notrack test
Date:   Thu, 18 Nov 2021 23:26:12 +0100
Message-Id: <20211118222618.433273-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118222618.433273-1-pablo@netfilter.org>
References: <20211118222618.433273-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

The second rule in prerouting chain was probably a leftover: The router
listens on veth0, so not tracking connections via that interface is
sufficient. Likewise, the rule in output chain can be limited to that
interface as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 905c033db74d..c62e4e26252c 100755
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
2.30.2

