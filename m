Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB1BC04A95
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Oct 2022 08:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiJYIqZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 04:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJYIqW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 04:46:22 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46B6F88DC
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Oct 2022 01:46:19 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 69A8B5868F19C; Tue, 25 Oct 2022 10:46:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 675BC60D756BC;
        Tue, 25 Oct 2022 10:46:17 +0200 (CEST)
Date:   Tue, 25 Oct 2022 10:46:17 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     John Thomson <git@johnthomson.fastmail.com.au>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [xtables-addons PATCH v1] build: support for linux 6.1
In-Reply-To: <20221024095802.2494673-1-git@johnthomson.fastmail.com.au>
Message-ID: <n46n815r-296o-100-16n-24n5pp113n56@vanv.qr>
References: <20221023032239.808311-1-git@johnthomson.fastmail.com.au> <20221024095802.2494673-1-git@johnthomson.fastmail.com.au>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Monday 2022-10-24 11:58, John Thomson wrote:

>6.1 commit de492c83cae0 ("prandom: remove unused functions") removed
>prandom_u32, which was replaced and deprecated for get_random_u32 in
>5.19 d4150779e60f ("random32: use real rng for non-deterministic
> randomness"). get_random_u32 was introduced in 4.11 c440408cf690
>("random: convert get_random_int/long into get_random_u32/u64")
>
>Use the cocci script from 81895a65ec63 ("treewide: use prandom_u32_max()
>when possible, part 1"), along with a best guess for _max changes, introduced:
>3.14 f337db64af05 ("random32: add prandom_u32_max and convert open coded users")
>
>Signed-off-by: John Thomson <git@johnthomson.fastmail.com.au>
>---
>v1: no #if kver: compat_xtables.h warns kernels below 4.16 not supported

Applied, pushed 3.22.
