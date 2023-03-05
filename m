Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B37C61DA4
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 12:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjCEMeQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 07:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjCEMeP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 07:34:15 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043C2EB63
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 04:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jweJOri3bsMs3FhQWJzuig+t5s/WbqVwyY/O+h5Rg6w=; b=SMFEBrwbAZE8sEX9DWZ2O1m3M4
        FBiIfHCzYRys4P29U8wTug34mYD6FiUIeunp1gV4RO7VdggwU4CHOUqR7OCul+O/4bwh+EHZ2Qj46
        sROFDvhwlJoocwkOvt4Pg1e4qNwL0+ImXV4rHeIJ533Gyhstqbe7bUfn/3P5kNkBJIFmu5/asUO42
        lSlbd1iENy1GbhNC7EoHyTXVMcoIuouwc3/S0fQrdOrQqq4M/FzmQ0TPQWpCIGa5u2lkhGfDiaEEw
        JFfqhGhY69PKwqCVhkuVaLGZq+jzQbL894OaYfybSTcJQa5o32t3yxLN8an1CEnYd7UE9E/YoFC6X
        cwht3ZNA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYnZ6-00E3og-8V
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 12:34:12 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 00/13] Support for shifted port-ranges in NAT
Date:   Sun,  5 Mar 2023 12:18:04 +0000
Message-Id: <20230305121817.2234734-1-jeremy@azazel.net>
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
* Patches 4 & 5 correct the size in a `nft_parse_register_load` call and
  add shifted port-range support to nft_nat.
* Patches 6-8 correct the size in a `nft_parse_register_load` call and
  add shifted port-range support to nft_masq.
* Patch 9 corrects a C&P mistake in an nft_redir `nft_expr_type`
  definition.
* Patch 10-13 correct the size in a `nft_parse_register_load` call and
  add shifted port-range support to nft_redir.

Jeremy Sowden (13):
  netfilter: conntrack: fix typo
  netfilter: nat: fix indentation of function arguments
  netfilter: nat: extend core support for shifted port-ranges
  netfilter: nft_nat: correct length for loading protocol registers
  netfilter: nft_nat: add support for shifted port-ranges
  netfilter: nft_masq: correct length for loading protocol registers
  netfilter: nft_masq: deduplicate eval call-backs
  netfilter: nft_masq: add support for shifted port-ranges
  netfilter: nft_redir: correct value of inet type `.maxattrs`
  netfilter: nf_nat_redirect: use `struct nf_nat_range2` in ipv4 API
  netfilter: nft_redir: correct length for loading protocol registers
  netfilter: nft_redir: deduplicate eval call-backs
  netfilter: nft_redir: add support for shifted port-ranges

 include/net/netfilter/nf_nat_redirect.h  |   3 +-
 include/uapi/linux/netfilter/nf_tables.h |   6 ++
 net/netfilter/nf_conntrack_core.c        |   2 +-
 net/netfilter/nf_nat_core.c              |   7 +-
 net/netfilter/nf_nat_masquerade.c        |   2 +
 net/netfilter/nf_nat_redirect.c          |  59 ++++++-------
 net/netfilter/nft_masq.c                 |  97 ++++++++++-----------
 net/netfilter/nft_nat.c                  |  38 ++++++---
 net/netfilter/nft_redir.c                | 104 +++++++++++------------
 net/netfilter/xt_REDIRECT.c              |  10 ++-
 10 files changed, 177 insertions(+), 151 deletions(-)

-- 
2.39.2

