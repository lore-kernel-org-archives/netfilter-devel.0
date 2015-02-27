From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] ebtables: Cache a copy of the v3.16 kernel headers in
 the ebtables tree
Date: Fri, 27 Feb 2015 12:23:49 +0100
Message-ID: <20150227112349.GA3407@salvia>
References: <54EF4BE4.4020002@codethink.co.uk>
 <20150226193054.GA5142@salvia>
 <54EFA21A.5090507@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pedro Alvarez <pedro.alvarez@codethink.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37011 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbbB0LUQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Feb 2015 06:20:16 -0500
Content-Disposition: inline
In-Reply-To: <54EFA21A.5090507@codethink.co.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 26, 2015 at 10:45:46PM +0000, Pedro Alvarez wrote:
> On 26/02/15 19:30, Pablo Neira Ayuso wrote:
> >On Thu, Feb 26, 2015 at 04:37:56PM +0000, Pedro Alvarez wrote:
> >>
> >>I decided to go for 2, and here is the patch:
> >
> >Yes, we have to go 2 as we did in iptables.
> >
> >>   Repo: git://git.baserock.org/delta/ebtables.git
> >>   Branch: baserock/pedroalvarez/ebt_ulog-fix
> >>   Sha1: 13747a56890cc710b2b4d420edc03a6c2714f40e
> >>
> >>NOTE: I didn't want to send a diff, since it would be big and nonsense, but I
> >>can do that if needed.
> >
> >OK, but it should be sufficient to include netfilter_bridge headers
> >for each supported extension, including types.h and filter.h as we do
> >in iptables.
> 
> Hi Pablo, thanks for taking a look at my patch.
> 
> Yeah, you are right, here is the second version of the patch [1]
> following your suggestion.
> 
> Repo: git://git.baserock.org/delta/ebtables.git
> Branch: baserock/pedroalvarez/ebt_ulog-fix-v2
> Sha1: 04d387f29184907dd61f7e6b23b0dd9ef3913c50

Please, remove filter.h, we don't need it for ebtables.

It would be good if you can send the patch to
netfilter-devel@vger.kernel.org, it's ~25 KBytes which sounds
reasonable size.

Thanks.
