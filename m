From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2 3/3] src: add xt compat support
Date: Thu, 9 Apr 2015 21:36:17 +0100
Message-ID: <20150409203616.GA27610@acer.localdomain>
References: <1428598514-1915-1-git-send-email-pablo@netfilter.org>
 <1428598514-1915-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33542 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbbDIUgV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 16:36:21 -0400
Content-Disposition: inline
In-Reply-To: <1428598514-1915-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.04, Pablo Neira Ayuso wrote:
> At compilation time, you have to pass this option.
> 
>   # ./configure --with-xtables
> 
> And libxtables needs to be installed in your system.
> 
> This patch allows you to use xt extensions from nft, eg.
> 
>   # nft add rule filter output \
>         tcp flags syn xt target TCPMSS [ --clamp-mss-to-pmtu ]
> 
> This feature requires that libxtables is installed in your system.
> 
> This provides access to all existing xt modules from nft. Users can
> meanwhile use xt extension until we can provide native expressions.
> 
> You can build this optionally, if disabled it displays an error:
> 
>   # nft add rule filter output tcp flags syn xt target TCPMSS [ --clamp-mss-to-pmtu ]
>   <cmdline>:1:38-77: Error: this build does not support xtables
>   add rule filter output tcp flags syn xt target TCPMSS [ --clamp-mss-to-pmtu ]
>                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> so you know your build doesn't support this.

Before review this patch, my main question is - are we sure we want to do
this? How will this affect our plans to get rid of the iptables code
at some point in the future? Arguably its a compatibility question, if we
support this in nft people will use it and we can't simply remove it.
