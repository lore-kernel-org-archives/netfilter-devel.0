From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables] goto vs jump documentation
Date: Tue, 24 Nov 2015 17:02:12 +0000
Message-ID: <20151124170212.GA26941@macbook.localdomain>
References: <CAOkSjBiEzMwQoKfZ-SbptULO_NHZUgoO=KELDO-2CNEFKiof_w@mail.gmail.com>
 <20151124155635.GA13734@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:47497 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753554AbbKXRCW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 12:02:22 -0500
Content-Disposition: inline
In-Reply-To: <20151124155635.GA13734@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Pablo Neira Ayuso wrote:
> On Fri, Nov 20, 2015 at 02:45:31PM +0100, Arturo Borrero Gonzalez wrote:
> > Hi,
> > 
> > I've documented the difference between goto and jump in the nftables wiki [0].
> > 
> > Let me know if that's OK.
> 
> This looks good.
> 
> I'd suggest you place this into add this into a new article:
> 
> "Going to chain"
> 
> just after the existing "Jumping to chain". No changes in the content,
> I like that you use the jump concept as reference to explain this new
> one.

Really in a new article? The difference is not really about the jumping,
both do that, the difference is in returning. "Going to" sounds a
unfamiliar to me.
