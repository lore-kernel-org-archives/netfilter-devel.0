Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17F6C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Dec 2021 22:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348695AbhLFWYc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 17:24:32 -0500
Received: from mail.netfilter.org ([217.70.188.207]:36026 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbhLFWYb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 17:24:31 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 254FB605BC;
        Mon,  6 Dec 2021 23:18:41 +0100 (CET)
Date:   Mon, 6 Dec 2021 23:20:58 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH v4 00/32] Fixes for compiler warnings
Message-ID: <Ya6MyhseW80+w0FY@salvia>
References: <20211130105600.3103609-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211130105600.3103609-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 30, 2021 at 10:55:28AM +0000, Jeremy Sowden wrote:
> This patch-set fixes all the warnings reported by gcc 11.
> 
> Most of the warnings concern fall-throughs in switches, possibly
> problematic uses of functions like `strncpy` and `strncat` and possible
> truncation of output by `sprintf` and its siblings.
> 
> Some of the patches fix bugs revealed by warnings, some tweak code to
> avoid warnings, others fix or improve things I noticed while looking at
> the warnings.
> 
> Changes since v3:
> 
>   * When publishing v3 I accidentally sent out two different versions of the
>     patch-set under one cover-letter.  There are no code-changes in v4: it just
>     omits the earlier superseded patches.

Applied from 1 to 19 (all inclusive)

Thanks.
