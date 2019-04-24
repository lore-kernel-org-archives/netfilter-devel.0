Return-Path: <SRS0=Os8a=S2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F7BC10F11
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 08:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A02BB218D3
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 08:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfDXICc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Apr 2019 04:02:32 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33560 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726031AbfDXICb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Apr 2019 04:02:31 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hJCr8-0007Ga-1T; Wed, 24 Apr 2019 10:02:14 +0200
Date:   Wed, 24 Apr 2019 10:02:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     pablo@netfilter.org, kadlec@blackhole.kfki.hu, dsahern@gmail.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingfangsen <mingfangsen@huawei.com>
Subject: Re: [PATCH] net: netfilter: Fix ipv6 rp_filter dropping vrf packets
 by mistake
Message-ID: <20190424080214.vadrfiufcv6xa3cm@breakpoint.cc>
References: <094b7376-f796-71b6-7a81-28866b0f882b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <094b7376-f796-71b6-7a81-28866b0f882b@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> wrote:

[ CC dsa, dropped some CCs ]

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
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  net/ipv6/netfilter/ip6t_rpfilter.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
> index c3c6b09acdc4..5cbc91f53736 100644
> --- a/net/ipv6/netfilter/ip6t_rpfilter.c
> +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
> @@ -73,6 +73,12 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
>  		goto out;
>  	}
> 
> +	if (netif_is_l3_master(dev)) {
> +		dev = __dev_get_by_index(dev_net(dev), IP6CB(skb)->iif);
> +		if (!dev)
> +			goto out;

I suspect this should be 'dev_get_by_index_rcu'.
