From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] netfilter: xt_socket: Restore mark from full sockets
 only
Date: Thu, 21 Sep 2017 17:01:39 -0700
Message-ID: <1506038499.29839.156.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1506031687-21319-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32875 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdIVABl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2017 20:01:41 -0400
Received: by mail-pf0-f193.google.com with SMTP id h4so3081758pfk.0
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2017 17:01:41 -0700 (PDT)
In-Reply-To: <1506031687-21319-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2017-09-21 at 16:08 -0600, Subash Abhinov Kasiviswanathan wrote:
> An out of bounds error was detected on an ARM64 target with
> Android based kernel 4.9. This occurs while trying to
> restore mark on a skb from an inet request socket.
> 
> BUG: KASAN: slab-out-of-bounds in socket_match.isra.2+0xc8/0x1f0 net/netfilter/xt_socket.c:248
> Read of size 4 at addr ffffffc06a8d824c by task syz-fuzzer/1532
> CPU: 7 PID: 1532 Comm: syz-fuzzer Tainted: G        W  O    4.9.41+ #1
> Call trace:

> 
> v1->v2: Change socket_mt6_v1_v2_v3() as well as mentioned by Eric
> 
> Fixes: a94070000388 ("netfilter: xt_socket: prepare for TCP_NEW_SYN_RECV support")

When my commit was written (Mon Mar 16 21:06:17 2015 -0700), this
XT_SOCKET_RESTORESKMARK code was not there yet.


The bug was added in commit 01555e74bde5 ("netfilter: xt_socket: add
XT_SOCKET_RESTORESKMARK flag")  which came later (Mon Jun 15 18:40:43
2015 -0600)

Please put a correct Fixes: tag, thanks.


> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  net/netfilter/xt_socket.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
> index e75ef39..575d215 100644
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
> @@ -133,7 +133,7 @@
>  			transparent = nf_sk_is_transparent(sk);
>  
>  		if (info->flags & XT_SOCKET_RESTORESKMARK && !wildcard &&
> -		    transparent)
> +		    transparent && sk_fullsock(sk))
>  			pskb->mark = sk->sk_mark;
>  
>  		if (sk != skb->sk)


