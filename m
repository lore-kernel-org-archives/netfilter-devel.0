Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2843FC0650F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3DFE20693
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 12:41:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="gJ1Zv7I1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbfG3Ml2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:41:28 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42097 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbfG3Ml2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 08:41:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id x1so15707457wrr.9
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 05:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BlP4513unQUdet+MKvQ2g15uNq4TvoNSOCqk6BEJf7o=;
        b=gJ1Zv7I1MINBx3xVNBcaEWYgqiAI2Hxdpv8UWLgZ1l+KCYj74JMQWldehUfc6SIkAz
         6wAw9qlPZq6SQKIeNsAhxvcBfOZEMvPvAc5Q0LHyJdD4gVZgojW4m+qLNz4GfrBixnVY
         AKPWBhhHasuwPOKwO/HteYm4dTpfSYy2+WL0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BlP4513unQUdet+MKvQ2g15uNq4TvoNSOCqk6BEJf7o=;
        b=KvyUKUfYEaw7Ss5SsbhkV1EROhwW/hh2bvvmLa8tTsjfZMvz5FkgoLd6FEBe8MVbWy
         AEgUrFcPpkIXfIbX0ck1lUQ7tv8HKfU/UZrjazXPbhkDd1fUOOTxs4YdMJUxTUU7SbT6
         2MLc9qFAWL3pj6l5IMrTCInuSoLttzQzbhkQtl3FI44Lu2GzKGe82WD5vOgt5s+vvnTt
         P6qxNdrzKZ2ODF9cLyWDoJlwXd8IdAjK+g6ZRcXUD76E3t6ZQF4LA9D1oaAfYfgHElqu
         Nf1W0e99gtEgr9t/a3SKFRYUG4erU451AxbvdadfWtdSYTzrVfv7Lt01NvIsKj1TgmyL
         +tog==
X-Gm-Message-State: APjAAAXg25Vqay7XFRRuIpV9DZR0Jbt+O2WwKuNMk7eqgT1RjV/NOWgw
        691kEG/lTjqRw6AeOYHW4XlvKg==
X-Google-Smtp-Source: APXvYqymLpYKBAlscHzFKItEq4jYCoeLBstlJUeaMgXHLDywH09H+q/A04KfrqhOZLQGA6w7A4n4MQ==
X-Received: by 2002:a5d:5507:: with SMTP id b7mr12759586wrv.35.1564490485822;
        Tue, 30 Jul 2019 05:41:25 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id g12sm94634989wrv.9.2019.07.30.05.41.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 05:41:25 -0700 (PDT)
Subject: Re: [PATCH] bridge:fragmented packets dropped by bridge
To:     Rundong Ge <rdong.ge@gmail.com>, davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, roopa@cumulusnetworks.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20190730122534.30687-1-rdong.ge@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <1dc87e69-628b-fd04-619a-8dbe5bdfa108@cumulusnetworks.com>
Date:   Tue, 30 Jul 2019 15:41:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190730122534.30687-1-rdong.ge@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 30/07/2019 15:25, Rundong Ge wrote:
> Given following setup:
> -modprobe br_netfilter
> -echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
> -brctl addbr br0
> -brctl addif br0 enp2s0
> -brctl addif br0 enp3s0
> -brctl addif br0 enp6s0
> -ifconfig enp2s0 mtu 1300
> -ifconfig enp3s0 mtu 1500
> -ifconfig enp6s0 mtu 1500
> -ifconfig br0 up
> 
>                  multi-port
> mtu1500 - mtu1500|bridge|1500 - mtu1500
>   A                  |            B
>                    mtu1300
> 
> With netfilter defragmentation/conntrack enabled, fragmented
> packets from A will be defragmented in prerouting, and refragmented
> at postrouting.
> But in this scenario the bridge found the frag_max_size(1500) is
> larger than the dst mtu stored in the fake_rtable whitch is
> always equal to the bridge's mtu 1300, then packets will be dopped.
> 
> This modifies ip_skb_dst_mtu to use the out dev's mtu instead
> of bridge's mtu in bridge refragment.
> 
> Signed-off-by: Rundong Ge <rdong.ge@gmail.com>
> ---
>  include/net/ip.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/net/ip.h b/include/net/ip.h
> index 29d89de..0512de3 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -450,6 +450,8 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
>  static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
>  					  const struct sk_buff *skb)
>  {
> +	if ((skb_dst(skb)->flags & DST_FAKE_RTABLE) && skb->dev)
> +		return min(skb->dev->mtu, IP_MAX_MTU);
>  	if (!sk || !sk_fullsock(sk) || ip_sk_use_pmtu(sk)) {
>  		bool forwarding = IPCB(skb)->flags & IPSKB_FORWARDED;
>  
> 

I don't think this is correct, there's a reason why the bridge chooses the smallest
possible MTU out of its members and this is simply a hack to circumvent it.
If you really like to do so just set the bridge MTU manually, we've added support
so it won't change automatically to the smallest, but then how do you pass packets
1500 -> 1300 in this setup ?

You're talking about the frag_size check in br_nf_ip_fragment(), right ?

