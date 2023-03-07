Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82749C6FD1E
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 23:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCGXXR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 18:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCGXXO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 18:23:14 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EC339CD2
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 15:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k5kIWnV4e369Lzno+Dk+CARpYfbjasAWt0fCyKlDfMA=; b=VtmPjtEz1ozw7NvSJG60WFKbe1
        vdzPaZx2rAeqK+sgk/cliRDdEBi2vfYLYWu8vQ8UKDGWjS6OSrgS974Q6UoCqp8mh4KRP4uX1gAFs
        piBUWpBYhzPeL5kNVmZ/KuG86VaGeEXv/XXIBVe1ZXnbURCoPmuJI8ayruuBF+Js4JpAMYTELPAvo
        ZZNhSl+AxCMZBAAEbHsgQChNlTo8rHJou95RFCf3j3rCE2MfuKmjWpp2kv1KSEgBMFUIA4/th+UzL
        nqcbi0YPeqVQuaM82ZiQqFFkTVY59Q0bwbibds/+eXYyUKHSI4JxniLyJdP+i83UHuGXi1N+VZTef
        pi4CpJtA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pZge9-00H2Fp-Mg
        for netfilter-devel@vger.kernel.org; Tue, 07 Mar 2023 23:23:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf 0/4] NAT fixes
Date:   Tue,  7 Mar 2023 23:22:55 +0000
Message-Id: <20230307232259.2681135-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These bug-fixes were originally part of a larger series adding shifted
port-ranges to nft NAT and targetting nf-next, but Florian suggested
sending them via nf instead to get them upstream more quickly.

* Patches 1-3 correct the sizes in `nft_parse_register_load` calls in
  nft_nat, nft_masq and nft_redir.
* Patch 4 corrects a C&P mistake in an nft_redir `nft_expr_type`
  definition.

Jeremy Sowden (4):
  netfilter: nft_nat: correct length for loading protocol registers
  netfilter: nft_masq: correct length for loading protocol registers
  netfilter: nft_redir: correct length for loading protocol registers
  netfilter: nft_redir: correct value of inet type `.maxattrs`

 net/netfilter/nft_masq.c  | 2 +-
 net/netfilter/nft_nat.c   | 2 +-
 net/netfilter/nft_redir.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.39.2

