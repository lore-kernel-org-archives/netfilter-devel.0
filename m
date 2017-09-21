From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: xt_socket: Restore mark from full sockets
 only
Date: Thu, 21 Sep 2017 14:32:47 -0700
Message-ID: <1506029567.29839.150.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1506028832-8981-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38565 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751697AbdIUVct (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2017 17:32:49 -0400
Received: by mail-pg0-f65.google.com with SMTP id m30so4077050pgn.5
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2017 14:32:49 -0700 (PDT)
In-Reply-To: <1506028832-8981-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2017-09-21 at 15:20 -0600, Subash Abhinov Kasiviswanathan wrote:
> An out of bounds error was detected on an ARM64 target with
> Android based kernel 4.9. This occurs while trying to
> restore mark on a skb from an inet request socket.
> 
> BUG: KASAN: slab-out-of-bounds in socket_match.isra.2+0xc8/0x1f0 net/netfilter/xt_socket.c:248

...

> 
> Fixes: a94070000388 ("netfilter: xt_socket: prepare for TCP_NEW_SYN_RECV support")
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  net/netfilter/xt_socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
> index e75ef39..3301091 100644
> --- a/net/netfilter/xt_socket.c
> +++ b/net/netfilter/xt_socket.c
> @@ -76,7 +76,7 @@
>  			transparent = nf_sk_is_transparent(sk);
>  
>  		if (info->flags & XT_SOCKET_RESTORESKMARK && !wildcard &&
> -		    transparent)
> +		    transparent && sk_fullsock(sk))
>  			pskb->mark = sk->sk_mark;
>  
>  		if (sk != skb->sk)

What about socket_mt6_v1_v2_v3() ?

Thanks.


