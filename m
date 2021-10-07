Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77046C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 20:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49EC561130
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 20:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbhJGUSH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhJGUSG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 16:18:06 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6174C061570
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Oct 2021 13:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ef1PVPKyG3rhSYMHUr6732zM9pEQmiWO9f/WuKK9bA8=; b=TjhtXKkpb+Y6XG1k+FfvnFllfU
        Xk5eMjH53tmMtX2LPmW8UlEEP3MHrMo+HXra0J6Ik9Yknk8qsalyBEGjDNZehfB1SDTQwu270Pi1H
        OvFFl08sd2L8QPkjmMrkubRR/W7rdL54x//KJP+9EA1ewtkDUjlrf9686vS5JfLeN2pj/w0nElWE7
        Kj6oAKbobdMm6qY1CWaRyC8/pRpMxdk3BI8VANbnYzDEYytoTFefV9E0i3ymyNm7cTsil7hr8ukNV
        DWglXCcMIrnHQzvflMj0I1z+YcccywS9N04ag7tC2CGyTiZLerhYNonDmC0PMIVO1zXxmloehn9Ah
        W1dQEKQw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mYZoJ-009Xrv-2T
        for netfilter-devel@vger.kernel.org; Thu, 07 Oct 2021 21:16:11 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v3 0/3] Stateless output fixes
Date:   Thu,  7 Oct 2021 21:12:19 +0100
Message-Id: <20211007201222.2613750-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The first patch removes some dummy output for named counters.  The
second patch fixes a bug that erroneously clears the stateless output
flag.  The third patch merges some conditionals.

Changes since v2: fixes for commit-messages of patches 2 & 3.
Changes since v1: patches 2 & 3 are new.

Jeremy Sowden (3):
  rule: remove fake stateless output of named counters
  rule: fix stateless output after listing sets containing counters
  rule: replace three conditionals with one

 src/rule.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

-- 
2.33.0

