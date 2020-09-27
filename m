Return-Path: <SRS0=8C00=DE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CB9C4346E
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Sep 2020 13:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6100421775
	for <netfilter-devel@archiver.kernel.org>; Sun, 27 Sep 2020 13:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgI0Nc0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 27 Sep 2020 09:32:26 -0400
Received: from mg.ssi.bg ([178.16.128.9]:52580 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgI0Nc0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Sep 2020 09:32:26 -0400
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 266001371C;
        Sun, 27 Sep 2020 16:32:24 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id 8535C136D6;
        Sun, 27 Sep 2020 16:32:23 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 207613C0332;
        Sun, 27 Sep 2020 16:32:18 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 08RDWDP7035896;
        Sun, 27 Sep 2020 16:32:16 +0300
Date:   Sun, 27 Sep 2020 16:32:13 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     "longguang.yue" <bigclouds@163.com>
cc:     yuelongguang@gmail.com, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] ipvs: adjust the debug info in function
 set_tcp_state
In-Reply-To: <20200927120756.75676-1-bigclouds@163.com>
Message-ID: <alpine.LFD.2.23.451.2009271625160.35554@ja.home.ssi.bg>
References: <20200927120756.75676-1-bigclouds@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Sun, 27 Sep 2020, longguang.yue wrote:

>         outputting client,virtual,dst addresses info when tcp state changes,
>         which makes the connection debug more clear
> 
> Signed-off-by: longguang.yue <bigclouds@163.com>

	Looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

	Simon, Pablo, may be commit description should not
be indented...

> ---
>  net/netfilter/ipvs/ip_vs_proto_tcp.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> index dc2e7da2742a..7da51390cea6 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> @@ -539,8 +539,8 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
>  	if (new_state != cp->state) {
>  		struct ip_vs_dest *dest = cp->dest;
>  
> -		IP_VS_DBG_BUF(8, "%s %s [%c%c%c%c] %s:%d->"
> -			      "%s:%d state: %s->%s conn->refcnt:%d\n",
> +		IP_VS_DBG_BUF(8, "%s %s [%c%c%c%c] c:%s:%d v:%s:%d "
> +			      "d:%s:%d state: %s->%s conn->refcnt:%d\n",
>  			      pd->pp->name,
>  			      ((state_off == TCP_DIR_OUTPUT) ?
>  			       "output " : "input "),
> @@ -548,10 +548,12 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
>  			      th->fin ? 'F' : '.',
>  			      th->ack ? 'A' : '.',
>  			      th->rst ? 'R' : '.',
> -			      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
> -			      ntohs(cp->dport),
>  			      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
>  			      ntohs(cp->cport),
> +			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
> +			      ntohs(cp->vport),
> +			      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
> +			      ntohs(cp->dport),
>  			      tcp_state_name(cp->state),
>  			      tcp_state_name(new_state),
>  			      refcount_read(&cp->refcnt));
> -- 
> 2.20.1 (Apple Git-117)

Regards

--
Julian Anastasov <ja@ssi.bg>

