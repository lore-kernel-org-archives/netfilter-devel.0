Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39BEECAAD4
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Aug 2022 11:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiH3LjN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Aug 2022 07:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiH3LiZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2022 07:38:25 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24ED6153D16
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2022 04:36:59 -0700 (PDT)
Date:   Tue, 30 Aug 2022 13:36:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: nft.8: Extend limit statement's burst value info
Message-ID: <Yw32VzsENzRJ0kpn@salvia>
References: <20220826131431.19696-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220826131431.19696-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 26, 2022 at 03:14:31PM +0200, Phil Sutter wrote:
> Describe how the burst value influences the kernel module's token
> bucket in each of the two modes.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Looking at the code, maybe one should make byte-based limit burst
> default to either zero or four times the rate value instead of the
> seemingly arbitrary 5 bytes.

This is a bug, let me have a look and then you follow up to update the
manpage, OK?

> ---
>  doc/statements.txt | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/doc/statements.txt b/doc/statements.txt
> index 6aaf806bcff25..af8ccb8603c67 100644
> --- a/doc/statements.txt
> +++ b/doc/statements.txt
> @@ -332,8 +332,13 @@ ____
>  A limit statement matches at a limited rate using a token bucket filter. A rule
>  using this statement will match until this limit is reached. It can be used in
>  combination with the log statement to give limited logging. The optional
> -*over* keyword makes it match over the specified rate. Default *burst* is 5.
> -if you specify *burst*, it must be non-zero value.
> +*over* keyword makes it match over the specified rate.
> +
> +The *burst* value influences the bucket size, i.e. jitter tolerance. With
> +packet-based *limit*, the bucket holds exactly *burst* packets, by default
> +five. With byte-based *limit*, the bucket's minimum size is the given rate's
> +byte value and the *burst* value adds to that, by default five bytes. If you
> +specify *burst*, it must be a non-zero value.
>  
>  .limit statement values
>  [options="header"]
> -- 
> 2.34.1
> 
