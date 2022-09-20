Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263D1C54EE9
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Sep 2022 21:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiITVYq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Sep 2022 17:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiITVYp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2022 17:24:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C783A13D12
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2022 14:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Xru8RPO9mSWF5EXL4lIh5qqLFX0lFCSwIb/5Bpx6eHk=; b=Uw8QAtsk0P4vJP/TFSc6g5AMwk
        bpNFDViQzdMcJ1ZQONNrOFN9JxlyPGU6S8Uc4mNYC+HkEKH0EtQ7xCKhkeUa/sMksuKvZl33JkU4x
        +D2yHFRP2Uoxwxxz5MaFefSQI0HRAmjbWTogn8q7TT+1ZfEa0mEx1TpV73VZbVEtHoJPASOK8HfpT
        C5i2HtTU8nooqDaC4w22yBPFQe+qHcpCPt7nibNyI8uZc5I2GfV2b6iZvS+WQZf9ULq6hpl84mFnP
        4qkV/sxElZWQVoHVJ6868GupZkZrYImGlZPzCiTUCjBjnbHS/r/Rt1iXoWbASwxZj0yUiKpLocS1i
        Why9RzOA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oakjR-0004cv-4S; Tue, 20 Sep 2022 23:24:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fwestpha@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        netfilter-devel@vger.kernel.org
Subject: [nf PATCH] netfilter: nft_fib: Fix for rpath check with VRF devices
Date:   Tue, 20 Sep 2022 23:24:32 +0200
Message-Id: <20220920212432.4168-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Analogous to commit b575b24b8eee3 ("netfilter: Fix rpfilter
dropping vrf packets by mistake") but for nftables fib expression:
Add special treatment of VRF devices so that typical reverse path
filtering via 'fib saddr . iif oif' expression works as expected.

Fixes: f6d0cbcf09c50 ("netfilter: nf_tables: add fib expression")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 3 +++
 net/ipv6/netfilter/nft_fib_ipv6.c | 7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index b75cac69bd7e6..7ade04ff972d7 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -83,6 +83,9 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	else
 		oif = NULL;
 
+	if (priv->flags & NFTA_FIB_F_IIF)
+		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
+
 	if (nft_hook(pkt) == NF_INET_PRE_ROUTING &&
 	    nft_fib_is_loopback(pkt->skb, nft_in(pkt))) {
 		nft_fib_store_result(dest, priv, nft_in(pkt));
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 8970d0b4faeb4..3f860e331580d 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -170,6 +170,10 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	else if (priv->flags & NFTA_FIB_F_OIF)
 		oif = nft_out(pkt);
 
+	if ((priv->flags & NFTA_FIB_F_IIF) &&
+	    (netif_is_l3_master(oif) || netif_is_l3_slave(oif)))
+		fl6.flowi6_oif = oif->ifindex;
+
 	iph = skb_header_pointer(pkt->skb, noff, sizeof(_iph), &_iph);
 	if (!iph) {
 		regs->verdict.code = NFT_BREAK;
@@ -197,7 +201,8 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
 		goto put_rt_err;
 
-	if (oif && oif != rt->rt6i_idev->dev)
+	if (oif && oif != rt->rt6i_idev->dev &&
+	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) != oif->ifindex)
 		goto put_rt_err;
 
 	nft_fib_store_result(dest, priv, rt->rt6i_idev->dev);
-- 
2.34.1

