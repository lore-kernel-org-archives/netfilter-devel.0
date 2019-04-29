Return-Path: <SRS0=bgPs=S7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D3BEC43219
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 22:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 197D32075E
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 22:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="Lcfo/zd4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbfD2WIs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Apr 2019 18:08:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45766 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbfD2WIr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Apr 2019 18:08:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id s15so18223330wra.12
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Apr 2019 15:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dL8zCrrjizWUNUdOzdkXTS+oc5CJH3ds7UM+UpIquFs=;
        b=Lcfo/zd451IFv+xL3XK6KtOEYCpauDdNTv1I9u/CcUyFYqGYHMxxYZn2+xeqkQQ6vI
         K77OrsGeTx4CF03PSO/MxNOwx1Wo8aWH2ch0P+T/flbuCsJ7xQkyYwvLdYpL0L7gagYe
         CYOlt/MLtJzfsLf05M25xXkba/wy3W67k2VYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dL8zCrrjizWUNUdOzdkXTS+oc5CJH3ds7UM+UpIquFs=;
        b=p3nwitGEI8zRUbOsBhYRDpEWueQPwh+9V4X0p6P414xdw7DW6sTxgFzVIfOSgy/Q1Y
         PXm+w6jepD/RlOQRbTSRDYBjoHtpXsZfgWCOyBqWlFml6b0mEzHVTV6CmU8isr6algw4
         IR9As2k7X97ty7jFmtOW+lyxc6MFzQwZ0vMPailv0QRIQWD6Iyc39cXqgDl7yMmq8ap5
         j9Z0iYf28wb9lFVSFsRLfGk55Hc3shUctodRiWSdgm5DrAEs0niZUulTbZfVPbQ6PaWc
         Sh90Ba4YzFKcLRznL3JW+iKVPYe6sVocHwv2ptE0IkFi3OThLg5g+uY7j7vonDC7v6Kb
         mwhA==
X-Gm-Message-State: APjAAAVDJ92jIeBKZrllZwXqNLFPD7iS48tpDfQ9bZw54+MHW5HbXXTr
        Uh6fknpjboHvuwJg1d79XwF7VQ==
X-Google-Smtp-Source: APXvYqz3eZAANFhLYQznj+3iGD8myRjBh0cYt3hJYM5BpnQHLcV20SydZB4FZy6qlN9cjo2rxUVUxQ==
X-Received: by 2002:adf:9e86:: with SMTP id a6mr1654618wrf.178.1556575725056;
        Mon, 29 Apr 2019 15:08:45 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m4sm5621770wrb.15.2019.04.29.15.08.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 15:08:44 -0700 (PDT)
Subject: Re: [PATCH 7/9 net-next,v2] netfilter: bridge: add connection
 tracking system
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com
References: <20190429195014.4724-1-pablo@netfilter.org>
 <20190429195014.4724-8-pablo@netfilter.org>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <9d4cda17-80eb-a566-9d1d-ea6425ab15d2@cumulusnetworks.com>
Date:   Tue, 30 Apr 2019 01:08:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429195014.4724-8-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 29/04/2019 22:50, Pablo Neira Ayuso wrote:
> This patch adds basic connection tracking support for the bridge,
> including initial IPv4 support.
> 
> This patch register two hooks to deal with the bridge forwarding path,
> one at bridge prerouting hook to call nf_conntrack_in() and another at
> the bridge postrouting hook to confirm the entry.
> 
> The conntrack bridge prerouting hook defragments packets and it passes
> them to nf_conntrack_in() to look up for an existing entry, otherwise a
> new entry is created in the conntrack table.
> 
> The conntrack bridge postrouting hook confirms new entries, ie. if this
> is the first packet seen of this flow that went through the entire
> bridge layer, then it adds the entries to the hashtable and (if needed)
> it refragments the skbuff into the original fragments, leaving the
> geometry as is if possible. Exceptions are linearized skbuffs, eg.
> skbuffs that are passed up to nfqueue and conntrack helpers, as well
> as cloned skbuff for the local delivery (eg. tcpdump) or in case of
> bridge port flooding.
> 
> The packet defragmentation is done through the ip_defrag() call.  This
> forces us to save the bridge control buffer, reset the IP control buffer
> area and then restore it after call. This function also bumps the IP
> fragmentation statistics. The maximum fragment length is stored in the
> control buffer and it is used to refragment the skbuff.
> 
> The new fraglist iterator and fragment transformer APIs is used to
> implement the bridge refragmentation code. The br_ip_fragment() function
> drops the packet in case the maximum fragment size seen is larger than
> the output port MTU.
> 
> This patchset follows the principle that conntrack should not drop
> packets, so users can do it through policy via invalid state.
> 
> Like br_netfilter, there is no refragmentation for packets that are
> passed up for local delivery, ie. prerouting -> input path. There are
> calls to nf_reset() already in several spots since time ago already, eg.
> af_packet, that show that skbuff fraglist from the netif_rx path is
> supported already.
> 
> The helpers are called from the postrouting hook, before confirmation,
> from there we may see packet floods to bridge ports. Then, although
> unlikely, this may result in exercising the helpers many times for each
> clone. It would be good to explore how to pass all the packets in a list
> to the conntrack hook to do this handle only once for this case.
> 
> This patch is based on original work from Florian Westphal.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: no changes.
> 
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
                      ^^^^^^^^^^^^^^^^
Same comment like the previous time, "This is provides". Should be "This provides" ?
http://patchwork.ozlabs.org/patch/1085949/

> +	  infrastructure.

Cheers,
 Nik


