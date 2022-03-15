Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D67C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 21:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiCOVzQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 17:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbiCOVzP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 17:55:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A95F913EB0
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 14:54:02 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9C70463004;
        Tue, 15 Mar 2022 22:51:41 +0100 (CET)
Date:   Tue, 15 Mar 2022 22:53:57 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [RFC] conntrack event framework speedup
Message-ID: <YjEK9RsgJuONGyTI@salvia>
References: <20220315120538.GB16569@breakpoint.cc>
 <YjEFXmDfNN6k63+H@salvia>
 <20220315214121.GA9936@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220315214121.GA9936@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 15, 2022 at 10:41:21PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > add new net.netfilter.nf_conntrack_events default mode: 2, autodetect.
> > 
> > Probably the sysctl entry does not make any sense anymore if you can
> > autodetect when there is a listener?
> 
> Hmmm, did not consider that.  I *think* we still want to allow to
> disable the feature because of xt_CT/nft_ct.
> 
> Someone might have nf_conntrack_events=0 and tehy could be using
> explicit configuration via templates (and then expect that only
> those flows that matched a '-j CT' rule generate events.

Maybe could you bump the ctnetlink_listeners counter when -j CT is
used with event filtering?

> > > in nfnetlink bind, inc pernet counter when event group is bound.
> > > in nfnetlink unbind, dec pernet counter when event group is unbound.
> > 
> > So you keep one counter per netlink group in netns area?
> 
> Rough sketch (doesn't compile/apply):
> 
> +++ b/net/netfilter/nfnetlink.c
> @@ -45,6 +45,7 @@ MODULE_DESCRIPTION("Netfilter messages via netlink socket");
>  static unsigned int nfnetlink_pernet_id __read_mostly;
>   
>   struct nfnl_net {
>   +  unsigned int ctnetlink_listeners;
>      struct sock *nfnl;
> 
>  static int nfnetlink_bind(struct net *net, int group)
>  {
>         const struct nfnetlink_subsystem *ss;
> @@ -691,11 +691,47 @@ static int nfnetlink_bind(struct net *net, int group)
>         if (!ss)
>                 request_module_nowait("nfnetlink-subsys-%d", type);
> +
> +       if (type == NFNL_SUBSYS_CTNETLINK) {
> +               struct nfnl_net *nfnlnet = nfnl_pernet(net);
> +
> +               nfnl_lock(NFNL_SUBSYS_CTNETLINK);
> +               nfnlnet->ctnetlink_listeners++;
> +               if (nfnlnet->ctnetlink_listeners == 1)
> +                       net->ct.ctnetlink_has_listener = true;
> +               nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
> 
> and then check 'net->ct.ctnetlink_has_listener' when allocating
> a new conntrack.

LGTM.

> > > a prototype.
> > 
> > There is also setsockopt() to subscribe to netlink groups, you might
> > need to extend netlink_kernel_cfg to deal with this case too?
> 
> afaics the netlink_bind callback is invoked for subscriptions via setsockopt too,
> so that angle shouw be covered.

good.
