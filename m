Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E07AC5517A
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2DCB20720
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="lQFZZwhh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416219AbgJYNQI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 09:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1416211AbgJYNQG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 09:16:06 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A3EC0613D0
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 06:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Gw3A3Mc1dzbZEfLbhr5+tnsyiMnWAYYJls/UM7LyZ8A=; b=lQFZZwhha9bzHsszey1icGBbm1
        rza60maDdaFktSzK23V5GZtHwLGx9O4qey/+blK8VLXa/w8BYonOHnUuk/eVdiThPYUHu91i3Jcoe
        PXDHSBX+XjKb8TMRqIDWxpCnwqF4xCwlLbkwZfXstY/AqWVh9e9gS6s2sytIIHZ4JcufxT9scmwAu
        6x1f9fsKN1+7ndJgu5jNVjmpZ65MM/cdNwadYV7lqQxOlgDbmtkQvUQiRsGEkDoL8Uw0voHe6LE2m
        2bsk7nq6hxZ5CY0ZMpywQn55tfxi9rPvruerTKaJqLQmFZZ/25JWvI/nOXoRlc2H7D1PjOZw//U3v
        SRjgtW6w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWfsS-0001SE-Bc; Sun, 25 Oct 2020 13:16:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 00/13] pknlusr improvements
Date:   Sun, 25 Oct 2020 13:15:46 +0000
Message-Id: <20201025131559.920038-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201025131559.920038-1-jeremy@azazel.net>
References: <20201025131559.920038-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since pknlusr is now installed, here are some improvements.  There's one
automake change related to the new man-page, a number of new patches
tidying up the source of pknlusr.c, before a new version of the patch to
remove the hard-coded group ID.  The last four patches do a bit of
tidying of the pknock kernel module.

Jeremy Sowden (13):
  pknock: pknlusr: ensure man-page is included by `make dist`.
  pknock: pknlusr: remove dest_addr and rename src_addr.
  pknock: pknlusr: tighten up variable scopes.
  pknock: pknlusr: tidy up initialization of local address.
  pknock: pknlusr: use NLMSG macros and proper types, rather than
    arithmetic on char pointers.
  pknock: pknlusr: use macro to define inet_ntop buffer size.
  pknock: pknlusr: don't treat recv return value of zero as an error.
  pknock: pknlusr: always close socket.
  pknock: pknlusr: fix hard-coded netlink multicast group ID.
  pknock: xt_pknock: use IS_ENABLED.
  pknock: xt_pknock: use kzalloc.
  pknock: xt_pknock: use `pr_err`.
  pknock: xt_pknock: remove DEBUG definition and disable debug output.

 extensions/pknock/Makefile.am    |   2 +-
 extensions/pknock/libxt_pknock.c |   4 +-
 extensions/pknock/pknlusr.c      | 113 +++++++++++++++++++------------
 extensions/pknock/xt_pknock.c    |  27 +++-----
 extensions/pknock/xt_pknock.h    |   2 -
 5 files changed, 83 insertions(+), 65 deletions(-)

-- 
2.28.0

