Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54830C433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Feb 2021 20:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 140AE601FC
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Feb 2021 20:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhBSUmf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 15:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhBSUme (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 15:42:34 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75A9C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Feb 2021 12:41:43 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 12ADA67401E0;
        Fri, 19 Feb 2021 21:41:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mail.kfki.hu; h=
        mime-version:message-id:from:from:date:date:received:received
        :received:received; s=20151130; t=1613767296; x=1615581697; bh=L
        UM5fSxBk+IUYZuD8kykew4utX+YwXtCtjDkqAFzzi0=; b=WtB5aFALQPmlFCRt+
        ZLd146Gv2Pm/srtRLJmxVHXFq67bAkWT9/geTMfyn2nttK+k0NTq5uLXCIrGggj/
        u5NSihzarS09+twlcm+PwG+qADZgFKgWTn37nVsLpWpr3Yww+toRu+HEsTjCM7QB
        9VeZ7tpBheflnfSb1Bd9K1uKGo=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 19 Feb 2021 21:41:36 +0100 (CET)
Received: from localhost.kfki.hu (host-94-248-219-210.kabelnet.hu [94.248.219.210])
        (Authenticated sender: kadlecsik.jozsef@wigner.mta.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id BAD2067401DF;
        Fri, 19 Feb 2021 21:41:36 +0100 (CET)
Received: by localhost.kfki.hu (Postfix, from userid 1000)
        id 6116A3009EF; Fri, 19 Feb 2021 21:41:36 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by localhost.kfki.hu (Postfix) with ESMTP id 5DE77300278;
        Fri, 19 Feb 2021 21:41:36 +0100 (CET)
Date:   Fri, 19 Feb 2021 21:41:36 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@mail.kfki.hu>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.11 released
Message-ID: <28d6aaed-79eb-dd80-ab29-624138969de4@mail.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm happy to announce ipset 7.11. The most important thing is that there 
was an argument parsin buffer overflow in the ipset userspace utility 
which is fixed in this release.

Userspace changes:
  - Parse port before trying by service name (Haw Loeung)
  - Silence unused-but-set-variable warnings (reported by
    Serhey Popovych)
  - Handle -Werror=implicit-fallthrough= in debug mode compiling
  - ipset: fix print format warning (Neutron Soutmun)
  - Updated utilities
  - Argument parsing buffer overflow in ipset_parse_argv fixed
    (reported by Marshall Whittaker)

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
