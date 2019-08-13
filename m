Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BEBC32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 14:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 862472067D
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 14:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JC9JhGo3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbfHMOer (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 10:34:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50879 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbfHMOer (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 10:34:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so1751895wml.0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 07:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uoSVCFnMGDbJ3T6CK+zx5gKma5l/hOQZ+XEmFVHXG3U=;
        b=JC9JhGo3/UBd5r6OgERJv8xxFZTkdLChMqWk8O3f72tmbP9b4HmT7sr/GWG7HNr1pN
         Pc6otZCu/kID0ZbyjFfHK8VM/G+4+c1ewJwlDG7PCgD9VS6qwB+7n9S7DFqGwzD1rpsG
         hS/9X+VdV5wka5p3kuqT/4Bu3B35s0Wih3JuQVg6thDb+m6lgk+w4FewZjz01oPg42IR
         H8/H6vlsDINFR7YiEwZ9hYwWkg4+xu33yCyf/hbHn0gUanpv3GZVYQ9m+8QI6KRBO214
         4b+TT7OjoleT0pfFfuzxvUZq3Q47uVGTCc4xGmapHwDELFkevAgL1BZ2GKkmj8HoAC7l
         qUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uoSVCFnMGDbJ3T6CK+zx5gKma5l/hOQZ+XEmFVHXG3U=;
        b=ucfqEfpadPpnq9h9OGw5u2Vineg4rbuCZK2gZ1MNkkxi6RuWKTWCznCo/BLQ1ebfuQ
         c2mMYq9WliWgF7hqnEy7zZyAhDbD+8NWBuBOVrhmlq42J5q2MITNxp1nt/cRy/9EfvYG
         FyjzK70LtUH/TJKg4M0DJ0TnseLHvUM5zv4DkyuBYXrv9TkXSTEy/kBr0t8HYo5M95gI
         XGLzukbdKQk82TbOefeRe5ebv1iO5LNVBnoTYGpIs2fNLPqaEaNN2bSPnYX3Tdo4DDcK
         iHD+4mQuKitwM/U92xurDaw/IDpIDcVcDmAqi+WDvSwrynla8ZktlrIfkAAO5DsD5LYj
         pBRg==
X-Gm-Message-State: APjAAAWshd6WokfLVWF7FJkDuwA8E1x8Np4CQMgcCNFbGFkMbGdN2wQl
        H+IpH5hzoRxEmjXO9rW0L2xjqFcA
X-Google-Smtp-Source: APXvYqy6QJUfKd0fLiaPlEx0T2XE51oJ1bSed94ZA89OG0GveSVeL5eFD3r3Vjcy3Ze6RJh6qM4euw==
X-Received: by 2002:a1c:1d08:: with SMTP id d8mr3433441wmd.22.1565706884684;
        Tue, 13 Aug 2019 07:34:44 -0700 (PDT)
Received: from [192.168.8.147] (91.174.185.81.rev.sfr.net. [81.185.174.91])
        by smtp.gmail.com with ESMTPSA id k124sm3663965wmk.47.2019.08.13.07.34.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 07:34:43 -0700 (PDT)
Subject: Re: [PATCH nf] netfilter: nft_flow_offload: skip tcp rst and fin
 packets
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190813085127.3860-1-pablo@netfilter.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c4f87be3-ae9b-27ee-ed48-bcc7ff665895@gmail.com>
Date:   Tue, 13 Aug 2019 16:34:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190813085127.3860-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 8/13/19 10:51 AM, Pablo Neira Ayuso wrote:
> TCP rst and fin packets do not qualify to place a flow into the
> flowtable. Most likely there will be no more packets after connection
> closure. Without this patch, this flow entry expires and connection
> tracking picks up the entry in ESTABLISHED state using the fixup
> timeout, which makes this look inconsistent to the user for a connection
> that is actually already closed.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_flow_offload.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index aa5f571d4361..6dc54c2ca856 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -73,10 +73,10 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  	struct nft_flow_offload *priv = nft_expr_priv(expr);
>  	struct nf_flowtable *flowtable = &priv->flowtable->data;
>  	enum ip_conntrack_info ctinfo;
> +	struct tcphdr *tcph = NULL;
>  	struct nf_flow_route route;
>  	struct flow_offload *flow;
>  	enum ip_conntrack_dir dir;
> -	bool is_tcp = false;
>  	struct nf_conn *ct;
>  	int ret;
>  
> @@ -89,7 +89,9 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  
>  	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
>  	case IPPROTO_TCP:
> -		is_tcp = true;
> +		tcph = (void *)(skb_network_header(pkt->skb) + pkt->xt.thoff);

Don't you need something like :

tcph = skb_header_pointer(pkt->skb, pkt->xt.thoff, sizeof(*tcph), buffer);


> +		if (unlikely(tcph->fin || tcph->rst))
> +			goto out;
>  		break;
>  	case IPPROTO_UDP:
>  		break;
> @@ -115,7 +117,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  	if (!flow)
>  		goto err_flow_alloc;
>  
> -	if (is_tcp) {
> +	if (tcph) {
>  		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
>  		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
>  	}
> 
