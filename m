Return-Path: <SRS0=Ro/3=TA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2ECEC43219
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 12:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE8CD2080C
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 12:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbfD3M3S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 08:29:18 -0400
Received: from mail.us.es ([193.147.175.20]:48730 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfD3M3S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 08:29:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B90F11FF86
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 14:29:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BDA8DA711
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 14:29:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 517D3DA70F; Tue, 30 Apr 2019 14:29:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51095DA705;
        Tue, 30 Apr 2019 14:29:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Apr 2019 14:29:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1541A4265A32;
        Tue, 30 Apr 2019 14:29:14 +0200 (CEST)
Date:   Tue, 30 Apr 2019 14:29:13 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [RFC nf-next v2 1/2] netfilter: connmark: introduce savedscp
Message-ID: <20190430122913.lyz7qjh5eebx7lpk@salvia>
References: <FEBDDE5A-DC07-4E41-84B3-C5033EB20CCE@darbyshire-bryant.me.uk>
 <20190409142333.68403-1-ldir@darbyshire-bryant.me.uk>
 <20190409142333.68403-2-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409142333.68403-2-ldir@darbyshire-bryant.me.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 09, 2019 at 02:23:46PM +0000, Kevin 'ldir' Darbyshire-Bryant wrote:
> diff --git a/include/uapi/linux/netfilter/xt_connmark.h b/include/uapi/linux/netfilter/xt_connmark.h
> index 1aa5c955ee1e..24272cac2d37 100644
> --- a/include/uapi/linux/netfilter/xt_connmark.h
> +++ b/include/uapi/linux/netfilter/xt_connmark.h
> @@ -16,7 +16,8 @@
>  enum {
>  	XT_CONNMARK_SET = 0,
>  	XT_CONNMARK_SAVE,
> -	XT_CONNMARK_RESTORE
> +	XT_CONNMARK_RESTORE,
> +	XT_CONNMARK_SAVEDSCP

I'd prefer you implement this in nftables, more comments below.

>  };
>  
>  enum {
> diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
> index 29c38aa7f726..6c63cf476342 100644
> --- a/net/netfilter/xt_connmark.c
> +++ b/net/netfilter/xt_connmark.c
> @@ -42,6 +42,7 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
>  	u_int32_t new_targetmark;
>  	struct nf_conn *ct;
>  	u_int32_t newmark;
> +	u8 dscp;
>  
>  	ct = nf_ct_get(skb, &ctinfo);
>  	if (ct == NULL)
> @@ -74,6 +75,34 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
>  			nf_conntrack_event_cache(IPCT_MARK, ct);
>  		}
>  		break;
> +	case XT_CONNMARK_SAVEDSCP:

Could you add a new revision and a new flag field for this? so it just
adds the dscp to the mark as you need.

> +		if (!info->ctmark)
> +			goto out;
> +
> +		if (skb->protocol == htons(ETH_P_IP)) {
> +			if (skb->len < sizeof(struct iphdr))
> +				goto out;
> +
> +			dscp = ipv4_get_dsfield(ip_hdr(skb)) >> 2;
> +
> +		} else if (skb->protocol == htons(ETH_P_IPV6)) {
> +			if (skb->len < sizeof(struct ipv6hdr))
> +				goto out;

This is already guaranteed to have a valid IP header in place, no need
for this check.

> +
> +			dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> 2;
> +
> +		} else { /* protocol doesn't have diffserv - get out! */
> +			goto out;
> +		}
> +
> +		newmark = (ct->mark & ~info->ctmark) ^
> +			  (info->ctmask | (dscp << info->shift_bits));
> +
> +		if (ct->mark != newmark) {
> +			ct->mark = newmark;
> +			nf_conntrack_event_cache(IPCT_MARK, ct);
> +		}
> +		break;
>  	case XT_CONNMARK_RESTORE:
>  		new_targetmark = (ct->mark & info->ctmask);
>  		if (info->shift_dir == D_SHIFT_RIGHT)
> @@ -86,6 +115,7 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
>  		skb->mark = newmark;
>  		break;
>  	}
> +out:
>  	return XT_CONTINUE;
>  }
>  
> -- 
> 2.20.1 (Apple Git-117)
> 
