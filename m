Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1E0C54EE9
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Sep 2022 22:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiI0WPu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Sep 2022 18:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiI0WPu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Sep 2022 18:15:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2970F12756F
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Sep 2022 15:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eySCsrAdPRN58Nug0bUZ4ndGA5g/vnqvCxk2Gl0sISc=; b=JttNcRg90MHGO0EzwhoUvM84ky
        pzC1mQNSpFKZQ6evtn+FdTJdMJ09LkL+vsxBApZClcJTzWZoeqqCRZRlIf8PGMaGtpbAKFAX10ltG
        +ziPiSE0UxIgNLt9lubmTiC/mNQzQ9EMG2REGUvJ0AVfcRui/HCRrhg/CNiILSHF1LRTORHVLTGQN
        ew9sh2Y7kyFBRGOvhVA7dfXYqnHv1G7sdfLDCA+lBnY5rJfNnYqzsS3JuidlxvLGUd/QYhmHvZT27
        x63Z6oO/ewUGsuEXgbi5dgtwSe92e6vQmwFlptxRxrrOKmmEqOg7Lszmc6HmTP9EiPIkkY0Ur0c9X
        /W/e7B6A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1odIrj-00006H-II
        for netfilter-devel@vger.kernel.org; Wed, 28 Sep 2022 00:15:47 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/5] Fixes around ebtables' --proto match
Date:   Wed, 28 Sep 2022 00:15:07 +0200
Message-Id: <20220927221512.7400-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

During some code merge, I created an ugly situation where local OPT_*
defines in xtables-eb.c override OPT_* enum values from xshared.h with
same name but different value.

The above became problematic when I curtly added --verbose support to
ebtables-nft in order to support -vv debug output. The used OPT_VERBOSE
symbol stemmed from xshared.h and its value clashed with OPT_PROTOCOL.
In practice, this turned verbose mode on for rules with protocol match.

Fix all the above by merging the different OPT_* symbols in the first
three patches.

The second more relevant issue was ebtables' lack of support for '-p
LENGTH', foremost a mandatory prerequisite for 802_3 extension matches
validity. The last two patches resolve this.

Phil Sutter (5):
  ebtables: Drop unused OPT_* defines
  ebtables: Eliminate OPT_TABLE
  ebtables: Merge OPT_* flags with xshared ones
  nft-shared: Introduce __get_cmp_data()
  ebtables: Support '-p Length'

 extensions/generic.txlate |  6 +++++
 extensions/libebt_802_3.t |  6 +++--
 iptables/nft-bridge.c     | 46 ++++++++++++++++++++++++++++++---------
 iptables/nft-shared.c     | 17 +++++++++------
 iptables/nft-shared.h     |  1 +
 iptables/xshared.h        |  5 +++++
 iptables/xtables-eb.c     | 28 ++++++------------------
 7 files changed, 69 insertions(+), 40 deletions(-)

-- 
2.34.1

