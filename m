Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43ED4C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 19:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 269656124E
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 19:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhHVTnc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 15:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhHVTnc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 15:43:32 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B524C061575
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 12:42:51 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id A8C6F587AD5C3; Sun, 22 Aug 2021 21:42:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id A74E061C70370;
        Sun, 22 Aug 2021 21:42:49 +0200 (CEST)
Date:   Sun, 22 Aug 2021 21:42:49 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     =?UTF-8?Q?Grzegorz_Kuczy=C5=84ski?= <grzegorz.kuczynski@interia.eu>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 0/8] xt_condition: per-net improvements
In-Reply-To: <20210822163556.693925-1-jeremy@azazel.net>
Message-ID: <r7768sq6-r5o1-8776-r226-04rp4p5837o@vanv.qr>
References: <20210822163556.693925-1-jeremy@azazel.net>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sunday 2021-08-22 18:35, Jeremy Sowden wrote:

>The first patch bumps the minimum version to 4.16 in order to allow us
>to use a useful macro and function in patches 2 & 3.  4 makes the
>proc_lock mutex a per-net variable.  5 removes an obsolete write
>memory-barrier.  6-8 tidy up the clean-up of matches when a namespace is
>deleted.

Processed.
