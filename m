Return-Path: <SRS0=dCSv=65=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B90C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 May 2020 18:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2767D20657
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 May 2020 18:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgEOSM5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 May 2020 14:12:57 -0400
Received: from ja.ssi.bg ([178.16.129.10]:54538 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726191AbgEOSM4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 May 2020 14:12:56 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 May 2020 14:12:55 EDT
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 04FI79uk004885;
        Fri, 15 May 2020 21:07:09 +0300
Date:   Fri, 15 May 2020 21:07:09 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Andrew Sy Kim <kim.andrewsy@gmail.com>
cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:IPVS" <netdev@vger.kernel.org>,
        "open list:IPVS" <lvs-devel@vger.kernel.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter/ipvs: expire no destination UDP connections
 when expire_nodest_conn=1
In-Reply-To: <20200515013556.5582-1-kim.andrewsy@gmail.com>
Message-ID: <alpine.LFD.2.21.2005152044380.3860@ja.home.ssi.bg>
References: <20200515013556.5582-1-kim.andrewsy@gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Thu, 14 May 2020, Andrew Sy Kim wrote:

> When expire_nodest_conn=1 and an IPVS destination is deleted, IPVS
> doesn't expire connections with the IP_VS_CONN_F_ONE_PACKET flag set (any
> UDP connection). If there are many UDP packets to a virtual server from a
> single client and a destination is deleted, many packets are silently
> dropped whenever an existing connection entry with the same source port
> exists. This patch ensures IPVS also expires UDP connections when a
> packet matches an existing connection with no destinations.
> 
> Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
> ---
>  net/netfilter/ipvs/ip_vs_core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index aa6a603a2425..f0535586fe75 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -2116,8 +2116,7 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
>  		else
>  			ip_vs_conn_put(cp);

	Above ip_vs_conn_put() should free the ONE_PACKET
connections because:

- such connections never start timer, they are designed
to exist just to schedule the packet, then they are released.
- noone takes extra references

	So, ip_vs_conn_put() simply calls ip_vs_conn_expire()
where connections should be released immediately. As result,
we can not access cp after this point here. That is why we work
just with 'flags' below...

	Note that not every UDP connection has ONE_PACKET
flag, it is present if you configure it for the service.
Do you have -o/--ops flag? If not, the UDP connection
should expire before the next jiffie. This is the theory,
in practice, you may observe some problem...

> -		if (sysctl_expire_nodest_conn(ipvs) &&
> -		    !(flags & IP_VS_CONN_F_ONE_PACKET)) {
> +		if (sysctl_expire_nodest_conn(ipvs)) {
>  			/* try to expire the connection immediately */
>  			ip_vs_conn_expire_now(cp);
>  		}

	You can also look at the discussion which resulted in
the last patch for this place:

http://archive.linuxvirtualserver.org/html/lvs-devel/2018-07/msg00014.html

Regards

--
Julian Anastasov <ja@ssi.bg>
