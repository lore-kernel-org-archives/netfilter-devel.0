Return-Path: <SRS0=ZoCe=SX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7875C282E1
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Apr 2019 18:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F0382080D
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Apr 2019 18:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfDUSsr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Apr 2019 14:48:47 -0400
Received: from ja.ssi.bg ([178.16.129.10]:38422 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbfDUSsr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Apr 2019 14:48:47 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x3LIm0bc026468;
        Sun, 21 Apr 2019 21:48:01 +0300
Date:   Sun, 21 Apr 2019 21:48:00 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     linmiaohe <linmiaohe@huawei.com>
cc:     wensong@linux-vs.org, horms@verge.net.au, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        Mingfangsen <mingfangsen@huawei.com>, liujie165@huawei.com
Subject: Re: [PATCH v2] ipvs:set sock send/receive buffer correctly
In-Reply-To: <7d0dbb46-09aa-0163-bfd9-169594489584@huawei.com>
Message-ID: <alpine.LFD.2.21.1904212142540.2345@ja.home.ssi.bg>
References: <7d0dbb46-09aa-0163-bfd9-169594489584@huawei.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Thu, 18 Apr 2019, linmiaohe wrote:

> From: Jie Liu <liujie165@huawei.com>
> 
> If we set sysctl_wmem_max or sysctl_rmem_max larger than INT_MAX, the
> send/receive buffer of sock will be an negative value. Same as when
> the val is larger than INT_MAX/2.
> 
> Fixes: 1c003b1580e2 ("ipvs: wakeup master thread")
> Reported-by: Qiang Ning <ningqiang1@huawei.com>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Jie Liu <liujie165@huawei.com>

	Looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_sync.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
> index 2526be6b3d90..760f3364d4a2 100644
> --- a/net/netfilter/ipvs/ip_vs_sync.c
> +++ b/net/netfilter/ipvs/ip_vs_sync.c
> @@ -1278,14 +1278,22 @@ static void set_sock_size(struct sock *sk, int mode, int val)
>  	/* setsockopt(sock, SOL_SOCKET, SO_RCVBUF, &val, sizeof(val)); */
>  	lock_sock(sk);
>  	if (mode) {
> -		val = clamp_t(int, val, (SOCK_MIN_SNDBUF + 1) / 2,
> -			      sysctl_wmem_max);
> -		sk->sk_sndbuf = val * 2;
> +		val = min_t(u32, val, sysctl_wmem_max);
> +
> +		/* Ensure val * 2 fits into an int, to prevent max_t()
> +		 * from treating it as a negative value.
> +		 */
> +		val = min_t(int, val, INT_MAX / 2);
> +		sk->sk_sndbuf = max_t(int, val * 2, SOCK_MIN_SNDBUF);
>  		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
>  	} else {
> -		val = clamp_t(int, val, (SOCK_MIN_RCVBUF + 1) / 2,
> -			      sysctl_rmem_max);
> -		sk->sk_rcvbuf = val * 2;
> +		val = min_t(u32, val, sysctl_rmem_max);
> +
> +		/* Ensure val * 2 fits into an int, to prevent max_t()
> +		 * from treating it as a negative value.
> +		 */
> +		val = min_t(int, val, INT_MAX / 2);
> +		sk->sk_rcvbuf = max_t(int, val * 2, SOCK_MIN_RCVBUF);
>  		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
>  	}
>  	release_sock(sk);
> -- 

Regards

--
Julian Anastasov <ja@ssi.bg>
