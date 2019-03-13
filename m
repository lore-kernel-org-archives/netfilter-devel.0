Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC19C10F03
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 11:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97A7E2171F
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 11:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfCML7u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 07:59:50 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54838 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725836AbfCML7u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 07:59:50 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h42Y0-0003Or-0x; Wed, 13 Mar 2019 12:59:48 +0100
Date:   Wed, 13 Mar 2019 12:59:48 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        pablo@netfilter.org, fw@strlen.de
Subject: Re: [PATCH net] netfilter: bridge: set skb transport_header before
 entering NF_INET_PRE_ROUTING
Message-ID: <20190313115948.zhnov5ze6rdttm7k@breakpoint.cc>
References: <35febf82503a4126b5ba28b02a0ca6e8f37a2765.1552466009.git.lucien.xin@gmail.com>
 <20190313113333.GB16434@hmswarspite.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190313113333.GB16434@hmswarspite.think-freely.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> wrote:
> On Wed, Mar 13, 2019 at 04:33:29PM +0800, Xin Long wrote:
> > Since Commit 21d1196a35f5 ("ipv4: set transport header earlier"),
> > skb->transport_header has been always set before entering INET
> > netfilter. This patch is to set skb->transport_header for bridge
> > before entering INET netfilter by bridge-nf-call-iptables.
> > 
> > It also fixes an issue that sctp_error() couldn't compute a right
> > csum due to unset skb->transport_header.
> > 
> > Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
> > Reported-by: Li Shuang <shuali@redhat.com>
> > Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/bridge/br_netfilter_hooks.c | 1 +
> >  net/bridge/br_netfilter_ipv6.c  | 2 ++
> >  2 files changed, 3 insertions(+)
> > 
> > diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> > index c93c35b..4d09a33 100644
> > --- a/net/bridge/br_netfilter_hooks.c
> > +++ b/net/bridge/br_netfilter_hooks.c
> > @@ -502,6 +502,7 @@ static unsigned int br_nf_pre_routing(void *priv,
> >  	nf_bridge->ipv4_daddr = ip_hdr(skb)->daddr;
> >  
> >  	skb->protocol = htons(ETH_P_IP);
> > +	skb->transport_header = skb->network_header + ip_hdr(skb)->ihl * 4;
> >  
> >  	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
> >  		skb->dev, NULL,
> > diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> > index 564710f..e88d664 100644
> > --- a/net/bridge/br_netfilter_ipv6.c
> > +++ b/net/bridge/br_netfilter_ipv6.c
> > @@ -235,6 +235,8 @@ unsigned int br_nf_pre_routing_ipv6(void *priv,
> >  	nf_bridge->ipv6_daddr = ipv6_hdr(skb)->daddr;
> >  
> >  	skb->protocol = htons(ETH_P_IPV6);
> > +	skb->transport_header = skb->network_header + sizeof(struct ipv6hdr);
> > +
> >  	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
> >  		skb->dev, NULL,
> >  		br_nf_pre_routing_finish_ipv6);
> > -- 
> > 2.1.0
> > 
> > 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Acked-by: Florian Westphal <fw@strlen.de>

... because this fixes discrepancy of normal stack vs. bridge path.

However, I think we still need a fix for the ipv6 case as
there is no guarantee ipv6 nexthdr will be the sctp one.

We already pass the sctp offset as argument to sctp_compute_cksum(),
why can't we just replace sctp_hdr(skb) with skb->data + dataoff, as
Xin Long originally suggested?

IOW, whats the problem with
https://marc.info/?l=linux-netdev&m=155109395226858&w=2 ?

(In theory conntrack can also inspect transport header inside icmp error
 messages like pkttoobig and so on,
 although this won't be the case here as we can't validate csum anyway
 if the packet isn't complete).

Just pointing out that we can't rely on skb transport header being
"correct" in all cases from netfilter point of view.
