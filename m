Return-Path: <SRS0=eCuo=7L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3CDC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 19:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1E4420814
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 May 2020 19:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgE2TPZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 May 2020 15:15:25 -0400
Received: from correo.us.es ([193.147.175.20]:35232 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgE2TPZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 May 2020 15:15:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 532F118D003
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 21:15:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45884DA705
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2020 21:15:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3B4FDDA701; Fri, 29 May 2020 21:15:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CEE58DA707;
        Fri, 29 May 2020 21:15:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 21:15:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B234C42EE38F;
        Fri, 29 May 2020 21:15:19 +0200 (CEST)
Date:   Fri, 29 May 2020 21:15:19 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laura Garcia Liebana <nevola@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, devel@zevenet.com
Subject: Re: [PATCH v2 nf-next] netfilter: introduce support for reject at
 prerouting stage
Message-ID: <20200529191519.GA32761@salvia>
References: <20200529110328.GA20367@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529110328.GA20367@nevthink>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 29, 2020 at 01:03:28PM +0200, Laura Garcia Liebana wrote:
[...]
> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> index 2361fdac2c43..b5b7633d9433 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -96,6 +96,22 @@ void nf_reject_ip_tcphdr_put(struct sk_buff *nskb, const struct sk_buff *oldskb,
>  }
>  EXPORT_SYMBOL_GPL(nf_reject_ip_tcphdr_put);
>  
> +static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
> +{
> +	struct dst_entry *dst = NULL;
> +	struct flowi fl;
> +	struct flowi4 *fl4 = &fl.u.ip4;
> +
> +	memset(fl4, 0, sizeof(*fl4));
> +	fl4->daddr = ip_hdr(skb_in)->saddr;
> +	nf_route(dev_net(skb_in->dev), &dst, &fl, false, AF_INET);
> +	if (!dst)
> +		return -1;
> +
> +	skb_dst_set(skb_in, dst);
> +	return 0;
> +}

Probably slightly simplify this? I'd suggest:

* make calls to nf_ip_route() and nf_ip6_route() instead of the nf_route()
  wrapper.

* use flowi structure, no need to add struct flowi4 ? Probably:

static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
{
        struct dst_entry *dst = NULL;
        struct flowi fl;

        memset(fl, 0, sizeof(*fl));
        fl.u.ip4 = ip_hdr(skb_in)->saddr;
        nf_ip_route(dev_net(skb_in->dev), &dst, &fl, false);
        if (!dst)
                return -1;

        skb_dst_set(skb_in, dst);
        return 0;
}

Another possibility would be to use C99 structure initialization. But
I think the code above should be fine.

Thanks.
