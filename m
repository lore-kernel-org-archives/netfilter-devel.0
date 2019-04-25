Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43900C10F03
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 10:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD018206BA
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 10:07:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="AdHF5Uo1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfDYKH6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:07:58 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35480 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfDYKH6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 06:07:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id y197so9708884wmd.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2019 03:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MVxB8kavRIR/UCaJf7Veev5Knu70ZTVlyGm9EnRwp6U=;
        b=AdHF5Uo1y4mTPbnh4mvNUPCwkOxPcWgefWQO8Q44KTvx1AxUbrAw+02AFuY+dLHXHQ
         +AhaLZRWh1eybfIv8FK77YsAYX9a3RsbnJpea2V+AKgtgRowxDxpR8TPXlv6zVbPQJrx
         dg23sgr/Dabnaw1WatVTPZVUh87iCOywL8v9jexHyKp25Cd8SugLArgU6MrKdFd8uk59
         Bi/1f45ntWySAE8bgxcJGC2oxV/rPm+x+Gug9Mv5hN0kXTbCOTIr/9N6LxMpar+8fDCr
         e87t234+H5Bn5PuHwcmZQPHRcQZh8moDOF0rWOPEGzRRY732mHI9X/I0TDZrOoeQIYjT
         vc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=MVxB8kavRIR/UCaJf7Veev5Knu70ZTVlyGm9EnRwp6U=;
        b=hQyA1TAZuiAffA06do1PlnNzGxHG5Afpxykxr8MNOFllX253k5URAciKsZaZpKWSfR
         QHx2S7ezdhQ2SuicHtvrDV7S4nSNyoEWeN/8kCruLBfi8mDgALkhsR8ly2wuqyKzRc3Y
         t7Wvz79s1Zx+1SkdmO7RhBgbuZ8INIhe9VgNaKdwqploN4kTfvKd9/UoYHOPD0UXaa3g
         La/gIzoITdbA+nrXnYvGpMBsQlk631v42qxnGlMIKsgrPkvHzh+Gi3vbuI+gLBgEei8R
         coUAlmWqgmQGZp2jXNCxcmUGN9KBNWgoiPXstX5sr+PtpPZCCXJiJJlT5smJ9oFUoJZF
         uVRQ==
X-Gm-Message-State: APjAAAXalkFP1cmJ9j1PNx1/81m71EvckP22sqOZyp6+x86LkfGAE4hf
        tN51p9eh4dMqTu5VnLQ4xPwvdNVKXfU=
X-Google-Smtp-Source: APXvYqzuubi0TDdPPa+xXLgfqOaBGOAjqzB3hulQCylrl46csZfJNH1BIdvzBui1tsOPCCazrb5OZQ==
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr3054523wme.72.1556186876563;
        Thu, 25 Apr 2019 03:07:56 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:d4c0:843b:d436:a905? ([2a01:e35:8b63:dc30:d4c0:843b:d436:a905])
        by smtp.gmail.com with ESMTPSA id t15sm23311814wmt.2.2019.04.25.03.07.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Apr 2019 03:07:55 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on
 flush
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-8-pablo@netfilter.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
Date:   Thu, 25 Apr 2019 12:07:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20181008230125.2330-8-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 09/10/2018 à 01:01, Pablo Neira Ayuso a écrit :
> From: Kristian Evensen <kristian.evensen@gmail.com>
> 
> The same connection mark can be set on flows belonging to different
> address families. This commit adds support for filtering on the L3
> protocol when flushing connection track entries. If no protocol is
> specified, then all L3 protocols match.
> 
> In order to avoid code duplication and a redundant check, the protocol
> comparison in ctnetlink_dump_table() has been removed. Instead, a filter
> is created if the GET-message triggering the dump contains an address
> family. ctnetlink_filter_match() is then used to compare the L3
> protocols.
> 
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
[snip] 					continue;
> @@ -1213,12 +1219,12 @@ static int ctnetlink_flush_iterate(struct nf_conn *ct, void *data)
>  
>  static int ctnetlink_flush_conntrack(struct net *net,
>  				     const struct nlattr * const cda[],
> -				     u32 portid, int report)
> +				     u32 portid, int report, u8 family)
>  {
>  	struct ctnetlink_filter *filter = NULL;
>  
> -	if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
> -		filter = ctnetlink_alloc_filter(cda);
> +	if (family || (cda[CTA_MARK] && cda[CTA_MARK_MASK])) {
Since this patch, there is a regression with 'conntrack -F', it does not flush
anymore ipv6 conntrack entries.
In fact, the conntrack tool set by default the family to AF_INET and forbid to
set the family to something else (the '-f' option is not allowed for the command
'flush').

Any idea to fix this (without changing the conntrack tool) is welcomed.


Regards,
Nicolas

> +		filter = ctnetlink_alloc_filter(cda, family);
>  		if (IS_ERR(filter))
>  			return PTR_ERR(filter);
>  	}
> @@ -1257,7 +1263,7 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
>  	else {
>  		return ctnetlink_flush_conntrack(net, cda,
>  						 NETLINK_CB(skb).portid,
> -						 nlmsg_report(nlh));
> +						 nlmsg_report(nlh), u3);
>  	}
>  
>  	if (err < 0)
> 
