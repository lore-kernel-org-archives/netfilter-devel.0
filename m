Return-Path: <SRS0=dF0f=SS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD079C282DA
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Apr 2019 16:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E2862087C
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Apr 2019 16:43:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="CXSfdCJC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbfDPQnY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 12:43:24 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54219 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfDPQnY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 12:43:24 -0400
Received: by mail-wm1-f68.google.com with SMTP id q16so26256277wmj.3
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Apr 2019 09:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k3quigJ3iYyqr+cUUV1MvC6h/03y1DMhl58wXKND/s8=;
        b=CXSfdCJC1IJ6452LEsWnioATig2vc/Wp1A33kz8KI/uJASA0+EN88DwZxcplhb74iL
         pqcsegWA+1zfu4aGAn8IaBhuOQrzO49XLeU0KUK4p8BihQm/gmk9hYCbPK9m93j9+bjD
         aflTLwBZ5aIBS+EdygjLtdrJwCSp3sVslATFE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k3quigJ3iYyqr+cUUV1MvC6h/03y1DMhl58wXKND/s8=;
        b=T18oRmb6jRSjcQHsqR92yhF2WGF2sf90yye3iihTNbZY2kPaBY8d1kTknvhyjYkfBR
         /VYelMlkVOH/cDSAI4rbK3bPAJtYkB9TPVXXhZyFr2YAuS+gP+CBbIuWmT5R1zAmTXDg
         a0ciuaGSKU0QqDzxdiBMaGN5Ack1QS5brVCi56FrEzbhnl3Tb3yfkidSxRtrekBLpRKL
         IMFz3fC7rd0hrcoP0Z/tomtjHJr22OpfSp3ug+IduGQ4NiPktM68x4xjOOY8xw5NO8Mx
         KHe8LmmxKiur08+vZKkZEj3IZZreB0XC1SSiPDzvC6IutiMhSja245y0GFNBCuir/1eI
         hsZg==
X-Gm-Message-State: APjAAAWfRSo2hhDUEzX9ivV0JSIU1oGB05GSfiLva/p9joDuZs4TvGpR
        yWhPySDBKjlqPjnFLGVEq9DK1Q==
X-Google-Smtp-Source: APXvYqz5D7yzzDKkJI05PSIrFteCggTXG1tpVPs/sy/CKOp8i92oZHXgODSRD2Sw2emYNZug6sfYJQ==
X-Received: by 2002:a7b:c743:: with SMTP id w3mr27023857wmk.75.1555433002203;
        Tue, 16 Apr 2019 09:43:22 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id z18sm79698112wrr.90.2019.04.16.09.43.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Apr 2019 09:43:21 -0700 (PDT)
Subject: Re: [PATCH net-next 08/10] netfilter: bridge: add support for
 conntrack support
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, fw@strlen.de,
        roopa@cumulusnetworks.com, herbert@gondor.apana.org.au
References: <20190415213611.21863-1-pablo@netfilter.org>
 <20190415213611.21863-9-pablo@netfilter.org>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <f81e45f2-aa95-14f5-81b2-d07cf08ddaec@cumulusnetworks.com>
Date:   Tue, 16 Apr 2019 19:43:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415213611.21863-9-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 16/04/2019 00:36, Pablo Neira Ayuso wrote:
> This patch adds basic connection tracking support for the bridge,
> including initial IPv4 support.
> 
> This patch register two hooks to deal with the bridge forwarding path,
> one at bridge prerouting to call nf_conntrack_in() and another at the
> bridge postrouting hook to confirm the entry.
> 
> The conntrack bridge prerouting hook defragments packets and it passes
> them to nf_conntrack_in() to look up for an existing entry, otherwise a
> new entry is created in the conntrack table.
> 
> The conntrack bridge postrouting hook confirms new entries, ie. this is
> the first packet seen of this flow, then (if needed) it refragments the
> skbuff into the original fragments, leaving the geometry as is if
> possible. Exceptions are linearized skbuffs, eg. passed up to nfqueue
> and conntrack helpers, cloned skbuff for the local delivery (eg.
> tcpdump) or in case of bridge port flooding.
> 
> The packet defragmentation is done through the ip_defrag() call.  This
> forces us to save the bridge control buffer, reset the IP control buffer
> area and then restore it after call. This function also bumps the IP
> fragmentation statistics. The maximum fragment length is stored in the
> control buffer and it is used to refragment the skbuff.
> 
> The new fraglist iterator and fragment transformer APIs is used to
> implement the refragmentation code. The br_ip_fragment() function drops
> the packet in case the maximum fragment size seen is larger than the
> output port MTU.
> 
> This patchset follows the principle that conntrack should not drop
> packets, so users can do it through policy via invalid state.
> 
> Like br_netfilter, there is no refragmentation for packets that are
> passed up for local delivery, ie. prerouting -> input path. There are
> calls to nf_reset() already in several spots that were placed there a
> bit of time ago already, eg. af_packet, that show that skbuff fraglist
> from the netif_rx path is supported already.
> 
> The helpers are called from the postrouting hook, before confirmation,
> from there we may see packet floods to bridge ports. Then, although
> unlikely this may result in exercising the helpers many times for each
> clone. We should probably explore how to pass all the packets in a list
> to the conntrack hook to do this handle only once for this case.
> 
> This patch is based on original work from Florian Westphal.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_conntrack_bridge.h |   7 +
>  include/net/netfilter/nf_conntrack_core.h   |   3 +
>  net/bridge/br_device.c                      |   1 +
>  net/bridge/br_private.h                     |   1 +
>  net/bridge/netfilter/Kconfig                |  14 ++
>  net/bridge/netfilter/Makefile               |   3 +
>  net/bridge/netfilter/nf_conntrack_bridge.c  | 378 ++++++++++++++++++++++++++++
>  net/netfilter/nf_conntrack_proto.c          |   7 +-
>  8 files changed, 410 insertions(+), 4 deletions(-)
>  create mode 100644 net/bridge/netfilter/nf_conntrack_bridge.c
> 
[snip]
> diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
> index 9a0159aebe1a..eb61197d8af8 100644
> --- a/net/bridge/netfilter/Kconfig
> +++ b/net/bridge/netfilter/Kconfig
> @@ -18,6 +18,20 @@ config NF_LOG_BRIDGE
>  	tristate "Bridge packet logging"
>  	select NF_LOG_COMMON
>  
> +config NF_CONNTRACK_BRIDGE
> +	tristate "IPv4/IPV6 bridge connection tracking support"
> +	depends on NF_CONNTRACK
> +	default n
> +	help
> +	  Connection tracking keeps a record of what packets have passed
> +	  through your machine, in order to figure out how they are related
> +	  into connections. This is used to enhance packet filtering via
> +	  stateful policies. Enable this if you want native tracking from
> +	  the bridge. This is provides a replacement for the `br_netfilter'

nit: typo "This is provides..."

> +	  infrastructure.
> +
> +	  To compile it as a module, choose M here.  If unsure, say N.
> +



