Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C94A4C7618B
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 15:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A29152239F
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 15:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388497AbfGWPGs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 11:06:48 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48646 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731767AbfGWPGs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 11:06:48 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hpwNI-0001Ba-EF; Tue, 23 Jul 2019 17:06:44 +0200
Date:   Tue, 23 Jul 2019 17:06:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fwestpha@redhat.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 1/2] net: nf_tables: Make nft_meta expression more
 robust
Message-ID: <20190723150644.GO22661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fwestpha@redhat.com>,
        netfilter-devel@vger.kernel.org
References: <20190719123921.1249-1-phil@nwl.cc>
 <20190719163521.oozthobj33ejswrx@salvia>
 <20190720151502.GD32501@orbyte.nwl.cc>
 <20190722195321.uf2r5lp46bvslvtd@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722195321.uf2r5lp46bvslvtd@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Jul 22, 2019 at 09:53:21PM +0200, Pablo Neira Ayuso wrote:
> On Sat, Jul 20, 2019 at 05:15:02PM +0200, Phil Sutter wrote:
> > Hi,
> > 
> > On Fri, Jul 19, 2019 at 06:35:21PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Jul 19, 2019 at 02:39:20PM +0200, Phil Sutter wrote:
> > > > nft_meta_get_eval()'s tendency to bail out setting NFT_BREAK verdict in
> > > > situations where required data is missing breaks inverted checks
> > > > like e.g.:
> > > > 
> > > > | meta iifname != eth0 accept
> > > > 
> > > > This rule will never match if there is no input interface (or it is not
> > > > known) which is not intuitive and, what's worse, breaks consistency of
> > > > iptables-nft with iptables-legacy.
> > > > 
> > > > Fix this by falling back to placing a value in dreg which never matches
> > > > (avoiding accidental matches):
> > > > 
> > > > {I,O}IF:
> > > > 	Use invalid ifindex value zero.
> > > > 
> > > > {BRI_,}{I,O}IFNAME, {I,O}IFKIND:
> > > > 	Use an empty string which is neither a valid interface name nor
> > > > 	kind.
> > > > 
> > > > {I,O}IFTYPE:
> > > > 	Use ARPHRD_VOID (0xFFFF).
> > > 
> > > What could it be done with?
> > > 
> > > NFT_META_BRI_IIFPVID
> > > NFT_META_BRI_IIFPVPROTO
> > > 
> > > Those will still not work for
> > > 
> > >         meta ibrpvid != 40
> > > 
> > > if interface is not available.
> > > 
> > > For VPROTO probably it's possible. I don't have a solution for
> > > IIFPVID.
> > 
> > VLAN IDs 0 and 4095 are reserved, we could use those. I refrained from
> > changing bridge VLAN matches because of IIFPVPROTO, no idea if there's
> > an illegal value we could use for that. If you have an idea, I'm all for
> > it. :)
> 
> I think we can add something like:
> 
>         NFT_META_BRI_IIFVLAN
> 
> just to check for br_vlan_enabled(), from userspace we can check for
> exists/missing as a boolean, so we don't have to worry on assuming an
> unused value for things like this. This can be added in the next
> release cycle.

Adding existence checks where missing is indeed a good idea, but doesn't
quite solve the problem we're facing here. :)

[...]
> These ones are missing:
> 
>         NFT_META_IIFGROUP
>         NFT_META_OIFGROUP
> 
> For these two, the default group (0) should be fine since every
> interface is falling under this category by default.
> 
> I can squash this small patch to this one and push it one.

My problem with these "sane defaults" is that we may cause inconsistent
behaviour in rulesets: In prerouting, 'meta oifgroup 0' will match no
matter which interface the packet will be routed to. Yes, prerouting
implies there is no output interface (yet), but I consider this an
implementation detail and there will likely be cases where it is not as
easy to spot why something can't work.

Cheers, Phil
