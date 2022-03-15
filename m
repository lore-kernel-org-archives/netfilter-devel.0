Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47EA4C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 21:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238058AbiCOVmh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 17:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238089AbiCOVmh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 17:42:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F00A580C7
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 14:41:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nUEuv-0003Ni-Fm; Tue, 15 Mar 2022 22:41:21 +0100
Date:   Tue, 15 Mar 2022 22:41:21 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [RFC] conntrack event framework speedup
Message-ID: <20220315214121.GA9936@breakpoint.cc>
References: <20220315120538.GB16569@breakpoint.cc>
 <YjEFXmDfNN6k63+H@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjEFXmDfNN6k63+H@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > add new net.netfilter.nf_conntrack_events default mode: 2, autodetect.
> 
> Probably the sysctl entry does not make any sense anymore if you can
> autodetect when there is a listener?

Hmmm, did not consider that.  I *think* we still want to allow to
disable the feature because of xt_CT/nft_ct.

Someone might have nf_conntrack_events=0 and tehy could be using
explicit configuration via templates (and then expect that only
those flows that matched a '-j CT' rule generate events.

> > in nfnetlink bind, inc pernet counter when event group is bound.
> > in nfnetlink unbind, dec pernet counter when event group is unbound.
> 
> So you keep one counter per netlink group in netns area?

Rough sketch (doesn't compile/apply):

+++ b/net/netfilter/nfnetlink.c
@@ -45,6 +45,7 @@ MODULE_DESCRIPTION("Netfilter messages via netlink socket");
 static unsigned int nfnetlink_pernet_id __read_mostly;
  
  struct nfnl_net {
  +  unsigned int ctnetlink_listeners;
     struct sock *nfnl;

 static int nfnetlink_bind(struct net *net, int group)
 {
        const struct nfnetlink_subsystem *ss;
@@ -691,11 +691,47 @@ static int nfnetlink_bind(struct net *net, int group)
        if (!ss)
                request_module_nowait("nfnetlink-subsys-%d", type);
+
+       if (type == NFNL_SUBSYS_CTNETLINK) {
+               struct nfnl_net *nfnlnet = nfnl_pernet(net);
+
+               nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+               nfnlnet->ctnetlink_listeners++;
+               if (nfnlnet->ctnetlink_listeners == 1)
+                       net->ct.ctnetlink_has_listener = true;
+               nfnl_unlock(NFNL_SUBSYS_CTNETLINK);

and then check 'net->ct.ctnetlink_has_listener' when allocating
a new conntrack.

> > a prototype.
> 
> There is also setsockopt() to subscribe to netlink groups, you might
> need to extend netlink_kernel_cfg to deal with this case too?

afaics the netlink_bind callback is invoked for subscriptions via setsockopt too,
so that angle shouw be covered.
