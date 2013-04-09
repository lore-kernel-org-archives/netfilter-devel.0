From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libipt6_mh.man: Correct command to display named mh types
Date: Tue, 9 Apr 2013 10:41:29 +0200
Message-ID: <20130409084129.GA25238@macbook.localnet>
References: <5163BFD9.7060804@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40661 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762938Ab3DIIlf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:41:35 -0400
Content-Disposition: inline
In-Reply-To: <5163BFD9.7060804@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 09, 2013 at 09:14:33AM +0200, Mart Frauenlob wrote:
> Hello,
> 
> ip6tables -p ipv6-mh -h
> 
> does not display the named mh types as the man page says.
> ip6tables -m mh -h does.

ip6tables -p mh also does. So please update the manpage to correct
the protocol.

> 
> This patch updates the man page accordingly.
> 
> Best regards
> 
> Mart

> >From 3df043fdd1ed58c0c07258e896e623a3ac06f69d Mon Sep 17 00:00:00 2001
> From: Mart Frauenlob <mart.frauenlob@chello.at>
> Date: Tue, 9 Apr 2013 09:04:17 +0200
> Subject: [PATCH] libip6t_mh: Correct command to list named mh types in manpage.
> 
> ---
>  extensions/libip6t_mh.man |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/extensions/libip6t_mh.man b/extensions/libip6t_mh.man
> index 4559e78..7106ef4 100644
> --- a/extensions/libip6t_mh.man
> +++ b/extensions/libip6t_mh.man
> @@ -8,5 +8,5 @@ a numeric MH
>  .IR type
>  or one of the MH type names shown by the command
>  .nf
> - ip6tables \-p ipv6\-mh \-h
> + ip6tables \-m mh \-h
>  .fi
> -- 
> 1.7.2.5
> 

