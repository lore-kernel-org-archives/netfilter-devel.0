Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6EEC43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Jul 2022 08:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbiGLIkQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Jul 2022 04:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbiGLIkN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Jul 2022 04:40:13 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80FD3A5E4D;
        Tue, 12 Jul 2022 01:40:08 -0700 (PDT)
Date:   Tue, 12 Jul 2022 10:40:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] netfilter: xt_TPROXY: fix clang -Wformat warnings:
Message-ID: <Ys0zZACWwGilTwHx@salvia>
References: <20220707191745.840590-1-justinstitt@google.com>
 <YsvniilEnfUOd+yk@salvia>
 <CAFhGd8qDwoWLTJEGtap3s2_+AOLdnSg57DO8VgoMrqDtcFY7qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFhGd8qDwoWLTJEGtap3s2_+AOLdnSg57DO8VgoMrqDtcFY7qQ@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 11, 2022 at 12:44:05PM -0700, Justin Stitt wrote:
> On Mon, Jul 11, 2022 at 2:04 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Thu, Jul 07, 2022 at 12:17:45PM -0700, Justin Stitt wrote:
> > > diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
> > > index 459d0696c91a..5d74abffc94f 100644
> > > --- a/net/netfilter/xt_TPROXY.c
> > > +++ b/net/netfilter/xt_TPROXY.c
> > > @@ -169,7 +169,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
> > >                  targets on the same rule yet */
> > >               skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
> > >
> > > -             pr_debug("redirecting: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
> > > +             pr_debug("redirecting: proto %d %pI6:%hu -> %pI6:%hu, mark: %x\n",
> > >                        tproto, &iph->saddr, ntohs(hp->source),
> > >                        laddr, ntohs(lport), skb->mark);
> > >
> > > @@ -177,7 +177,7 @@ tproxy_tg6_v1(struct sk_buff *skb, const struct xt_action_param *par)
> > >               return NF_ACCEPT;
> > >       }
> > >
> > > -     pr_debug("no socket, dropping: proto %hhu %pI6:%hu -> %pI6:%hu, mark: %x\n",
> > > +     pr_debug("no socket, dropping: proto %d %pI6:%hu -> %pI6:%hu, mark: %x\n",
> > >                tproto, &iph->saddr, ntohs(hp->source),
> > >                &iph->daddr, ntohs(hp->dest), skb->mark);
> >
> > Could you instead send a patch to remove these pr_debug calls?
>
> Do you mean all Instances of pr_debug in `xt_TPROXY.c` (of which there
> are six) or just these two specific cases @ +169 and +177.

Yes, remove all pr_debug instances, thanks.
