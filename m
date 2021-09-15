Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DE7C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 17:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C7BB61186
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 17:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhIOR0Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Sep 2021 13:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhIOR0Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 13:26:16 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410C6C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Sep 2021 10:24:57 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 43A9E5875F675; Wed, 15 Sep 2021 19:24:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 3EAAA6101A29F;
        Wed, 15 Sep 2021 19:24:54 +0200 (CEST)
Date:   Wed, 15 Sep 2021 19:24:54 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Josef Pithart <pithart@email.cz>
cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        kaskada@email.cz
Subject: Re: [xtables-addons] xt_ipp2p: add ipv6 module alias
In-Reply-To: <FA.Zu6V.5ytypyKnDSO.1XGXsj@seznam.cz>
Message-ID: <sqos9337-n8n6-1os2-s7qr-n4364on33nqp@vanv.qr>
References: <20210914140934.190397-1-jeremy@azazel.net> <33D.aVMp.3L4gqjighB0.1XGFsS@seznam.cz> <YUIJW3DPDsmmjYPA@azazel.net> <FA.Zu6V.5ytypyKnDSO.1XGXsj@seznam.cz>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2021-09-15 18:22, Josef Pithart wrote:
>Hello,
>
>I`ve no idea why, but even if I do:
>
>modprobe -r xt_ipp2p
>./autogen.sh
>./configure

It defaults to /usr/local. Are you sure your iptables actually looks in
/usr/local for plugins?
