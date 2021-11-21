Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF88C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Nov 2021 20:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbhKUUo4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Nov 2021 15:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbhKUUo4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Nov 2021 15:44:56 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96863C061714
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Nov 2021 12:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NquPTbP4rAeEM9GSE8BtomYww5ib9c8KIqJkIP5oddg=; b=ck0T4ydtbF5CI5qcrluyb0uUnJ
        p+PVSMFg7tBFcrOzZyImHTXeNPUQVMQHHSK5MwlIPl6kGASDaV5STGDmQ4tPyo6/LOGNIxujuPwjM
        h8VI5w3br76D/mKufbyVMDqlrNOT/lJDkp9E2hrYJYDWuCix6TAUnffSGE59mnCZXkU7O2OjMSySK
        +cEiddgqPVu9ow4d9skPcSJFY4wlqhdqwMdmMPMa3C2XjvAN6cMywFnwHoT2iBl3if6ZHE7uPGYCM
        Eft2/h8kAiYz0lG7Fs+FGmvAJ3y2ClQMtr0bK2LrtOQRANjAHhZRr9u5BrtLL4JDoVRuXTZ7290Da
        gGL0MmHg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1motek-0025lK-W6
        for netfilter-devel@vger.kernel.org; Sun, 21 Nov 2021 20:41:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 0/5] Format string fixes
Date:   Sun, 21 Nov 2021 20:41:34 +0000
Message-Id: <20211121204139.2218387-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The first patch adds gcc's `format` attribute to the `ulogd_log` logging
function and the following four patches fix the bugs revealed by it.

Jeremy Sowden (5):
  include: add `format` attribute to `__ulogd_log` declaration
  ulogd: remove empty log-line
  ulogd: fix order of log arguments
  input: UNIXSOCK: correct format specifiers
  output: IPFIX: correct format specifiers

 include/ulogd/ulogd.h                |  5 +++--
 input/packet/ulogd_inppkt_UNIXSOCK.c | 11 ++++++-----
 output/ipfix/ulogd_output_IPFIX.c    |  9 +++++----
 src/ulogd.c                          |  3 +--
 4 files changed, 15 insertions(+), 13 deletions(-)

-- 
2.33.0

