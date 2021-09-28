Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD10C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 09:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C485E6023B
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 09:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbhI1JpV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Sep 2021 05:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbhI1JpV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 05:45:21 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66171C061575
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Sep 2021 02:43:42 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id BCEFC5874277E; Tue, 28 Sep 2021 11:43:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id B87D160EF2E94;
        Tue, 28 Sep 2021 11:43:39 +0200 (CEST)
Date:   Tue, 28 Sep 2021 11:43:39 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Philip Prindeville <philipp@redfish-solutions.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] xt_ECHO, xt_TARPIT: make properly conditional on
 IPv6
In-Reply-To: <20210926195734.702772-1-philipp@redfish-solutions.com>
Message-ID: <5s32r847-4op5-70s2-7o9n-4968n7rso321@vanv.qr>
References: <20210926195734.702772-1-philipp@redfish-solutions.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sunday 2021-09-26 21:57, Philip Prindeville wrote:

>From: Philip Prindeville <philipp@redfish-solutions.com>
>
>Not all modules compile equally well when CONFIG_IPv6 is disabled.
>
> 	{
> 		.name       = "ECHO",
> 		.revision   = 0,
>-		.family     = NFPROTO_IPV6,
>+		.family     = NFPROTO_IPV4,
> 		.proto      = IPPROTO_UDP,
> 		.table      = "filter",
>-		.target     = echo_tg6,
>+		.target     = echo_tg4,
> 		.me         = THIS_MODULE,
> 	},
>+#ifdef WITH_IPV6

I put the original order back, makes the diff smaller.
So added.

