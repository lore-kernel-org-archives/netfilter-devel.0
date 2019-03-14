Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966B8C10F06
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 14:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 645B62184C
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 14:41:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y3l+Rsmu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfCNOlz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:41:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37044 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfCNOlz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 10:41:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id y15so6157528wro.4;
        Thu, 14 Mar 2019 07:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QFKZSWh+YJ1d4AHHnV/0TiCHs3qsJlEycg4dKAhuYyI=;
        b=Y3l+RsmuWzo5Sl4xJ30eW9UvnpK2NW36GK28MlMDVxBKZZ0BM3ohnEJrg3XFe5Fi2f
         IzIpwuuJ7OIEgLKjCMAz2T1kIPuw+NoSkI1UOOTtpz5NHcHXVFIJqfysXpHgKdqyJa4F
         a1H1zzRFmZ/QgZoRMn022lSSxwERMxzDgzrEE6IUTiXkTRmVYtKdUhnfns+Jiuqqsgpa
         QU/TIoep/UCj/LMB2YHIJffSuMP+mWg+nyUk0O9U9Ewuon4gPzu+g1Dms4QjI+ryZRYk
         KYi9sQGu3Xyvf2BcSjVvNVH3exMZUVVZ4Tu9qZAdGmAX7Ljwog9fsElV4mZhPx/iLbDd
         TBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QFKZSWh+YJ1d4AHHnV/0TiCHs3qsJlEycg4dKAhuYyI=;
        b=Eh+osDy21sOK7himkEYGgvsEnBW4YIdtg6zR3z/YmXWTuWlVWgS2MfjMQm4mIs6Z7Y
         OFVudw1IpXWQ2sbzhFBws6CqEHHl7j8tDRuVqdCGA2M3dISULOWWSirpNToVIGjgMghL
         bZqaivZ8KYPKrjuCKV26pAoLobejWKx9FVbwNe24IY9n7ZemUxhbBIJ4QsZBEzW2fqdd
         Jwe8x53d/TAPiCdT08OhatZnnIF1f6OJBLlwFAs9Z+zkQ2iv+VMp4F7aCwe+iHmT/Ytm
         UO2q8/ybKPJvN652QzrLEwqObnItZqXWNZtuebymnVjc58LNoAQ9ilN7ksS7bRAjJ5+h
         PMSg==
X-Gm-Message-State: APjAAAWO6aQ/NM2ViAePBIkYJmXez6i7hW+nFHftn91/jbD2Ka20E+Fc
        1B/NLEDgUDpex/Hxn8dUEbzfWQeTDHbb+DW7L1eOyd/KtpU=
X-Google-Smtp-Source: APXvYqwQY/EpoLKJd0n72cVfZQfa0Rv8pbmGl0Ui1R6GhJaB9wD7lcXCA9zRxAXWacT06ksuYfSzZb3nSXm2Zr5R0x8=
X-Received: by 2002:adf:b3d1:: with SMTP id x17mr32166963wrd.15.1552574513147;
 Thu, 14 Mar 2019 07:41:53 -0700 (PDT)
MIME-Version: 1.0
References: <35febf82503a4126b5ba28b02a0ca6e8f37a2765.1552466009.git.lucien.xin@gmail.com>
 <20190313113333.GB16434@hmswarspite.think-freely.org> <20190313115948.zhnov5ze6rdttm7k@breakpoint.cc>
 <20190314141905.6xzrxwtlrs5k7nsp@salvia>
In-Reply-To: <20190314141905.6xzrxwtlrs5k7nsp@salvia>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 14 Mar 2019 22:41:41 +0800
Message-ID: <CADvbK_dqH7PyG6M=aHEEGPyEnw1ZLXSstsrxN11yjDpZYzEVzg@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: bridge: set skb transport_header before
 entering NF_INET_PRE_ROUTING
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Neil Horman <nhorman@tuxdriver.com>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 14, 2019 at 10:19 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Mar 13, 2019 at 12:59:48PM +0100, Florian Westphal wrote:
> > Neil Horman <nhorman@tuxdriver.com> wrote:
> > > On Wed, Mar 13, 2019 at 04:33:29PM +0800, Xin Long wrote:
> > > > Since Commit 21d1196a35f5 ("ipv4: set transport header earlier"),
> > > > skb->transport_header has been always set before entering INET
> > > > netfilter. This patch is to set skb->transport_header for bridge
> > > > before entering INET netfilter by bridge-nf-call-iptables.
> > > >
> > > > It also fixes an issue that sctp_error() couldn't compute a right
> > > > csum due to unset skb->transport_header.
> > > >
> > > > Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
> > > > Reported-by: Li Shuang <shuali@redhat.com>
> > > > Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > ---
> > > >  net/bridge/br_netfilter_hooks.c | 1 +
> > > >  net/bridge/br_netfilter_ipv6.c  | 2 ++
> > > >  2 files changed, 3 insertions(+)
> > > >
> > > > diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> > > > index c93c35b..4d09a33 100644
> > > > --- a/net/bridge/br_netfilter_hooks.c
> > > > +++ b/net/bridge/br_netfilter_hooks.c
> > > > @@ -502,6 +502,7 @@ static unsigned int br_nf_pre_routing(void *priv,
> > > >   nf_bridge->ipv4_daddr = ip_hdr(skb)->daddr;
> > > >
> > > >   skb->protocol = htons(ETH_P_IP);
> > > > + skb->transport_header = skb->network_header + ip_hdr(skb)->ihl * 4;
> > > >
> > > >   NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
> > > >           skb->dev, NULL,
> > > > diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> > > > index 564710f..e88d664 100644
> > > > --- a/net/bridge/br_netfilter_ipv6.c
> > > > +++ b/net/bridge/br_netfilter_ipv6.c
> > > > @@ -235,6 +235,8 @@ unsigned int br_nf_pre_routing_ipv6(void *priv,
> > > >   nf_bridge->ipv6_daddr = ipv6_hdr(skb)->daddr;
> > > >
> > > >   skb->protocol = htons(ETH_P_IPV6);
> > > > + skb->transport_header = skb->network_header + sizeof(struct ipv6hdr);
> > > > +
> > > >   NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
> > > >           skb->dev, NULL,
> > > >           br_nf_pre_routing_finish_ipv6);
> > > > --
> > > > 2.1.0
> > > >
> > > >
> > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> >
> > Acked-by: Florian Westphal <fw@strlen.de>
> >
> > ... because this fixes discrepancy of normal stack vs. bridge path.
> >
> > However, I think we still need a fix for the ipv6 case as
> > there is no guarantee ipv6 nexthdr will be the sctp one.
> >
> > We already pass the sctp offset as argument to sctp_compute_cksum(),
> > why can't we just replace sctp_hdr(skb) with skb->data + dataoff, as
> > Xin Long originally suggested?
> >
> > IOW, whats the problem with
> > https://marc.info/?l=linux-netdev&m=155109395226858&w=2 ?
>
> That patch looks fine too.
>
> > (In theory conntrack can also inspect transport header inside icmp error
> >  messages like pkttoobig and so on,
> >  although this won't be the case here as we can't validate csum anyway
> >  if the packet isn't complete).
> >
> > Just pointing out that we can't rely on skb transport header being
> > "correct" in all cases from netfilter point of view.
>
> Indeed.
Hi Neil,

It seems we should bring that patch back, otherwize we will have to add
a special sctp csum computing function for Netfilter?
