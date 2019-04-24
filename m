Return-Path: <SRS0=Os8a=S2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E1EC10F11
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 15:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88CA5218D3
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 15:24:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OTKNPqJy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbfDXPYZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Apr 2019 11:24:25 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32849 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbfDXPYZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Apr 2019 11:24:25 -0400
Received: by mail-pf1-f195.google.com with SMTP id h5so9489022pfo.0;
        Wed, 24 Apr 2019 08:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2/16R8gyl/4Jt68+YOJRddfp0JNVpMjs514ajsj6SXI=;
        b=OTKNPqJy7h5GYprQDQN6Z4vsU+o1mvwurwt02Go9DFX9rhJeLtoz+CpjRJpxfTCKI2
         yueMWQOGrhsG8Zd/qD0FGie9FwIiriUW2NcgdIQqE0wYeW7JyfBGKmfYdmJlzHfFvAEV
         hRuRvrg/5b7mpLh2dXvySDo9mzSq240eyMATwgbor24kx6LsT3BuSR+i8A43ww0V9o9H
         zmAMagpQ6E17IuDd0Ba/S8I1tDU2eT85Ku2jNOCSOShzNSfo+ePaRJFXMhUpPobBVoaQ
         EbZTNh7dyrmCndsbu9VcQ+/Mr8Mlol9ckna7bDMz1Iq/r03QDN1zr142ZQB8xDFnF06O
         pSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2/16R8gyl/4Jt68+YOJRddfp0JNVpMjs514ajsj6SXI=;
        b=ox5zE6T5Jyvx4Ly2NBhWhuBg2fwd5qekbgo6IuGSv43lhzD1J7g1Ulpun8tPe0bYyG
         zEfkujjB0+XKnCLud1S+x3pfm7sOmHZyahjw88+WOhl4Eh0CgnzAaJud64NpUwcmfR5O
         SAz/yGundu9eGrOY3K5t9yyN9/Gd9NqxUKunqHEQWBHib3L7YRMG//33seMjhu5BDWE2
         IpSvLDR99+Wn4LyTt9GWKCBnMO4b1i5iFrxYmVkAobZCD6IDXBKSuW1MkNRatrBHnams
         61kIbPFueVuKS80rxkClgpEbJXXHkwUg9oh2adoCmrWI3TmtJRp7l+UGP3taJroNlR8N
         S9zQ==
X-Gm-Message-State: APjAAAV+aRBD4JXl/Sl3Qzwlw77dXS00IsTRsSX0wvAxbQYy7O+KNDTB
        BEqyNYrEBK30q7gZjaAo4/c=
X-Google-Smtp-Source: APXvYqykN155GPoHIgsUNbxEAJ9i4I+zBSXLD+gHWnbjC5Au08k1zgVwdPAli8WjF9dqw6BKf9+e7A==
X-Received: by 2002:a65:6150:: with SMTP id o16mr7681166pgv.285.1556119464441;
        Wed, 24 Apr 2019 08:24:24 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f02b:2058:cbd0:634d? ([2601:282:800:fd80:f02b:2058:cbd0:634d])
        by smtp.googlemail.com with ESMTPSA id b2sm26877642pfo.150.2019.04.24.08.24.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Apr 2019 08:24:23 -0700 (PDT)
Subject: Re: [PATCH v2] net: netfilter: Fix ipv6 rp_filter dropping vrf
 packets by mistake
To:     linmiaohe <linmiaohe@huawei.com>, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mingfangsen <mingfangsen@huawei.com>
References: <7662b7eb-89a4-adac-1e46-2c09816641f2@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <05222a41-c60b-0c05-6beb-26a143deea36@gmail.com>
Date:   Wed, 24 Apr 2019 09:24:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <7662b7eb-89a4-adac-1e46-2c09816641f2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/24/19 3:12 AM, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> When firewall is enabled with rp_filter, vrf ipv6 packets
> will be dropped because in device is vrf but out device
> is an enslaved device. So rt->rt6i_idev->dev != dev and
> maybe return false in func rpfilter_lookup_reverse6.
> 
> Here is the out message when I ping the peer:
> ip vrf exec vrf1 ping 2013::2 -c 1
> 1 packets transmitted, 0 received, 100% packet loss, time 0ms
> 
> The drop info in /var/log/message:
> Apr 24 14:59:45 localhost kernel: [81316.158259] rpfilter_DROP: IN=vrf1
> OUT= MAC=52:54:00:9e:dd:c1:52:54:00:4f:81:38:86:dd
> SRC=2013:0000:0000:0000:0000:0000:0000:0002
> DST=2013:0000:0000:0000:0000:0000:0000:0001 LEN=104 TC=0 HOPLIMIT=64
> FLOWLBL=1032942 PROTO=ICMPv6 TYPE=129 CODE=0 ID=14943 SEQ=1
> 
> Signed-off-by: linmiaohe <linmiaohe@huawei.com>
> ---
>  net/ipv6/netfilter/ip6t_rpfilter.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
> index c3c6b09acdc4..cf1070ab1252 100644
> --- a/net/ipv6/netfilter/ip6t_rpfilter.c
> +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
> @@ -73,6 +73,12 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
>  		goto out;
>  	}
> 
> +	if (netif_is_l3_master(dev)) {
> +		dev = dev_get_by_index_rcu(dev_net(dev), IP6CB(skb)->iif);
> +		if (!dev)
> +			goto out;
> +	}
> +
>  	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
>  		ret = true;
>   out:
> 

What about the case where XT_RPFILTER_LOOSE is set? flowi6_oif needs to
be set to the dev->ifindex if dev is an l3 master.

And looking at the IPv4 version I do not see how it could be correct
either. Have you tested it?
