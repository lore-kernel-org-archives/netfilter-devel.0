From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v3] src: Pass stateless, numeric, ip2name and handle
 variables as structure members.
Date: Sun, 18 Jun 2017 11:24:09 +0200
Message-ID: <20170618092409.GA2214@salvia>
References: <5943a3bc.4c17620a.524bc.7af5@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43182 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdFRJYW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Jun 2017 05:24:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A93F1E1229
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 11:24:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9739F102183
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 11:24:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4005100A79
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Jun 2017 11:24:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <5943a3bc.4c17620a.524bc.7af5@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 16, 2017 at 02:54:06PM +0530, Varsha Rao wrote:
> libnftables library will be created soon. So declare numeric_output,
> stateless_output, ip2name_output and handle_output as members of
> structure output_ctx, instead of global variables. Rename these
> variables as following,
> 
> numeric_output -> numeric
> stateless_output -> stateless
> ip2name_output -> ip2name
> handle_output -> handle
> 
> Also add struct output_ctx *octx as member of struct netlink_ctx.

Applied, thanks Varsha. Some small changes though, see below.

> diff --git a/src/main.c b/src/main.c
> index 5089ff2..d09fd78 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -28,11 +28,8 @@
>  #include <iface.h>
>  #include <cli.h>
>  
> +struct output_ctx octx;

I turned this into 'static struct ...'

>  unsigned int max_errors = 10;
> -unsigned int numeric_output;
> -unsigned int stateless_output;
> -unsigned int ip2name_output;
> -unsigned int handle_output;
>  #ifdef DEBUG
>  unsigned int debug_level;
>  #endif
[...]

And some other small comestic changes, but overall looks good!

Thanks!
