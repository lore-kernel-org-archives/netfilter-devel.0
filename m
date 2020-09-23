Return-Path: <SRS0=+Cxx=DA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF66C2D0A8
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 17:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD89B20665
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Sep 2020 17:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgIWRmr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Sep 2020 13:42:47 -0400
Received: from mg.ssi.bg ([178.16.128.9]:53134 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbgIWRmr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Sep 2020 13:42:47 -0400
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id EC27E2C44B
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2020 20:33:06 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id 443C62C3CA
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2020 20:33:06 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id AC3963C0332;
        Wed, 23 Sep 2020 20:33:01 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 08NHWwhQ005307;
        Wed, 23 Sep 2020 20:32:58 +0300
Date:   Wed, 23 Sep 2020 20:32:58 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     yue longguang <yuelongguang@gmail.com>
cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, pablo@netfilter.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] ipvs: adjust the debug order of src and dst
In-Reply-To: <CAPaK2r921GtJVhwGKnZyCcQ1qkcWA=8TBWwNkW03R_=7TKzo6g@mail.gmail.com>
Message-ID: <alpine.LFD.2.23.451.2009232012470.4453@ja.home.ssi.bg>
References: <CAPaK2r921GtJVhwGKnZyCcQ1qkcWA=8TBWwNkW03R_=7TKzo6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Wed, 23 Sep 2020, yue longguang wrote:

> From: ylg <bigclouds@163.com>
> 
> adjust the debug order of src and dst when tcp state changes
> 
> Signed-off-by: ylg <bigclouds@163.com>
> ---
>  net/netfilter/ipvs/ip_vs_proto_tcp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> index dc2e7da2742a..6567eb45a234 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> @@ -548,10 +548,10 @@ set_tcp_state(struct ip_vs_proto_data *pd,
> struct ip_vs_conn *cp,
>        th->fin ? 'F' : '.',
>        th->ack ? 'A' : '.',
>        th->rst ? 'R' : '.',
> -      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
> -      ntohs(cp->dport),
>        IP_VS_DBG_ADDR(cp->af, &cp->caddr),
>        ntohs(cp->cport),
> +      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
> +      ntohs(cp->dport),
>        tcp_state_name(cp->state),
>        tcp_state_name(new_state),
>        refcount_read(&cp->refcnt));
> -- 

	The first patch applies but this one does not: wrapped lines,
different tabs. You can also consider using the
"c:%s:%d v:%s:%d d:%s:%d" format as in ip_vs_bind_dest(). As result,
we will avoid the confusion about "->" meaning.

Regards

--
Julian Anastasov <ja@ssi.bg>

