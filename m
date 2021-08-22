Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC3FC4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 19:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2FB661267
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 19:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhHVTn0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 15:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhHVTnZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 15:43:25 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C500C061575
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 12:42:44 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 0FBAB587AD5C3; Sun, 22 Aug 2021 21:42:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 0BA2161C70370;
        Sun, 22 Aug 2021 21:42:43 +0200 (CEST)
Date:   Sun, 22 Aug 2021 21:42:43 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     =?UTF-8?Q?Grzegorz_Kuczy=C5=84ski?= <grzegorz.kuczynski@interia.eu>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 1/8] build: bump minimum supported kernel
 version from 4.15 to 4.16.
In-Reply-To: <20210822163556.693925-2-jeremy@azazel.net>
Message-ID: <90309s8n-6p9r-p534-o722-371n1p55q2q4@vanv.qr>
References: <20210822163556.693925-1-jeremy@azazel.net> <20210822163556.693925-2-jeremy@azazel.net>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sunday 2021-08-22 18:35, Jeremy Sowden wrote:

>The next two commits make use of a function and macro that were
>introduced in 4.16.
>
>Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
>---
> configure.ac | 2 +-

I needed to touch some more files for 4.16.
