From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 13:46:26 +0100
Message-ID: <20160302124626.GA5243@salvia>
References: <20160301204042.GA15382@sonyv>
 <20160302114611.GA3008@salvia>
 <20160302121033.GA4348@breakpoint.cc>
 <20160302123339.GA4930@salvia>
 <20160302123738.GB4348@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45622 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbcCBMqb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 07:46:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B035980FF
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 13:46:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A18F2DA8FA
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 13:46:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 57DECDA39D
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 13:46:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160302123738.GB4348@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 01:37:38PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> [ nft meta random ]
> 
> > I'm fine with the probability scaling, but I think we should keep this
> > consistent with other selectors, so I would use lt and gte instead
> > here.
> > 
> > We can potentially use ranges here too and other available operations
> > such as prefixes (although this one I don't know use case for this).
> 
> Ok, so just to clarify.  You want me to submit v2 of nft meta random
> patch set that turns:
> 
> meta random value
> into
> meta random lt value
> 
> ... and ...
> 
> meta random ne value
> into
> meta random ge value
> 
> Is that correct?

I think so, so this becomes consistent with other selectors that we
have. Does this sound reasonable to you?
