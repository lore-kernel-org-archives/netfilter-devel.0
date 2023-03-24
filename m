Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7051FC6FD1C
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Mar 2023 19:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCXTFa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjCXTF3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 15:05:29 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC4320A11
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2023 12:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O60+peHDooCHG1N2tYf9qQHUbWW5PBjmQVM2hWmGVwk=; b=TGQcsn8xcFpjL9gXsOZGdlCrWV
        Ja8U3GpB6jLAXmUgkp4/M0ivQp0q40it8abTWYfSqKYPk4KiiS0z+8l8KkXZaY8ER5sz2XAwrc2fL
        8PaAn1wpx2JtgrWjN0EwPonXZi6/wpHVuCE3mX9vYMV+EX/Xj533WNnQl3nrjuIUN4NA9O/mxvC0W
        KGALERV+vWFQD4zYNzcY9Db3QO+8XEAUEthDaRZuwOHXYcGMw8o5EPDCasEmJt5+UKfwTYrLH1/5p
        eEKBbt6y3wUukcZYMQwmnrk0U2S3pbKZdDtAmrGkYjtsovcA6MaKddEoudfpS3yzHer9Nkt9trqtc
        S87f5k3A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pfmiF-0044uC-Ax
        for netfilter-devel@vger.kernel.org; Fri, 24 Mar 2023 19:04:31 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 0/4] Support for shifted port-ranges in NAT
Date:   Fri, 24 Mar 2023 19:04:15 +0000
Message-Id: <20230324190419.543888-1-jeremy@azazel.net>
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

* Patch 1 extends the core NAT support for shifted port-ranges to SNAT.
* Patch 2 adds shifted port-range support to nft_nat.
* Patch 3 adds shifted port-range support to nft_masq.
* Patch 4 adds shifted port-range support to nft_redir.

Changes since v2.

  * All the remaining patches not directly related to the new
    functionality have been submitted separately.

Changes since v1.

  * Four patches containing bug-fixes have been removed.
  * Missing `if (priv->sreg_proto_base)` checks have been added to
    patches 4, 6, & 9.
  * In patch 8, `range.flags` in `nft_redir_eval` is initialized by
    simple assignment.

Jeremy Sowden (4):
  netfilter: nat: extend core support for shifted port-ranges
  netfilter: nft_nat: add support for shifted port-ranges
  netfilter: nft_masq: add support for shifted port-ranges
  netfilter: nft_redir: add support for shifted port-ranges

 include/uapi/linux/netfilter/nf_tables.h |  6 ++++
 net/netfilter/nf_nat_core.c              |  3 ++
 net/netfilter/nf_nat_masquerade.c        |  2 ++
 net/netfilter/nf_nat_redirect.c          |  1 +
 net/netfilter/nft_masq.c                 | 25 ++++++++++++++-
 net/netfilter/nft_nat.c                  | 41 ++++++++++++++++++------
 net/netfilter/nft_redir.c                | 23 ++++++++++++-
 7 files changed, 89 insertions(+), 12 deletions(-)

-- 
2.39.2

