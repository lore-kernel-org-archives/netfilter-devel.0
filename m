From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: TEE broken in 3.6
Date: Wed, 17 Oct 2012 10:15:51 +0200
Message-ID: <20121017081551.GA12998@1984>
References: <20121016211319.3f07a7e3@goldlack.enda.eu>
 <1350417618.3954.1494.camel@edumazet-glaptop>
 <20121017094543.2ddb0397@goldlack.enda.eu>
 <1350460131.26103.68.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Torsten Luettgert <ml-netfilter@enda.eu>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55015 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914Ab2JQIP6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:15:58 -0400
Content-Disposition: inline
In-Reply-To: <1350460131.26103.68.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 17, 2012 at 09:48:51AM +0200, Eric Dumazet wrote:
> On Wed, 2012-10-17 at 09:45 +0200, Torsten Luettgert wrote:
> > On Tue, 16 Oct 2012 22:00:18 +0200
> > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > 
> > > Could you try latest tree, with the following patch ?
> > 
> > Yeah, that works.
> > 
> > I'm still a bit sad, though, since I'll have to wait for 3.7 now (no
> > FLOWI_FLAG_KNOWN_NH in 3.6.*), or is there any solution for those "old"
> > kernels, too?
> > 
> > Regards,
> > Torsten
> 
> I believe its stable material, it will reach 3.6.3 or 3.6.4 dont worry.

Sure. I'll pass this to -stable once it hits Linus' tree. It may take
a while though.
