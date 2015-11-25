From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables] goto vs jump documentation
Date: Wed, 25 Nov 2015 13:31:16 +0000
Message-ID: <20151125133116.GC18449@macbook.localdomain>
References: <CAOkSjBiEzMwQoKfZ-SbptULO_NHZUgoO=KELDO-2CNEFKiof_w@mail.gmail.com>
 <20151124155635.GA13734@salvia>
 <20151124170212.GA26941@macbook.localdomain>
 <alpine.LSU.2.20.1511251413300.5641@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:57146 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750699AbbKYNbV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 08:31:21 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1511251413300.5641@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.11, Jan Engelhardt wrote:
> 
> On Tuesday 2015-11-24 18:02, Patrick McHardy wrote:
> >On 24.11, Pablo Neira Ayuso wrote:
> >> On Fri, Nov 20, 2015 at 02:45:31PM +0100, Arturo Borrero Gonzalez wrote:
> >> > Hi,
> >> > 
> >> > I've documented the difference between goto and jump in the nftables wiki [0].
> >> > 
> >> > Let me know if that's OK.
> >> 
> >> This looks good.
> >> 
> >> I'd suggest you place this into add this into a new article:
> >> 
> >> "Going to chain"
> >> 
> >> just after the existing "Jumping to chain". No changes in the content,
> >> I like that you use the jump concept as reference to explain this new
> >> one.
> >
> >Really in a new article? The difference is not really about the jumping,
> >both do that, the difference is in returning. "Going to" sounds a
> >unfamiliar to me.
> 
> I concur, in particular because of the curious choice of keywords once 
> upon many moons. I would even suggest to name the section title 
> "Invoking other chains" so as to avoid using terms with 
> implementation-specific meaning before they are explained. Think someone 
> skimming through the TOC..

I agree, that's way better.
