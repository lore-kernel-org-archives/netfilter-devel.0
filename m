Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA26C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 21:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhLOVvB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 16:51:01 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56150 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhLOVvB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 16:51:01 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 478CB625F1;
        Wed, 15 Dec 2021 22:48:31 +0100 (CET)
Date:   Wed, 15 Dec 2021 22:50:55 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH 0/3] inet reject statement fix
Message-ID: <YbpjP1AGixf5gBR7@salvia>
References: <20211211185525.20527-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211211185525.20527-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Dec 11, 2021 at 06:55:22PM +0000, Jeremy Sowden wrote:
> The first two patches contain small improvements that I noticed while
> looking into a Debian bug-report.  The third contains a fix for the
> reported bug, that `inet` `reject` rules of the form:
> 
>   table inet filter {
>     chain input {
>       type filter hook input priority filter;
>       ether saddr aa:bb:cc:dd:ee:ff ip daddr 192.168.0.1 reject
>     }
>   }
> 
> fail with:
> 
>   BUG: unsupported familynft: evaluate.c:2766:stmt_evaluate_reject_inet_family: Assertion `0' failed.
>   Aborted

Series applied, thanks.
