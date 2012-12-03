From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: resolve link failure for ip6t_NETMAP
Date: Mon, 3 Dec 2012 14:12:09 +0100
Message-ID: <20121203131209.GA32300@1984>
References: <1354472208-25759-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38781 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab2LCNMP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:12:15 -0500
Content-Disposition: inline
In-Reply-To: <1354472208-25759-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 02, 2012 at 07:16:48PM +0100, Jan Engelhardt wrote:
> Link stage of libip6t_NETMAP failed since recently.
> 
>   CCLD     libip6t_NETMAP.so
> /usr/lib64/gcc/x86_64-suse-linux/4.7/../../../../x86_64-suse-linux/bin/ld:
> cannot find -lip6tc

Is this problem opensuse specific? Need some diagnosing information on
why that's happening.

> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
> 
> Retrievable through
> 	git://git.inai.de/iptables master
> 
> 
>  extensions/GNUmakefile.in |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
> index e71e3ff..68e0b9b 100644
> --- a/extensions/GNUmakefile.in
> +++ b/extensions/GNUmakefile.in
> @@ -101,7 +101,8 @@ libxt_state.so: libxt_conntrack.so
>  	ln -fs $< $@
>  
>  # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
> -ip6t_NETMAP_LIBADD  = -lip6tc
> +ip6t_NETMAP_LIBADD  = -L${top_builddir}/libiptc/.libs \
> +                      -L${top_builddir}/libiptc -lip6tc
>  xt_RATEEST_LIBADD   = -lm
>  xt_statistic_LIBADD = -lm
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
