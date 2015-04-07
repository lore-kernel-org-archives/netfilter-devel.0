From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [iptables PATCH] list: fix prefetch dummy
Date: Mon, 06 Apr 2015 17:38:05 -0700
Message-ID: <552326ED.9040500@gmail.com>
References: <20150406180541.7031.97131.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36323 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbDGAiH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2015 20:38:07 -0400
Received: by pabsx10 with SMTP id sx10so60273627pab.3
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Apr 2015 17:38:06 -0700 (PDT)
In-Reply-To: <20150406180541.7031.97131.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04/06/2015 11:05 AM, Arturo Borrero Gonzalez wrote:
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

Why not just use "do {} while (0)"?  I know that is what is used in the
kernel for functions that don't do anything.

- Alex
