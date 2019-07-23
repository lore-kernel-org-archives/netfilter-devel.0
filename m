Return-Path: <SRS0=NVo7=VU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB47C76186
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 18:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66F2216C8
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Jul 2019 18:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733158AbfGWSie (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 14:38:34 -0400
Received: from mail.us.es ([193.147.175.20]:57794 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731007AbfGWSie (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 14:38:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9E88FF2629
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 20:38:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D6FBA59B
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2019 20:38:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8318F58F; Tue, 23 Jul 2019 20:38:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7A001DA732;
        Tue, 23 Jul 2019 20:38:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 23 Jul 2019 20:38:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 237244265A32;
        Tue, 23 Jul 2019 20:38:28 +0200 (CEST)
Date:   Tue, 23 Jul 2019 20:38:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fwestpha@redhat.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 1/2] net: nf_tables: Make nft_meta expression more
 robust
Message-ID: <20190723183826.v66wxkfckb2oakpl@salvia>
References: <20190719123921.1249-1-phil@nwl.cc>
 <20190719163521.oozthobj33ejswrx@salvia>
 <20190720151502.GD32501@orbyte.nwl.cc>
 <20190722195321.uf2r5lp46bvslvtd@salvia>
 <20190723150644.GO22661@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723150644.GO22661@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 23, 2019 at 05:06:44PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Mon, Jul 22, 2019 at 09:53:21PM +0200, Pablo Neira Ayuso wrote:
> > On Sat, Jul 20, 2019 at 05:15:02PM +0200, Phil Sutter wrote:
> > > Hi,
> > > 
> > > On Fri, Jul 19, 2019 at 06:35:21PM +0200, Pablo Neira Ayuso wrote:
> > > > On Fri, Jul 19, 2019 at 02:39:20PM +0200, Phil Sutter wrote:
> > > > > nft_meta_get_eval()'s tendency to bail out setting NFT_BREAK verdict in
> > > > > situations where required data is missing breaks inverted checks
> > > > > like e.g.:
> > > > > 
> > > > > | meta iifname != eth0 accept
> > > > > 
> > > > > This rule will never match if there is no input interface (or it is not
> > > > > known) which is not intuitive and, what's worse, breaks consistency of
> > > > > iptables-nft with iptables-legacy.
> > > > > 
> > > > > Fix this by falling back to placing a value in dreg which never matches
> > > > > (avoiding accidental matches):
> > > > > 
> > > > > {I,O}IF:
> > > > > 	Use invalid ifindex value zero.
> > > > > 
> > > > > {BRI_,}{I,O}IFNAME, {I,O}IFKIND:
> > > > > 	Use an empty string which is neither a valid interface name nor
> > > > > 	kind.
> > > > > 
> > > > > {I,O}IFTYPE:
> > > > > 	Use ARPHRD_VOID (0xFFFF).
> > > > 
> > > > What could it be done with?
> > > > 
> > > > NFT_META_BRI_IIFPVID
> > > > NFT_META_BRI_IIFPVPROTO
> > > > 
> > > > Those will still not work for
> > > > 
> > > >         meta ibrpvid != 40
> > > > 
> > > > if interface is not available.
> > > > 
> > > > For VPROTO probably it's possible. I don't have a solution for
> > > > IIFPVID.
> > > 
> > > VLAN IDs 0 and 4095 are reserved, we could use those. I refrained from
> > > changing bridge VLAN matches because of IIFPVPROTO, no idea if there's
> > > an illegal value we could use for that. If you have an idea, I'm all for
> > > it. :)
> > 
> > I think we can add something like:
> > 
> >         NFT_META_BRI_IIFVLAN
> > 
> > just to check for br_vlan_enabled(), from userspace we can check for
> > exists/missing as a boolean, so we don't have to worry on assuming an
> > unused value for things like this. This can be added in the next
> > release cycle.
> 
> Adding existence checks where missing is indeed a good idea, but doesn't
> quite solve the problem we're facing here. :)

I'm not proposing to use this approach for _every key_. For this one
specifically I think it's meaningful to have a NFT_META_BRI_IIFVLAN
since vlan is an optional configuration.

> [...]
> > These ones are missing:
> > 
> >         NFT_META_IIFGROUP
> >         NFT_META_OIFGROUP
> > 
> > For these two, the default group (0) should be fine since every
> > interface is falling under this category by default.
> > 
> > I can squash this small patch to this one and push it one.
> 
> My problem with these "sane defaults" is that we may cause inconsistent
> behaviour in rulesets: In prerouting, 'meta oifgroup 0' will match no
> matter which interface the packet will be routed to. Yes, prerouting
> implies there is no output interface (yet), but I consider this an
> implementation detail and there will likely be cases where it is not as
> easy to spot why something can't work.

I think disallowing 'meta oifgroup 0' from prerouting (and the input
path in general) is fine from the control plane configuration, but you
know Florian disagrees with this. Probably this can be left as is for
IIFNAME and OIFNAME, which as used by iptables-nft for compatibility
with legacy. For new keys, check for invalid configuration I would
argue that is fine.

But let's wait for Florian to say what he thinks :-)
