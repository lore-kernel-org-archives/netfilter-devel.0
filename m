Return-Path: <SRS0=kgPV=3D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DA9C33CB1
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 10:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 038B324672
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jan 2020 10:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgANKik (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jan 2020 05:38:40 -0500
Received: from correo.us.es ([193.147.175.20]:47114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgANKik (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 05:38:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BE52B172C76
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2020 11:38:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD27ADA78D
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2020 11:38:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A2C0ADA717; Tue, 14 Jan 2020 11:38:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B5C0DA716;
        Tue, 14 Jan 2020 11:38:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 14 Jan 2020 11:38:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7E4C542EF52A;
        Tue, 14 Jan 2020 11:38:36 +0100 (CET)
Date:   Tue, 14 Jan 2020 11:38:35 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 1/3] libnftables: add nft_ctx_set_netns()
Message-ID: <20200114103835.toksgmp6krbmh4ei@salvia>
References: <20200109172115.229723-1-pablo@netfilter.org>
 <20200109172115.229723-2-pablo@netfilter.org>
 <20200110125311.GP20229@orbyte.nwl.cc>
 <20200112102802.7bvwieqaza3zdbza@salvia>
 <20200112104027.ijjcv34glvnkhnvc@salvia>
 <20200114102516.GD20229@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114102516.GD20229@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 14, 2020 at 11:25:16AM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Sun, Jan 12, 2020 at 11:40:27AM +0100, Pablo Neira Ayuso wrote:
> > On Sun, Jan 12, 2020 at 11:28:02AM +0100, Pablo Neira Ayuso wrote:
> > > On Fri, Jan 10, 2020 at 01:53:11PM +0100, Phil Sutter wrote:
> > > > On Thu, Jan 09, 2020 at 06:21:13PM +0100, Pablo Neira Ayuso wrote:
> > > > [...]
> > > > > diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
> > > > > index 765b20dd71ee..887628959ac6 100644
> > > > > --- a/include/nftables/libnftables.h
> > > > > +++ b/include/nftables/libnftables.h
> > > > > @@ -34,10 +34,13 @@ enum nft_debug_level {
> > > > >   * Possible flags to pass to nft_ctx_new()
> > > > >   */
> > > > >  #define NFT_CTX_DEFAULT		0
> > > > > +#define NFT_CTX_NETNS		1
> > > > 
> > > > What is this needed for?
> > > 
> > > The socket is initialized from nft_ctx_init(), and such initialization
> > > needs to happen after the netns switch.
> > 
> > s/nft_ctx_init()/nft_ctx_new()
> 
> Ah, I missed that socket init in nft_ctx_new() happens only if flags is
> zero.
> 
> > > > >  struct nft_ctx *nft_ctx_new(uint32_t flags);
> > > > >  void nft_ctx_free(struct nft_ctx *ctx);
> > > > >  
> > > > > +int nft_ctx_set_netns(struct nft_ctx *ctx, const char *netns);
> > > > 
> > > > Is there a way to select init ns again?
> > > 
> > > AFAIK, setns() does not let you go back to init ns once set.
> 
> I noticed something I find worse, namely that libnftables as a library
> changes the application's netns. Anything it does after changing the
> context's netns applies to that netns only, no matter if it's creating a
> new nft context with NFT_CtX_DEFAULT flag or call iproute via system().
> 
> If we can't find a way to exit the netns again, one can safely assume
> that we are trapping a user's application in a netns with this feature.

IIRC, you can fork(), then let the child enter the netns while parent
remain in the original netns.

> Maybe we should restrict per-netns operation to nft utility and perform
> the netns switch there? Maybe we could provide a "switch_netns()"
> routine in libnftables which is not bound to nft context so users may
> use it in their application?

That's another possibility, yes. In that case, there is no need for
NFT_CTX_NETNS, which is just there to skip the socket initialization.
