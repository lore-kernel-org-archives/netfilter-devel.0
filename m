Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E1DC47089
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Dec 2022 19:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiLCTCY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Dec 2022 14:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiLCTCW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Dec 2022 14:02:22 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5DB1C91B
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Dec 2022 11:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tKbBW2NIVlzWPiGTUZeX6PxHp8XeIirZpfwZjn7C76E=; b=euOkIyS5B0I5/Q18oyGLrb+JjT
        vJmDOmr+toYJSKvTFL/eQ4igEJlWkfgX9iFWl9PYQW5oNfN1I+yJSI31y9OV3yciAHoLXOVAHhjmS
        tGp8U0rMiqAsgqmyN3VEVlirEFX6DbsCZhC6hLDb+h9pVTq3IQVCxXazJ5UIMaNTMsauU98SyDtDd
        NQoSObClqIH1WPKEQGMP9jxaViMHH5g/AXFWggXDvwkRtEG5acs8o9IbFSzIIEU8BxpBdUB7JjrjW
        48Exkdx6J20VPJ3K3MdHBrfYh00Xp4JeudhPNQCKn+L+nXaUrIeQ3FoWdoPjsjBGSEBK0tn/g7MMA
        meaYiVfw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p1XmE-000B5v-4F
        for netfilter-devel@vger.kernel.org; Sat, 03 Dec 2022 19:02:18 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 0/4] Some bug-fixes
Date:   Sat,  3 Dec 2022 19:02:08 +0000
Message-Id: <20221203190212.346490-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As requested by Pablo, I've broken up the 34-part "Refactor of the DB
output plug-ins" patch-series I sent out last month into smaller chunks.
This first set contains four unrelated bug-fixes.

Jeremy Sowden (4):
  ulogd: fix parse-error check
  filter: fix buffer sizes in filter plug-ins
  JSON: remove incorrect config value check
  db: fix back-log capacity checks

 filter/ulogd_filter_HWHDR.c   |  4 ++--
 filter/ulogd_filter_IP2BIN.c  | 14 +++++++-------
 filter/ulogd_filter_IP2HBIN.c |  2 +-
 filter/ulogd_filter_IP2STR.c  |  6 +++---
 output/ulogd_output_JSON.c    |  8 +++-----
 src/ulogd.c                   |  2 +-
 util/db.c                     | 11 +++++++----
 7 files changed, 24 insertions(+), 23 deletions(-)

-- 
2.35.1

