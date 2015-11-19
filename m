From: Florian Westphal <fw@strlen.de>
Subject: Re: Extending connmark to 64 bits
Date: Thu, 19 Nov 2015 22:32:47 +0100
Message-ID: <20151119213247.GA25336@breakpoint.cc>
References: <1447802062.16644.12.camel@mattb-dl>
 <20151119030011.GA6710@breakpoint.cc>
 <1447904116.12623.2.camel@mattb-dl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "fw@strlen.de" <fw@strlen.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Matt Bennett <Matt.Bennett@alliedtelesis.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49986 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758978AbbKSVcu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Nov 2015 16:32:50 -0500
Content-Disposition: inline
In-Reply-To: <1447904116.12623.2.camel@mattb-dl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Matt Bennett <Matt.Bennett@alliedtelesis.co.nz> wrote:
> On Thu, 2015-11-19 at 04:00 +0100, Florian Westphal wrote:
> > Matt Bennett <Matt.Bennett@alliedtelesis.co.nz> wrote:
> > > Currently we have a number of router features making use of connection
> > > tracking. As such we now require more than the 32 bits connmark
> > > currently has. Our first inclination is to extend this field to 64 bits
> > > and update related areas of code appropriately.
> > > 
> > > The major question we have is whether there is a reason this field is 32
> > > bits (performance reasons or other)?
> > 
> > Its meant to align with skb->mark.
> 
> I thought that could be the case. Probably the wrong mailing-list to be
> asking this on but is increasing the number of bits for the skb->mark
> then a possibility?

Increase sk_buff size?  Doubtful.

> The number of bits available for marking becomes the
> limiting factor when you have a number of applications needing to mark
> packets.

Now I am confused.  You mentioned connmark.

Are you marking packets or connections?

Why are 2**32 marks not sufficient?
