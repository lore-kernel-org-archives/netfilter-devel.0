Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1447C61DA4
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjCEKkX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjCEKkV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:40:21 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB2711EA5
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v8kVmCUQRLP66wQn+UMqvWnmv+xKGcTaJslgBbwNS24=; b=D5mIN2caFVL58ALCGtsc+R4jF7
        dHTuvafhP0f2Ge5aPF3uPfFtrjaZAcYmjrwCHJViyO+/sJ5RQzoRMc1PGThZJnR1wTvHn8c6O6Yt7
        cmy0sh362rWcLhK1pp8ThxEJ8tW1Z53UGm3PdK3zO7bKVSGPqRINPRJm68bzi+UnBVSaue0SD36F8
        5yzJf32p5qHG8Ey5BwsqaNFDzFl+k3/NXpv8ZMt5WjXzyXRoqlgeP0P5JOxYNnhuempH8ETdTQSYh
        K2U6T0FDnTeOZ5vmamkU/ZKX5WhgBEpYMhPS/EVO3C98CHIjZLH9rAqTtfW90ckLUjVjcq/ORnzYj
        Dqt/5JHA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlms-00DzM9-B4
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:40:18 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl 0/3] Support for shifted port-ranges in NAT
Date:   Sun,  5 Mar 2023 10:24:37 +0000
Message-Id: <20230305102440.2234017-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support for shifted port-ranges in DNAT was added to iptables in 2018.
This allows one to redirect packets intended for one port to another in
a range in such a way that the new port chosen has the same offset in
the range as the original port had from a specified base value.

For example, by using the base value 2000, one could redirect packets
intended for 10.0.0.1:2000-3000 to 10.10.0.1:12000-13000 so that the old
and new ports were at the same offset in their respective ranges, i.e.:

  10.0.0.1:2345 -> 10.10.0.1:12345

This patch-set makes support in the nft kernel modules for doing
likewise available to user space.  In contrast to iptables, this works
for `snat`, `redirect` and `masquerade` statements as well as well as
`dnat`.

Jeremy Sowden (3):
  nat: add support for shifted port-ranges
  masq: add support for shifted port-ranges
  redir: add support for shifted port-ranges

 include/libnftnl/expr.h             |  3 +++
 include/linux/netfilter/nf_tables.h |  6 ++++++
 src/expr/masq.c                     | 25 +++++++++++++++++++++++--
 src/expr/nat.c                      | 22 ++++++++++++++++++++++
 src/expr/redir.c                    | 29 ++++++++++++++++++++++++-----
 tests/nft-expr_masq-test.c          |  4 ++++
 tests/nft-expr_nat-test.c           |  4 ++++
 tests/nft-expr_redir-test.c         |  4 ++++
 8 files changed, 90 insertions(+), 7 deletions(-)

-- 
2.39.2

