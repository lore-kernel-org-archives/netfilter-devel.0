From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH]iptables-save: fix don't show counters by default
Date: Mon, 14 May 2012 10:39:25 +0200
Message-ID: <20120514083925.GE9577@1984>
References: <4FAB8D11.4040704@parrot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nicolas CARRIER <nicolas.carrier.ext@parrot.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44271 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab2ENIj1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 May 2012 04:39:27 -0400
Content-Disposition: inline
In-Reply-To: <4FAB8D11.4040704@parrot.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Nicolas,

On Thu, May 10, 2012 at 11:40:33AM +0200, Nicolas CARRIER wrote:
> When one issue an iptables-save command, counters are always shown in front of policies, which doesn't seem to be the desired result.
> The attached patch tries to fix this. It uses the global show_counters flag to decide if counters will be shown.

This changes the behaviour of default iptables-save (that has been to
include the global counters by default for years).

I don't want to break backward compatibility. People expect to get
them without the -c option.

> -- 
> Nicolas CARRIER - Parrot France - Software Engineer

> From 8ccc08a6b0fde5544145f6831b7f80d1bf8bbdf0 Mon Sep 17 00:00:00 2001
> From: Nicolas CARRIER <nicolas.carrier.ext@parrot.com>
> Date: Thu, 10 May 2012 11:25:53 +0200
> Subject: [PATCH] iptables-save: fix don't show counters by default
> 
> ---
>  iptables/ip6tables-save.c |    9 ++++++---
>  iptables/iptables-save.c  |    9 ++++++---
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
> index d819b30..4e7e4e8 100644
> --- a/iptables/ip6tables-save.c
> +++ b/iptables/ip6tables-save.c
> @@ -90,11 +90,14 @@ static int do_output(const char *tablename)
>  		printf(":%s ", chain);
>  		if (ip6tc_builtin(chain, h)) {
>  			struct xt_counters count;
> -			printf("%s ",
> +			printf("%s",
>  			       ip6tc_get_policy(chain, &count, h));
> -			printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
> +			if (show_counters)
> +				printf(" [%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
> +			else
> +				printf("\n");
>  		} else {
> -			printf("- [0:0]\n");
> +			printf("-%s\n", show_counters ? " [0:0]" : "");
>  		}
>  	}
>  
> diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
> index e599fce..6322c51 100644
> --- a/iptables/iptables-save.c
> +++ b/iptables/iptables-save.c
> @@ -88,11 +88,14 @@ static int do_output(const char *tablename)
>  		printf(":%s ", chain);
>  		if (iptc_builtin(chain, h)) {
>  			struct xt_counters count;
> -			printf("%s ",
> +			printf("%s",
>  			       iptc_get_policy(chain, &count, h));
> -			printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
> +			if (show_counters)
> +				printf(" [%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
> +			else
> +				printf("\n");
>  		} else {
> -			printf("- [0:0]\n");
> +			printf("-%s\n", show_counters ? " [0:0]" : "");
>  		}
>  	}
>  
> -- 
> 1.7.10
> 

