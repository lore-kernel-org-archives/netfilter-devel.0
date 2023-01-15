Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF657C46467
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Jan 2023 22:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjAOWHw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Jan 2023 17:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjAOWHv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Jan 2023 17:07:51 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0571B548
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Jan 2023 14:07:46 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pHBAG-00047R-4u; Sun, 15 Jan 2023 23:07:44 +0100
Date:   Sun, 15 Jan 2023 23:07:44 +0100
From:   Phil Sutter <phil@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ANNOUNCE] iptables 1.8.9 release
Message-ID: <Y8R5MGQTFOn2DxTb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <Y7/s83d8D0z1QYt1@orbyte.nwl.cc>
 <e0357e53-8eda-9d9d-d1d6-4f8669759181@netfilter.org>
 <Y8Onpi8LqsWIX06f@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8Onpi8LqsWIX06f@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi!

On Sun, Jan 15, 2023 at 08:13:42AM +0100, Pablo Neira Ayuso wrote:
> On Sat, Jan 14, 2023 at 10:18:56PM +0100, Arturo Borrero Gonzalez wrote:
> > On 1/12/23 12:20, Phil Sutter wrote:
> > > Hi!
> > > 
> > > The Netfilter project proudly presents:
> > > 
> > >          iptables 1.8.9
> > > 
> > 
> > Hi Phil,
> > 
> > thanks for the release!
> > 
> > I see the tarball includes now a etc/xtables.conf file [0]. Could you please clarify the expected usage of this file?
> > 
> > Do we intend users to have this in their systems? If so, what for.
> > It appears to be in nftables native format, so who or what mechanisms would be responsible for reading it in a system that
> > has no nftables installed?
> > 
> > Perhaps the file is only useful for development purposes?
> 
> I think this file just slipped through while enabling `make distcheck'
> in a recent update, but let's wait for Phil to confirm this.

Oh, I wasn't aware this file wasn't installed prior to my patches
enabling 'make dist'. This explains why Jan came up with a patch to
prevent installation. %)

So yes, this config is a leftover from an early approach of supporting a
configurable iptables-nft chain layout which never gained traction. One
should just ignore it, sorry for the mess this causes.

Cheers, Phil
