Return-Path: <SRS0=TL01=WX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD458C3A5A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 12:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA1C02077B
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 12:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfH0Mro (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 08:47:44 -0400
Received: from correo.us.es ([193.147.175.20]:32828 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbfH0Mro (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 08:47:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 77AA61878AE
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2019 14:47:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B3B3DA8E8
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2019 14:47:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 60EB9DA801; Tue, 27 Aug 2019 14:47:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B106DA7B6;
        Tue, 27 Aug 2019 14:47:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 27 Aug 2019 14:47:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 38E8F4265A5A;
        Tue, 27 Aug 2019 14:47:38 +0200 (CEST)
Date:   Tue, 27 Aug 2019 14:47:39 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 14/14] nft: bridge: Rudimental among extension
 support
Message-ID: <20190827124739.lbbsvvdi2uxmvisc@salvia>
References: <20190821092602.16292-1-phil@nwl.cc>
 <20190821092602.16292-15-phil@nwl.cc>
 <20190827104919.r3p3giv6hmnzmcbr@salvia>
 <20190827113526.GA937@orbyte.nwl.cc>
 <20190827122111.yj6j54l7mfygxov5@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827122111.yj6j54l7mfygxov5@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 27, 2019 at 02:21:11PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 27, 2019 at 01:35:26PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Tue, Aug 27, 2019 at 12:49:19PM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Aug 21, 2019 at 11:26:02AM +0200, Phil Sutter wrote:
> > > [...]
> > > > +/* Make sure previous payload expression(s) is/are consistent and extract if
> > > > + * matching on source or destination address and if matching on MAC and IP or
> > > > + * only MAC address. */
> > > > +static int lookup_analyze_payloads(const struct nft_xt_ctx *ctx,
> > > > +				   bool *dst, bool *ip)
> > > > +{
> > > > +	int val, val2 = -1;
> > > > +
> > > > +	if (ctx->flags & NFT_XT_CTX_PREV_PAYLOAD) {
> > > 
> > > Can you probably achieve this by storing protocol context?
> > > 
> > > Something like storing the current network base in the nft_xt_ctx
> > > structure, rather than the last payload that you have seen.
> > > 
> > > From the context you annotate, then among will find the information
> > > that it needs in the context.
> > > 
> > > We can reuse this context later on to generate native tcp/udp/etc.
> > > matching.
> > 
> > Sorry, I don't understand your approach. With protocol context as it is
> > used in nftables in mind, I don't see how that applies here. For among
> > match, we simply have a payload match for MAC address and optionally a
> > second one for IP address. These are not related apart from the fact
> > that among allows to match only source or only destination addresses.
> > The problem lookup_analyze_payloads() solves is:
> > 
> > 1) Are we matching MAC only or MAC and IP?
> > 2) Are we matching source or destination?
> > 3) Is everything consistent, i.e., no IP match without MAC one and no
> >    mixed source/destination matches?

Ok, so you are storing the last two payload expressions in the
nft_xt_ctx object. Looks fine to me.

We might need to revisit this when supporting for native payload
matching. The existing context infrastructure might not be enough if
we need to express more complex things. But that can be done later on.
