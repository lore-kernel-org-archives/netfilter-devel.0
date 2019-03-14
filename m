Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F275EC4360F
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 14:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF74B2085A
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 14:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfCNOTK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:19:10 -0400
Received: from mail.us.es ([193.147.175.20]:48730 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbfCNOTK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 10:19:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 60420C51CC
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 15:19:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D347DA7FC
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 15:19:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4C58CDA7F4; Thu, 14 Mar 2019 15:19:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0156DA85E;
        Thu, 14 Mar 2019 15:19:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Mar 2019 15:19:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 99EB24265A4C;
        Thu, 14 Mar 2019 15:19:05 +0100 (CET)
Date:   Thu, 14 Mar 2019 15:19:05 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net] netfilter: bridge: set skb transport_header before
 entering NF_INET_PRE_ROUTING
Message-ID: <20190314141905.6xzrxwtlrs5k7nsp@salvia>
References: <35febf82503a4126b5ba28b02a0ca6e8f37a2765.1552466009.git.lucien.xin@gmail.com>
 <20190313113333.GB16434@hmswarspite.think-freely.org>
 <20190313115948.zhnov5ze6rdttm7k@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190313115948.zhnov5ze6rdttm7k@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 13, 2019 at 12:59:48PM +0100, Florian Westphal wrote:
> Neil Horman <nhorman@tuxdriver.com> wrote:
> > On Wed, Mar 13, 2019 at 04:33:29PM +0800, Xin Long wrote:
> > > Since Commit 21d1196a35f5 ("ipv4: set transport header earlier"),
> > > skb->transport_header has been always set before entering INET
> > > netfilter. This patch is to set skb->transport_header for bridge
> > > before entering INET netfilter by bridge-nf-call-iptables.
> > > 
> > > It also fixes an issue that sctp_error() couldn't compute a right
> > > csum due to unset skb->transport_header.
> > > 
> > > Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
> > > Reported-by: Li Shuang <shuali@redhat.com>
> > > Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/bridge/br_netfilter_hooks.c | 1 +
> > >  net/bridge/br_netfilter_ipv6.c  | 2 ++
> > >  2 files changed, 3 insertions(+)
> > > 
> > > diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> > > index c93c35b..4d09a33 100644
> > > --- a/net/bridge/br_netfilter_hooks.c
> > > +++ b/net/bridge/br_netfilter_hooks.c
> > > @@ -502,6 +502,7 @@ static unsigned int br_nf_pre_routing(void *priv,
> > >  	nf_bridge->ipv4_daddr = ip_hdr(skb)->daddr;
> > >  
> > >  	skb->protocol = htons(ETH_P_IP);
> > > +	skb->transport_header = skb->network_header + ip_hdr(skb)->ihl * 4;
> > >  
> > >  	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
> > >  		skb->dev, NULL,
> > > diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> > > index 564710f..e88d664 100644
> > > --- a/net/bridge/br_netfilter_ipv6.c
> > > +++ b/net/bridge/br_netfilter_ipv6.c
> > > @@ -235,6 +235,8 @@ unsigned int br_nf_pre_routing_ipv6(void *priv,
> > >  	nf_bridge->ipv6_daddr = ipv6_hdr(skb)->daddr;
> > >  
> > >  	skb->protocol = htons(ETH_P_IPV6);
> > > +	skb->transport_header = skb->network_header + sizeof(struct ipv6hdr);
> > > +
> > >  	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
> > >  		skb->dev, NULL,
> > >  		br_nf_pre_routing_finish_ipv6);
> > > -- 
> > > 2.1.0
> > > 
> > > 
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Acked-by: Florian Westphal <fw@strlen.de>
> 
> ... because this fixes discrepancy of normal stack vs. bridge path.
> 
> However, I think we still need a fix for the ipv6 case as
> there is no guarantee ipv6 nexthdr will be the sctp one.
> 
> We already pass the sctp offset as argument to sctp_compute_cksum(),
> why can't we just replace sctp_hdr(skb) with skb->data + dataoff, as
> Xin Long originally suggested?
> 
> IOW, whats the problem with
> https://marc.info/?l=linux-netdev&m=155109395226858&w=2 ?

That patch looks fine too.

> (In theory conntrack can also inspect transport header inside icmp error
>  messages like pkttoobig and so on,
>  although this won't be the case here as we can't validate csum anyway
>  if the packet isn't complete).
> 
> Just pointing out that we can't rely on skb transport header being
> "correct" in all cases from netfilter point of view.

Indeed.
