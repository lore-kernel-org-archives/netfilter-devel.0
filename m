Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1389C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CAA56113B
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhHVQjA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 12:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhHVQjA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 12:39:00 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0903DC061756
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 09:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LsHvWjIZPD8LQXkHEY/sGPybYMQuQZxRmQNyeuRkh1c=; b=ujPSuANgDofIMCErH04ws9H0is
        TVQkWUSH7EN2BhAiIIhkLjym4IJbbwMCwFZ4wZ8JQvVriBkNx5dQslq0i0ih69iNBfAv2E705HHxu
        9rsarxQlp63pc3z6wYrQht13eZ4CCPlhMEX6g9D9aS+h18aS3Xt65d5zPGz/jHDyghTP0+fOZOyjh
        wdeU4HM0LDsFP4py8MBMz9XBmmB7iNJ63yUZ8r3CBWXt/nJKRcCfPO8Q3oRWk9b2O96xH+wpeLCXs
        sJ2mVIeKy2DMwiweYGkACmRlFQJdrohPvv4r1FeQFB5cGZ2Wyx4BNw0A/g877kPzfyyHJRplUkDIW
        hcqRuTHA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHqUB-008Q2I-QK; Sun, 22 Aug 2021 17:38:15 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     =?UTF-8?q?Grzegorz=20Kuczy=C5=84ski?= 
        <grzegorz.kuczynski@interia.eu>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 0/8] xt_condition: per-net improvements
Date:   Sun, 22 Aug 2021 17:35:48 +0100
Message-Id: <20210822163556.693925-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The first patch bumps the minimum version to 4.16 in order to allow us
to use a useful macro and function in patches 2 & 3.  4 makes the
proc_lock mutex a per-net variable.  5 removes an obsolete write
memory-barrier.  6-8 tidy up the clean-up of matches when a namespace is
deleted.

Jeremy Sowden (8):
  build: bump minimum supported kernel version from 4.15 to 4.16.
  xt_condition: use sizeof_field macro to size variable name.
  xt_condition: use `xt_check_proc_name` to validate /proc file-name.
  xt_condition: make mutex per-net.
  xt_condition: remove `wmb` when adding new variable.
  xt_condition: use `proc_net_condition` member of `struct
    condition_net`to signal that `condition_net_exit` has been called.
  xt_condition: don't delete variables in `condition_net_exit`.
  xt_condition: simplify clean-up of variables.

 configure.ac              |  2 +-
 extensions/xt_condition.c | 54 +++++++++++++--------------------------
 2 files changed, 19 insertions(+), 37 deletions(-)

-- 
2.32.0

