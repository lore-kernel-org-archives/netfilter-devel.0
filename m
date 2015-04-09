From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [iptables PATCH] list: fix prefetch dummy
Date: Wed, 8 Apr 2015 17:18:25 -0700
Message-ID: <20150408171825.40368215@urahara>
References: <20150406180541.7031.97131.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33356 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbbDIASV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 20:18:21 -0400
Received: by paboj16 with SMTP id oj16so130967137pab.0
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Apr 2015 17:18:21 -0700 (PDT)
In-Reply-To: <20150406180541.7031.97131.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 06 Apr 2015 20:05:41 +0200
Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:

> linux_list.h:381:59: warning: right-hand operand of comma expression has no effect [-Wunused-value]
>   for (pos = list_entry((head)->next, typeof(*pos), member), \
>                                                            ^
> libiptc.c:552:2: note: in expansion of macro 'list_for_each_entry'
>   list_for_each_entry(c, &h->chains, list) {
>   ^
> 
> [ Patch copied from one similar of Patrick McHardy on libnftnl ]
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  libiptc/linux_list.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libiptc/linux_list.h b/libiptc/linux_list.h
> index abdcf88..559e33c 100644
> --- a/libiptc/linux_list.h
> +++ b/libiptc/linux_list.h
> @@ -27,7 +27,7 @@
>  	1; \
>  })
>  
> -#define prefetch(x)		1
> +#define prefetch(x)		((void)0)
>  
>  /* empty define to make this work in userspace -HW */
>  #define smp_wmb()
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The kernel dropped the prefetch() in the list macros a couple
of years ago. The prefetch() had no performance gain and hurt
in several cases.
