From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] parser: simplify monitor command parsing
Date: Wed, 17 Sep 2014 10:01:15 +0200
Message-ID: <20140917080115.GB10380@acer.localdomain>
References: <1410939907-10180-1-git-send-email-kaber@trash.net>
 <CAOkSjBgHZ4aG7Qog1pOtCHS=YDmLiJi11eXPxdY20oDNgPE1bA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53637 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaIQIBT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:01:19 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBgHZ4aG7Qog1pOtCHS=YDmLiJi11eXPxdY20oDNgPE1bA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 17, 2014 at 09:52:11AM +0200, Arturo Borrero Gonzalez wrote:
> On 17 September 2014 09:45, Patrick McHardy <kaber@trash.net> wrote:
> > Add tokens for "new" and "destroy". Split up the monitor flags into an
> > event and an object to avoid lots of duplicated code.
> >
> > Signed-off-by: Patrick McHardy <kaber@trash.net>
> > ---
> 
> I think the 'new' keyword may clash with 'ct new', don't you?. That's
> why Pablo did the parser that way.

Right. The split into event and object still saves a lot of code, I'll
add back the strcmp if I can't think of a nicer way to fix this.

I'm working on command line completion based on the bison grammar, so
I'd prefer to only use strings for identifiers, not for keywords.
