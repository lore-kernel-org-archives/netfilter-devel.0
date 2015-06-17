From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] parser_bison: allow to use mark as datatype for maps
 and sets
Date: Wed, 17 Jun 2015 12:33:03 +0200
Message-ID: <20150617103303.GA3365@salvia>
References: <1434469933-6402-1-git-send-email-pablo@netfilter.org>
 <20150616154924.GL20951@acer.localdomain>
 <20150616155732.GA7067@salvia>
 <CAO0uZ+-k7FVjpforphDBLEnLEpxMj8uSnQWOTeFvVzSRonWpUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Miroslav Kratochvil <exa.exa@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59007 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbbFQK1n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jun 2015 06:27:43 -0400
Content-Disposition: inline
In-Reply-To: <CAO0uZ+-k7FVjpforphDBLEnLEpxMj8uSnQWOTeFvVzSRonWpUg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 17, 2015 at 10:29:30AM +0200, Miroslav Kratochvil wrote:
> > > Yes, I think this is preferrable since the mark type can be used for
> > > things besides packet marking, f.i. conntracks.
> >
> > Ok, then I'll push this patch, thanks!
> 
> 
> Great, marking by named map is now perfectly usuable.
> 
> One last (cosmetic reminder) thing, could the last occurence of
> "packetmark" type name in documentation also be replaced with "mark",
> for consistency?
> 
> in doc/nft.xml, lines 988, 1887.

Would you send us a Signed-off-by patch that I can apply via git am?

Thanks.
