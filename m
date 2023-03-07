Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 857D9C678D5
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 23:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjCGXbj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 18:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCGXbi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 18:31:38 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E71A8818
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 15:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8wBLH/Cq803hXaqjHojvSOZ4MMlzbQaGUuKefe/xVBM=; b=f08/regS1lJLpRh5Dq71qIbjHn
        rRzZZr3rDNkUlEA1bQctGlvAxYJiFLJbq2WDr/mKApbp/XA3Ene7uWL3rSiDliXvowRwJQkAc/4zp
        SZoyaNcc52GtVntDldgVV3SSKhK+9UvIEJRz3LIlxHIkyK3yp954q0k68qlbP0AZSVyZ/sjNtzS9+
        g3Sx1bScWAqXxUXhnOnX1raWDEFhQIjBMz70vjznkiPU6Q+bLFmfG9Z/34dRBsFHYMXhLkvxLn7PM
        S+YqTFZzuKZklDwZwie9PiPC7c4/8Vec4sQvChZlaHd/IEnWrTyMxeW6LKVpQC4gwiwI9yHhnaGIA
        x47tTs7A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pZgmM-00H2Ov-Kt
        for netfilter-devel@vger.kernel.org; Tue, 07 Mar 2023 23:31:34 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 0/9] Support for shifted port-ranges in NAT
Date:   Tue,  7 Mar 2023 23:30:47 +0000
Message-Id: <20230307233056.2681361-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 2eb0f624b709 ("netfilter: add NAT support for shifted portmap
ranges") introduced support for shifting port-ranges in DNAT.  This
allows one to redirect packets intended for one port to another in a
range in such a way that the new port chosen has the same offset in the
range as the original port had from a specified base value.

For example, by using the base value 2000, one could redirect packets
intended for 10.0.0.1:2000-3000 to 10.10.0.1:12000-13000 so that the old
and new ports were at the same offset in their respective ranges, i.e.:

  10.0.0.1:2345 -> 10.10.0.1:12345

However, while support for this was added to the common DNAT infra-
structure, only the xt_nat module was updated to make use of it.  This
patch-set extends the core support and updates all the nft NAT modules
to support it too.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=970672
Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1501

* Patches 1 & 2 contain small tidy-ups.
* Patch 3 extends the core NAT support for shifted port-ranges to SNAT.
* Patch 4 adds shifted port-range support to nft_nat.
* Patches 5-6 add shifted port-range support to nft_masq.
* Patch 7-9 add shifted port-range support to nft_redir.

Changes since v1.

  * Four patches containing bug-fixes have been removed.
  * Missing `if (priv->sreg_proto_base)` checks have been added to
    patches 4, 6, & 9.
  * In patch 8, `range.flags` in `nft_redir_eval` is initialized by
    simple assignment.

Jeremy Sowden (9):
  netfilter: conntrack: fix typo
  netfilter: nat: fix indentation of function arguments
  netfilter: nat: extend core support for shifted port-ranges
  netfilter: nft_nat: add support for shifted port-ranges
  netfilter: nft_masq: deduplicate eval call-backs
  netfilter: nft_masq: add support for shifted port-ranges
  netfilter: nf_nat_redirect: use `struct nf_nat_range2` in ipv4 API
  netfilter: nft_redir: deduplicate eval call-backs
  netfilter: nft_redir: add support for shifted port-ranges

 include/net/netfilter/nf_nat_redirect.h  |   3 +-
 include/uapi/linux/netfilter/nf_tables.h |   6 ++
 net/netfilter/nf_conntrack_core.c        |   2 +-
 net/netfilter/nf_nat_core.c              |   7 +-
 net/netfilter/nf_nat_masquerade.c        |   2 +
 net/netfilter/nf_nat_redirect.c          |  59 ++++++-------
 net/netfilter/nft_masq.c                 | 100 +++++++++++----------
 net/netfilter/nft_nat.c                  |  41 ++++++---
 net/netfilter/nft_redir.c                | 107 +++++++++++------------
 net/netfilter/xt_REDIRECT.c              |  10 ++-
 10 files changed, 188 insertions(+), 149 deletions(-)

-- 
2.39.2

