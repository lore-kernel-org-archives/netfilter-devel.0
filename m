Return-Path: <SRS0=TL01=WX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6B2C3A5A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 10:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 540D5204EC
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 10:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfH0Kjj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 06:39:39 -0400
Received: from correo.us.es ([193.147.175.20]:45752 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfH0Kji (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 06:39:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A690B67BA9
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2019 12:39:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9732AFB362
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2019 12:39:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8CE71CA0F3; Tue, 27 Aug 2019 12:39:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8870CD2B1D;
        Tue, 27 Aug 2019 12:39:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 27 Aug 2019 12:39:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 62CC742EE396;
        Tue, 27 Aug 2019 12:39:33 +0200 (CEST)
Date:   Tue, 27 Aug 2019 12:39:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 14/14] nft: bridge: Rudimental among extension
 support
Message-ID: <20190827103934.26m7eponuwseb43i@salvia>
References: <20190821092602.16292-1-phil@nwl.cc>
 <20190821092602.16292-15-phil@nwl.cc>
 <20190824165333.l4qyhk3fyzglstmp@salvia>
 <20190826154006.GD14469@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826154006.GD14469@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 26, 2019 at 05:40:06PM +0200, Phil Sutter wrote:
> On Sat, Aug 24, 2019 at 06:53:34PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Aug 21, 2019 at 11:26:02AM +0200, Phil Sutter wrote:
> > [...]
> > > +/* XXX: move this into libnftnl, replacing nftnl_set_lookup() */
> > > +static struct nftnl_set *nft_set_byname(struct nft_handle *h,
> > > +					const char *table, const char *set)
> > 
> > Probably extend libnftnl to allow to take a pointer to a nftnl_set
> > object, as an alternative to the set name? The idea is that this
> > set object now belongs to the lookup extension, so this extension will
> > take care of releasing it from the destroy path.
> > 
> > Then, the lookup extension will have a pointer to the anonymous set so
> > you could then skip the cache code (and all the updates to have access
> > to it).
> 
> Sounds like a nice approach! So I would add a new
> NFTNL_EXPR_LOOKUP_SET_PTR to link the set and introduce
> NFTA_LOOKUP_ANON_SET (or so) which starts a nested attribute filled
> simply by nftnl_set_nlmsg_build_payload()? Kernel code would have to be
> extended accordingly, of course.

No need for kernel code update.

> Seems like I can't reuse nftnl_set_nlmsg_parse() since
> mnl_attr_parse_nested() would have to be called. But I guess outsourcing
> the attribute handling from the further and introducing a second wrapper
> would do.

My proposal is to add NFTNL_EXPR_LOOKUP_SET_PTR, that allows you to
pass a pointer to the set, if that makes this simpler for you.

This would be an alias of the SET_ID, from the build path it would
use. You would still need to add the set command.

But I think you will end up needing the set cache anyway from the
netlink dump path anyway.

I'm re-evaluating, and I think your patchset is a good approach.
