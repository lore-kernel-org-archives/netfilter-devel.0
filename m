Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F32C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 15:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiJEPez (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 11:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiJEPev (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 11:34:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38F5DF59
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 08:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+Cl9kO0KYybQRpDXYRs4lUgQ8/hd8H7C2JEYCzjVKpk=; b=i3gC3PMtDA3SyY6ETbSSIzXkZ5
        5UfzmTrGxBQv/EUu0CMxqQopzVh5xWlIwBvHtIs2jIuYk1YFFQ5mP5q0rz1RVrRGqReLPGZwUTbBs
        08g/q8EZeABQqOJ5Y2dP5fDBVANVtQ8JA08VQAFMd8UWJ/TDsFuD/tsyYvVLO/SnDd+IKOi35xJql
        8GLyAWgSSM+bPGg/aIpt/oIHAqclMmANitapV3LHmhi+wU07vlH3vgpCPcyjBRXXbkMDkAFBi/Ve+
        bVSPIz9x9nxcSyt3QYilHlM5J8AidGXHY48Ht8aYJiPrvtNXcaAMG3O6k4nEr3bNQlsDOjm/ulFgp
        TtQpjdtQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1og6Q1-0005Gd-Cp; Wed, 05 Oct 2022 17:34:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>
Subject: [nf PATCH] selftests: netfilter: Fix nft_fib.sh for all.rp_filter=1
Date:   Wed,  5 Oct 2022 17:34:36 +0200
Message-Id: <20221005153436.30464-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If net.ipv4.conf.all.rp_filter is set, it overrides the per-interface
setting and thus defeats the fix from bbe4c0896d250 ("selftests:
netfilter: disable rp_filter on router"). Unset it as well to cover that
case.

Fixes: bbe4c0896d250 ("selftests: netfilter: disable rp_filter on router")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tools/testing/selftests/netfilter/nft_fib.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/netfilter/nft_fib.sh b/tools/testing/selftests/netfilter/nft_fib.sh
index fd76b69635a44..dff476e45e772 100755
--- a/tools/testing/selftests/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/netfilter/nft_fib.sh
@@ -188,6 +188,7 @@ test_ping() {
 ip netns exec ${nsrouter} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+ip netns exec ${nsrouter} sysctl net.ipv4.conf.all.rp_filter=0 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.rp_filter=0 > /dev/null
 
 sleep 3
-- 
2.34.1

