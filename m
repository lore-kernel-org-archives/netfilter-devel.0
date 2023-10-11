Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865C7CD6E77
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 15:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjJKPGA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 11:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbjJKPF7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 11:05:59 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF878B0
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 08:05:56 -0700 (PDT)
Received: from [78.30.34.192] (port=53238 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qqamX-00CccJ-8x; Wed, 11 Oct 2023 17:05:55 +0200
Date:   Wed, 11 Oct 2023 17:05:52 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack] conntrack: label update requires a previous
 label in place
Message-ID: <ZSa50Cb3QtTbYFGb@calendula>
References: <20231011095503.131168-1-pablo@netfilter.org>
 <ZSZ39VSJWfPjeizQ@calendula>
 <20231011111029.GE1407@breakpoint.cc>
 <ZSakk9nuZZXAb+qE@calendula>
 <20231011140007.GF1407@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231011140007.GF1407@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 11, 2023 at 04:00:07PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Rationale was that if you have no rules that check on labels then
> > > there is never a need to allocate the space.
> > > 
> > > I'm working on a patchset that will also set/enable the label
> > > extension if its enabled on the template. The idea is to convert
> > > ovs and act_ct to it, currently they point-blank increment
> > > net->ct.labels_used which means that all conntrack objects get the
> > > label area allocated.
> > > 
> > > But thats not what the counter was (originally) meant to convey, it
> > > was really 'number of connlabel rules'.
> > 
> > > As soon as act_ct or ovs modules are loaded, then all the namespaces
> > > see 'I need conntrack labels', which completely voids all attempts to
> > > avoid ct->ext allocation.
> > 
> > OK, so instead a of per-netns sysctl toggle, you propose to use the
> > conntrack template to selectively enable this.
> 
> I think for iptables/nftables current approach is fine.
> 
> Otherwise someone has to explain to me what the use case is for
> setting connlabels from netlink but no rules in place that make
> any decision based on that.

Agreed.

I don't need this myself. I just found this bugzilla ticket while
reviewing recent reports. I think my patch for conntrack command line
is fine by now (documentation plus deal with corner case that triggers
ENOSPC from update path).

So yes, agreed, if anyone has a use case for no rules while having
connlabel, they should come here and explain.

