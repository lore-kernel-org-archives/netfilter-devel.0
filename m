Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78C3C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Sep 2021 15:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B6C4610F9
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Sep 2021 15:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhINPJy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 11:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbhINPJy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 11:09:54 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41B4C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Sep 2021 08:08:36 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 8A081586A3A49; Tue, 14 Sep 2021 17:08:35 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 85C5160E57516;
        Tue, 14 Sep 2021 17:08:35 +0200 (CEST)
Date:   Tue, 14 Sep 2021 17:08:35 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>, kaskada@email.cz
Subject: Re: [xtables-addons] xt_ipp2p: add ipv6 module alias
In-Reply-To: <20210914140934.190397-1-jeremy@azazel.net>
Message-ID: <8256o629-qr34-3994-pqs2-9o2sn8r66s2@vanv.qr>
References: <20210914140934.190397-1-jeremy@azazel.net>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tuesday 2021-09-14 16:09, Jeremy Sowden wrote:
>
> extensions/xt_ipp2p.c | 1 +
> 1 file changed, 1 insertion(+)

Added
