Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA42AC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Apr 2022 09:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbiDMJHq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Apr 2022 05:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiDMJHq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Apr 2022 05:07:46 -0400
Received: from mail.strongswan.org (sitav-80046.hsr.ch [152.96.80.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DE129CAA;
        Wed, 13 Apr 2022 02:05:24 -0700 (PDT)
Received: from think.home (67.36.7.85.dynamic.wline.res.cust.swisscom.ch [85.7.36.67])
        by mail.strongswan.org (Postfix) with ESMTPSA id CB9ED40260;
        Wed, 13 Apr 2022 11:05:22 +0200 (CEST)
Message-ID: <5572c06750a388056001d1b460d5e67c18fa2836.camel@strongswan.org>
Subject: Re: [PATCH nf] netfilter: Update ip6_route_me_harder to consider L3
 domain
From:   Martin Willi <martin@strongswan.org>
To:     David Ahern <dsahern@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Date:   Wed, 13 Apr 2022 11:05:22 +0200
In-Reply-To: <a64e1342-c953-40c5-2afb-0e9654e7d002@kernel.org>
References: <20220412074639.1963131-1-martin@strongswan.org>
         <a64e1342-c953-40c5-2afb-0e9654e7d002@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi David,

> > @@ -39,6 +38,13 @@ int ip6_route_me_harder(struct net *net, struct
> > sock *sk_partial, struct sk_buff
> >  	};
> >  	int err;
> >  
> > +	if (sk && sk->sk_bound_dev_if)
> > +		fl6.flowi6_oif = sk->sk_bound_dev_if;
> > +	else if (strict)
> > +		fl6.flowi6_oif = dev->ifindex;
> > +	else
> > +		fl6.flowi6_oif = l3mdev_master_ifindex(dev);
> 
> For top of tree, this is now fl6.flowi6_l3mdev

Ah, I see, missed that.

Given that IPv4 should be converted to flowi4_l3mdev as well (?), what
about:

 * Keep the IPv6 patch in this form, as this allows stable to pick it
   up as-is
 * I'll add a follow-up patch, which converts both to flowi[46]_l3mdev

This would avoid some noise for a separate stable patch, but let me
know what you prefer.

>  and dev is only needed here so make this:
> 	fl6.flowi6_l3mdev = l3mdev_master_ifindex(skb_dst(skb)->dev);

Actually it is used in that "strict" branch, this is why I've added
"dev" as a local variable. I guess that is still needed
with flowi6_l3mdev?

Thanks,
Martin

