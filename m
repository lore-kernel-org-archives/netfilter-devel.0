Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0F47C64E90
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 11:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 309AA206C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Nov 2020 11:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="jB4+wzkE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgK3LcJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Nov 2020 06:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgK3LcI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 06:32:08 -0500
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD94C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Nov 2020 03:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vNIIVblqmTKdOFhUS9k0oR94hOiVAWHlnek9KSV/F3o=; b=jB4+wzkEzHiaNlgmWIXPSPiyRp
        RqZVgQRVL+cY2u3ifHxTNyS4juHbKu1uDRQGDnpPwbFunwXuXMaHwh5cJ0TMRLFmLcIU800Uqe9BR
        eF4sJ6cCZFVf1r74/QQS1oByAUe9hRhEhKlXEWUbIVAEtA8aH/mdYcHsvxN9RukZAVNq7z9LPIrm2
        LaJAg8UFRBxGS24RBSDUAfdJwtLPufRVVKF3slGdaaucXyrskJMmajAMwkhoR6UicfdWmvW4g5SO1
        uK+QtUzrrMapv6pIYQk0nGtaV3rrCb/mYYUvNoikNwge4Os16HOMhXBohIK7ejXM8UAHk8CuDqaUd
        sFsDCLbg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kjhOw-0002ji-Jr; Mon, 30 Nov 2020 11:31:26 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_log 0/2] build: a couple of `-lnfnetlink` fixes.
Date:   Mon, 30 Nov 2020 11:31:23 +0000
Message-Id: <20201130113125.1346744-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Building libnetfilter_log.so passes `-lnfnetlink` to the linker twice and
building libnetfilter_log_libipulog.so doesn't pass it at all.

Jeremy Sowden (2):
  build: remove duplicate `-lnfnetlink` from LDFLAGS.
  build: link libnetfilter_log_libipulog.so explicitly to
    libnfnetlink.so.

 src/Makefile.am | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.29.2

