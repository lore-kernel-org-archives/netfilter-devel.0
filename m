Return-Path: <SRS0=/pLU=RP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345D1C10F00
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 11:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 047F620883
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 11:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4VrlApu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbfCLLBR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 07:01:17 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34031 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfCLLBQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 07:01:16 -0400
Received: by mail-wr1-f67.google.com with SMTP id f14so2209984wrg.1;
        Tue, 12 Mar 2019 04:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qTlhrCT1sQy6dNry2H9q/HH4UWiJvbJVrdaTsmxUUec=;
        b=J4VrlApu1d3svEunM45Dn7uv17Bg6L2HobT4Tr9QKlfDrNYUvHWOljhuJKqiuJO+qO
         7ncZ3bvidyr8/eiMHJdeWt+9nRO2yZ/0rErDQPWVzmk2xkJnggdp/CzLBIhRPvAGMwKN
         bsiA14lbAH4MJwl95DNxzZ2KGg/q6K3pEJAjl9EVWpXGSkHiCsPAzShmfTjdil8hIXlm
         6C5KWOCI2mgavsm0npWmDVTZ4I1m0PIeJAE5UblT59Put9qmMlmQsbvQMQm3G8xr5g9Y
         Br48WJGlP6ktHgNpH3VLVAlt/Vej7mX8PCFuoVYtkmV+ropoWS/IL86Sa6lJfYdfC9Fg
         d6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qTlhrCT1sQy6dNry2H9q/HH4UWiJvbJVrdaTsmxUUec=;
        b=TZvYDEDrCFKd3rAvdDBRYK90dp/DngvAVVmAjBm3gg0K+dkTAsD+Ok8INZeYyRmmrl
         M2tmwhDhhoWb6vh/AMdP9mcBKeBlIO2P+c34ZvgYp1BeCs/9N5iCPGAgbmY2CDjkKiic
         M3pTfmb8qLL899E3e/Skp6IN/QDhF+EvLmxXtEldSpis5uDZU4CILQH9UrlVGLIULoKo
         FNjeBhOQ2EIFpPP4mhryGeY3r7TMlreVjteZSKHQVwlc5EZVpbyEnXCCXModM0/9OcBf
         mJHpkYrj6MvYR4ghwCbL2SgKFX0tgfAf9QjR8ApSd+FsejMnx4IsdM82ATYV7jIO2EYz
         92hQ==
X-Gm-Message-State: APjAAAX6Gsjr7Y3Nk7gnmT3V0854PuAYOJFiQ+HpkOS0TN1kVnWISJ9v
        CI6XksCh4JoVnvslgkhkxPFpGImmsIKBrptl55U=
X-Google-Smtp-Source: APXvYqzvXKsUi0hXIPzXARwlpIgdwwLlaJA7M8AZGRr3/zw6CwHzvZDwx+ZACycYP4JpnSEvzpR+d58vqvn/b9h/Lr8=
X-Received: by 2002:a5d:6288:: with SMTP id k8mr25076717wru.173.1552388474676;
 Tue, 12 Mar 2019 04:01:14 -0700 (PDT)
MIME-Version: 1.0
References: <740683890e28e93c1b2e940a28089ca10f006b7f.1551601041.git.lucien.xin@gmail.com>
 <20190308155049.by7f4uzjxqnf3xu7@salvia> <CADvbK_djd5ckv3nTROsmHNdr0Z5ULt7MF3MXtNYAO58mo+po7Q@mail.gmail.com>
 <20190309092434.oflik6j57yrhpkh5@breakpoint.cc> <20190311110752.GA30241@hmswarspite.think-freely.org>
 <CADvbK_dUUyECm57EPmqHyQnh-mkVNz5u-0MCrhtpo80PCr51fA@mail.gmail.com> <20190312094846.r2pgi3pevvmdv33l@salvia>
In-Reply-To: <20190312094846.r2pgi3pevvmdv33l@salvia>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 12 Mar 2019 19:01:03 +0800
Message-ID: <CADvbK_fwjDmnsHyA1=nTFE0h0z6XVjBXFq1BrVFQOgRLY6FL1A@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: set skb transport_header before calling sctp_compute_cksum
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Florian Westphal <fw@strlen.de>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 12, 2019 at 5:49 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Mar 12, 2019 at 04:39:46PM +0800, Xin Long wrote:
> > On Mon, Mar 11, 2019 at 7:08 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > >
> > > On Sat, Mar 09, 2019 at 10:24:34AM +0100, Florian Westphal wrote:
> > > > Xin Long <lucien.xin@gmail.com> wrote:
> > > > >   https://marc.info/?l=linux-netdev&m=155109395226858&w=2
> > > > > But from sctp side, Neil preferred sctp_hdr().
> > > > >
> > > > > We need to either add skb_set_transport_header() in sctp_s/dnat_handler()
> > > > > and sctp_manip_pkt(), or bring that patch back?
> > > > >
> > > > > Now it seems not good to set skb->transport_header in netfilter code.
> > > >
> > > > I think its fine, but I wonder why we need to do it.
> > > >
> > > > Since 21d1196a35f5686c4323e42a62fdb4b23b0ab4a3 ipv4 input path sets
> > > > transport header before netfilter.  The only problem is that linear
> > > > access is illegal without may_pull checks, but in this case the
> > > > make_writable call takes care of this already.
> > > >
> > > Yes, this.  It seems to me we should be setting the transport header prior to
> > > ever getting into the netfilter code, which does imply that we need the may_pull
> > > check to linearize enough of the packet to do so, just like tcp and udp do.
> > >
> > > > So, why was this patch needed?
> >
> > The issue was reported when going to nf_conntrack by br_netfilter's
> > bridge-nf-call-iptables, which could be:
> >
> > br_prerouting->inet_prerouting->
> > br_forward->inet_forward->
> > br_postrouting->inet_postrouting
>
> Can you fix this from br_netfilter then? ie. set the transport header
> before prerouting to emulate the IP stack behaviour.
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 9d34de6..22afa56 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -502,6 +502,7 @@ static unsigned int br_nf_pre_routing(void *priv,
  nf_bridge->ipv4_daddr = ip_hdr(skb)->daddr;

  skb->protocol = htons(ETH_P_IP);
+ skb->transport_header = skb->network_header + ip_hdr(skb)->ihl * 4;

  NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
  skb->dev, NULL,
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 564710f..e88d664 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -235,6 +235,8 @@ unsigned int br_nf_pre_routing_ipv6(void *priv,
  nf_bridge->ipv6_daddr = ipv6_hdr(skb)->daddr;

  skb->protocol = htons(ETH_P_IPV6);
+ skb->transport_header = skb->network_header + sizeof(struct ipv6hdr);
+
  NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
  skb->dev, NULL,
  br_nf_pre_routing_finish_ipv6);

Looks more reasonable, it's also safe after br_validate_ipv4/6(). Thanks.
