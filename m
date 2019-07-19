Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE639C76188
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 11:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9848F21849
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 11:10:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="cgib1RRq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfGSLKM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 07:10:12 -0400
Received: from kadath.azazel.net ([81.187.231.250]:52152 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfGSLKM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 07:10:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bIcI8FbVzas7ECKEPvhZOr/9nzSZJmV1wl9/Axw7ZU8=; b=cgib1RRqBDzB/tvae0huLM16iw
        gtkJMEY4ScxYB+NO8P5SDAb5lrJVRWUDd4GAeaUnTuklTWBZhV0F9QDeteISEzod/Y0mCmdCnbRwB
        9Yh8FHwkvqOiHPGJ0LdRll6nEHJp+yX6nau+7drAF7xSR5AQ2rYr/kbF9C7r1r1VSQs8BVdkGeRaw
        ptEX5524jhH7eZ3cT0uZ0r4QWNqrMbKZ7jX76iOxTafP9I9znteR0lc8/8O7rY7yzU/saRlmPN5gt
        3vEJmJEhiqbjP5GW6SdWEioEfpf7AuZjpO1hiDC0JfSqFjvVx86MHPtfHVKJz0MLv1t4IrwjzUZDZ
        JhNpgVPA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hoQmA-00070n-LB; Fri, 19 Jul 2019 12:10:10 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft v2 0/2] netlink_ctx initialization fixes.
Date:   Fri, 19 Jul 2019 12:10:08 +0100
Message-Id: <20190719111010.14421-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719103205.GM1628@orbyte.nwl.cc>
References: <20190719103205.GM1628@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A couple of patches to tidy up initialization of a pair of netlink_ctx
variables.

Since v1 (based on Phil's feedback -- thanks, Phil):

 * Eliminated batch local variable from first patch.
 * Do initialization of .list and .batch into struct initializer from
   first patch.
 * Updated commit in "Fixes:" tag in first patch.
 * Added second patch.

Jeremy Sowden (2):
  libnftables: got rid of repeated initialization of netlink_ctx
    variable in loop.
  rule: removed duplicate member initializer.

 src/libnftables.c | 23 ++++++++++-------------
 src/rule.c        |  1 -
 2 files changed, 10 insertions(+), 14 deletions(-)

-- 
2.20.1
