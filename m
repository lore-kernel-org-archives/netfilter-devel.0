Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3810C3DA7A
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Jan 2023 16:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbjABQT7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Jan 2023 11:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236618AbjABQT7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2023 11:19:59 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEE9FB481
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2023 08:19:57 -0800 (PST)
Date:   Mon, 2 Jan 2023 17:19:54 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_conntrack 2/2] conntrack: simplify
 calculation of `struct sock_fprog` length
Message-ID: <Y7MEKg8Xnr2Ym41e@salvia>
References: <20221223162441.2692988-1-jeremy@azazel.net>
 <20221223162441.2692988-2-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221223162441.2692988-2-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 23, 2022 at 04:24:41PM +0000, Jeremy Sowden wrote:
> When assigning the length to the `struct sock_fprog` object, we
> calculate it by multiplying the number of `struct sock_filter` objects,
> `j`, by `sizeof(struct sock_filter)` and then dividing by
> `sizeof(bsf[0])`, which, since `bsf[0]` is a `struct sock_filter`, is
> equal to `sizeof(struct sock_filter)`.
> 
> Remove the `sizeof` expressions and just assign `j`.

Also applied, thanks
