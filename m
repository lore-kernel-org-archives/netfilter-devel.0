Return-Path: <SRS0=WWTr=RS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0085C43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Mar 2019 13:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80D5520854
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Mar 2019 13:40:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ku8FF7Q1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbfCONj7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 09:39:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38608 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727705AbfCONj7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 09:39:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id a188so6068421wmf.3;
        Fri, 15 Mar 2019 06:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bZG5sN9Wzgm0NBfQjEyerUqfKlfyCZPLlscpPFnFxFI=;
        b=ku8FF7Q1P5JAIESPan5r5IkyKiQCNuGO08ba0FUCTOO1W4xub02r+kcz0Ef3ikkfcY
         PMaZ80X/ciI5LxdHqDYxDAgsUvrYN+rs3+69Pnvrv2MOpaZEC0UcnltY/8dwCK+6aHWg
         5WAwIblejjThhR6EKN83n4XLLV9XO3oYGC2NnCcynnNs77FQ3QXur6j5M5ZlkwFkCtYh
         rbQLPsi5mw5wXvZhng4ektxkqsDcw62h6nWYUKWF3RMzIZ7B6RsvGxfBJ7m28yyrcO8Z
         vB6P+HVU0A46AmNygJdiNhGyjiy7sLnZY2umyP/V60OHIkTQn7qPp7/9XPjhO4X6KQqm
         PZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bZG5sN9Wzgm0NBfQjEyerUqfKlfyCZPLlscpPFnFxFI=;
        b=XuLTkGOFeqyQD8swoCbdTrsajUOwm9KqZAneGLyWzkopykV38E3NTOALet8TAUy0C/
         8Ai9zLwGgWIRxjpRxq6mdw2lQ8dM8gS8i73MKoEUNd7cPFF8fpIFi4XMXUwXsSaPgdSc
         SxtTJsZMgrLjfJiRxoHf7kIyLJEYd+piZ+L82XkiyKyAD+QqyCzNnlkLoure3ImiyebY
         raSkDR+pC1cC4dsumcSOf1sA5OymLYMX3rW6R/28kWuy18nGWA1fDWaqxqyEn41TzSnD
         2ZRKzjcw8UPdho7ckaqcNmFMzdxIHmL3K+K8uQDw0J30uJPs/lsFEtCVVpRh9jdSOv5y
         q7Kw==
X-Gm-Message-State: APjAAAX8S6eAVApI1HTWGosnpncnxR8wUHPCXTHWQq3ecp71JuV1jAWF
        wwu/4QOFgOb2VVpQHYyhepwGTsJWl1ppIuPjQg0=
X-Google-Smtp-Source: APXvYqyYKNpe3cx4I0ylB13mlXtMT6NSW1CdwooE6TCrPNDmwv7Uxh+q4i89s2p5i+psTo4/5d4g0FwQL0LwWwc6eW0=
X-Received: by 2002:a1c:4d:: with SMTP id 74mr2098036wma.129.1552657196834;
 Fri, 15 Mar 2019 06:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <35febf82503a4126b5ba28b02a0ca6e8f37a2765.1552466009.git.lucien.xin@gmail.com>
 <20190313113333.GB16434@hmswarspite.think-freely.org> <20190313115948.zhnov5ze6rdttm7k@breakpoint.cc>
 <20190314141905.6xzrxwtlrs5k7nsp@salvia> <CADvbK_dqH7PyG6M=aHEEGPyEnw1ZLXSstsrxN11yjDpZYzEVzg@mail.gmail.com>
 <20190315110942.GA16380@hmswarspite.think-freely.org>
In-Reply-To: <20190315110942.GA16380@hmswarspite.think-freely.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 15 Mar 2019 21:39:45 +0800
Message-ID: <CADvbK_fvd6qVU6UsUfrmOrsK2VZiknFQyeWEC5MfrOkDpguPLg@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: bridge: set skb transport_header before
 entering NF_INET_PRE_ROUTING
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 15, 2019 at 7:10 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Thu, Mar 14, 2019 at 10:41:41PM +0800, Xin Long wrote:
> > On Thu, Mar 14, 2019 at 10:19 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > On Wed, Mar 13, 2019 at 12:59:48PM +0100, Florian Westphal wrote:
> > > > Neil Horman <nhorman@tuxdriver.com> wrote:
> > > > > On Wed, Mar 13, 2019 at 04:33:29PM +0800, Xin Long wrote:
> > > > > > Since Commit 21d1196a35f5 ("ipv4: set transport header earlier"),
> > > > > > skb->transport_header has been always set before entering INET
> > > > > > netfilter. This patch is to set skb->transport_header for bridge
> > > > > > before entering INET netfilter by bridge-nf-call-iptables.
> > > > > >
> > > > > > It also fixes an issue that sctp_error() couldn't compute a right
> > > > > > csum due to unset skb->transport_header.
> > > > > >
> > > > > > Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
> > > > > > Reported-by: Li Shuang <shuali@redhat.com>
> > > > > > Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > > ---
> > > > > >  net/bridge/br_netfilter_hooks.c | 1 +
> > > > > >  net/bridge/br_netfilter_ipv6.c  | 2 ++
> > > > > >  2 files changed, 3 insertions(+)
> > > > > >
> > > > > > diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> > > > > > index c93c35b..4d09a33 100644
> > > > > > --- a/net/bridge/br_netfilter_hooks.c
> > > > > > +++ b/net/bridge/br_netfilter_hooks.c
> > > > > > @@ -502,6 +502,7 @@ static unsigned int br_nf_pre_routing(void *priv,
> > > > > >   nf_bridge->ipv4_daddr = ip_hdr(skb)->daddr;
> > > > > >
> > > > > >   skb->protocol = htons(ETH_P_IP);
> > > > > > + skb->transport_header = skb->network_header + ip_hdr(skb)->ihl * 4;
> > > > > >
> > > > > >   NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
> > > > > >           skb->dev, NULL,
> > > > > > diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> > > > > > index 564710f..e88d664 100644
> > > > > > --- a/net/bridge/br_netfilter_ipv6.c
> > > > > > +++ b/net/bridge/br_netfilter_ipv6.c
> > > > > > @@ -235,6 +235,8 @@ unsigned int br_nf_pre_routing_ipv6(void *priv,
> > > > > >   nf_bridge->ipv6_daddr = ipv6_hdr(skb)->daddr;
> > > > > >
> > > > > >   skb->protocol = htons(ETH_P_IPV6);
> > > > > > + skb->transport_header = skb->network_header + sizeof(struct ipv6hdr);
> > > > > > +
> > > > > >   NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
> > > > > >           skb->dev, NULL,
> > > > > >           br_nf_pre_routing_finish_ipv6);
> > > > > > --
> > > > > > 2.1.0
> > > > > >
> > > > > >
> > > > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > > >
> > > > Acked-by: Florian Westphal <fw@strlen.de>
> > > >
> > > > ... because this fixes discrepancy of normal stack vs. bridge path.
> > > >
> > > > However, I think we still need a fix for the ipv6 case as
> > > > there is no guarantee ipv6 nexthdr will be the sctp one.
> > > >
> > > > We already pass the sctp offset as argument to sctp_compute_cksum(),
> > > > why can't we just replace sctp_hdr(skb) with skb->data + dataoff, as
> > > > Xin Long originally suggested?
> > > >
> > > > IOW, whats the problem with
> > > > https://marc.info/?l=linux-netdev&m=155109395226858&w=2 ?
> > >
> > > That patch looks fine too.
> > >
> > > > (In theory conntrack can also inspect transport header inside icmp error
> > > >  messages like pkttoobig and so on,
> > > >  although this won't be the case here as we can't validate csum anyway
> > > >  if the packet isn't complete).
> > > >
> > > > Just pointing out that we can't rely on skb transport header being
> > > > "correct" in all cases from netfilter point of view.
> > >
> > > Indeed.
> > Hi Neil,
> >
> > It seems we should bring that patch back, otherwize we will have to add
> > a special sctp csum computing function for Netfilter?
> >
> Fine.
I will repost that patch, thanks!
