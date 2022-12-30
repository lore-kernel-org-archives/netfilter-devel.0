Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FB9C4167B
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Dec 2022 14:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiL3OtL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Dec 2022 09:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiL3OtL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Dec 2022 09:49:11 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E44B84D
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Dec 2022 06:49:08 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 30A8558AE97DA; Fri, 30 Dec 2022 15:49:05 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 2651A60FF7CD8;
        Fri, 30 Dec 2022 15:49:05 +0100 (CET)
Date:   Fri, 30 Dec 2022 15:49:05 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 0/3] Add Linux 6.2 Support
In-Reply-To: <20221229163507.352888-1-jeremy@azazel.net>
Message-ID: <33onqq1s-4393-4ro2-6058-40p58qr7s6n7@vanv.qr>
References: <20221229163507.352888-1-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thursday 2022-12-29 17:35, Jeremy Sowden wrote:

>The main purpose of the patch-set is to add support for 6.2, which
>removes `prandom_u32_max`, by replacing it with the function that
>supersedes it.  We also introduce the `LT_INIT` into configure.ac.

added.
