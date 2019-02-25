Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF965C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 20:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC7BB20842
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 20:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfBYUVj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 15:21:39 -0500
Received: from ja.ssi.bg ([178.16.129.10]:55006 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727021AbfBYUVj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 15:21:39 -0500
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x1PKJwWJ005616;
        Mon, 25 Feb 2019 22:19:59 +0200
Date:   Mon, 25 Feb 2019 22:19:58 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Xin Long <lucien.xin@gmail.com>
cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, pablo@netfilter.org,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org
Subject: Re: [PATCH net] ipvs: get sctphdr by sctphoff in sctp_csum_check
In-Reply-To: <cd1c829cfd9ee916e57c51f6879947f0f88c1eb1.1551094063.git.lucien.xin@gmail.com>
Message-ID: <alpine.LFD.2.21.1902252213460.3472@ja.home.ssi.bg>
References: <cd1c829cfd9ee916e57c51f6879947f0f88c1eb1.1551094063.git.lucien.xin@gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Mon, 25 Feb 2019, Xin Long wrote:

> sctp_csum_check() is called by sctp_s/dnat_handler() where it calls
> skb_make_writable() to ensure sctphdr to be linearized.
> 
> So there's no need to get sctphdr by calling skb_header_pointer()
> in sctp_csum_check().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

	Looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

	I guess, it is for the nf-next/net-next tree because it just
eliminates a duplicate check.

> ---
>  net/netfilter/ipvs/ip_vs_proto_sctp.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
> index b0cd7d0..0ecf241 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
> @@ -183,7 +183,7 @@ static int
>  sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp)
>  {
>  	unsigned int sctphoff;
> -	struct sctphdr *sh, _sctph;
> +	struct sctphdr *sh;
>  	__le32 cmp, val;
>  
>  #ifdef CONFIG_IP_VS_IPV6
> @@ -193,10 +193,7 @@ sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp)
>  #endif
>  		sctphoff = ip_hdrlen(skb);
>  
> -	sh = skb_header_pointer(skb, sctphoff, sizeof(_sctph), &_sctph);
> -	if (sh == NULL)
> -		return 0;
> -
> +	sh = (struct sctphdr *)(skb->data + sctphoff);
>  	cmp = sh->checksum;
>  	val = sctp_compute_cksum(skb, sctphoff);
>  
> -- 
> 2.1.0

Regards

--
Julian Anastasov <ja@ssi.bg>
