Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CE4C4361B
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 13:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BA6523380
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 13:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgLGNg3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:36:29 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:35224 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgLGNg3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Dec 2020 08:36:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 50124201E5;
        Mon,  7 Dec 2020 14:35:47 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bvWTkXGRiujs; Mon,  7 Dec 2020 14:35:46 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B84A12009B;
        Mon,  7 Dec 2020 14:35:46 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 7 Dec 2020 14:35:46 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 7 Dec 2020
 14:35:46 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E392F318085B;
 Mon,  7 Dec 2020 14:35:45 +0100 (CET)
Date:   Mon, 7 Dec 2020 14:35:45 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     <linux-crypto@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        "Nicolas Dichtel" <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH] xfrm: interface: Don't hide plain packets from netfilter
Message-ID: <20201207133545.GF85961@gauss3.secunet.de>
References: <20201207130303.30774-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201207130303.30774-1-phil@nwl.cc>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 07, 2020 at 02:03:03PM +0100, Phil Sutter wrote:
> With an IPsec tunnel without dedicated interface, netfilter sees locally
> generated packets twice as they exit the physical interface: Once as "the
> inner packet" with IPsec context attached and once as the encrypted
> (ESP) packet.
> 
> With xfrm_interface, the inner packet did not traverse NF_INET_LOCAL_OUT
> hook anymore, making it impossible to match on both inner header values
> and associated IPsec data from that hook.
> 
> Fix this by looping packets transmitted from xfrm_interface through
> NF_INET_LOCAL_OUT before passing them on to dst_output(), which makes
> behaviour consistent again from netfilter's point of view.
> 
> Fixes: f203b76d78092 ("xfrm: Add virtual xfrm interfaces")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/xfrm/xfrm_interface.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> index aa4cdcf69d471..24af61c95b4d4 100644
> --- a/net/xfrm/xfrm_interface.c
> +++ b/net/xfrm/xfrm_interface.c
> @@ -317,7 +317,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
>  	skb_dst_set(skb, dst);
>  	skb->dev = tdev;
>  
> -	err = dst_output(xi->net, skb->sk, skb);
> +	err = NF_HOOK(skb_dst(skb)->ops->family, NF_INET_LOCAL_OUT, xi->net,
> +		      skb->sk, skb, NULL, skb_dst(skb)->dev, dst_output);
>  	if (net_xmit_eval(err) == 0) {
>  		struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);

This is networking code, so please send your patch also to the netdev list:
netdev@vger.kernel.org
