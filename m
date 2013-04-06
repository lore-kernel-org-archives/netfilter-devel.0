From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables manpage: Fix missing space for recent match
 --mask option
Date: Sat, 6 Apr 2013 13:04:35 +0200
Message-ID: <20130406110435.GA4500@localhost>
References: <515FE4EC.1070900@chello.at>
 <515FE8F3.5020700@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33513 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710Ab3DFLEl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Apr 2013 07:04:41 -0400
Content-Disposition: inline
In-Reply-To: <515FE8F3.5020700@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 06, 2013 at 11:20:51AM +0200, Mart Frauenlob wrote:
> On 06.04.2013 11:04, netfilter-devel-owner@vger.kernel.org wrote:
> >As the subject says...
> >
> >Best regards
> >
> >Mart
> 
> lol damn, must been blind, now I added an extra space :/
> removed...

And missed initial \fI in netmask, but no problem, I fixed it and
applied this to master. Thanks.

> From 937309f37f9000f18f88c191923192c5d31a07e8 Mon Sep 17 00:00:00 2001
> From: Mart Frauenlob <mart.frauenlob@chello.at>
> Date: Sat, 6 Apr 2013 10:49:47 +0200
> Subject: [PATCH 2/2] iptables manpage: Fix missing space for recent match --mask option.
> 
> ---
>  extensions/libxt_recent.man |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
> index 8e6a8e9..05ae4fa 100644
> --- a/extensions/libxt_recent.man
> +++ b/extensions/libxt_recent.man
> @@ -24,7 +24,7 @@ is the default.
>  \fB\-\-rdest\fP
>  Match/save the destination address of each packet in the recent list table.
>  .TP
> -\fB\-\-mask\fPnetmask
> +\fB\-\-mask\fP \fnetmask\fP
>  Netmask that will be applied to this recent list.
>  .TP
>  [\fB!\fP] \fB\-\-rcheck\fP
> -- 
> 1.7.2.5
> 

