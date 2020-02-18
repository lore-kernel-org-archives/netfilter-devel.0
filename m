Return-Path: <SRS0=aYEw=4G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73F0C34026
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 15:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4C3E22527
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Feb 2020 15:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgBRPmw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Feb 2020 10:42:52 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:49898 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgBRPmw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 10:42:52 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j451O-000703-89; Tue, 18 Feb 2020 16:42:50 +0100
Date:   Tue, 18 Feb 2020 16:42:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [iptables PATCH] ebtables: among: Support mixed MAC and MAC/IP
 entries
Message-ID: <20200218154250.GB20005@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>
References: <20200214104910.21196-1-phil@nwl.cc>
 <20200218135651.x6el7lciqsfi32kw@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218135651.x6el7lciqsfi32kw@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Feb 18, 2020 at 02:56:51PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Feb 14, 2020 at 11:49:10AM +0100, Phil Sutter wrote:
> > Powered by Stefano's support for concatenated ranges, a full among match
> > replacement can be implemented. The trick is to add MAC-only elements as
> > a concatenation of MAC and zero-length prefix, i.e. a range from
> > 0.0.0.0 till 255.255.255.255.
> > 
> > Although not quite needed, detection of pure MAC-only matches is left in
> > place. For those, no implicit 'meta protocol' match is added (which is
> > required otherwise at least to keep nft output correct) and no concat
> > type is used for the set.
> 
> I'm glad to see this, thanks Phil.

You're welcome. I was surprised how quick this was to implement. :)

> Is ebt among is now complete?

Yes, I think we're feature-complete with ebtables-legacy now. The only
question would be whether we want to support IPv6 as well, but I don't
think it's worth the effort.

Cheers, Phil
