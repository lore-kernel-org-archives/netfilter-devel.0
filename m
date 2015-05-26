From: Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH 1/3 nf-next] netfilter: default CONFIG_NETFILTER_INGRESS
 to y
Date: Tue, 26 May 2015 09:44:44 +0900
Message-ID: <20150526004441.GA23370@vergenet.net>
References: <1432558004-13481-1-git-send-email-pablo@netfilter.org>
 <1432558004-13481-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32797 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbbEZAoy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2015 20:44:54 -0400
Received: by padbw4 with SMTP id bw4so79755157pad.0
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2015 17:44:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1432558004-13481-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Mon, May 25, 2015 at 02:46:40PM +0200, Pablo Neira Ayuso wrote:
> Useful to compile-test all options.
> 
> Suggested-by: by Alexei Stavoroitov <ast@plumgrid.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

There seems to be a stray "by" between ':' and Alexi's name.

> ---
>  net/netfilter/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index db1c674..9a89e7c 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -3,6 +3,7 @@ menu "Core Netfilter Configuration"
>  
>  config NETFILTER_INGRESS
>  	bool "Netfilter ingress support"
> +	default y
>  	select NET_INGRESS
>  	help
>  	  This allows you to classify packets from ingress using the Netfilter
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
